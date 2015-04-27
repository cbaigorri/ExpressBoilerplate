
module.exports = (app) ->

  app.use (err, req, res, next) =>
    res.status(500)
    res.render 'pages/error',
      error: err
    app.emit('error', err)
