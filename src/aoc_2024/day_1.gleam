import gleam/int
import gleam/list
import gleam/string

pub fn parse(input: String) -> List(#(Int, Int)) {
  string.trim_end(input)
  |> string.split("\n")
  |> list.map(fn(a: String) -> #(String, String) {
    case string.split_once(a, " ") {
      Error(_) -> panic as "invalid input"
      Ok(#(a, b)) -> #(a, b)
    }
  })
  |> list.map(fn(data: #(String, String)) -> #(Int, Int) {
    let #(astr, bstr) = data
    let a = case int.base_parse(string.trim(astr), 10) {
      Error(_) -> {
        panic as { "not a number: " <> astr }
      }
      Ok(a) -> a
    }
    let b = case int.base_parse(string.trim(bstr), 10) {
      Error(_) -> {
        panic as { "not a number: " <> bstr }
      }
      Ok(b) -> b
    }
    #(a, b)
  })
}

pub fn pt_1(input: List(#(Int, Int))) -> Int {
  let a_side =
    list.map(input, fn(data: #(Int, Int)) -> Int {
      let #(a, _) = data
      a
    })
    |> list.sort(by: int.compare)

  let b_side =
    list.map(input, fn(data: #(Int, Int)) -> Int {
      let #(_, b) = data
      b
    })
    |> list.sort(by: int.compare)

  list.zip(a_side, b_side)
  |> list.map(fn(data: #(Int, Int)) {
    let #(a, b) = data
    int.subtract(a, b)
    |> int.absolute_value()
  })
  |> list.fold(0, int.add)
}

pub fn pt_2(input: List(#(Int, Int))) -> Int {
  let b_side =
    list.map(input, fn(data: #(Int, Int)) -> Int {
      let #(_, b) = data
      b
    })
    |> list.sort(by: int.compare)

  list.map(input, fn(data: #(Int, Int)) -> Int {
    let #(a, _) = data
    a
  })
  |> list.sort(by: int.compare)
  |> list.map(fn(data: Int) -> Int {
    data * list.count(b_side, fn(b) { b == data })
  })
  |> list.fold(0, int.add)
}
