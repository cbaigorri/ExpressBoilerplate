cluster = require('cluster')

PORT = +process.env.PORT || 5000
numCPUs = require('os').cpus().length

exceptionHandler = (err) ->
  try
    # try to send an email about what went wrong
    # logger.catastrophe err

    # Kill the app after 30 seconds
    killTimer = setTimeout () ->
      process.exit(1)
    , 30000
    killTimer.unref()

    # disconnect the worker
    console.log "Worker process", cluster.worker.uniqueID, "suicide..."
    cluster.worker.disconnect()
  catch err2
    logger.error 'Error disconnecting', err2


if cluster.isMaster

  # workers
  i = 0
  while i < numCPUs
    cluster.fork()
    i++

  cluster.on 'disconnect', (worker) ->
    console.error 'Worker disconnected', worker.uniqueID
    cluster.fork()

else

  logger.info 'Worker process initiated', cluster.worker.uniqueID

  cluster.worker.process.on 'uncaughtException', exceptionHandler

  api = require('./rest')
  api.on 'error', exceptionHandler
