/**
 * Funtional tuple implementation.
 * All parts are immutable and without side effects
 *
 * Author: Tobias Wennergren (wennergr) wennergr@gmail.com
 *
 * License: MIT
 *
 * TODO: Support for x amount of arguments
 */


/**
 * Initiate a new Tuple
 * 
 * Examples:
 *  
 *  var tuple = new Tuple(1,2)
 *
 * @param {a} First argument
 * @param {b} Second argument
 * @return {List} a tuple
 */
function Tuple(a,b) {

  if ( !(this instanceof Tuple) ) 
    return new Tuple(a, b);
  
  /**
   * Return first object
   *
   * @return {Object} first object
   */   
  this.first = function() { return a; }

  /**
   * Return second object
   *
   * @return {Object} first object
   */  
  this.second = function() { return b; }


  /**
   * Pretty print out information about the list
   *
   * @return {String} String implementation of the list
   */  
  this.toString = function() { 
    return "(" + this.first() + ", " + this.second() + ")"; 
  }

  return this;
}

/**
 * Export the public interfaces for List and Nil
 */
module.exports = {
  "Tuple" : Tuple
}
