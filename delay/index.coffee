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
# `async( syncFun)` turns `syncFun` into an async functions.
"""

module.exports = delay
