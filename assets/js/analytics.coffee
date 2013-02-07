# needed to work with minification
window.bookapp.factory 'Analytics', [ '$http', ($http) ->

  lastEventWasSearching = false

  service =
    trackSearching: ->
      if !lastEventWasSearching
        _gaq.push ['_trackEvent', 'UI', 'SearchBook']
        lastEventWasSearching = true
    trackShowAddBookDialog: ->
      lastEventWasSearching = false
      _gaq.push ['_trackEvent', 'UI', 'ShowAddBookDialog']
    trackOffer: (isbn) ->
      lastEventWasSearching = false
      _gaq.push ['_trackEvent', 'Books', 'Offer', isbn]
    trackShowBorrowRequestDialog: (isbn) ->
      lastEventWasSearching = false
      _gaq.push ['_trackEvent', 'Books', 'CancelledLendingRequest', isbn]
    trackBorrowRequest: (isbn) ->
      lastEventWasSearching = false
      _gaq.push ['_trackEvent', 'Books', 'LendingRequest', isbn]
    trackBookDeletion: (isbn) ->
      lastEventWasSearching = false
      _gaq.push ['_trackEvent', 'Books', 'Delete', isbn]
    trackLikeBook: (isbn) ->
      lastEventWasSearching = false
      _gaq.push ['_trackEvent', 'Books', 'LikeObject', isbn]
    trackUnlikeBook: (isbn) ->
      lastEventWasSearching = false
      _gaq.push ['_trackEvent', 'Books', 'UnlikeObject', isbn]
    trackShowMoreBooks: () ->
      lastEventWasSearching = false
      _gaq.push ['_trackEvent', 'UI', 'ShowMoreBooks']
    trackShowAuthRequest: () ->
      lastEventWasSearching = false
      _gaq.push ['_trackEvent', 'FB', 'ShowAuthRequest']
    trackAcceptAuthRequest: () ->
      lastEventWasSearching = false
      _gaq.push ['_trackEvent', 'FB', 'AcceptAuthRequest']
    trackDenyAuthRequest: () ->
      lastEventWasSearching = false
      _gaq.push ['_trackEvent', 'FB', 'DenyAuthRequest']


  # Return service
  return service
]