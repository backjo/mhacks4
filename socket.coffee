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
      debugger;
      loadGame gameID , (game) ->
        console.log('callback called')
        console.log(game)
        if game
          console.log('game exists')
          socket.emit 'gameLoad', {
            gameId: game.id
            choice: game.currentOption
            previousChoices: game.previousChoices
          }


    socket.on 'veto', (gameID, newChoice) ->
      vetoGame gameID, newChoice, (game) ->
        gameObj = {
          newChoice: newChoice
          previousChoices: game.previousChoices
        }
        socket.emit 'newChoice', gameObj
        socket.broadcast.emit 'newChoice', gameObj

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
    console.log(game)
    cb game
  )

vetoGame = (gameID, newChoice, cb) ->
  Game.findOne({_id: gameID}, (err, game) ->
    if game
      if game.previousChoices.indexOf(newChoice) is -1
        game.previousChoices.push game.currentOption
        game.currentOption = newChoice
        game.save (err) ->
          cb game
  )