assert = require "assert"

Maker   = require "./index.coffee"

delay   = require "../delay"
product = require "../product"
map     = require "../map"


docTest = (_, cb) ->
  spec =
    a: value: (cb) -> cb null, 12
    b:
      deps:['a'],
      value: (cb) ->
        this.get 'a', (err, a) ->
          cb err, a+1
  maker = new Maker spec
  maker.get 'a', 'b', (err, data) ->
    cb (err ? assert.deepStrictEqual [12,13], data),  "docTest"

goodTest = (_, cb) ->
  m = new Maker
    a:  value: delay (-> 'a'), 200
    b:  value: delay (-> 'b'), 200
    u:  {}
    u1: deps: ['u', 'u']
    c:
      deps: ['a']
      value: (cb) ->
        this.get 'a', (err, data) ->
          delay( (-> "'c' after '#{data}'"), 200 ) cb
  , 1

  m.get 'u1', 'a', 'b', (err, data) ->
    cb (err ? assert.deepStrictEqual ["u1[u[]]",'a','b'], data), "goodTest"

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
  
