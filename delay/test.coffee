delay = require "./"
map   = require "../map"

alog = delay console.log.bind(console)

t = (i, cb) ->
  console.log " calling #{i}"
  d = 1100 - 100 * i
  alog " .. running #{i} with delay #{d}..."
  delay(((x) -> x), d) i, (err, data) ->
    console.log " ....  #{data} done"
    cb err, data

test = map(t)

test [1..10], alog

module.exports = (cb) ->
  test [1..10], (err) ->
    cb err, not err
