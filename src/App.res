type state = {todos: array<Todo.t>, input: string}

type actions = AddTodo | RemoveTodo(int) | InputChange(string)

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer((state, action) => {
    switch action {
    | AddTodo => {
        input: "",
        todos: state.todos->Belt.Array.concat([
          Incomplete({content: state.input, id: Js.Date.make()->Js.Date.getTime}),
        ]),
      }
    | RemoveTodo(id) => {
        ...state,
        todos: state.todos->Belt.Array.keepWithIndex((_, i) => i != id),
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
        ->Belt.Array.map(todo => {
          switch todo {
          | Complete(_) => React.null
          | Incomplete({content, id}) =>
            <li key={Belt.Float.toString(id)}> {React.string(content)} </li>
          }
        })
        ->React.array}
      </ul>
    }}
  </div>
}
