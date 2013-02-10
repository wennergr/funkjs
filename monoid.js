var s = require('./semigroup')
var list = require('./list')
var stream = require('./stream')

/**
 * Monoid implementation
 *
 * Must follow the rules of: 
 *  associativity:
 *    forall x,y,z sum(sum(x,y), z) = sum(x, sum(y,z))
 *  right idenity:
 *    forall x, sum(x, zero()) = x
 *  left idenity:
 *    forall y, sum(zero(), y) = y
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

/**
 * New monoid based on function fn and a identity
 *
 * @param {fn} (x) -> (y) -> function(x,y)
 * @param {z} zero (identity)
 */
function monoid(fn, z) {
  if ( !(this instanceof monoid) ) 
    return new monoid(fn, z);

  /**
   * Execute monoid operation on arguments a and b
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

  /**
   * Return the zero value for this monoid (identity)
   *
   * @return zero value for this monoid
   */
  this.zero = function() {
    return z;
  }
}

/**
 * New monoid based on a semigroup s and an identity 
 *
 * @param {s} semigroup
 * @param {z} identity value (zero)
 */
function monoidS(s, z) {
  return monoid(s.sum(), z);
}

/**
 * New monoid based on function fn and zero (identity)
 *
 * @param {fn} (x, y) -> function(x,y)
 * @param {z} identity value
 */
function monoid2(fn, z) {
  return monoid(curry(fn), z);
}

/**
 * Monoid that adds two numbers together
 */
var numberAdditionMonoid = monoidS(s.numberAdditionSemigroup, 0);

/**
 * Monoid that multiplies numbers
 */
var numberMultiplicationMonoid = monoidS(s.numberMultiplicationSemigroup, 1);

/**
 * Monoid that concatinates two strings
 */
var stringMonoid = monoidS(s.stringSemigroup, "");

/**
 * Monoid that run logical OR on two booleans
 */
var disjunctionMonoid = monoidS(s.disjunctionSemigroup, false);

/**
 * Monoid that run logical XOR on two booleans
 */
var exclusiveDisjunctionMonoid = monoidS(s.exclusiveDisjunctionSemigroup, false);

/**
 * Monoid that run logical AND on two booleans
 */
var conjunctionMonoid = monoidS(s.conjunctionSemigroup, true);

/**
 * Monoid for list concatination
 */
var listMonoid = monoidS(s.listSemigroup, list.emptyList());

/**
 * Monoid for list stream concatination
 */
var streamMonoid = monoidS(s.streamSemigroup, stream.emptyStream());


/**
 * Export the public interfaces for Monoids
 */
module.exports = {
  "fromFunction1" : monoid,
  "fromFunction2" : monoid2,
  "fromFunctionS" : monoidS,
  "numberAdditionMonoid" : numberAdditionMonoid,
  "numberMultiplicationMonoid" : numberMultiplicationMonoid,
  "stringMonoid" : stringMonoid,
  "disjunctionMonoid" : disjunctionMonoid,
  "exclusiveDisjunctionMonoid" : exclusiveDisjunctionMonoid,
  "conjunctionMonoid" : conjunctionMonoid,
  "listMonoid" : listMonoid,
  "streamMonoid" : streamMonoid
};

