Game = require './models/game.coffee'
secrets = require './config/secrets'
yelp = require 'yelp'

yelpClient = yelp.createClient secrets.yelp

module.exports = (io) ->
  io.on 'connection', (socket) ->
    console.log 'user connected'


    socket.on 'newGame', (firstOption) ->
      console.log('newGame gamed')
      initGame firstOption, (game) ->
        socket.join game.id
        socket.emit 'gameLoad',
          gameId: game.id
          choice: firstOption
          previousChoices: null

    socket.on 'loadGame', (gameID) ->
      loadGame gameID , (game) ->
        socket.join game.id
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
        socket.to(gameID).broadcast.emit('newChoice', gameObj);

    socket.on 'yelp', (location) ->
      location = location || 'Ann Arbor'
      yelpClient.search {term: 'food', location: location}, (err,data) ->
        console.log data
        socket.emit 'yelpData', data

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