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

exports.read = (req,res) ->
  book = Book.findById req.params.book, (err,book) ->
    if err
      res.json(404, {error: "Book not found"})
    else if book?
      res.render 'books/book', {book}
    else
      res.json(404, {error: "Book not found"})

exports.delete = (req, res) -> 
  Book.findById req.params.book, (err,book) ->
    if err
      res.json(404, {error: "Book not found"})
    else if book?
      book.remove()
      res.json
        success: true
    else
      res.json(404, {error: "Book not found"})

exports.bookauthor = (req,res) ->
  book = Book.findById req.params.book, (err,book) ->
    if err
      res.json(404, {error: "Book not found"})
    else if book?
      res.render 'books/bookauthor', {book}
    else
      res.json(404, {error: "Book not found"})
