vows    = require 'vows'
assert  = require 'assert'
t       = require "../tuple"

vows
  .describe("An immutable tuple")
  .addBatch(
  # Tests of adding values to a list
    'Setting value':
      topic: new t.Tuple(1,2),
      'Sets the values correct' : (tuple) ->

        assert.equal(tuple.first(), 1)
        assert.equal(tuple.second(), 2)

    'Rendering':
      topic: new t.Tuple(1,2),
      'toString renders correctly' : (tuple) ->
        
        assert.equal(tuple.toString(), "(1, 2)")
          

).export(module)


