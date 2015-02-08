var Collection;

Collection = (function() {
  function Collection(lists) {
    this.lists = lists != null ? lists : [];
  }

  Collection.prototype.create = function() {
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
        self.add(data).render();
        self.save();
        return $('#new-list').val("");
      },
      error: function() {
        return alert("Something went wrong. Please try again.");
      }
    });
  };

  Collection.prototype.add = function(data) {
    var list;
    list = new List(data._id, data.title, []);
    this.lists.push(list);
    return list;
  };

  Collection.prototype.remove = function(id) {
    var list, _i, _len, _ref;
    _ref = this.lists;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      list = _ref[_i];
      if (list.id === id) {
        list.remove();
        this.lists.splice(this.lists.indexOf(list), 1);
        return true;
      }
    }
    return false;
  };

  Collection.prototype.save = function() {
    var cookie, data, list, listData, _i, _len, _ref;
    listData = [];
    _ref = this.lists;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      list = _ref[_i];
      data = {
        id: list.id,
        title: list.title
      };
      listData.push(data);
    }
    cookie = ['todoLists', '=', JSON.stringify(listData), '; domain=.', window.location.host.toString(), '; path=/;'].join('');
    document.cookie = cookie;
  };

  Collection.prototype.restore = function() {
    var data, list, result, results, _i, _len;
    results = document.cookie.match(new RegExp('todoLists=([^;]+)'));
    results && (result = JSON.parse(results[1]));
    if (results) {
      for (_i = 0, _len = results.length; _i < _len; _i++) {
        list = results[_i];
        data = {
          id: list.id,
          title: list.title
        };
        self.add(data).render();
      }
    }
  };

  return Collection;

})();
