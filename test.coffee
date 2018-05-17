assert = require "assert"
map = require "./map"

modules = [
    "LazyValue"
    "retry"
    "semaphore"
    "throttle"
    "delay"
    "compose"
    "product"
    "concurrent"
    "merge"
    "map"
    "helpers" ]

tests = for part in modules
  [part, require "./#{part}/test.coffee"]


map( ([part,testFn], cb) ->
  testFn (err, result) ->
    assert result
    cb err, [part,result] ) tests, (err, data) ->
      console.log "\n---\nTested: \n", data
