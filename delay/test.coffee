delay = require "./"

alog = delay console.log, 1000

for i in [1..10]
    console.log " calling #{i}"
    alog "  running #{i}"
    do (i = i) ->
        delay((x) -> x) i, (err, data) ->
            console.log " .... #{i}"
