# sequenz

[![Build Status](https://travis-ci.org/snd/sequenz.png)](https://travis-ci.org/snd/sequenz)

sequenz composes connect middleware for nodejs

### install

```
npm install sequenz
```

**or**

put this line in the dependencies section of your `package.json`:

```
"sequenz": "1.0.7"
```

then run:

```
npm install
```

### use

the sequenz module exports a single function which
takes either an array of middlewares or any number of middlewares
as arguments and returns a new middleware that will call the
middlewares in order.

### example

the example uses some [connect](http://www.senchalabs.org/connect/) middleware and [passage](https://github.com/snd/passage) for routing.

```javascript
var http = require('http');
var connect = require('connect');
var sequenz = require('sequenz');
var passage = require('passage');

var routes = sequenz(
    passage.get('/', function(req, res, next) {
        res.end('landing page');
    }),
    passage.get('/about', function(req, res, next) {
        res.end('about page');
    })
);

var middleware = sequenz(
    function(req, res, next) {
        console.log('i am a middleware that is called first on every request');
        next();
    },
    connect.favicon(),
    connect.bodyParser(),
    connect.cookieParser(),
    connect.query(),
    routes,
    function(req, res, next) {
        res.statusCode = 404;
        res.end('not found');
    }
);

var server = http.createServer(middleware);

server.listen(8080);
```

### license: MIT
