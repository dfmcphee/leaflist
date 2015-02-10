# Initialize express
express = require("express")
app = express()
port = process.env.PORT || 3000

# Mongo connection
mongoose = require( 'mongoose' )
Schema = mongoose.Schema

List = new Schema(
  title: String
)

Todo = new Schema(
  content: String,
  dateAdded: Date,
  complete: Boolean,
  listId: String
)

Todo = mongoose.model('Todo', Todo)
List = mongoose.model('List', List)
mongoose.connect(process.env.MONGOLAB_URI)

# Allow parsing incoming json data
bodyParser = require("body-parser")
app.use bodyParser.json()

# Serve static files in public directory
app.use express.static(__dirname + "/public")

#
# List todos
#
app.get "/todos/:id/", (req, res) ->
  # Find list
  List.findOne({_id: req.params.id}).exec (err, list) ->
    # Find all todos
    Todo.find({listId: req.params.id}).sort(dateAdded: 1).exec (err, todos) ->
      response =
        list: list
        todos: todos
      res.send response

#
# Create a new todo list
#
app.post "/list/create", (req, res) ->
  # Initialize new list
  list = new List(
    title: req.body.title
    dateAdded: new Date()
  )
  list.save((err) ->
    res.send(list)
  )
#
# Create a new todo
#
app.post "/todos/create", (req, res) ->
  # Add todo
  todo = new Todo(
    complete: false
    content: req.body.content
    dateAdded: new Date()
    listId: req.body.listId
  )
  todo.save((err) ->
    res.send todo
  )

#
# Complete a todo
#
app.post "/todos/update", (req, res) ->
  # Make sure request includes id
  if typeof (req.body.id) isnt "undefined"
    update = {}
    # Update complete
    if typeof (req.body.complete) isnt "undefined"
      update.complete = req.body.complete
    # Update content
    if typeof (req.body.content) isnt "undefined"
      update.content = req.body.content

    Todo.update(
      _id: req.body.id
    , $set:
        update
    ).exec()
  res.send req.body.id

#
# Remove a todo
#
app.post "/todos/remove", (req, res) ->
  # Make sure request includes id and a todo exists with that id
  if typeof (req.body.id) isnt "undefined"
    Todo.remove
      _id: req.body.id
    , {}
  res.send req.body.id

#
# Remove a list
#
app.post "/lists/remove", (req, res) ->
  # Make sure request includes id and a todo exists with that id
  if typeof (req.body.id) isnt "undefined"
    Todo.remove
      listId: req.body.id
    , {}
    List.remove
      _id: req.body.id
    , {}
  res.send req.body.id


# Open port for server
app.listen port
console.log "Server running at http://localhost:" + port
