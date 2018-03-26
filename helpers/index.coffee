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

module.exports =
  flatten: flatten
  isArray: isArray
  isString: isString
  isFunction: isFunction
  isEmpty: isEmpty

  doc: '''
# Helper (synchronous) functions:
#  flatten: e.g., [[1,2],3,4] -> [1,2,3,4] 
#  isArray: e.g., [1,2,3] -> true
#  isString: e.g., 123 -> false
#  isFunction: ...
#  isEmpty: e.g., {} -> true, [] -> true, ""-> true, but 0 -> false
'''
