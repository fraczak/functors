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
    "helpers"
    "Maker" 
]
testFn = (file, cb) ->
  try require("./#{file}/test.coffee") file, cb
  catch e
    cb e

map(testFn) modules, (err, data) ->
  for i in [0..modules.length-1]
    if err?[i]
      console.log "  ? - test '#{modules[i]}' failed! #{err[i]}"
    else
      console.log " OK - test '#{modules[i]}' succeeded: #{data[i]}"

  if err
    process.exitCode = 1
  else
    console.log "All tests passed"
