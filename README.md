funkjs
======

> Pure functional javascript library 


Introduction
------------

funkjs is a pure functional immutable library without side effects.
It consists of:
 * list library (good to have functional list library)
 * stream library (lazy list)
 * tuple (immutable tuple implementation)
 * semigroup (basic semigroup library + 8 predefined semigroups)

It has 100% test coverage using vows.

Many other components are under development.

Documentation
-------------

> Check the docs/ directory for api documentation


Examples
--------

> Check examples.js

Initiate a new list:
```javascript
    var list = new fpl.fromVarargs(1,2,3,4,5,6,7,8,9,10)
```

Get the first element:
```javascript
    list.head()
```
Get everything but the first element:
```javascript
    list.tail()
```
Generation of infinite lists using unfold
```javascript
stream
  .unfold(0, function(x) { return new fpt.Tuple(x, x+1); })
  .map(function (y) { console.log(y); return y * 2; })
  .take(5)
```
Combination of different list functions:
```javascript
    list
      .takeWhile(function(x) { return x < 8; })
      .map(function(x) { return x * 2; })
      .foldLeft(0, function(x,xs) { return x+xs })
```
Example of zip (using the tuples library):
```javascript
    list.zip(list.reverse())
```
Example of zipWith (a more generic form then zip):
```javascript
    list
      .zipWith(function(x,y) { return new fpt.Tuple(x*2, y*2) },
        list.reverse())
```
Working with multiple infinite lists and zip
```javascript
stream
  .unfold(0, function(x) { return new fpt.Tuple(x, x+1); })
  .map(function (y) { console.log(y); return y * 2; })
  .zip(stream.repeat('a'))
  .take(10)
```
Another example of dynamically building a immutable list
```javascript
    list
      .add(5)
      .add(2)
      .take(4)
```

```javascript
semigroup.stringSemigroup.sum('foo', 'bar') => 'foobar'
```

Author
------
Tobias Wenergren (wennergr@gmail.com)


