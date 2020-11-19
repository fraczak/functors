{flatten, isFunction, isEmpty} = require "../helpers"

_compose = (funcs) ->
  if isEmpty funcs
    (args..., cb) ->
      if not isFunction cb
        args = [args..., cb]
        cb = ->
      cb null, args...
  else
    [fn, funcs...] = funcs
    (args..., cb) ->
      if not isFunction cb
        args = [args..., cb]
        cb = ->
      fn args..., (err, data...) ->
        return cb(err, data...) if err
        _compose(funcs) data..., cb

compose = (funcs...) ->
  _compose flatten funcs
compose.doc = '''
# `compose(asyncFn1, asyncFn2, ...)` composes the asynchronous functions
# `asyncFn1`, `asyncFn2`, ... from left-to-right, e.g.,
# `compose(f1, f2, f3)(x, cb)` corresponds to something like:
#   f1(x, function(e, x) {
#           if (e) { return cb(e); }
#           f2(x, function(e, x) {
#                   if (e) { return cb(e); }
#                   f3(x, cb) }) })
'''

module.exports = compose

