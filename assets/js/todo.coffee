unless Array::filter
  Array::filter = (callback) ->
    element for element in this when callback(element)

# needed to work with minification
window.todoapp = angular.module 'todoapp', []
window.todoapp.controller 'TodoCtrl', [ '$scope', ($scope) ->

  $scope.books = (searchkey, location) -> [
    {
    	title: 'Harry Potter und der Stein der Weisen'
    	authors: ['Joanne K. Rowling']
    	isbn: '3-551-55167-7'
    	location: 'Karlsruhe'
    	lender:
    		email: 'messmer@sunsteps.org'
    	image: 'http://lakritzplanet.files.wordpress.com/2010/01/lit_hp_stein.jpg'
    },
    {
    	title: 'Eragon'
    	authors: ['Christopher Paolini']
    	isbn: '3-570-12803-2'
    	location: 'Karlsruhe'
    	lender:
    		email: 'cominch@gmx.de'
    	image: 'http://1.bp.blogspot.com/-GhSiZp0aZ4Y/Tx72SUaMR0I/AAAAAAAAAMc/6QXkRY5R7M0/s1600/eragon1.jpg'
    }
  ]

  $scope.authorsToString = (array) ->
    array.reduce (x,y) -> x+", "+y

  $scope.addBook = (title, authors, isbn, location) ->
    $scope.books.push {title: title, authors: authors, isbn: isbn, location: location}
    
]

booksList = new List 'booksList',
  valueNames: ["title","isbn"]