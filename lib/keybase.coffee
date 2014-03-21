exec = require('child_process').exec
spawn = require('child_process').spawn

KeyBase = ->
  return this

KeyBase.prototype.sign = (msg, cb) ->
  exec "keybase sign --no-color -m #{msg}", (err, data) ->
    cb err, data

KeyBase.prototype.verify = (msg, cb) ->
  verifier = spawn 'keybase', ['--no-color', 'verify', '-m', msg]

  output = ''
  errors = null

  verifier.stderr.on 'data', (data) ->
    output += data.toString()

  verifier.stdin.end()

  verifier.on 'error', (err) ->
    errors = err

  verifier.on 'exit', (code) ->
    if errors
      return cb errors, {}, output

    if code > 0
      return cb new Error(code), {}, output

    data = {}

    lines = output.split '\n'

    for line in lines
      if line.indexOf('info') > -1
        arr = line.split 'info: Valid signature from '
        data.signer = arr[1]

    return cb errors, data, output

module.exports = new KeyBase()
