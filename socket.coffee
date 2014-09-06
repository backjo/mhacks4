Game = require './models/game.coffee'

module.exports = (io) ->
  io.on 'connection', (socket) ->
    console.log 'user connected'


    socket.on 'newGame', (firstOption) ->
      console.log('newGame gamed')
      initGame firstOption, (game) ->
        socket.emit 'gameLoad',
          gameId: game._id
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

initGame = (firstOption, callback) ->
  game = new Game {
    previousChoices: []
    currentOption: firstOption
  }

  game.save (err) ->
    console.log err
    callback game

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