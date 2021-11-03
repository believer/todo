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

let contentMatchesSearch = (todo, query) =>
  content(todo)->Js.String2.toLowerCase->Js.String2.includes(query->Js.String2.toLowerCase)

let completed = (todos, query) =>
  todos->Belt.Array.keep(((_, todo)) => {
    switch (isComplete(todo), query) {
    | (true, "") => true
    | (true, query) if contentMatchesSearch(todo, query) => true
    | (true, _)
    | (false, _) => false
    }
  })

let incomplete = (todos, query) =>
  todos->Belt.Array.keep(((_, todo)) =>
    switch (isComplete(todo), query) {
    | (false, "") => true
    | (false, query) if contentMatchesSearch(todo, query) => true
    | (false, _)
    | (true, _) => false
    }
  )
