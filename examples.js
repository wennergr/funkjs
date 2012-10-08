/* Load the library */
var fpl = require("./list"),
  fpt = require("./tuple"),
  assert = require("assert");


var list = new fpl.fromVarargs(1,2,3,4,5,6,7,8,9,10)

/* Returns 56 */
list
    .takeWhile(function(x) { return x < 8; })
    .map(function(x) { return x * 2; })
    .foldLeft(0, function(x,xs) { return x+xs })
    .toString();

/* Returns
 * (1, 10) :: (2, 9) :: (3, 8) :: (4, 7) :: (5, 6) :: 
 * (6, 5) :: (7, 4) :: (8, 3) :: (9, 2) :: (10, 1) :: Nil
 */
list
  .zip(list.reverse())
  .toString();

/* Returns
 * (2, 20) :: (4, 18) :: (6, 16) :: (8, 14) :: (10, 12) :: 
 * (12, 10) :: (14, 8) :: (16, 6) :: (18, 4) :: (20, 2) :: Nil
 *
 * Here we can see how we can create zip from the more generic
 * form zipWith
 */
list
  .zipWith(function(x,y) { return new fpt.Tuple(x*2, y*2) },
    list.reverse())
  .toString()

/* Returns
 * 2 :: 5 :: 1 :: 2 :: Nil
 */
list
  .add(5)
  .add(2)
  .take(4)
  .toString()


lazyList = fpl.unfold('a', function(x) { return 'a'; } );

lazyList.take(4).toString();
