###
Boilerplate
###

express = require 'express'


app = express()

# all environments
app.configure ()->
  app.set 'title', 'Boilerplate'
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'

  app.locals.layout = true
  
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use require('less-middleware')({src: __dirname + '/src', dest: __dirname + '/out'})
  app.use require('connect-coffee-script')({src: __dirname + '/src', dest: __dirname + '/out'})
  app.use express.static(__dirname + '/out')

# development only
app.configure 'development', () ->
  # set development configuration here
  app.locals.pretty = true

# production only
app.configure 'production', () ->
  # set production configuration here

app.get '/', (req, res) ->
  res.render 'index', {
    title: "Home"
  }

app.listen 3000

