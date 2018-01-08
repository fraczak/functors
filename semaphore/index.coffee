semaphore = (maxRunning = 10) ->
  queue = []
  running = 0
  (fn, that = null) -> (args..., cb) ->
    queue.push fn.bind that, args..., (err, data...) ->
      running--
      if queue.length > 0
        running++
        queue.shift()()
      cb err, data...
    if (running < maxRunning)
      running++
      queue.shift()()

semaphore.doc = """
#  `semaphore(maxRunning = 10)` constructs a constrained execution context and
#  returns a function `function(fn, that = null)` that constructs a function
#  which behaves as it's argument `fn`, unless there are already `maxRunning`
#  functions running in this resource's context. In such a case, the
#  execution is delayed.
"""

module.exports = semaphore
