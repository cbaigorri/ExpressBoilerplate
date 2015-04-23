
module.exports = (app) ->

  app.use (req, res, next) ->
    res.status(404)

    # html
    if req.accepts('html')
      res.render 'pages/404', url: req.url
      return

    # json
    if req.accepts('json')
      res.send error: 'Not found'
      return

    # default to plain-text
    res.type('txt').send 'Not found'
