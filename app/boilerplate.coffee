###
Express Boilerplate
###

EventEmitter = require('events').EventEmitter
k = require './constants'
pkg = require './package'
fs = require 'fs'
path = require 'path'
express = require 'express'
coffeescript = require 'connect-coffee-script'
browserify = require 'browserify-middleware'
coffeeify = require 'coffeeify'
# jadeify = require 'jadeify'
browserifyShim = require 'browserify-shim'
bodyParser = require 'body-parser'
serveStatic = require 'serve-static'
methodOverride = require 'method-override'
lessMiddleware = require 'less-middleware'
favicon = require 'serve-favicon'
morgan = require 'morgan'

class BoilerplateApp extends EventEmitter

  ###
  Constructor
  ###
  constructor: ()->
    # console.log ''
    # console.log ''
    # console.log '\x1b[33m'
    # console.log fs.readFileSync(path.join(__dirname, 'BANNER'), {encoding:'utf8'})
    # console.log pkg.name, 'version', pkg.version
    # console.log '\x1b[0m'
    # console.log ''

  ###
  Init
  ###
  initialize: ()->
    @env = process.env.NODE_ENV || 'development'
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
        yuicompress: (@env is 'production')
        sourceMap: (@env is 'development')
        compress: (@env is 'production')

    # browserify settings
    browserify.settings 'transform', [browserifyShim, coffeeify]

    #bundle.js
    @app.get '/js/bundle.js',
      browserify path.join(@sourceDir, '/js/script.coffee'),
          extensions: ['.coffee']
          minify: (@env is 'production')
          external: [
            'jquery'
          ]

    # Favicon
    @app.use favicon(path.join(@staticDir, '/favicon.ico'))

    # Static dir
    @app.use serveStatic @staticDir

    # development only
    if @env == 'development'
      # set development configuration here
      @app.locals.pretty = true

      # Error test route
      @app.get '/error', (req, res, next) ->
        ee = new (require('events').EventEmitter)
        setTimeout ()->
          # ee.emit 'error', 'This should break it EE!!!.'
          # throw new Error('This should break.')
          # next( throw new Error('This should break.') )
          # next( new Error('This should break.') ) # doesn't break - needs to be thrown to cause an exception
          # flerb.bark()

    # production only
    if @env == 'production'
      # set production configuration here
      console.log 'prod'

  ###
  Init Routes
  ###
  initializeRoutes: ()->

    # Robots.txt
    require('./lib/routes/robots')(@app)

    # routes
    @app.get '/', (req, res) ->
      res.render 'pages/index',
        title: "Home"

    # 404
    require('./lib/routes/404')(@app)

    # Application error handling
    require('./lib/routes/500')(@app)


boilerplateApp = new BoilerplateApp()
boilerplateApp.initialize()

module.exports = boilerplateApp
