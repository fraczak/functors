assert = require "assert"

Maker   = require "./index.coffee"

delay   = require "../delay"
product = require "../product"
map     = require "../map"

m = new Maker
  a:
    deps: []
    value: delay (-> 'a'), 200
  b:
    deps: []
    value: delay (-> 'b'), 200
  u: {}
  u1:
    deps: ['u', 'u']
  c:
    deps: ['a']
    value: (cb) ->
      this.get 'a', (err, data) ->
        delay( (-> "'c' after '#{data}'"), 200 ) cb
, {parallel: 1, log: true}

test = (_, cb) ->
  m.get 'u1', 'a', 'b', (err, data) ->
    return cb err if err
    assert.deepStrictEqual ["u1[u[]]",'a','b'], data
    cb null, "OK"

module.exports = test
