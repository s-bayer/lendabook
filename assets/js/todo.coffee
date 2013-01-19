unless Array::filter
  Array::filter = (callback) ->
    element for element in this when callback(element)

# needed to work with minification
window.todoapp = angular.module 'todoapp', []
window.todoapp.controller 'TodoCtrl', [ '$scope', '$http', ($scope, $http) ->
  options =
    item: 'book-item'
  $scope.booksList = new List 'book-list', options

  # TODO SB descriptions should not be to long or shortened client-side

  $scope.books = (searchkey, location) ->
    $scope.staticBooks

  $scope.authorsToString = (array) ->
    array.reduce (x,y) -> x+", "+y

  updateLenderInformation = () ->
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


  $scope.addBook = () ->
    $scope.newBook.authors = [$scope.newBook.authors]
    $scope.newBook.lender = $scope.user.id
    # send book info via ajax
    $http.post("/books", {book: $scope.newBook}).
      success( (data, status) ->
        # TODO SB handle server side errors which return JSON
        addBooksToListJs(data)
      ).
      error( (data, status) ->
        # TODO SB better error handling
        $scope.error += "error on POST: data: #{JSON.stringify(data)} status: #{status}"
        alert 'data: ' + JSON.stringify(data) + 'status: ' + status
      )
    # update view
    $scope.booksList.add prettifyBooks [$scope.newBook]
    $scope.staticBooks.push $scope.newBook
    updateLenderInformation()

  $scope.OnTitleChange = () ->


  prettifyBooks = (books) ->
    result = books.map (v) ->
      v.authorsAsString = $scope.authorsToString(v.authors)
      v.imageTag = "<img src='#{v.image}', style='overflow: hidden; width: 100px', width='100'>"
      v.lenderId = v.lender
      v
    result

  # Add books to list-js
  addBooksToListJs = (books) ->
    $scope.staticBooks = books
    $scope.booksList.add prettifyBooks $scope.staticBooks
    updateLenderInformation()

  # Load books via ajax and load them into list-js
  $http.get("/books").
    success( (data, status) ->
      # TODO SB handle server side errors which return JSON
      if(data.error)
        alert 'Something went wrong. Please contact us.'
      else
        addBooksToListJs(data)
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
    # Additional initialization code such as adding Event Listeners goes here
    FB.login (response) ->
      if response.authResponse
        #Success
        FB.api '/me', (response) ->
          $scope.user = response
          $scope.$apply()
      else
        alert "Not authorized"

  # Load Facebook plugin
  fbinit = (d, s, id) ->
    fjs = d.getElementsByTagName(s)[0]
    if !d.getElementById(id)
      js = d.createElement(s)
      js.id = id
      js.async = true
      js.src = "//connect.facebook.net/de_DE/all.js#xfbml=1&appId=516801898340306"
      fjs.parentNode.insertBefore(js, fjs)

  fbinit document, 'script', 'facebook-jssdk'
]
  
