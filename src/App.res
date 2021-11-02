type state = {todos: array<(string, Todo.t)>, input: string, searchQuery: string}

type actions =
  | AddTodo
  | RemoveTodo(string)
  | ToggleTodo(string)
  | InputChange(string)
  | ArchiveTodos
  | UpdateTodo(string, string)
  | Search(string)

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer((state, action) => {
    switch action {
    | AddTodo => {
        ...state,
        input: "",
        todos: state.todos->Belt.Array.concat([
          (
            Js.Date.make()->Js.Date.getTime->Belt.Float.toString,
            Incomplete({content: state.input}),
          ),
        ]),
      }
    | RemoveTodo(id) => {
        ...state,
        todos: state.todos->Belt.Array.keep(((todoId, _)) => todoId !== id),
      }
    | ToggleTodo(todoId) => {
        ...state,
        todos: state.todos->Belt.Array.map(((id, todo)) => {
          if id === todoId {
            (id, Todo.toggle(todo))
          } else {
            (id, todo)
          }
        }),
      }
    | InputChange(input) => {...state, input: input}
    | ArchiveTodos => {
        ...state,
        todos: state.todos->Belt.Array.keep(((_, todo)) => !Todo.isComplete(todo)),
      }
    | UpdateTodo(todoId, updatedTodo) => {
        ...state,
        todos: state.todos->Belt.Array.map(((id, todo)) => {
          if id === todoId {
            (id, todo->Todo.updateContent(updatedTodo))
          } else {
            (id, todo)
          }
        }),
      }
    | Search(searchQuery) => {
        ...state,
        searchQuery: searchQuery,
      }
    }
  }, {todos: [], input: "", searchQuery: ""})

  let incompleteTasks = state.todos->Belt.Array.keep(((_, todo)) =>
    switch (Todo.isComplete(todo), state.searchQuery) {
    | (false, "") => true
    | (false, query)
      if Todo.content(todo)
      ->Js.String2.toLowerCase
      ->Js.String2.includes(query->Js.String2.toLowerCase) => true
    | (false, _)
    | (true, _) => false
    }
  )
  let completedTasks = state.todos->Belt.Array.keep(((_, todo)) => {
    switch (Todo.isComplete(todo), state.searchQuery) {
    | (true, "") => true
    | (true, query)
      if Todo.content(todo)
      ->Js.String2.toLowerCase
      ->Js.String2.includes(query->Js.String2.toLowerCase) => true
    | (true, _)
    | (false, _) => false
    }
  })

  let renderTodo = ((id, todo)) =>
    <TodoItem
      todo
      key={id}
      onToggle={_ => dispatch(ToggleTodo(id))}
      onRemove={_ => dispatch(RemoveTodo(id))}
      onUpdate={updatedTodo => dispatch(UpdateTodo(id, updatedTodo))}
    />

  <div className="mt-8 max-w-4xl mx-auto">
    <h1 className="text-4xl font-bold"> {React.string("Tasks")} </h1>
    <h2> {React.string("TODO")} </h2>
    <Input
      label="Search"
      id="search"
      onChange={value => {
        dispatch(Search(value))
      }}
      value={state.searchQuery}
    />
    <Input
      id="new-todo"
      label="New todo"
      onChange={value => {
        dispatch(InputChange(value))
      }}
      onKeyPress={event => {
        if ReactEvent.Keyboard.key(event) === "Enter" {
          dispatch(AddTodo)
        }
      }}
      value={state.input}
    />
    {switch Belt.Array.length(incompleteTasks) {
    | 0 => React.string("You don't have any todos")
    | _ => <ul> {incompleteTasks->Belt.Array.map(renderTodo)->React.array} </ul>
    }}
    {switch Belt.Array.length(completedTasks) {
    | 0 => React.null
    | _ => <>
        <hr />
        <h2> {React.string("Done")} </h2>
        <ul> {completedTasks->Belt.Array.map(renderTodo)->React.array} </ul>
        <button onClick={_ => dispatch(ArchiveTodos)}> {React.string("Archive todos")} </button>
      </>
    }}
  </div>
}
