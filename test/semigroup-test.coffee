vows    = require 'vows'
assert  = require 'assert'
semigroup = require "../semigroup"

vows
  .describe("A semigroup")
  .addBatch(
  # Tests of adding values to a list
    'fromFunction1 and fromFunction2 should be compatible':
      topic: new semigroup.fromFunction1( (x) -> ((y) -> (x+y)) )
      'verification' : (s1) ->
        
        s2 = semigroup.fromFunction2( (x,y) -> (x+y) )

        assert.equal(s1.sum(1,2), s2.sum(1,2));

      'currying' : (s1) ->
        s2 = semigroup.fromFunction2( (x,y) -> (x+y) )

        assert.equal(s1.sum(1,2), s2.sum(1,2))
        assert.equal(s1.sum(1)(2), s2.sum(1,2))
        assert.equal(s1.sum()(1)(2), s2.sum(1,2))
        assert.equal(s1.sum(1,2), s2.sum(1)(2))
        assert.equal(s1.sum(1,2), s2.sum()(1)(2))

    'Number Addition Semigroup':
      topic: semigroup.numberAdditionSemigroup
      'addition' : (nas) ->
        assert.equal(nas.sum(1,2), 3)

      'associativity': (nas) ->
        assert.equal(nas.sum(nas.sum(1,2), 3), nas.sum(1, nas.sum(2,3)))

    'Number Multiplication Semigroup':
      topic: semigroup.numberAdditionSemigroup
      'multiplication' : (nms) ->
        assert.equal(nms.sum(1,2), 3)

      'associativity': (nms) ->
        assert.equal(nms.sum(nms.sum(1,2), 3), nms.sum(1, nms.sum(2,3)))

    'Number Max Semigroup':
      topic: semigroup.numberMaxSemigroup
      'max' : (nms) ->
        assert.equal(nms.sum(1,2), 2)

      'composition': (nms) ->
        assert.equal(nms.sum(nms.sum(1,2), 3), 3)

      'associativity': (nms) ->
        assert.equal(nms.sum(nms.sum(1,2), 3), nms.sum(1, nms.sum(2,3)))

    'Number Min Semigroup':
      topic: semigroup.numberMinSemigroup
      'min' : (nms) ->
        assert.equal(nms.sum(1,2), 1)

      'composition': (nms) ->
        assert.equal(nms.sum(nms.sum(1,2), 3), 1)

      'associativity': (nms) ->
        assert.equal(nms.sum(nms.sum(1,2), 3), nms.sum(1, nms.sum(2,3)))


).export(module)


#  "numberMinSemigroup" : numberMinSemigroup,
#  "numberMaxSemigroup" : numberMaxSemigroup

