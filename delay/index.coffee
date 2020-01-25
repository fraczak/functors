{isFunction} = require "../helpers"

delay = (syncFun, timeout = 0, context) ->
  (args...,cb) ->
    _context = contex ? this
    if not isFunction cb
      args = [args...,cb]
      cb = ->
    if timeout is "now"
      return cb null, syncFun.apply _context, args
    setTimeout ->
      data = null
      err = null
      try
        data = syncFun.apply _context, args
      catch e
        err = e
      cb err, data
    , timeout
    return
delay.doc = """
# `delay( syncFun )` turns `syncFun` into an async function.
#
# `delay(syncFun, timeout = 0)` defines an async function,
# which, when called, will be execuded with delay `timeout`.
#
# `delay(syncFun, 'now')` is:
#    function(...args, cb) { cb(null, syncFun(...args)); } 
"""

module.exports = delay
