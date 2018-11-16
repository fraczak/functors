{product, compose} = require "../"
fs = require 'fs'
ld = require 'lodash'

retry = require "./"

module.exports = (_, cb) ->
  fun = (file, cb) ->
    console.log " ... trying to read #{file}"
    fs.readFile file, cb

  funs = ['/etc/passwd', '/etc/passwd_2', './kuku'].map (file, i) ->
      (token, cb) ->
        retry(fun, 4, 500 + i * 100) file, (err, data) ->
          str = if err then " finally failed reading #{file}" else " finished successfully reading #{file} "
          console.log str
          cb null, "ok"
  product(funs) _, (err, results) ->
    cb err, "retryTest"
