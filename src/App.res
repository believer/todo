type state = {todos: array<(float, Todo.t)>, input: string}

type actions = AddTodo | RemoveTodo(int) | ToggleTodo(float) | InputChange(string)

module TodoItem = {
  @react.component
  let make = (~todo, ~onToggle) => {
    <li>
      <label className="items-center flex space-x-2">
        <input checked={Todo.isComplete(todo)} type_="checkbox" onChange={onToggle} />
        <div>
          {switch todo {
          | Incomplete({content}) => React.string(content)
          | Complete({content, completionDate}) =>
            React.string(content ++ " " ++ completionDate->Js.Date.toISOString)
          }}
        </div>
      </label>
    </li>
  }
}

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
    }
  }, {todos: [], input: ""})

  <div>
    <label htmlFor="new-todo"> {React.string("New todo")} </label>
    <input
      id="new-todo"
      type_="text"
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
    {switch Belt.Array.length(state.todos) {
    | 0 => React.string("You don't have any todos")
    | _ =>
      <ul>
        {state.todos
        ->Belt.Array.map(((id, todo)) => {
          <TodoItem todo key={id->Belt.Float.toString} onToggle={_ => dispatch(ToggleTodo(id))} />
        })
        ->React.array}
      </ul>
    }}
  </div>
}
