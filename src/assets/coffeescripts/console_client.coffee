
launchConsole = (socket) ->
  window.jqconsole = $('#console').jqconsole('', '> ')

  jqconsole.RegisterShortcut('Z', () ->
    jqconsole.AbortPrompt()
    handler()
  )

  jqconsole.RegisterShortcut('A', () ->
    jqconsole.MoveToStart()
    handler()
  )

  jqconsole.RegisterShortcut('E', () ->
    jqconsole.MoveToEnd()
    handler()
  )

  jqconsole.RegisterMatching('{', '}', 'brace')
  jqconsole.RegisterMatching('(', ')', 'paran')
  jqconsole.RegisterMatching('[', ']', 'bracket')

  handler = (command) ->
    if command
      socket.emit 'eval request', message: command

  jqconsole.inputReady = () ->
    jqconsole.Prompt true, handler

  jqconsole.inputReady()
  jqconsole

launchSocket = () ->
  socket = io.connect('http://localhost:3000')

  socket.on('connect', () ->
    jqconsole = launchConsole socket
    console.log('connected')

    socket.on('eval response', (data) ->
      console.log 'received: \n' + data.message
      jqconsole.Write(data.message)
      jqconsole.inputReady()
    )
  )
  
$(() -> launchSocket())

