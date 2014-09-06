Game = require './models/game.coffee'

module.exports = (io) ->
  io.on 'connection', (socket) ->
    console.log 'user connected'


    socket.on 'newGame', (firstOption) ->
      console.log('newGame gamed')
      initGame firstOption, (game) ->
        socket.emit 'gameLoad',
          gameId: game.id
          choice: firstOption
          previousChoices: null

    socket.on 'loadGame', (gameID) ->
      loadGame gameID, (game) ->
        if game is not null
          socket.emit 'gameLoad', {
            choice: game.currentOption
            previousChoices: game.previousChoices
          }


    socket.on 'veto', (gameID, newChoice) ->
      vetoGame gameID, newChoice, () ->
        socket.emit 'newChoice', {
          newChoice: newChoice
          previousChoices: game.previousChoices
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
    cb game
  )

vetoGame = (gameID, newChoice, cb) ->
  Game.findOne({_id: gameID}, (err, game) ->
    if game is not null
      if game.previousChoices.indexOf(newChoice) is -1
        game.previousChoices.push game.currentOption
        game.currentOption = newChoice
        game.save (err) ->
          cb game
  )