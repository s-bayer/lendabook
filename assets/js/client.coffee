unless Array::filter
  Array::filter = (callback) ->
    element for element in this when callback(element)

# needed to work with minification
window.bookapp = angular.module 'bookapp', []
window.bookapp.controller 'BookCtrl', [ '$scope', '$http', 'Facebook', ($scope, $http, Facebook) ->

  books = 
    listjs:(() -> 
      options = 
        item: 'book-item'
      new List 'book-list', options
    )()

    updateLenderInformation: () ->
      Facebook.getCurrentUser (currentUser) ->
        Facebook.getLikedBooks (likedBooks)->
          $(".book").each (index,elem) ->
            bookId = $(elem).find(".bookId").text()
            lenderId = $(elem).find(".lenderId").text()
            ogUrl = 'http://www.lendabook.org/og/books/'+bookId
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
            Facebook.getUser lenderId, (lender)->
              $(elem).find(".lenderName").text(lender.name)
              $(elem).find(".lenderImage").attr 'src', 'http://graph.facebook.com/'+lender.id+'/picture'
              $(elem).find(".borrowbtn").click () ->
                Facebook.lendingRequest bookId, lender.id
              $(elem).find(".deletebtn").click () ->
                books.delete(bookId)
              if lender.id==currentUser.id
                $(elem).find(".borrowbtn").hide()
                $(elem).find(".deletebtn").show()
              else
                $(elem).find(".deletebtn").hide()
                $(elem).find(".borrowbtn").show()

    add: (book) ->
      # send book info via ajax
      $http.post("/books", {book: book}).
        success( (data, status) ->
          Facebook.offer data.ETag.id
        ).
        error( (data, status) ->
          # TODO SB better error handling
          $scope.error += "error on POST: data: #{JSON.stringify(data)} status: #{status}"
          alert 'data: ' + JSON.stringify(data) + 'status: ' + status
        )
      # update view
      books.listjs.add prettifyBooks [$scope.newBook]
      books.updateLenderInformation()

    delete: (bookId) ->
      $http.delete("/books/"+bookId).
        success( (data,status) ->
          #Success
        ).error( (data,status) ->
          # TODO SB better error handling
          $scope.error += "error on POST: data: #{JSON.stringify(data)} status: #{status}"
          alert 'data: ' + JSON.stringify(data) + 'status: ' + status 
        )

  prettifyBooks= (inputBooks) ->
    inputBooks.map (v) ->
      v.imageTag = "<img src='#{v.image}', style='overflow: hidden; width: 100px', width='100'>"
      v.lenderId = v.lender
      v.bookId = v._id
      v

  # TODO SB descriptions should not be to long or shortened client-side

  $scope.addBook = () ->
    $scope.newBook.lender = $scope.user.id
    books.add($scope.newBook)

  $scope.OnTitleChange = () ->

  # Load books via ajax and load them into list-js
  $http.get("/books").
    success( (data, status) ->
      # TODO SB handle server side errors which return JSON
      if(data.error)
        alert 'Something went wrong. Please contact us.'
      else
        books.listjs.add prettifyBooks data
        books.updateLenderInformation()
    )
    .
    error( (data, status) ->
      # TODO SB better error handling
      alert 'data: ' + data + 'status: ' + status
    )

  # Load book data from google books
  window.test = (data) ->
    # alert JSON.stringify(data)

  url = 'http://books.google.com/books?bibkeys=ISBN:0451526538&jscmd=viewapi&callback=window.test'
  $http.jsonp(url)

  Facebook.getCurrentUser (user) ->
    $scope.user = user
    $scope.$apply()
]
  
