const express = require('express')
const nunjucks = require('nunjucks')
const app = express()
const port = 3000
var fs = require('fs');

nunjucks.configure('views', {
    autoescape: true,
    express: app
});
app.set('view engine', 'html');

app.get('/', function(req, res) {
    const filecontent = fs.readFileSync('data.json')
    const data=JSON.parse(filecontent);
    res.render('index.html', { inputs: data, solution: {plan: []} });
});

app.use(express.static('views'));

app.get('/solution', function(req, res) {
    var formInputs = {
        "username": "You!",
        "rooms": req.query.rooms,
        "layers": req.query.layers,
        "time_mix": splitCommaSeparatedValues(req.query.time_mix),
        "time_paint": splitCommaSeparatedValues(req.query.time_paint),
        "self_clean": req.query.self_clean,
        "mixers": req.query.mixers, 
        "jobStarted": new Date()
    };

    // todo: instead of reading the plan from the plan.json static file, 
    // generate the real problem.pddl file using nunjucks.render(...) and call the solver
    // hints: 
    // https://mozilla.github.io/nunjucks/api.html#render

    var Request = require("request");
    let requestBody = {
        "domain": fs.readFileSync('mixing_paintingDomain.pddl').toString('utf8'),
        "problem": fs.readFileSync('problem_two_rooms.pddl').toString('utf8')
    };

    Request.post({ url: "http://solver.planning.domains/solve", 
        body: requestBody, json: true, timeout:60000 }, 
        (error, httpResponse, responseBody) => {
        if(error) {
            return console.dir(error);
        }
        if (httpResponse.statusCode > 220) {
            console.log('Status code: ' + httpResponse.statusCode);
        }
        console.log(JSON.parse(responseBody));
    });

    const planFileContent = fs.readFileSync('plan.json')
    const plan=JSON.parse(planFileContent);

    res.render('index.html', { inputs: formInputs, solution: plan});
});

app.get('/d',(req, res) => res.send('Hello World!'))

app.listen(port, () => console.log(`Example app listening on port ${port}!`))

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