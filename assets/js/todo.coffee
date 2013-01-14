unless Array::filter
  Array::filter = (callback) ->
    element for element in this when callback(element)

# needed to work with minification
window.todoapp = angular.module 'todoapp', []
window.todoapp.controller 'TodoCtrl', [ '$scope', ($scope) ->

  $scope.books = (searchkey, location) -> [
    {title: 'Harry Potter und der Stein der Weisen', authors: ['Joanne K. Rowling'], isbn: '3-551-55167-7', location: 'Karlsruhe'},
    {title: 'Eragon', authors: ['Christopher Paolini'], isbn: '3-570-12803-2', location: 'Karlsruhe'}
  ]

  $scope.addBook = (title, authors, isbn, location) ->
    $scope.books.push {title: title, authors: authors, isbn: isbn, location: location}
]