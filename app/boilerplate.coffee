###
Express Boilerplate
###

env = process.env.NODE_ENV || 'development'

path = require 'path'
express = require 'express'
bodyParser = require 'body-parser'
methodOverride = require 'method-override'
lessMiddleware = require 'less-middleware'
morgan = require 'morgan'

app = express()

app.set 'title', 'Express Boilerplate'
app.set 'views', __dirname + '/views'
app.set 'view engine', 'jade'

app.locals.layout = true

app.use morgan('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded( extended: true )
app.use methodOverride()
app.use lessMiddleware path.join(__dirname, '/src'),
    dest: __dirname + '/out'
  ,
    yuicompress: (process.env.NODE_ENV is 'production')
    sourceMap: (process.env.NODE_ENV is 'development')
    compress: (process.env.NODE_ENV is 'production')

app.use require('connect-coffee-script')(
  src: __dirname + '/src'
  dest: __dirname + '/out'
)
app.use express.static(__dirname + '/out')


# development only
if env == 'development'
  # set development configuration here
  app.locals.pretty = true

# production only
if env == 'production'
  # set production configuration here
  console.log 'prod'


# routes
app.get '/', (req, res) ->
  res.render 'index',
    title: "Home"

app.listen 3000
console.log 'listening on port 3000'
