isFunction = (obj) -> obj? and toString.call(obj) is '[object Function]'

module.exports = sequenz =

    # nop middleware: does nothing
    nop: (req, res, next) -> next()

    # combine two middlewares to one middleware which runs them in order
    bind: (fst, snd) ->
        throw new TypeError "bind: fst is not a function, (#{fst})" if not isFunction fst
        throw new TypeError "bind: snd is not a function, (#{snd})" if not isFunction snd
        (req, res, next) -> fst req, res, -> snd req, res, next

    # make a middleware usable directly with `http.createServer` by making `next`
    # optional
    decorate: (middleware) ->
        (req, res, next = ->) -> middleware req, res, next

    # combine an array of middlewares to one middleware which runs them in order
    sequence: (middlewares) -> middlewares.reduce sequenz.bind, sequenz.nop
