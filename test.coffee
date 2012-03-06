assert = require 'assert'

sequenz = require './lib/sequenz'

module.exports =
    'bind: fst is called before snd': (test) ->
        fst = (req, res, next) ->
            req.params.push 1
            next()

        snd = (req, res, next) ->
            req.params.push 2
            next()

        check = (req, res, next) ->
            test.equals req.params[0], 1
            test.equals req.params[1], 2
            next()

        f = sequenz.bind (sequenz.bind fst, snd), check

        f {params: []}, {}, test.done

    'sequence: middleware is called in order': (test) ->
        middleware = []

        middleware.push (req, res, next) ->
            req.params.push 1
            next()

        middleware.push (req, res, next) ->
            req.params.push 2
            next()

        middleware.push (req, res, next) ->
            req.params.push 3
            next()

        middleware.push (req, res, next) ->
            test.equals req.params[0], 1
            test.equals req.params[1], 2
            test.equals req.params[2], 3
            next()

        f = sequenz.sequence middleware

        f {params: []}, {}, test.done

    'bind: fst has to be a function': (test) ->
        test.throws -> sequenz.bind {}, sequenz.nop
        test.done()

    'bind: snd has to be a function': (test) ->
        test.throws -> sequenz.bind sequenz.nop, {}
        test.done()
