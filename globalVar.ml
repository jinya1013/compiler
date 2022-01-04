open Syntax

exception GVarErr of string

let rec output_env oc env = 
  match env with
  | (x, a) :: envs -> 
    Id.output_id oc x; output_string oc (": "^(string_of_int a)^"\n"); 
    output_env oc envs
  | [] -> ()

let rec output_tenv oc env = 
  match env with
  | (x, a) :: envs -> 
    Id.output_id oc x; output_string oc ": ";  Type.output_type oc a; output_string oc " \n";
    output_tenv oc envs
  | [] -> ()

let gaddress = ref 2097152
let genv = ref M.empty (* グローバル変数名とそのアドレスの対応 *)
let gtenv = ref M.empty
let aenv = ref M.empty (* 配列名とその要素のサイズの対応 *)

let rec get_size senv = function
| Int(_) | Float(_) | Bool(_) ->  4 
| Neg(x, _) -> get_size senv x
| Var(x, _) -> M.find x senv
| Tuple(xs, _) -> 4
| Let ((x, _), e1, e2, _) -> get_size (M.add x (get_size senv e1) senv) e2
| Get(Var(x, _), _, _) -> 
  let (_, size) = M.find x !aenv in size (* aenvを引いて, 配列xに格納されている変数のサイズを獲得する *)
| Array(_) -> 4
| e -> output_prog stdout e; raise (GVarErr "[get_size]グローバル変数宣言時に指定されていない式の定義があります.\n")

let rec forward_address senv = function
| Tuple(xs, _) -> 
  let step = List.fold_left (fun b x -> forward_address senv x; b + get_size senv x) 0 xs in
  gaddress := !gaddress + step;
| Array(Int(len, _), elem, p) ->
  let step = len * (get_size senv elem) in
  gaddress := !gaddress + step;
| _ -> ()


let rec h x0 t0 x senv = function (* x0: gでの呼び出し元Letで定義される変数名, t0: gでの呼び出し元Letで定義される型名, x: hでの再帰呼出における直前の呼び出し元Letで定義される変数名 *)
  Array(Int(len, _), elem, p) ->
    forward_address senv elem;
    let size = get_size senv elem in
    aenv := M.add x (len, size) !aenv;
    (* output_string stdout ("#"^(string_of_int p)^" add ("^x0^", "^(string_of_int !gaddress)^") into genv\n"); *)
    genv := M.add x0 !gaddress !genv;
    gtenv := M.add x0 t0 !gtenv;
    gaddress := len * size + !gaddress;
| Let((x, t), e1, e2, _) -> 
  forward_address senv e1;
  h x0 t0 x (M.add x (get_size senv e1) senv) e2
| Tuple(xs, p) -> 
    let size = List.fold_left (fun b x -> b + (get_size senv x)) 0 xs in
    (* output_string stdout ("#"^(string_of_int p)^" add ("^x0^", "^(string_of_int !gaddress)^") into genv\n"); *)
    genv := M.add x0 !gaddress !genv;
    gtenv := M.add x0 t0 !gtenv;
    gaddress := size + !gaddress;
| e -> output_prog stdout e; raise (GVarErr "[h]グローバル変数定義のメインブランチに一次変数定義及び配列定義以外の命令があります.\n")

(* トップレベル関数 *)
let rec g senv = function
  Let((x, t), e1, e2, _) -> 
    h x t x senv e1;
    g (M.add x (get_size senv e1) senv) e2;
 | Unit(_) -> ()
 | _ -> raise (GVarErr "[g]グローバル変数定義のトップレベルで指定されていない命令があります.\n")

let rec f oc e = 
  g M.empty e;
  (* output_tenv stdout (M.bindings !gtenv); *)
  (* output_env stdout (M.bindings !genv); *)
  e
