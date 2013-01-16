
# Module dependencies.

express = require 'express'
routes = require './routes'
http = require 'http'
path = require 'path'
Snockets = require 'snockets'
http = require 'http'
mongoose = require 'mongoose'

snockets = new Snockets()
app = express()

# Connect to Mongo DB via Mongoose
mongoose.connect 'mongodb://localhost/test'

app.configure () ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser 'your secret here'
  app.use express.session()
  app.use app.router
  app.use express.static path.join __dirname, 'public'
  # Coffeescript
  app.use require('connect-assets')()

app.configure 'development', () ->
  app.use express.errorHandler()

app.get '/', routes.index

books = require('./controllers/book.js')
app.get '/books', books.list
# app.get('/books/:id', routes.book);

# Do I really need the process.on and app.on functions
process.on 'SIGTERM', () ->
  console.log "Closing app..."
  app.close()

app.on 'close', () ->
  console.log 'Closing mongoDB connection'
  # Close mongose connection
  mongoose.connection.close()

http.createServer(app).listen app.get('port'), () ->
  console.log "Express server listening on port " + app.get('port')
