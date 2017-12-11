resource = (maxRunning = 10) ->
  queue = []
  running = 0
  (fn, that = null) -> (args..., cb) ->
    queue.push fn.bind that, args..., (err) ->
      running--
      if queue.length > 0
        running++
        queue.shift()()
      cb err
    if (running < maxRunning)
      running++
      queue.shift()()

resource.doc = """
#  `resource(maxRunning = 10)` constructs a constrained execution context and
#  returns a function `function(fn, that = null)` that constructs a function
#  which behaves as it's argument `fn` unless there are already `maxRunning`
#  functions running in this resource's context.
"""

module.exports = resource
