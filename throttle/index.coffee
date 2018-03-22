throttle = (fn, waitTime = 2000) ->
  pending = false
  lastRun = new Date("Jan 01 1965")
  context = { $:null, args:null }
  (args...) ->
    context.$ = this
    context.args = args
    if not pending
      now = new Date()
      if  waitTime < now - lastRun
        lastRun = now
        fn.apply context.$, context.args
      else
        pending = true
        setTimeout () ->
          fn.apply context.$, context.args
          lastRun = new Date()
          pending = false
        , waitTime - (now - lastRun)
throttle.doc = '''
#  `throttle(fn, waitTime = 2000)` constructs a function, which behaves
#  as its argument `fn`, unless it is called in intervals smaller than `waitTime`.
#  In that case only the last call within that `waiting time` will be made.
'''

module.exports = throttle
