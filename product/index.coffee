product = (funcs...) ->
    if funcs.length is 0
        return (cb) ->
            cb null, [] 
    (args..., cb) ->
        if args.length isnt funcs.length
            args = [args..., cb]
            cb = ->
        if args.length isnt funcs.length
            throw new Error("Number of actual parameters doesn't match!!!")
        counter = funcs.length
        result  = []
        errors  = []
        for i in [0..counter-1]
            do (i = i) ->
                funcs[i] args[i], (err, data) ->
                    counter--
                    errors[i] = err if err?
                    result[i] = data
                    if counter is 0
                        errors = null if errors.length is 0
                        cb errors, result
product.doc = """
# `product(asyncFn1, asyncFn2, ..., asyncFnk)` generates a new async function
# which takes k arguments, runs the async functions with them, and then calls
# a cb with the array of results
"""

module.exports = product
