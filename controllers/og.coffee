Book = require '../models/book.js'

exports.book = (req,res) ->
  book = Book.findById req.params.book, (err,book) ->
    if err
      res.json(404, {error: "Book not found"})
    else if book?
      res.render 'og/book', {book}
    else
      res.json(404, {error: "Book not found"})

###exports.bookimage = (req,res) ->
  book = Book.findById req.params.book, (err,book) ->
    if err
      res.json 404,
        error: "Book not found"
    else if book?
      res.set('Content-Type', 'image/png');
      base64Image = book.image.replace(/^data:image\/jpeg;base64,/,"")
      console.log(base64Image)
      decodedImage = new Buffer(base64Image, 'base64')
      res.send(decodedImage)
    else
      res.json 404,
        error: "Book not found"###