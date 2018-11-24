{isArray, isFunction, isEmpty, flatten} = require "../helpers"

iterFn = (funcs, args, errors, cb) ->
  return cb errors if isEmpty funcs
  [fn, funcs...] = funcs
  [a, args...] = args
  if not isFunction fn
    errors.push Error "Argument to 'merge' is not a function!"
    setImmediate iterFn, funcs, args, errors, cb
  else
    fn a, (err, res) ->
      if err
        errors.push err
        setImmediate iterFn, funcs, args, errors, cb
      else
        cb null, res
  return

_merge = (funcs) ->
  throw Error "EMPTY-MERGE" if isEmpty funcs
  (args, cb) ->
    args = (args for i in [1..funcs.length]) unless isArray args
    if args.length isnt funcs.length
      return cb Error "merge(...) needs #{funcs.length} arguments but got #{args.length}!"
    iterFn funcs, args, [], cb

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
