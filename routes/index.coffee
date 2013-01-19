mongoose = require 'mongoose'

# GET home page.
exports.index = (req, res) ->
  res.render 'index', { title: 'Lend a book' }

exports.fbchannel = (req, res) ->
  res.render 'channel'

# GET all books
exports.books = (Book) ->
  (req, res) ->
    Book.find (err, books) ->
      if (err)
        res.json({error: 'Could not get books'})
      else
        res.json(books)
  
###
exports.book = (req, res) ->
  res.render 'index', { title: 'Lend a book' }
###