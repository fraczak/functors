assert = require "assert"

{product} = require "../"
fs = require 'fs'
ld = require 'lodash'

LazyValue = require "./"


LazyValueTest = (_token,cb) ->
  x = new LazyValue fs.readFile.bind fs, '/etc/passwd'
  x.get (err, data) ->
    return cb err if err
    x.get (err,d) ->
      return cb err if err
      if data isnt d
        return cb Error "Not the same value"
      cb null, "LazyValueTest"

LazyValueErrorTest = (_token, cb) ->
  x = new LazyValue fs.readFile.bind fs, '/etc/passwd-what'
  x.get (err, data) ->
    if err
      return cb null, "LazyValueErrorTest"
    cb Error "Unexpected success - that's BAD!"

LazyValueSelectTest = (_token, cb) ->
  trans_obj = (obj) ->
    ld.assign {}, obj, rec: new LazyValue (cb) ->
      fs.readFile "./#{obj.rec}", (err, val) ->
        cb null, trans_obj JSON.parse val
  lazy_obj = trans_obj require "./select.json"

  LazyValue.select lazy_obj, ['rec','rec','rec','g'], (err, data) ->
    return cb err if err 
    lazy_obj.rec.select ['rec','f'], (err, data) ->
      return cb err if err
      if data isnt "field f1 of select.json"
        return cb Error "Value doesn't match!"
      cb null, "LazyValueSelectTest" 

module.exports = product [
  LazyValueTest
  LazyValueErrorTest
  LazyValueSelectTest
  ]
  
