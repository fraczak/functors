{isFunction} = require "../helpers"

class LazyValue
  constructor: (fetch) ->
    throw new Error("It's not a function!") unless isFunction fetch 
    @fetch = fetch
    @state = "start"  # start, waiting, or ready
    @cbs = []
    $ = this
    $.get = (..., cb) ->
      switch $.state
        when "start"
          $.state = "waiting"
          $.cbs.push cb
          setTimeout ->
            $.fetch (err,data) ->
              $.state = "ready"
              $.data = data
              $.err = err
              while $.cbs.length
                $.cbs.shift() err, data
          , 0
        when "waiting"
          $.cbs.push cb
        when "ready" 
          cb($.err, $.data)
        else throw new Error "Unknown state: #{$.state}" 
      return $
  get: (..., cb = (err, value) -> ) ->
    # the method definition will be overwritten by constructor
  select: (path, cb) ->
    select this, path, cb

select = (obj, path, cb) ->
  if obj?.constructor?.name is "LazyValue"
    obj.get (err, val) ->
      return cb(err) if err
      select val, path, cb
  else if path.length is 0
    cb null, obj
  else
    do (field = path.shift()) ->
      try
        select obj[field], path, cb
      catch e
        cb e
  undefined

LazyValue.select = select

LazyValue.doc = """
# `value = new LazyValue( fetch_fn )` creates a read only value initialized
# by an async `fetch_fn`. The value is read by `value.get( cb )`.  E.g.:
#
#   > var val = new LazyValue(function(cb){fs.readFile('/etc/passwd', cb);});
#   > val.get( function( err, data ){ console.log(data.toString() ) });
#
# There is also a helper method `select`:
# `select(obj, path, cb)` a field `obj.path` in `obj` which may contain
# `LazyValue`s.
# The callback `cb(err,val)` is called once value `val` of `obj.path`
# is retrived or error occurs.
"""
module.exports = LazyValue
