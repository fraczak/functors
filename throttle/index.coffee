{isFunction} = require "../helpers"
throttle = (fn, waitTime = 2000) ->
  pending = false
  lastRun = new Date("Jan 01 1965")
  context = { $:null, args:null }
  (args...) ->
    if not pending
      now = new Date()
      if  waitTime < now - lastRun
        lastRun = now
        return fn.apply this, args
      pending = true
      context.$ = this
      context.args = args
      setTimeout () ->
        fn.apply context.$, context.args
        lastRun = new Date()
        pending = false
      , waitTime - (now - lastRun)
    else
      do (err = new Error "Too many calls...") ->
        [..., cb] = context.args
        context.$ = this
        context.args = args
        return cb err if isFunction cb
        throw err
    return
    
throttle.doc = '''
#  `throttle(fn, waitTime = 2000)` constructs a function, which behaves
#  as its argument `fn`, unless it is called in intervals smaller than `waitTime`.
#  In that case only the last call within that `waiting time` will be made.
'''

module.exports = throttle
