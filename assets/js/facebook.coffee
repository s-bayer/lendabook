# needed to work with minification
window.bookapp.factory 'Facebook', [ '$http', ($http) ->

  appId = '516801898340306'
  appNamespace = 'lend-it'

  fbApiInit = false
  fbUserAvailable = false
  fbAppAuthorized = false

  # Init facebook
  window.fbAsyncInit = ->
    # init the FB JS SDK
    FB.init
      appId      : appId # App ID from the App Dashboard
      channelUrl : '//www.lendabook.org/channel' # Channel File for x-domain communication
      status     : true # check the login status upon init?
      cookie     : true # set sessions cookies to allow your server to access the session?
      xfbml      : true # parse XFBML tags on this page?

    handleAuthChange = (response) ->
      fbApiInit = true
      if response.status=='connected'
        fbUserAvailable = true
        fbAppAuthorized = true
      else if response.status=='not_authorized'
        fbUserAvailable = true
        fbAppAuthorized = false
      else if response.status=='unknown'
        fbUserAvailable = false
        fbAppAuthorized = false
    FB.Event.subscribe 'auth.authResponseChange', handleAuthChange
    FB.getLoginStatus handleAuthChange


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

  handleIfError = (response, callback) ->
    if(!response? || response.error?)
      callback(response)

  handleIfNoError = (response, callback) ->
    if(response? && !response.error?)
      callback(response)

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
        if !fbAppAuthorized
          FB.login (response) ->
            if response.authResponse
              callback()
            else
              alert("Du musst die Anwendung akzeptieren, um diese Funktion auszuführen.")
          , {scope: 'publish_actions'}
        else
          callback()
    onLoginStatusChange: (callback) ->
      service.ensureInit ->
        FB.Event.subscribe 'auth.authResponseChange', callback
        FB.getLoginStatus callback
    getCurrentUser: (callback) ->
      service.ensureInit -> FB.api '/me', callback
    getUser: (id,callback) ->
      service.ensureLoggedIn -> FB.api '/'+id, callback
    getProfilePicture: (userId, callback) ->
      callback('https://graph.facebook.com/'+userId+'/picture')
    lendingRequest: (bookId, lenderId) ->
      service.ensureLoggedIn -> FB.ui {
        method: 'send'
        link: 'http://www.lendabook.org/books/'+ bookId
        to: lenderId
      }, (response) ->
        if(!response?)
          #User cancelled the dialog
        else if(!response.success? || !response.success)
          #Error
          alert("Error: "+JSON.stringify(response))
        else
          #Success, register opengraph action for borrowing
          FB.api '/me/'+appNamespace+':borrow', 'post', {book: "http://www.lendabook.org/books/"+bookId}, (response) ->
            #TODO Enable following block again
            #displayIfError(response)
    offer: (bookId, errorhandler, successhandler) ->
      service.ensureLoggedIn -> FB.api '/me/'+appNamespace+':offer', 'post', {book: "http://www.lendabook.org/books/"+bookId}, (response)->
        handleIfError(response,errorhandler)
        handleIfNoError(response,successhandler)
    like: (bookId, callbacks) ->
      service.ensureLoggedIn -> FB.api '/me/og.likes', 'post', {object: "http://www.lendabook.org/books/"+bookId}, (response) ->
        displayIfError(response)
        callbacks.success(response)
    unlike: (likeId, callbacks) ->
      service.ensureLoggedIn -> FB.api likeId, 'delete', (response) ->
        displayIfError(response)
        callbacks.success(response)
    getLikedBooks: (callback)->
      service.ensureInit ->
        if fbAppAuthorized
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