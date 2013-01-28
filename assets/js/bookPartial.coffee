# needed to work with minification
window.bookapp.factory 'BookPartial', [ 'Facebook', 'BooksServer', 'Analytics', (Facebook, BooksServer, Analytics) ->

  #The callbacks parameter should be a JSON object with two entries: success and error
  # success: function(result of request)
  # error: function(error object)
  # It's always possible to ignore one or both of the parameter. Then the default implementation is used.
  # The default implementation of success does nothing, the default implementation of error shows an alert.

  # TODO Dry out callSuccess, callError (is also in other JS files)
  callSuccess = (data, callbacks) ->
    if(callbacks? && callbacks.success?)
      callbacks.success data
  callError = (data, callbacks) ->
    if(callbacks? && callbacks.error?)
      callbacks.error data
    else
      alert "Error: "+JSON.stringify(data)

  getBookOgUrl = (bookId) -> 'http://www.lendabook.org/books/'+bookId

  updateLikeButton = (bookLiked, elem) ->
    bookId = $(elem).find(".bookId").text()
    isbn = $(elem).find(".isbn").text()
    if bookLiked
      $(elem).find(".like").hide()
      $(elem).find(".unlike").show()
    else
      $(elem).find(".unlike").hide()
      $(elem).find(".like").show()
    $(elem).find(".like").click () ->
      Analytics.trackLikeBook isbn
      Facebook.like bookId,
        success: ->
          $(elem).find(".like").hide()
          $(elem).find(".unlike").show()
    $(elem).find(".unlike").click () ->
      Analytics.trackUnlikeBook isbn
      Facebook.getLikedBooks (likedBooks) ->
        Facebook.unlike likedBooks[getBookOgUrl(bookId)],
          success: ->
            $(elem).find(".unlike").hide()
            $(elem).find(".like").show()

  updateLenderArea = (elem, removefunc) ->
    bookId = $(elem).find(".bookId").text()
    lenderId = $(elem).find(".lender").text()
    isbn = $(elem).find(".isbn").text()
    Facebook.getProfilePicture lenderId, (pictureUrl)->
      $(elem).find(".lenderImage").attr 'src', pictureUrl
    Facebook.getCurrentUser (currentUser) ->
      $(elem).find(".borrowbtn").click () ->
        Facebook.lendingRequest bookId, lenderId,
          sent: ->
            Analytics.trackBorrowRequest isbn
          cancelled: ->
            Analytics.trackCancelledBorrowRequest isbn
      $(elem).find(".deletebtn").click () ->
        Analytics.trackBookDeletion isbn
        BooksServer.remove bookId
        removefunc bookId
      if lenderId==currentUser.id
        $(elem).find(".borrowbtn").hide()
        $(elem).find(".deletebtn").show()
      else
        $(elem).find(".deletebtn").hide()
        $(elem).find(".borrowbtn").show()    

  doUpdateBookPartial = (elem, likedBooks, removefunc) ->
    bookId = $(elem).find(".bookId").text()
    updateLikeButton likedBooks[getBookOgUrl(bookId)]?, elem
    updateLenderArea elem, removefunc


  service = 
    updateBookPartial: (elem,removefunc) ->
      Facebook.getLikedBooks (likedBooks)->
        doUpdateBookPartial elem, likedBooks, removefunc

    updateAllBookPartials: (removefunc)->
      Facebook.getLikedBooks (likedBooks)->
        $(".book").each (index,elem) ->
          doUpdateBookPartial elem, likedBooks, removefunc

  # Return service
  return service
]