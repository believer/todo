%%raw("import './index.css'")

switch ReactDOM.querySelector("#root") {
| Some(root) => ReactDOM.render(<App />, root)
| None => () // Do nothing if root element does not exist
}
