vows    = require 'vows'
assert  = require 'assert'
s       = require "../stream"
fpt     = require "../tuple"

vows
  .describe("A stream (lazy list)")
  .addBatch(
  # Tests of adding values to a stream
    'Adding value':
      topic : new s.fromVarargs(1,2,3,4),
      'dosen\'t modify the original stream' : (stream) ->
        streamSerialized = stream.toString()

        stream.add(5)

        assert.equal stream.toString(), streamSerialized

      'Adds the value to the beginning of the stream': (stream) ->
        assert.equal(5, stream.add(5).head())

      'Has correct length after adding' : (stream) ->
        assert.equal(stream.length()+2, stream.add(5).add(2).length())

      'Can add into an empty Stream' : (stream) ->
        assert.equal(s.emptyStream().add(1).toString(), new s.fromVarargs(1))

  # Tests of taking values from a stream
    'Taking values':
      topic : new s.fromVarargs(1,2,3,4,5,6),
      'dosen\'t modify the original stream' : (stream) ->
        streamSerialized = stream.toString()

        stream.take(2)

        assert.equal(stream.toString(), streamSerialized)

        stream.takeWhile( (x) -> x % 2 == 0 )

        assert.equal(stream.toString(), streamSerialized)

      'grabs the first 2 elements' : (stream) ->
        assert.equal(stream.take(2).toString(), new s.fromVarargs(1,2).toString())

      'take while x < 5 only returns number smaller then 5' : (stream) ->
        assert.equal(stream.takeWhile( (x) -> x < 5 ).toString(),
          new s.fromVarargs(1,2,3,4).toString())

      'take from an empty stream' : (stream) ->
        assert.equal(s.emptyStream().take(2).toString(), s.emptyStream().toString())
        assert.equal(s.emptyStream().takeWhile( (x) -> x < 5; ).toString(),
          s.emptyStream().toString())

  # Tests of dropping values from a stream
    'Dropping values':
      topic : new s.fromVarargs(1,2,5,1,1),
      'dosen\'t modify the original stream' : (stream) ->
        streamSerialized = stream.toString()

        stream.drop(2)

        assert.equal(stream.toString(), streamSerialized)

        stream.takeWhile( (x) -> x % 2 == 0 )

        assert.equal(stream.toString(), streamSerialized)

      'Drop the first 2 elements' : (stream) ->
        assert.equal(stream.drop(2).toString(), new s.fromVarargs(5,1,1).toString())

      'Drop while x < 5' : (stream) ->
        assert.equal(stream.dropWhile( (x) -> x < 5 ).toString(),
          new s.fromVarargs(5,1,1).toString())

      'drop from an empty stream' : (stream) ->
        assert.equal(s.emptyStream().drop(2).toString(), s.emptyStream().toString())
        assert.equal(s.emptyStream().dropWhile( (x) -> x < 5 ).toString(),
          s.emptyStream().toString())

  # Verifing that the length function works correct
    'length of stream':
      topic : new s.fromVarargs(1,2,3,4),
      'length of stream' : (stream) ->
        assert.equal(stream.length(), 4)

      'length of an empty stream' : (stream) ->
        assert.equal(s.emptyStream().length(), 0)
    
  # Verify that the fold methods works correctly
    'Folding in different dirctions':
      topic : new s.fromVarargs(1,2,3,4,5,4,3,2,1),
      'dosen\'t modify the original stream' : (stream) ->
        streamSerialized = stream.toString()

        stream.foldLeft(0, (xs, x) -> x)

        assert.equal(stream.toString(), streamSerialized)

        stream.foldRight(0, (xs, x) -> x )

        assert.equal(stream.toString(), streamSerialized)

      'Count implemented using folding' : (stream) ->
        assert.equal(stream.foldLeft(0, (xs, x) -> xs+1), stream.length())
        assert.equal(stream.foldRight(0, (xs, x) -> xs+1), stream.length())

      'Sum implemented using folding' : (stream) ->
        assert.equal(stream.foldLeft(0, (xs, x) -> xs+x), 25)
        assert.equal(stream.foldRight(0, (xs, x) -> xs+x), 25)

      'Folding over an empty stream' : (stream) ->
        assert.equal(s.emptyStream().foldLeft(2, (xs, x) -> xs+x; ), 2)
        assert.equal(s.emptyStream().foldRight(2, (xs, x) -> xs+x; ), 2)
    
  # Test of the exists operator
    'Exists':
      topic : new s.fromVarargs(1,2,3,4),
      'dosen\'t modify the original stream': (stream) ->
        streamSerialized = stream.toString()

        stream.exists(3); # Existing value

        assert.equal(stream.toString(), streamSerialized)

        stream.exists(8); # Dosen't exists

        assert.equal(stream.toString(), streamSerialized)

      'With value in the stream' : (stream) ->
        assert.equal(stream.exists(3), true)

      'Without value in the stream' : (stream) ->
        assert.equal(stream.exists(9), false)

      'With empty stream' : (stream) ->
        assert.equal(s.emptyStream().exists(8), false)

  # Test zip function
    'ZipWith (and special case zip)':
      topic: new s.fromVarargs(1,2,3,4),
      'Correctly with stream of even sizes': (stream) ->
        assert.equal(stream.zipWith( ((x,y) -> x+y), new s.fromVarargs(1,1,1,1)).toString(), 
          "Stream(2 :: 3 :: 4 :: 5 :: Nil)")

        assert.equal(stream.zip(new s.fromVarargs(1,1,1,1)).toString(),
          "Stream((1, 1) :: (2, 1) :: (3, 1) :: (4, 1) :: Nil)")


      'Correctly with stream of uneven sizes': (stream) ->
        assert.equal(stream.zip(new s.fromVarargs(1,1,1)).toString(),
          "Stream((1, 1) :: (2, 1) :: (3, 1) :: Nil)")

        assert.equal(stream.zipWith( ((x,y) -> x+y), new s.fromVarargs(1,1,1)).toString(), 
          "Stream(2 :: 3 :: 4 :: Nil)")

  # Test the concat function
    'concatination of stream':
      topic: new s.fromVarargs(1,2,3,4),
      'concat of two non empty stream': (stream) ->
        assert.equal(stream.concat(new s.fromVarargs(1,2)),
          "Stream(1 :: 2 :: 3 :: 4 :: 1 :: 2 :: Nil)")

      'concat with empty stream': (stream) ->
        assert.equal(stream.concat(s.emptyStream()),
          "Stream(1 :: 2 :: 3 :: 4 :: Nil)")

      'concat from empty stream': (stream) ->
        assert.equal(s.emptyStream().concat(stream),
          "Stream(1 :: 2 :: 3 :: 4 :: Nil)")

  # Verifying that stream works even if a user foregetts the "new" keyword
    'System is working without new':
      topic: s.fromVarargs(1,2,3,4),
      'rendering of the stream': (stream) ->
        assert.equal(stream.toString(), "Stream(1 :: 2 :: 3 :: 4 :: Nil)")

      'calling inherited methods': (stream) ->
        assert.equal(stream.add(1).toString(), "Stream(1 :: 1 :: 2 :: 3 :: 4 :: Nil)")


  # Verifying that the flatten function works as expected
    'Flattening of stream (flatten)':
      topic: new s.fromVarargs(1,new s.fromVarargs(2,3),3,4),
      'flatten of 2 dimentional stream': (stream) ->
        assert.equal(stream.flatten().toString(), "Stream(1 :: 2 :: 3 :: 3 :: 4 :: Nil)")

      'flatten of 1 dimentional stream': (stream) ->
        assert.equal(new s.fromVarargs(1,2,3).flatten().toString(), "Stream(1 :: 2 :: 3 :: Nil)")

      'flatten of 3 dimentional stream': (stream) ->
        assert.equal(new s.fromVarargs(1, s.fromVarargs(1, s.fromVarargs(2, 4)),2,3).flatten().toString(), 
          "Stream(1 :: 1 :: 2 :: 4 :: 2 :: 3 :: Nil)")


      'flatten of an empty stream': (stream) ->
        assert.equal(s.emptyStream().flatten().toString(), "Stream()")


  # Verifying that flatMap works correctly
    'FlatMap of stream (flatMap)':
      topic: new s.fromVarargs(1,2,3,4),
      'Identify flatmap': (stream) ->
        assert.equal(new s.fromVarargs(stream, stream).flatMap( (x) -> x ).toString(),
          "Stream(1 :: 2 :: 3 :: 4 :: 1 :: 2 :: 3 :: 4 :: Nil)")

      'Removing with flatmap': (stream) ->
        assert.equal(stream.flatMap( 
            (x) -> if x == 2 then s.emptyStream() else new s.fromVarargs(x) ).toString(),
          "Stream(1 :: 3 :: 4 :: Nil)");

      'Adding with flatmap': (stream) ->
        assert.equal(s.fromVarargs(1,2,3,4).flatMap( 
            (x) -> new s.fromVarargs(x,x)).toString(),
          "Stream(1 :: 1 :: 2 :: 2 :: 3 :: 3 :: 4 :: 4 :: Nil)");

  # Verify that a stream can be created using unfold
    'Creating an infinite stream using unfold':
      topic: new s.unfold(0, (x) -> fpt.Tuple(x, x+1)),
      'size of of stream is correct (using take)': (stream) ->
        assert.equal(stream.take(5).length(),  5)

      'Elements are correct': (stream) ->
        assert.equal(stream.take(5).toString(),
          "Stream(0 :: 1 :: 2 :: 3 :: 4 :: Nil)")

      'Anamorphism is working': (stream) ->
        assert.equal(stream.take(200).foldLeft(0, (xs, x) -> xs+x ), 19900)

      'Map is working': (stream) ->
        assert.equal(stream.map( (x) -> x+1 ).take(5).toString(),
          "Stream(1 :: 2 :: 3 :: 4 :: 5 :: Nil)")

      'Filter is working': (stream) ->
        assert.equal(stream.filter( (x) -> x % 2 == 0 ).take(5).toString(),
          "Stream(0 :: 2 :: 4 :: 6 :: 8 :: Nil)")

      'TakeWhile is working': (stream) ->
        assert.equal(stream.takeWhile( (x) -> x < 3).toString(),
          "Stream(0 :: 1 :: 2 :: Nil)")

      'DropWhile is working': (stream) ->
        assert.equal(stream.dropWhile( (x) -> x < 3 ).take(3).toString(),
          "Stream(3 :: 4 :: 5 :: Nil)")

      'Drop is working': (stream) ->
        assert.equal(stream.drop(4).take(3).toString(),
          "Stream(4 :: 5 :: 6 :: Nil)")

      'Exists is working': (stream) ->
        assert.equal(stream.exists(10), true)

      'zip with two inifite streams': (stream) ->
        assert.equal(stream.zip(s.repeat('a')).take(3).toString(),
          "Stream((0, a) :: (1, a) :: (2, a) :: Nil)")


  # Verify repeat
    'Inifinte stream using repeat':
      topic: new s.repeat('a'),
      'size of of stream is correct (using take)': (stream) ->
        assert.equal(stream.take(5).length(),  5)

      'Elements are correct': (stream) ->
        assert.equal(stream.take(5).toString(),
          "Stream(a :: a :: a :: a :: a :: Nil)")

).export(module)
