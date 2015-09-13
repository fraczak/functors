compose = (funcs...) ->
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
            fn.apply null, [args..., (err, data...) ->
                return cb(err, data...) if err
                compose(funcs...) data..., cb
            ]
compose.doc = """
# `compose(asyncFn1, asyncFn2, ...)` composes the asynchronous functions
# `asyncFn1`, `asyncFn2`, ...
"""

module.exports = compose

