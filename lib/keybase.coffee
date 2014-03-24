exec = require('child_process').exec
spawn = require('child_process').spawn

KeyBase = ->
  return this

KeyBase.prototype.sign = (msg, cb) ->
  exec "keybase sign --no-color -m #{msg}", (err, data) ->
    cb err, data

KeyBase.prototype.verify = (msg, cb) ->
  @spawn ['verify', '-m', msg], cb

KeyBase.prototype.decrypt = (msg, cb) ->
  @spawn ['decrypt', '-m', msg], cb

KeyBase.prototype.spawn = (args, cb) ->
  args.unshift '--no-color'
  verifier = spawn 'keybase', args

  stderr = ''
  stdout = ''
  errors = null

  verifier.stderr.on 'data', (data) ->
    stderr += data.toString()

  verifier.stdout.on 'data', (data) ->
    stdout += data.toString()

  verifier.stdin.end()

  verifier.on 'error', (err) ->
    errors = err

  verifier.on 'exit', (code) ->
    if errors
      return cb errors, {}, stderr

    if code > 0
      return cb new Error(code), {}, stderr

    data = {}

    err_lines = stderr.split '\n'

    for line in err_lines
      if line.indexOf('info') > -1
        if line.indexOf('Valid signature from keybase user') > -1
          arr = line.split 'info: Valid signature from keybase user '
          signer = arr[1]
          data.signer = signer.split(' ')[0]
        else if line.indexOf('Valid signature from ') > -1
          arr = line.split 'info: Valid signature from '
          signer = arr[1]
          data.signer = signer.split(' ')[0]
        else
          data.info ?= []
          data.info.push line.split('info: ')[1]

    return cb errors, data, stdout

module.exports = new KeyBase()
