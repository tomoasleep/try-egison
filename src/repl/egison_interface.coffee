child_process = require('child_process')

programName = 'egison'

class EgisonInterface
  constructor: (@handler) ->
    @process = child_process.spawn(programName, ['--prompt', ''])

    @process.stdout.on('data', (data) =>
      str = data.toString('utf8')
      console.log('egison stdout: \n' + str)
      @handler str
    )

    @process.on('close', (code) ->
      console.log('child process exited with code ' + code)
    )

  eval: (msg) ->
    console.log('egison stdin: \n' + msg)
    @process.stdin.write(msg + '\n')

  exitProcess: () ->
    @process.stdout.removeAllListeners('data')
    @process.kill('SIGTERM')

  @socketHandler: (socket) ->
    egison = new EgisonInterface (msg) ->
      socket.emit 'eval response', message: msg

    socket.on 'eval request', (data) ->
      egison.eval data.message

    socket.on 'disconnect', () ->
      egison.exitProcess()
      console.log('egison exited.')

    socket

exports.EgisonInterface = EgisonInterface

