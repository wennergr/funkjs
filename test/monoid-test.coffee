vows      = require 'vows'
assert    = require 'assert'
monoid    = require "../monoid"
semigroup = require "../semigroup"

vows
  .describe("A monoid")
  .addBatch(
    'fromFunction1 and fromFunction2 should be compatible':
      topic: new monoid.fromFunction1( ((x) -> ((y) -> (x+y))), 0 )
      'verification' : (s1) ->
        
        s2 = monoid.fromFunction2( ((x,y) -> (x+y)), 0 )

        assert.equal(s1.sum(1,2), s2.sum(1,2));
        assert.equal(s1.zero(), s2.zero());

      'currying' : (s1) ->
        s2 = monoid.fromFunction2( ((x,y) -> (x+y)), 0 )

        assert.equal(s1.sum(1,2), s2.sum(1,2))
        assert.equal(s1.sum(1)(2), s2.sum(1,2))
        assert.equal(s1.sum()(1)(2), s2.sum(1,2))
        assert.equal(s1.sum(1,2), s2.sum(1)(2))
        assert.equal(s1.sum(1,2), s2.sum()(1)(2))

    'fromFunctionS is compatible with fromFunction2':
      topic: monoid.fromFunctionS(semigroup.fromFunction2( (x,y) -> (x+y) ), 0)
      'verification' : (ss) ->
        assert.equal(ss.sum(1,2), 3)
        assert.equal(ss.sum(ss.zero(), 9), 9)

    'Number Addition Monoid':
      topic: monoid.numberAdditionMonoid
      'addition' : (nas) ->
        assert.equal(nas.sum(1,2), 3)

      'associativity': (nas) ->
        assert.equal(nas.sum(nas.sum(1,2), 3), nas.sum(1, nas.sum(2,3)))

      'identity': (nas) ->
        assert.equal(nas.sum(1, nas.zero()), 1)
        assert.equal(nas.sum(nas.zero(), 1), 1)

    'Number Multiplication Monoid':
      topic: monoid.numberMultiplicationMonoid
      'multiplication' : (nms) ->
        assert.equal(nms.sum(4,2), 8)

      'associativity': (nms) ->
        assert.equal(nms.sum(nms.sum(1,2), 3), nms.sum(1, nms.sum(2,3)))

      'identity': (nms) ->
        assert.equal(nms.sum(9, nms.zero()), 9)
        assert.equal(nms.sum(nms.zero(), 9), 9)

    'String concatination Monoid':
      topic: monoid.stringMonoid
      'concat' : (ss) ->
        assert.equal(ss.sum('foo','bar'), 'foobar')

      'composition': (ss) ->
        assert.equal(ss.sum(ss.sum('foo','bar'), 'fnord'), 'foobarfnord')

      'associativity': (ss) ->
        assert.equal(ss.sum(ss.sum('foo','bar'), 'fnord'), ss.sum('foo', ss.sum('bar','fnord')))

      'identity': (ss) ->
        assert.equal(ss.sum("foobar", ss.zero()), "foobar")
        assert.equal(ss.sum(ss.zero(), "foobar"), "foobar")

    'Disjunction Monoid':
      topic: monoid.disjunctionMonoid
      'disjunction' : (ds) ->
        assert.equal(ds.sum(true,false), true)
        assert.equal(ds.sum(false,true), true)
        assert.equal(ds.sum(true,true), true)
        assert.equal(ds.sum(false,false), false)

      'composition': (ds) ->
        assert.equal(ds.sum(ds.sum(false,false), true), true)

      'associativity': (ds) ->
        assert.equal(ds.sum(ds.sum(false,true), false), ds.sum(false, ds.sum(true,false)))

      'identity': (ds) ->
        assert.equal(ds.sum(true, ds.zero()), true);
        assert.equal(ds.sum(false, ds.zero()), false);
        assert.equal(ds.sum(ds.zero(), true), true);
        assert.equal(ds.sum(ds.zero(), false), false);

    'Exclusive Disjunction Monoid':
      topic: monoid.exclusiveDisjunctionMonoid
      'eclusive disjunction' : (eds) ->
        assert.equal(eds.sum(true,true), false)
        assert.equal(eds.sum(true,false), true)
        assert.equal(eds.sum(false,true), true)
        assert.equal(eds.sum(false,false), false)

      'composition': (eds) ->
        assert.equal(eds.sum(eds.sum(false,false), true), true)

      'associativity': (eds) ->
        assert.equal(eds.sum(eds.sum(false,true), false), eds.sum(false, eds.sum(true,false)))

      'identity': (eds) ->
        assert.equal(eds.sum(true, eds.zero()), true);
        assert.equal(eds.sum(false, eds.zero()), false);
        assert.equal(eds.sum(eds.zero(), true), true);
        assert.equal(eds.sum(eds.zero(), false), false);


    'Conjunction Monoid':
      topic: monoid.conjunctionMonoid
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

      'identity': (cs) ->
        assert.equal(cs.sum(true, cs.zero()), true);
        assert.equal(cs.sum(false, cs.zero()), false);
        assert.equal(cs.sum(cs.zero(), true), true);
        assert.equal(cs.sum(cs.zero(), false), false);


).export(module)

