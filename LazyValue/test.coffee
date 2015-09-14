async = require "async"
fs = require 'fs'
ld = require 'lodash'

LazyValue = require "./"

async.series [

    (cb) ->
        output = [" - - - - - -"]
        output.push "TESTING `LazyValue`"
        asyncVals = [
            new LazyValue fs.readFile.bind fs, '/etc/passwd'
            new LazyValue fs.readFile.bind fs, '/etc/passwd_2'
            new LazyValue fs.readFile.bind fs, '/etc/passwd_3'
        ]
        print = (err, data) ->
            if err
                output.push "#{err}" + " - as expected"
            else
                output.push "DATA length:\n#{data.toString().length}"
        (val.get print for val in asyncVals)
        (val.get print for val in asyncVals)

        l = -1
        new LazyValue( (cb) -> fs.readFile("./index.coffee", cb) )
            .get()
            .get (e,d) ->
                l = d
            .get (e,d) ->
                if d is l
                    output.push "LazyValue() test OK"
                    cb null, output.join '\n'
                else
                    cb new Error " * LazyValue() test failed!!!"

    (cb) ->
        output = [" - - - - - -"]
        output.push "TESTING `select`"

        trans_obj = (obj) ->
            ld.assign {}, obj, rec: new LazyValue (cb) ->
                fs.readFile "./#{obj.rec}", (err, val) ->
                    cb null, trans_obj JSON.parse val
        lazy_obj = trans_obj require "./select.json"

        LazyValue.select lazy_obj, ['rec', 'f'], console.log.bind console, ">>>>>> Expected error: "
        LazyValue.select lazy_obj, ['rec', 'rec','rec', 'g'], (err,val) ->
            output.push val
            lazy_obj.rec.select ['rec','rec', 'g'], (err,val) ->
                output.push val
                cb null, output.join('\n')
    ],
    ( err, results) ->
        for log in results
            console.log log
        if err
            console.error err 
        else
            console.log "\n   Done: all tests passed."
