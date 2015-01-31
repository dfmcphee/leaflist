var List;

List = (function() {
  function List(todos) {
    this.todos = todos != null ? todos : [];
  }

  List.prototype.create = function() {
    var content, self, url;
    self = this;
    content = $("#new-todo").val();
    url = "/todos/create";
    $.ajax(url, {
      type: "POST",
      data: JSON.stringify({
        content: content
      }),
      contentType: "application/json",
      success: function(data) {
        self.add(data).render();
        return $('#new-todo').val("");
      },
      error: function() {
        return alert("Something went wrong. Please try again.");
      }
    });
  };

  List.prototype.add = function(data) {
    var todo;
    todo = new Todo(data._id, data.content, data.complete);
    this.todos.push(todo);
    return todo;
  };

  List.prototype.remove = function(id) {
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
      if (todo.id === updatedTodo._id) {
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
    url = "/todos/";
    $.ajax(url, {
      type: "GET",
      contentType: "application/json",
      success: function(data) {
        var todo, _i, _len;
        for (_i = 0, _len = data.length; _i < _len; _i++) {
          todo = data[_i];
          self.todos.push(new Todo(todo._id, todo.content, todo.complete));
        }
        return self.list();
      },
      error: function() {
        return alert("Something went wrong. Please try again.");
      }
    });
  };

  List.prototype.list = function() {
    var todo, _i, _len, _ref;
    $('#todo-list').empty();
    _ref = this.todos;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      todo = _ref[_i];
      todo.render();
    }
  };

  return List;

})();
