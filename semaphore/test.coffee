assert = require "assert"

semaphore = require "./"
product  = require "../product/"
delay    = require "../delay/"

console.log "--- TESTING `semaphore`"

times2 = (x) ->
  console.log "  ... #{x} + #{x} = #{x+x}"
  x + x

sixFns = ( delay(times2, 2000 * Math.random()) for i in [1..6] )

smallResource = semaphore(1)
bigResource = semaphore(10)

test = (cb) ->
  console.log " 1. semaphore(1) = sequential... "
  product((smallResource f for f in sixFns )) [1..6], (err, data1) ->
    console.log err, data1
    return cb err if err
    console.log " 2. semaphore(10) = 10 in parallel "
    product((bigResource f for f in sixFns )) [1..6], (err, data2) ->
      return cb err if err
      console.log data2
      assert.deepStrictEqual data1, data2
      console.log "Success!"
      cb null, true

test console.log.bind console

module.exports = test
