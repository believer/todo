@react.component
let make = (~label, ~id, ~value, ~onKeyPress=?, ~onChange) => {
  <>
    <label htmlFor=id> {React.string(label)} </label>
    <input id type_="text" onChange ?onKeyPress value />
  </>
}
