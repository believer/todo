type t =
  | Complete({id: float, content: string, completedTime: Js.Date.t})
  | Incomplete({content: string, id: float})
