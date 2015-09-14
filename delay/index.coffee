delay = (syncFun, timeout = 0, context = this) ->
    (args...,cb) ->
        if "function" isnt typeof cb
            args = [args...,cb]
            cb = ->
        setTimeout ->
            data = null
            err = null
            try
                data = syncFun.apply context, args
            catch e
                err = e
            cb err, data
        , timeout
        return
delay.doc = """
# `delay( syncFun )` turns `syncFun` into an async functions.
#
# `delay(syncFun, timeout = 0, context = this)` defines an async
# function, which, when called, will be execuded with delay `timeout`.
"""

module.exports = delay
