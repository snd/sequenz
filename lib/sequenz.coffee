_ = require 'underscore'

module.exports = sequenz =

    # nop middleware: does nothing
    nop: (req, res, next) -> next()

    # combine two middlewares to one middleware which runs them in order
    bind: (fst, snd) ->
        if not (typeof fst is 'function')
            throw new TypeError "bind: fst is not a function, (#{fst})"
        if not (typeof snd is 'function')
            throw new TypeError "bind: snd is not a function, (#{snd})"
        (req, res, next) -> fst req, res, -> snd req, res, next

    # make a middleware usable directly with `http.createServer` by making `next`
    # optional
    decorate: (middleware) ->
        (req, res, next = ->) -> middleware req, res, next

    # combine an array of middlewares to one middleware which runs them in order
    sequence: (middlewares) -> _.reduce middlewares, sequenz.bind, sequenz.nop

    # take either an array or a variable argument list and return arguments array
    normalizeArguments: (args...) ->
        if args.length is 1 and _.isArray(args[0]) then args[0] else args
