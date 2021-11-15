{isEmpty} = require "../helpers"

reduce = (afunc) ->
  (args, cb = ->) ->
    return cb new Error "An non-empty array is required!" if isEmpty args
    return cb null, args[0] if args.length is 1
    do ([x,y,args...] = args) ->
      afunc x, y, (err, xy) ->
        return cb err if err?
        reduce(afunc) [xy, args...], cb
    return

reduce.doc = '''
# `reduce(asyncFn)` generates a new async function 'fold-left',
# which takes a non-empty array of elements and a callback `cb` as
# arguments, e.g:
# > reduce(delay (x,y) -> x + y) [100,1,1], (err, x) -> console.log x
# prints '102'
'''

module.exports = reduce
