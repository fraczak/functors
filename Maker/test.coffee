assert = require "assert"

Maker   = require "./index.coffee"

delay   = require "../delay"
product = require "../product"
map     = require "../map"


docTest = (_, cb) ->
  spec =
    a: value: delay (o) -> 12
    b:
      deps:'a',
      value: delay (o) -> o.a + 1
  maker = new Maker spec
  maker.get 'a', 'b', (err, data) ->
    cb (err ? assert.deepStrictEqual [12,13], data),  "docTest"

goodTest = (_, cb) ->
  m = new Maker
    a:  delay (-> console.log 'a'; 'a'), 300
    b:  delay (-> console.log 'b'; 'b'), 300
    u:  null
    u1: ['u', 'u']
  , 1

  m.get 'u1', 'a', 'b', (err, data) ->
    cb (err ? assert.deepStrictEqual ["u1[u]",'a','b'], data), "goodTest"

noDagTest = delay ->
  assert.throws ->
    m = new Maker {a: {deps: 'b'}, b: deps: 'a'}
  , { name: "Error", message: "It is not a DAG!" }
  'noDagTest'

noTargetTest = delay ->
  assert.throws ->
    m = new Maker {a: {deps: ['b', 'c']}}
  , { name: 'TypeError' }
  'noTargetTest'

module.exports = product [
  docTest
  goodTest
  noDagTest
  noTargetTest
]
  
