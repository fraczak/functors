throttle = require "./"
map      = require "../map"
delay    = require "../delay"

counter = 0

myFun = throttle ( -> counter++), 600

myTest = map (i, cont) ->
  d = i * 100
  delay(myFun,d) (err) ->
    cont err, i

throttleTest = (_, cb) ->
  myTest [1..5], (err, data) ->
    return cb err if err
    do delay ->
      if counter isnt 2
        return cb Error "Counter shuld be '2' and is #{counter}"
      cb null, "throttleTest"
      "hej"
    , 600

module.exports = throttleTest
