# On document ready
$ ->
  todoList = false

  uri = new URI(window.location.href)
  params = uri.search(true)

  # If a list is passed in the url, load it
  if (params && params.list)
    todoList = new List(params.list)
    todoList.fetch()
  else
    $('#create-list').removeClass('hidden')

  # Add event listener when add list button is clicked
  $(document).on "click", "#add-list", ->
    todoList = new List()
    todoList.create()
    return

  # Add event listener when enter key is pressed
  $('#new-list').keypress (e) ->
    if (e.which == 13)
      todoList = new List()
      todoList.create()

  # Add event listener when add todo button is clicked
  $(document).on "click", "#add-todo", ->
    if (todoList)
      new Todo().create(todoList)
    return

  # Add event listener when enter key is pressed
  $('#new-todo').keypress (e) ->
    if (e.which == 13 && todoList)
      new Todo().create(todoList)

  # Add event listener when chekbox is checked/unchecked
  $('#todo-list').on "click", "input[type='checkbox']", (e) ->
    checkbox = e.target

    # Get ID from data attribute on checkbox
    todo =
      id: $(checkbox).closest('li').data("todo-id")
      complete: checkbox.checked

    # Update todo
    todoList.update(todo)
    return

  # Add event listener when text input is double clicked
  $('#todo-list').on "dblclick", "input[type='text']", (e) ->
    ro = $(this).prop('readonly')
    if ro
      $(this).prop('readonly', !ro).focus()
      $(this).parent().append('<button class="button">Delete</button>')
    return

  # Add event when todo input is blurred
  $('#todo-list').on "blur", "input[type='text']", (e) ->
    input = e.target
    id = $(input).closest('li').data("todo-id")

    todo =
      id: id
      complete: $('#todo-complete-' + id).checked
      content: $(input).val()

    # Update todo
    todoList.update(todo)
    $(input).prop('readonly', true)
    setTimeout ( ->
      $(input).parent().find('button').remove()
      return
    ), 100
    return

  # Add event listener when enter key is pressed while editing
  $('#todo-list').on "keyup", "input[type='text']", (e) ->
    if (e.which == 13)
      # Get id from focussed input
      input = $(':focus')
      id = $(input).closest('li').data("todo-id")

      # Update todo content
      todo =
        _id: id
        complete: $('#todo-complete-' + id).checked
        content: $(input).val()

      # Update todo
      todoList.update(todo)
      $(input).prop('readonly', true)
      $(input).parent().find('button').remove()

  # Add event when todo delete is clicked
  $('#todo-list').on "click", "button", (e) ->
    id = $(this).closest('li').data("todo-id")
    todoList.removeTodo(id)
    return
