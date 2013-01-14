unless Array::filter
  Array::filter = (callback) ->
    element for element in this when callback(element)

# needed to work with minification
window.todoapp = angular.module 'todoapp', []
window.todoapp.controller 'TodoCtrl', [ '$scope', ($scope) ->
  options =
    item: 'book-item'
  $scope.booksList = new List 'book-list', options

  # TODO SB descriptions should not be to long or shortened client-side
  $scope.staticBooks = [
    {
      title: 'Harry Potter und der Stein der Weisen'
      authors: ['Joanne K. Rowling']
      isbn: '3-551-55167-7'
      location: 'Karlsruhe'
      lender:
        email: 'messmer@sunsteps.org'
      image: 'http://lakritzplanet.files.wordpress.com/2010/01/lit_hp_stein.jpg'
      description: 'Harry Potter erkennt, dass er kein normaler Junge ist, sondern Zauberkräfte hat und kommt auf die Zauberschule.'
    },
    {
      title: 'Eragon'
      authors: ['Christopher Paolini']
      isbn: '3-570-12803-2'
      location: 'Karlsruhe'
      lender:
        email: 'cominch@gmx.de'
      image: 'http://1.bp.blogspot.com/-GhSiZp0aZ4Y/Tx72SUaMR0I/AAAAAAAAAMc/6QXkRY5R7M0/s1600/eragon1.jpg'
      description: 'Irgendwas mit einem Drachen, ziemlich viel Fantasy.'
    }
  ]

  $scope.books = (searchkey, location) ->
    $scope.staticBooks

  $scope.authorsToString = (array) ->
    array.reduce (x,y) -> x+", "+y

  $scope.addBook = () ->
    alert "bla"
    $scope.newBook.authors = [$scope.newBook.authors]
    $scope.staticBooks.push $scope.newBook

  prettifiedBooks = () ->
    result = $scope.staticBooks.map (v) ->
      v.authorsAsString = $scope.authorsToString(v.authors)
      v
    result

  # Add books to list-js
  $scope.booksList.add prettifiedBooks()

]
  
