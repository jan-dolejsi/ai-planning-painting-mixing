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
    res.render('index.html', data);
});

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