###
Express Boilerplate
###

env = process.env.NODE_ENV || 'development'

EventEmitter = require('events').EventEmitter
pkg = require './package'
fs = require 'fs'
path = require 'path'
express = require 'express'
coffeescript = require 'connect-coffee-script'
bodyParser = require 'body-parser'
serveStatic = require 'serve-static'
methodOverride = require 'method-override'
lessMiddleware = require 'less-middleware'
morgan = require 'morgan'

class BoilerplateApp extends EventEmitter

  ###
  Constructor
  ###
  constructor: ()->
    console.log ''
    console.log ''
    console.log '\x1b[33m'
    console.log fs.readFileSync(path.join(__dirname, 'BANNER'), {encoding:'utf8'})
    console.log pkg.name, 'version', pkg.version
    console.log '\x1b[0m'
    console.log ''

  ###
  Init
  ###
  initialize: ()->
    @initializeConfigurations()
    @initializeRoutes()
    @appServer = @app.listen process.env.PORT, ()=>
      console.log 'listening on port ', process.env.PORT
      @emit('BoilerplateApp.ready')

  ###
  Init Configurations
  ###
  initializeConfigurations: ()->
    # Paths
    @staticDir = path.join(__dirname, '/static')
    @sourceDir = path.join(__dirname, '/src')

    @app = express()

    @app.set 'title', 'Express Boilerplate'

    @app.locals.layout = true

    # Logger
    @app.use morgan('dev')

    # Body Parser
    @app.use bodyParser.json
      limit: '50mb'
    @app.use bodyParser.urlencoded
     extended: true
     limit: '50mb'

     # Method override
    @app.use methodOverride()

    # Jade
    @app.set 'views', __dirname + '/views'
    @app.set 'view engine', 'jade'

    # Less
    @app.use lessMiddleware @sourceDir,
      dest: @staticDir
      render:
        yuicompress: (process.env.NODE_ENV is 'production')
        sourceMap: (process.env.NODE_ENV is 'development')
        compress: (process.env.NODE_ENV is 'production')

    # CoffeeScript - TODO: swap out with browserify or webpack
    @app.use coffeescript
      src: @sourceDir
      dest: @staticDir

    # Static dir
    @app.use serveStatic @staticDir

    # development only
    if env == 'development'
      # set development configuration here
      @app.locals.pretty = true

    # production only
    if env == 'production'
      # set production configuration here
      console.log 'prod'

  ###
  Init Routes
  ###
  initializeRoutes: ()->

    # Robots
    require('./lib/routes/robots')(@app)

    # routes
    @app.get '/', (req, res) ->
      res.render 'index',
        title: "Home"

    # 404
    require('./lib/routes/404')(@app)


boilerplateApp = new BoilerplateApp()
boilerplateApp.initialize()

module.exports = boilerplateApp
