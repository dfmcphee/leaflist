var Todo;

Todo = (function() {
  function Todo(id, content, complete) {
    this.id = id;
    this.content = content;
    this.complete = complete;
  }

  Todo.prototype.render = function() {
    var checkbox, checkbox_wrapper, input, li;
    li = $("<li id='todo-" + this.id + "'></li>");
    li.attr("data-todo-id", this.id);
    input = $("<input type='text' readonly />");
    input.val(this.content);
    li.append(input);
    checkbox_wrapper = $("<div class='checkbox'>");
    checkbox = $("<input type='checkbox' id='todo-complete-" + this.id + "' />");
    checkbox.prop("checked", this.complete);
    checkbox_wrapper.append(checkbox);
    checkbox_wrapper.append("<label for='todo-complete-" + this.id + "'></label>");
    li.append(checkbox_wrapper);
    $("#todo-list").append(li);
  };

  Todo.prototype.remove = function() {
    var id, url;
    url = "/todos/remove";
    id = this.id;
    $.ajax(url, {
      type: "POST",
      data: JSON.stringify({
        id: id
      }),
      contentType: "application/json",
      success: function(data) {
        $("#todo-" + id).remove();
      },
      error: function() {
        return alert("Something went wrong. Please try again.");
      }
    });
  };

  Todo.prototype.publish = function() {
    var todo, url;
    url = "/todos/update";
    todo = {
      id: this.id,
      content: this.content,
      complete: this.complete
    };
    return $.ajax(url, {
      type: "POST",
      data: JSON.stringify(todo),
      contentType: "application/json"
    });
  };

  return Todo;

})();
