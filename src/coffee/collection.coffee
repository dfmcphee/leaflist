#
# List of todos
#
class Collection
  constructor: (@lists=[]) ->

  #
  # Creates a new list
  #
  create: ->
    self = this

    # Get list title from input
    title = $("#new-list").val()

    # Set url for request
    url = "/list/create"

    # Send ajax POST request
    $.ajax url,
      type: "POST"
      data: JSON.stringify({title: title})
      contentType: "application/json"
      success: (data) ->
        self.add(data).render()
        self.save()

        # Reset the input content
        $('#new-list').val ""
      error: ->
        # Output error if request fails
        alert "Something went wrong. Please try again."
    return

  #
  # Adds a new list
  #
  add: (data) ->
    # Initialize a new Todo
    list = new List(data._id, data.title, [])

    # Add it to the todos
    @lists.push(list)

    return list

  #
  # Removes a list
  #
  remove: (id) ->
    self = this
    # Loop through lists
    for list in @lists
      # If the id matches
      if list.id == id
        # Remove from the collection
        list.remove()
        @lists.splice(@lists.indexOf(list), 1)
        self.save()
        return true

    return false

  #
  # Saves collection
  #
  save: () ->
    listData = []
    # Loop through lists
    for list in @lists
      data =
        id: list.id
        title: list.title
      listData.push(data)
    $.cookie('todoLists', listData)
    return

  #
  # Restore collection from cookie
  #
  restore: () ->
    self = this
    results = $.cookie('todoLists')
    if results
      for list in results
        data =
          _id: list.id
          title: list.title
        self.add(data).render()
    return
