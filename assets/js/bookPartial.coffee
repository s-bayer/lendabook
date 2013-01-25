# needed to work with minification
window.bookapp.factory 'BookPartial', [ 'Facebook', (Facebook) ->

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

  updateLikeButton = (bookLiked, elem) ->
    if bookLiked
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

  updateLenderArea = (bookId, lenderId, elem) ->
    $(elem).find(".lenderImage").attr 'src', 'https://graph.facebook.com/'+lenderId+'/picture'
    Facebook.getCurrentUser (currentUser) ->
      $(elem).find(".borrowbtn").click () ->
        Facebook.lendingRequest bookId, lenderId
      $(elem).find(".deletebtn").click () ->
        BooksServer.remove bookId
      if lenderId==currentUser.id
        $(elem).find(".borrowbtn").hide()
        $(elem).find(".deletebtn").show()
      else
        $(elem).find(".deletebtn").hide()
        $(elem).find(".borrowbtn").show()    

  doUpdateBookPartial = (elem, likedBooks) ->
    bookId = $(elem).find(".bookId").text()
    lenderId = $(elem).find(".lender").text()
    ogUrl = 'http://www.lendabook.org/books/'+bookId
    updateLikeButton likedBooks[ogUrl]?, elem
    updateLenderArea bookId, lenderId, elem


  service = 
    updateBookPartial: (elem) ->
      Facebook.getLikedBooks (likedBooks)->
        doUpdateBookPartial elem, likedBooks

    updateAllBookPartials: ->
      Facebook.getLikedBooks (likedBooks)->
        $(".book").each (index,elem) ->
          doUpdateBookPartial elem, likedBooks

  # Return service
  return service
]