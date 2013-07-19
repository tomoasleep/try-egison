
###
Module dependencies.
###
express = require("express")
routes = require("./routes")
http = require("http")
path = require("path")
EgisonInterface = require("./repl/egison_interface").EgisonInterface
socketIO = require("socket.io")

app = express()
server = http.createServer(app)
socketIOServer = socketIO.listen(server)

# all environments
app.set "port", process.env.PORT or 3000
app.set "views", path.join(__dirname, "..", "views")
app.set "view engine", "jade"
app.use express.favicon()
app.use express.logger("dev")
app.use express.bodyParser()
app.use express.methodOverride()
# app.use express.compiler(
#   src: __dirname + "/public"
#   enable: [ "sass" ]
# )
app.use app.router
app.use express.static(path.join(__dirname, "..", "public"))

# development only
app.use express.errorHandler()  if "development" is app.get("env")

# routing
app.get "/", routes.index

server.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

socketIOServer.sockets.on 'connection', EgisonInterface.socketHandler

