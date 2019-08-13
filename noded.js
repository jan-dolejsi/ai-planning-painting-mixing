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
        "time_mix": req.query.time_mix,
        "time_paint": req.query.time_paint,
        "self_clean": req.query.self_clean,
        "mixers": req.query.mixers
    };
    res.render('index.html', formInputs);
});

app.get('/d',(req, res) => res.send('Hello World!'))

app.listen(port, () => console.log(`Example app listening on port ${port}!`))
