_cancel = "[functors/semaphore] RESOURCE KILLED - execution cancelled!"

semaphore = (maxRunning = 10) ->
  queue = []
  running = 0
  alive = true
  res = (fn, context) ->
    (args..., cb) ->
      _that = context ? this 
      if alive
        queue.push fn.bind _that, args..., (err, data...) ->
          running--
          if queue.length > 0
            running++
            if alive
              queue.shift()()
            else
              queue.shift()
              cb Error _cancel
          cb err, data...
        if (running < maxRunning)
          running++
          if alive
            queue.shift()()
          else
            queue.shift()
            cb Error _cancel
      else
        cb Error _cancel
  res.kill = ->
    alive = false
  res.resurrect = ->
    alive = true
  res

semaphore.doc = """
#  `semaphore(maxRunning = 10)` constructs a 'semaphore' which is a
#  function `function(afn, context)` that creates a new async
#  function which behaves as its argument `afn`. If there are already
#  `maxRunning` functions running against the semaphore, the execution
#  is delayed.
"""

module.exports = semaphore
