const express = require('express');
const nunjucks = require('nunjucks');
const fs = require('fs');
const request = require("request");

const app = express(); 
const port = 3000; // default port

// configure where nunjucks looks for templates
nunjucks.configure('views', {
    autoescape: true,
    express: app
});

app.set('view engine', 'html');

app.get('/', function (req, res) {
    const caseName = req.query.case || 'defaults.json';
    const defaults = fs.readFileSync(caseName);
    const defaultsJson = JSON.parse(defaults);
    var timeZoneOffset = (new Date()).getTimezoneOffset() * 60000; //offset in milliseconds
    defaultsJson["jobStart"] = new Date(Date.now() - timeZoneOffset).toISOString().slice(0, -1)
    res.render('index.html', { inputs: defaultsJson, solution: { plan: [] } });
});

app.use(express.static('views')); // this is how express serves the 'style.css'

app.get('/solution', async function (req, res) {
    var formInputs = {
        "case": req.query.case,
        "problem": req.query.case.replace(/[^\w-]/g, '_'), // sanitize user input
        "rooms": parseInt(req.query.rooms),
        "layers": parseInt(req.query.layers),
        "time_mix": splitCommaSeparatedValues(req.query.time_mix),
        "time_paint": splitCommaSeparatedValues(req.query.time_paint),
        "disposable_brush": req.query.disposable_brush,
        "time_clean": parseFloat(req.query.time_clean),
        "mixers": parseInt(req.query.mixers),
        "jobStart": req.query.jobStart
    };

    let planSteps = [];
    try {
        planSteps = await callPlanner(formInputs);
        // const planFileContent = fs.readFileSync('plan.json')
        // const plan = JSON.parse(planFileContent);
        const plan = { "plan": planSteps };

        res.render('index.html', { inputs: formInputs, solution: plan });
    }
    catch (err) {
        console.log(err);
        res.send(err.message || err);
        res.end();
    }
});

app.listen(port, () => console.log(`Planning app listening on port ${port}!`))

async function callPlanner(inputs) {

    const requestBody = createRequest(inputs);

    const generatedPlanSteps = await new Promise((resolve, reject) => {
        request.post({
            url: "http://localhost:8087/solve?enableSteepestAscent=true&enableEarliestApplicability=true&stateMemory=StateDomination&",
            body: requestBody, json: true, timeout: 60000
        },
            (error, httpResponse, responseBody) => {
                if (error) {
                    console.dir(error);
                    reject(error);
                    return;
                }
                if (httpResponse.statusCode > 220) {
                    console.log('Status code: ' + httpResponse.statusCode);
                    reject('Status code: ' + httpResponse.statusCode);
                    return;
                }
                if (responseBody["status"] !== "ok") {
                    console.log(responseBody["result"]["error"]);
                    reject(responseBody["result"]["error"]);
                    return;
                }
                else {
                    const planSteps = responseBody["result"]["plan"];
                    resolve(planSteps);
                    return;
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
 * @returns {number[]} list of values
 */
function splitCommaSeparatedValues(valuesCsv) {
    return valuesCsv.split(',')
        .map(valueAsString => valueAsString.trim()) // trim extra spaces
        .map(valueAsString => Number.parseFloat(valueAsString)); // turn to number
}