app = require('express')()
http = require('http').Server app
io = require('socket.io')(http)
Game = require './models/game.coffee'

app.get '/', (req, res) ->
  res.sendfile 'index.html'

io.on 'connection', (socket) ->
  console.log 'user connected'


  socket.on 'newGame', (firstOption) ->
    initGame firstOption, () ->
      socket.emit 'gameLoad',
        choice: firstOption

  socket.on 'loadGame', (gameID) ->
    loadGame gameID, (currentOption) ->
      if currentOption is not null
        socket.emit 'gameLoad', {
          choice: game.currentOption
        }


  socket.on 'veto', (gameID, newChoice) ->
    vetoGame gameID, newChoice, () ->
      socket.emit 'newChoice', {
        newChoice: newChoice
      }


http.listen 3000, () ->
  console.log 'listening on 3000'

initGame = (firstOption, callback) ->
  game = new Game {
    previousChoices: []
    currentOption: ''
  }

  game.save (err) ->
    callback()

loadGame = (gameID, cb) ->
  Game.findOne({_id: gameID}, (err, game) ->
    cb game.currentOption
  )

vetoGame = (gameID, newChoice, cb) ->
  Game.findOne({_id: gameID}, (err, game) ->
    if game is not null
      if game.previousChoices.indexOf(newChoice) is -1
        game.previousChoices.push game.currentOption
        game.currentOption = newChoice
        game.save (err) ->
          cb newChoice
  )