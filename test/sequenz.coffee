sequenz = require '../lib/sequenz'
test = require 'tape'

test 'bind - fst is called before snd', (t) ->
  fst = (req, res, next) ->
    req.params.push 1
    next()

  snd = (req, res, next) ->
    req.params.push 2
    next()

  check = (req, res, next) ->
    t.equals req.params[0], 1
    t.equals req.params[1], 2
    next()

  f = sequenz.bind (sequenz.bind fst, snd), check

  f {params: []}, {}, t.end

test 'bind - fst has to be a function', (t) ->
  t.throws -> sequenz.bind {}, sequenz.nop
  t.end()

test 'bind - snd has to be a function', (t) ->
  t.throws -> sequenz.bind sequenz.nop, {}
  t.end()

test 'sequence - middleware is called in order', (t) ->
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
    t.equals req.params[0], 1
    t.equals req.params[1], 2
    t.equals req.params[2], 3
    next()

  f = sequenz.sequence middleware

  f {params: []}, {}, t.end

test 'sequence - works with single middleware', (t) ->
  middleware = []

  middleware.push (req, res, next) -> next()

  f = sequenz.sequence middleware

  f {}, {}, t.end

test 'normalizeArguments - single array as argument', (t) ->
  t.deepEqual [1,2,3], sequenz.normalizeArguments [1,2,3]
  t.end()

test 'normalizeArguments - no value as argument', (t) ->
  t.deepEqual [], sequenz.normalizeArguments()
  t.end()


test 'normalizeArguments - single value as argument', (t) ->
  t.deepEqual [1], sequenz.normalizeArguments 1
  t.end()

test 'normalizeArguments - multiple values as arguments': (test) ->
  t.deepEqual [1,2,3], sequenz.normalizeArguments 1, 2, 3
  t.end()
