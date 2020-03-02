isArray = (x) -> Array.isArray(x)

flatten = (args) ->
  do (res=[]) ->
    for x in args
      if isArray x
        for y in x
          res.push y
      else
        res.push x
    res 

isString = (x) ->
  (typeof x is "string") or (x instanceof String)

isNumber = (x) ->
  (typeof x is "number") or (x instanceof Number)

isFunction = (x) ->
  typeof x is "function"

isEmpty = (x) ->
  switch (typeof x)
    when "string"
      return x.length <= 0
    when "undefined"
      return true
    when "object"
      return (not x) or Object.keys(x).length <= 0
  false

withContinuation = (syncFn, context) ->
  (args..., cb) ->
    data = null
    err = null
    try
      data = syncFn.apply context, args
    catch e
      err = e
    cb err, data

refrain = (promise, cb) ->
    promise
    .then (data) -> cb null, data
    .catch (err) -> cb err ? Error "Broken Promise"
      
module.exports =
  flatten: flatten
  isArray: isArray
  isString: isString
  isFunction: isFunction
  isEmpty: isEmpty
  isNumber: isNumber
  withContinuation: withContinuation
  refrain: refrain

  doc: '''
# Helper (synchronous) functions:
#  flatten: e.g., [[1,2],3,4] -> [1,2,3,4] 
#  isArray: e.g., [1,2,3] -> true
#  isNumber: e.g., 0 -> true 
#  isString: e.g., 123 -> false
#  isFunction: ...
#  isEmpty: e.g., {} -> true, [] -> true, ""-> true, but 0 -> false
#  withContinuation: (fn) -> (args...,cb) -> cb null, fn args...
#  refrain: try to turn a Promise into an 'async-by-continuation' function
'''
