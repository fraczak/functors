{flatten} = require "../helpers"

_compose = (funcs) ->
  if funcs.length is 0
    (args..., cb) ->
      if 'function' isnt typeof cb
        args = [args..., cb]
        cb = ->
      cb null, args...
  else
    [fn, funcs...] = funcs
    (args..., cb) ->
      if 'function' isnt typeof cb
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

