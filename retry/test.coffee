async = require "async"
fs = require 'fs'
ld = require 'lodash'

retry = require "./"

async.series [

    (cb) ->
        output = [" - - - - - -"]
        output.push "TESTING `retry`"

        fun = (file, out, cb) ->
            console.log " ... trying to read file #{file}..." 
            out.push " trying to read file #{file}..." 
            fs.readFile file, cb

        async.mapSeries ['/etc/passwd', '/etc/passwd_2', './kuku'],
            (item,cbk) ->
                myOutput = []
                retry(fun, 5, 2000) item, myOutput, (err, data) ->
                    str = if err then " failed reading #{item}" else " finished successfully reading #{item} "
                    console.log str
                    myOutput.push str
                    cbk null, myOutput.join('\n'),
            (err, results) ->
                cb err, output.concat(results).join('\n')

    ],
    ( err, results) ->
        for log in results
            console.log log
        if err
            console.error err 
        else
            console.log "\n   Done: all tests passed."
