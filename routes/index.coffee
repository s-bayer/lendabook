mongoose = require 'mongoose'

# GET home page.
exports.index = (req, res) ->
  res.render 'index', { title: 'Lend a book' }

exports.facebook = (req, res) ->
  res.render 'facebook', { title: 'Lend a book' }

exports.fbchannel = (req, res) ->
  res.render 'channel'

exports.impressum = (req,res) ->
  res.render 'impressum', { title: 'Lend a book' }
  
###
exports.book = (req, res) ->
  res.render 'index', { title: 'Lend a book' }
###