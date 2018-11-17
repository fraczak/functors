helpers   = require "../helpers"
product   = require "../product"
LazyValue = require "../LazyValue"
map       = require "../map"
semaphore = require "../semaphore"

normalizeDeps = (deps) ->
  m = [].concat(deps).reduce (m, x) ->
    m[x] = x if x?
    m
  , {}
  Object.keys(m).sort()

topoOrder = (spec) ->
  inDegree = Object.keys(spec).reduce (inDegree, v) ->
    for x in spec[v].deps = normalizeDeps spec[v].deps
      inDegree[x] = if inDegree[x] then inDegree[x] + 1 else 1
    inDegree
  , {}
  starts = Object.keys(spec).filter (x) ->
    not inDegree[x]
  result = []
  while x = starts.pop()
    result.push x
    deps = spec[x].deps ? []
    for y in deps
      inDegree[y]--
      starts.push y if inDegree[y] is 0
  result

class Maker
  constructor: ( @spec, @opts = {parallel: 10} ) ->
    $ = this
    sem = semaphore @opts.parallel
    if topoOrder(@spec).length isnt Object.keys(@spec).length
      throw Error "It is not a DAG!"

    for v, val of @spec
      do (v,val) ->
        valueFn = $.spec[v].value ? (cb) ->
          console.log " simulating '#{v}' ..."
          $.get val.deps, (err, data) ->
            cb err, "#{v}[#{data}]"
        val._value = new LazyValue (cb) ->
          $.get val.deps, (err) ->
            return cb err if err
            sem(valueFn, $) cb

  _getFn: (target) =>
    spec = @spec
    throw Error "Unknown target: '#{target}'" unless spec[target]
    (_token, cb) ->
      spec[target]._value.get cb

  get: (targets..., cb) ->
    targets = helpers.flatten targets
    fns = targets.map @_getFn
    if targets.length is 1
      fns[0] targets[0], cb
    else
      product(fns) targets, cb
    this

Maker.doc = """
#    maker = new Maker(spec, opts={parallel:10})
#  constructs a DAG of 'targets'. Ex:
#    spec = {
#      a: {value: (cb) -> cb null, 12},
#      b: {deps:['a'],
#          value: (cb) ->
#            this.get 'a', (err, a) ->
#              cb err, a+1 } }
#  The 'targets' (in the above example 'a' and 'b') are realized by calling:
#      maker.get 'a','b', (err, result) ->
#        console.log result
#  # should print: `[12, 13]` 
#  All targets are evaluated at most once, with 'this' set to `maker`.
"""

module.exports = Maker
