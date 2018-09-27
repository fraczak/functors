{isFunction} = require "../helpers"
delay        = require "../delay"


swallow = (ran, _func, _args) ->
  console.error new Error "Continuation 'callback' called #{ran} times! All calls, but the first, are not executed."

logOnly = (ran, func, args) ->
  console.error new Error "Continuation 'callback' called #{ran} times! All those calls are executed."
  func args...

_continuation = (func, nextCalls) ->
  do (ran = 0) ->
    (args...) ->
      ran++
      if ran is 1
        func args...
      else
        nextCalls ran, func, args


continuation = (func, nextCalls = swallow) ->
  return _continuation func, nextCalls if isFunction(func) and isFunction nextCalls
  throw new Error "The arguments must be asynchronous functions!"

continuation.logOnly = logOnly
continuation.swallow = swallow
continuation.doc = '''
# `continuation( asyncFn, allButFirstCalls = swallow)` generates a new
# async function which, when called once behaves like `asyncFn`.
# All consecutive calls do nothing, except printing a warning.
'''

module.exports = continuation
