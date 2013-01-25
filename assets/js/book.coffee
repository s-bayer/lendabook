# needed to work with minification
window.bookapp = angular.module 'bookapp', []
window.bookapp.controller 'SingleBookCtrl', [ '$scope', '$http', 'Facebook', 'BookPartial', ($scope, $http, Facebook, BookPartial) ->

  BookPartial.updateAllBookPartials()

]
  
