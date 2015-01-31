#
# List of todos
#
class List
  constructor: (@todos=[]) ->

  #
  # Creates a new todo
  #
  create: ->
    self = this

    # Get todo content from input
    content = $("#new-todo").val()

    # Set url for request
    url = "/todos/create"

    # Send ajax POST request
    $.ajax url,
      type: "POST"
      data: JSON.stringify({content: content})
      contentType: "application/json"
      success: (data) ->
        self.add(data).render()

        # Reset the input content
        $('#new-todo').val ""
      error: ->
        # Output error if request fails
        alert "Something went wrong. Please try again."
    return

  #
  # Adds a new todo
  #
  add: (data) ->
    # Initialize a new Todo
    todo = new Todo(data._id, data.content, data.complete)

    # Add it to the todos
    @todos.push(todo)

    return todo

  #
  # Removes a todo
  #
  remove: (id) ->
    # Loop through todos
    for todo in @todos
      # If the id matches
      if todo.id == id
        # Remove from the todos
        todo.remove()
        @todos.splice(@todos.indexOf(todo), 1)
        return true

    return false

  #
  # Finds a todo by its id
  #
  findById: (id) ->
    # Loop through todos
    for todo in @todos
      # If the id matches
      if todo.id == id
        # Return the todo
        return todo

    return false

  #
  # Updates a todo
  #
  update: (updatedTodo) ->
    # Loop through todos
    for todo in @todos
      # If the id matches
      if todo.id == updatedTodo._id
        # Update it
        todo.complete = updatedTodo.complete
        todo.content = updatedTodo.content
        # And publish
        todo.publish()
        return true

    return false

  #
  # Get todos from the server
  #
  fetch: ->
    self = this

    # Set url for request
    url = "/todos/"

    # Send ajax GET request for list of todos
    $.ajax url,
      type: "GET"
      contentType: "application/json"
      success: (data) ->
        # Add fetched todos to todos
        for todo in data
          self.todos.push new Todo(todo._id, todo.content, todo.complete)

        # Render todos todos
        self.list()
      error: ->
        # Output error if request fails
        alert "Something went wrong. Please try again."
    return

  #
  # Render list of todos
  #
  list: ->
    # Remove any exisiting list elements
    $('#todo-list').empty()
    # Loop through todos of todos
    for todo in @todos
      # And render each one
      todo.render()

    return
