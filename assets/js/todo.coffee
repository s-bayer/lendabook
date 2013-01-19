unless Array::filter
  Array::filter = (callback) ->
    element for element in this when callback(element)

# needed to work with minification
window.bookapp = angular.module 'bookapp', []
window.bookapp.controller 'BookCtrl', [ '$scope', '$http', ($scope, $http) ->

  books = 
    listjs:(() -> 
      options = 
        item: 'book-item'
      new List 'book-list', options
    )()

    _updateLenderInformation: () ->
      $(".lend").each (index,elem) ->
        lenderId = $(elem).children(".lenderId").text()
        FB.api '/'+lenderId, (response)->
          $(elem).children(".lenderName").text(response.name)
          $(elem).children(".lenderImage").attr 'src', 'http://graph.facebook.com/'+lenderId+'/picture'
          $(elem).children(".btn").click () ->
            FB.ui
              method: 'send'
              name: 'Buch ausleihen'
              link: 'http://apps.facebook.com/lendabooktest'
              to: lenderId

    add: (book) ->
      # send book info via ajax
      $http.post("/books", {book: book}).
        success( (data, status) ->
          # TODO SB handle server side errors which return JSON
        ).
        error( (data, status) ->
          # TODO SB better error handling
          $scope.error += "error on POST: data: #{JSON.stringify(data)} status: #{status}"
          alert 'data: ' + JSON.stringify(data) + 'status: ' + status
        )
      # update view
      books.listjs.add prettifyBooks [$scope.newBook]
      books._updateLenderInformation()

  prettifyBooks= (inputBooks) ->
    inputBooks.map (v) ->
      v.authorsAsString = $scope.authorsToString(v.authors)
      v.imageTag = "<img src='#{v.image}', style='overflow: hidden; width: 100px', width='100'>"
      v.lenderId = v.lender
      v

  # TODO SB descriptions should not be to long or shortened client-side

  $scope.authorsToString = (array) ->
    array.reduce (x,y) -> x+", "+y

  $scope.addBook = () ->
    $scope.newBook.authors = [$scope.newBook.authors]
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
        books._updateLenderInformation()
    )
    .
    error( (data, status) ->
      # TODO SB better error handling
      alert 'data: ' + data + 'status: ' + status
    )

  # Load book data from google books
  window.test = (data) ->
    # alert JSON.stringify(data)

  url ='http://books.google.com/books?bibkeys=ISBN:0451526538&jscmd=viewapi&callback=window.test'
  $http.jsonp(url)

  window.fbAsyncInit = () ->
    # init the FB JS SDK
    FB.init
      appId      : '516801898340306' # App ID from the App Dashboard
      channelUrl : '//www.lendabook.org/channel' # Channel File for x-domain communication
      status     : true # check the login status upon init?
      cookie     : true # set sessions cookies to allow your server to access the session?
      xfbml      : true # parse XFBML tags on this page?
    FB.login (response) ->
      if response.authResponse
        #Success
        FB.api '/me', (response) ->
          $scope.user = response
          $scope.$apply()
      else
        alert "Not authorized"

  # Load Facebook plugin
  ((d, s, id) ->
    fjs = d.getElementsByTagName(s)[0]
    if !d.getElementById(id)
      js = d.createElement(s)
      js.id = id
      js.async = true
      js.src = "//connect.facebook.net/de_DE/all.js#xfbml=1&appId=516801898340306"
      fjs.parentNode.insertBefore(js, fjs)
  )(document, 'script', 'facebook-jssdk')
]
  
