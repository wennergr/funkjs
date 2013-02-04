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

    'String concatination Semigroup':
      topic: semigroup.stringSemigroup
      'concat' : (ss) ->
        assert.equal(ss.sum('foo','bar'), 'foobar')

      'composition': (ss) ->
        assert.equal(ss.sum(ss.sum('foo','bar'), 'fnord'), 'foobarfnord')

      'associativity': (ss) ->
        assert.equal(ss.sum(ss.sum('foo','bar'), 'fnord'), ss.sum('foo', ss.sum('bar','fnord')))

    'Disjunction Semigroup':
      topic: semigroup.disjunctionSemigroup
      'disjunction' : (ds) ->
        assert.equal(ds.sum(true,false), true)
        assert.equal(ds.sum(false,true), true)
        assert.equal(ds.sum(true,true), true)
        assert.equal(ds.sum(false,false), false)

      'composition': (ds) ->
        assert.equal(ds.sum(ds.sum(false,false), true), true)

      'associativity': (ds) ->
        assert.equal(ds.sum(ds.sum(false,true), false), ds.sum(false, ds.sum(true,false)))

    'Exclusive Disjunction Semigroup':
      topic: semigroup.exclusiveDisjunctionSemigroup
      'eclusive disjunction' : (eds) ->
        assert.equal(eds.sum(true,true), false)
        assert.equal(eds.sum(true,false), true)
        assert.equal(eds.sum(false,true), true)
        assert.equal(eds.sum(false,false), false)

      'composition': (eds) ->
        assert.equal(eds.sum(eds.sum(false,false), true), true)

      'associativity': (eds) ->
        assert.equal(eds.sum(eds.sum(false,true), false), eds.sum(false, eds.sum(true,false)))

    'Conjunction Semigroup':
      topic: semigroup.conjunctionSemigroup
      'eclusive disjunction' : (cs) ->
        assert.equal(cs.sum(true,true), true)
        assert.equal(cs.sum(true,false), false)
        assert.equal(cs.sum(false,true), false)
        assert.equal(cs.sum(false,false), false)

      'composition': (cs) ->
        assert.equal(cs.sum(cs.sum(false,false), true), false)
        assert.equal(cs.sum(cs.sum(true,true), true), true)

      'associativity': (cs) ->
        assert.equal(cs.sum(cs.sum(false,true), false), cs.sum(false, cs.sum(true,false)))


).export(module)

