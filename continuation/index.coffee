{isFunction} = require "../helpers"
delay        = require "../delay"


doNotRun = (ran, _func, _args) ->
  console.error new Error "Continuation 'callback' called #{ran} times! All calls, but the first, are not executed."

runAll = (ran, func, args, context) ->
  console.error new Error "Continuation 'callback' called #{ran} times! All those calls are executed."
  func.apply context, args

_continuation = (func, nextCalls, context = this) ->
  do (ran = 0) ->
    (args...) ->
      ran++
      if ran is 1
        func.apply context, args
      else
        nextCalls ran, func, args, context

continuation = (func, opts) ->
  if isFunction opts
    nextCalls = opts
    context = this
  else
    nextCalls = opts?.nextCalls ? doNotRun
    context = opts?.context ? this
  return _continuation func, nextCalls, context if isFunction(func) and isFunction nextCalls
  throw new Error "The argument must be a function!"

continuation.runAll = runAll

continuation.doc = '''
# `continuation( fn, {context: this}` generates a new
# function which, when called once behaves like `fn`.
# All consecutive calls do nothing, except printing a warning.
'''

module.exports = continuation
