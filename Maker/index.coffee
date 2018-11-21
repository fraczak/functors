product   = require "../product"
LazyValue = require "../LazyValue"
map       = require "../map"
semaphore = require "../semaphore"
{flatten, isArray, isFunction, isString} = require "../helpers"

normalizeDeps = (deps) ->
  m = [].concat(deps).reduce (m, x) ->
    m[x] = x if x?
    m
  , {}
  Object.keys(m).sort()

topoOrder = (spec) ->
  inDegree = Object.keys(spec).reduce (inDegree, v) ->
    for x in spec[v].deps
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

_defaultValue = ($, deps, target) =>
    (cb) ->
      console.log " simulating '#{target}' ..."
      $.get deps, (err, data) ->
        cb err, "#{target}[#{data}]"

_getFn = (spec,target) =>
    throw Error "Unknown target: '#{target}'" unless spec[target]
    (_token, cb) ->
      spec[target]._value.get cb

class Maker
  constructor: ( spec, parallel = 10 ) ->
    $ = this
    sem = semaphore @parallel
    spec = Object.keys(spec).reduce (res, target) ->
      switch
        when isString(spec[target]) or isArray(spec[target])
          deps = normalizeDeps spec[target]
          res[target] =
            deps: deps
            value: _defaultValue $, deps, target
        when isFunction spec[target]
          res[target] =
            deps: []
            value: spec[target]
        else
          deps = normalizeDeps spec[target].deps
          res[target] =
            deps: deps
            value: spec[target].value ? _defaultValue $, deps, target
      res
    , {}

    if topoOrder(spec).length isnt Object.keys(spec).length
      throw Error "It is not a DAG!"

    for v, val of spec
      do (v=v,val=val) ->
        val._value = new LazyValue (cb) ->
          $.get val.deps, (err) ->
            return cb err if err
            sem(val.value, $) cb

    $.get = (targets..., cb) ->
      targets = flatten targets
      fns = targets.map _getFn.bind null, spec
      if targets.length is 1
        fns[0] targets[0], cb
      else
        product(fns) targets, cb
      this


Maker.doc = """
#    maker = new Maker(spec, opts={parallel:10})
#  constructs a DAG of 'targets'. Ex:
#    spec = {
#      a: (cb) => cb(null, 12),
#      b: {deps: 'a',
#          value: function(cb){
#            this.get('a', (err, a) => cb(err, a+1)) }}}
#  The 'targets' (in the above example 'a' and 'b') are realized by calling:
#     maker.get('a','b', (err, result) => console.log(result))
#  # should print: `[12, 13]` 
#  All targets are evaluated at most once, with 'this' set to `maker`.
"""

module.exports = Maker
