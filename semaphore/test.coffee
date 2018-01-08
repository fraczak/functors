semaphore = require "./"
product  = require "../product/"
delay    = require "../delay/"

console.log "--- TESTING `semaphore`"

testFn = (t, cb) ->
  product(t) [1..6], (err, r) ->
    return console.error err if err
    console.log r
    cb()

times2 = (x) ->
  console.log "  ... #{x} + #{x} = #{x+x}"
  x + x

sixFns = ( delay(times2, 2000 * Math.random()) for i in [1..6] )


smallResource = semaphore(1)
bigResource = semaphore(10)

console.log " 1. semaphore(1) = sequential... "
testFn ( smallResource f for f in sixFns ), ->
  console.log " 2. semaphore(10) = 10 in parallel "
  testFn ( bigResource f for f in sixFns ), ->
    console.log "Done!"
