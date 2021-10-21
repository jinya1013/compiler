(* SPARC assembly with a few virtual instructions *)

type id_or_imm = V of Id.t | C of int
type t = (* 命令の列 (caml2html: sparcasm_t) *)
| Ans of exp * Syntax.pos
| Let of (Id.t * Type.t) * exp * t * Syntax.pos
and exp = (* 一つ一つの命令に対応する式 (caml2html: sparcasm_exp) *)
  | Nop
  | Set of int
  | SetL of Id.l
  | Mov of Id.t
  | Neg of Id.t
  | Add of Id.t * id_or_imm
  | Sub of Id.t * id_or_imm
  | SLL of Id.t * id_or_imm
  | Ld of Id.t * id_or_imm
  | St of Id.t * Id.t * id_or_imm
  | FMov of Id.t
  | FNeg of Id.t
  | FAdd of Id.t * Id.t
  | FSub of Id.t * Id.t
  | FMul of Id.t * Id.t
  | FDiv of Id.t * Id.t
  | Comment of string
  (* virtual instructions *)
  | IfEq of Id.t * id_or_imm * t * t
  | IfLE of Id.t * id_or_imm * t * t
  | IfGE of Id.t * id_or_imm * t * t (* 左右対称ではないので必要 *)
  | IfFEq of Id.t * Id.t * t * t
  | IfFLE of Id.t * Id.t * t * t
  (* closure address, integer arguments, and float arguments *)
  | CallCls of Id.t * Id.t list * Id.t list
  | CallDir of Id.l * Id.t list * Id.t list
  | Save of Id.t * Id.t (* レジスタ変数の値をスタック変数へ保存 (caml2html: sparcasm_save) *)
  | Restore of Id.t (* スタック変数から値を復元 (caml2html: sparcasm_restore) *)
type fundef = { name : Id.l; args : Id.t list; fargs : Id.t list; body : t; ret : Type.t }
(* プログラム全体 = 浮動小数点数テーブル + トップレベル関数 + メインの式 (caml2html: sparcasm_prog) *)
type prog = Prog of (Id.l * float) list * fundef list * t

let pos_of_t  = function
  | Ans (_, p) -> p
  | Let (_, _, _, p) -> p

let fletd(x, e1, e2, p) = Let((x, Type.Float), e1, e2, p)
let seq(e1, e2, p) = Let((Id.gentmp Type.Unit, Type.Unit), e1, e2, p)

let regs = (* Array.init 16 (fun i -> Printf.sprintf "%%r%d" i) *)
  [| 
     "%x6"; "%x7"; "%x8"; "%x9"; "%x10"; "%x11"; "%x12"; "%x13";
     "%x14"; "%x15"; "%x16"; "%x17"; "%x18"; "%x19"; "%x20";
     "%x21"; "%x22"; "%x23"; "%x24"; "%x25"; "%x26"; "%x27";
     "%x28"; "%x29"; "%x30"; "%x31"
  |]
(* 関数呼び出し時は, クロージャのアドレスをx6に, 引数をx7, x8, に, 戻り番地をx1に入れる *)
let fregs = Array.init 16 (fun i -> Printf.sprintf "%%f%d" (i * 2))
let allregs = Array.to_list regs
let allfregs = Array.to_list fregs
let reg_cl = "%x4" (* closure address (caml2html: sparcasm_regcl) *)
let reg_sw = "%x5"(* temporary for swap *)
let reg_fsw = "%f31" (* temporary for swap *)
let reg_sp = "%x2" (* stack pointer *)
let reg_hp = "%x3" (* heap pointer (caml2html: sparcasm_reghp) *)
let reg_ra = "%x1" (* return address *)

(* let co_freg_table = (* 元々は浮動小数は倍精度で管理していたため, その先頭レジスタと後方レジスタを対応づけるハッシュテーブル*)
  let ht = Hashtbl.create 16 in
  for i = 0 to 15 do
    Hashtbl.add
      ht
      (Printf.sprintf "%%f%d" (i * 2))
      (Printf.sprintf "%%f%d" (i * 2 + 1))
  done;
  ht
let co_freg freg = Hashtbl.find co_freg_table freg "companion" freg *)

(* super-tenuki *)

(* xs = S.empty と初期化して呼べば, ysから被りをなくすような操作になる *)
let rec remove_and_uniq xs = function
  | [] -> []
  | x :: ys when S.mem x xs -> remove_and_uniq xs ys
  | x :: ys -> x :: remove_and_uniq (S.add x xs) ys

(* free variables in the order of use (for spilling) (caml2html: sparcasm_fv) *)
let fv_id_or_imm = function V(x) -> [x] | _ -> []
let rec fv_exp = function
  | Nop | Set(_) | SetL(_) | Comment(_) | Restore(_) -> []
  | Mov(x) | Neg(x) | FMov(x) | FNeg(x) | Save(x, _) -> [x]
  | Add(x, y') | Sub(x, y') | SLL(x, y') | Ld(x, y')  -> x :: fv_id_or_imm y'
  | St(x, y, z')  -> x :: y :: fv_id_or_imm z'
  | FAdd(x, y) | FSub(x, y) | FMul(x, y) | FDiv(x, y) -> [x; y]
  | IfEq(x, y', e1, e2) | IfLE(x, y', e1, e2) | IfGE(x, y', e1, e2) -> x :: fv_id_or_imm y' @ remove_and_uniq S.empty (fv e1 @ fv e2) (* uniq here just for efficiency *)
  | IfFEq(x, y, e1, e2) | IfFLE(x, y, e1, e2) -> x :: y :: remove_and_uniq S.empty (fv e1 @ fv e2) (* uniq here just for efficiency *)
  | CallCls(x, ys, zs) -> x :: ys @ zs
  | CallDir(_, ys, zs) -> ys @ zs
and fv = function
  | Ans(exp, _) -> fv_exp exp
  | Let((x, t), exp, e, _) ->
      fv_exp exp @ remove_and_uniq (S.singleton x) (fv e)
let fv e = remove_and_uniq S.empty (fv e)

(* 式 e1 の後ろに 式 e2 が入ってくるようにする *)
let rec concat e1 xt e2 =
  match e1 with
  | Ans(exp, p) -> Let(xt, exp, e2, p)
  | Let(yt, exp, e1', p) -> Let(yt, exp, concat e1' xt e2, p)

let align i = (if i mod 8 = 0 then i else i + 4)

let rec output_id_or_imm outchan = function
  | V (x) -> Id.output_id outchan x
  | C (c) -> output_string outchan (string_of_int c)
  
and output_t outchan depth = function
  | Ans(e, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "ANS";
    output_exp outchan (depth + 1) p e;
  )
  | Let((x, t), e1, e2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "LET";
    Id.output_tab2 outchan (depth+1) p;
    Id.output_id outchan x;
    output_string outchan " : ";
    Type.output_type outchan t;
    output_exp outchan (depth + 1) p e1;
    output_t outchan (depth + 1) e2;
  )
and output_exp outchan depth p = function
  | Nop -> 
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "NOP"
  )
  | Set(c) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "SET ";
    output_string outchan (string_of_int c)
  )
  | SetL (label) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "SETLABEL ";
    Id.output_label outchan label
  )
  | Mov (x) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "MOVE ";
    Id.output_id outchan x
  )
  | Neg (x) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "NEG ";
    Id.output_id outchan x
  )
  | Add (x, c) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "ADD ";
    Id.output_id outchan x;
    output_string outchan " ";
    output_id_or_imm outchan c;
  )
  | Sub (x, c) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "SUB ";
    Id.output_id outchan x;
    output_string outchan " ";
    output_id_or_imm outchan c;
  )
  | SLL (x, c) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "SLL ";
    Id.output_id outchan x;
    output_string outchan " ";
    output_id_or_imm outchan c;
  )
  | Ld (x, offset) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "LD ";
    Id.output_id outchan x;
    output_string outchan " ";
    output_id_or_imm outchan offset;
  )
  
  | St (x, y, offset) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "ST ";
    Id.output_id outchan x;
    output_string outchan " ";
    Id.output_id outchan y;
    output_string outchan " ";
    output_id_or_imm outchan offset;
  )
  | FMov (x) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FMOVE ";
    Id.output_id outchan x
  )
  | FNeg (x) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FNEG ";
    Id.output_id outchan x
  )
  | FAdd (x, c) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FADD ";
    Id.output_id outchan x;
    output_string outchan " ";
    Id.output_id outchan c;
  )
  | FSub (x, c) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FSUB ";
    Id.output_id outchan x;
    output_string outchan " ";
    Id.output_id outchan c;
  )
  | FMul (x, c) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FMUL ";
    Id.output_id outchan x;
    output_string outchan " ";
    Id.output_id outchan c;
  )
  | FDiv (x, c) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FDIV ";
    Id.output_id outchan x;
    output_string outchan " ";
    Id.output_id outchan c;
  )
  | Comment (str) -> 
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "/* ";
    output_string outchan str;
    output_string outchan " */"
  )
  (* virtual instructions *)
  | IfEq (x, c, e1, e2) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "IFEQ ";
    Id.output_id outchan x;
    output_string outchan " ";
    output_id_or_imm outchan c;
    output_t outchan (depth + 1) e1;
    output_t outchan (depth + 1) e2;
  )
  | IfLE (x, c, e1, e2) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "IFLE ";
    Id.output_id outchan x;
    output_string outchan " ";
    output_id_or_imm outchan c;
    output_t outchan (depth + 1) e1;
    output_t outchan (depth + 1) e2;
  )
  | IfGE (x, c, e1, e2) ->(* 左右対称ではないので必要 *)
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "IFGE ";
    Id.output_id outchan x;
    output_string outchan " ";
    output_id_or_imm outchan c;
    output_t outchan (depth + 1) e1;
    output_t outchan (depth + 1) e2;
  ) 
  | IfFEq (x, c, e1, e2) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "IFFEQ ";
    Id.output_id outchan x;
    output_string outchan " ";
    Id.output_id outchan c;
    output_t outchan (depth + 1) e1;
    output_t outchan (depth + 1) e2;
  )
  | IfFLE (x, c, e1, e2) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "IFFLE ";
    Id.output_id outchan x;
    output_string outchan " ";
    Id.output_id outchan c;
    output_t outchan (depth + 1) e1;
    output_t outchan (depth + 1) e2;
  )
  (* closure address, integer arguments, and float arguments *)
  | CallCls (x, intargs, floatargs) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "CALLCLS ";
    Id.output_id outchan x;
    output_string outchan " ";
    Id.output_id_list outchan intargs;
    output_string outchan " ";
    Id.output_id_list outchan floatargs;
  )
  | CallDir (x, intargs, floatargs) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "CALLDIR ";
    Id.output_label outchan x;
    output_string outchan " ";
    Id.output_id_list outchan intargs;
    output_string outchan " ";
    Id.output_id_list outchan floatargs;
  )
  | Save (x, m) -> (* レジスタ変数の値をスタック変数へ保存 (caml2html: sparcasm_save) *)
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "SAVE ";
    Id.output_id outchan x;
    output_string outchan " ";
    Id.output_id outchan m;
  )
  | Restore (m) -> (* スタック変数から値を復元 (caml2html: sparcasm_restore) *)
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "RESTORE ";
    Id.output_id outchan m;
  )
and output_func outchan depth { name = funname; args = intargs; fargs = floatargs; body = funbody; ret = returntype } = 
let p = pos_of_t funbody in
  Id.output_tab2 outchan depth p;
  output_string outchan "NAME : ";
  Id.output_label outchan funname;
  Id.output_tab2 outchan depth p;
  output_string outchan "INTARGS : ";
  Id.output_id_list outchan intargs;
  Id.output_tab2 outchan depth p;
  output_string outchan "FLOATARGS : ";
  Id.output_id_list outchan floatargs;
  Id.output_tab2 outchan depth p;
  output_string outchan "FUNBODY : ";
  output_t outchan (depth + 1) funbody;
  Id.output_tab2 outchan depth p;
  output_string outchan "RETURNTYPE : ";
  Type.output_type outchan returntype
and output_prog outchan (Prog(table, f, e)) =
  output_string outchan " \t";
  output_string outchan "FLOAT_TABLE";
  List.iter 
  (
    fun (label, fl) ->
    Id.output_tab outchan 1;
    Id.output_label outchan label;
    output_string outchan " : ";
    output_string outchan (string_of_float fl)
  ) 
  table;

  Id.output_tab2 outchan 0 (-1);
  output_string outchan "FUNDEF";
  List.iter 
  (
    fun _f ->
    (* Id.output_tab outchan 0; *)
    output_func outchan 1 _f
  ) 
  f;
  Id.output_tab2 outchan 0 (-1);
  output_string outchan "MAIN";
  output_t outchan 1 e;
  output_string outchan "\n";