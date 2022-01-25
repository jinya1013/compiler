let limit = ref 1000

let rec iter n e = (* ????????????????????????????????? (caml2html: main_iter) *)
  Format.eprintf "iteration %d@." n;
  if n = 0 then e else
  let e' = Elim.f (ConstFold.f (Inline.f (Assoc.f (Beta.f e)))) in
  if e = e' then e else
  iter (n - 1) e'

let lexbuf outchan utils_s_chan p = 
  Typing.extenv := M.empty;
  Emit.f outchan utils_s_chan
    (RegAlloc.f
      (VirtualElim.f
        (Simm.f
          (Virtual.f
            (Closure.f
              (iter !limit
                (Alpha.f 
                  (KNormal.f
                    (Typing.f
                      p)))))))))

let lexbuf_verbose outchan outchanr outchans outchanv outchanc outchani outchana outchank outchant utils_s_chan p = 
  Id.counter := 0;
  Typing.extenv := M.empty;
  Emit.f outchan utils_s_chan
    (let r = RegAlloc.f
      (let ve = VirtualElim.f
        (let s = Simm.f
          (let v = Virtual.f
            (let tc = Type_check.type_check_prog
              (let c = Closure.f
                (let i = iter !limit
                  (let a = Alpha.f
                    (let k = KNormal.f
                      (let t = Typing.f
                        p
                      in output_string outchant "AFTER TYPING\n"; Syntax.output_prog outchant t; t)
                    in output_string outchank "AFTER KNORMAL\n"; KNormal.output_prog outchank k; k)
                  in output_string outchana "AFTER ALPHA_TRANSFORM\n"; KNormal.output_prog outchana a; a)
                in output_string outchani "AFTER ITER\n"; KNormal.output_prog outchani i; i)
              in output_string outchanc "AFTER CLOSURE_TRANSFORM\n"; Closure.output_prog outchanc c; c)
            in tc)
          in output_string outchanv "AFTER VIRTUAL_TRANSFORM\n"; Asm.output_prog outchanv v; v)
        in output_string outchans "AFTER SIMM\n"; Asm.output_prog outchans s; s)
      in output_string outchanr "AFTER VIRTUAL_ELIM\n"; Asm.output_prog outchanr ve; ve)
    in output_string outchanr "AFTER REGALLOC\n";Asm.output_prog outchanr r; r)

let string s = 
  let utils_ml_chan = open_in "utils.ml" in
  let utils_s_chan = open_in "utils.s" in
  let utils = Parser.exp Lexer.token (Lexing.from_channel utils_ml_chan) in
  let mains = Parser.exp Lexer.token (Lexing.from_channel stdin) in
  let combined = Syntax.combine utils mains in

  output_string stdout "AFTER PARSE\n";
  Syntax.output_prog stdout combined;
  
  lexbuf_verbose stdout stdout stdout stdout stdout stdout stdout stdout stdout utils_s_chan combined;

  close_in utils_ml_chan;
  close_in utils_s_chan

let file f output_flag = (* ?????��?��???????��?��????��?????????????��?��???????��???????? (caml2html: main_file) *)
(* 
    Args
        f : string
          ??��?��????��?????????????��?��???????????(??�張�?�?�?)

    Returns
        retval : unit
          ??????
*)
  if f = "test/min-rt_cpuexp" then
  (
  Emit.is_minrt_cpuexp := true;
  let inchan = open_in (f ^ ".ml") in
  let gchan = open_in "globals.ml" in
  let utils_ml_chan = open_in "utils.ml" in
  let utils_s_chan = open_in "utils.s" in
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

    let globals = Parser.exp Lexer.token (Lexing.from_channel gchan) in
    let utils = Parser.exp Lexer.token (Lexing.from_channel utils_ml_chan) in
    let mains = Parser.exp Lexer.token (Lexing.from_channel inchan) in
    let combined = Syntax.combine (Syntax.combine globals utils) mains in

    output_string outchanp "AFTER PARSE\n";
    Syntax.output_prog outchanp combined;

    lexbuf_verbose outchan outchanr outchans outchanv outchanc outchani outchana outchank outchant utils_s_chan combined;

    close_in inchan;
    close_in gchan;
    close_in utils_ml_chan;
    close_in utils_s_chan;
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
      let globals = Parser.exp Lexer.token (Lexing.from_channel gchan) in
      let utils = Parser.exp Lexer.token (Lexing.from_channel utils_ml_chan) in
      let mains = Parser.exp Lexer.token (Lexing.from_channel inchan) in
      let combined = Syntax.combine (Syntax.combine globals utils) mains in

      lexbuf outchan utils_s_chan combined;
      close_in inchan;
      close_in gchan;
      close_in utils_ml_chan;
      close_in utils_s_chan;
      close_out outchan;
    with e -> (close_in inchan; close_in gchan; close_in utils_ml_chan; close_in utils_s_chan; close_out outchan; raise e)
  )
  )
  else 
  (
  (
  Emit.is_minrt_cpuexp := false;
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

    let mains = Parser.exp Lexer.token (Lexing.from_channel inchan) in

    lexbuf_verbose outchan outchanr outchans outchanv outchanc outchani outchana outchank outchant inchan mains;

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
      let mains = Parser.exp Lexer.token (Lexing.from_channel inchan) in
      lexbuf outchan inchan mains;
      close_in inchan;
      close_out outchan;
    with e -> (close_in inchan; close_out outchan; raise e)
  )
  )
  )

let () = 
  let files = ref [] in
  let output_flag = ref true in
  Arg.parse
    [
      ("-inline", Arg.Int(fun i -> Inline.threshold := i), "maximum size of functions inlined");
      ("-iter", Arg.Int(fun i -> limit := i), "maximum number of optimizations iterated");
      ("-output", Arg.Unit(fun () -> output_flag := true), "whether output middle expression or not");
      ("-hp", Arg.String(fun s -> Emit.ftp_address := (int_of_string s); Emit.hp_address := !Emit.ftp_address + 256; GlobalVar.gaddress := !Emit.ftp_address + 256 ), "the initial address of the heap pointer");
      ("-sp", Arg.String(fun s -> Emit.sp_address := (int_of_string s) - 4), "the initial address of the stack pointer")
    ]
    (fun s -> files := !files @ [s])
    ("Mitou Min-Caml Compiler (C) Eijiro Sumii\n" ^
     Printf.sprintf "usage: %s [-inline m] [-iter n] ...filenames without \".ml\"..." Sys.argv.(0));
  List.iter
    (fun f -> ignore (file f output_flag))
    !files