# needed to work with minification
window.bookapp.factory 'Analytics', [ '$http', ($http) ->


  service =
    trackShowAddBookDialog: ->
      _gaq.push ['_trackEvent', 'UI', 'ShowAddBookDialog']
    trackOffer: (isbn) ->
      _gaq.push ['_trackEvent', 'Books', 'Offer', isbn]
    trackShowBorrowRequestDialog: (isbn) ->
      _gaq.push ['_trackEvent', 'Books', 'CancelledLendingRequest', isbn]
    trackBorrowRequest: (isbn) ->
      _gaq.push ['_trackEvent', 'Books', 'LendingRequest', isbn]
    trackBookDeletion: (isbn) ->
      _gaq.push ['_trackEvent', 'Books', 'Delete', isbn]
    trackLikeBook: (isbn) ->
      _gaq.push ['_trackEvent', 'Books', 'LikeObject', isbn]
    trackUnlikeBook: (isbn) ->
      _gaq.push ['_trackEvent', 'Books', 'UnlikeObject', isbn]
    trackShowMoreBooks: () ->
      _gaq.push ['_trackEvent', 'UI', 'ShowMoreBooks']
    trackShowAuthRequest: () ->
      _gaq.push ['_trackEvent', 'FB', 'ShowAuthRequest']
    trackAcceptAuthRequest: () ->
      _gaq.push ['_trackEvent', 'FB', 'AcceptAuthRequest']
    trackDenyAuthRequest: () ->
      _gaq.push ['_trackEvent', 'FB', 'DenyAuthRequest']


  # Return service
  return service
]