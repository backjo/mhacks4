mongoose = require 'mongoose'
ShortId = require 'mongoose-shortid'

gameSchema = new mongoose.Schema
  _id:
    type: ShortId,
    len: 5,
    base: 64,
    alphabet: undefined
    retries: 4
  previousChoices: Array
  currentOption: ''

Game = mongoose.model 'Game', gameSchema

module.exports = Game