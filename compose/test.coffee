assert = require "assert"

compose = require "./index.coffee"
delay   = require "../delay"
product = require "../product"

double = delay (x) -> x + x
eightTimes = compose double, double, double
sixtyFourTimes = compose([eightTimes,eightTimes])

inc = delay (x) -> x + 1
inc1000 = compose( (inc for x in [1..1001]) )

composeTest = (_, cb) ->

  x = 2
  product(double, eightTimes, sixtyFourTimes, inc1000) [1, 1, 1, 1], (err, [r1,r2,r3,r4]) ->
    return cb err if err
    assert r1, 2
    assert r2, 4
    assert r3, 16
    assert r4, 1001
    cb null, "composeTest" 


module.exports = composeTest
