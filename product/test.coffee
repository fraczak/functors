product = require "./"
delay   = require "../delay"

console.log " TESTING: product ..."

fn = delay((x) -> x+x)

fn2 = product fn, fn

x = 2
y = 3
fn2 x, y, (err, data) ->
    expected = [x+x,y+y]
    if err or expected[0] isnt data[0] or expected[1] isnt data[1]
        console.error "FAILED: we should get #{expected}!!!"
    else
        console.log "SUCCESS!!! (#{data})"

product(fn2, fn2) [x,x], [y,y], (err, data) ->
    expected = [[x+x.x+x],[y+y,y+y]]
    if err or expected[0][1] isnt data[0][1] or expected[1][0] isnt data[1][0]
        console.error "FAILED: we should get #{expected}!!!"
    else
        console.log "SUCCESS!!! (#{data})"
