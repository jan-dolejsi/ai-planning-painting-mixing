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
app.get('/da', function(req, res) {
    const filecontent = fs.readFileSync('data.json')
    const data=JSON.parse(filecontent);
    res.render('index.html', data);
});

app.get('/d',(req, res) => res.send('Hello World!'))

app.listen(port, () => console.log(`Example app listening on port ${port}!`))
