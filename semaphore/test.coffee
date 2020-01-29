assert = require "assert"

semaphore = require "./"
product  = require "../product/"
delay    = require "../delay/"
map      = require "../map"

times2 = (x) ->
  x + x

tenFns = ( delay(times2, 200) for i in [1..10] )

semInProduct = (parallel, cb) ->
  sem = semaphore(parallel)
  start = new Date()
  product(sem f for f in tenFns) [1..10], (err, data1) ->
    return cb err if err
    cb null, (new Date()) - start 

productTest = (_, cb) ->
  map(semInProduct) [1, 10], (err, [t1, t10]) ->
    cb (err or assert(t1 > t10)),
      "productTest[speedup #{t1/t10}]"

semInMap = (parallel, cb) ->
  sem = semaphore(parallel)
  start = new Date()
  map(sem tenFns[0]) [1..10], (err, data1) ->
    return cb err if err
    cb null, (new Date()) - start 

mapTest = (_, cb) ->
  map(semInMap) [1, 10], (err, [t1, t10]) ->
    cb (err or assert(t1 > t10)),
      "mapTest[speedup #{t1/t10}]"

module.exports = product [
  productTest
  mapTest
]
