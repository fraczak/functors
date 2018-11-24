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
# `asyncFn1`, `asyncFn2`, ...
'''

module.exports = compose

