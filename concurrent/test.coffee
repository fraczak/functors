assert = require "assert"

concurrent = require "./"
delay   = require "../delay"

console.log " TESTING: concurrent ..."

points = [1000, 500, 1000, 1000, 1000]

fns = for t in points
  do(t = t) ->
    delay ->
      console.log t
      t
    , t

test = (cb) ->
  concurrent(fns) points, (err, r) ->
    return cb err if err
    assert r, Math.min points...
    console.log "Success!"
    cb null, true

test console.log.bind console

module.exports = test
