// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Belt_Array from "rescript/lib/es6/belt_Array.js";

function isComplete(todo) {
  if (todo.TAG === /* Complete */0) {
    return true;
  } else {
    return false;
  }
}

function toggle(todo) {
  if (todo.TAG === /* Complete */0) {
    return {
            TAG: /* Incomplete */1,
            content: todo.content
          };
  } else {
    return {
            TAG: /* Complete */0,
            content: todo.content,
            completionDate: new Date()
          };
  }
}

function content(todo) {
  return todo.content;
}

function updateContent(todo, updatedTodo) {
  if (todo.TAG === /* Complete */0) {
    return {
            TAG: /* Complete */0,
            content: updatedTodo,
            completionDate: todo.completionDate
          };
  } else {
    return {
            TAG: /* Incomplete */1,
            content: updatedTodo
          };
  }
}

function contentMatchesSearch(todo, query) {
  return todo.content.toLowerCase().includes(query.toLowerCase());
}

function completed(todos, query) {
  return Belt_Array.keep(todos, (function (param) {
                var todo = param[1];
                var match = isComplete(todo);
                if (match && (query === "" || contentMatchesSearch(todo, query))) {
                  return true;
                } else {
                  return false;
                }
              }));
}

function incomplete(todos, query) {
  return Belt_Array.keep(todos, (function (param) {
                var todo = param[1];
                var match = isComplete(todo);
                if (match || !(query === "" || contentMatchesSearch(todo, query))) {
                  return false;
                } else {
                  return true;
                }
              }));
}

export {
  isComplete ,
  toggle ,
  content ,
  updateContent ,
  contentMatchesSearch ,
  completed ,
  incomplete ,
  
}
/* No side effect */
