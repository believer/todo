type actions = Idle | Updating

@react.component
let make = (~todo, ~onToggle, ~onRemove, ~onUpdate) => {
  let (todoContent, setTodoContent) = React.useState(() => Todo.content(todo))
  let (todoState, setTodoState) = React.useState(() => Idle)

  <li
    className="flex space-x-4 items-stretch bg-gray-100 dark:bg-gray-800 border-gray-100 pr-2 rounded">
    <label className="bg-gray-200 dark:bg-gray-700 flex items-center px-2">
      <input checked={Todo.isComplete(todo)} type_="checkbox" onChange={onToggle} />
      <span className="sr-only"> {todo->Todo.content->React.string} </span>
    </label>
    {switch todoState {
    | Idle =>
      <button
        className="justify-between flex-1 text-left overflow-hidden text-sm py-2"
        onClick={_ => setTodoState(_ => Updating)}>
        <span> {todo->Todo.content->React.string} </span>
        {switch todo {
        | Complete({completionDate}) =>
          <span className="text-xs text-gray-400 block mt-1">
            {React.string(
              " " ++
              Intl.DateTime.make(
                ~date=completionDate,
                ~locale=Some("sv-SE"),
                ~options=Intl.DateTime.Options.make(
                  ~dateStyle=Some(#short),
                  ~timeStyle=Some(#short),
                  (),
                ),
                (),
              ),
            )}
          </span>
        | Incomplete(_) => React.null
        }}
      </button>

    | Updating =>
      <label className="flex-1 py-2">
        <span className="sr-only"> {todo->Todo.content->React.string} </span>
        <textarea
          autoFocus={true}
          className="w-full dark:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-pink-300"
          type_="text"
          onChange={event => {
            let value = ReactEvent.Form.target(event)["value"]
            setTodoContent(_ => value)
          }}
          onKeyPress={event => {
            switch (ReactEvent.Keyboard.key(event), Js.String2.trim(todoContent)) {
            | ("Enter", "") => ()
            | ("Enter", content) =>
              onUpdate(content)
              setTodoState(_ => Idle)
            | _ => ()
            }
          }}
          value={Js.String2.trim(todoContent)}
        />
      </label>
    }}
    <button className="text-sm" onClick=onRemove>
      <Icon.Remove /> <span className="sr-only"> {React.string("Remove")} </span>
    </button>
  </li>
}
