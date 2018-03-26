{flatten} = require "../helpers"

_concurrent = (funcs) ->
    if funcs.length is 0
        return (cb) ->
            cb "EMPTY-UNION", null
    (args, cb = ->) ->
        if args.length isnt funcs.length
            throw new Error("Number of actual parameters doesn't match!!!")
        counter = funcs.length
        result  = null
        errors  = []
        for i in [0..counter-1]
            do (i = i) ->
              if not result?
                funcs[i] args[i], (err, data) ->
                    return if result?
                    counter--
                    if err
                      errors[i] = err
                      if counter is 0
                        cb errors, null
                    else
                      result = data
                      cb null, data


concurrent = (funcs...) ->
  _concurrent flatten funcs
concurrent.doc = '''
# `concurrent(aFn1, aFn2, ..., aFnk)` generates a new async function
# which takes an array of k elements and a callback `cb` as arguments, runs
# the afunctions cuncurrently with the elements of the array, respectively.
# The first function which succeeds, (err = null), calls `cb`
# with its results.
'''

module.exports = concurrent
