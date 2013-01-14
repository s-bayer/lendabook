
/*
 * GET home page.
 */

exports.index = function(req, res){
  res.render('index', { title: 'Lend a book' });
};

exports.lend = function(req, res) {
	res.render('lend', {title: 'Lend a book'});
};