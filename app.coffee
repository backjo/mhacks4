express = require('express')
app = express()
http = require('http').Server app
io = require('socket.io')(http)
sockets = require('./socket')(io)
mongoose = require 'mongoose'
Game = require './models/game.coffee'
app.use(express.static(__dirname + '/public'))

mongoose.connect 'mongodb://localhost/mhacks'

http.listen 3000, () ->
  console.log 'listening on 3000'



