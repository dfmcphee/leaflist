var List;

List = (function() {
  function List(id, title, todos) {
    this.id = id != null ? id : null;
    this.title = title != null ? title : '';
    this.todos = todos != null ? todos : [];
  }

  List.prototype.create = function() {
    var self, title, url;
    self = this;
    title = $("#new-list").val();
    url = "/list/create";
    $.ajax(url, {
      type: "POST",
      data: JSON.stringify({
        title: title
      }),
      contentType: "application/json",
      success: function(data) {
        $('#new-list').val("");
        self.id = data._id;
        self.title = data.title;
        return self.render();
      },
      error: function() {
        return alert("Something went wrong. Please try again.");
      }
    });
  };

  List.prototype.add = function(todo) {
    return this.todos.push(todo);
  };

  List.prototype.remove = function() {
    var id, url;
    url = "/lists/remove";
    id = this.id;
    $.ajax(url, {
      type: "POST",
      data: JSON.stringify({
        id: id
      }),
      contentType: "application/json",
      success: function(data) {
        $("#list-" + id).remove();
      },
      error: function() {
        return alert("Something went wrong. Please try again.");
      }
    });
  };

  List.prototype.removeTodo = function(id) {
    var todo, _i, _len, _ref;
    _ref = this.todos;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      todo = _ref[_i];
      if (todo.id === id) {
        todo.remove();
        this.todos.splice(this.todos.indexOf(todo), 1);
        return true;
      }
    }
    return false;
  };

  List.prototype.findById = function(id) {
    var todo, _i, _len, _ref;
    _ref = this.todos;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      todo = _ref[_i];
      if (todo.id === id) {
        return todo;
      }
    }
    return false;
  };

  List.prototype.update = function(updatedTodo) {
    var todo, _i, _len, _ref;
    _ref = this.todos;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      todo = _ref[_i];
      if (todo.id === updatedTodo.id) {
        todo.complete = updatedTodo.complete;
        todo.content = updatedTodo.content;
        todo.publish();
        return true;
      }
    }
    return false;
  };

  List.prototype.fetch = function() {
    var self, url;
    self = this;
    url = "/todos/" + this.id + "/";
    $.ajax(url, {
      type: "GET",
      contentType: "application/json",
      success: function(data) {
        var todo, _i, _len, _ref;
        self.title = data.list.title;
        _ref = data.todos;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          todo = _ref[_i];
          self.todos.push(new Todo(todo._id, todo.content, todo.complete));
        }
        return self.render();
      },
      error: function() {
        return alert("Something went wrong. Please try again.");
      }
    });
  };

  List.prototype.render = function() {
    var todo, uri, _i, _len, _ref;
    $('#title').html(this.title);
    document.title = this.title;
    $('#todo-list').empty();
    _ref = this.todos;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      todo = _ref[_i];
      todo.render();
    }
    $('#create-list').addClass('hidden');
    $('#create-todo').removeClass('hidden');
    $('.nav-right').removeClass('hidden');
    uri = new URI(window.location.href);
    uri.setQuery("list", this.id);
    window.history.pushState({
      list: this.id
    }, this.title, uri.toString());
  };

  return List;

})();
