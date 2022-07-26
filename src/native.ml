let type_from_string s =
  let lexbuf = Lexing.from_string s in
  Parser.typ Lexer.read lexbuf


type native =
  {
    name : string;
    typ : string;
    fn : (Eval.value -> Eval.value);
  }

let get_int = function
  | Eval.VInt v -> v
  | v -> failwith ("Expected integer, found " ^ Eval.value_to_string v)

let get_bool = function
  | Eval.VBool v -> v
  | v -> failwith ("Expected bool, found " ^ Eval.value_to_string v)

let initial_env =
  [
    {
        name = "plus";
        typ = "int -> int -> int";
        fn = fun x -> VNative (fun y -> VInt (get_int x + get_int y))
    };
    {
        name = "is_true";
        typ = "bool -> bool";
        fn = fun x -> VBool (get_bool x)
    };
  ]

let add_functions_to_typ_env (env : Typecheck.env) : Typecheck.env =
  let f env' native =
    let typ = type_from_string native.typ in
    Typecheck.Env.add native.name (Typecheck.dont_generalize typ) env'
  in
  List.fold_left f env initial_env

let add_functions_to_eval_env (env : Eval.env) :  Eval.env =
  let f env' native =
    let fn = Eval.VNative native.fn in
    Eval.Env.add native.name fn env'
  in
  List.fold_left f env initial_env
