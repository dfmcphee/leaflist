$(function() {
  var params, todoList, uri;
  todoList = false;
  FastClick.attach(document.body);
  uri = new URI(window.location.href);
  params = uri.search(true);
  if (params && params.list) {
    todoList = new List(params.list);
    todoList.fetch();
  } else {
    $('#create-list').removeClass('hidden');
  }
  $('#main').addClass('animated fadeIn');
  $(document).on("click", "#link-button", function() {
    $('#list-url').val(document.URL);
    return $('#share').toggleClass('hidden');
  });
  $(document).on("click", "#title", function() {
    if (todoList) {
      $('#title').addClass('hidden');
      $('#list-title').removeClass('hidden');
      $('#list-title').val($('#title').text());
      $('#list-title').focus();
    }
  });
  $(document).on("blur", "#list-title", function() {
    var newTitle;
    newTitle = $('#list-title').val();
    todoList.update(newTitle);
    $('#title').html(newTitle);
    document.title = newTitle;
    $('#title').removeClass('hidden');
    $('#list-title').addClass('hidden');
  });
  $(document).on('keyup', '#list-title', function(e) {
    var newTitle;
    if (e.which === 13) {
      newTitle = $('#list-title').val();
      todoList.update(newTitle);
      $('#title').html(newTitle);
      document.title = newTitle;
      $('#title').removeClass('hidden');
      return $('#list-title').addClass('hidden');
    }
  });
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
    todoList.updateTodo(todo);
  });
  $('#todo-list').on("click", "input[type='text']", function(e) {
    var button, ro;
    ro = $(this).prop('readonly');
    if (ro) {
      $(this).prop('readonly', false);
      button = $(this).parent().find('.remove');
      button.addClass('animated bounceInRight');
      button.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
        return button.removeClass('bounceInRight');
      });
      $(this).focus();
    }
  });
  $('#todo-list').on("blur", "input[type='text']", function(e) {
    var button, id, input, todo;
    input = e.target;
    id = $(input).closest('li').data("todo-id");
    todo = {
      id: id,
      complete: $('#todo-complete-' + id).checked,
      content: $(input).val()
    };
    todoList.updateTodo(todo);
    $(input).prop('readonly', true);
    button = $(input).parent().find('.remove');
    button.addClass('animated bounceOutRight');
    button.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
      return button.removeClass('animated bounceOutRight');
    });
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
      todoList.updateTodo(todo);
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
