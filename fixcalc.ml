(*
  Call Fixpoint Calculator for numerical domains
*)

open Globals
open Gen
open Cformula
module DD = Debug
module Pr = Cprinter
module CP = Cpure
module MCP = Mcpure
module TP = Tpdispatcher

(******************************************************************************)

(* Operators *)
let op_lt = "<"
let op_lte = "<="
let op_gt = ">"
let op_gte = ">="
let op_eq = "="
let op_neq = "!="
let op_and = " && "
let op_or = " || "
let op_add = "+"
let op_sub = "-"

(******************************************************************************)

let is_self = CP.is_self_var

let is_null = CP.is_null

let rec string_of_elems elems string_of sep = match elems with
  | [] -> ""
  | h::[] -> string_of h
  | h::t -> (string_of h) ^ sep ^ (string_of_elems t string_of sep)

(******************************************************************************)
let gen_fixcalc_file str_fc=
  let file_name = (List.hd !Globals.source_files) in
  let out_chn =
    let reg = Str.regexp "\(\.ss\)\|\(.slk\)" in
    let file_name1 = "logs/gen_" ^ (Str.global_replace reg ".fc" file_name) in
    (* let _ = print_endline (file_name1 ^ ".fc") in *)
    let _ = print_endline ("\n generating fixcalc file : " ^ file_name1) in
    (try Unix.mkdir "logs" 0o750 with _ -> ());
    (*open_out*) open_out_gen [Open_wronly; Open_append; Open_creat] 0o600 (file_name1)
  in
  let _ = output_string out_chn str_fc in
  let _ = close_out out_chn in
  ()


(******************************************************************************)

let fixcalc_of_spec_var x = match x with
  | CP.SpecVar (Named _, id, Unprimed) -> if String.compare id self =0 then id else "NOD" ^ id
  | CP.SpecVar (Named _, id, Primed) -> "NODPRI" ^ id
(* TODO: Handle mixture of non-numerical and numerical variables *)
(* Still have problem with the order of parameters of relation *)
(*  | CP.SpecVar (Named _, id, Unprimed)*)
(*  | CP.SpecVar (Named _, id, Primed) -> *)
(*    report_error no_pos "Relation contains non-numerical variables"*)
  | CP.SpecVar (_, id, Unprimed) -> id
  | CP.SpecVar (_, id, Primed) -> "PRI" ^ id

let fixcalc_of_spec_var x =
DD.no_1 "fixcalc_of_spec_var" !CP.print_sv (fun c->c) fixcalc_of_spec_var x

let rec fixcalc_of_exp_list e op number = match number with
  | 0 -> ""
  | 1 -> fixcalc_of_exp e
  | n -> fixcalc_of_exp e ^ op ^ (fixcalc_of_exp_list e op (n-1))

and fixcalc_of_exp e = match e with
  | CP.Null _ -> "null"
  | CP.Var (x, _) -> fixcalc_of_spec_var x
  | CP.IConst (i, _) -> string_of_int i
  | CP.FConst (f, _) -> string_of_float f
  | CP.Add (e1, e2, _) -> fixcalc_of_exp e1 ^ op_add ^ fixcalc_of_exp e2 
  | CP.Subtract (e1, e2, _) -> 
    fixcalc_of_exp e1 ^ op_sub ^ "(" ^ fixcalc_of_exp e2 ^ ")"
  | CP.Mult (e1, e2, _) -> 
    begin
      match e1, e2 with
      | (CP.IConst (i,_), CP.IConst (j,_)) -> string_of_int (i*j)
      | (CP.IConst (i,_),_) -> fixcalc_of_exp_list e2 op_add i
      | (_,CP.IConst (i,_)) -> fixcalc_of_exp_list e1 op_add i
      | _ -> illegal_format ("Fixcalc.fixcalc_of_exp: Not supported expression")
    end
  | _ -> illegal_format ("Fixcalc.fixcalc_of_exp: Not supported expression")

let fixcalc_of_bool b =
  match b with
    | true -> "1=1"
    | false -> "1=0"

let rec fixcalc_of_b_formula b =
  let (pf, _) = b in
  match pf with
    | CP.BConst (b,_) -> fixcalc_of_bool b 
    | CP.BVar (x, _) -> fixcalc_of_spec_var x
    | CP.Lt (e1, e2, _) -> fixcalc_of_exp e1 ^ op_lt ^ fixcalc_of_exp e2
    | CP.Lte (e1, e2, _) -> fixcalc_of_exp e1 ^ op_lte ^ fixcalc_of_exp e2
    | CP.Gt (e1, e2, _) -> fixcalc_of_exp e1 ^ op_gt ^ fixcalc_of_exp e2
    | CP.Gte (e1, e2, _) -> fixcalc_of_exp e1 ^ op_gte ^ fixcalc_of_exp e2
    | CP.Eq (e1, e2, _) -> 
      if is_null e2 then fixcalc_of_exp e1 ^ op_lte ^ "0"
      else
      if is_null e1 then fixcalc_of_exp e2 ^ op_lte ^ "0"
      else fixcalc_of_exp e1 ^ op_eq ^ fixcalc_of_exp e2
    | CP.Neq (e1, e2, _) ->
      if is_null e1 then 
        let s = fixcalc_of_exp e2 in s ^ op_gt ^ "0"
      else
      if is_null e2 then 
        let s = fixcalc_of_exp e1 in s ^ op_gt ^ "0"
      else
        let s = fixcalc_of_exp e1 in
        let t = fixcalc_of_exp e2 in
        "((" ^ s ^ op_lt ^ t ^ ")" ^ op_or ^ "(" ^ s ^ op_gt ^ t ^ "))"
    | CP.RelForm (id,args,_) -> 
      if List.exists 
        (fun x -> match x with | CP.IConst _ -> true | _ -> false) args 
      then "0=0"
      else
        (fixcalc_of_spec_var id) ^ "(" ^ 
          (string_of_elems args fixcalc_of_exp ",") ^ ")"
    | _ -> 
      illegal_format ("Fixcalc.fixcalc_of_b_formula: Do not support bag, list")

let rec fixcalc_of_pure_formula f = match f with
  | CP.BForm ((CP.BVar (x,_),_),_) -> fixcalc_of_spec_var x ^ op_gt ^ "0"
  | CP.BForm (b,_) -> fixcalc_of_b_formula b
  | CP.And (p1, p2, _) ->
    "(" ^ fixcalc_of_pure_formula p1 ^ op_and ^ fixcalc_of_pure_formula p2 ^ ")"
  | CP.AndList b -> 
    (match b with 
    | [] -> fixcalc_of_pure_formula (CP.mkFalse no_pos) 
    | (_,x)::t -> fixcalc_of_pure_formula 
      (List.fold_left (fun a (_,c) -> CP.mkAnd a c no_pos) x t)
    )
  | CP.Or (p1, p2,_ , _) ->
    "(" ^ fixcalc_of_pure_formula p1 ^ op_or ^ fixcalc_of_pure_formula p2 ^ ")"
  | CP.Not (p,_ , _) -> 
    begin
    match p with
    | CP.BForm ((CP.BVar (x,_),_),_) -> fixcalc_of_spec_var x ^ op_lte ^ "0"
    | _ -> illegal_format ("Fixcalc.fixcalc_of_pure_formula: 
                            Not supported Not-formula")
    end
  | CP.Forall (sv, p,_ , _) ->
    " (forall (" ^ fixcalc_of_spec_var sv ^ ":" ^
                   fixcalc_of_pure_formula p ^ ")) "
  | CP.Exists (sv, p,_ , _) ->
    " (exists (" ^ fixcalc_of_spec_var sv ^ ":" ^
                   fixcalc_of_pure_formula p ^ ")) "

let rec fixcalc_of_h_formula f = match f with
  | Star {h_formula_star_h1 = h1; h_formula_star_h2 = h2} ->
    "(" ^ fixcalc_of_h_formula h1 ^ op_and ^ fixcalc_of_h_formula h2 ^ ")"
  | StarMinus {h_formula_starminus_h1 = h1; h_formula_starminus_h2 = h2} ->
    "(" ^ fixcalc_of_h_formula h1 ^ op_and ^ fixcalc_of_h_formula h2 ^ ")"
  | Conj {h_formula_conj_h1 = h1; h_formula_conj_h2 = h2}
  | ConjStar {h_formula_conjstar_h1 = h1; h_formula_conjstar_h2 = h2}
  | ConjConj {h_formula_conjconj_h1 = h1; h_formula_conjconj_h2 = h2} ->
    "(" ^ fixcalc_of_h_formula h1 ^ op_or ^ fixcalc_of_h_formula h2 ^ ")"
  | ThreadNode {h_formula_thread_node = sv; h_formula_thread_name = c;} ->
    (*TOCHECK: currently ignore delayed and resource*)
    if CP.is_self_spec_var sv then self ^ op_gt ^ "0"
    else c ^ "(" ^ (fixcalc_of_spec_var sv) ^ "," ^
                   (string_of_elems [] fixcalc_of_spec_var ",") ^ ")"
  | DataNode {h_formula_data_node = sv; h_formula_data_name = c;
              h_formula_data_arguments = svs} ->
    (* if CP.is_self_spec_var sv then self ^ op_gt ^ "0" *)
    (* else c ^ "(" ^ (fixcalc_of_spec_var sv) ^ "," ^  *)
    (*                (string_of_elems svs fixcalc_of_spec_var ",") ^ ")" *)
        (fixcalc_of_spec_var sv)  ^ op_gt ^ "0"
  | ViewNode {h_formula_view_node = sv; h_formula_view_name = c;
              h_formula_view_arguments = svs} ->
    if CP.is_self_spec_var sv then self ^ op_gt ^ "0"
    else if (List.length svs = 0) then c ^ "(" ^ (fixcalc_of_spec_var sv) ^ ")"
    else c ^ "(" ^ (fixcalc_of_spec_var sv) ^ "," ^
                   (string_of_elems svs fixcalc_of_spec_var ",") ^ ")"
  | HTrue -> "HTrue"
  | HFalse -> "HFalse"
  | HEmp -> "0=0"
  | HRel _ -> "HTrue"
  | Hole _ | FrmHole _ | HVar _ ->
    illegal_format ("Fixcalc.fixcalc_of_h_formula: Not supported Hole-formula")
  | Phase _ -> Error.report_no_pattern ()

let fixcalc_of_mix_formula f = match f with
  | MCP.MemoF _ -> ""
  | MCP.OnePF pf -> fixcalc_of_pure_formula pf

let rec fixcalc_of_formula e = match e with
  | Or _ ->
    illegal_format ("Fixcalc.fixcalc_of_formula: Not supported Or-formula")
  | Base {formula_base_heap = h; formula_base_pure = p} ->
    "(" ^ fixcalc_of_h_formula h ^ op_and ^ fixcalc_of_mix_formula p ^ ")"
  | Exists {formula_exists_qvars = svs; formula_exists_heap = h;
            formula_exists_pure = p} ->
    " exists (" ^ (string_of_elems svs fixcalc_of_spec_var ",") ^ ": " ^
    fixcalc_of_h_formula h ^ op_and ^ fixcalc_of_mix_formula p ^ ")"

(******************************************************************************)

let subst_inv_lower_view_x view_invs f0=
   (*****************************************)
  let rec subst_h (hf: h_formula)=
     match hf with
      | Star s -> begin
          let nh1, ps1 = subst_h s.h_formula_star_h1 in
          let nh2, ps2 = subst_h s.h_formula_star_h2 in
          match nh1,nh2 with
            | HEmp,HEmp -> HEmp,ps1@ps2
            | HEmp,_ -> nh2,ps1@ps2
            | _ , HEmp -> nh1,ps1@ps2
            | _ ->
                  (Star {s with h_formula_star_h1 = nh1;
                      h_formula_star_h2 = nh2
                  }, ps1@ps2)
        end
      | ViewNode vn -> begin
          try
            let (_,(form_args, inv)) = List.find (fun (s1,_) -> String.compare s1 vn.h_formula_view_name = 0) view_invs in
            let sst = List.combine form_args (vn.h_formula_view_node::vn.h_formula_view_arguments) in
            (HEmp, [ (CP.subst sst (MCP.pure_of_mix inv))])
          with _ -> hf,[]
        end
      | _ -> hf,[]
  in
  let rec subst_helper f=
    match f with
      | Base fb ->
            let nh,ps = subst_h fb.formula_base_heap in
            let p = CP.conj_of_list ((MCP.pure_of_mix fb.formula_base_pure)::ps) (pos_of_formula f) in
             Base {fb with formula_base_pure = MCP.mix_of_pure p;
                     formula_base_heap = nh;} 
      | Exists _ ->
            let quans,bare = split_quantifiers f in
            let nf = subst_helper  bare in
            (add_quantifiers quans nf)
      | Or orf ->
            let nf1= (subst_helper orf.formula_or_f1) in
            let nf2 = (subst_helper orf.formula_or_f2) in
            (Or {orf with formula_or_f1 = nf1;
                formula_or_f2 = nf2;
            })
  in
  (*****************************************)
  if view_invs = [] then f0 else subst_helper f0

let subst_inv_lower_view view_invs f=
  let pr1= Cprinter.string_of_formula in
  let pr2 = pr_pair pr_id (pr_pair !CP.print_svl Cprinter.string_of_mix_formula) in
  Debug.no_2 "subst_inv_lower_view" (pr_list_ln pr2) pr1 pr1
      (fun _ _ -> subst_inv_lower_view_x view_invs f)
      view_invs f
(******************************************************************************)

(* let fixcalc_exe = "/home/thaitm/hg-repository/infer-rec/sleekex/bin/fixcalc " *)
(* let fixcalc_exe = "fixcalc " *)
let fixcalc_exe = if !Globals.is_solver_local then (ref "./fixcalc ") else (ref "fixcalc ")
let fixcalc_options = " -v:-1"
(* to suppress some printing *)

let syscall cmd =
  let _ = Debug.ninfo_hprint (add_str  "cmd" pr_id) cmd no_pos in
  let ic, oc = Unix.open_process cmd in
  let buf = Buffer.create 16 in
  (try
     while true do
       Buffer.add_channel buf ic 1
     done
   with End_of_file -> ());
  let _ = Unix.close_process (ic, oc) in
  (Buffer.contents buf)

(******************************************************************************)

(* Deprecated *)
(*
let compute_inv name vars fml pf =
  if not !Globals.do_infer_inv then pf
  else
    let output_of_sleek = "fixcalc.inp" in
    let oc = open_out output_of_sleek in
    let input_fixcalc = 
      name ^ ":=" ^ "{" ^ "[" ^ self ^ "," ^ 
      (string_of_elems vars fixcalc_of_spec_var ",") ^ "]" ^ " -> [] -> []: " ^
      (string_of_elems fml (fun (c,_)-> fixcalc_of_formula c) op_or) ^
      "\n};\n\nFix1:=bottomupgen([" ^ name ^ "]);\n\n"
    in 
    Printf.fprintf oc "%s" input_fixcalc;
    flush oc;
    close_out oc;
    let res = syscall (!fixcalc_exe ^ output_of_sleek ^ fixcalc_options) in
    let new_pf = List.hd (Parse_fix.parse_fix res) in
    (*let _ = Pr.fmt_string("\nInv: "^(Pr.string_of_pure_formula new_pf)) in*)
    let check_imply = Omega.imply new_pf pf "1" 100.0 in
    if check_imply then (
      Pr.fmt_string "INV:  ";
      Pr.pr_angle name 
        (fun x -> Pr.fmt_string (Pr.string_of_typed_spec_var x)) vars;
      Pr.fmt_string ("\nOLD: " ^ (Pr.string_of_pure_formula pf) ^
                     "\nNEW: " ^ (Pr.string_of_pure_formula new_pf) ^ "\n\n");			
      new_pf)
    else pf
*)

(******************************************************************************)

let rec remove_paren s n = if n=0 then "" else match s.[0] with
  | '(' -> remove_paren (String.sub s 1 (n-1)) (n-1)
  | ')' -> remove_paren (String.sub s 1 (n-1)) (n-1)
  | _ -> (String.sub s 0 1) ^ (remove_paren (String.sub s 1 (n-1)) (n-1))

(******************************************************************************)

let compute_pure_inv (fmls:CP.formula list) (name:ident) (para_names:CP.spec_var list): CP.formula =
  let vars = para_names in
  let fmls = List.map (fun p -> 
    let exists_vars = CP.diff_svl (CP.fv_wo_rel p) para_names in
    CP.mkExists exists_vars p None no_pos) fmls in

  (* Prepare the input for the fixpoint calculation *)
  let input_fixcalc = 
    try
      name ^ ":={[" ^ (string_of_elems vars fixcalc_of_spec_var ",") ^ 
      "] -> [] -> []: " ^ (string_of_elems fmls fixcalc_of_pure_formula op_or) ^
      "\n};\nbottomupgen([" ^ name ^ "], [1], SimHeur);"
    with _ -> report_error no_pos "Error in translating the input for fixcalc"
  in 
  DD.ninfo_zprint (lazy (("Input of fixcalc: " ^ input_fixcalc))) no_pos;

  let _ =
    if !Globals.gen_fixcalc then gen_fixcalc_file input_fixcalc else ()
  in

  (* Call the fixpoint calculation *)
  let output_of_sleek = "fixcalc.inp" in
  let oc = open_out output_of_sleek in
  Printf.fprintf oc "%s" input_fixcalc;
  flush oc;
  close_out oc;
  let res = syscall (!fixcalc_exe ^ output_of_sleek ^ fixcalc_options) in

  (* Remove parentheses *)
  let res = remove_paren res (String.length res) in
  DD.ninfo_zprint (lazy (("res = " ^ res ^ "\n"))) no_pos;

  (* Parse result *)
  let inv = List.hd (Parse_fix.parse_fix res) in
  inv

(******************************************************************************)
let slk2fix_body lower_invs fml0 vname dataname para_names=
  (*rename to avoid clashing, capture rev_subst also*)
  (* let self_sv = CP.SpecVar (Named dataname, self, Unprimed) in *)
  let vars =  para_names in
  let fr_vars = CP.fresh_spec_vars (vars) in
  let sst = List.combine vars fr_vars in
  let rev_sst = List.combine fr_vars vars in
  let fs = List.map (fun (f,_) -> Cformula.subst sst (subst_inv_lower_view lower_invs f)) fml0 in
  let input_fixcalc =
    try
      vname ^ ":={[" ^ (self) ^ (if (List.length fr_vars > 0) then "," else "") ^ (string_of_elems fr_vars fixcalc_of_spec_var ",") ^
      "] -> [] -> []: " ^
      (string_of_elems fs (fun c-> fixcalc_of_formula c) op_or) ^
          "\n};\n"
    with _ -> report_error no_pos "Error in translating the input for fixcalc"
  in
  DD.ninfo_zprint (lazy (("Input of fixcalc: " ^ input_fixcalc))) no_pos;
  (input_fixcalc, fr_vars, rev_sst)

let slk2fix_body_wo_fresh_vars lower_invs fml0 vname para_names=
  let vars =  para_names in
  let fs = List.map (fun (f,_) -> (subst_inv_lower_view lower_invs f)) fml0 in
  let input_fixcalc =
    try
      vname ^ ":={[" ^ (self) ^ (if (List.length vars > 0) then "," else "") ^ (string_of_elems vars fixcalc_of_spec_var ",") ^
          "] -> [] -> []: " ^
          (string_of_elems fs (fun c-> fixcalc_of_formula c) op_or) ^
          "\n};\n"
    with _ -> report_error no_pos "Error in translating the input for fixcalc"
  in
  DD.ninfo_zprint (lazy (("Input of fixcalc: " ^ input_fixcalc))) no_pos;
  (input_fixcalc)

let slk2fix_header disj_num vnames=
  let ls_vnames = String.concat "," vnames in
  let ls_disj_nums=  String.concat "," (List.map (fun _ -> string_of_int disj_num) vnames) in
  let _ = DD.ninfo_hprint (add_str "ls_vnames" pr_id) ls_vnames no_pos in
  "bottomupgen([" ^ ls_vnames ^ "], [" ^ ls_disj_nums ^ "], SimHeur);"

let compute_invs_fixcalc input_fixcalc=
  let rec get_lines s curp res=
    try
      let n = String.index_from s curp '\n' in
      let str = String.sub s curp (n-curp) in
       if String.length str > 0 then  get_lines s (n+1) res@[str] else res
    with _ ->
        (res)
  in
  let output_of_sleek =  (* Globals.fresh_any_name *) "fixcalc.inp" in
  let oc = open_out output_of_sleek in
  Printf.fprintf oc "%s" input_fixcalc;
  flush oc;
  close_out oc;
  let res = syscall (!fixcalc_exe ^ output_of_sleek ^ fixcalc_options) in

  (* Remove parentheses *)
  let res = remove_paren res (String.length res) in
  
  (* Parse result *)
  let _ = DD.ninfo_hprint (add_str "res= " pr_id) res no_pos in
  (* let _ = print_endline ("res ="^ res) in *)
  let lines = get_lines res 0 [] in
   let _ = DD.ninfo_hprint (add_str "lines" (pr_list_ln pr_id)) lines no_pos in
  let invs = List.fold_left (fun r line -> r@(Parse_fix.parse_fix line)) [] lines in
  let _ = DD.ninfo_hprint (add_str "res(parsed)= " (pr_list !CP.print_formula)) invs no_pos in
  invs

let lookup_inv invs pos fr_vars rev_sst=
  let rec helper rest_invs=
    match rest_invs with
      | inv::tail ->
            let svl = CP.fv inv in
            if CP.intersect_svl svl fr_vars != [] then
              CP.subst rev_sst inv
            else helper tail
      | [] -> (* report_error no_pos "something wrong with fixcalc" *)
            raise Not_found
  in
  try
    helper invs
  with _ ->
      List.nth invs pos

(* TODO: TO MERGE WITH ABOVE *)
let compute_heap_pure_inv_x fml (name:ident) data_name (para_names:CP.spec_var list) transed_views: CP.formula =
  (* let vars = para_names in *)
  (* Prepare the input for the fixpoint calculation *)
  let lower_invs = Cast.extract_view_x_invs transed_views in
  let input_fixcalc, fr_vars, rev_sst = 
    (* try *)
  (*     name ^ ":={[" ^ self ^ "," ^ (string_of_elems vars fixcalc_of_spec_var ",") ^  *)
  (*     "] -> [] -> []: " ^  *)
  (*     (string_of_elems fml (fun (c,_)-> fixcalc_of_formula (subst_inv_lower_view lower_invs c)) op_or) ^ *)
  (*     "\n};\nbottomupgen([" ^ name ^ "], [1], SimHeur);" *)
  (*   with _ -> report_error no_pos "Error in translating the input for fixcalc" *)
    let fixc_body,fr_vars, rev_sst = slk2fix_body lower_invs fml name data_name para_names in
    let fixc_header = slk2fix_header 1 [name] in
    (fixc_body ^ fixc_header, fr_vars, rev_sst)
  in
  DD.ninfo_zprint (lazy (("Input of fixcalc: " ^ input_fixcalc))) no_pos;

  let _ =
    if !Globals.gen_fixcalc then gen_fixcalc_file input_fixcalc else ()
  in

  (* (\* Call the fixpoint calculation *\) *)
  (* let output_of_sleek =  Globals.fresh_any_name "fixcalc.inp" in *)
  (* let oc = open_out output_of_sleek in *)
  (* Printf.fprintf oc "%s" input_fixcalc; *)
  (* flush oc; *)
  (* close_out oc; *)
  (* let res = syscall (!fixcalc_exe ^ output_of_sleek ^ fixcalc_options) in *)

  (* (\* Remove parentheses *\) *)
  (* let res = remove_paren res (String.length res) in *)
  (* DD.ninfo_zprint (lazy (("res = " ^ res ^ "\n"))) no_pos; *)

  (* (\* Parse result *\) *)
  (* let _ = DD.ninfo_hprint (add_str "res(parsed)= " pr_id) res no_pos in *)
  (* let inv = List.hd (Parse_fix.parse_fix res) in *)
  (* let _ = DD.info_hprint (add_str "res(parsed)= " !CP.print_formula) inv no_pos in *)
  (* inv *)
  let invs = (compute_invs_fixcalc input_fixcalc) in
  lookup_inv invs 0 fr_vars rev_sst

let compute_heap_pure_inv fml (name:ident) data_name (para_names:CP.spec_var list) lower_invs: CP.formula =
  let pr1 = !CP.print_formula in
  let pr2 (f, _) = Cprinter.string_of_formula f in
  Debug.no_3 "compute_heap_pure_inv" (pr_list_ln pr2) pr_id !CP.print_svl pr1
      (fun _ _ _ ->  compute_heap_pure_inv_x fml name data_name para_names lower_invs)
      fml name para_names

(******************************************************************************)

let compute_inv_x name vars fml data_name lower_views pf =
if List.exists CP.is_bag_typ vars then Fixbag.compute_inv name vars fml pf 1
else
  if not !Globals.do_infer_inv then pf
  else let new_pf = compute_heap_pure_inv fml name data_name vars lower_views in
    let check_imply = TP.imply_raw new_pf pf in
    if check_imply then
      let _ = DD.ninfo_hprint (add_str ("new 1 inv("^name^")") !CP.print_formula) new_pf no_pos in
      let _ = print_endline_quiet "" in
      new_pf
    else pf

let compute_inv name vars fml data_name lower_views pf =
  let pr1 (f,_) = Cprinter.prtt_string_of_formula f in
  let pr2 = !CP.print_formula in
  Debug.no_4 " compute_inv" pr_id !CP.print_svl (pr_list_ln pr1) pr2 pr2
      (fun _ _ _ _ -> compute_inv_x name vars fml data_name lower_views pf)
      name vars fml pf

(*compute invs of views in one loop*)
let compute_inv_mutrec_x mutrec_vnames views =
  (**************************************************)
  let str_cmp s1 s2 = String.compare s1 s2 = 0 in
  let rec lookup_map vmaps vname0=
    match vmaps with
      | [] -> raise Not_found
      | (vname,b,c):: rest -> if str_cmp vname vname0 then
          (vname,b,c) else
            lookup_map rest vname0
  in
  let update_view invs pos vmaps view all_rev_sst=
    try
      let (vname, fr_vars, rev_sst) = lookup_map vmaps view.Cast.view_name in
      let new_pf = lookup_inv invs pos fr_vars rev_sst in
      let pf =  MCP.pure_of_mix view.Cast.view_user_inv in
      let check_imply = TP.imply_raw new_pf pf in
      if check_imply then 
        let _ = DD.info_hprint (add_str ("new 2 inv(" ^ vname^")") !CP.print_formula) new_pf no_pos in
        let _ = print_endline "" in
        let memo_pf_P = MCP.memoise_add_pure_P (MCP.mkMTrue no_pos) new_pf in
        (* let memo_pf_N = MCP.memoise_add_pure_N (MCP.mkMTrue pos) inv in *)
        (* let xpure_flag = Tpdispatcher.check_diff memo_pf_N memo_pf_P in *)
        begin
          Debug.binfo_hprint (add_str "view_x_formula" Cprinter.string_of_mix_formula) memo_pf_P no_pos;
          view.Cast.view_x_formula <- memo_pf_P;
          view
        end
      else view
    with _ -> view
  in
  (**************************************************)
  if  not !Globals.do_infer_inv then
    views
  else
    (*get all views of the loop*)
    (*subst inv of their depent (lower) views
      (remember to remove members of the loop)
    *)
    let mutrec_views, rest = List.partition (fun v ->
        Gen.BList.mem_eq str_cmp v.Cast.view_name  mutrec_vnames
    ) views in
    let lower_invs = Cast.extract_view_x_invs rest in
    (*gen cf of each view*)
    let fixc_bodys, vnames, vmaps = List.fold_left (fun (r1,r2,r3) view ->
        let fixc_body, fr_vars, rev_sst = slk2fix_body lower_invs
          view.Cast.view_un_struc_formula view.Cast.view_name view.Cast.view_data_name view.Cast.view_vars in
        (r1 ^ "\n" ^ fixc_body, r2@[view.Cast.view_name], r3@[(view.Cast.view_name,fr_vars, rev_sst)])
    ) ("",[],[]) mutrec_views in
    let fixc_header = slk2fix_header 1 vnames in
    let input_fixcalc  =  fixc_bodys ^ fixc_header in
    let _ = DD.ninfo_hprint (add_str "Input of fixcalc " pr_id) input_fixcalc no_pos in
    let _ =
    if !Globals.gen_fixcalc then gen_fixcalc_file input_fixcalc else ()
    in
    (* Call the fixpoint calculation *)
    let invs = (compute_invs_fixcalc input_fixcalc) in
    (*get result and revert back*)
    (*set invs + flags*)
    let all_rev_sst = List.fold_left (fun r (_,_,sst) -> r@sst) [] vmaps in
    let r,_ = List.fold_left (fun (res,pos) view ->
        let nview = update_view invs pos vmaps view all_rev_sst in
        (res@[nview], pos+1)
    ) ([], 0) views in
    r

let compute_inv_mutrec mutrec_views views =
  let pr1 = pr_list pr_id in
  let pr2 v = v.Cast.view_name in
  Debug.no_2 "compute_inv_mutrec" pr1 (pr_list pr2)  (pr_list pr2)
      (fun _ _ -> compute_inv_mutrec_x mutrec_views views)
      mutrec_views views

(******************************************************************************)

(******************************************************************************)

let compute_pure_inv_x (fmls:CP.formula list) (name:ident) (para_names:CP.spec_var list): CP.formula =
  let vars = para_names in
  let fmls = List.map (fun p -> 
    let exists_vars = CP.diff_svl (CP.fv_wo_rel p) para_names in
    CP.mkExists exists_vars p None no_pos) fmls in

  (* Prepare the input for the fixpoint calculation *)
  let input_fixcalc = 
    try
      name ^ ":={[" ^ (string_of_elems vars fixcalc_of_spec_var ",") ^ 
      "] -> [] -> []: " ^ (string_of_elems fmls fixcalc_of_pure_formula op_or) ^
      "\n};\nbottomupgen([" ^ name ^ "], [1], SimHeur);"
    with _ -> report_error no_pos "Error in translating the input for fixcalc"
  in 
  DD.ninfo_zprint (lazy (("Input of fixcalc: " ^ input_fixcalc))) no_pos;

  let _ =
    if !Globals.gen_fixcalc then gen_fixcalc_file input_fixcalc else ()
  in

  (* Call the fixpoint calculation *)
  let output_of_sleek = (* Globals.fresh_any_name *) "fixcalc.inp" in
  let oc = open_out output_of_sleek in
  Printf.fprintf oc "%s" input_fixcalc;
  flush oc;
  close_out oc;
  let res = syscall (!fixcalc_exe ^ output_of_sleek ^ fixcalc_options) in

  (* Remove parentheses *)
  let res = remove_paren res (String.length res) in
  DD.ninfo_zprint (lazy (("res = " ^ res ^ "\n"))) no_pos;

  (* Parse result *)
  let inv = List.hd (Parse_fix.parse_fix res) in
  inv

let compute_pure_inv (fmls:CP.formula list) (name:ident) (para_names:CP.spec_var list): CP.formula =
  let pr1 = !CP.print_formula in
  Debug.no_3 "compute_pure_inv" (pr_list_ln pr1) pr_id !CP.print_svl pr1
      (fun _ _ _ ->  compute_pure_inv_x fmls name para_names)
      fmls name para_names

(******************************************************************************)

let rec is_rec pf = match pf with
  | CP.BForm (bf,_) -> CP.is_RelForm pf
  | CP.And (f1,f2,_) -> is_rec f1 || is_rec f2
  | CP.AndList b -> exists_l_snd is_rec b
  | CP.Or (f1,f2,_,_) -> is_rec f1 || is_rec f2
  | CP.Not (f,_,_) -> is_rec f
  | CP.Forall (_,f,_,_) -> is_rec f
  | CP.Exists (_,f,_,_) -> is_rec f

let rec is_not_rec pf = match pf with
  | CP.BForm (bf,_) -> not(CP.is_RelForm pf)
  | CP.And (f1,f2,_) -> is_not_rec f1 && is_not_rec f2
  | CP.AndList b -> all_l_snd is_not_rec b
  | CP.Or (f1,f2,_,_) -> is_not_rec f1 && is_not_rec f2
  | CP.Not (f,_,_) -> is_not_rec f
  | CP.Forall (_,f,_,_) -> is_not_rec f
  | CP.Exists (_,f,_,_) -> is_not_rec f

let substitute_args_x a_rel = match a_rel with
  | CP.BForm ((CP.RelForm (name,args,o1),o2),o3) ->
    let new_args, subs = List.split 
      (List.map (fun e ->
        match e with
        | CP.Var _ -> (e, [])
        | _ -> 
          (try 
            let arb = List.hd (CP.afv e) in 
            let var = CP.fresh_spec_var_prefix "fc" arb in
            let var = CP.mkVar var no_pos in
            (var, [CP.mkEqExp var e no_pos])
          with _ -> (e,[]))
      ) args)
    in
    (CP.BForm ((CP.RelForm (name,new_args,o1),o2),o3), List.concat subs)
  | _ -> report_error no_pos "substitute_args_x Expected a relation"

let substitute_args rcase =
  let rels = CP.get_RelForm rcase in
  let rcase_wo_rel = TP.simplify_raw (CP.drop_rel_formula rcase) in
  let rels, subs = 
    List.split (List.map (fun rel -> substitute_args_x rel) rels) in
  let res = [rcase_wo_rel]@rels@(List.concat subs) in
  CP.conj_of_list res no_pos

(* TODO: Need to handle computed relation in the future *)
let rec get_other_branches or_fml args = match or_fml with
  | Or fml -> 
    (get_other_branches fml.formula_or_f1 args) @ 
    (get_other_branches fml.formula_or_f2 args)
  | _ ->
    (* TODO CHECK: a *)
    let _,p,_,_,a = split_components or_fml in 
    let conjs = CP.list_of_conjs (MCP.pure_of_mix p) in
    List.filter (fun pure -> CP.subset args (CP.fv pure)) conjs

let process_base_rec pfs rel specs = match CP.get_rel_id rel with
  | None -> report_error no_pos "process_base_rec: Expected a relation"
  | Some ivs ->
    let (rcases, bcases) = List.partition is_rec pfs in

    (* TODO *)
    let or_post = get_or_post specs (CP.get_rel_id_list rel) in
    let bcases = 
      begin
      match or_post with
      | [] -> bcases
      | [or_fml] ->
        let other_branches = get_other_branches or_fml (CP.get_rel_args rel) in
        let other_branches = List.map (fun p -> CP.mkNot_s p) other_branches in
        let pure_other_branches = CP.conj_of_list other_branches no_pos in
        List.filter (fun b -> TP.is_sat_raw (MCP.mix_of_pure 
          (CP.mkAnd b pure_other_branches no_pos))) bcases
      | _ -> bcases
      end
    in

    let no_of_disjs = 
      List.map (fun b -> 
        let disjs = CP.list_of_disjs b in 
        (* TODO *)
        let cond = List.exists (fun d -> 
            let conjs = CP.list_of_conjs d in 
            List.exists (fun c -> CP.is_eq_const c) conjs
          ) disjs 
        in 
        if cond then 1 else List.length disjs
      ) bcases in
    let no_of_disjs = List.fold_left (fun a b -> max a b) 1 no_of_disjs in 

    (* Normalize each relation *)
    let rcases = List.map (fun x -> substitute_args x) rcases in

    bcases @ rcases, no_of_disjs

let compute_def (rel_fml, pf, no) ante_vars =
  let (name,vars) = match rel_fml with
    | CP.BForm ((CP.RelForm (name,args,_),_),_) -> 
      (CP.name_of_spec_var name, (List.concat (List.map CP.afv args)))
    | _ -> report_error no_pos 
              ("Wrong format: " ^ (!CP.print_formula rel_fml) ^ "\n")
  in

  let pre_vars, post_vars = 
      List.partition (fun v -> List.mem v ante_vars) vars in

  try
    let rhs = fixcalc_of_pure_formula pf in
    let input_fixcalc =
        name ^ ":={[" 
      ^ (string_of_elems pre_vars fixcalc_of_spec_var ",") ^ "] -> [" 
      ^ (string_of_elems post_vars fixcalc_of_spec_var ",") ^ "] -> []: " 
      ^ rhs ^ "\n};"
    in input_fixcalc
  with _ -> report_error no_pos "Error in translating the input for fixcalc"

let compute_cmd rel_defs bottom_up = 
  let nos = List.map (fun (_,_,a) -> a) rel_defs in
  (* let nos = string_of_elems nos string_of_int "," in *)
  let nos = string_of_elems nos (fun _ -> 
      string_of_int !Globals.fixcalc_disj) "," in
  let _ = DD.ninfo_hprint (add_str "No of disjs" (fun x -> x)) nos no_pos in
  let rels = List.map (fun (a,_,_) ->
      CP.name_of_spec_var (CP.name_of_rel_form a)) rel_defs in
  let names = string_of_elems rels (fun x -> x) "," in
  if bottom_up then
    "\nbottomupgen([" ^ names ^ "], [" ^ nos ^ "], SimHeur);"
  else
    "\nTD:=topdown(" ^ names ^ ", " ^ nos ^ ", SimHeur);\nTD;"

let compute_fixpoint_aux rel_defs ante_vars bottom_up =
  (* Prepare the input for the fixpoint calculation *)
  let def = List.fold_left (fun x y -> x ^ (compute_def y ante_vars)) "" rel_defs in
  let cmd = compute_cmd rel_defs bottom_up in
  let input_fixcalc =  def ^ cmd  in
  DD.binfo_pprint ">>>>>> compute_fixpoint <<<<<<" no_pos;
  DD.binfo_pprint ("Input of fixcalc: " ^ input_fixcalc) no_pos;
  (* DD.info_hprint (add_str "def" pr_id) def no_pos; *)
  (* DD.info_hprint (add_str "cmd" pr_id) cmd no_pos; *)
  (* DD.info_zprint (lazy (("fixpoint input = " ^ input_fixcalc))) no_pos; *)
  (* Call the fixpoint calculation *)
  DD.ninfo_zprint (lazy (("Input of fixcalc: " ^ input_fixcalc))) no_pos;

  let _ =
    if !Globals.gen_fixcalc then gen_fixcalc_file input_fixcalc else ()
  in

  let output_of_sleek = if bottom_up then "fixcalc.inf" else "fixcalc.td" in
  let oc = open_out output_of_sleek in
  Printf.fprintf oc "%s" input_fixcalc;
  flush oc;
  close_out oc;
  let res = syscall (!fixcalc_exe ^ output_of_sleek ^ fixcalc_options) in

  (* Remove parentheses *)
  let res = remove_paren res (String.length res) in
  DD.ninfo_zprint (lazy (("res = " ^ res ^ "\n"))) no_pos;

  (* Parse result *)
  DD.ninfo_pprint ("Result of fixcalc: " ^ res) no_pos;
  let fixpoints = Parse_fix.parse_fix res in
  DD.devel_hprint (add_str "Result of fixcalc (parsed): "
    (pr_list !CP.print_formula)) fixpoints no_pos;

  (* Pre-result *)
  let rels = List.map (fun (a,_,_) -> a) rel_defs in
  let res =
    try List.combine rels fixpoints
    with _ -> report_error no_pos "Error in compute_fixpoint_aux"
  in

  (* Substitute the parameters of each relation to the original ones *)
(*  DD.ninfo_pprint ("res(b4): " ^ *)
(*    (pr_list (pr_pair !CP.print_formula !CP.print_formula) res)) no_pos;*)
(*  let res =*)
(*    List.map (fun (a_rel,fixpoint) -> *)
(*      match a_rel with*)
(*      | CP.BForm ((CP.RelForm (name,args,o1),o2),o3) ->*)
(*        let subst_arg = *)
(*          try List.assoc name subs*)
(*          with _ -> []*)
(*        in*)
(*        let subst_arg = List.map (fun (x,y) -> (y,x)) subst_arg in*)
(*        if subst_arg = [] then (a_rel, fixpoint)*)
(*        else (CP.subst subst_arg a_rel, CP.subst subst_arg fixpoint)*)
(*      | _ -> report_error no_pos "compute_fixpoint_aux: Expected a relation"*)
(*    ) res in*)
(*  DD.ninfo_pprint ("res(af): " ^ *)
(*    (pr_list (pr_pair !CP.print_formula !CP.print_formula) res)) no_pos;*)
  res

let extract_inv_helper_x (rel, pfs) ante_vars specs =
  (* Remove bag constraints *)
  Debug.ninfo_hprint (add_str "pfs(b4):" (pr_list !CP.print_formula)) pfs no_pos;
  let pfs = List.map (fun p -> 
      let bag_vars = List.filter CP.is_bag_typ (CP.fv p) in
      if bag_vars == [] then p else 
        let p = TP.simplify_raw p in
        CP.remove_cnts bag_vars p
      ) pfs
  in
  Debug.ninfo_hprint (add_str "pfs(af):" (pr_list !CP.print_formula)) pfs no_pos;

  (* Some other processes *)
  let pfs,no = process_base_rec pfs rel specs in

  (* Make existence *)
  let pfs = List.concat (List.map (fun p ->
    let exists_vars = CP.diff_svl (CP.fv_wo_rel p) (CP.fv rel) in
    let res = CP.mkExists exists_vars p None no_pos in
    if CP.isConstTrue (TP.simplify_raw res) then [CP.mkTrue no_pos]
    else [res]) pfs)
  in

  Debug.ninfo_hprint (add_str "pfs(af):" (pr_list !CP.print_formula)) pfs no_pos;

  (* Disjunctive defintion for each relation *)
  let def = List.fold_left
          (fun p1 p2 -> CP.mkOr p1 p2 None no_pos) (CP.mkFalse no_pos) pfs in
  [(rel, def, no)]

let extract_inv_helper (rel, pfs) ante_vars specs =
  let pr1 = !CP.print_formula in
  let pr2 = pr_list_ln pr1 in
  let pr3 = Cprinter.string_of_struc_formula in
  Debug.no_3 "extract_inv_helper" (pr_pair pr1 pr2) !CP.print_svl pr3 (pr_list_ln (pr_triple pr1 pr1 string_of_int))
      (fun _ _ _ -> extract_inv_helper_x (rel, pfs) ante_vars specs)
      (rel, pfs) ante_vars specs

let arrange_para input_pairs ante_vars =
  let pairs, subs = List.split 
    (List.map (fun (r,pfs) ->
      match r with
      | CP.BForm ((CP.RelForm (name,args,o1),o2),o3) ->
        let pre_args, post_args = 
          List.partition 
            (fun e -> Gen.BList.subset_eq CP.eq_spec_var (CP.afv e) ante_vars) 
          args
        in
        let new_args = pre_args @ post_args in
        if new_args = args then ((r,pfs),[])
        else
          let subst_arg = List.combine (List.map CP.exp_to_spec_var args) 
                                       (List.map CP.exp_to_spec_var new_args) 
          in
          ((CP.BForm ((CP.RelForm (name,new_args,o1),o2),o3), 
            List.map (fun x -> CP.subst subst_arg x) pfs),[(name,subst_arg)])
      | _ -> report_error no_pos "arrange_para: Expected a relation"
    ) input_pairs)
  in 
  pairs, List.concat subs

let arrange_para_of_rel rhs_rel lhs_rel_name (old_args, new_args) bottom_up = 
  match rhs_rel with
  | CP.BForm ((CP.RelForm (name,args,o1),o2),o3) ->
    if name = lhs_rel_name then 
      let pairs = List.combine old_args args in
      let args = List.map (fun a -> List.assoc a pairs) new_args in
      CP.BForm ((CP.RelForm (name,args,o1),o2),o3)
    else 
    if bottom_up then rhs_rel
    else report_error no_pos "Not support topdown fixpoint for mutual recursion"
  | _ -> report_error no_pos "arrange_para_of_rel: Expected a relation"

let arrange_para_of_pure fml lhs_rel_name subst bottom_up =
  let conjs = CP.list_of_conjs fml in
  let rel_conjs, others = List.partition CP.is_RelForm conjs in
  let new_rel_conjs = List.map (fun x -> arrange_para_of_rel x lhs_rel_name subst bottom_up) rel_conjs in
  CP.conj_of_list (others @ new_rel_conjs) no_pos

let rec re_order_para rels pfs ante_vars = match rels with
  | [] -> ([],pfs)
  | r::rs ->
    let res_rs,res_pfs = re_order_para rs pfs ante_vars in
    (match r with
    | CP.BForm ((CP.RelForm (name,args,o1),o2),o3) ->
      let pre_args, post_args = List.partition 
        (fun e -> Gen.BList.subset_eq CP.eq_spec_var (CP.afv e) ante_vars) args 
      in
      let new_args = pre_args @ post_args in
      if new_args = args then (r::res_rs,res_pfs)
      else
        let subst_arg = args, new_args in
        let new_pfs = List.map (fun pf_lst ->
            List.map (fun pf -> arrange_para_of_pure pf name subst_arg true) pf_lst) res_pfs
        in ([CP.BForm ((CP.RelForm (name,new_args,o1),o2),o3)]@res_rs, new_pfs)
    | _ -> report_error no_pos "re_order_para: Expected a relation")

let arrange_para_new input_pairs ante_vars =
  let rels,pfs = List.split input_pairs in
  let _ = Debug.ninfo_hprint (add_str "rels(b4):" (pr_list !CP.print_formula)) rels no_pos in
  let _ = Debug.ninfo_hprint (add_str "pfs(b4):" (pr_list (pr_list !CP.print_formula))) pfs no_pos in
  let rels,pfs = re_order_para rels pfs ante_vars in
  let _ = Debug.ninfo_hprint (add_str "rels(af):" (pr_list !CP.print_formula)) rels no_pos in
  let _ = Debug.ninfo_hprint (add_str "pfs(af):" (pr_list (pr_list !CP.print_formula))) pfs no_pos in
  try List.combine rels pfs
  with _ -> report_error no_pos "Error in re_order_para"

(*  let pairs, subs = List.split *)
(*    (List.map (fun (r,pfs) ->*)
(*      match r with*)
(*      | CP.BForm ((CP.RelForm (name,args,o1),o2),o3) ->*)
(*        let pre_args, post_args = *)
(*          List.partition *)
(*            (fun e -> Gen.BList.subset_eq CP.eq_spec_var (CP.afv e) ante_vars) *)
(*          args*)
(*        in*)
(*        let new_args = pre_args @ post_args in*)
(*        if new_args = args then ((r,pfs),[])*)
(*        else*)
(*          let subst_arg = List.combine (List.map CP.exp_to_spec_var args) *)
(*                                       (List.map CP.exp_to_spec_var new_args) *)
(*          in*)
(*          ((CP.BForm ((CP.RelForm (name,new_args,o1),o2),o3), *)
(*            List.map (fun x -> CP.subst subst_arg x) pfs),[(name,subst_arg)])*)
(*      | _ -> report_error no_pos "arrange_para: Expected a relation"*)
(*    ) input_pairs)*)
(*  in *)
(*  pairs, List.concat subs*)

let arrange_para_td input_pairs ante_vars =
  let pairs = List.map (fun (r,pfs) ->
    match r with
      | CP.BForm ((CP.RelForm (name,args,o1),o2),o3) ->
        let pre_args, post_args = 
          List.partition 
            (fun e -> Gen.BList.subset_eq CP.eq_spec_var (CP.afv e) ante_vars) 
          args
        in
        let new_args = pre_args @ post_args in
        if new_args = args then (r,pfs)
        else
          let subst_arg = args, new_args in
          CP.BForm ((CP.RelForm (name,new_args,o1),o2),o3), 
            List.map (fun x -> arrange_para_of_pure x name subst_arg false) pfs
      | _ -> report_error no_pos "arrange_para_td: Expected a relation"
    ) input_pairs
  in 
  pairs

let rec unify_rels rel a_rel = match rel, a_rel with
  | (f1,CP.BForm ((CP.RelForm (name1,args1,p1),p2),p3)), 
    (f2,CP.BForm ((CP.RelForm (name2,args2,_ ),_ ),_ )) ->
    let subst_arg = List.combine (List.map CP.exp_to_spec_var args2) 
                                 (List.map CP.exp_to_spec_var args1) in
    let f2 = CP.subst subst_arg f2 in
    f2
  | _ -> report_error no_pos ("unify_rels: Expected a relation, " ^ 
        (pr_pair !CP.print_formula !CP.print_formula) (snd rel, snd a_rel))

(*(n=0 & m=0) | (n=0 & m>0) ==> (n=0 & m>=0) *)
let fixc_reduce_disj_one_rel_x (rel_p, oblgs0)=
  (****************INTERNAL********************)
  let red_measure = 1 in
  let rec partition_comm_diff_x lst_ps1 lst_ps2 (comm, diff1, diff2)=
    match lst_ps1 with
      | [] -> (comm, diff1, diff2@lst_ps2)
      | p1::rest1 -> let n_comm, rest2 = List.partition (fun p2 -> CP.equalFormula p1 p2) lst_ps2 in
        if n_comm = [] then partition_comm_diff_x rest1 lst_ps2 (comm, diff1@[p1], diff2) else
         partition_comm_diff_x rest1 rest2 (comm@[p1], diff1, diff2)
  in
  let partition_comm_diff lst_ps1 lst_ps2 (comm, diff1, diff2)=
    let pr1 = pr_list !CP.print_formula in
    let pr2 = pr_triple pr1 pr1 pr1 in
    Debug.no_3 "partition_comm_diff" pr1 pr1 pr2 pr2
        (fun _ _ _ -> partition_comm_diff_x lst_ps1 lst_ps2 (comm, diff1, diff2))
            lst_ps1 lst_ps2 (comm, diff1, diff2)
  in
  let collect_comm lst_p lst_ps=
    let lst_comm, lst_rest = List.fold_left (fun (r_comm, r_rest) lst_p1 ->
        let comm,diff1,diff2 = partition_comm_diff lst_p lst_p1 ([],[],[]) in
        (*do reduce for one*)
        if comm = [] || (List.length diff1 != red_measure) || (List.length diff2 != red_measure) then
          (r_comm, r_rest@[lst_p1])
        else (r_comm@[comm,diff1,diff2], r_rest)
    ) ([],[]) lst_ps in
    if lst_comm = [] then ([], lst_p::lst_ps) else
      (lst_comm, lst_rest)
  in
  let find_max_common lst_ps=
    let rec collect_comm_lst lst_p rest_lst_ps done_lst_ps res=
      match rest_lst_ps with
        | [] ->
              let r1 = collect_comm lst_p done_lst_ps in
              (res@[r1])
        | lst_p1::rest_lsp1 -> let r1 = collect_comm lst_p (rest_lst_ps@done_lst_ps) in
          collect_comm_lst lst_p1 rest_lsp1 (done_lst_ps@[lst_p]) (res@[r1])
    in
    match lst_ps with
      | [] -> ([], lst_ps)
      | lst_p::rest -> let lst_comm = collect_comm_lst lst_p rest [] [] in
        (*get max_comm*)
        let sorted_comm = List.sort (fun (_,rest1) (_,rest2) -> List.length rest1 - List.length rest2) lst_comm in
        List.hd sorted_comm
  in
  let do_reduce_x (comm_ps, diff_ps1, diff_ps2)=
    let p1 = CP.conj_of_list diff_ps1 no_pos in
    let p2 = CP.conj_of_list diff_ps2 no_pos in
    let p = CP.mkOr p1 p2 None (CP.pos_of_formula p1) in
    let p1 = TP.pairwisecheck_raw p in
    let _ = Debug.ninfo_hprint (add_str "p"  !CP.print_formula) p no_pos in
    let _ = Debug.ninfo_hprint (add_str "p1"  !CP.print_formula) p1 no_pos in
    if CP.is_disjunct p1 then
      [(comm_ps@diff_ps1);(comm_ps@diff_ps2)]
    else [(p1::comm_ps)]
  in
  let do_reduce (comm_ps, diff_ps1, diff_ps2)=
    let pr1 = pr_list_ln !CP.print_formula in
    let pr2 =  pr_list_ln pr1 in
    let pr3 = pr_triple pr1 pr1 pr1 in
    Debug.no_1 "do_reduce" pr3 pr2
        (fun _ -> do_reduce_x (comm_ps, diff_ps1, diff_ps2))
        (comm_ps, diff_ps1, diff_ps2)
  in
  let rec reduce_one_disj oblgs=
    let lst_ps = List.map (CP.list_of_conjs) oblgs in
    let (lst_com_ps, rest_lst_ps) = find_max_common lst_ps in
    let lst_reduced_ps = List.fold_left (fun r comp -> r@(do_reduce comp)) [] lst_com_ps in
    let reduced_ps = List.map (fun ps -> CP.conj_of_list ps no_pos) lst_reduced_ps in
    let reduced_ps1 = Gen.BList.remove_dups_eq CP.equalFormula reduced_ps in
    let rest_ps= List.map (fun ps -> CP.conj_of_list ps no_pos) rest_lst_ps in
    (reduced_ps1@rest_ps)
  in
  (*****************END*INTERNAL****************)
  let ini_oblgs, rec_oblgs = List.partition (fun p ->
      (CP.get_list_rel_args p) = []
  ) oblgs0 in
  let ini_oblgs1 = reduce_one_disj ini_oblgs in
  (rel_p, rec_oblgs@ini_oblgs1)

let fixc_reduce_disj_one_rel pairs=
  let pr1 = !CP.print_formula in
  let pr2 = pr_pair pr1 (pr_list_ln pr1) in
  Debug.no_1 "fixc_reduce_disj_one_rel" pr2 pr2
      (fun _ -> fixc_reduce_disj_one_rel_x pairs) pairs

let fixc_preprocess_x pairs0 =
  let rec helper pairs res=
    match pairs with
      | [] -> res
      | r::rs ->
            let rel = snd r in
            let name = CP.name_of_rel_form rel in
            let same_rels, diff_rels =
              List.partition (fun r0 ->
                  CP.eq_spec_var (CP.name_of_rel_form (snd r0)) name) rs in
            let unified_rels =
              if same_rels == [] then [(snd r, [fst r])]
              else
                let res = List.map (fun r0 ->
                    if CP.equalFormula rel (snd r0) then (fst r0)
                    else unify_rels r r0) same_rels in
                let unified_oblgs = (snd r, (fst r) :: res) in
                (*reduce number of disj*)
                let red_pairs = fixc_reduce_disj_one_rel unified_oblgs in
                [red_pairs]
            in
            helper diff_rels (res@unified_rels)
  in
  helper pairs0 []

let fixc_preprocess pairs0 =
  let pr1 = !CP.print_formula in
  let pr2 = pr_list_ln (pr_pair pr1 pr1) in
  let pr3 = pr_list_ln (pr_pair pr1 (pr_list_ln pr1)) in
  Debug.no_1 "fixc_preprocess" pr2 pr3
      (fun _ -> fixc_preprocess_x pairs0) pairs0

(*let rec unify_rels_ass rel a_rel = match rel, a_rel with*)
(*  | (CP.BForm ((CP.RelForm (name1,args1,p1),p2),p3),f1), *)
(*    (CP.BForm ((CP.RelForm (name2,args2,_ ),_ ),_ ),f2) ->*)
(*    let subst_arg = List.combine (List.map CP.exp_to_spec_var args2) *)
(*                                 (List.map CP.exp_to_spec_var args1) in*)
(*    let f2 = CP.subst subst_arg f2 in*)
(*    f2*)
(*  | _ -> report_error no_pos ("unify_rels_ass: Expected a relation, " ^ *)
(*        (pr_pair !CP.print_formula !CP.print_formula) (fst rel, fst a_rel))*)

(*let rec preprocess_rel_ass pairs = match pairs with*)
(*  | [] -> []*)
(*  | r::rs -> *)
(*    let rel = fst r in*)
(*    let name = CP.name_of_rel_form rel in*)
(*    let same_rels, diff_rels = *)
(*      List.partition (fun r0 -> *)
(*        CP.eq_spec_var (CP.name_of_rel_form (fst r0)) name) rs in*)
(*    let unified_rels = *)
(*      if same_rels == [] then [(fst r, [snd r])]*)
(*      else *)
(*        let res = List.map (fun r0 -> *)
(*                    if CP.equalFormula rel (fst r0) then (snd r0)*)
(*                    else unify_rels_ass r r0) same_rels in*)
(*        [(fst r, (snd r) :: res)]*)
(*    in*)
(*    unified_rels @ (preprocess_rel_ass diff_rels)*)

let compute_fixpoint_xx input_pairs_num ante_vars specs bottom_up =
  (* TODO: Handle non-recursive ones separately *)
  DD.ninfo_pprint ("input_pairs_num: " ^ (pr_list
    (pr_pair !CP.print_formula !CP.print_formula) input_pairs_num)) no_pos;

  let pairs = fixc_preprocess input_pairs_num in

  DD.ninfo_hprint (add_str "input_pairs(b4): " (pr_list
    (pr_pair !CP.print_formula (pr_list !CP.print_formula)) )) pairs no_pos;

(*  let pairs, subs = if bottom_up then arrange_para_new pairs ante_vars,[] *)
(*    else arrange_para_td pairs ante_vars,[]*)
(*  in*)

  let pairs = if bottom_up then arrange_para_new pairs ante_vars
    else arrange_para_td pairs ante_vars
  in

  DD.ninfo_hprint (add_str "input_pairs(af): "  (pr_list
    (pr_pair !CP.print_formula (pr_list !CP.print_formula)) )) pairs no_pos;

  let rel_defs = List.concat
    (List.map (fun pair -> extract_inv_helper pair ante_vars specs) pairs) in

  DD.ninfo_hprint (add_str "rel_defs "  (pr_list
    (pr_triple !CP.print_formula !CP.print_formula string_of_int)) ) rel_defs no_pos;

  let true_const,rel_defs = List.partition (fun (_,pf,_) -> CP.isConstTrue pf) rel_defs in
  let non_rec_defs, rec_rel_defs = List.partition (fun (_,pf,_) -> is_not_rec pf) rel_defs in

  DD.ninfo_hprint (add_str "rec_rel_defs "  (pr_list
      (pr_triple !CP.print_formula !CP.print_formula string_of_int)) ) rec_rel_defs no_pos;

  let true_const = List.map (fun (rel_fml,pf,_) -> (rel_fml,pf)) true_const in
  let non_rec_defs = List.map (fun (rel_fml,pf,_) -> (rel_fml,pf)) non_rec_defs in
  if rec_rel_defs=[] then true_const @ non_rec_defs
  else
    true_const @ (* non_rec_defs @ *) (compute_fixpoint_aux rel_defs ante_vars bottom_up)

let compute_fixpoint_x input_pairs ante_vars specs bottom_up =
  let is_bag_cnt rel = List.exists CP.is_bag_typ (CP.fv rel) in
  let input_pairs_bag, input_pairs_num =
    List.partition (fun (p,r) -> is_bag_cnt r) input_pairs
  in
  let bag_res = if input_pairs_bag = [] || not(bottom_up) then []
    else Fixbag.compute_fixpoint 1 input_pairs_bag ante_vars true
  in
  let num_res = if input_pairs_num = [] then []
    else compute_fixpoint_xx input_pairs_num ante_vars specs bottom_up
  in bag_res @ num_res

let compute_fixpoint (i:int) input_pairs ante_vars specs =
  let pr0 = !CP.print_formula in
  let pr1 = pr_list_ln (pr_pair pr0 pr0) in
  let pr2 = !CP.print_svl in
  let pr_res = pr_list (pr_pair pr0 pr0) in
  DD.no_2_num i "compute_fixpoint" pr1 pr2 pr_res
    (fun _ _ -> compute_fixpoint_x input_pairs ante_vars specs true) 
      input_pairs ante_vars

let compute_fixpoint_td (i:int) input_pairs ante_vars specs =
  let pr0 = !CP.print_formula in
  let pr1 = pr_list_ln (pr_pair pr0 pr0) in
  let pr2 = !CP.print_svl in
  let pr_res = pr_list (pr_pair pr0 pr0) in
  DD.no_2_num i "compute_fixpoint_td" pr1 pr2 pr_res 
    (fun _ _ -> compute_fixpoint_x input_pairs ante_vars specs false)
      input_pairs ante_vars

