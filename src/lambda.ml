module Eval = Eval

let parse (s : string) : Ast.expr =
  let lexbuf = Lexing.from_string s in
  Parser.prog Lexer.read lexbuf

let interp (s : string) : Eval.value =
  s |> parse |> Eval.eval []
