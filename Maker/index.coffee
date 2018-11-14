helpers   = require "../helpers"
product   = require "../product"
LazyValue = require "../LazyValue"
map       = require "../map"
semaphore = require "../semaphore"

topoOrder = (spec) ->
  inDegree = Object.keys(spec).reduce (inDegree, v) ->
    for x in spec[v].deps ? []
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
  result.reverse()

class Maker
  constructor: ( @spec, @opts = {parallel: 10, log: false} ) ->
    $ = this
    @topo = topoOrder @spec
    @sem = sem = semaphore @opts.parallel
    if @topo.length isnt Object.keys(@spec).length
      throw Error "It is not a DAG!"

    for v, val of @spec
      do (v,val) ->
        val.deps ?= []
        valueFn = $.spec[v].value ? (cb) ->
          console.log "... simulating #{v}"
          map($.get) val.deps, (err, data) ->
            cb err, v + data
        val._value = new LazyValue (cb) ->
          product(val.deps.map $.buildAsyncFn) val.deps, (err) ->
            return cb err if err
            sem(valueFn, $) cb

  get: (target, cb) ->
    @spec[target]._value.get cb

  buildAsyncFn: (target) =>
    throw Error "Unknown target: '#{target}'" unless @spec[target]
    (_token, cb) =>
      if @opts.log
        console.log "... asking for '#{target}'"
      @get target, cb

  make: (targets..., cb) =>
    targets = helpers.flatten targets
    product(targets.map @buildAsyncFn) targets, cb
    "done"

Maker.doc = """
#  `maker = new Maker(spec, opts = {parallel:100,log:false})` constructs a DAG of 'targets'.
#  Ex:
#    spec =
#      a:
#        value: (cb) -> 12
#      b:
#        deps: ['a']
#        value: (cb) ->
#          this.get 'a', (err, a) ->
#            cb null, a + 1
#  The 'targets' (in the above example 'a' and 'b') can be made by calling:
#      maker.make ['a','b'], (err, result) ->
#        console.log result // should give:[12, 13] 
#  All targets are evaluated at most once, with 'this' set to `maker`.
"""

module.exports = Maker
