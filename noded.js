const express = require('express')
const nunjucks = require('nunjucks')
const app = express()
const port = 3000
var fs = require('fs');
var request = require("request");

nunjucks.configure('views', {
    autoescape: true,
    express: app
});
app.set('view engine', 'html');

app.get('/', function (req, res) {
    const filecontent = fs.readFileSync('data.json')
    const data = JSON.parse(filecontent);
    res.render('index.html', { inputs: data, solution: { plan: [] } });
});

app.use(express.static('views'));

app.get('/solution', async function (req, res) {
    var formInputs = {
        "username": "from_ui",
        "rooms": parseInt(req.query.rooms),
        "layers": parseInt(req.query.layers),
        "time_mix": splitCommaSeparatedValues(req.query.time_mix),
        "time_paint": splitCommaSeparatedValues(req.query.time_paint),
        "self_clean": req.query.self_clean,
        "mixers": parseInt(req.query.mixers),
        "jobStarted": new Date()
    };

    let planSteps = [];
    try {
        planSteps = await callPlanner(formInputs);
    }
    catch (err) {
        console.log(err);
        res.write(err);
        res.end();
    }

    // const planFileContent = fs.readFileSync('plan.json')
    // const plan = JSON.parse(planFileContent);
    const plan = { "plan": planSteps };

    res.render('index.html', { inputs: formInputs, solution: plan });
});

app.get('/d', (req, res) => res.send('Hello World!'))

app.listen(port, () => console.log(`Example app listening on port ${port}!`))

async function callPlanner(inputs) {

    const requestBody = createRequest(inputs);

    const generatedPlanSteps = await new Promise((resolve, reject) => {
        request.post({
            url: "http://localhost:8087/solve",
            body: requestBody, json: true, timeout: 60000
        },
            (error, httpResponse, responseBody) => {
                if (error) {
                    console.dir(error);
                    reject(error);
                }
                if (httpResponse.statusCode > 220) {
                    console.log('Status code: ' + httpResponse.statusCode);
                    reject('Status code: ' + httpResponse.statusCode);
                }
                if (responseBody["status"] !== "ok") {
                    console.log(responseBody["result"]["error"]);
                    reject(responseBody["result"]["error"]);
                }
                else {
                    const planSteps = responseBody["result"]["plan"];
                    resolve(planSteps);
                }
            });
    });

    return generatedPlanSteps.map(step => transformPlanStep(step));
}

function transformPlanStep(step) {
    return {
        "time": step["time"],
        "action": step["name"].replace(/[\(\)]/g, ''),
        "duration": step["duration"]
    }
}

function createRequest(inputs) {
    const template = fs.readFileSync('mixing_paintingProblem.pddl').toString('utf8');
    const renderedPddl = nunjucks.renderString(template, {data: inputs});
    fs.writeFileSync('mixing_paintingProblem_rendered.pddl', renderedPddl, {encoding: 'utf8'});

    let requestBody = {
        "domain": fs.readFileSync('mixing_paintingDomain.pddl').toString('utf8'),
        "problem": renderedPddl
    };

    return requestBody;
}

/**
 * Splits the text by comma, trims, parses and returns as a list of numbers.
 * @param {string} valuesCsv comma separated
 * @returns {mumber[]} list of values
 */
function splitCommaSeparatedValues(valuesCsv) {
    return valuesCsv.split(',')
        .map(valueAsString => valueAsString.trim()) // trim extra spaces
        .map(valueAsString => Number.parseFloat(valueAsString)); // turn to number
}