let limit = ref 1000

let rec iter n e = (* ????????????????????????????????? (caml2html: main_iter) *)
  Format.eprintf "iteration %d@." n;
  if n = 0 then e else
  let e' = Elim.f (ConstFold.f (Inline.f (Assoc.f (Beta.f e)))) in
  if e = e' then e else
  iter (n - 1) e'

let lexbuf outchan l = (* ???????????��????��?��????��?????????????��?��???????��?��???????? (caml2html: main_lexbuf) *)
  Id.counter := 0;
  Typing.extenv := M.empty;
  Emit.f outchan
    (RegAlloc.f
       (Simm.f
          (Virtual.f
            (Closure.f
              (iter !limit
                (Alpha.f 
                  (KNormal.f
                    (Typing.f
                      (Parser.exp Lexer.token l)))))))))

let lexbuf_verbose outchan outchanr outchans outchanv outchanc outchani outchana outchank outchant outchanp l = (* ???????????��????��?��????��?????????????��?��???????��?��???????? (caml2html: main_lexbuf) *)
  Id.counter := 0;
  Typing.extenv := M.empty;
  Emit.f outchan
    (let r = RegAlloc.f
      (let s = Simm.f
        (let v = Virtual.f
          (let c = Closure.f
            (let i = iter !limit
              (let a = Alpha.f
                (let abc = RmExp.f 
                  (let k = KNormal.f
                    (let t = Typing.f
                      (
                        let p = Parser.exp Lexer.token l in output_string outchanp "AFTER PARSE\n"; Syntax.output_prog outchanp p; p
                      )
                    in output_string outchant "AFTER TYPING\n"; Syntax.output_prog outchant t; t)
                  in output_string outchank "AFTER KNORMAL\n"; KNormal.output_prog outchank k; k)
                in output_string outchank "AFTER REMOVE_COMMON_EXP\n"; KNormal.output_prog outchank abc; abc)
              in output_string outchana "AFTER ALPHA_TRANSFORM\n"; KNormal.output_prog outchana a; a)
            in output_string outchani "AFTER ITER\n"; KNormal.output_prog outchani i; i)
          in output_string outchanc "AFTER CLOSURE_TRANSFORM\n"; Closure.output_prog outchanc c; c)
        in output_string outchanv "AFTER VIRTUAL_TRANSFORM\n"; Asm.output_prog outchanv v; v)
      in output_string outchans "AFTER SIMM\n"; Asm.output_prog outchans s; s)
    in output_string outchanr "AFTER REGALLOC\n";Asm.output_prog outchanr r; r)

let string s = lexbuf_verbose stdout stdout stdout stdout stdout stdout stdout stdout stdout stdout (Lexing.from_string s) (* ???�?????????��?��????��????????�?�???��?????�?示�????? (caml2html: main_string) *)

let file f output_flag = (* ?????��?��???????��?��????��?????????????��?��???????��???????? (caml2html: main_file) *)
(* 

    Args
        f : string
          ??��?��????��?????????????��?��???????????(??�張�?�?�?)

    Returns
        retval : unit
          ??????

*)
  let inchan = open_in (f ^ ".ml") in
  let outchan = open_out (f ^ ".s") in
  if !output_flag then 
  (
    try
    let outchanr = open_out (f ^ ".opr") in
    let outchans = open_out (f ^ ".ops") in
    let outchanv = open_out (f ^ ".opv") in
    let outchanc = open_out (f ^ ".opc") in
    let outchani = open_out (f ^ ".opi") in
    let outchana = open_out (f ^ ".opa") in
    let outchank = open_out (f ^ ".opk") in
    let outchant = open_out (f ^ ".opt") in
    let outchanp = open_out (f ^ ".opp") in

    lexbuf_verbose outchan outchanr outchans outchanv outchanc outchani outchana outchank outchant outchanp (Lexing.from_channel inchan);

    close_in inchan;
    close_out outchan;
    close_out outchanr;
    close_out outchans;
    close_out outchanv;
    close_out outchanc;
    close_out outchani;
    close_out outchana;
    close_out outchank;
    close_out outchant;
    close_out outchanp;

    with e -> (close_in inchan; close_out outchan; raise e)
  )
  else
  (
    try
      lexbuf outchan (Lexing.from_channel inchan);
      close_in inchan;
      close_out outchan;
    with e -> (close_in inchan; close_out outchan; raise e)
  )

