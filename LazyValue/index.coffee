class LazyValue
    constructor: (fetch) ->
        _fetch = fetch
        $ = this
        $.get = (cb = -> ) ->
            _cb = cb
            _cbs =  [ _cb ]
            setTimeout ->
                _fetch (err,data) ->
                    _data = data
                    _err = err
                    while _cbs.length
                        _cbs.shift() _err, _data
                    $.get = (cb = -> ) ->
                        cb _err, _data
                        return $
            , 0
            $.get = (cb = -> ) ->
                _cbs.push cb
                return $
            return $
    get: (cb = (err, value) -> ) ->
        # the method definition will be overwritten by constructor
    select: LazyValue.select = select = (args..., cb) ->
        if args.length is 1
            args = [this, args...]
        [obj, path] = args
        if obj.constructor.name is "LazyValue"
            obj.get (err, val) ->
                return cb(err) if err
                select val, path, cb
        else if path.length is 0
            cb null, obj
        else
            do (field = path.shift()) ->
                o = obj[field]
                if o
                    select o, path, cb
                else
                    cb new Error("No field '#{field}' in: #{obj}")

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
