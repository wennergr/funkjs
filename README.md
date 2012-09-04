funcjs
======

> Pure functional javascript library 


Introduction
------------

funcjs is a pure functional library without side effects
and 100% immutable. It consists of a list and a tuple library
but many other components are under development.


Documentation
-------------

> Check the docs/ directory for api documentation


Examples
--------

> Check examples.js

Initiate a new list:

    var list = new fpl.List(1,2,3,4,5,6,7,8,9,10)

Get the first element:

    list.head()

Get everything but the first element:
  
    list.tail()

Combination of different list functions:

    list
      .takeWhile(function(x) { return x < 8; })
      .map(function(x) { return x * 2; })
      .foldLeft(0, function(x,xs) { return x+xs })

Example of zip (using the tuples library):

    list.zip(list.reverse())

Example of zipWith (a more generic form then zip):

    list
      .zipWith(function(x,y) { return new fpt.Tuple(x*2, y*2) },
        list.reverse())

Another example of dynamically building a immutable list

    list
      .add(5)
      .add(2)
      .take(4)

Author
------
Tobias Wenergren (wennergr@gmail.com)


