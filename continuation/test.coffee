assert = require "assert"

continuation = require "../continuation/index.coffee"
product      = require "../product/index.coffee"
delay       = require "../delay/index.coffee"
concurrent = require "../concurrent/index.coffee"

console.log " TESTING: continuation ..."

test1 = (token, cb) ->
  bla =  delay -> "bla"
  bla_as_cont = continuation bla, continuation.logOnly
  product([
    bla
    bla_as_cont
    bla_as_cont
  ]) token, (err, data) ->
    assert.strictEqual data[0], "bla"
    assert.strictEqual data[1], "bla"
    assert.strictEqual data[2], "bla"
    cb null, true

test2 = (token, cb) ->
  bla =  delay -> "bla"
  bla_as_cont = continuation bla, continuation.swallow
  concurrent(
    product bla_as_cont, bla_as_cont
    delay (-> "foo"), 1000
  ) token, (err, data) ->
    assert.strictEqual data, "foo"
    cb null, true

test = (cb) ->
  bla =  delay -> "bla"
  bla_as_cont = continuation bla, continuation.logOnly
  product(test1, test2) "token", (err, data) ->
    assert.deepStrictEqual data, [true,true] 
    cb null, true



test console.log.bind console

module.exports = test
