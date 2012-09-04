vows    = require 'vows'
assert  = require 'assert'
l       = require "../list"

vows
  .describe("An immutable list")
  .addBatch(
  # Tests of adding values to a list
    'Adding value':
      topic : new l.List(1,2,3,4),
      'dosen\'t modify the original list' : (lst) ->
        lstSerialized = lst.toString()

        lst.add(5)

        assert.equal lst.toString(), lstSerialized

      'Adds the value to the beginning of the list': (lst) ->
        assert.equal(5, lst.add(5).head())

      'Has correct length after adding' : (lst) ->
        assert.equal(lst.length()+2, lst.add(5).add(2).length())

      'Can add into an empty list' : (lst) ->
        assert.equal(l.Nil.add(1).toString(), new l.List(1))

  # Tests of taking values from a list
    'Taking values':
      topic : new l.List(1,2,3,4,5,6),
      'dosen\'t modify the original list' : (lst) ->
        lstSerialized = lst.toString()

        lst.take(2)

        assert.equal(lst.toString(), lstSerialized)

        lst.takeWhile( (x) -> x % 2 == 0 )

        assert.equal(lst.toString(), lstSerialized)

      'grabs the first 2 elements' : (lst) ->
        assert.equal(lst.take(2).toString(), new l.List(1,2).toString())

      'take while x < 5 only returns number smaller then 5' : (lst) ->
        assert.equal(lst.takeWhile( (x) -> x < 5 ).toString(),
          new l.List(1,2,3,4).toString())

      'take from an empty list' : (lst) ->
        assert.equal(l.Nil.take(2).toString(), l.Nil.toString())
        assert.equal(l.Nil.takeWhile( (x) -> x < 5; ).toString(),
          l.Nil.toString())

  # Tests of dropping values from a list
    'Dropping values':
      topic : new l.List(1,2,5,2,1),
      'dosen\'t modify the original list' : (lst) ->
        lstSerialized = lst.toString()

        lst.drop(2)

        assert.equal(lst.toString(), lstSerialized)

        lst.takeWhile( (x) -> x % 2 == 0 )

        assert.equal(lst.toString(), lstSerialized)

      'Drop the first 2 elements' : (lst) ->
        assert.equal(lst.drop(2).toString(), new l.List(5,2,1).toString())

      'Drop while x < 5' : (lst) ->
        assert.equal(lst.dropWhile( (x) -> x < 5 ).toString(),
          new l.List(5,2,1).toString())

      'drop from an empty list' : (lst) ->
        assert.equal(l.Nil.drop(2).toString(), l.Nil.toString())
        assert.equal(l.Nil.dropWhile( (x) -> x < 5 ).toString(),
          l.Nil.toString())

  # Verifing that the length function works correct
    'length of list':
      topic : new l.List(1,2,3,4),
      'length of list' : (lst) ->
        assert.equal(lst.length(), 4)

      'length of an empty list' : (lst) ->
        assert.equal(l.Nil.length(), 0)
    
  # Verify that the fold methods works correctly
    'Folding in different dirctions':
      topic : new l.List(1,2,3,4,5,4,3,2,1),
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
        assert.equal(l.Nil.foldLeft(2, (xs, x) -> xs+x; ), 2)
        assert.equal(l.Nil.foldRight(2, (xs, x) -> xs+x; ), 2)
    
  # Test of the exists operator
    'Exists':
      topic : new l.List(1,2,3,4),
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
        assert.equal(l.Nil.exists(8), false)

  # Test zip function
    'ZipWith (and special case zip)':
      topic: new l.List(1,2,3,4),
      'Correctly with lists of even sizes': (lst) ->
        assert.equal(lst.zipWith( ((x,y) -> x+y), new l.List(1,1,1,1)).toString(), 
          "2 :: 3 :: 4 :: 5 :: Nil")

        assert.equal(lst.zip(new l.List(1,1,1,1)).toString(),
          "(1, 1) :: (2, 1) :: (3, 1) :: (4, 1) :: Nil")


      'Correctly with lists of uneven sizes': (lst) ->
        assert.equal(lst.zip(new l.List(1,1,1)).toString(),
          "(1, 1) :: (2, 1) :: (3, 1) :: Nil")

        assert.equal(lst.zipWith( ((x,y) -> x+y), new l.List(1,1,1)).toString(), 
          "2 :: 3 :: 4 :: Nil")


).export(module)


