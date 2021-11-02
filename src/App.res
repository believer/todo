type state = {todos: array<(float, Todo.t)>, input: string}

type actions = AddTodo | RemoveTodo(int) | ToggleTodo(float) | InputChange(string) | ArchiveTodos

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer((state, action) => {
    switch action {
    | AddTodo => {
        input: "",
        todos: state.todos->Belt.Array.concat([
          (Js.Date.make()->Js.Date.getTime, Incomplete({content: state.input})),
        ]),
      }
    | RemoveTodo(id) => {
        ...state,
        todos: state.todos->Belt.Array.keepWithIndex((_, i) => i != id),
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
    }
  }, {todos: [], input: ""})

  let incompleteTasks = state.todos->Belt.Array.keep(((_, todo)) => !Todo.isComplete(todo))
  let completedTasks = state.todos->Belt.Array.keep(((_, todo)) => Todo.isComplete(todo))

  <div>
    <h1> {React.string("Tasks")} </h1>
    <h2> {React.string("TODO")} </h2>
    <AddTodo
      id="new-todo"
      label="New todo"
      onChange={event => {
        let value = ReactEvent.Form.target(event)["value"]
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
    | _ =>
      <ul>
        {incompleteTasks
        ->Belt.Array.map(((id, todo)) => {
          <TodoItem todo key={id->Belt.Float.toString} onToggle={_ => dispatch(ToggleTodo(id))} />
        })
        ->React.array}
      </ul>
    }}
    {switch Belt.Array.length(completedTasks) {
    | 0 => React.null
    | _ => <>
        <h2> {React.string("Done")} </h2>
        <ul>
          {completedTasks
          ->Belt.Array.map(((id, todo)) => {
            <TodoItem todo key={id->Belt.Float.toString} onToggle={_ => dispatch(ToggleTodo(id))} />
          })
          ->React.array}
        </ul>
        <button onClick={_ => dispatch(ArchiveTodos)}> {React.string("Archive todos")} </button>
      </>
    }}
  </div>
}
