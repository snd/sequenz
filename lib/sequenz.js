/*jshint node: true*/
'use strict';

// you cant get around ONE context allocated variable:
// because next() must be a function that is called without a target
// and 

// inlined
function SequenzInvocationState(middlewares, req, res, done) {
  this.middlewares = middlewares;
  this.index = 0;
  this.req = req;
  this.res = res;
  this.done = done;
}

SequenzInvocationState.prototype.next = function next() {
  if (this.index < this.middlewares.length) {
    var middleware = this.middlewares[this.index];
    this.index++;
    var state = this;
    middleware(this.req, this.res, function boundNext() {
      state.next();
    });
  } else {
    if (this.done) this.done();
  }
}

// inlined
function Sequenz(middlewares) {
  this.middlewares = middlewares;
}

Sequenz.prototype.invoke = function invoke(req, res, next) {
  var invocation = new SequenzInvocationState(this.middlewares, req, res, next);
  invocation.next();
};

module.exports = function sequenz(middlewares) {
  if (!Array.isArray(middlewares)) {
    throw new Error('argument must be an array of middlewares');
  }
  var sequenz = new Sequenz(middlewares);
  return function composedMiddlewareReturnedBySequenz(req, res, next) {
    Sequenz.prototype.invoke.apply(sequenz, req, res, next);
  };
}

// function sequenzNextMiddleware(middlewares, index, req, res, done) {
//   middlewares[index](req, res, function next() {
//     if (index + 1 === middlewares.length) {
//       if (done) done();
//     } else {
//       sequenzNextMiddleware(middlewares, index + 1, req, res, done);
//     }
//   });
// }
//
// module.exports = function sequenz(middlewares) {
//   if (!Array.isArray(middlewares)) {
//     throw new Error('argument must be an array of middlewares');
//   }
//   return function composedMiddlewareReturnedBySequenz(req, res, done) {
//     sequenzNextMiddleware(middlewares, 0, req, res, done);
//   };
// };

function statusToString(status) {
  switch(status) {
    case 1: return 'optimized';
    case 2: return 'not optimized';
    case 3: return 'always optimized';
    case 4: return 'never optimized';
    case 6: return 'maybe deoptimized';
  }
}

function printStatus(func) {
  console.log(%FunctionGetName(func), statusToString(%GetOptimizationStatus(func)));
}

module.exports([
  function() {},
]);

module.exports([
  function() {},
]);

%OptimizeFunctionOnNextCall(module.exports);

var inner = function inner(req, res, next) {
  next();
}

var inner2 = function inner2(req, res, next) {
};

var outer = module.exports([
  inner,
  inner2
]);

outer({}, {});
outer({}, {});

%OptimizeFunctionOnNextCall(SequenzInvocationState);
%OptimizeFunctionOnNextCall(SequenzInvocationState.prototype.next);
%OptimizeFunctionOnNextCall(Sequenz);
%OptimizeFunctionOnNextCall(Sequenz.prototype.invoke);
%OptimizeFunctionOnNextCall(outer);
%OptimizeFunctionOnNextCall(inner);
%OptimizeFunctionOnNextCall(inner2);

outer({}, {});

printStatus(module.exports);
printStatus(Sequenz);
printStatus(Sequenz.prototype.invoke);
printStatus(SequenzInvocationState);
printStatus(SequenzInvocationState.prototype.next);
printStatus(outer);
printStatus(inner);
printStatus(inner2);
