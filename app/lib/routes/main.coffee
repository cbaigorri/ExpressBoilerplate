express = require('express')
router = express.Router()

# Main router middleware
router.use (req, res, next) ->
  next()

# Home
router.get '/home', (req, res) ->
  res.render 'pages/index',
    title: "Home"

module.exports = router
