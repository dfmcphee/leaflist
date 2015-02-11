# On document ready
$ ->
  todoList = false
  FastClick.attach(document.body)

  uri = new URI(window.location.href)
  params = uri.search(true)

  # If a list is passed in the url, load it
  if (params && params.list)
    todoList = new List(params.list)
    todoList.fetch()
  else
    $('#create-list').removeClass('hidden')

  $('#main').addClass('animated fadeIn')

  # Add event listener when title is clicked
  $(document).on "click", "#title", ->
    if (todoList)
      $('#title').addClass('hidden')
      $('#list-title').removeClass('hidden')
      $('#list-title').val($('#title').text())
      $('#list-title').focus()
    return

  # Add event listener when title input is blurred
  $(document).on "blur", "#list-title", ->
    newTitle = $('#list-title').val()
    todoList.update(newTitle)
    $('#title').html(newTitle)
    $('#title').removeClass('hidden')
    $('#list-title').addClass('hidden')
    return

  # Add event listener when enter key is pressed while editing
  $(document).on 'keyup', '#list-title', (e) ->
    if (e.which == 13)
      newTitle = $('#list-title').val()
      todoList.update(newTitle)
      $('#title').html(newTitle)
      $('#title').removeClass('hidden')
      $('#list-title').addClass('hidden')

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
    todoList.updateTodo(todo)
    return

  # Add event listener when text input is clicked
  $('#todo-list').on "click", "input[type='text']", (e) ->
    ro = $(this).prop('readonly')
    if ro
      $(this).prop('readonly', false)
      button = $(this).parent().find('.remove')
      button.addClass('animated bounceInRight')
      button.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
        button.removeClass('bounceInRight')
      )
      $(this).focus()
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
    todoList.updateTodo(todo)
    $(input).prop('readonly', true)
    button = $(input).parent().find('.remove')
    button.addClass('animated bounceOutRight')
    button.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
      button.removeClass('animated bounceOutRight')
    )
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
      todoList.updateTodo(todo)
      $(input).prop('readonly', true)
      $(input).parent().find('button').remove()

  # Add event when todo delete is clicked
  $('#todo-list').on "click", "button", (e) ->
    id = $(this).closest('li').data("todo-id")
    todoList.removeTodo(id)
    return
