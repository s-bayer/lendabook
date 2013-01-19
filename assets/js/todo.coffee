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
    },
    {
      title: 'The New Business Road Test'
      authors: ['John W. Mullins']
      isbn: '0-273-70805-8'
      location: 'Karlsruhe'
      lender:
        email: 'cie@kit.edu'
      image: 'http://imgv2-4.scribdassets.com/img/word_document/80290047/255x300/814797a85c/1341953356'
      description: 'Give your business the chance to be one of those that make it.'
    }
  ]

  $scope.books = (searchkey, location) ->
    $scope.staticBooks

  $scope.authorsToString = (array) ->
    array.reduce (x,y) -> x+", "+y

  $scope.addBook = () ->
    $scope.newBook.authors = [$scope.newBook.authors]
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

  $scope.OnTitleChange = () ->


  prettifyBooks = (books) ->
    result = books.map (v) ->
      v.authorsAsString = $scope.authorsToString(v.authors)
      v.imageTag = "<img src='#{v.image}', style='overflow: hidden; width: 100px', width='100'>"
      v.lend = "<a class='btn btn-success pull-right', href='mailto:#{v.lender.email}'> Lend now </a>"
      v
    result

  # Add books to list-js
  addBooksToListJs = (books) ->
    $scope.staticBooks = books
    $scope.booksList.add prettifyBooks $scope.staticBooks

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
          $scope.username = response.name
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
  
