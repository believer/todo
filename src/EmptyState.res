module NoTodos = {
  @react.component
  let make = () => {
    <div
      className="bg-gray-100 p-8 mt-4 text-center text-sm text-gray-600 rounded dark:bg-gray-800 dark:text-gray-200">
      {React.string("You don't have any todos. Add one using the input above.")}
    </div>
  }
}

module NoSearchResults = {
  @react.component
  let make = (~query) => {
    <div
      className="bg-gray-100 p-8 mt-4 text-center text-sm text-gray-600 rounded dark:bg-gray-800 dark:text-gray-200">
      {React.string("There are no todos that match ")} <strong> {React.string(query)} </strong>
    </div>
  }
}
