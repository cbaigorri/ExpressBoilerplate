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

# Less
app.use lessMiddleware path.join(__dirname, '/src'),
    dest: __dirname + '/out'
  ,
    yuicompress: (process.env.NODE_ENV is 'production')
    sourceMap: (process.env.NODE_ENV is 'development')
    compress: (process.env.NODE_ENV is 'production')

# CoffeeScript
app.use require('connect-coffee-script')(
  src: __dirname + '/src'
  dest: __dirname + '/out'
)

# Static dir
app.use express.static(__dirname + '/out')

# Robots
app.use(function (req, res, next) {
  if req.url == '/robots.txt'
    res.type 'text/plain'
    res.send if process.env.NODE_ENV is 'production' then "User-agent: *" else "User-agent: *\nDisallow: /"
  else
    next()


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


# 404
app.use (req, res, next) ->
  res.status(404)

  # html
  if req.accepts('html')
    res.render '404', url: req.url
    return

  # json
  if req.accepts('json')
    res.send error: 'Not found'
    return

  # default to plain-text
  res.type('txt').send 'Not found'


app.listen 3000
console.log 'listening on port 3000'
