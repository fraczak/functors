delay = require "./"
map   = require "../map"
product = require "../product"

delayTest = (_, cb) ->
  delay( -> 10 ) (err, d) ->
    if d isnt 10
      cb err, "Should be 10, is #{d}"
    cb err, "delayTest"

module.exports = product [
  delayTest
  ]

