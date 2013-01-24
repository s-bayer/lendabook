unless Array::filter
  Array::filter = (callback) ->
    element for element in this when callback(element)

# needed to work with minification
window.bookapp = angular.module 'bookapp', []
window.bookapp.controller 'BookCtrl', [ '$scope', '$http', 'Facebook', 'BooksServer', ($scope, $http, Facebook, BooksServer) ->

  books = 
    listjs:(() -> 
      options = 
        item: 'book-item'
        page: 6
      new List 'book-list', options
    )()

    updateLenderInformation: () ->
      Facebook.getCurrentUser (currentUser) ->
        Facebook.getLikedBooks (likedBooks)->
          $(".book").each (index,elem) ->
            bookId = $(elem).find(".bookId").text()
            lenderId = $(elem).find(".lenderId").text()
            ogUrl = 'http://www.lendabook.org/books/'+bookId
            if likedBooks[ogUrl]?
              $(elem).find(".like").hide()
              $(elem).find(".unlike").show()
            else
              $(elem).find(".unlike").hide()
              $(elem).find(".like").show()
            $(elem).find(".like").click () ->
              Facebook.like bookId,
                success: ->
                  $(elem).find(".like").hide()
                  $(elem).find(".unlike").show()
            $(elem).find(".unlike").click () ->
              Facebook.getLikedBooks (likedBooks) ->
                Facebook.unlike likedBooks[ogUrl],
                  success: ->
                    $(elem).find(".unlike").hide()
                    $(elem).find(".like").show()
            $(elem).find(".lenderImage").attr 'src', 'https://graph.facebook.com/'+lenderId+'/picture'
            $(elem).find(".borrowbtn").click () ->
              Facebook.lendingRequest bookId, lenderId
            $(elem).find(".deletebtn").click () ->
              booksServer.remove bookId
            if lenderId==currentUser.id
              $(elem).find(".borrowbtn").hide()
              $(elem).find(".deletebtn").show()
            else
              $(elem).find(".deletebtn").hide()
              $(elem).find(".borrowbtn").show()

    add: (book, callback) ->
      booksServer.add book,
        success: (data) ->
          $scope.newBook._id = data.ETag.id
          Facebook.offer $scope.newBook._id, (err)->
            #TODO Replace following block by the following commented block
            books.listjs.add prettifyBooks [$scope.newBook]
            books.updateLenderInformation()
            callback()
            #booksServer.remove data.ETag.id
            #alert "Eintragen des Buches fehlgeschlagen. Ist das Coverbild korrekt gesetzt?"
          , () -> #Success
            books.listjs.add prettifyBooks [$scope.newBook]
            books.updateLenderInformation()
            callback()

  prettifyBooks= (inputBooks) ->
    inputBooks.map (v) ->
      v.imageTag = "<img src='#{v.image}', style='overflow: hidden; width: 100px', width='100'>"
      v.lenderId = v.lender
      v.bookId = v._id
      v

  $scope.showMoreBooks = () ->
    books.listjs.show(0,200)
    $('#moreBooks').hide()

  # TODO SB descriptions should not be to long or shortened client-side

  $scope.addBookModal = () ->
    Facebook.ensureLoggedIn ->
      $('#addBook').modal 'show'

  $scope.addBook = () ->
    $scope.newBook.lender = $scope.user.id
    $scope.newBook.lenderName = $scope.user.first_name
    books.add $scope.newBook, ->
      $scope.newBook = {}

  $scope.OnTitleChange = () ->

  # Load books via ajax and load them into list-js
  BooksServer.getAllBooks
    success: (data) ->
      books.listjs.add prettifyBooks data
      books.updateLenderInformation()      
    error: (error) ->
      alert("Error: "+error)

  # Load book data from google books
  # window.test = (data) ->
    # alert JSON.stringify(data)

  # url = 'https://books.google.com/books?bibkeys=ISBN:0451526538&jscmd=viewapi&callback=window.test'
  # $http.jsonp(url)

  Facebook.getCurrentUser (user) ->
    $scope.user = user
    $scope.$apply()
]
  
