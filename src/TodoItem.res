type actions = Idle | Updating

@react.component
let make = (~todo, ~onToggle, ~onRemove, ~onUpdate) => {
  let (todoContent, setTodoContent) = React.useState(() => Todo.content(todo))
  let (todoState, setTodoState) = React.useState(() => Idle)

  <li className="flex items-center space-x-2">
    <label>
      <input checked={Todo.isComplete(todo)} type_="checkbox" onChange={onToggle} />
      <span className="sr-only"> {todo->Todo.content->React.string} </span>
    </label>
    {switch todoState {
    | Idle =>
      <button onClick={_ => setTodoState(_ => Updating)}>
        {todo->Todo.content->React.string}
        {switch todo {
        | Complete({completionDate}) => React.string(" " ++ completionDate->Js.Date.toISOString)
        | Incomplete(_) => React.null
        }}
      </button>

    | Updating =>
      <label>
        <span className="sr-only"> {todo->Todo.content->React.string} </span>
        <input
          type_="text"
          onChange={event => {
            let value = ReactEvent.Form.target(event)["value"]
            setTodoContent(_ => value)
          }}
          onKeyPress={event => {
            if ReactEvent.Keyboard.key(event) === "Enter" {
              onUpdate(todoContent)
              setTodoState(_ => Idle)
            }
          }}
          value={todoContent}
        />
      </label>
    }}
    <button onClick=onRemove> {React.string("Remove todo")} </button>
  </li>
}
