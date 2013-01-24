# needed to work with minification
window.bookapp.factory 'Facebook', [ '$http', ($http) ->

  appId = '516801898340306'
  appNamespace = 'lend-it'

  fbApiInit = false
  fbLoggedIn = false

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
    ensureInit: (callback) ->
      if(!fbApiInit || !FB?)
        setTimeout((()->service.ensureInit(callback)), 50)
      else if callback?
        callback()
    ensureLoggedIn: (callback) ->
      service.ensureInit ->
        if !fbLoggedIn
          FB.login (response) ->
            if response.authResponse
              fbLoggedIn = true
              callback()
            else
              alert("Du musst die Anwendung akzeptieren, um diese Funktion auszuführen.")
          , {scope: 'publish_actions'}
        else
          callback()
    getCurrentUser: (callback) ->
      service.ensureInit -> FB.api '/me', callback
    getUser: (id,callback) ->
      service.ensureLoggedIn -> FB.api '/'+id, callback
    lendingRequest: (bookId, lenderId) ->
      service.ensureLoggedIn -> FB.ui {
        method: 'send'
        link: 'https://www.lendabook.org/books/'+ bookId
        to: lenderId
      }, (response) ->
        if(!response?)
          #User cancelled the dialog
        else if(!response.success? || !response.success)
          #Error
          alert("Error: "+JSON.stringify(response))
        else
          #Success, register opengraph action for borrowing
          FB.api '/me/'+appNamespace+':borrow', 'post', {book: "https://www.lendabook.org/books/"+bookId}, (response) ->
            displayIfError(response)
    offer: (bookId) ->
      service.ensureLoggedIn -> FB.api '/me/'+appNamespace+':offer', 'post', {book: "https://www.lendabook.org/books/"+bookId}, (response)->
        displayIfError(response)
    like: (bookId, callbacks) ->
      service.ensureLoggedIn -> FB.api '/me/og.likes', 'post', {object: "https://www.lendabook.org/books/"+bookId}, (response) ->
        displayIfError(response)
        callbacks.success(response)
    unlike: (likeId, callbacks) ->
      service.ensureLoggedIn -> FB.api likeId, 'delete', (response) ->
        displayIfError(response)
        callbacks.success(response)
    getLikedBooks: (callback)->
      service.ensureInit ->
        if fbLoggedIn
          FB.api '/me/og.likes?fields=data&app_id_filter='+appId, (queryResult) ->
            displayIfError(queryResult)
            result = {}
            result[elem.data.object.url] = elem.id for elem in queryResult.data
            callback result
        else
          callback []

  # Return service
  return service
]