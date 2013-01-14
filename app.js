
/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes')
  , user = require('./routes/user')
  , http = require('http')
  , path = require('path')
  , Snockets = require('snockets')
  , http = require('http');

var snockets = new Snockets();
var app = express();

app.configure(function(){
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
  app.use(express.static(path.join(__dirname, 'public')));
  // Coffeescript
  app.use(require('connect-assets')());
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

app.get('/', routes.index);
app.get('/lend', routes.lend);

/*app.head('/js/todo.js', function(req, response) {
  var options = {method: 'GET', host: 'localhost', port: 3000, path: '/js/todo.js'};
  var request = http.request(options, function(result){
    console.log(JSON.stringify(result.headers));
    headers = result.headers;
    response.statusCode = result.statusCode

    response.writeHead(304,headers);
    response.end();
  });
  request.end();
});*/

http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));

  /*snockets.getCompiledChain('public/js/all.js', function(err, jsList){
    if(err) {
      console.log("ERROR: " + err);
    } else {
      console.log("Compiling " + jsList.length +" files.");
    }
  });*/
});
