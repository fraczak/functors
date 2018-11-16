fs = require "fs"
assert = require "assert"

map = require "./index.coffee"
product = require "../product/index.coffee"
compose = require "../compose/index.coffee"
delay = require "../delay/index.coffee"

files = (x, cb) ->
  fs.readdir "./map/a/"+x, cb

h = compose files, map files
h2 = compose files, map.obj files

test = (_, cb) ->
  product(h,h2) ["",""], (err,data) ->
    return cb err if err
    assert.deepEqual data, [
      [["a","b"],["c","d"]],
      {x:["a","b"],y:["c","d"]}
    ]
    console.log "Success!"
    cb null, true

module.exports = test
