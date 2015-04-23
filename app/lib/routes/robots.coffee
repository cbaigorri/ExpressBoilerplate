
module.exports = (app) ->

  app.use (req, res, next) ->
    if req.url == '/robots.txt'
      res.type 'text/plain'
      res.send if process.env.NODE_ENV is 'production' then "User-agent: *" else "User-agent: *\nDisallow: /"
    else
      next()
