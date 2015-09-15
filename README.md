`functors` is a collection of "_async_" function generators and/or transformers.
In `coffee-script`:

    {delay, product, compose} = require "functors"

    fns = ( delay f for f in [
        (x) -> x + 1
        (x) -> x + x
        (x) -> x * x
    ] )

    compose(fns) 1, (err, data) ->
        console.log "compose yields #{data}"
    # compose yields 16

    product(fns) [1,2,3], (err, data) ->
        console.log "product yields #{data}"
    # product yields 2,4,9

By running `coffee doc.coffee` we get the doc:

    LazyValue:
    -----------
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

    retry:
    -----------
    #    `retry(asyncFun)` transforms `asyncFun` into another async function
    # which will try executing `asyncFun` twice, if error, before calling its `callback`.
    # Actually, the signature is:
    #   `retry(asyncFun,times=2,interval=500)`
    # and it returns an async function.

    throttle:
    -----------
    #  `throttle(fn, waitTime = 2000)` constructs a function, which behaves
    #  as its argument `fn`, unless it is called in intervals smaller than `waitTime`.
    #  In that case only the last call within that `waiting time` will be made.

    delay:
    -----------
    # `delay( syncFun )` turns `syncFun` into an async functions.
    #
    # `delay(syncFun, timeout = 0, context = this)` defines an async
    # function, which, when called, will be execuded with delay `timeout`.

    compose:
    -----------
    # `compose(asyncFn1, asyncFn2, ...)` composes the asynchronous functions
    # `asyncFn1`, `asyncFn2`, ...

    product:
    -----------
    # `product(asyncFn1, asyncFn2, ..., asyncFnk)` generates a new async function
    # which takes an array of k elements and a callback `cb` as arguments, runs
    # the async functions with the elements of the array. Finnaly, it calls `cb`
    # with the array of results
