{isArray, isFunction, flatten} = require "../helpers"

_merge = (funcs) ->
  if funcs.length is 0
    return (..., cb) ->
      cb "EMPTY-MERGE", null
  (args, cb = ->) ->
    args = (args for i in [1..funcs.length]) unless isArray args
    if args.length isnt funcs.length
      throw new Error("Number of actual parameters doesn't match!!!")
    errors  = []
    iterFn = ->
      [fn, funcs...] = funcs
      [a, args...] = args
      return cb errors unless isFunction fn
      fn a, (err, res) ->
        if err
          errors.push err
          do iterFn
        else
          cb null, res
    do iterFn

merge = (funcs...) ->
  _merge flatten funcs

merge.doc = '''
# `merge(aFun1, aFun2, ...)` transforms `aFun1, ...` into another async function
# which takes two arguments, `[args], cb`, and will try executing `aFun1(args[0])`
# and if error it will try aFun2(args[1]), and so on...
'''

module.exports = merge
