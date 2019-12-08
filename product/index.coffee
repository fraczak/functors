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
    ran = []
    for i in [0..counter-1]
      do (i = i) ->
        funcs[i] args[i], (err, data) ->
          if ran[i]
            console.trace "A callback called more than once?"
            console.error err if err?
            if isArray errors[i]
              for e in errors[i]
                console.error e
          else  
            counter--
          ran[i] = true
          if err?
            errors[i] ?= []
            errors[i].push err
          result[i] = data
          if counter is 0
            if isEmpty errors
              cb null, result
            else
              cb errors, result
    return

product = (funcs...) ->
  _product flatten funcs
product.doc = '''
# `product(asyncFn1, asyncFn2, ..., asyncFnk)` generates a new async function
# which takes an array of k elements and a callback `cb` as arguments, runs
# the async functions with the elements of the array. Finnaly, it calls `cb`
# with the array of results
'''

module.exports = product
