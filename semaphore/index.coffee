_cancel = "[functors/semaphore] RESOURCE ALREADY KILLED - execution cancelled!"

semaphore = (maxRunning = 10) ->
  queue = []
  running = 0
  alive = true
  res = (fn, that = null) ->
    (args..., cb) ->
      if alive
        queue.push fn.bind that, args..., (err, data...) ->
          running--
          if queue.length > 0
            running++
            if alive
              queue.shift()()
            else
              queue.shift()
              cb _cancel
          cb err, data...
        if (running < maxRunning)
          running++
          if alive
            queue.shift()()
          else
            queue.shift()
            cb _cancel
      else
        cb _cancel
  res.kill = ->
    alive = false
  res.resurrect = ->
    alive = true
  res

semaphore.doc = """
#  `semaphore(maxRunning = 10)` constructs a constrained execution context and
#  returns a function `function(fn, that = null)` that constructs a function
#  which behaves as it's argument `fn`, unless there are already `maxRunning`
#  functions running in this resource's context. In such a case, the
#  execution is delayed.
"""

module.exports = semaphore
