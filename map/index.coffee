product = require "../product"
compose = require "../compose"
delay = require "../delay"

map = (afn) -> (a, cb) ->
  product( (afn for x in a) ) a, cb

map.obj = (fn) -> (args, cb) ->
  aux = compose map(fn), delay (vals) ->
    res = {}
    for i in [0..args.length-1]
      res[args[i]] = vals?[i]
    res
  aux args, cb
map.doc = """
# `map(asyncFn)` generates a new async function which takes an array of
# k elements and a callback `cb` as arguments, runs the async function
# with every element of the array. Finnaly, it calls `cb`
# with the array of results
"""

module.exports = map
