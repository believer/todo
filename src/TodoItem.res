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
