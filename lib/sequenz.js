// Generated by CoffeeScript 1.10.0
var bind, decorate, nop, normalizeArguments, sequence,
  slice = [].slice;

nop = function(req, res, next) {
  return next();
};

bind = function(fst, snd) {
  if (!(typeof fst === 'function')) {
    throw new TypeError("bind: fst is not a function, (" + fst + ")");
  }
  if (!(typeof snd === 'function')) {
    throw new TypeError("bind: snd is not a function, (" + snd + ")");
  }
  return function(req, res, next) {
    return fst(req, res, function() {
      return snd(req, res, next);
    });
  };
};

decorate = function(middleware) {
  return function(req, res, next) {
    if (next == null) {
      next = function() {};
    }
    return middleware(req, res, next);
  };
};

sequence = function(middlewares) {
  return middlewares.reduce(bind, nop);
};

normalizeArguments = function() {
  var args;
  args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
  if (args.length === 1 && Array.isArray(args[0])) {
    return args[0];
  } else {
    return args;
  }
};

module.exports = function() {
  var middleware;
  middleware = 1 <= arguments.length ? slice.call(arguments, 0) : [];
  return decorate(sequence(normalizeArguments.apply(null, middleware)));
};

module.exports.bind = bind;

module.exports.sequence = sequence;

module.exports.normalizeArguments = normalizeArguments;
