type t =
  | Complete({content: string, completionDate: Js.Date.t})
  | Incomplete({content: string})

let isComplete = todo =>
  switch todo {
  | Complete(_) => true
  | Incomplete(_) => false
  }

let toggle = todo =>
  switch todo {
  | Complete({content}) => Incomplete({content: content})
  | Incomplete({content}) => Complete({content: content, completionDate: Js.Date.make()})
  }

let content = todo =>
  switch todo {
  | Incomplete({content}) => content
  | Complete({content}) => content
  }

let updateContent = (todo, updatedTodo) =>
  switch todo {
  | Complete(todo) => Complete({...todo, content: updatedTodo})
  | Incomplete(_) => Incomplete({content: updatedTodo})
  }
