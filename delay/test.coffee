delay = require "./index.coffee"
map   = require "../map/index.coffee"
product = require "../product/index.coffee"

delayTest = (_, cb) ->
  delay( -> 10 ) (err, d) ->
    if d isnt 10
      cb Error "Should be 10, is #{d}"
    cb err, "delayTest"

module.exports = product [
  delayTest
  ]

