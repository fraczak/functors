assert = require "assert"

concurrent = require "./"
delay   = require "../delay"

console.log " TESTING: concurrent ..."

points = [1000, 500, 1000, 1000, 1000]

fns = points.map (t) ->
  delay ->
    t
  , t

concurrentTest = (_, cb) ->
  concurrent(fns) points, (err, r) ->
    return cb err if err
    assert r, Math.min points...
    cb null, "concurrentTest"

module.exports = concurrentTest
