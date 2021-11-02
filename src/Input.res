@react.component
let make = (~label, ~id, ~value, ~onKeyPress=?, ~onChange) => {
  <>
    <label className="block text-sm font-bold text-gray-700 mb-2" htmlFor=id>
      {React.string(label)}
    </label>
    <input
      className="border-2 border-coolGray-300 py-2 px-8 rounded-sm w-full appearance-none bg-transparent dark:border-coolGray-600 focus:outline-none focus:ring-2 focus:ring-offset-4 dark:focus:ring-offset-coolGray-800 focus:ring-pink-300"
      id
      type_="text"
      onChange={event => {
        let value = ReactEvent.Form.target(event)["value"]
        onChange(value)
      }}
      ?onKeyPress
      value
    />
  </>
}
