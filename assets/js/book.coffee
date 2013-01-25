# needed to work with minification
window.bookapp = angular.module 'bookapp', []
window.bookapp.controller 'SingleBookCtrl', [ '$scope', 'BookPartial', ($scope, BookPartial) ->

  BookPartial.updateAllBookPartials()

]
  
