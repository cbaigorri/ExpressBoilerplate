request = require('supertest')

# Bind the environment variables
dotenv = require('dotenv')
dotenv.config
  path: __dirname + '/../env/local/.env'

# Reference to the express app
api = require('../boilerplate.coffee').app


describe 'GET /', () ->
  it 'responded with json', (done) ->
    request(api)
      .get('/')
      .set('Accept', 'application/json')
      .expect('Content-Type', /json/)
      .expect(200, done)
