/**
 * Non lazy (non-strict) funtional list implementation.
 * All parts are immutable and without side effects
 *
 * Author: Tobias Wennergren (wennergr) wennergr@gmail.com
 *
 * License: MIT
 *
 */


/* Import the tuple */
var t = require("./tuple")

/**
 * Companion object for a richer interface to cons and Nil
 */
var _prototype = {

  "valid" : function(x, fn) { return this !== nil() && fn(x) },

  /**
   * Add an element to a list
   * Complexity O(1)
   *
   * @param {Object} element to be added
   * @return {Stream} a new list with the added element
   */
  "add" : function(e) {
    var _this = this;
    return new cons(e, function() { return _this; } );
  },


  /**
   * All elements in a list except the last one
   * Complexity O(n), n = elements in the list
   *
   * @return {Stream} a new list with all elements except last one
   */
  "init" : function() {
    if (this.tail()() === nil()) 
      return this.tail();

    return new cons(this.head(), function() { return this.tail().init(); } );
  },

  /**
   * Take n elements from a list
   * Complexity O(n), n = elements to take
   *
   * @param {Int} amount of objects to be taken
   * @return {Stream} a new list with the taken objects
   */
  "take" : function(n) {
    if (n === 0 || this === nil()) 
      return nil();

    var _this = this;

    return new cons(_this.head(), function() { return _this.tail().take(n-1) } );
  },

  /**
   * Take elements from a list while fn(x) is true
   * Complexity O(n), n = elements in the list
   *
   * @param {Function(x)} predicate to control the take function
   * @return {Stream} a new list with the taken objects
   */
  "takeWhile" : function(fn) {
    if (this === nil() || !this.valid(this.head(), fn)) 
      return nil();

    var _this = this;

    return new cons(_this.head(), function() { return _this.tail().takeWhile(fn); } );
  },

  /**
   * Drop n elements from a list
   * Complexity O(n), n = elements to drop
   *
   * @param {Int} amount of objects to be dropped
   * @return {Stream} a new list with everything except the dropped elements
   */
  "drop" : function(n) {
    if (this === nil() ) return nil();
    else if( n === 0 ) return this;
    return this.tail().drop(n-1);
  },

  /**
   * Drop elements from a list while fn(x) is true
   * Complexity O(n), n = elements in the list
   *
   * @param {Function} predicate to control the drop function
   * @return {Stream} a new list with everything except the dropped elements
   */
  "dropWhile" : function(fn) {
    if (this === nil() ) return nil();
    else if (!fn(this.head())) { console.log("We are in true land"); return this; }
    return this.tail().dropWhile(fn)
  },

  /**
   * Applies a binary operator to a start value and all elements of this list, going left to right.
   * Complexity O(n), n = elements in the list
   *
   * @param {Function(x,xs)} predicate to control the fold function
   * @return {Object} result of the binary function over the list
   */
  "foldLeft" : function(init, fn) {
    if (this === nil()) return init;
    return this.tail().foldLeft(fn(init, this.head()), fn);
  },

  /**
   * Applies a binary operator to a start value and all elements of this list, going right to left.
   * Complexity O(n), n = elements in the list
   *
   * @param {Function(x,xs)} predicate to control the fold function
   * @return {Object} result of the binary function over the list
   */
  "foldRight" : function(init, fn) {
    if (this === nil()) return init;
    return fn(this.tail().foldRight(init, fn), this.head());
  },

  /**
   * Returns a new list with the element in reversed order
   * Complexity O(n), n = elements in the list
   *
   * @return {Stream} a new list
   */
  "reverse" : function() {
    return this.foldLeft(nil(), function(xs,x) { return xs.add(x) });
  },


  /**
   * Selects all elements of this list which satisfy a predicate
   * Complexity O(n), n = elements in the list
   *
   * @param {Function(x)} predicate to control the filter function
   * @return {Stream} a new list with all elements that satised the preficate
   */
  "filter" : function(fn) {
    var _this = this;

    if (_this === nil()) return nil()
    return fn(_this.head()) 
      ? new cons(_this.head(), function() { return _this.tail().filter(fn); })
      : _this.tail().filter(fn);
  },

  /**
   * Builds a new list by applying a function to all elements of this list.
   * Complexity O(n), n = elements in the list
   *
   * @param {Function(x)} function to be applied to each entry in the list
   * @return {Stream} a new list with the function applied to each argument
   */
  "map" : function(fn) {
    _this = this;

    if (_this === nil()) return nil()
    return new cons(fn(_this.head()), function() { return _this.tail().map(fn); });
  },

  /**
   * Calculate the length of the list
   * Complexity O(n), n = elements in the list
   *
   * @param {Function(x)} function to be applied to each entry in the list
   * @return {Stream} a new list with the function applied to each argument
   */  
  "length" : function() {
    return this.foldLeft(0, function(xs,x) { return xs+1});
  },

  /**
   * Check if element exsits in a list
   * Complexity O(n), n = elements in the list
   *
   * @param {Object} object to look for
   * @return {Boolean} True if the object exists, else false
   */
  "exists" : function(e) {
    if (this === nil()) return false;
    return e === this.head() || this.tail().exists(e);
  },

  /**
   * Merge two list's together with help of a function
   * Complexity O(n), n = elements in the shortest list
   *
   * @param {Function(x)} function to be used for the merge
   * @param {Stream} List to merge with
   * @return {Stream} A new merged list
   */
  "zipWith" : function(fn, lst) {
    var _this = this;

    if (this === nil() || lst === nil()) return nil();

    else return new cons(fn(_this.head(), lst.head()), 
      function () { return _this.tail().zipWith(fn, lst.tail()); });
  },

  /**
   * Returns a list formed from this list and another list by 
   * combining corresponding elements in pairs.
   * Complexity O(n), n = elements in the shortest list
   *
   * @param {Stream} List to merge with
   * @return {Stream} A new merged list
   */  
  "zip" : function(lst) {
    return this.zipWith( function(x,y) { return new t.Tuple(x,y) }, lst );
  },


  /**
   * Returns a new list crated by concatination with a second list
   * Complexity O(n), n = elements in the first list
   *
   * @param {Stream} List to merge with
   * @return {Stream} A new merged list
   */   
  "concat" : function(lst) {
    var _this = this;

    /* Starting from empty list */    
    if (_this === nil()) return lst;

    /* Reached end of first list */
    else if (_this.tail() === nil()) return new cons(_this.head(), function() { return lst; }); 

    /* Copy eveything from the current list to a new one */
    else return new cons(_this.head(), function() { return _this.tail().concat(lst); });
  },

  /**
   * Flattens a list of lists
   * Complexity O(n), n = total amount of elements
   *
   * @return {Stream} A new flatten:ed list
   */   
  "flatten" : function() {
    var _this = this;

    if (_this === nil()) return nil();

    var head = _this.head();

    if (head instanceof cons) return head.flatten().concat(_this.tail().flatten());
    else return new cons(head, function() { return _this.tail().flatten(); });
  },

  /**
   * Flattens a list a list using a function
   * Complexity O(n), n = total amount of elements
   *
   * @param {Function(x)} Function from X -> Stream[Y]
   * @return {Stream} A new flatten:ed and mapped list
   */   
  "flatMap" : function(fn) {
    if (this === nil()) return nil();

    return fn(this.head()).concat(this.tail().flatMap(fn));
  },

 
  /**
   * Build's an array based on a list
   * Complexity O(n), n = elements in the list
   *
   * @return {Stream} A new array
   */   
   "toArray" : function() {
    var array = Array();

    function f(x) { 
      if (x !== nil()) p.push(x.head()) && f(x.tail()); 
    }

    f(this);

    return p;
  }
}


/**
 * The Nil Object representing end of list
 */
function nil() {

  if ( !(this instanceof nil) ) 
    return new nil();

  if ( arguments.callee._instance )
    return arguments.callee._instance;

  arguments.callee._instance = this;

  this._toString = function() { 
    return "Nil"
  }

  this.toString = function() { 
    return "Stream()";
  }

  nil.prototype._instance = this;

  return this;
}

/**
 * Base part of any list. Represent's A current element + a link to next cons.
 *
 * @example
 *  
 *  new cons(1, new const(2, new const(3, Nil)));
 */
function cons(x, xs) {

  if ( !(this instanceof cons) ) 
    return new cons(x, xs);

  /**
   * Pretty print out information about the list
   *
   * @return {String} String implementation of the list
   */
  this._toString = function() {
    if (this.head() === nil()) return this.head()._toString();
    return this.head() + " :: " + this.tail()._toString(); 
  }

  this.toString = function() {
    return "Stream("+this._toString()+")"
  };

  /**
   * Returns the current element in the list
   *
   * @return {Object} returns the current element
   */
  this.head = function() {
    return x
  };

  /**
   * Returns a list of everything except the current element
   *
   * @return {Stream} everything except the current element
   */
  this.tail = xs /*function() {
    return xs;
  };  */
}


/* Both cons and Nil should inherit from _prototype */
cons.prototype = _prototype;
nil.prototype = _prototype;

/* utlity method to create an array from <func>.args */
function _argToArray(arg) {
  var p = Array();
  for(var i=0; i<arg.length; i++) 
    p.push(arg[i]);

  return p
}

/* Static factory methods */

/**
* Corecursion (Anamorphism) function to generate 
* lazy lists. Takes the initial value for the generated list
* and based on that, generates a new one
*
* @param {init} Initial value to function
* @parma {Function(x)} Stream generation function. Argument is the last returned value
* @return {Stream} a new lazy list based on on the given corecurisve function
*
*/
function unfold(init, fn) {
  var t = fn(init);
  return new cons(t.first(), function() { return new unfold(t.second(), fn); } );
}

function repeat(x) {
  return new unfold(x, function(k) { return new t.Tuple(x, x); } );
}

function fromArray(lst) { 
  if (lst.length === 0) return nil();
  else return new cons(lst[0], function() { return fromArray(lst.slice(1)); } );
}

function fromVarargs() { 
  return fromArray(_argToArray(fromVarargs.arguments))
}


/**
 * Export the public interfaces for Stream and Nil
 */
module.exports = {
  "fromVarargs" : fromVarargs,
  "fromArray" : fromArray,
  "emptyStream" : nil,
  "unfold" : unfold,
  "repeat" : repeat
}

