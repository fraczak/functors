assert = require "assert"

product = require "./"
delay   = require "../delay"

console.log " TESTING: product ..."

double = delay((x) -> x+x)

double2 = product double, double

test = (cb) ->
  product(double, double2) [1,[2,3]], (err, [r1, [r2, r3]]) ->
    return cb err if err
    assert r1, 2
    assert r2, 4
    assert r3, 6
    console.log "Success!"
    cb null, true

test console.log.bind console

module.exports = test
