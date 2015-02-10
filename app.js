var List, Schema, Todo, app, bodyParser, express, mongoose;

express = require("express");

app = express();

mongoose = require('mongoose');

Schema = mongoose.Schema;

List = new Schema({
  title: String
});

Todo = new Schema({
  content: String,
  dateAdded: Date,
  complete: Boolean,
  listId: String
});

Todo = mongoose.model('Todo', Todo);

List = mongoose.model('List', List);

mongoose.connect(process.env.MONGOLAB_URI);

bodyParser = require("body-parser");

app.use(bodyParser.json());

app.use(express["static"](__dirname + "/public"));

app.get("/todos/:id/", function(req, res) {
  return List.findOne({
    _id: req.params.id
  }).exec(function(err, list) {
    return Todo.find({
      listId: req.params.id
    }).sort({
      dateAdded: 1
    }).exec(function(err, todos) {
      var response;
      response = {
        list: list,
        todos: todos
      };
      return res.send(response);
    });
  });
});

app.post("/list/create", function(req, res) {
  var list;
  list = new List({
    title: req.body.title,
    dateAdded: new Date()
  });
  return list.save(function(err) {
    return res.send(list);
  });
});

app.post("/todos/create", function(req, res) {
  var todo;
  todo = new Todo({
    complete: false,
    content: req.body.content,
    dateAdded: new Date(),
    listId: req.body.listId
  });
  return todo.save(function(err) {
    return res.send(todo);
  });
});

app.post("/todos/update", function(req, res) {
  var update;
  if (typeof req.body.id !== "undefined") {
    update = {};
    if (typeof req.body.complete !== "undefined") {
      update.complete = req.body.complete;
    }
    if (typeof req.body.content !== "undefined") {
      update.content = req.body.content;
    }
    Todo.update({
      _id: req.body.id
    }, {
      $set: update
    }).exec();
  }
  return res.send(req.body.id);
});

app.post("/todos/remove", function(req, res) {
  if (typeof req.body.id !== "undefined") {
    Todo.remove({
      _id: req.body.id
    }, {});
  }
  return res.send(req.body.id);
});

app.post("/lists/remove", function(req, res) {
  if (typeof req.body.id !== "undefined") {
    Todo.remove({
      listId: req.body.id
    }, {});
    List.remove({
      _id: req.body.id
    }, {});
  }
  return res.send(req.body.id);
});

app.listen(3000);

console.log("Server running at http://localhost:3000");
