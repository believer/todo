module H1 = {
  @react.component
  let make = (~children) => {
    <h1 className="text-4xl font-bold mb-4"> children </h1>
  }
}

module H2 = {
  @react.component
  let make = (~children) => {
    <h2 className="text-xl font-bold my-4 pb-1 border-b dark:border-gray-800"> children </h2>
  }
}
