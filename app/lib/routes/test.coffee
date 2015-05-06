express = require('express')
router = express.Router()

# Error test route
router.get '/error', (req, res, next) ->
  ee = new (require('events').EventEmitter)
  setTimeout ()->
    # ee.emit 'error', 'This should break it EE!!!.'
    # throw new Error('This should break.')
    # next( throw new Error('This should break.') )
    next( new Error('This should break.') ) # doesn't break - needs to be thrown to cause an exception
    # flerb.bark()

module.exports = router
