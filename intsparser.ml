#include "xdebug.cppo"
open VarGen
open Globals
open Gen.Basic
open Iexp 

module I = Iast
module IF = Iformula
module IP = Ipure

let init_conditions_of_block (b : ints_block) : (ints_exp_assume list * ints_exp list) =
  let vars_of_exp e =
    let f e =
      match e with
      | I.Var { I.exp_var_name = id } -> Some [id]
      | _ -> None in
    I.fold_exp e f (List.concat) [] in
  let vars_of_asg asg =
    let lhs = asg.ints_exp_assign_lhs in
    vars_of_exp lhs in
  let vars_of_assume asm =
    vars_of_exp asm.ints_exp_assume_formula in
  let rec helper blk_cmds assigned =
    match blk_cmds with
    | [] -> ([], [])
    | (Assume asm as e)::cmds ->
      (* assumption is "inital" if all of the variables in its formula
       * aren't used by any asg's lhs so far in the block. *)
      let (ic, others) = helper cmds assigned in
      if (List.exists
           (fun i -> List.mem i assigned)
           (vars_of_assume asm))
      then (ic, e::others)
      else (asm::ic, others)
    | (Assign asg as e)::cmds ->
      let (ic, others) = helper cmds ((vars_of_asg asg)@assigned) in
      (ic, e::others)
  in
  helper b.ints_block_commands []

let formula_of_exp (exp : I.exp) : IP.formula =
  let rec helper exp =
    match exp with
    | I.Unary op ->
      let pos = op.I.exp_unary_pos in
      let e = op.I.exp_unary_exp in
      (match op.I.exp_unary_op with
       | I.OpNot ->
         let pf = helper e in
         IP.Not (pf, None, pos)
       | _ -> report_error no_pos "intsparser.trans_pure_formula: unexpected unary_op"
      )
    | I.Binary op ->
      let pos = op.I.exp_binary_pos in
      let e1 = op.I.exp_binary_oper1 in
      let e2 = op.I.exp_binary_oper2 in
      (match op.I.exp_binary_op with
       | I.OpEq ->
         let pe1 = I.trans_to_exp_form e1 in
         let pe2 = I.trans_to_exp_form e2 in
         IP.BForm (((IP.Eq (pe1, pe2, pos)), None), None)
       | I.OpNeq ->
         let pe1 = I.trans_to_exp_form e1 in
         let pe2 = I.trans_to_exp_form e2 in
         IP.BForm (((IP.Neq (pe1, pe2, pos)), None), None)
       | I.OpLt ->
         let pe1 = I.trans_to_exp_form e1 in
         let pe2 = I.trans_to_exp_form e2 in
         IP.BForm (((IP.Lt (pe1, pe2, pos)), None), None)
       | I.OpLte ->
         let pe1 = I.trans_to_exp_form e1 in
         let pe2 = I.trans_to_exp_form e2 in
         IP.BForm (((IP.Lte (pe1, pe2, pos)), None), None)
       | I.OpGt ->
         let pe1 = I.trans_to_exp_form e1 in
         let pe2 = I.trans_to_exp_form e2 in
         IP.BForm (((IP.Gt (pe1, pe2, pos)), None), None)
       | I.OpGte ->
         let pe1 = I.trans_to_exp_form e1 in
         let pe2 = I.trans_to_exp_form e2 in
         IP.BForm (((IP.Gte (pe1, pe2, pos)), None), None)
       | I.OpLogicalAnd ->
         let pf1 = helper e1 in
         let pf2 = helper e2 in
         IP.And (pf1, pf2, pos)
       | I.OpLogicalOr ->
         let pf1 = helper e1 in
         let pf2 = helper e2 in
         IP.Or (pf1, pf2, None, pos)
       | _ -> report_error no_pos "intsparser.trans_pure_formula: unexpected bin_op"
      )
    | _ -> report_error no_pos "intsparser.trans_pure_formula: unexpected exp"
  in
  helper exp

let trans_pure_formula (ass : ints_exp_assume) : IP.formula =
  formula_of_exp ass.ints_exp_assume_formula

let pure_formula_of_condition (cond : ints_exp_assume list) : IP.formula =
  let true_formula = IP.BForm ((IP.BConst (true, no_pos), None), None) in
  List.fold_right (fun a pf2 ->
    let pos = a.ints_exp_assume_pos in
    let pf1 = trans_pure_formula a in
    IP.And (pf1, pf2, pos)) cond true_formula

let is_equivalent_condition c1 c2 =
  let pf1 = pure_formula_of_condition c1 in
  let pf2 = pure_formula_of_condition c2 in
  let cf1 = Astsimp.trans_pure_formula pf1 [] in
  let cf2 = Astsimp.trans_pure_formula pf2 [] in
  Tpdispatcher.simpl_imply_raw cf1 cf2 &&
  Tpdispatcher.simpl_imply_raw cf2 cf1

(* Want to go from, e.g.
 * [[x > 0], [x > 0, y > 0]] => [y > 0, x > 0]
 * [[x > 0 & y > 0], [x <= 0]] => [y > 0, x > 0]
 * i.e., find 'disjunct' set of assumption expressions from a list of blocks. *)
let indepedent_exps_of_blocks (blocks : ints_block list) : I.exp list =
  let rec normalise_exps exps : (I.exp list) =
    (* Want to weed out OR, AND expressions, since these are more difficult
     * to deal with. *)
    match exps with
    | [] -> []
    | exp::exps ->
      (match exp with
       | I.Binary { I.exp_binary_op = op; I.exp_binary_oper1 = e1; I.exp_binary_oper2 = e2 } ->
         (match op with
          | I.OpLogicalAnd | I.OpLogicalOr -> normalise_exps (e1::(e2::exps))
          | _ -> exp::(normalise_exps exps))
       | _ -> exp::(normalise_exps exps))
  in
  (* Test whether the given expression can be 'derived' from some function
   * of a set of expressions.*)
  let is_indep_to (exps : I.exp list) (exp : I.exp) : bool =
    let rec combinations_of exps =
      match exps with
      | [] -> [I.mkBoolLit true no_pos]
      | e::es ->
        let ne = I.mkUnary I.OpNot e None (I.get_exp_pos e) in
        let res = combinations_of es in
        res@(List.map (fun c -> (I.mkBinary I.OpLogicalAnd e c None no_pos)) res)
           @(List.map (fun c -> (I.mkBinary I.OpLogicalAnd ne c None no_pos)) res) in
    let formulae = combinations_of exps in
    (* return whether the given exps are equivalent to the given exp *)
    let exp_satisfies_cond (cond : I.exp) : bool =
      let pf1 = formula_of_exp cond in
      let pf2 = formula_of_exp exp in
      let cf1 = Astsimp.trans_pure_formula pf1 [] in
      let cf2 = Astsimp.trans_pure_formula pf2 [] in
      Tpdispatcher.simpl_imply_raw cf1 cf2 &&
      Tpdispatcher.simpl_imply_raw cf2 cf1
      in
    not (List.exists exp_satisfies_cond formulae)
  in
  let all_block_asms = List.concat (List.map (fun b -> fst (init_conditions_of_block b)) blocks) in
  let norm_exps = normalise_exps (List.map (fun asm -> asm.ints_exp_assume_formula) all_block_asms) in
  let op = (fun acc e ->
              if (is_indep_to acc e)
              then e::acc
              else acc) in
  List.fold_left op [] norm_exps

(* [p, q, r] ->? asm *)
let is_implied_by c asm =
  let af = trans_pure_formula asm in
  let cf = pure_formula_of_condition c in
  let acf = Astsimp.trans_pure_formula af [] in
  let ccf = Astsimp.trans_pure_formula cf [] in
  Tpdispatcher.simpl_imply_raw ccf acf

(* Common factor / condition of two conditions.
 * [p, q, r] [p, s] -> [p] *)
let common_condition_of c1 c2 =
  List.filter (is_implied_by c2) c1

let rec partition_by_key key_of key_eq ls = 
  match ls with
  | [] -> []
  | e::es ->
    let ke = key_of e in 
    let same_es, other_es = List.partition (fun e -> key_eq ke (key_of e)) es in
    (ke, e::same_es)::(partition_by_key key_of key_eq other_es)

let ints_loc_prefix = "ints_method_"

let name_of_ints_loc lbl = 
  match lbl with
  | NumLoc (i, _) -> ints_loc_prefix ^ (string_of_int i)
  | NameLoc (s, _) -> s

let pos_of_ints_loc lbl = 
  match lbl with
  | NumLoc (_, p)
  | NameLoc (_, p) -> p

let eq_ints_loc lbl1 lbl2 =
  (String.compare (name_of_ints_loc lbl1) (name_of_ints_loc lbl2)) == 0

let rec trans_ints_exp_lst (exps: ints_exp list) (last_exp: I.exp): I.exp = 
  match exps with
  | [] -> last_exp
  | e::es ->
    let cont_exp = trans_ints_exp_lst es last_exp in
    match e with
    | Assign asg ->
      let asg_pos = asg.ints_exp_assign_pos in
      let asg_exp = I.mkAssign I.OpAssign asg.ints_exp_assign_lhs asg.ints_exp_assign_rhs 
                      (fresh_branch_point_id "") asg_pos in
      I.mkSeq asg_exp cont_exp asg_pos
    | Assume asm ->
      let asm_pos = asm.ints_exp_assume_pos in
      I.mkCond asm.ints_exp_assume_formula cont_exp (I.Empty asm_pos) None asm_pos

let trans_ints_block (blk: ints_block): I.exp =
  let exps = blk.ints_block_commands in
  let fr = blk.ints_block_from in
  let t = blk.ints_block_to in
  let pos = blk.ints_block_pos in
  (* Translate to_label to a method call *)
  let to_exp = I.mkCallNRecv (name_of_ints_loc t) None [] None (fresh_branch_point_id "") (pos_of_ints_loc t) in
  (* Translate ints_exp list *)
  trans_ints_exp_lst exps to_exp

let trans_ints_block_lst fn (fr_lbl: ints_loc) (blks: ints_block list): I.proc_decl =
  let pos = pos_of_ints_loc fr_lbl in
  let proc_name = name_of_ints_loc fr_lbl in
  let nondet_seq_for blk_exps =
    let rec nondet_chain_for blk_exps =
      match blk_exps with
      | [] -> (I.Empty no_pos)
      | [exp] -> exp
      | blk::blk_exps ->
        let nondet_call = I.mkCallNRecv Globals.nondet_int_proc_name None [] None None no_pos in
        let nondet_cond = I.mkBinary I.OpGt nondet_call (I.mkIntLit 0 no_pos) None no_pos in
        I.mkCond nondet_cond blk (nondet_chain_for blk_exps) None (I.get_exp_pos blk) in
    nondet_chain_for blk_exps
  in
  let wrap_with_cond asm then_exp else_exp =
    let asm_pos = asm.ints_exp_assume_pos in
    I.mkCond asm.ints_exp_assume_formula then_exp else_exp None asm_pos
  in
  let rec helper blks factored =
    match blks with
    | [] -> []
    | blk::blks ->
      let (init_cond, blk_other_exps) = init_conditions_of_block blk in
      (* filter out the conditions which are already considered *)
      let (_, init_cond) = List.partition (is_implied_by factored) init_cond in
      let init_cond_exps = List.map (fun asm -> Assume asm) init_cond in
      let blk = { blk with ints_block_commands = init_cond_exps@blk_other_exps } in
      (* Build Iast cond-expressions with blocks which share common 'factor'
       * in their conditions. *)
      let rec try_to_factor_blocks cond =
        (match cond with
         | [] -> (* empty. No conditions could factor. *)
           (trans_ints_block blk)::(helper blks factored)
         | asm::asms ->
           let negation_of_asm asm =
               let pos = asm.ints_exp_assume_pos in
               let neg = I.mkUnary I.OpNot asm.ints_exp_assume_formula None pos in
               { asm with ints_exp_assume_formula = neg } in
           let is_equiv_asm asm1 asm2 =
             let af1 = trans_pure_formula asm1 in
             let af2 = trans_pure_formula asm2 in
             let acf1 = Astsimp.trans_pure_formula af1 [] in
             let acf2 = Astsimp.trans_pure_formula af2 [] in
             Tpdispatcher.simpl_imply_raw acf1 acf2 &&
             Tpdispatcher.simpl_imply_raw acf2 acf1 in
           let block_has_equiv asm blk =
             let (ic, _) = init_conditions_of_block blk in
             List.exists (is_equiv_asm asm) ic in
           let block_has_negation_of asm blk =
             let (ic, _) = init_conditions_of_block blk in
             List.exists (is_equiv_asm (negation_of_asm asm)) ic in
           (* partition list of blocks into those which have this asm in common,
            * those with the negation_of, and 'others'. *)
           let (common, other) = List.partition (block_has_equiv asm) blks in
           let (negative, other) = List.partition (block_has_negation_of asm) other in
           if (List.length common == 0 && List.length negative == 0)
           then (* No other blocks shared the assumption. *)
              try_to_factor_blocks asms
           else
             let exps_with_factor = helper (blk::common) (asm::factored) in
             let exps_with_negation_of = helper negative ((negation_of_asm asm)::factored) in
             let other_exps = (helper other factored) in
             let then_exp = (nondet_seq_for exps_with_factor) in
             let else_exp = (nondet_seq_for exps_with_negation_of) in
             let cond_exp = wrap_with_cond asm then_exp else_exp in
             cond_exp::other_exps) in
      try_to_factor_blocks init_cond
  in
  let exps = helper blks [] in
  let proc_body = nondet_seq_for exps in
  I.mkProc fn proc_name [] "" None false [] [] I.void_type None (IF.EList []) (IF.mkEFalseF ()) pos (Some proc_body)

let trans_ints_prog fn (iprog: ints_prog): I.prog_decl =
  let main_proc =
    let start_lbl = iprog.ints_prog_start in
    let pos = pos_of_ints_loc start_lbl in
    let start_exp = I.mkCallNRecv (name_of_ints_loc start_lbl) None [] None (fresh_branch_point_id "") pos in
    I.mkProc fn "main" [] "" None false [] [] I.void_type None (IF.EList []) (IF.mkEFalseF ()) pos (Some start_exp)
  in
  let from_lbls = List.map (fun blk -> blk.ints_block_from) iprog.ints_prog_blocks in
  let to_lbls = List.map (fun blk -> blk.ints_block_to) iprog.ints_prog_blocks in
  let abandoned_to_lbls = Gen.BList.remove_dups_eq eq_ints_loc (Gen.BList.difference_eq eq_ints_loc to_lbls from_lbls) in
  let abandoned_procs = List.map (fun lbl ->
      let pos = pos_of_ints_loc lbl in
      let ret_exp = I.mkReturn None None pos in
      I.mkProc fn (name_of_ints_loc lbl) [] "" None false [] [] I.void_type None (IF.EList []) (IF.mkEFalseF ()) pos (Some ret_exp)
    ) abandoned_to_lbls in
  
  let proc_blks = partition_by_key (fun blk -> blk.ints_block_from) eq_ints_loc iprog.ints_prog_blocks in
  let proc_decls = 
    [main_proc] @ 
    (List.map (fun (fr, blks) -> trans_ints_block_lst fn fr blks) proc_blks) @
    abandoned_procs @
    (* ensure `nondet()` proc is in program *)
    match (Parser.create_tnt_prim_proc Globals.nondet_int_proc_name) with
    | None -> [] | Some pd -> [pd]
  in
  let global_vars =
    let f e =
      match e with
      | I.Var v -> Some [(v.I.exp_var_name, v.I.exp_var_pos)]
      | _ -> None
    in
    let all_vars = List.concat (List.map (fun pd ->
        match pd.I.proc_body with
        | None -> []
        | Some b -> I.fold_exp b f (List.concat) [])
      proc_decls) in
    Gen.BList.remove_dups_eq (fun (s1, _) (s2, _) -> String.compare s1 s2 == 0) all_vars
  in
  let () = x_binfo_hp (add_str "global_vars" (pr_list fst)) global_vars no_pos in
  let global_var_decls = List.map (fun (d, p) -> I.mkGlobalVarDecl Int [(d, None, p)] p) global_vars in 
  (* Inline Iast procedure if body is only a call to another procedure *)
  let proc_decls =
      let called_proc pn =
        try Some (List.find
                   (fun pd -> pn = pd.I.proc_name)
                   proc_decls)
        with Not_found -> None in
      let is_self_recursive proc =
          let has_call_with_procname e =
            (match e with
             | I.CallNRecv { exp_call_nrecv_method = cnr_method } ->
               Some (cnr_method = proc.I.proc_name)
             | _ -> None) in
          match proc.I.proc_body with
          | Some bd -> let any = List.fold_left (||) false in
             I.fold_exp bd has_call_with_procname any false
          | None -> false in
      let rec inline_body pd proc_names =
        (match pd.I.proc_body with
        | Some bd ->
          (* function to inline function calls. *)
          let replace_all_proc_calls (e : I.exp) : I.exp option =
            (match e with
             | (I.CallNRecv ({ exp_call_nrecv_method = cnr_method } as cnr)) ->
               let cp = called_proc cnr_method in
               (match cp with
                | Some cp ->
                  if not (List.mem cp.I.proc_name proc_names) then
                    (* cp isn't already being inlined, then recurse *)
                    let inlined_proc = inline_body cp (pd.I.proc_name::proc_names) in
                    if not (is_self_recursive inlined_proc)
                    then inlined_proc.I.proc_body
                    else None
                  else
                    (* The procedure call is to something we're already inlining. self-recursive. *)
                    None
                | None -> None)
             | _ -> None) in
            { pd with I.proc_body = Some (I.map_exp bd replace_all_proc_calls) }
        | _ -> pd) in
      (List.map (fun pd -> inline_body pd []) proc_decls) in
  let called_proc_names =
    let f caller_name e =
      match e with
      (* Don't consider calls where the proc name is the caller name. *)
      | I.CallNRecv { exp_call_nrecv_method = cnr_method } when cnr_method <> caller_name ->
        Some [cnr_method]
      | _ -> None
    in
    let all_calls = "main" :: List.concat (List.map (fun pd ->
        match pd.I.proc_body with
        | None -> []
        | Some b -> I.fold_exp b (f pd.I.proc_name) (List.concat) [])
    proc_decls) in
    Gen.BList.remove_dups_eq (fun s1 s2 -> String.compare s1 s2 == 0) all_calls
  in
  let () = x_binfo_hp (add_str "called_proc_names" (pr_list (fun x->x))) called_proc_names no_pos in
  (* remove procedures which aren't called *)
  let proc_decls =
    List.filter (fun pd -> List.mem pd.I.proc_name called_proc_names) proc_decls
  in
  { prog_include_decls = [];
    prog_data_decls = [];
    prog_global_var_decls = global_var_decls;
    prog_logical_var_decls = [];
    prog_enum_decls = [];
    prog_view_decls = [];
    prog_func_decls = [];
    prog_rel_decls = [];
    prog_rel_ids = [];
    prog_templ_decls = [];
    prog_ut_decls = [];
    prog_hp_decls = [];
    prog_hp_ids = [];
    prog_axiom_decls = [];
    prog_proc_decls = proc_decls;
    prog_coercion_decls = [];
    prog_hopred_decls = [];
    prog_barrier_decls = [];
    prog_test_comps = []; }

let parse_ints (file_name: string): I.prog_decl =
  let in_chnl = open_in file_name in
  let lexbuf = Lexing.from_channel in_chnl in
  let iprog = 
    try
      let p = Iparser.program Ilexer.tokenizer lexbuf in
      let () = close_in in_chnl in
      p
    with e ->
      let () = close_in in_chnl in
      match e with
      | Parsing.Parse_error ->
        let curr = lexbuf.Lexing.lex_curr_p in
        let err_pos = { start_pos = curr; mid_pos = curr; end_pos = curr; } in
        (* let line = curr.Lexing.pos_lnum in                       *)
        (* let cnum = curr.Lexing.pos_cnum - curr.Lexing.pos_bol in *)
        let token = Lexing.lexeme lexbuf in
        Gen.report_error err_pos ("Intsparser: Unexpected token " ^ token)
      | _ -> raise e
  in 
  trans_ints_prog file_name iprog
