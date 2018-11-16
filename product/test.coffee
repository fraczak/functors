assert = require "assert"

product = require "./index.coffee"
delay   = require "../delay"

console.log " TESTING: product ..."

double = delay((x) -> x+x)

double2 = product double, double

productTest = (_, cb) ->
  product(
    product(double, double2)
    product([])
    product()
  ) [[1,[2,3]], null, []], (err, [[r1, [r2, r3]],e1,e2]) ->
      return cb err if err
      assert r1, 2
      assert r2, 4
      assert r3, 6
      assert e1, []
      assert e2, []
      cb null, "productTest"

module.exports = productTest
