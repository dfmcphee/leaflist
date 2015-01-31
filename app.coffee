# Initialize express
express = require("express")
app = express()

# Allow parsing incoming json data
bodyParser = require("body-parser")
app.use bodyParser.json()

# Serve static files in public directory
app.use express.static(__dirname + "/public")

# Initialize nedb
Datastore = require('nedb')
db = new Datastore(
  filename: __dirname + '/db.json'
  autoload: true
)

#
# List todos
#
app.get "/todos/", (req, res) ->
  # Find all todos
  db.find({}).sort(dateAdded: 1).exec (err, todos) ->
    res.send todos

#
# Create a new todo
#
app.post "/todos/create", (req, res) ->
  # Initialize new todo
  todo =
    complete: false
    content: req.body.content
    dateAdded: new Date()

  # Add todo
  db.insert todo, (err, newTodo) ->
    res.send newTodo

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

    db.update
      _id: req.body.id
    ,
      $set:
        update
    ,
      multi: false
  res.send req.body.id

#
# Remove a todo
#
app.post "/todos/remove", (req, res) ->
  # Make sure request includes id and a todo exists with that id
  if typeof (req.body.id) isnt "undefined"
    db.remove
      _id: req.body.id
    , {}
  res.send req.body.id


# Open port for server
app.listen 3000
console.log "Server running at http://localhost:3000"
