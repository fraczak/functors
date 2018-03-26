throttle = require "./"
map      = require "../map"
delay    = require "../delay"

console.log [" - - - - - -"]
console.log "TESTING `throttle`"
myFun = throttle console.log.bind(console), 500

myTest = map (i, cont) ->
  d = i * 100
  console.log " > calling myFun, i:#{i}, delay:#{d}"
  delay(myFun,d) "   ... running myFun, i:#{i}, delay:#{d}", (err) ->
    cont err, i

test = (cb) ->
  myTest [1..10], (err, data) ->
    return cb err if err
    console.log data
    console.log "Success!"
    cb null, true

test console.log.bind console

module.exports = test
