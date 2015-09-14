compose = require "./"
delay   = require "../delay"

fn = delay((x) -> x+x)

fn3 = compose fn, fn, fn

console.log " TESTING: compose ..."

x = 2
fn3 x, (err, data) ->
    expected = x * 2 * 2 * 2
    if err or expected isnt data
        console.error "FAILED: we should get #{expected}!!!"
    else
        console.log "SUCCESS!!! (#{data})"

compose(fn3, fn3) x, (err, data) ->
    expected = x * 2 * 2 * 2 * 2 * 2 * 2
    if err or expected isnt data
        console.error "FAILED: we should get #{expected}!!!"
    else
        console.log "SUCCESS!!! (#{data})"
