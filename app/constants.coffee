###
Constants Class
###

class Constants

  constructor: ()->

  @err:
    # Catch all error - 400
    GENERAL_ERROR:
      message: "General error"
      code: 42
    # Internal error - most cases 500
    INTERNAL_ERROR:
      message: "Internal error"
      code: 300

###
Module exports
###
module.exports = Constants
