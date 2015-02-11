#
# List of todos
#
class List
  constructor: (@id = null, @title = '', @todos = []) ->

  #
  # Creates a new list
  #
  create: ->
    self = this

    # Get list title from input
    title = $("#new-list").val()

    # Set url for request
    url = "/list/create"

    # Send ajax POST request
    $.ajax url,
      type: "POST"
      data: JSON.stringify({title: title})
      contentType: "application/json"
      success: (data) ->
        # Reset the input content
        $('#new-list').val ""

        # Save the attributes
        self.id = data._id
        self.title = data.title

        # Render the new list
        self.render()
      error: ->
        # Output error if request fails
        alert "Something went wrong. Please try again."
    return

  #
  # Adds a new todo
  #
  add: (todo) ->
    # Add it to the todos
    @todos.push(todo)

  #
  # Remove a list
  #
  remove: ->
    # Set url for request
    url = "/lists/remove"
    id = @id

    # Send ajax POST request
    $.ajax url,
      type: "POST"
      data: JSON.stringify({id: id})
      contentType: "application/json"
      success: (data) ->
        $("#list-" + id).remove()
        return
      error: ->
        # Output error if request fails
        alert "Something went wrong. Please try again."
    return

  #
  # Removes a todo
  #
  removeTodo: (id) ->
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
      if todo.id == updatedTodo.id
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
    url = "/todos/" + @id + "/"

    # Send ajax GET request for list of todos
    $.ajax url,
      type: "GET"
      contentType: "application/json"
      success: (data) ->
        self.title = data.list.title

        # Add fetched todos to todos
        for todo in data.todos
          self.todos.push new Todo(todo._id, todo.content, todo.complete)

        # Render todos todos
        self.render()
      error: ->
        # Output error if request fails
        alert "Something went wrong. Please try again."
    return

  #
  # Renders the list
  #
  render: ->
    # Set title
    $('#title').html(@title)
    document.title = @title

    # Remove any exisiting list elements
    $('#todo-list').empty()
    # Loop through todos of todos
    for todo in @todos
      # And render each one
      todo.render()

    # Toggle toolbars
    $('#create-list').addClass('hidden')
    $('#create-todo').removeClass('hidden')
    $('.nav-right').removeClass('hidden')

    # Push state
    uri = new URI(window.location.href)
    uri.setQuery("list", @id);
    window.history.pushState({list: @id}, @title, uri.toString());
    return
