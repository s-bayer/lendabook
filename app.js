// Generated by CoffeeScript 1.3.3
(function() {
  var Snockets, app, books, express, http, mongoose, path, routes, snockets;

  express = require('express');

  routes = require('./routes');

  http = require('http');

  path = require('path');

  Snockets = require('snockets');

  http = require('http');

  mongoose = require('mongoose');

  snockets = new Snockets();

  app = express();

  mongoose.connect(process.env.MONGOHQ_URL);

  app.configure(function() {
    app.set('port', process.env.PORT || 3000);
    app.set('views', __dirname + '/views');
    app.set('view engine', 'jade');
    app.use(express.favicon());
    app.use(express.logger('dev'));
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express.cookieParser('your secret here'));
    app.use(express.session());
    app.use(app.router);
    app.use(express["static"](path.join(__dirname, 'public')));
    return app.use(require('connect-assets')());
  });

  app.configure('development', function() {
    return app.use(express.errorHandler());
  });

  app.get('/', routes.index);

  app.post('/facebook', routes.facebook);

  app.get('/facebook', routes.facebook);

  app.get('/channel', routes.fbchannel);

  books = require('./controllers/book.js');

  app.get('/books', books.list);

  app.post('/books', books.create);

  process.on('SIGTERM', function() {
    console.log("Closing app...");
    return app.close();
  });

  app.on('close', function() {
    console.log('Closing mongoDB connection');
    return mongoose.connection.close();
  });

  http.createServer(app).listen(app.get('port'), function() {
    return console.log("Express server listening on port " + app.get('port'));
  });

}).call(this);
