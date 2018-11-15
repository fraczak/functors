assert = require "assert"

Maker   = require "./index.coffee"

delay   = require "../delay"
product = require "../product"
map     = require "../map"

console.log " TESTING: Maker ..."

m = new Maker
  a:
    deps: []
    value: delay (-> console.log("done 'a'"); 'a'), 1000
  b:
    deps: []
    value: delay (-> console.log("done 'b'"); 'b'), 1000
  c:
    deps: ['a']
    value: (cb) ->
      this.get 'a', (err, data) ->
        delay( (-> "'c' after '#{data}'"), 1000 ) cb
, {parallel: 2, log: true}

test = (cb) ->
  m.get 'a', cb
#  map(m.get.bind m) [['b', 'a'], 'c'], cb

test console.log.bind console

module.exports = test
