###
Express Boilerplate
###

express = require 'express'
lessMiddleware = require 'less-middleware'


app = express()

# all environments
app.configure ()->
  app.set 'title', 'Express Boilerplate'
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'

  app.locals.layout = true
  
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use lessMiddleware(
    src: __dirname + '/src'
    dest: __dirname + '/out'
    yuicompress: (process.env.NODE_ENV is 'production')
    compress: (process.env.NODE_ENV is 'production')
  )
  app.use require('connect-coffee-script')(
    src: __dirname + '/src'
    dest: __dirname + '/out'
  )
  app.use express.static(__dirname + '/out')

# development only
app.configure 'development', () ->
  # set development configuration here
  app.locals.pretty = true

# production only
app.configure 'production', () ->
  # set production configuration here


# routes
app.get '/', (req, res) ->
  res.render 'index', {
    title: "Home"
  }

app.listen 3000
