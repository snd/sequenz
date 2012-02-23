_ = require 'underscore'

module.exports = sequenz = {}

# nop middleware: does nothing
sequenz.nop = (req, res, next) -> next()

# combine two middlewares to one middleware which runs them in order
sequenz.bind = (fst, snd) ->
    throw new TypeError "fst is not a function, (#{fst})" if not _.isFunction fst
    throw new TypeError "snd is not a function, (#{snd})" if not _.isFunction snd
    (req, res, next) -> fst req, res, -> snd req, res, next

# make a middleware usable directly with `http.createServer` by making `next`
# optional
sequenz.decorate = (middleware) ->
    (req, res, next = ->) -> middleware req, res, next

# combine an array of middlewares to one middleware which runs them in order
sequenz.sequence = (middleware) -> _.foldl middleware, sequenz.bind, sequenz.nop
