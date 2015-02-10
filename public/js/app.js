$(function() {
  var params, todoList, uri;
  todoList = false;
  uri = new URI(window.location.href);
  params = uri.search(true);
  if (params && params.list) {
    todoList = new List(params.list);
    todoList.fetch();
  } else {
    $('#create-list').removeClass('hidden');
  }
  $(document).on("click", "#add-list", function() {
    todoList = new List();
    todoList.create();
  });
  $('#new-list').keypress(function(e) {
    if (e.which === 13) {
      todoList = new List();
      return todoList.create();
    }
  });
  $(document).on("click", "#add-todo", function() {
    if (todoList) {
      new Todo().create(todoList);
    }
  });
  $('#new-todo').keypress(function(e) {
    if (e.which === 13 && todoList) {
      return new Todo().create(todoList);
    }
  });
  $('#todo-list').on("click", "input[type='checkbox']", function(e) {
    var checkbox, todo;
    checkbox = e.target;
    todo = {
      id: $(checkbox).closest('li').data("todo-id"),
      complete: checkbox.checked
    };
    todoList.update(todo);
  });
  $('#todo-list').on("dblclick", "input[type='text']", function(e) {
    var ro;
    ro = $(this).prop('readonly');
    if (ro) {
      $(this).prop('readonly', !ro).focus();
      $(this).parent().append('<button class="button">Delete</button>');
    }
  });
  $('#todo-list').on("blur", "input[type='text']", function(e) {
    var id, input, todo;
    input = e.target;
    id = $(input).closest('li').data("todo-id");
    todo = {
      id: id,
      complete: $('#todo-complete-' + id).checked,
      content: $(input).val()
    };
    todoList.update(todo);
    $(input).prop('readonly', true);
    setTimeout((function() {
      $(input).parent().find('button').remove();
    }), 100);
  });
  $('#todo-list').on("keyup", "input[type='text']", function(e) {
    var id, input, todo;
    if (e.which === 13) {
      input = $(':focus');
      id = $(input).closest('li').data("todo-id");
      todo = {
        _id: id,
        complete: $('#todo-complete-' + id).checked,
        content: $(input).val()
      };
      todoList.update(todo);
      $(input).prop('readonly', true);
      return $(input).parent().find('button').remove();
    }
  });
  return $('#todo-list').on("click", "button", function(e) {
    var id;
    id = $(this).closest('li').data("todo-id");
    todoList.removeTodo(id);
  });
});
