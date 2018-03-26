fs = require 'fs'
assert = require "assert"

product = require "../product"
merge = require "./"

fun = (file, cb) ->
  console.log " ... trying to read file #{file}..."
  fs.readFile file, (err, buf) ->
    cb err, buf?.toString()

test = (cb) ->
  product([
    merge(fun, fun, fun)
    merge(fun, fun)
  ]) [['/etc/passwd_bad', '/etc/passwd', './kuku'], "ala"], (err, data) ->
    assert data[0], undefined
    assert err[1], undefined
    cb null, true
    
test console.log.bind console

module.exports = test
