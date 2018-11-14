{flatten, isArray, isEmpty} = require "../helpers"

_product = (funcs) ->
  if isEmpty funcs
    return (args, cb) ->
      return cb null, [] unless isArray args
      return cb null, [] if isEmpty args
      throw new Error("Number of actual parameters doesn't match!!!")

  (args, cb = ->) ->
    args = (args for i in [1..funcs.length]) unless isArray args
    if args.length isnt funcs.length
      throw new Error("Number of actual parameters doesn't match!!!")
    counter = funcs.length
    result  = []
    errors  = []
    for i in [0..counter-1]
      do (i = i) ->
        funcs[i] args[i], (err, data) ->
          counter--
          errors[i] = err if err?
          result[i] = data
          if counter is 0
            errors = null if isEmpty errors
            cb errors, result

product = (funcs...) ->
  _product flatten funcs
product.doc = '''
# `product(asyncFn1, asyncFn2, ..., asyncFnk)` generates a new async function
# which takes an array of k elements and a callback `cb` as arguments, runs
# the async functions with the elements of the array. Finnaly, it calls `cb`
# with the array of results
'''

module.exports = product
