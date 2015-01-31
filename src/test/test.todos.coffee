describe "Library Tests", ->
  before ->

  it "Should be able to add a new Todo", ->
    list = new List()
    todo =
      _id: "1"
      content: "test todo"
      complete: false
    list.add(todo)

    assert list.todos.length is 1
    return

  it "Should initialize todo correctly", ->
    list = new List()
    todo =
      _id: "1"
      content: "test content"
      complete: false
    list.add(todo)

    assert list.todos[0].content is "test content"
    return

  it "Should be able to remove a Todo", ->
    list = new List()
    todo =
      _id: "1"
      content: "test todo"
      complete: false
    list.add(todo)

    list.remove("1")
    assert list.todos.length is 0
    return

  it "Should be able to update a Todo", ->
    list = new List()
    todo =
      _id: "1"
      content: "test todo"
      complete: false
    list.add(todo)

    update =
      _id: "1"
      content: "updated todo"
      complete: true
    response = list.update(update)

    result = list.findById("1")

    assert response is true
    assert result.content is "updated todo"
    assert result.complete is true
    return

  it "Should be able to search for a Todo", ->
    list = new List()
    todo =
      _id: "1"
      content: "test todo"
      complete: false
    list.add(todo)

    result = list.findById("1")
    assert result is list.todos[0]
    return

  it "Search should return false if no results", ->
    list = new List()
    todo =
      _id: "1"
      content: "test todo"
      complete: false
    list.add(todo)

    result = list.findById("3")
    assert result is false
    return

  return
