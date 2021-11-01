// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";

function App(Props) {
  var match = React.useReducer((function (state, action) {
          if (typeof action === "number") {
            return {
                    todos: Belt_Array.concat(state.todos, [{
                            TAG: /* Incomplete */1,
                            content: state.input,
                            id: new Date().getTime()
                          }]),
                    input: ""
                  };
          }
          if (action.TAG !== /* RemoveTodo */0) {
            return {
                    todos: state.todos,
                    input: action._0
                  };
          }
          var id = action._0;
          return {
                  todos: Belt_Array.keepWithIndex(state.todos, (function (param, i) {
                          return i !== id;
                        })),
                  input: state.input
                };
        }), {
        todos: [],
        input: ""
      });
  var dispatch = match[1];
  var state = match[0];
  var match$1 = state.todos.length;
  return React.createElement("div", undefined, React.createElement("label", {
                  htmlFor: "new-todo"
                }, "New todo"), React.createElement("input", {
                  id: "new-todo",
                  type: "text",
                  value: state.input,
                  onKeyPress: (function ($$event) {
                      if ($$event.key === "Enter") {
                        return Curry._1(dispatch, /* AddTodo */0);
                      }
                      
                    }),
                  onChange: (function ($$event) {
                      var value = $$event.target.value;
                      return Curry._1(dispatch, {
                                  TAG: /* InputChange */1,
                                  _0: value
                                });
                    })
                }), match$1 !== 0 ? React.createElement("ul", undefined, Belt_Array.map(state.todos, (function (todo) {
                          if (todo.TAG === /* Complete */0) {
                            return null;
                          } else {
                            return React.createElement("li", {
                                        key: String(todo.id)
                                      }, todo.content);
                          }
                        }))) : "You don't have any todos");
}

var make = App;

export {
  make ,
  
}
/* react Not a pure module */
