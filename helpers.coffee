flatten = (args)->
  do (res=[]) ->
    for x in args
      if Array.isArray x
        for y in x
          res.push y
      else
        res.push x
    res 
module.exports =
  flatten: flatten
