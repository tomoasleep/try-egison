
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

  write_response = (response) ->
    jqconsole.Write(response.message)
    jqconsole.Prompt true, handler

  socket.on('eval response', (data) ->
    console.log 'received: \n' + data.message
    write_response(data)
  )
  
  jqconsole.Prompt true, handler

  jqconsole

launchSocket = () ->
  socket = io.connect('http://localhost:3000')
  socket.on('connect', () ->
    launchConsole socket
    console.log('connected')
  )

$(() -> launchSocket())

