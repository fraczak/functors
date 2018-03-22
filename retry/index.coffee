retry = (asyncFun, n = 2, timeout = 500) ->
  context = this
  count = n
  throw new Error("`n` must be at least 1 (one) but was: `#{n}`") unless count >= 1
  (args...) ->
    [params..., cb] = orig_args = args
    iterFun = ->
      asyncFun.apply context,
        [ params..., (err, data...) ->
          if count > 1 and err
            count--
            setTimeout iterFun, timeout
          else
            cb err, data...
        ]
    do iterFun
retry.doc = '''
#    `retry(asyncFun)` transforms `asyncFun` into another async function
# which will try executing `asyncFun` twice, if error, before calling its `callback`.
# Actually, the signature is:
#   `retry(asyncFun,times=2,interval=500)`
# and it returns an async function.
'''

module.exports = retry
