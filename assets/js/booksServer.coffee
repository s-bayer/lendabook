# needed to work with minification
window.bookapp.factory 'BooksServer', [ '$http', ($http) ->

  #The callbacks parameter should be a JSON object with two entries: success and error
  # success: function(result of request)
  # error: function(error object)
  # It's always possible to ignore one or both of the parameter. Then the default implementation is used.
  # The default implementation of success does nothing, the default implementation of error shows an alert.

  callSuccess = (data, callbacks) ->
    if(callbacks? && callbacks.success?)
      callbacks.success data
  callError = (data, callbacks) ->
    if(callbacks? && callbacks.error?)
      callbacks.error data
    else
      alert "Error: "+JSON.stringify(data)

  service = 
    getAllBooks: (callbacks) ->
      $http.get("/books").
        success( (data, status) ->
          # TODO SB handle server side errors which return JSON
          if(data.error)
            callError data,callbacks
          else
            callSuccess data,callbacks
        )
        .
        error( (data, status) ->
          callError data,callbacks
        )

    remove: (bookId, callbacks) ->
      $http.delete("/books/"+bookId).
        success( (data,status) ->
          callSuccess data,callbacks
        ).error( (data,status) ->
          callError data,callbacks
        )

    add: (book, callbacks) ->
      $http.post("/books", {book}).
        success( (data, status) ->
          callSuccess data, callbacks
        ).
        error( (data, status) ->
          callError data, callbacks
        )

  # Return service
  return service
]