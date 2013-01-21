# needed to work with minification
window.bookapp.factory 'Facebook', [ '$http', ($http) ->

  fbApiInit = false
  ensureInit = (callback) ->
    if(!fbApiInit || !FB?)
      setTimeout((()->ensureInit(callback)), 50)
    else if callback?
      callback()

  # Init facebook
  window.fbAsyncInit = () ->
    # init the FB JS SDK
    FB.init
      appId      : '516801898340306' # App ID from the App Dashboard
      channelUrl : '//www.lendabook.org/channel' # Channel File for x-domain communication
      status     : true # check the login status upon init?
      cookie     : true # set sessions cookies to allow your server to access the session?
      xfbml      : true # parse XFBML tags on this page?
    FB.getLoginStatus (status) ->
      fbApiInit = true
    FB.login (response) ->
      if response.authResponse
        #Success
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

  service = 
    getCurrentUser: (callback) ->
      ensureInit -> FB.api '/me', callback
    getUser: (id,callback) ->
      ensureInit -> FB.api '/'+id, callback
    lendingRequest: (bookId, lenderId) ->
      ensureInit -> FB.ui
          method: 'send'
          link: 'http://www.lendabook.org/og/books/'+ bookId
          to: lenderId
    offer: (bookId) ->
      ensureInit -> FB.api '/me/lendabooktest:offer', 'post', {book: "http://www.lendabook.org/og/books/"+bookId}, (response)->
          alert(JSON.stringify(response))

  # Return service
  return service
]