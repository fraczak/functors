`functors` is a collection of "_async_" function generators and/or
transformers.

To install:

    npm i functors

An example:

    var delay   = require("functors/delay"),
        product = require("functors/product"),
        compose = require("functors/compose");

    var fns = [
      function(x){ return x + 1; },
      function(x){ return x + x; },
      function(x){ return x * x; }
    ].map(function(f){ return delay(f); });

    compose(fns)(1, function(err, data) {
      console.log("compose yields " + data);
    });
    // compose yields 16

    product(fns)([1,2,3], function(err, data) {
      console.log("product yields " + data);
    });
    // product yields 2,4,9


The same in `coffee-script`:

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

By running `npm run doc` (or `coffee doc.coffee`) we get the doc:

    > functors@2.2.0 doc /home/wojtek/gits/functors
    > coffee doc.coffee


    > functors@2.2.0 doc /home/wojtek/gits/functors
    > coffee doc.coffee


    delay:
    -----------
    # `delay( syncFun )` turns `syncFun` into an async functions.
    #
    # `delay(syncFun, timeout = 0, context = undefined)` defines an async
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

    map:
    -----------
    # `map(asyncFn)` generates a new async function which takes an array of
    # k elements and a callback `cb` as arguments, runs the async function
    # with every element of the array. Finnaly, it calls `cb`
    # with the array of results

    merge:
    -----------
    # `merge(afn1, afn2, ...)` transforms `afn1, afn2, ...` into another
    # async function which takes two arguments, `[args], cb`, and will
    # try executing in order `afn1(args[0],cb)` and if error occurs
    # it will try afn2(args[1], cb), and so on, till one of the calls
    # does not generate an error.

    concurrent:
    -----------
    # `concurrent(aFn1, aFn2, ..., aFnk)` generates a new async function
    # which takes an array of k elements and a callback `cb` as arguments,
    # runs the functions cuncurrently with the elements of the array,
    # respectively.
    # The first function which succeeds, (err = null), calls `cb`
    # with its results.

    semaphore:
    -----------
    #  `semaphore(maxRunning = 10)` constructs a constrained execution context and
    #  returns a function `function(fn, that = null)` that constructs a function
    #  which behaves as it's argument `fn`, unless there are already `maxRunning`
    #  functions running in this resource's context. In such a case, the
    #  execution is delayed.

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

    Maker:
    -----------
    #    maker = new Maker(spec, parallel:10)
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

    helpers:
    -----------
    # Helper (synchronous) functions:
    #  flatten: e.g., [[1,2],3,4] -> [1,2,3,4] 
    #  isArray: e.g., [1,2,3] -> true
    #  isNumber: e.g., 0 -> true 
    #  isString: e.g., 123 -> false
    #  isFunction: ...
    #  isEmpty: e.g., {} -> true, [] -> true, ""-> true, but 0 -> false

