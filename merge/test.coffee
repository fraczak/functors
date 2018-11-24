fs = require 'fs'
assert = require "assert"
delay = require "../delay"
product = require "../product"
merge = require "./index.coffee"

fun = (file, cb) ->
  fs.readFile file, (err, buf) ->
    cb err, file

test1 = (_, cb) ->
  merge(fun,fun,fun) ['/etc/passwd_bad', '/etc/passwd', './kuku'], (err, data) ->
    cb (err or assert.strictEqual '/etc/passwd', data), "test1"

test2 = (_, cb) ->
  merge(fun, fun) "ala", (err, data) ->
    cb assert.strictEqual(2, err.length), "test2"

test3 = (_, cb) ->
  merge("dupa", delay -> 3) "token", (err, data) ->
    cb (err or assert.strictEqual 3, data), "test3"

wrongNumberOfArgsTest = (_, cb) ->
  merge("a1", "a2") [1], (err) ->
    cb assert.strictEqual(err.message, "merge(...) needs 2 arguments but got 1!"), "wrongNumberOfArgsTest"


module.exports = product [
  test1
  test2
  test3
  wrongNumberOfArgsTest
]
  
