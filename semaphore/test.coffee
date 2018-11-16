assert = require "assert"

semaphore = require "./"
product  = require "../product/"
delay    = require "../delay/"
map      = require "../map"

times2 = (x) ->
  x + x

sixFns = ( delay(times2, 100) for i in [1..10] )

test = (parallel, cb) ->
  sem = semaphore(parallel)
  start = new Date()
  product(sem f for f in sixFns) [1..10], (err, data1) ->
    return cb err if err
    cb null, (new Date()) - start 

semaphoreTest = (_, cb) ->
  map(test) [1, 10], (err, [t1, t10]) ->
    cb err if err
    if 6
      4 < Math.round(t1/t10) < 14
      return cb null, "semaphoreTest[~#{Math.round(t1/t10)}]"
    cb "Execution times do not match! t1=#{t1} vs t10=#{t10}"

module.exports = product [
  semaphoreTest
]
