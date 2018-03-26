{product, compose} = require "../"
fs = require 'fs'
ld = require 'lodash'

retry = require "./"

test = (cb) ->
  product([
    (_,cb) ->
        output = [" - - - - - -"]
        output.push "TESTING `retry`"

        fun = (file, out, cb) ->
            console.log " ... trying to read file #{file}..."
            out.push " trying to read file #{file}..."
            fs.readFile file, cb

        funs = for file in ['/etc/passwd', '/etc/passwd_2', './kuku']
            do (file = file) ->
                (myOutput,cbk) ->
                    retry(fun.bind(this,file), 5, 1000) myOutput, (err, data) ->
                        str = if err then " failed reading #{file}" else " finished successfully reading #{file} "
                        console.log str
                        myOutput.push str
                        cbk null, myOutput
        compose(funs) [], (err, results) ->
                cb err, output.concat(results).join('\n')

    ]) [1], ( err, results) ->
      for log in results or []
        console.log log
      return cb err if err
      console.log "Success!"
      cb null, true


test console.log.bind console

module.exports = test
