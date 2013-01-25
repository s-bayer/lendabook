# The Book model
 
mongoose = require('mongoose')
Schema = mongoose.Schema
 
bookSchema = mongoose.Schema
  title: String
  author: String
  isbn: String
  location: String
  lender: String
  lenderName: String
  image: String
  description: String

module.exports = mongoose.model 'Books', bookSchema  