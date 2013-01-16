# The Book model
 
mongoose = require('mongoose')
Schema = mongoose.Schema
 
bookSchema = mongoose.Schema
  title: String
  authors: [String]
  isbn: String
  location: String
  lender:
    email: String
  image: String
  description: String

module.exports = mongoose.model 'Books', bookSchema  