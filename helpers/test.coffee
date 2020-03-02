assert = require "assert"

helpers = require "./index.coffee"
delay = require "../delay"
product = require "../product"


test1 =
  delay ->
    assert.deepEqual helpers.flatten([[1], 2, [3..10], [11..100]]), [1..100]

    assert helpers.isArray []
    assert not helpers.isArray {}

    assert helpers.isString ""
    assert helpers.isString new String()
    assert helpers.isString "Ah"
    assert not helpers.isString []
    assert not helpers.isString false
    assert not helpers.isString null

    assert helpers.isFunction ( -> )
    assert helpers.isFunction console.log
    assert not helpers.isFunction []

    assert helpers.isEmpty []
    assert helpers.isEmpty ""
    assert helpers.isEmpty {}
    assert helpers.isEmpty undefined
    assert helpers.isEmpty null
    assert not helpers.isEmpty false
    assert not helpers.isEmpty 0
    assert not helpers.isEmpty ( -> )

    assert not helpers.isNumber null
    assert not helpers.isNumber []
    assert not helpers.isNumber "1"
    assert not helpers.isNumber ""
    assert helpers.isNumber 0
    assert helpers.isNumber 123
    assert helpers.isNumber 123/234
    "Sync-helpers"

test2 = (_, cb) ->
  helpers.withContinuation((x)->x+1) 1, (err, data) ->
    if err? or (data isnt 2)
      err = [err, "Should be 2!"] 
    cb err, "withContinuation"

test3 = (_, cb) ->
  workingPromise = new Promise (s,r) -> s 132
  helpers.refrain workingPromise, (err, data) ->
    if err? or (data isnt 132)
      err = [err, "Should be 132"]
    cb err, "Promise"
    
test4 = (_, cb) ->
  brokenPromise = new Promise (s,r) -> r()
  helpers.refrain brokenPromise, (err, data) ->
    err = null if err?
    cb err, "brokenPromise"



module.exports = product [
  test1
  test2
  test3
  test4
]
  
