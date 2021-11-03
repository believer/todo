module ID: {
  type t
  let fromString: string => t
  let toString: t => string
} = {
  type t = string

  let fromString = id => id
  let toString = id => id
}

type state = {todos: array<(ID.t, Todo.t)>, input: string, searchQuery: string}

type actions =
  | AddTodo
  | AddTodoChange(string)
  | RemoveTodo(ID.t)
  | ToggleTodo(ID.t)
  | UpdateTodo(ID.t, string)
  | ArchiveTodos
  | Search(string)

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer((state, action) => {
    switch action {
    | AddTodoChange(input) => {...state, input: input}
    | AddTodo => {
        ...state,
        input: "",
        todos: state.todos->Belt.Array.concat([
          (
            Js.Date.make()->Js.Date.getTime->Belt.Float.toString->ID.fromString,
            Incomplete({content: state.input}),
          ),
        ]),
      }
    | RemoveTodo(id) => {
        ...state,
        todos: state.todos->Belt.Array.keep(((todoId, _)) => id !== todoId),
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

  let incompleteTasks = Todo.incomplete(state.todos, state.searchQuery)
  let completedTasks = Todo.completed(state.todos, state.searchQuery)

  let renderTodo = ((id, todo)) =>
    <TodoItem
      todo
      key={ID.toString(id)}
      onToggle={_ => dispatch(ToggleTodo(id))}
      onRemove={_ => dispatch(RemoveTodo(id))}
      onUpdate={updatedTodo => dispatch(UpdateTodo(id, updatedTodo))}
    />

  <div className="mt-8 max-w-sm mx-auto">
    <Typography.H1> {React.string("Tasks")} </Typography.H1>
    <Input
      label="Search"
      id="search"
      onChange={value => {
        dispatch(Search(value))
      }}
      value={state.searchQuery}
    />
    <Typography.H2> {React.string("TODO")} </Typography.H2>
    <Input
      id="new-todo"
      label="New todo"
      onChange={value => {
        dispatch(AddTodoChange(value))
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
        <Typography.H2> {React.string("Done")} </Typography.H2>
        <ul> {completedTasks->Belt.Array.map(renderTodo)->React.array} </ul>
        <button onClick={_ => dispatch(ArchiveTodos)}> {React.string("Archive todos")} </button>
      </>
    }}
  </div>
}
