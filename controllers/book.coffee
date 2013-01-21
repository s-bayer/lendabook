Book = require '../models/book.js'

exports.list = (req, res) ->
  Book.find (err, books) ->
    if (err)
      res.json({error: 'Could not get books'})
    else
      res.json(books)

exports.create = (req, res) ->
  book = new Book(req.body.book)
  id = book._id
  book.save()
  # required by rest
  res.json
    ETag:
      id: "#{id}"
      uri: "http://#{req.header('host')}#{req.url}"
      type: "book"

exports.delete = (req, res) ->
  console.log("PAram: "+req.params.book)
  Book.findById req.params.book, (err,book) ->
    console.log("Err: "+err)
    console.log("Book: "+book)
    if err
      res.json(404, {error: "Book not found"})
    else if book?
      book.remove()
      res.json
        success: true
    else
      res.json(404, {error: "Book not found"})