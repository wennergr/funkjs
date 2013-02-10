list = require("./list");
stream = require("./stream");

/**
 * Semigroup implementation
 *
 * Must follow the rules of associativity:
 *  forall x,y,z sum(sum(x,y), z) = sum(x, sum(y,z))
 *
 * Author: Tobias Wennergren (wennergr) wennergr@gmail.com
 *
 * License: MIT
 *
 */

/**
 * Curry from f2(A, B) => C to f1(A) => f(b) => c
 */
function curry(fn) {
  return function(a) {
    return function(b) {
      return fn(a,b);
    }
  }
}

function isLessThen(a, b) {
  return a < b;
}

function isGreaterThen(a, b) {
  return a > b;
}

/**
 * New semigroup based on function fn
 *
 * @param {fn} (x, y) -> function(x,y)
 */
function semigroup2(fn) {
  return new semigroup(curry(fn));
}

/**
 * New semigroup based on function fn
 *
 * @param {fn} (x) -> (y) -> function(x,y)
 */
function semigroup(fn) {
  if ( !(this instanceof semigroup) ) 
    return new semigroup(fn);

  /**
   * Execute semigroup operation of arguments a and b
   *
   * @param {a} first parameter (optional)
   * @param {b} second parameter (optional)
   *
   * @return
   *   sum() => fn(a,b) (curry)
   *   sum(a) => fn(a) (curry)
   *   sum(a,b) = c
   */
  this.sum = function(a, b) {

    // Neither a or be defined, Curry over a and b
    if (a === undefined)
      return fn;

    // a is defined but not b, curry over a
    if (b === undefined)
      return fn(a);

    return fn(a)(b);
  }
}

/**
 * Semigroup that adds to numbers together
 */
var numberAdditionSemigroup = new semigroup2(function (a,b) {
  return a+b;
});

/**
 * Semigroup that multiplies number together
 */
var numberMultiplicationSemigroup = new semigroup2(function (a,b) {
    return a*b;
});

/**
 * Semigroup that returns the highest number
 */
var numberMaxSemigroup = new semigroup2(function (a,b) {
    return isLessThen(a, b) ? b : a
});

/**
 * Semigroup that returns the lowest number
 */
var numberMinSemigroup = new semigroup2(function (a,b) {
    return isGreaterThen(a, b) ? b : a
});


/**
 * Semigroup that concatinates two strings
 */
var stringSemigroup = new semigroup2(function (a,b) {
    return a+b;
});


/**
 * Semigroup that run logical OR on two booleans
 */
var disjunctionSemigroup = new semigroup2(function (a,b) {
    return a || b;
});

/**
 * Semigroup that run logical XOR on two booleans
 */
var exclusiveDisjunctionSemigroup = new semigroup2(function (a,b) {
    return a ^ b;
});

/**
 * Semigroup that run logical AND on two booleans
 */
var conjunctionSemigroup = new semigroup2(function (a,b) {
    return a && b;
});

/**
 * Semigroup for lists
 */
var listSemigroup = new semigroup2(function (a,b) {
  return a.concat(b);
});

/**
 * Semigroup for stream
 */
var streamSemigroup = new semigroup2(function (a,b) {
  return a.concat(b);
});


/**
 * Export the public interfaces for Semigroups
 */
module.exports = {
  "fromFunction1" : semigroup,
  "fromFunction2" : semigroup2,
  "numberAdditionSemigroup" : numberAdditionSemigroup,
  "numberMultiplicationSemigroup" : numberMultiplicationSemigroup,
  "numberMinSemigroup" : numberMinSemigroup,
  "numberMaxSemigroup" : numberMaxSemigroup,
  "stringSemigroup" : stringSemigroup,
  "disjunctionSemigroup" : disjunctionSemigroup,
  "exclusiveDisjunctionSemigroup" : exclusiveDisjunctionSemigroup,
  "listSemigroup" : listSemigroup,
  "streamSemigroup" : streamSemigroup,
  "conjunctionSemigroup" : conjunctionSemigroup
};


