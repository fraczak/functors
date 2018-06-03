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
    iterFn = (funcs) ->
      [fn, funcs...] = funcs
      [a, args...] = args
      return cb errors unless isFunction fn
      fn a, (err, res) ->
        if err
          errors.push err
          iterFn funcs
        else
          cb null, res
    iterFn funcs

merge = (funcs...) ->
  _merge flatten funcs

merge.doc = '''
# `merge(afn1, afn2, ...)` transforms `afn1, afn2, ...` into another
# async function which takes two arguments, `[args], cb`, and will
# try executing in order `afn1(args[0],cb)` and if error occurs
# it will try afn2(args[1], cb), and so on, till one of the calls
# does not generate an error.
'''
module.exports = merge
