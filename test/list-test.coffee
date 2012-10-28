vows    = require 'vows'
assert  = require 'assert'
l       = require "../list"
fpt     = require "../tuple"

vows
  .describe("An immutable list")
  .addBatch(
  # Tests of adding values to a list
    'Adding value':
      topic : new l.fromVarargs(1,2,3,4),
      'dosen\'t modify the original list' : (lst) ->
        lstSerialized = lst.toString()

        lst.add(5)

        assert.equal lst.toString(), lstSerialized

      'Adds the value to the beginning of the list': (lst) ->
        assert.equal(5, lst.add(5).head())

      'Has correct length after adding' : (lst) ->
        assert.equal(lst.length()+2, lst.add(5).add(2).length())

      'Can add into an empty list' : (lst) ->
        assert.equal(l.emptyList().add(1).toString(), new l.fromVarargs(1))

  # Tests of taking values from a list
    'Taking values':
      topic : new l.fromVarargs(1,2,3,4,5,6),
      'dosen\'t modify the original list' : (lst) ->
        lstSerialized = lst.toString()

        lst.take(2)

        assert.equal(lst.toString(), lstSerialized)

        lst.takeWhile( (x) -> x % 2 == 0 )

        assert.equal(lst.toString(), lstSerialized)

      'grabs the first 2 elements' : (lst) ->
        assert.equal(lst.take(2).toString(), new l.fromVarargs(1,2).toString())

      'take while x < 5 only returns number smaller then 5' : (lst) ->
        assert.equal(lst.takeWhile( (x) -> x < 5 ).toString(),
          new l.fromVarargs(1,2,3,4).toString())

      'take from an empty list' : (lst) ->
        assert.equal(l.emptyList().take(2).toString(), l.emptyList().toString())
        assert.equal(l.emptyList().takeWhile( (x) -> x < 5; ).toString(),
          l.emptyList().toString())

  # Tests of dropping values from a list
    'Dropping values':
      topic : new l.fromVarargs(1,2,5,2,1),
      'dosen\'t modify the original list' : (lst) ->
        lstSerialized = lst.toString()

        lst.drop(2)

        assert.equal(lst.toString(), lstSerialized)

        lst.takeWhile( (x) -> x % 2 == 0 )

        assert.equal(lst.toString(), lstSerialized)

      'Drop the first 2 elements' : (lst) ->
        assert.equal(lst.drop(2).toString(), new l.fromVarargs(5,2,1).toString())

      'Drop while x < 5' : (lst) ->
        assert.equal(lst.dropWhile( (x) -> x < 5 ).toString(),
          new l.fromVarargs(5,2,1).toString())

      'drop from an empty list' : (lst) ->
        assert.equal(l.emptyList().drop(2).toString(), l.emptyList().toString())
        assert.equal(l.emptyList().dropWhile( (x) -> x < 5 ).toString(),
          l.emptyList().toString())

  # Verifing that the length function works correct
    'length of list':
      topic : new l.fromVarargs(1,2,3,4),
      'length of list' : (lst) ->
        assert.equal(lst.length(), 4)

      'length of an empty list' : (lst) ->
        assert.equal(l.emptyList().length(), 0)
    
  # Verify that the fold methods works correctly
    'Folding in different dirctions':
      topic : new l.fromVarargs(1,2,3,4,5,4,3,2,1),
      'dosen\'t modify the original list' : (lst) ->
        lstSerialized = lst.toString()

        lst.foldLeft(0, (xs, x) -> x)

        assert.equal(lst.toString(), lstSerialized)

        lst.foldRight(0, (xs, x) -> x )

        assert.equal(lst.toString(), lstSerialized)

      'Count implemented using folding' : (lst) ->
        assert.equal(lst.foldLeft(0, (xs, x) -> xs+1), lst.length())
        assert.equal(lst.foldRight(0, (xs, x) -> xs+1), lst.length())

      'Sum implemented using folding' : (lst) ->
        assert.equal(lst.foldLeft(0, (xs, x) -> xs+x), 25)
        assert.equal(lst.foldRight(0, (xs, x) -> xs+x), 25)

      'Folding over an empty list' : (lst) ->
        assert.equal(l.emptyList().foldLeft(2, (xs, x) -> xs+x; ), 2)
        assert.equal(l.emptyList().foldRight(2, (xs, x) -> xs+x; ), 2)
    
  # Test of the exists operator
    'Exists':
      topic : new l.fromVarargs(1,2,3,4),
      'dosen\'t modify the original list': (lst) ->
        lstSerialized = lst.toString()

        lst.exists(3); # Existing value

        assert.equal(lst.toString(), lstSerialized)

        lst.exists(8); # Dosen't exists

        assert.equal(lst.toString(), lstSerialized)

      'With value in the list' : (lst) ->
        assert.equal(lst.exists(3), true)

      'Without value in the list' : (lst) ->
        assert.equal(lst.exists(9), false)

      'With empty list' : (lst) ->
        assert.equal(l.emptyList().exists(8), false)

  # Test zip function
    'ZipWith (and special case zip)':
      topic: new l.fromVarargs(1,2,3,4),
      'Correctly with lists of even sizes': (lst) ->
        assert.equal(lst.zipWith( ((x,y) -> x+y), new l.fromVarargs(1,1,1,1)).toString(), 
          "List(2 :: 3 :: 4 :: 5 :: Nil)")

        assert.equal(lst.zip(new l.fromVarargs(1,1,1,1)).toString(),
          "List((1, 1) :: (2, 1) :: (3, 1) :: (4, 1) :: Nil)")


      'Correctly with lists of uneven sizes': (lst) ->
        assert.equal(lst.zip(new l.fromVarargs(1,1,1)).toString(),
          "List((1, 1) :: (2, 1) :: (3, 1) :: Nil)")

        assert.equal(lst.zipWith( ((x,y) -> x+y), new l.fromVarargs(1,1,1)).toString(), 
          "List(2 :: 3 :: 4 :: Nil)")

  # Test the concat function
    'concatination of lists':
      topic: new l.fromVarargs(1,2,3,4),
      'concat of two non empty list': (lst) ->
        assert.equal(lst.concat(new l.fromVarargs(1,2)),
          "List(1 :: 2 :: 3 :: 4 :: 1 :: 2 :: Nil)")

      'concat with empty list': (lst) ->
        assert.equal(lst.concat(l.emptyList()),
          "List(1 :: 2 :: 3 :: 4 :: Nil)")

      'concat from empty list': (lst) ->
        assert.equal(l.emptyList().concat(lst),
          "List(1 :: 2 :: 3 :: 4 :: Nil)")

  # Verifying that lists works even if a user foregetts the "new" keyword
    'System is working without new':
      topic: l.fromVarargs(1,2,3,4),
      'rendering of the list': (lst) ->
        assert.equal(lst.toString(), "List(1 :: 2 :: 3 :: 4 :: Nil)")

      'calling inherited methods': (lst) ->
        assert.equal(lst.add(1).toString(), "List(1 :: 1 :: 2 :: 3 :: 4 :: Nil)")


  # Verifying that the flatten function works as expected
    'Flattening of lists (flatten)':
      topic: new l.fromVarargs(1,new l.fromVarargs(2,3),3,4),
      'flatten of 2 dimentional lists': (lst) ->
        assert.equal(lst.flatten().toString(), "List(1 :: 2 :: 3 :: 3 :: 4 :: Nil)")

      'flatten of 1 dimentional lists': (lst) ->
        assert.equal(new l.fromVarargs(1,2,3).flatten().toString(), "List(1 :: 2 :: 3 :: Nil)")

      'flatten of 3 dimentional lists': (lst) ->
        assert.equal(new l.fromVarargs(1, l.fromVarargs(1, l.fromVarargs(2, 4)),2,3).flatten().toString(), 
          "List(1 :: 1 :: 2 :: 4 :: 2 :: 3 :: Nil)")


      'flatten of an empty list': (lst) ->
        assert.equal(l.emptyList().flatten().toString(), "List()")


  # Verifying that flatMap works correctly
    'FlatMap of lists (flatMap)':
      topic: new l.fromVarargs(1,2,3,4),
      'Identify flatmap': (lst) ->
        assert.equal(new l.fromVarargs(lst, lst).flatMap( (x) -> x ).toString(),
          "List(1 :: 2 :: 3 :: 4 :: 1 :: 2 :: 3 :: 4 :: Nil)")

      'Removing with flatmap': (lst) ->
        assert.equal(lst.flatMap( 
            (x) -> if x == 2 then l.emptyList() else new l.fromVarargs(x) ).toString(),
          "List(1 :: 3 :: 4 :: Nil)");

      'Adding with flatmap': (lst) ->
        assert.equal(l.fromVarargs(1,2,3,4).flatMap( 
            (x) -> new l.fromVarargs(x,x)).toString(),
          "List(1 :: 1 :: 2 :: 2 :: 3 :: 3 :: 4 :: 4 :: Nil)")

  # Verify that a list can be created using unfold
    'Creating a list using unfold':
      topic: new l.unfold(0, (x) -> if x > 4 then l.emptyList() else new fpt.Tuple(x, x+1)),
      'size of of list is correct': (lst) ->
        assert.equal(lst.length(),  5)

      'Elements are correct': (lst) ->
        assert.equal(lst.toString(),
          "List(0 :: 1 :: 2 :: 3 :: 4 :: Nil)")

).export(module)


