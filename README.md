# sequenz

[![Build Status](https://travis-ci.org/snd/sequenz.png)](https://travis-ci.org/snd/sequenz)

sequenz composes connect middleware for nodejs

**sequenz makes a single middleware from multiple middlewares**

### install

```
npm install sequenz
```

**or**

put this line in the dependencies section of your `package.json`:

```
"sequenz": "1.0.9"
```

then run:

```
npm install
```

### use

a middleware is a function of three arguments:
the [request object](http://nodejs.org/api/http.html#http_http_incomingmessage) `req` from the nodejs http server,
the [response object](http://nodejs.org/api/http.html#http_class_http_serverresponse)`res` from the nodejs http server
and a callback `next`.
middleware handles the request and usually modifies the response.
if a middleware doesn't end the request it should call `next` to give control
to the next middleware.

the sequenz module exports a single function.
that function either takes a single array of middlewares or any number of middlewares
as separate arguments.
it returns a new middleware that will call those middlewares in order.

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
