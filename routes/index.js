// Generated by CoffeeScript 1.3.3
(function() {
  var mongoose;

  mongoose = require('mongoose');

  exports.index = function(req, res) {
    return res.render('index', {
      title: 'Lend a book'
    });
  };

  exports.facebook = function(req, res) {
    return res.render('facebook', {
      title: 'Lend a book'
    });
  };

  exports.fbchannel = function(req, res) {
    return res.render('channel');
  };

  exports.impressum = function(req, res) {
    return res.render('impressum', {
      title: 'Lend a book'
    });
  };

  exports.books = function(Book) {
    return function(req, res) {
      return Book.find(function(err, books) {
        if (err) {
          return res.json({
            error: 'Could not get books'
          });
        } else {
          return res.json(books);
        }
      });
    };
  };

  /*
  exports.book = (req, res) ->
    res.render 'index', { title: 'Lend a book' }
  */


}).call(this);
