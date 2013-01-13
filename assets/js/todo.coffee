unless Array::filter
  Array::filter = (callback) ->
    element for element in this when callback(element)

# needed to work with minification
window.todoapp = angular.module 'todoapp', []
window.todoapp.controller 'TodoCtrl', [ '$scope', ($scope) ->
  $scope.todos = [
    {text: 'Get up early', done: true},
    {text: 'Feed the cat', done: false},
    {text: 'Go to sleep', done: false}
  ]

  $scope.getTodos = () ->
    $scope.todos

  $scope.numRemaining = () ->
    $scope.todos.reduce (sum, todo) ->
      if(todo.done) then sum else sum+1
    , 0

  $scope.numCompleted = () ->
    $scope.todos.length - $scope.numRemaining()

  $scope.addTodo = () ->
    $scope.todos.push {text: $scope.todoText, done:false}
    $scope.todoText = ''

  $scope.removeTodo = (todo) ->
    $scope.todos = $scope.todos.filter (t) ->
      t isnt todo

  $scope.clear = () ->
    $scope.todos = $scope.todos.filter (todo) ->
      !todo.done
]