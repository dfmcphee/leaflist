$(function() {
  var todoList;
  todoList = new List;
  todoList.fetch();
  $(document).on("click", "#add-todo", function() {
    todoList.create();
  });
  $('#new-todo').keypress(function(e) {
    if (e.which === 13) {
      return todoList.create();
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
      _id: id,
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
    todoList.remove(id);
  });
});
