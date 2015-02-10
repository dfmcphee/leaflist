#
# Todo
#
class Todo
  constructor: (@id, @content, @complete, @listId) ->

  #
  # Creates a new todo
  #
  create: (list) ->
    self = this

    # Get todo content from input
    content = $("#new-todo").val()

    # Set url for request
    url = "/todos/create"

    # Send ajax POST request
    $.ajax url,
      type: "POST"
      data: JSON.stringify({content: content, listId: list.id})
      contentType: "application/json"
      success: (data) ->
        self.id = data._id
        self.content = data.content
        self.complete = data.complete
        self.listId = data.listId

        list.add(data)
        self.render()

        # Reset the input content
        $('#new-todo').val ""
      error: ->
        # Output error if request fails
        alert "Something went wrong. Please try again."
    return

  #
  # Renders a todo item
  #
  render: ->
    # Create new list item
    li = $("<li id='todo-" + @id + "'></li>")

    # Add the todo id as a data attribute
    li.attr "data-todo-id", @id

    # Add todo content to readonly text input
    input = $("<input type='text' readonly />")
    input.val @content
    li.append input

    # Create checkbox input
    checkbox_wrapper = $("<div class='checkbox'>")
    checkbox = $("<input type='checkbox' id='todo-complete-" + @id + "' />")

    # Set checkbox checked
    checkbox.prop "checked", @complete

    # Add checkbox to wrapper
    checkbox_wrapper.append checkbox

    # Add label to wrapper
    checkbox_wrapper.append "<label for='todo-complete-" + @id + "'></label>"

    # Add checkbox wrapper to list item
    li.append checkbox_wrapper

    # Add to todo list
    $("#todo-list").append li
    return

  #
  # Remove a todo item
  #
  remove: ->
    # Set url for request
    url = "/todos/remove"
    id = @id

    # Send ajax POST request
    $.ajax url,
      type: "POST"
      data: JSON.stringify({id: id})
      contentType: "application/json"
      success: (data) ->
        $("#todo-" + id).remove()
        return
      error: ->
        # Output error if request fails
        alert "Something went wrong. Please try again."
    return

  #
  # Updates a todo on the server
  #
  publish: ->
    # Set url for request
    url = "/todos/update"

    todo =
      id: @id
      content: @content
      complete: @complete

    # Open and send the request
    $.ajax url,
      type: "POST"
      data: JSON.stringify(todo)
      contentType: "application/json"
