Book = require '../models/book.js'

exports.list = (req, res) ->
  Book.find (err, books) ->
    if (err)
      res.json({error: 'Could not get books'})
    else
      res.json(books)