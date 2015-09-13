throttle = require "./"

console.log [" - - - - - -"]
console.log "TESTING `throttle`"
myFun = throttle console.log.bind(null), 500

for i in [1..10]
    delay = i * 300
    ( (i,delay) ->
        setTimeout ->
            console.log " > calling myFun, i:#{i}, delay:#{delay}"
            myFun "   ... running myFun, i:#{i}, delay:#{delay}"
            if i is 10
                console.log " * `throttle` probably OK, to make sure analize the output!"
        , delay) i, delay

