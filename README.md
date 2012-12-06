# sequenz

[![Build Status](https://travis-ci.org/snd/sequenz.png)](https://travis-ci.org/snd/sequenz)

sequenz composes connect middleware for nodejs

### install

```
npm install sequenz
```

### use

given that `middlewares` is an array of middlewares

```coffeescript
sequenz = require 'sequenz'

sequenz middlewares
```
returns a new middleware, which will call all `middlewares` in order.

you can also call sequenz with the individual middlewares as arguments:

```coffeescript
sequenz middleware1, middleware2, middleware3
```

### example

```coffeescript
http = require 'http'
connect = require 'connect'
sequenz = require 'sequenz'
Passage = require 'passage'

router = new Passage

router.get '/', (req, res, next) ->
    res.end 'landing page'

router.get '/about', (req, res, next) ->
    res.end 'about page'

server = http.createServer sequenz [
    (req, res, next) ->
        console.log 'i am a middleware that is called first on every request'
        next()
    connect.favicon()
    connect.bodyParser()
    connect.cookieParser()
    connect.query()
    router.middleware
    (req, res, next) ->
        res.writeHead 404
        res.end 'not found'
]

server.listen 8080
```

### license: MIT
