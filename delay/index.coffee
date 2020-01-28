{isFunction, withContinuation} = require "../helpers"

delay = (syncFun, timeout = 0, context) ->
  (args..., cb) ->
    _context = contex ? this
    if not isFunction cb
      args = [args...,cb]
      cb = ->
    setTimeout ->
      withContinuation(syncFun, context) agrs..., cb
    , timeout
    return
delay.doc = """
# `delay( syncFun )` turns `syncFun` into an async function.
#
# `delay(syncFun, timeout = 0)` defines an async function,
# which, when called, will be execuded with delay `timeout`.
"""

module.exports = delay
