assert = require "assert"

continuation = require "../continuation/index.coffee"
product      = require "../product/index.coffee"
delay       = require "../delay/index.coffee"
concurrent = require "../concurrent/index.coffee"

console.log " TESTING: continuation ..."

test1 = (token, cb) ->
  bla =  -> "bla"
  bla_as_cont = continuation bla, nextCalls: continuation.runAll
  data = [bla(), bla_as_cont(), bla_as_cont()]
  cb (assert.strictEqual(data[0], "bla") ?
      assert.strictEqual(data[1], "bla") ?
      assert.strictEqual(data[2], "bla"))
  , 'test1'

test2 = (token, cb) ->
  bla =  delay -> "bla"
  bla_as_cont = continuation bla
  concurrent(
    product bla_as_cont, bla_as_cont
    delay (-> "foo"), 100
  ) token, (err, data) ->
    cb (err ? assert.strictEqual data, "foo"), 'test2'

module.exports = product [
  test1
  test2
]
