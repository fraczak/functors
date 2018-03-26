assert = require "assert"

helpers = require "./index.coffee"
delay = require "../delay"

console.log [" - - - - - -"]
console.log "TESTING `helpers`"

test = ->
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

  true

test()

module.exports = delay test
  
