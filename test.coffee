sequenz = require './lib/sequenz'

module.exports =

    'bind':

        'fst is called before snd': (test) ->
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

        'fst has to be a function': (test) ->
            test.throws -> sequenz.bind {}, sequenz.nop
            test.done()

        'snd has to be a function': (test) ->
            test.throws -> sequenz.bind sequenz.nop, {}
            test.done()

    'sequence':

        'middleware is called in order': (test) ->
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

        'works with single middleware': (test) ->
            middleware = []

            middleware.push (req, res, next) -> next()

            f = sequenz.sequence middleware

            f {}, {}, test.done

    'normalizeArguments':

        'single array as argument': (test) ->
            test.deepEqual [1,2,3], sequenz.normalizeArguments [1,2,3]
            test.done()

        'no value as argument': (test) ->
            test.deepEqual [], sequenz.normalizeArguments()
            test.done()

        'single value as argument': (test) ->
            test.deepEqual [1], sequenz.normalizeArguments 1
            test.done()

        'multiple values as arguments': (test) ->
            test.deepEqual [1,2,3], sequenz.normalizeArguments 1, 2, 3
            test.done()
