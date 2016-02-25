fs = require "fs"
map = require "./index.coffee"
compose = require "../compose/index.coffee"
delay = require "../delay/index.coffee"

console.log [" - - - - - -"]
console.log "TESTING `map`"

files = (x,cb) ->
    fs.readdir "./map/a/"+x, cb

h = compose files, map files
h2 = compose files, map.obj files

for f in [h,h2]
    f "", (err, data) ->
        console.log "err:#{JSON.stringify err}"
        console.log "data:#{JSON.stringify data}"

