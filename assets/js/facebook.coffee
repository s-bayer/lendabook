# needed to work with minification
window.bookapp.factory 'Facebook', [ '$http', ($http) ->

  appId = '516801898340306'

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
      appId      : appId # App ID from the App Dashboard
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

  displayIfError = (response) ->
    if(!response?)
      alert "Error: No response"
    else if(response.error?)
      alert "Error: "+JSON.stringify(response.error)

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
        displayIfError(response)
    like: (bookId, callbacks) ->
      ensureInit -> FB.api '/me/og.likes', 'post', {object: "http://www.lendabook.org/og/books/"+bookId}, (response) ->
        displayIfError(response)
        callbacks.success(response)
    unlike: (likeId, callbacks) ->
      ensureInit -> FB.api likeId, 'delete', (response) ->
        displayIfError(response)
        callbacks.success(response)
    getLikedBooks: (callback)->
      ensureInit -> FB.api '/me/og.likes?fields=data&app_id_filter='+appId, (queryResult) ->
        displayIfError(queryResult)
        result = {}
        result[elem.data.object.url] = elem.id for elem in queryResult.data
        callback result

  # Return service
  return service
]