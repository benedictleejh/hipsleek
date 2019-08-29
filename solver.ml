#include "xdebug.cppo"

open VarGen
(*
26.11.2008
todo: disable the default logging for omega
*)

open Globals
open Others
open Stat_global
module DD = Debug
open Exc.GTable
open Cast
open Cformula
open Prooftracer
open Gen.Basic
open Immutable
open Perm
open Mcpure_D
open Mcpure
open Cvutil
open Solver_base

module CP = Cpure
module CF = Cformula
module CFU = Cfutil
module MCP = Mcpure
module Err = Error
module TP = Tpdispatcher
module VP = Vperm
module CVP = CvpermUtils
module SB = Songbird

exception False_from_explicit_inst of string

module LO = Label_only.LOne

let self_var vdn = CP.SpecVar (Named vdn, self, Unprimed)

(*used for classic*)
let rhs_rest_emp = ref true

let rhs_pure_stk = new Gen.stack_pr "rhs_pure" (Cprinter.string_of_mix_formula) (==)         (* used for detecting pure contra inside folding *)

(*cyclic: should improve the design. why AS call solver??*)
let manage_unsafe_lemmas =
  ref (fun (repo: Iast.coercion_decl list) (iprog:Iast.prog_decl)
        (cprog:Cast.prog_decl) ->
        let () = print_endline_quiet ("Solver.manage_unsafe_lemmas: not int " )
        in (None: CF.list_context list option))

let vv_ref = ref 9999

(*
   this object is to track progress to prevent
   a lemma from being folded with itself prior to
   a folding step on its LHS term
*)
let lemma_soundness = Cast.lemma_soundness

let wrapper_lemma_soundness = Cast.wrapper_lemma_soundness


(*
: (fun int ->
  Sautility.C.prog_decl ->
  Lemma.CF.h_formula ->
  Lemma.CF.MCP.mix_formula ->
  int ->
  Lemma.CF.MCP.mix_formula * Solver.CP.spec_var list * Solver.CF.mem_formula)
*)
let manage_infer_pred_lemmas =
  ref (fun (repo: Iast.coercion_decl list) (iprog:Iast.prog_decl)
        (cprog:Cast.prog_decl) (fnc) ->
        let () = print_endline_quiet ("Solver.manage_infer_lemmas: not int " ) in
        (([],[],None): ((CP.formula * CP.formula * CP.formula * CP.formula) list
                       ) * (CF.hp_rel_def list) * CF.list_context list option))

let trans_hprel_2_cview =
  ref (fun (iprog:Iast.prog_decl) (cprog:Cast.prog_decl) (proc_name:string)
        (hpdefs:CF.hp_rel_def list) ->
        let () = print_endline_quiet ("Solver.trans_hprel_2_cview: not int " ) in
    (([], []): (view_decl list * hp_decl list)))

let trans_formula_hp_2_view =
  ref (fun (iprog:Iast.prog_decl) (cprog:Cast.prog_decl) (proc_name:string)
        (chprels_decl: hp_decl list) (hpdefs:CF.hp_rel_def list)
        (view_equivs: (Globals.ident * Globals.ident) list)
        (f:CF.formula) -> let () = print_endline_quiet
                              ("Solver.trans_formula_hp_2_view: not int " ) in
        (f:CF.formula))

(** An Hoa : switch to do unfolding on duplicated pointers **)
let unfold_duplicated_pointers = ref true

(** An Hoa : to store the number of unfolding performed on duplicated pointers **)
let num_unfold_on_dup = ref 0

let simple_imply f1 f2 =
  let r,_,_ = x_add TP.imply_one 23 f1 f2 "simple_imply" false None in r

let simple_imply f1 f2 =
  let pr = !CP.print_formula in
  Debug.no_2 "simple_imply" pr pr string_of_bool
    simple_imply f1 f2

let apply_subs subst v =
  try
    List.assoc v subst
  with _ -> v

let subst_eqset subst eqset =
  let subs = apply_subs subst in
  List.map (fun (v1,v2) -> (subs v1,subs v2)) eqset

let subst_eqset s e =
  let pr_sv = Cprinter.string_of_spec_var in
  let pr = pr_list (pr_pair pr_sv pr_sv) in
  Debug.no_2 "subst_eqset" pr pr pr subst_eqset s e

(*find what conditions are required in order for the antecedent node to be pruned sufficiently
  to match the conseq, if the conditions relate only to universal variables then move them to the right*)
let prune_branches_subsume_x prog lhs_node rhs_node:
  (bool*(CP.formula*bool) option) =
  match lhs_node,rhs_node with
  | ThreadNode dn1, ThreadNode dn2-> (true, None) (*No branches for ThreadNode*)
  | HVar _, HVar _ -> (true, None)
  | HRel h1, HRel h2->  (true, None)    (* what decision should be taken abt unk pred? *)
  | DataNode dn1, DataNode dn2->
    (match (dn1.h_formula_data_remaining_branches,
            dn2.h_formula_data_remaining_branches) with
     | None,None -> (true, None)
     | Some l1, _ -> (true, None) (*(Gen.BList.subset_eq (=) l1 l2, None)*)
     | None, Some _ ->
       Debug.print_info "Warning: " "left hand side node is not specialized!" no_pos;
       (false, None))
  | ViewNode vn1, ViewNode vn2->
    (match (vn1.h_formula_view_remaining_branches,
            vn2.h_formula_view_remaining_branches) with
     | None,None -> (true, None)
     | Some l1, Some l2 ->
       let need_prunning = Gen.BList.difference_eq (=) l1 l2 in
       if (List.length need_prunning)<=0 then (true,None) (* *)
       else
         let v_def = look_up_view_def no_pos prog.prog_view_decls
             vn2.h_formula_view_name in
         let to_vars = vn2.h_formula_view_node:: vn2.h_formula_view_arguments in
         let self_v = self_var v_def.view_data_name in
         let from_vars = self_v::v_def.view_vars in
         let subst_vars = List.combine from_vars to_vars in
         let new_cond =
           List.filter (fun (_,c2)-> (List.length (Gen.BList.intersect_eq (=)
                                                     need_prunning c2))>0)
             v_def.view_prune_conditions in
         let new_cond = List.map (fun (c1,c2)-> (CP.b_subst subst_vars c1,c2)) new_cond in
         if (Gen.BList.subset_eq (=) need_prunning
               (List.concat (List.map snd new_cond))) then
           (*i have enough prunning conditions to succeed*)
           let ll = List.map (fun c -> List.filter (fun (_,c1)->
               List.exists ((=) c) c1) new_cond) need_prunning in
           (*posib prunning cond for each branch*)
           let wrap_f (c,_) = CP.BForm ((memo_f_neg c),None) in
           let ll = List.map (fun l -> List.fold_left (fun a c->
               CP.mkOr a (wrap_f c) None no_pos) (wrap_f (List.hd l)) (List.tl l
                                                                      )) ll in
           let inst_forms = CP.conj_of_list ll no_pos in
           let fls = ((List.length need_prunning)=(List.length l1)) in
           (true, Some (inst_forms,fls))
         else (
           print_string "I do not have enough prunning conditions to succeed in this match\n";
           print_string ("lhs_br: "^(Cprinter.string_of_formula_label_list l1));
           print_string ("rhs_br: "^(Cprinter.string_of_formula_label_list l2));
           print_string ("need_prunning: "^(Cprinter.string_of_formula_label_list need_prunning));
           print_string ("cond : "^(Cprinter.string_of_case_guard new_cond));
           (false, None)) (*this should not occur though*)
     | None, Some _ ->
       Debug.print_info "Warning: " "left hand side node is not specialized!" no_pos;
       (false, None)
     | Some _, None ->
       Debug.print_info "Warning: " "right hand side node is not specialized!" no_pos;
       (true, None)
    )
  | _ -> (false, None)

let prune_branches_subsume prog lhs_node rhs_node =
  let pr1 = pr_pair Cprinter.string_of_pure_formula string_of_bool in
  let pr2 = pr_pair string_of_bool (pr_opt pr1) in
  let pr = Cprinter.string_of_h_formula in
  Debug.no_2 "pr_branches_subsume" pr pr pr2 (fun _ _ ->
      prune_branches_subsume_x prog lhs_node rhs_node) lhs_node rhs_node

(*LDK: only use crt_heap_entailer
  a : Cformula.list_failesc_context
*)
let heap_entail_agressive_prunning (crt_heap_entailer:'a -> 'b)
    (prune_fct:'a -> 'a) (res_checker:'b-> bool) (argument:'a) :'b =
  begin
    let first_res = crt_heap_entailer argument in
    first_res
  end

let clear_entailment_history_es (es :entail_state) :context =
  (* TODO : this is clearing more than es_heap since qsort-tail.ss fails otherwise *)
  Ctx {
    (empty_es (mkTrueFlow ()) es.es_group_lbl no_pos) with
    es_formula = es.es_formula;
    es_path_label = es.es_path_label;
    es_cond_path = es.es_cond_path ;
    es_prior_steps = es.es_prior_steps;
    es_var_measures = es.es_var_measures;
    es_infer_obj = es.es_infer_obj;
    es_infer_vars = es.es_infer_vars;
    es_infer_heap = es.es_infer_heap;
    es_infer_templ = es.es_infer_templ;
    es_infer_templ_assume = es.es_infer_templ_assume;
    es_infer_pure = es.es_infer_pure;
    es_infer_vars_rel = es.es_infer_vars_rel;
    es_infer_vars_templ = es.es_infer_vars_templ;
    es_infer_term_rel = es.es_infer_term_rel;
    es_infer_rel = es.es_infer_rel # clone;
    es_infer_vars_hp_rel = es.es_infer_vars_hp_rel;
    es_infer_vars_sel_hp_rel = es.es_infer_vars_sel_hp_rel;
    es_infer_vars_sel_post_hp_rel = es.es_infer_vars_sel_post_hp_rel;
    es_infer_hp_unk_map = es.es_infer_hp_unk_map;
    es_infer_hp_rel = es.es_infer_hp_rel # clone;
    es_var_zero_perm = es.es_var_zero_perm;
    es_ho_vars_map = es.es_ho_vars_map; (*TOCHECK*)
  }

let fail_ctx_stk = ref ([]:fail_type list)
let previous_failure () = not(Gen.is_empty !fail_ctx_stk)

class entailhist =
  object (self)
    val en_hist = Hashtbl.create 40

    method init () = Hashtbl.clear en_hist

    method upd_opt (pid : control_path_id) (rs: list_context) (errmsg: string) =
      match pid with
        None -> failwith errmsg;
      | Some (pid_i,_) -> Hashtbl.add en_hist pid_i rs

    method upd (pid : formula_label) (rs: list_context) =
      let pid_i,_ = pid in
      Hashtbl.add en_hist pid_i rs

    method get (id : int) : list_context list =
      Hashtbl.find_all en_hist id

  end

let entail_hist = new entailhist

let no_diff = ref false
(* if true, then xpure_symbolic will drop the disequality generated by * *)

let no_check_outer_vars = ref false

let rec pairwise_diff (svars10: P.spec_var list ) (svars20:P.spec_var list) pos =
  let rec diff_one sv svars = match svars with
    | sv2 :: rest ->
      let tmp1 = diff_one sv rest in
      let tmp2 = CP.mkNeqVar sv sv2 pos in
      let res = CP.mkAnd tmp1 tmp2 pos in
      res
    | [] -> CP.mkTrue pos
  in
  if Gen.is_empty svars20 then
    CP.mkTrue pos
  else
    match svars10 with
    | sv :: rest ->
      let tmp1 = pairwise_diff rest svars20 pos in
      let tmp2 = diff_one sv svars20 in
      let res = CP.mkAnd tmp1 tmp2 pos in
      res
    | [] -> CP.mkTrue pos

and prune_ctx_failesc_list prog ctx = List.map (fun (c1,c2,c3)->
    let rc3 = List.map (prune_branch_ctx prog) c3 in
    (c1,c2,rc3))  ctx

(*
  type: Mcpure_D.memo_pure ->
  (CP.b_formula * Globals.formula_label list) list ->
  Globals.formula_label list ->
  Globals.formula_label list *
  (Cformula.CP.b_formula * Globals.formula_label list) list *
  Mcpure_D.memo_pure

  Arguments:
  old_mem: formula to prune
  prun_cond: a list of b_formula and its corresponding branch
  rem_br: remaining branch to prune
*)
(********************************************************)
and combine_es_and prog (f : MCP.mix_formula) (reset_flag:bool) (es : entail_state) : context =
  let r1,r2 = combine_and es.es_formula f in
  if (reset_flag) then if r2 then (Ctx {es with es_formula = r1;es_unsat_flag =false;})
    else Ctx {es with es_formula = r1;}
  else Ctx {es with es_formula = r1;}

and list_context_and_unsat_now prog (ctx : list_context) : list_context =
  let r = transform_list_context ((elim_unsat_es 7 prog (ref 1)),(fun c->c)) ctx in
  TP.incr_sat_no () ; r

and list_failesc_context_and_unsat_now prog (ctx : list_failesc_context) :
  list_failesc_context =
  let r = transform_list_failesc_context (idf,idf,(elim_unsat_es 6 prog (ref 1))) ctx in
  let r = List.map (x_add_1 CF.remove_dupl_false_fe) r in
  TP.incr_sat_no () ; r

and combine_list_failesc_context_and_unsat_now_x prog (ctx :
  list_failesc_context) (f : MCP.mix_formula) : list_failesc_context =
  let r = transform_list_failesc_context (idf,idf,(combine_es_and prog f true)) ctx in
  let r = transform_list_failesc_context (idf,idf,(x_add elim_unsat_es_now 2 prog (ref 1))) r in
  let r = List.map (x_add_1 CF.remove_dupl_false_fe) r in
  TP.incr_sat_no () ; r

and combine_list_failesc_context_and_unsat_now prog (ctx : list_failesc_context)
  (f : MCP.mix_formula) : list_failesc_context =
  let pr = Cprinter.string_of_list_failesc_context in
  let pr2 = Cprinter.string_of_mix_formula in
  Debug.no_2 "combine_list_failesc_context_and_unsat_now" pr pr2 pr (fun _ _ ->
      combine_list_failesc_context_and_unsat_now_x prog ctx f) ctx f

and combine_list_failesc_context prog (ctx : list_failesc_context) (f :
  MCP.mix_formula) : list_failesc_context =
  let r = transform_list_failesc_context (idf,idf,(combine_es_and prog f true)) ctx in
  let r = List.map (x_add_1 CF.remove_dupl_false_fe) r in r

and combine_context_and_unsat_now prog (ctx : context) (f : MCP.mix_formula) : context =
  let pr_ctx = Cprinter.string_of_context_short in
  let pr_mf = Cprinter.string_of_mix_formula in
  Debug.no_2 "combine_context_and_unsat_now" pr_ctx pr_mf pr_ctx (fun _ _ ->
      combine_context_and_unsat_now_x prog ctx f) ctx f


and combine_context_and_unsat_now_x prog (ctx : context) (f : MCP.mix_formula) : context =
  let r = transform_context (combine_es_and prog f true) ctx in
  let r = transform_context (x_add elim_unsat_es_now 3 prog (ref 1)) r in
  TP.incr_sat_no () ; r
(* expand all predicates in a definition *)

and context_and_unsat_now prog (ctx : context)  : context =
  let r = transform_context (elim_unsat_es 5 prog (ref 1)) ctx in
  TP.incr_sat_no () ; r
(* expand all predicates in a definition *)

and expand_all_preds prog f0 do_unsat: formula =
  match f0 with
  | Or (({
      formula_or_f1 = f1;
      formula_or_f2 = f2}) as or_f) ->
    begin
      let ef1 = expand_all_preds prog f1 do_unsat in
      let ef2 = expand_all_preds prog f2 do_unsat in
      Or ({or_f with formula_or_f1 = ef1; formula_or_f2 = ef2})
    end
  | Base ({
      formula_base_heap = h;
      formula_base_pure = p;
      formula_base_vperm = vp;
      formula_base_and = a; (*TO CHECK: ???*)
      formula_base_pos =pos }) ->
    begin
      let proots = find_pred_roots_heap h in
      let ef0 = List.fold_left (fun f v -> fst (unfold_nth 3 (prog,None) f v
                                                  do_unsat 0 pos) ) f0 proots in
      ef0
    end
  | Exists ({
      formula_exists_qvars = qvars;
      formula_exists_heap = qh;
      formula_exists_pure = qp;
      formula_exists_vperm = vp;
      formula_exists_flow = fl;
      formula_exists_and = a; (*TO CHECK*)
      formula_exists_label = lbl;
      formula_exists_pos = pos }) ->
    begin
      let proots = find_pred_roots_heap qh in
      let f = Base ({
          formula_base_heap = qh;
          formula_base_vperm = vp;
          formula_base_pure = qp;
          formula_base_type = TypeTrue;
          formula_base_and = a; (*TO CHECK: ???*)
          formula_base_flow = fl;
          formula_base_label = lbl;
          formula_base_pos = pos }) in
      let ef,_ = List.fold_left (fun (f,ss) v0 ->
          let v = CP.subst_var_par ss v0 in
          let nf,ss1 =  unfold_nth 4 (prog,None) f v do_unsat 0 pos in
          (nf, ss@ss1)) (f,[]) proots in
      let ef0 = push_exists qvars ef in
      ef0
    end

and find_pred_roots f0 = match f0 with
  | Or ({formula_or_f1 = f1;
         formula_or_f2 = f2}) -> begin
      let pr1 = find_pred_roots f1 in
      let pr2 = find_pred_roots f2 in
      let tmp = CP.remove_dups_svl (pr1 @ pr2)  in
      tmp
    end
  | Base ({formula_base_heap = h;
           formula_base_pure = p;
           formula_base_pos =pos}) -> find_pred_roots_heap h
  | Exists ({formula_exists_qvars = qvars;
             formula_exists_heap = qh;
             formula_exists_pure = qp;
             formula_exists_pos = pos}) -> begin
      let tmp1 = find_pred_roots_heap qh in
      let tmp2 = Gen.BList.difference_eq CP.eq_spec_var tmp1 qvars in
      tmp2
    end

and find_pred_roots_heap h0 =
  match h0 with
  | Star ({h_formula_star_h1 = h1;
           h_formula_star_h2 = h2;
           h_formula_star_pos = pos})
  | StarMinus ({h_formula_starminus_h1 = h1;
                h_formula_starminus_h2 = h2;
                h_formula_starminus_pos = pos})
  | Conj ({h_formula_conj_h1 = h1;
           h_formula_conj_h2 = h2;
           h_formula_conj_pos = pos})
  | ConjStar ({h_formula_conjstar_h1 = h1;
               h_formula_conjstar_h2 = h2;
               h_formula_conjstar_pos = pos})
  | ConjConj ({h_formula_conjconj_h1 = h1;
               h_formula_conjconj_h2 = h2;
               h_formula_conjconj_pos = pos})
  | Phase ({h_formula_phase_rd = h1;
            h_formula_phase_rw = h2;
            h_formula_phase_pos = pos}) -> begin
      let pr1 = find_pred_roots_heap h1 in
      let pr2 = find_pred_roots_heap h2 in
      let tmp = CP.remove_dups_svl (pr1 @ pr2) in
      tmp
    end
  | ViewNode ({h_formula_view_node = p}) -> [p]
  | ThreadNode _
  | DataNode _ | HTrue | HFalse | HEmp | HRel _ | Hole _ | FrmHole _ | HVar _ -> []

(* unfold then unsat *)
and unfold_context_unsat_now_x prog0 (prog:prog_or_branches)
    (ctx : list_context) (v : CP.spec_var) (pos : loc) : list_context =
  let ctx = unfold_context prog ctx v false pos in
  list_context_and_unsat_now prog0 ctx

and unfold_context_unsat_now prog0 (prog:prog_or_branches)
    (ctx : list_context) (v : CP.spec_var) (pos : loc) : list_context =
  let p1 = Cprinter.string_of_prog_or_branches in
  let p2 = Cprinter.string_of_spec_var in
  let pr_out = Cprinter.string_of_list_context in
  Debug.no_2 "unfold_context_unsat_now" p1 p2 pr_out (fun _ _ ->
      unfold_context_unsat_now_x prog0 prog ctx v pos) prog v

(* unfolding *)
and unfold_context (prog:prog_or_branches) (ctx : list_context)
    (v : CP.spec_var) (already_unsat:bool)(pos : loc) : list_context =
  let fct es =
    let unfolded_f,_ = unfold_nth 5 prog es.es_formula v already_unsat 0 pos in
    let res = build_context (Ctx es) unfolded_f pos in
    if already_unsat then set_unsat_flag res true
    else res in
  transform_list_context (fct,(fun c->c)) ctx

and unfold_partial_context (prog:prog_or_branches) (ctx : list_partial_context)
  (v : CP.spec_var) (already_unsat:bool)(pos : loc) : list_partial_context =
  let fct es =
    let unfolded_f,_ = unfold_nth 6 prog es.es_formula v already_unsat 0 pos in
    let res = build_context (Ctx es) unfolded_f pos in
    if already_unsat then set_unsat_flag res true
    else res in
  transform_list_partial_context (fct,(fun c->c)) ctx

and unfold_failesc_context (prog:prog_or_branches) (ctx : list_failesc_context)
  (v : CP.spec_var) (already_unsat:bool)(pos : loc) : list_failesc_context =
  let pr1 = Cprinter.string_of_list_failesc_context in
  let pr2 = CP.string_of_spec_var in
  Debug.no_2 "unfold_failesc_context" pr1 pr2 pr1
    (fun _ _ -> unfold_failesc_context_x prog ctx v already_unsat pos) ctx v

and unfold_failesc_context_x (prog:prog_or_branches) (ctx :
  list_failesc_context) (v : CP.spec_var) (already_unsat:bool)(pos : loc) :
  list_failesc_context =
  let fct es =
    (* this came from unfolding for bind mostly *)
    (*VarPerm: to keep track of es_var_zero_perm, when rename_bound_vars, also rename zero_perm*)
    if (es.es_var_zero_perm!=[]) then
      let new_f = es.es_formula in
      let unfolded_f,_ = unfold_nth 7 prog new_f v already_unsat 0 pos in
      let new_es = es in
      let res = build_context (Ctx new_es) unfolded_f (* unfolded_f2 *) pos in
      if already_unsat then set_unsat_flag res true
      else res
    else
      let formula = es.es_formula in
      let e_vars = CF.get_exists formula in
      let n_f = Synthesis.remove_exists_vars formula e_vars in
      let unfolded_f,_ = unfold_nth 7 prog n_f v already_unsat 0 pos in
      let unfolded_f = Synthesis.add_exists_vars unfolded_f e_vars in
      let res = build_context (Ctx es) unfolded_f pos in
      if already_unsat then set_unsat_flag res true
      else res in
  transform_list_failesc_context (idf,idf,fct) ctx

and unfold_struc_nth (n:int) (prog:prog_or_branches) (f : struc_formula) (v : CP.spec_var)
    (already_unsat:bool) (uf:int) (pos : loc) : struc_formula =
  let pr = Cprinter.string_of_struc_formula in
  let pr2 = Cprinter.string_of_prog_or_branches in
  let prs = Cprinter.string_of_spec_var in
  Debug.no_4_num n "unfold_struc_nth" string_of_bool prs pr pr2 pr
    (fun _ _ _ _ -> unfold_struc_x prog f v already_unsat uf pos) already_unsat v f prog

and unfold_struc_x (prog:prog_or_branches) (f : struc_formula) (v : CP.spec_var)
    (already_unsat:bool) (uf:int) (pos : loc) : struc_formula =

  let struc_unfold_baref prog (h : h_formula) (p : MCP.mix_formula)
      (vp: CVP.vperm_sets) a (fl:flow_formula) (v : CP.spec_var) pos
      qvars ee ei ii already_unsat (uf:int) : struc_formula option =
    let asets = Csvutil.alias_nth 6 (MCP.ptr_equations_with_null p) in
    let aset' = x_add Csvutil.get_aset asets v in
    let aset = if CP.mem v aset' then aset' else v :: aset' in
    let h_rest, unfolded_f = struc_unfold_heap prog h aset v uf (qvars@ee@ei) pos in
    match unfolded_f with
    | None -> None
    | Some s ->
      let rem_f = mkEBase_w_vars ee ei ii (mkBase h_rest p vp TypeTrue fl a pos) None pos in
      let pr = Cprinter.string_of_struc_formula in
      let () = x_tinfo_hp (add_str "Solver: rem_f: " pr) rem_f pos in
      let () = x_tinfo_hp (add_str "Solver: s: " pr) s pos in
      let () = x_tinfo_hp (add_str "Solver: combined: " pr) (combine_struc rem_f s) pos in
      let () = x_tinfo_hp (add_str "Solver: exists: " pr)
          (push_struc_exists qvars (combine_struc rem_f s)) pos in
      Some (push_struc_exists qvars (combine_struc rem_f s) ) in

  let f_helper ee ei ii f =
    let nf = match f with
      | Or _ -> report_error no_pos
                  "[solver.ml] unfold_struc, struc formula should have been
    normalized. Did not expect Or"
      | Base {
          formula_base_heap = h;
          formula_base_pure = p;
          formula_base_vperm = vp;
          formula_base_and = a;
          formula_base_flow = fl;
          formula_base_pos = pos; } ->
        struc_unfold_baref prog h p vp a fl v pos []  ee ei ii already_unsat uf
      | Exists _ ->
        let pr = Cprinter.string_of_spec_var_list in
        let () = x_tinfo_hp (add_str "Solver.unfold_struc: ee: " pr) ee pos in
        let () = x_tinfo_hp (add_str "Solver.unfold_struc: ei: " pr) ei pos in
        let () = x_tinfo_hp (add_str "Solver.unfold_struc: ii: " pr) ii pos in
        (*should remove non-continuous para*)
        let rf,l = x_add_1 rename_bound_vars_with_subst f in
        let qvars, baref = split_quantifiers rf in
        let () = x_tinfo_hp (add_str "Solver.unfold_struc: qvars: " pr) qvars pos in
        let () = x_tinfo_hp (add_str "Solver.unfold_struc: rf: "
                               Cprinter.string_of_formula) rf pos in
        let () = x_tinfo_hp (add_str "Solver.unfold_struc: baref: "
                               Cprinter.string_of_formula) baref pos in
        let h, p, vp, fl, t, a = split_components baref in
        struc_unfold_baref prog h p vp a fl v pos qvars ee ei ii already_unsat uf in
    match nf with
    | None -> None
    | Some s ->
      let tmp_es = CF.empty_es (CF.mkTrueFlow ()) (None,[]) no_pos in
      (* WN_all_lemma : are there two programs here? *)
      Some (normalize_struc_formula_w_coers (fst prog) tmp_es s
              (Lem_store.all_lemma # get_left_coercion)) in

  let rec struc_helper f = match f with
    | ECase b -> ECase {b with formula_case_branches
                               = map_l_snd struc_helper b.formula_case_branches}
    | EList b -> EList (map_l_snd struc_helper b)
    | EAssume b -> EAssume {
        b with formula_assume_simpl
               = fst(unfold_nth 44 prog b.formula_assume_simpl v already_unsat
                       uf pos);
               formula_assume_struc = struc_helper b.formula_assume_struc;}
    | EInfer b -> EInfer {b with formula_inf_continuation = struc_helper
                                     b.formula_inf_continuation;}
    | EBase {
        formula_struc_exists = ee;
        formula_struc_explicit_inst = ei;
        formula_struc_implicit_inst = ii;
        formula_struc_continuation = cont;
        formula_struc_base = base;} ->
      match f_helper ee ei ii base with
      | None -> f
      | Some s -> match map_opt struc_helper cont  with
        | None -> s
        | Some f -> combine_struc f s
  in
  struc_helper f

and struc_unfold_heap_x (prog:Cast.prog_or_branches) (f : h_formula) (aset :
  CP.spec_var list) (v : CP.spec_var) (uf:int) eqvars pos:
  h_formula *(struc_formula option)=
  let (f,r) = pick_view_node f aset in
  let n_struc = match r with
    | None -> None
    | Some { h_formula_view_node = p;
             h_formula_view_imm = imm;
             h_formula_view_name = lhs_name;
             h_formula_view_origins = origs;
             h_formula_view_unfold_num = old_uf;
             h_formula_view_label = v_lbl;
             h_formula_view_remaining_branches = brs;
             h_formula_view_perm = perm;
             h_formula_view_arguments = vs;
             h_formula_view_annot_arg = anns
           } ->
      let uf = old_uf+uf in
      let vdef = x_add Cast.look_up_view_def pos (fst prog).prog_view_decls lhs_name in
      (* check to see if vdef case vars are quantif. Is so use unstruc view formula *)
      let vs_vdef = List.combine ((self_var vdef.view_data_name)::vdef.view_vars) (p::vs) in
      let is_in v lst = Gen.BList.mem_eq CP.eq_spec_var v lst in
      let quantif_case_vars = List.exists (fun (vdef_arg,varg) ->
          is_in varg eqvars && is_in vdef_arg vdef.view_case_vars) vs_vdef in
      let joiner f = formula_of_disjuncts (fst (List.split f)) in
      let args = p::vs in
      let pr = Cprinter.string_of_spec_var in
      let () = x_tinfo_hp (add_str "quantif_case_vars" string_of_bool)  quantif_case_vars no_pos in
      let () = x_tinfo_hp (add_str "vs_vdef" (pr_list (pr_pair pr pr))) vs_vdef no_pos in
      let () = x_tinfo_hp (add_str "case_vars" Cprinter.string_of_spec_var_list)
          vdef.view_case_vars no_pos in
      let () = x_tinfo_hp (add_str "args" Cprinter.string_of_spec_var_list)  args no_pos in
      let forms = match brs, quantif_case_vars with
        | None, false   -> vdef.view_formula
        | None, true    ->
          let f = joiner  vdef.view_un_struc_formula in
          struc_formula_of_formula f  pos
        | Some s,_      ->
          let f = joiner (List.filter (fun (_,l)-> List.mem l s) vdef.view_un_struc_formula) in
          struc_formula_of_formula f  pos  in
      let renamed_view_formula = add_struc_unfold_num (rename_struc_bound_vars forms) uf in
      let renamed_view_formula =
        if (Perm.allow_perm ()) then
          (match perm with
           | None -> renamed_view_formula
           | Some f -> Cformula.propagate_perm_struc_formula
  renamed_view_formula (Cpure.get_var f))
        else renamed_view_formula in
      let forms = try
          let fr_ann = List.map fst vdef.view_ann_params in
          let anns = List.map fst anns in
          let to_ann = anns in
          let mpa = List.combine fr_ann to_ann in
          Immutable.propagate_imm renamed_view_formula lhs_name imm mpa
        with _ -> renamed_view_formula
      in
      let fr_vars = (CP.SpecVar (Named vdef.view_data_name, self, Unprimed))::  vdef.view_vars in
      let to_rels,to_rem = (List.partition CP.is_rel_typ vs) in
      let res_form = subst_struc_avoid_capture fr_vars (v::vs) renamed_view_formula in
      let res_form = struc_formula_set_lhs_case false (add_struc_origins origs res_form ) in
      let new_struc_f = CF.replace_struc_formula_label v_lbl res_form in
      Some new_struc_f in
  (f,n_struc)

and struc_unfold_heap (prog:Cast.prog_or_branches) (f : h_formula) (aset :
  CP.spec_var list) (v : CP.spec_var) (uf:int) qvars pos:
  h_formula *(struc_formula option)=
  let pr = Cprinter.string_of_struc_formula in
  let prh = Cprinter.string_of_h_formula in
  let pr2 = Cprinter.string_of_prog_or_branches in
  let prs = Cprinter.string_of_spec_var in
  let pr_out = ( (pr_pair prh (pr_opt pr))  ) in
  Debug.no_5 "struc_unfold_heap"  prh (pr_list prs) prs pr2 (pr_list prs) pr_out
    (fun _ _ _ _ _ -> struc_unfold_heap_x prog f aset v uf qvars pos)  f aset v prog qvars

and unfold_nth (n:int) (prog:prog_or_branches) (f : formula) (v : CP.spec_var)
    ?(lem_unfold = false) (already_unsat:bool) (uf:int) (pos : loc):
  (formula * (CP.spec_var*CP.spec_var) list) =
  let prs = Cprinter.string_of_spec_var in
  let pr = Cprinter.string_of_formula in
  let pr2 = Cprinter.string_of_prog_or_branches in
  let pr_out = pr_pair pr (pr_list (pr_pair prs prs)) in
  Debug.no_5_num (*loop*) n "unfold"
    (add_str "lem_unfold" string_of_bool)
    (add_str "already_unsat" string_of_bool)
    prs pr pr2 pr_out
    (fun _ _ _ _ _ -> unfold_x prog f v ~lem_unfold:lem_unfold already_unsat uf pos)
    lem_unfold already_unsat v f prog

and unfold_x (prog:prog_or_branches) (f : formula) (v : CP.spec_var)
    ?(lem_unfold = false) (already_unsat:bool) (uf:int) (pos : loc)  =
  let rec aux f v  uf pos =
    match f with
    | Base ({
        formula_base_heap = h;
        formula_base_pure = p;
        formula_base_vperm = vp;
        formula_base_flow = fl;
        formula_base_and = a;
        formula_base_pos = pos}) ->
      let new_f = unfold_baref prog h p vp a fl v pos [] ~lem_unfold:lem_unfold already_unsat uf in
      let tmp_es = CF.empty_es (CF.mkTrueFlow ()) (None,[]) no_pos in
      (normalize_formula_w_coers 1 (fst prog) tmp_es new_f
         (Lem_store.all_lemma # get_left_coercion), [])

    | Exists _ ->
      let rf,l = x_add_1 rename_bound_vars_with_subst f in
      let v = CP.subst_var_par l v in
      let qvars, baref = split_quantifiers rf in
      let h, p, vp, fl, t, a = split_components baref in
      let uf = unfold_baref prog h p vp a fl v pos qvars ~lem_unfold:lem_unfold already_unsat uf in
      let tmp_es = CF.empty_es (CF.mkTrueFlow ()) (None,[]) no_pos in
      (normalize_formula_w_coers 2 (fst prog) tmp_es uf
         (Lem_store.all_lemma # get_left_coercion), l)
    | Or ({formula_or_f1 = f1;
           formula_or_f2 = f2;
           formula_or_pos = pos}) ->
      let uf1,l1 = aux f1 v uf pos in
      let uf2,l2 = aux f2 v uf pos in
      let resform = mkOr uf1 uf2 pos in
      resform,l1@l2
  in
  let new_f,ss0 = aux f v uf pos in
  let new_f = x_add_1 Immutable.normalize_field_ann_formula new_f in
  new_f,ss0

and unfold_baref_x prog (h : h_formula) (p : MCP.mix_formula) (vp:
    CVP.vperm_sets) a (fl:flow_formula) (v : CP.spec_var)
    pos qvars ?(lem_unfold = false) already_unsat (uf:int) =
  let asets = Csvutil.alias_nth 6 (MCP.ptr_equations_with_null p) in
  let aset' = x_add Csvutil.get_aset asets v in
  let aset = if CP.mem v aset' then aset' else v :: aset' in
  let unfolded_h = (x_add_1 unfold_heap prog) h aset v fl uf ~lem_unfold:lem_unfold pos in
  let pure_f = mkBase HEmp p vp TypeTrue (mkTrueFlow ()) [] pos in
  let tmp_form_norm = normalize_combine unfolded_h pure_f pos in
  let tmp_form = Cformula.set_flow_in_formula_override fl tmp_form_norm in
  let tmp_form = add_formula_and a tmp_form in
  let resform = if (List.length qvars) >0 then push_exists qvars tmp_form else tmp_form in
  if already_unsat then match (snd prog) with
    | None ->
      (Gen.Profiling.push_time "unfold_unsat";
       let r = elim_unsat_for_unfold (fst prog) resform in
       Gen.Profiling.pop_time "unfold_unsat";r)
    | _ -> resform
  else resform

and unfold_baref prog (h : h_formula) (p : MCP.mix_formula) (vp: CVP.vperm_sets)
    a (fl:flow_formula) (v : CP.spec_var) pos qvars ?(lem_unfold = false)
    already_unsat (uf:int) =
  let pr1 = Cprinter.string_of_h_formula in
  let pr_out = Cprinter.string_of_formula in
  Debug.no_1 "unfold_baref"
    (add_str "lhs heap:" pr1)
    pr_out
    (fun _ -> unfold_baref_x prog (h : h_formula) (p : MCP.mix_formula)
        (vp: CVP.vperm_sets) a (fl:flow_formula) (v : CP.spec_var)
        pos qvars ~lem_unfold:lem_unfold already_unsat (uf:int) ) h

and unfold_heap (prog:Cast.prog_or_branches) (f : h_formula) (aset : CP.spec_var
  list) (v : CP.spec_var) fl (uf:int) ?(lem_unfold = false) pos : formula =
  let pr1 = Cprinter.string_of_h_formula in
  let pr2 = Cprinter.string_of_spec_var in
  let pr3 = pr_list pr2 in
  let pr_out = Cprinter.string_of_formula in
  Debug.no_5 "unfold_heap"
    (add_str "lhs heap:" pr1)
    (add_str "lhs var:" pr2)
    (add_str "lhs aset:" pr3)
    (add_str "lem_unfold" string_of_bool)
    (add_str "unfold count:" string_of_int)
    pr_out
    (fun _ _ _ _ _ -> unfold_heap_x prog f aset v fl uf ~lem_unfold:lem_unfold
        pos) f v aset lem_unfold uf

and unfold_heap_x (prog:Cast.prog_or_branches) (f : h_formula) (aset :
  CP.spec_var list) (v : CP.spec_var) fl (uf:int) ?(lem_unfold = false) pos:
  formula =
  match f with
  | ViewNode ({h_formula_view_node = p;
               h_formula_view_imm = imm;
               h_formula_view_name = lhs_name;
               h_formula_view_origins = origs;
               h_formula_view_original = original;
               h_formula_view_unfold_num = old_uf;
               h_formula_view_label = v_lbl;
               h_formula_view_remaining_branches = brs;
               h_formula_view_perm = perm;
               h_formula_view_arguments = vs;
               h_formula_view_annot_arg = anns;
              }) ->
    (*!!Attention: there might be several nodes pointed to by the same pointer
      as long as they are empty*)
    let prog1 = fst prog in
    let vdef = x_add Cast.look_up_view_def pos prog1.prog_view_decls lhs_name in
    if (vdef.view_is_prim) then
      (* don't unfold primitive predicates *)
      formula_of_heap_fl f fl pos
    else if CP.mem p aset then (
      match (snd prog) with
      | None ->
        let uf = old_uf+uf in
        let joiner f = formula_of_disjuncts (fst (List.split f)) in
        let filt s = (List.filter (fun (_,l)-> List.mem l s) vdef.view_un_struc_formula) in
        let forms = match brs with
          | None ->
            let f = formula_of_unstruc_view_f vdef in
            let () = y_tinfo_hp (add_str "form_unstr_view" !CF.print_formula) f in
            f
          | Some s ->
            let ()  = y_tinfo_pp "here 1" in
            joiner (filt s) in
        let () = y_tinfo_hp (add_str "forms 1" !CF.print_formula) forms in
        let from_ann = List.map fst vdef.view_ann_params in
        let anns = List.map fst anns in
        let to_ann = anns in
        let forms =
          try
            let mpa = List.combine from_ann to_ann in
            propagate_imm_formula forms lhs_name imm mpa
          with _ -> forms
        in
        let renamed_view_formula = x_add_1 rename_bound_vars forms in
        let renamed_view_formula = add_unfold_num renamed_view_formula uf in
        let renamed_view_formula =
          if (Perm.allow_perm ()) then
            (match perm with
             | None -> renamed_view_formula
             | Some f -> Cformula.propagate_perm_formula renamed_view_formula (Cpure.get_var f))
          else renamed_view_formula
        in
        let fr_vars = (CP.SpecVar (Named vdef.view_data_name, self, Unprimed))
                      :: vdef.view_vars in
        let to_rels,to_rem = (List.partition CP.is_rel_typ vs) in
        let to_vars = v :: vs in
        let res_form = subst_avoid_capture fr_vars to_vars renamed_view_formula in
        let () = y_tinfo_pp ("unfold pre subst: "^(Cprinter.string_of_formula
                                                     renamed_view_formula)) in
        let () = y_tinfo_pp (("unfold post subst: "^(Cprinter.string_of_formula res_form))) in
        let res_form = add_origins res_form origs in
        let res_form = set_lhs_case res_form false in (* no LHS case analysis after unfold *)
        let ()  = y_tinfo_pp "2" in
        CF.replace_formula_label v_lbl res_form
      | Some (base , (pred_id,to_vars)) -> (* base case unfold *)
        (* ensures that only view with a specific pred and arg are base-case unfolded *)
        let flag =
          if (pred_id=lhs_name) then (
            try
              (List.fold_left2 (fun a c1 c2-> a&&(CP.eq_spec_var c1 c2)) true to_vars vs)
            with _ ->
              print_endline("\nWARNING : mis-matched list lengths");
              print_endline("Pred name :"^pred_id);
              print_endline("vars1     :"^(pr_list (Cprinter.string_of_spec_var) vs));
              print_endline("vars2     :"^(pr_list (Cprinter.string_of_spec_var) to_vars));
              false
          )
          else false
        in
        let () = y_tinfo_hp (add_str "base-case-unfold" string_of_bool) flag in
        if flag then  (* perform base-case unfold *)
          CF.replace_formula_label v_lbl  (CF.formula_of_mix_formula_with_fl base fl [] no_pos)
        else formula_of_heap f pos
    )
    else
      let ()  = y_tinfo_pp "3" in
      formula_of_heap_fl f fl pos
  | Star ({h_formula_star_h1 = f1;
           h_formula_star_h2 = f2}) ->
    let uf1 = unfold_heap_x prog f1 aset v fl uf ~lem_unfold:lem_unfold pos in
    let uf2 = unfold_heap_x prog f2 aset v fl uf ~lem_unfold:lem_unfold pos in
    normalize_combine_star uf1 uf2 pos
  | StarMinus ({h_formula_starminus_h1 = f1;
                h_formula_starminus_aliasing = al;
                h_formula_starminus_h2 = f2}) -> formula_of_heap_fl f fl pos
  | Conj ({h_formula_conj_h1 = f1;
           h_formula_conj_h2 = f2}) ->
    let uf1 = unfold_heap_x prog f1 aset v fl uf ~lem_unfold:lem_unfold pos in
    let uf2 = unfold_heap_x prog f2 aset v fl uf ~lem_unfold:lem_unfold pos in
    normalize_combine_conj uf1 uf2 pos
  | ConjConj ({h_formula_conjconj_h1 = f1;
               h_formula_conjconj_h2 = f2}) ->
    let uf1 = unfold_heap_x prog f1 aset v fl uf ~lem_unfold:lem_unfold pos in
    let uf2 = unfold_heap_x prog f2 aset v fl uf ~lem_unfold:lem_unfold pos in
    normalize_combine_conjconj uf1 uf2 pos
  | ConjStar ({h_formula_conjstar_h1 = f1;
               h_formula_conjstar_h2 = f2}) ->
    let uf1 = unfold_heap_x prog f1 aset v fl uf ~lem_unfold:lem_unfold pos in
    let uf2 = unfold_heap_x prog f2 aset v fl uf ~lem_unfold:lem_unfold pos in
    normalize_combine_conjstar uf1 uf2 pos
  | Phase ({h_formula_phase_rd = f1;
            h_formula_phase_rw = f2}) ->
    let uf1 = unfold_heap_x prog f1 aset v fl uf ~lem_unfold:lem_unfold pos in
    let uf2 = unfold_heap_x prog f2 aset v fl uf ~lem_unfold:lem_unfold pos in
    normalize_combine_phase uf1 uf2 pos
  | HRel _ ->
    if lem_unfold then
      try
        let () = x_nodo "Unfold HRel" in
        let cprog = fst prog in
        let hr_root, hr_args = CFU.get_node_var_args cprog f in
        let unfold_f = CFU.unfold_formula_of_hrel cprog hr_root hr_args in
        let () = y_tinfo_hp (add_str "f" !CF.print_h_formula) f in
        let () = y_tinfo_hp (add_str "unfold_f" !CF.print_formula) unfold_f in
        unfold_f
      with _ -> formula_of_heap_fl f fl pos
    else formula_of_heap_fl f fl pos
  | _ -> formula_of_heap_fl f fl pos

and unfold_for_abs_merge prog pos =
  let unfold_fun fl qvars vp p a h v uf  =
    unfold_baref (prog, None) h p vp a fl v pos qvars false uf in
  unfold_fun

(*
  vvars: variables of interest
  evars: those involving this will be on the rhs
  otherwise move to the lhs
*)
and split_universal_x (f0 : CP.formula) (evars : CP.spec_var list)
    (expl_inst_vars : CP.spec_var list)(impl_inst_vars : CP.spec_var list)
    (vvars : CP.spec_var list) (pos : loc)
  = let (a,x,y)=split_universal_a f0 evars expl_inst_vars impl_inst_vars vvars pos in
  (elim_exists_pure_formula a,x,y)

and split_universal (f0 : CP.formula) (evars : CP.spec_var list)
    (expl_inst_vars : CP.spec_var list)(impl_inst_vars : CP.spec_var list)
    (vvars : CP.spec_var list) (pos : loc) =
  let vv = evars (*impl_inst_vars*) in
  Debug.no_2 "split_universal"
    (fun f->Cprinter.string_of_pure_formula f)
    (fun _ ->
       (Cprinter.string_of_spec_var_list evars)^
       "/Impl="^(Cprinter.string_of_spec_var_list impl_inst_vars)^
       "/Expl="^(Cprinter.string_of_spec_var_list expl_inst_vars)^
       "/view vars:"^ (Cprinter.string_of_spec_var_list vvars))
    (fun (f1,f2,evars) ->
       ("to_ante =" ^ Cprinter.string_of_pure_formula f1)^"/ "^
       "to_conseq = " ^ (Cprinter.string_of_pure_formula f2) ^
       "/ evars: "^ (Cprinter.string_of_spec_var_list evars))
    (fun f vv -> split_universal_x f0 evars expl_inst_vars impl_inst_vars vvars pos)
    f0 vv
      (*
        vvars: variables of interest
        evars: those involving this will be on the rhs
        otherwise move to the lhs
      *)

and split_universal_a (f0 : CP.formula) (evars : CP.spec_var list)
    (expl_inst_vars : CP.spec_var list) (impl_inst_vars : CP.spec_var list)
    (vvars : CP.spec_var list) (pos : loc) : (CP.formula  * CP.formula * (CP.spec_var list)) =
  let rec split f = match f with
    | CP.And (f1, f2, _) ->
      let app1, cpp1 = split f1 in
      let app2, cpp2 = split f2 in
      (CP.mkAnd app1 app2 pos, CP.mkAnd cpp1 cpp2 pos)
    | CP.AndList b -> let l1,l2 = List.split (List.map (fun (l,c)-> let l1,l2 =
    split c in ((l,l1),(l,l2))) b) in (CP.mkAndList l1, CP.mkAndList l2)
    | _ ->
      let fvars = CP.fv f in
      if CP.disjoint fvars vvars then
        (CP.mkTrue pos, CP.mkTrue pos)
        (* just ignore the formula in this case as
           it is disjoint from the set of variables of interest *)
      else
            (*
              - 23.05.2008 -
              Current actions are:
              (i) discard E2(g) which has already been proven
              (ii) move E1(f.g) to LHS for implicit instantiation
              (iii) leave E3(e,f,g) to RHS for linking existential var e

              What we added here: -->Step (iii) can be also improved by
            additionally moving (exists e : E3(e,f,g)) to the LHS.
            *)
      if not (CP.disjoint (evars@expl_inst_vars@impl_inst_vars) fvars) then (* to conseq *)
        (CP.mkTrue pos, f)
      else (* to ante *)
        (f, CP.mkTrue pos)
  in
  (* -- added on 21.05.2008 *)
  (* try to obtain as much as a CNF form as possible so that the splitting of
            bindings between antecedent and consequent is more accurate *)
  let f = (normalize_to_CNF f0 pos) in
  let to_ante, to_conseq = split f in
  x_dinfo_zp (lazy ("split_universal: to_ante(after split): "
                    ^ (Cprinter.string_of_pure_formula to_ante))) pos;
  let to_ante = CP.find_rel_constraints to_ante vvars in
  x_dinfo_zp (lazy ("split_universal: to_ante(find_rel_constraint): "
                    ^ (Cprinter.string_of_pure_formula to_ante))) pos;
  let conseq_fv = CP.fv to_conseq in
  (*TO CHECK: should include impl_inst_vars or not*)
  let instantiate = List.filter (fun v -> List.mem v (evars@expl_inst_vars(*@impl_inst_vars*))) conseq_fv in
  let wrapped_to_conseq = CP.mkExists instantiate to_conseq None pos in
  let to_ante =
    if CP.fv wrapped_to_conseq <> [] then CP.mkAnd to_ante wrapped_to_conseq no_pos else to_ante
  in
  x_dinfo_zp (lazy ("split_universal: to_ante(aft wrap): "^ (Cprinter.string_of_pure_formula to_ante))) pos;

  (*TODO: wrap implicit vars for to_ante
    (i) find FV=free vars of to_ante; (ii) select ctrs connected to FV (iii) remove redundant exists vars
  *)

  x_dinfo_zp (lazy ("split_universal: evars: "
                    ^ (String.concat ", " (List.map Cprinter.string_of_spec_var
                                             evars)))) pos;
  x_dinfo_zp (lazy ("split_universal: expl_inst_vars: "
                    ^ (String.concat ", "(List.map Cprinter.string_of_spec_var
                                            expl_inst_vars)))) pos;
  x_dinfo_zp (lazy ("split_universal: vvars: "
                    ^ (String.concat ", "(List.map Cprinter.string_of_spec_var
                                            vvars)))) pos;
  x_dinfo_zp (lazy ("split_universal: to_ante: "^ (Cprinter.string_of_pure_formula to_ante))) pos;
  x_dinfo_zp (lazy ("split_universal: to_conseq: "
                    ^ (Cprinter.string_of_pure_formula to_conseq))) pos;
  let fvars = CP.fv f in

  (* 27.05.2008 *)
  if !Globals.move_exist_to_LHS
  && (not(Gen.is_empty (Gen.BList.difference_eq CP.eq_spec_var fvars evars))
      && not(Gen.is_empty evars)) then
    (* there still are free vars whose bondings were not moved to the LHS --> existentially quantify the whole formula and move it to the LHS *)
    (* Ex.:  ex e. f1<e & e<=g or ex e. (f=1 & e=2 \/ f=2 & e=3) *)
    (* Branches not handled here yet *)
    let new_f = discard_uninteresting_constraint f vvars in
    (CP.mkAnd to_ante (CP.mkExists evars new_f None pos) pos, to_conseq, evars)
  else (to_ante, to_conseq, evars)


(**************************************************************)
(*
  We do a simplified translation towards CNF where we only take out the common
  conjuncts from all the disjuncts:

  Ex:
  (a=1 & b=1) \/ (a=2 & b=2) - nothing common between the two disjuncts
  (a=1 & b=1 & c=3) \/ (a=2 & b=2 & c=3) ->  c=3 & ((a=1 & b=1) \/ (a=2 & b=2))
*)

(*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*)
(*17.04.2009*)

and memo_normalize_to_CNF_n1 (f: memo_pure) pos : memo_pure =
  List.map (fun c-> {c with memo_group_slice
                            = List.map (fun c-> normalize_to_CNF_new c pos)
                                c.memo_group_slice}) f

and memo_normalize_to_CNF_new (f:MCP.mix_formula) pos : MCP.mix_formula = match f with
  | MCP.MemoF f-> MCP.MemoF (memo_normalize_to_CNF_n1 f pos)
  | MCP.OnePF f -> MCP.OnePF (normalize_to_CNF_new f pos)

and normalize_to_CNF_new (f : CP.formula) pos : CP.formula =
  let disj_list = (CP.list_of_disjs) f in
  let dc_list = List.map CP.list_of_conjs disj_list in
  match dc_list with
  | conj_list :: rest ->
    let first_disj, res_conj, res_disj_list = (filter_common_conj conj_list rest pos) in
    let res_disj = List.map (fun c -> (CP.conj_of_list c pos)) res_disj_list in
    (CP.mkAnd (CP.conj_of_list res_conj pos)
       (CP.mkOr (CP.conj_of_list first_disj pos) (CP.disj_of_list res_disj pos)
          None pos) pos)
  | [] -> (print_string("[solver.ml, normalize_to_CNF]: should not be here!!"); (CP.mkTrue pos))

and filter_common_conj (conj_list : CP.formula list)
    (dc_list : (CP.formula list) list) pos
  : (CP.formula list *  CP.formula list * (CP.formula list
  list)) =
  match conj_list with
  | h :: rest ->
    let b, new_dc_list = remove_conj_list dc_list h pos in
    if b then
      let first_disj, conj, new_dc_list2 = filter_common_conj rest new_dc_list pos in
      (first_disj, h::conj, new_dc_list2)
    else
      let first_disj, conj, new_dc_list2 = filter_common_conj rest dc_list pos in
      (h::first_disj, conj, new_dc_list2)
  | [] -> ([], [], dc_list)

and remove_conj_list (f : (CP.formula list) list) (conj : CP.formula) pos :
  (bool * (CP.formula list list)) = match f with
  | h :: rest ->
    let b1, l1 = remove_conj_new h conj pos in
    let b2, l2 = remove_conj_list rest conj pos in
    (b1 && b2, l1::l2)
  | [] -> (true, [])

and remove_conj_new (f : CP.formula list) (conj : CP.formula) pos :
  (bool * CP.formula list) =
  match f with
  | h :: rest ->
    if (CP.eq_pure_formula h conj) then (true, rest)
    else
      let b1, l1 = remove_conj_new rest conj pos in (b1, h::l1)
  | [] -> (false, [])

(*17.04.2009*)
(*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*)

and normalize_to_CNF (f : CP.formula) pos : CP.formula =
  let pr = Cprinter.string_of_pure_formula in
  Debug.no_1 "normalize_to_CNF"
    pr pr (fun _ -> normalize_to_CNF_x f pos) f

and normalize_to_CNF_x (f : CP.formula) pos : CP.formula = match f with
  | CP.Or (f1, f2, lbl, p) ->
    let conj, disj1, disj2 = (find_common_conjs f1 f2 p) in
    (CP.mkAnd conj (CP.mkOr disj1 disj2 lbl p) p)
  | CP.And (f1, f2, p) -> CP.mkAnd (normalize_to_CNF_x f1 p) (normalize_to_CNF_x f2 p) p
  | CP.Not (f1, lbl, p) -> CP.Not(normalize_to_CNF_x f1 p, lbl ,p)
  | CP.Forall (sp, f1, lbl, p) -> CP.Forall(sp, normalize_to_CNF_x f1 p, lbl ,p)
  | CP.Exists (sp, f1, lbl, p) -> CP.mkExists [sp] (normalize_to_CNF_x f1 p)  lbl p
  | CP.AndList b-> CP.AndList (map_l_snd (fun c-> normalize_to_CNF_x c no_pos) b)
  | _ -> f

(* take two formulas f1 and f2 and returns:
   - the formula containing the commom conjuncts
   - the formula representing what's left of f1
   - the formula representing what's left of f2
*)

and find_common_conjs (f1 : CP.formula) (f2 : CP.formula) pos :
  (CP.formula * CP.formula * CP.formula) =
  match f1 with
  | CP.BForm(b,_) ->
    if (List.exists (fun c -> (CP.eq_pure_formula c f1)) (CP.list_of_conjs f2)) then
      begin
        (f1, (CP.mkTrue pos), (remove_conj f2 f1 pos))
      end
    else
      ((CP.mkTrue pos), f1, f2)
  | CP.And(f11, f12, p) ->
    let outer_conj, new_f1, new_f2 = (find_common_conjs f11 f2 p) in
    let outer_conj_prim, new_f1_prim, new_f2_prim  = (find_common_conjs f12 new_f2 p) in
    ((CP.mkAnd outer_conj outer_conj_prim p), (CP.mkAnd new_f1 new_f1_prim p), new_f2_prim)
  | CP.Or(f11, f12, lbl ,p) ->
    let new_f11 = (normalize_to_CNF_x f11 p) in
    let new_f12 = (normalize_to_CNF_x f12 p) in
    (CP.mkTrue pos),(CP.mkOr new_f11 new_f12 lbl p),f2
  | _ -> ((CP.mkTrue pos), f1, f2)

and remove_conj (f : CP.formula) (conj : CP.formula) pos : CP.formula = match f with
  | CP.BForm(b1,_) ->
    begin
      match conj with
      |CP.BForm(b2,_) ->
        if (CP.eq_b_formula_no_aset b1 b2) then
          (CP.mkTrue pos)
        else f
      | _ -> f
    end
  | CP.And(f1, f2, p) -> (CP.mkAnd (remove_conj f1 conj p) (remove_conj f2 conj p) p)
  | CP.AndList b -> CP.AndList (map_l_snd (fun c-> remove_conj c conj no_pos) b)
  | CP.Not(f1, lbl, p) -> CP.Not((remove_conj f1 conj p), lbl, p)
  | _ -> f

(**************************************************************)
(**************************************************************)
(**************************************************************)

(* 21.05.2008 *)
(*
  Say we have three kinds of vars
  f - free, g - global (from the view definition), e - existential
  Assume, we have expression at the end of folding:
  E1(f,g) & E2(g) & E3(e,f,g)

  First action is to discard E2(g) which has already been proven

  (discard_uninteresting_constraint f vvars) only maintains those vars containing vvars, which are vars of interest
*)

and contra_wrapper f rhs_p =
  let rs0, fold_prf =
    (*Loc: why smart_lem_search?? append_sll_cll_slk-15.smt2.slk from must failure to may failure?? *)
    (* TODO:WN need to to capture for exception *)
    if (true || !Globals.smart_lem_search) then
      let () = rhs_pure_stk # push_list [rhs_p] in
      let rs0, fold_prf = f None in
      let () = rhs_pure_stk # pop in
      (rs0, fold_prf)
    else f None in
  (rs0, fold_prf)

(*LDK: add rhs_p*)
and fold_op_init ?(root_inst=None) p c vd v (rhs_p: MCP.mix_formula) u loc =
  Gen.Profiling.no_2 "fold" (fold_op_x  ~root_inst:root_inst p c vd v rhs_p) u loc

and fold_op_x ?(root_inst=None) prog (ctx : context) (view : h_formula)
    vd (rhs_p: MCP.mix_formula) (use_case:CP.formula option) (pos : loc)
  : (list_context * proof) =
  let pr (x,_) = Cprinter.string_of_list_context x in
  let id x = x in
  let ans = ((* ("use-case : "^string_of_bool use_case) *)
    (* ^ *)"\n ** context:"^(Cprinter.string_of_context ctx)
           ^"\n ** rhs view:"^(Cprinter.string_of_h_formula view)
           ^"\n ** rhs view annot:"^(Cprinter.string_of_annot_arg_list
                                       (CF.get_node_annot_args view))
           ^"\n ** rhs_pure:"^(Cprinter.string_of_mix_formula rhs_p)) in
  let pr2 x = match x with
    | None -> "None"
    | Some (f) -> Cprinter.string_of_struc_formula f.view_formula in
  Debug.no_2 "fold_op_1"
    (add_str "vdef" pr2) id pr
    (fun _ _ -> fold_op_x1 ~root_inst:root_inst prog (ctx : context)
        (view : h_formula) vd rhs_p (use_case:CP.formula option) (pos : loc)) vd
    ans


and fold_op_x1 ?(root_inst=None) prog (ctx : context) (view : h_formula) vd
    (rhs_p : MCP.mix_formula) (use_case:CP.formula option) (pos : loc)
  : (list_context * proof) =
  match view with
  | ViewNode ({ h_formula_view_node = p;
                h_formula_view_name = c;
                h_formula_view_imm = imm;
                h_formula_view_label = pid;
                h_formula_view_remaining_branches = r_brs;
                h_formula_view_perm = perm;
                h_formula_view_arguments = vs;
                h_formula_view_annot_arg = anns
              }) -> (
      try (
        let vdef = match vd with
          | None -> (
              (* in full_fold, vd = None *)
              try look_up_view_def_raw x_loc prog.Cast.prog_view_decls c
              with Not_found -> report_error no_pos ("fold: view def not found:"^c^"\n")
            )
          | Some vd -> vd in
        (* is there a benefit for using case-construct during folding? *)
        let root_inst2 = vdef.Cast.view_actual_root in
        let brs = filter_branches r_brs vdef.Cast.view_formula in
        (* let form = if use_case then brs else Cformula.case_to_disjunct brs in*)
        let form = if use_case==None then Cformula.case_to_disjunct brs else brs in
        (*let form = x_add_1 Cformula.case_to_disjunct brs in *)
        let () = y_tinfo_hp (add_str "actual_root"
                               (pr_option (pr_pair !CP.print_sv !
                                             CP.print_formula))) root_inst2 in
        (* let () = y_tinfo_hp (add_str "root_inst" (pr_option !CP.print_sv )) root_inst in *)
        let () = y_tinfo_hp (add_str "do_fold: form" Cprinter.string_of_struc_formula) form in
        let stk = new Gen.stack in
        let renamed_view_formula = rename_struc_bound_vars ~stk:(Some stk) form in
        let sst = stk # get_stk in
        let new_inst = match root_inst2 with
          | None -> None
          | Some((p,_)) ->
            begin
              match root_inst with
              | None -> None
              | Some(xxx) ->
                try
                  let np = snd(List.find (fun (v1,_) -> CP.eq_spec_var p v1) sst) in
                  Some (np,xxx)
                with _ -> None
            end in
        let () = y_dinfo_hp (add_str "new_inst" (pr_option (pr_pair !CP.print_sv
                                                              pr_sv))) new_inst
        in
        let () = y_tinfo_hp (add_str "sst" (pr_list (pr_pair !CP.print_sv !CP.print_sv ))) sst in
        let () = y_tinfo_hp (add_str "do_fold: renamed_view_formula"
                               Cprinter.string_of_struc_formula)
            renamed_view_formula in
        let renamed_view_formula =
          if (Perm.allow_perm ()) then (
            match perm with
            | None -> renamed_view_formula
            | Some f -> Cformula.propagate_perm_struc_formula renamed_view_formula (Cpure.get_var f)
          )
          else renamed_view_formula
        in
        let () = Debug.ninfo_hprint (add_str "do_fold: renamed_view_formula 2"
                                       Cprinter.string_of_struc_formula)
            renamed_view_formula no_pos in
        let fr_vars = (CP.SpecVar (Named vdef.Cast.view_data_name, self,
                                   Unprimed)) :: vdef.view_vars in
        let to_vars = p :: vs in
        (* adding actual root parameter inst *)
        let (fr_vars,to_vars) = match new_inst with
          | None -> (fr_vars,to_vars)
          | Some(f,t) -> (f::fr_vars,t::to_vars) in
        let () = y_tinfo_hp (add_str "fr_vars" !CP.print_svl) fr_vars in
        let () = y_tinfo_hp (add_str "to_vars" !CP.print_svl) to_vars in
        let view_form = subst_struc_avoid_capture fr_vars to_vars renamed_view_formula in
        let () = y_tinfo_hp (add_str "do_fold: view_form 2"
                               Cprinter.string_of_struc_formula) view_form  in
        let anns = List.map fst anns in
        let fr_ann = List.map fst vdef.view_ann_params in
        let to_ann = anns in
        (*ENHANCE universal lemmas:
          propagate constraint on univ_vars into view_form*)
        let uni_vars = vdef.view_uni_vars in
        let new_uni_vars = CP.subst_var_list_avoid_capture fr_vars to_vars uni_vars in
        let to_fold_view = MCP.find_rel_constraints rhs_p new_uni_vars in
        x_tinfo_zp (lazy ("new_univ_vars" ^ (!CP.print_svl new_uni_vars))) pos;
        x_tinfo_zp (lazy ("to_fold_view" ^ (Cprinter.string_of_mix_formula to_fold_view))) pos;
        let view_form =
          if not(!Globals.old_univ_vars) then view_form
          else add_mix_formula_to_struc_formula to_fold_view view_form in
        (*propagate*)
        let view_form =
          if (Perm.allow_perm ()) then (
            match perm with
            | None -> view_form
            | Some permvar ->
              let to_fold_view = MCP.find_rel_constraints rhs_p [(Cpure.get_var permvar)] in
              add_mix_formula_to_struc_formula to_fold_view view_form
          )
          else view_form
        in
        let view_form_new =
          let pure_related_to_folded_pred = MCP.find_rel_constraints rhs_p vs in
          add_mix_formula_to_struc_formula pure_related_to_folded_pred view_form
        in
        let view_form = if !Globals.adhoc_flag_6 then view_form_new else view_form in
        (* adding _new caused loop *)
        x_tinfo_zp (lazy ("view_form(b4 push_case):"
                          ^ (Cprinter.string_of_struc_formula view_form))) pos;
        x_tinfo_zp (lazy ("view_form_new:" ^ (Cprinter.string_of_struc_formula view_form_new))) pos;
        let view_form = add_struc_origins (get_view_origins view) view_form  in
        let view_form = CF.replace_struc_formula_label pid view_form in
        x_tinfo_zp (lazy ("view_form(b4 push_case):"
                          ^ (Cprinter.string_of_struc_formula view_form))) pos;
        let view_form = match use_case with
          | None -> view_form
          | Some f -> push_case_f f view_form in
        x_tinfo_zp (lazy ("view_form(b4 prog_imm): "
                          ^ (Cprinter.string_of_struc_formula view_form))) pos;
        let view_form =
          try
            let mpa = List.combine fr_ann to_ann in
            let sf = Immutable.propagate_imm view_form c imm mpa in
            sf
          with _ -> view_form
        in
        x_dinfo_zp (lazy ("do_fold: anns:" ^ (Cprinter.string_of_annot_arg_list anns))) pos;
        x_dinfo_zp (lazy ("do_fold: LHS ctx:" ^ (Cprinter.string_of_context_short ctx))) pos;
        x_dinfo_zp (lazy ("do_fold: RHS view: " ^ (Cprinter.string_of_h_formula view))) pos;
        x_tinfo_zp (lazy ("do_fold: view_form: "
                          ^ (Cprinter.string_of_struc_formula view_form))) pos;
        let estate = estate_of_context ctx pos in
        (*LDK: propagate es_vars from the estate to FOLD context
          to avoid proving es_vars as universal vars when finishing FOLDING*)
        (*Because we propagate some pure constrains into view formula
          when FOLDING. we also have to propagate es_vars from the
          estate into FOLDING context to avoid. Is it SOUND? Indeed,
          we need to propagate es_vars whose constraints are propagated
          into view formula when FOLDING.*)
        (*TO CHECK: does the below give new information instead of the above*)
        (*LDK: IMPORTANT
          if frac var is an existential variable, transfer it into folded view*)
        (*add fracvar into list of parameters*)
        let vs =
          if (Perm.allow_perm ()) then
            match perm with
            | None -> vs
            | Some f -> (Cpure.get_var f)::vs
          else vs
        in
        let new_es_evars = vs in
        let new_es = {estate with
                      es_evars
                      = Gen.BList.remove_dups_eq (=) (new_es_evars @ estate.es_evars);
                     } in
        let () = Debug.tinfo_hprint (add_str "fold_op: estate"
                                       Cprinter.string_of_entail_state) estate
            no_pos in
        let () = Debug.tinfo_hprint (add_str "fold_op: new_es"
                                       Cprinter.string_of_entail_state) new_es
            no_pos in
        let new_ctx = Ctx new_es in
        let () = Debug.tinfo_hprint (add_str "do_fold: view_form 4"
                                       Cprinter.string_of_struc_formula)
            view_form no_pos in
        (* andreeac - to add the pure of rhs which shall be used for contra
           detection inside the fold *)
        let new_ctx =
          CF.set_context (fun es ->
              let rhs_p = MCP.pure_of_mix rhs_p in
              {es with es_rhs_pure = Gen.map_opt_def
                           (if(CP.is_True rhs_p || CP.is_False rhs_p ) then None else Some rhs_p)
                           (fun x -> Some (CP.join_conjunctions [rhs_p;x]))
                           es.es_rhs_pure   }
            ) new_ctx in
        let () = x_tinfo_hp (add_str "fold_op, rhs_p" !MCP.print_mix_formula) rhs_p no_pos in
        let () = x_tinfo_hp (add_str "new_ctx" Cprinter.string_of_context) new_ctx no_pos in
        let heap_enatil = heap_entail_one_context_struc_nth 99 prog true false
            new_ctx view_form None None None pos in
        let rs0, fold_prf = contra_wrapper heap_enatil rhs_p in

        let rels = Infer.collect_rel_list_context rs0 in
        if rels!=[] && !Globals.old_infer_collect then
          begin
            let () = x_winfo_hp (add_str "RelInferred (simplified/solver.ml)"
                                   (pr_list Cprinter.string_of_lhs_rhs)) rels
                no_pos in
            let () = Infer.infer_rel_stk # push_list_pr x_loc rels in
            let () = Log.current_infer_rel_stk # push_list rels in
            ()
          end;
        let tmp_vars = p :: (estate.es_evars @ vs) in
        (**************************************)
        (*        process_one                 *)
        (**************************************)
        let rec process_one_x (ss:CF.steps) rs1  = (
          x_tinfo_zp (lazy ("fold: process_one: rs1:\n"^ (Cprinter.string_of_context rs1))) pos;
          match rs1 with
          | OCtx (c1, c2) ->
                          (*
                            It is no longer safe to assume that rs will be conjunctive.
                            The recursive folding entailment call (via case splitting
                            for example) can turn ctx to a disjunctive one, hence making
                            rs disjunctive.
                          *)
            let tmp1 = process_one_x (CF.add_to_steps ss "left OR 3 on ante") c1 in
            let tmp2 = process_one_x (CF.add_to_steps ss "right OR 3 on ante") c2 in
            let tmp3 = (mkOCtx tmp1 tmp2 pos) in
            tmp3
          | Ctx es ->
            let () = x_tinfo_zp (lazy ("begin es.es_pure: "
                                       ^(Cprinter.string_of_mix_formula
                                           es.es_pure))) pos in
            let es = CF.overwrite_estate_with_steps es ss in
            let w = Gen.BList.difference_eq CP.eq_spec_var  es.es_evars tmp_vars in
            let mix_f = elim_exists_pure w es.es_pure true pos in
            (*LDK: remove duplicated conjuncts in the estate,
              which are generated because one perm var can be folded
              into many perm vars in many heap nodes. These generated
              permvars might create many duplicated constraints*)
            let old_mix_f = mix_f in
            let mix_f = CF.remove_dupl_conj_eq_mix_formula mix_f in
            let res_rs = Ctx {es with
                              es_evars = estate.es_evars;
                              es_pure = mix_f;
                              es_prior_steps = (ss @ es.es_prior_steps);
                             } in
            x_dinfo_zp (lazy ("fold: context at beginning of fold: "
                              ^ (Cprinter.string_of_spec_var p) ^ "\n"
                              ^ (Cprinter.string_of_context ctx))) pos;
            x_dinfo_zp (lazy ("fold: context at end of fold: "
                              ^ (Cprinter.string_of_spec_var p) ^ "\n"
                              ^ (Cprinter.string_of_context res_rs))) pos;
            x_tinfo_zp (lazy ("fold: es.es_pure: "
                              ^(Cprinter.string_of_mix_formula es.es_pure))) pos;
            res_rs
        ) in
        let process_one (ss:CF.steps) fold_rs1 = (
          let pr = Cprinter.string_of_context  in
          Debug.no_1 "fold_op_process_one" pr pr (fun _ ->
              process_one_x (ss:CF. steps) fold_rs1) fold_rs1
        ) in
        let res = match rs0 with
          | FailCtx _ -> rs0
          | SuccCtx l -> SuccCtx (List.map (process_one []) l) in
        (res, fold_prf)
      ) with e -> raise e
    )
  | _ ->
    x_dinfo_zp (lazy ("fold: second parameter is not a view: "
                      ^ (Cprinter.string_of_h_formula view))) pos;
    report_error no_pos ("fold: second parameter is not a view\n")

and process_fold_result ivars_p prog is_folding estate (fold_rs0:list_context)
    p2 vs2 base2 pos
  : (list_context * proof list) =
  let pr_es = Cprinter.string_of_entail_state in
  let pr1 = Cprinter.string_of_list_context in
  let pro x = pr1 (fst x) in
  let pr2 = pr_list Cprinter.string_of_spec_var in
  let pr3 x = Cprinter.string_of_formula (CF.Base x) in
  Debug.no_4 "process_fold_result" pr_es pr1 pr2 pr3 pro
    (fun _ _ _ _->

       process_fold_result_x ivars_p prog is_folding estate (fold_rs0:list_context)
         p2 vs2 base2 pos
    ) estate fold_rs0 (p2::vs2) base2

and process_fold_result_x (ivars,ivars_rel) prog is_folding estate
    (fold_rs0:list_context) p2 vs2 base2 pos
  : (list_context * proof list) =
  let pure2 = base2.formula_base_pure in
  let vp2 = base2.formula_base_vperm in
  let resth2 = base2.formula_base_heap in
  let type2 = base2.formula_base_type in
  let flow2 = base2.formula_base_flow in
  let a2 = base2.formula_base_and in
  let rec process_one_x (ss:CF.steps) fold_rs1 = match fold_rs1 with
    | OCtx (c1, c2) ->
      let tmp1, prf1 = process_one_x (add_to_steps ss "left OR 4 in ante") c1 in
      let tmp2, prf2 = process_one_x  (add_to_steps ss "right OR 4 in ante") c2 in
      let tmp3 = or_list_context tmp1 tmp2 in
      let prf3 = Prooftracer.mkOrLeft fold_rs1 (Base base2) [prf1; prf2] in
      (tmp3, prf3)
    | Ctx fold_es ->
      let fold_es = CF.overwrite_estate_with_steps fold_es ss in
      let e_pure = MCP.fold_mem_lst (CP.mkTrue pos) true true fold_es.es_pure in
      let to_ante, to_conseq, new_evars =
        split_universal e_pure fold_es.es_evars fold_es.es_gen_expl_vars
          fold_es.es_gen_impl_vars vs2 pos in
      let tmp_conseq = mkBase resth2 pure2 vp2 type2 flow2 a2 pos in
      let () = Debug.ninfo_hprint (add_str "tmp_conseq"
                                     (Cprinter.string_of_formula)) tmp_conseq
          pos in
      let new_conseq = normalize 6 tmp_conseq (formula_of_pure_N to_conseq pos) pos in
      let () = Debug.ninfo_hprint (add_str "new_conseq"
                                     (Cprinter.string_of_formula)) new_conseq
          pos in
      let new_ante = normalize 7 fold_es.es_formula (formula_of_pure_N to_ante pos) pos in
      let new_ante = filter_formula_memo new_ante false in
      let new_consumed = fold_es.es_heap in
      let impl_vars = Gen.BList.intersect_eq CP.eq_spec_var vs2 (CP.fv to_ante) in
      let new_impl_vars = Gen.BList.difference_eq CP.eq_spec_var
          estate.es_gen_impl_vars impl_vars in
      (* TODO : change estate to fold_es *)
      let new_es = {(* fold_es *) estate with
                                 es_heap = new_consumed;
                                 es_formula = new_ante;
                                 es_evars = new_evars;
                                 es_unsat_flag =false;
                                 es_gen_impl_vars = new_impl_vars;
                                 es_trace = fold_es.es_trace;
                                 es_orig_ante = fold_es.es_orig_ante;
                                 es_infer_vars = fold_es.es_infer_vars;
                                 es_infer_vars_rel = fold_es.es_infer_vars_rel;
                                 es_infer_vars_templ = fold_es.es_infer_vars_templ;
                                 es_infer_vars_hp_rel = fold_es.es_infer_vars_hp_rel;
                                 es_infer_vars_sel_hp_rel = fold_es.es_infer_vars_sel_hp_rel;
                                 es_infer_vars_sel_post_hp_rel = fold_es.es_infer_vars_sel_post_hp_rel;
                                 es_infer_hp_unk_map = fold_es.es_infer_hp_unk_map;
                                 es_infer_vars_dead = fold_es.es_infer_vars_dead;
                                 es_infer_heap = fold_es.es_infer_heap;
                                 es_infer_templ = fold_es.es_infer_templ;
                                 es_infer_templ_assume = fold_es.es_infer_templ_assume;
                                 es_infer_pure = fold_es.es_infer_pure;
                                 es_infer_pure_thus = fold_es.es_infer_pure_thus;
                                 es_infer_term_rel = fold_es.es_infer_term_rel;
                                 es_infer_rel = fold_es.es_infer_rel # clone;
                                 es_infer_hp_rel = fold_es.es_infer_hp_rel # clone;
                                 (* captures existential subst, see ptr1/ex6f1c6.slk *)
                                 es_subst = fold_es.es_subst;
                                 es_imm_last_phase = fold_es.es_imm_last_phase;
                                 es_group_lbl = fold_es.es_group_lbl;
                                 es_term_err = fold_es.es_term_err;
                                 es_conc_err = fold_es.es_conc_err;
                                 (* es_aux_conseq = CP.mkAnd estate.es_aux_conseq to_conseq pos *)} in
      let new_ctx = (Ctx new_es) in
      x_tinfo_zp (lazy ("process_fold_result: old_ctx before folding: "
                        ^ (Cprinter.string_of_spec_var p2) ^ "\n"
                        ^ (Cprinter.string_of_context (Ctx fold_es)))) pos;
      x_tinfo_zp (lazy ("process_fold_result: new_ctx after folding: "
                        ^ (Cprinter.string_of_spec_var p2) ^ "\n"
                        ^ (Cprinter.string_of_context new_ctx))) pos;
      x_tinfo_zp (lazy ("process_fold_result: vs2: "
                        ^ (String.concat ", "
                             (List.map Cprinter.string_of_spec_var vs2)))) pos;
      x_tinfo_zp (lazy ("process_fold_result: to_ante: "
                        ^ (Cprinter.string_of_pure_formula to_ante))) pos;
      x_tinfo_zp (lazy ("process_fold_result: to_conseq: "
                        ^ (Cprinter.string_of_pure_formula to_conseq))) pos;
      x_tinfo_zp (lazy ("process_fold_result: new_conseq:\n"
                        ^ (Cprinter.string_of_formula new_conseq))) pos;
      (* WN : we need to restore es_infer_vars here *)
      let new_ctx = Infer.restore_infer_vars_ctx ivars ivars_rel new_ctx in
      let rest_rs, prf = x_add heap_entail_one_context 1 prog is_folding new_ctx
          new_conseq None None None pos in
      x_dinfo_zp (lazy ("process_fold_result: context at end fold: "
                        ^ (Cprinter.string_of_spec_var p2) ^ "\n"
                        ^ (Cprinter.string_of_list_context rest_rs))) pos;
      let r = add_to_aux_conseq rest_rs to_conseq pos in
      (r, prf) in
  let process_one (ss:CF.steps) fold_rs1 =
    let pr1 = Cprinter.string_of_context(* _short *)  in
    let pr2 (c,_) = Cprinter.string_of_list_context(*_short*) c in
    Debug.no_1 "process_one" pr1 pr2 (fun _ -> process_one_x (ss:CF.steps) fold_rs1) fold_rs1 in
  match fold_rs0 with
  | FailCtx _ -> report_error no_pos ("process_fold_result: FailCtx encountered solver.ml\n")
  | SuccCtx fold_rs0 ->
    let t1,p1 = List.split (List.map (process_one []) fold_rs0) in
    let t1 = fold_context_left 1 t1 in
    (t1,p1)


and elim_exists_pure w f lump pos = elim_exists_mix_formula w f pos

and elim_exists_mix_formula w f pos =
  let pr = Cprinter.string_of_mix_formula in
  Debug.no_2 "elim_exists_mix_formula" pr !CP.print_svl pr
    (fun _ _ -> elim_exists_mix_formula_x w f pos) f w

and elim_exists_mix_formula_x w f pos = match f with
  | MCP.MemoF f -> MCP.MemoF (elim_exists_memo_pure w f pos)
  | MCP.OnePF f -> MCP.OnePF (elim_exists_pure_branch 1 w f pos)

and elim_exists_memo_pure_x (w : CP.spec_var list) (f0 : memo_pure) pos =
  let f_simp w f pos = Gen.Profiling.push_time "elim_exists";
    let f_s = elim_exists_pure_branch 2(*_debug*) w f pos in
    Gen.Profiling.pop_time "elim_exists"; f_s in
  MCP.memo_pure_push_exists_all (f_simp,true) w f0 pos

and elim_exists_memo_pure(* _debug *) w f0 pos =
  Debug.no_2 "elim_exists_memo_pure" Cprinter.string_of_spec_var_list
    Cprinter.string_of_memo_pure_formula Cprinter.string_of_memo_pure_formula
    (fun w f0 -> elim_exists_memo_pure_x w f0 pos) w f0


and elim_exists_ctx_list (ctx0 : list_context) =
  transform_list_context (entail_state_elim_exists, (fun c-> c)) ctx0

and elim_exists_partial_ctx_list (ctx0 : list_partial_context) =
  transform_list_partial_context (entail_state_elim_exists, (fun c-> c)) ctx0

and elim_exists_failesc_ctx_list_x (ctx0 : list_failesc_context) =
  transform_list_failesc_context (idf,idf,entail_state_elim_exists) ctx0

and elim_exists_failesc_ctx_list (ctx0 : list_failesc_context) =
  Gen.Profiling.do_1 "elim_exists_failesc_ctx_list"
    elim_exists_failesc_ctx_list_x ctx0

and elim_exists_ctx_x (ctx0:context) =
  if !Globals.elim_exists_ff then
    transform_context entail_state_elim_exists ctx0
  else ctx0

and elim_exists_ctx (ctx0:context) =
  Gen.Profiling.do_1 "elim_exists_ctx" elim_exists_ctx_x ctx0

(*used for finding the unsat in the original pred defs formulas*)
and find_unsat_x (prog : prog_decl) (f : formula):formula list*formula list =
  let sat_subno = ref 1 in
  match f with
  | Base {formula_base_label = lbl} | Exists {formula_exists_label = lbl} ->
    let () = Gen.reset_int2 () in
    let pf, _, m_set = x_add xpure 1 prog f in
    let m_set_f = List.fold_left (fun a (c1,c2)->
        CP.mkAnd a (CP.mkPtrNeqEqn c1 c2 no_pos) no_pos) (CP.mkTrue no_pos)
        (generate_disj_pairs_from_memf m_set) in
    let n_pf = MCP.memoise_add_pure_N pf m_set_f in
    let is_ok = TP.is_sat_mix_sub_no n_pf sat_subno true true in
    if is_ok then ([f],[]) else ([(mkFalseLbl (CF.mkTrueFlow ()) lbl no_pos)],[f])
  | Or ({formula_or_f1 = f1;
         formula_or_f2 = f2;
         formula_or_pos = pos}) ->
    let nf1,nf1n = find_unsat_x prog f1 in
    let nf2,nf2n = find_unsat_x prog f2 in
    (nf1@nf2,nf1n@nf2n)

and find_unsat prog f =
  let pr_f =  Cprinter.string_of_formula in
  let pr_l = pr_list pr_f in
  Debug.no_1 "find_unsat" pr_f (pr_pair pr_l pr_l) (find_unsat_x prog) f

and elim_ante_evars (es:entail_state) : context =
  let () = x_tinfo_hp (add_str "elim ante_evars"
                         Cprinter.string_of_spec_var_list) es.es_ante_evars
      no_pos in
  let () = x_tinfo_hp (add_str "elim gen_expl_vars"
                         Cprinter.string_of_spec_var_list) es.es_gen_expl_vars
      no_pos in
  let () = x_tinfo_hp (add_str "elim evars" Cprinter.string_of_spec_var_list) es.es_evars no_pos in
  if es.es_evars==[] then Ctx es
  else
    let f = push_exists es.es_evars es.es_formula in
    let ef = elim_exists f in
    Ctx {es with es_formula = ef } (*!! maybe unsound unless new clean cache id*)

and unsat_base_x prog (sat_subno:  int ref) f  : bool=
  let tp_call_wrapper npf =
    if !Globals.simpl_unfold2 then
      let r =
        let sat,npf = MCP.check_pointer_dis_sat npf in
        if  sat then
          let () = Debug.ninfo_hprint
              (add_str "npf a" Cprinter.string_of_mix_formula) npf no_pos in
          not (TP.is_sat_mix_sub_no npf sat_subno true true)
        else true in
      r
    else
      let () = Debug.ninfo_hprint (add_str "npf b" Cprinter.string_of_mix_formula) npf no_pos in
      not (TP.is_sat_mix_sub_no npf sat_subno true true)
  in
  (* TODO-EXPURE : need to invoke EPureI.UNSAT for --inv-baga *)
  let views = prog.Cast.prog_view_decls in
  let tp_syn_x h p =
    let () = x_tinfo_pp ("Omega unsat:start " ^ (string_of_int !Omega.omega_call_count) ^ " invocations") no_pos in
    let p1 = (Mcpure.pure_of_mix p) in
    let is_shape1 = List.for_all (CP.is_node_typ) (CP.fv p1) in
    let is_shape2 = is_shape_h_formula h in
    let t1 = Expure.build_ef_heap_formula is_shape2 h views in
    let t2 = Expure.build_ef_pure_formula ~shape:is_shape1 p1 in
    let d = Excore.EPureI.mk_star_disj t1 t2 in
    let res = (Excore.EPureI.is_false_disj (is_shape1 && is_shape2) d) in
    let () = x_tinfo_pp ("Omega unsat:end " ^ (string_of_int !Omega.omega_call_count) ^ " invocations") no_pos in
    res
  in
  let tp_syn h p =
    let pr1 = !print_h_formula in
    let pr2 = Cprinter.string_of_mix_formula in
    Debug.no_2 "Solver.tp_syn" pr1 pr2 string_of_bool
      (fun _ _ -> tp_syn_x h p) h p
  in
  let tp_sem fh fp =
    let () = x_tinfo_pp ("Omega unsat:start " ^ (string_of_int !Omega.omega_call_count) ^ " invocations") no_pos in
    let fp = MCP.translate_level_mix_formula fp in
    let fh, fp = Norm.imm_norm_h_formula prog fh fp unfold_for_abs_merge no_pos in
    let ph,_,_ = x_add xpure_heap 1 prog fh fp 1 in
    let npf = MCP.merge_mems fp ph true in
    let res = tp_call_wrapper npf in
    let () = x_tinfo_pp ("Omega unsat:end " ^ (string_of_int !Omega.omega_call_count) ^ " invocations") no_pos in
    res
  in
  (* TODOIMM : check if we have the segmented info for views at this point - if
  not, then it's not sound to merge here *)
  let f = Norm.imm_abs_norm_formula f prog (unfold_for_abs_merge prog (pos_of_formula f)) in
  match f with
  | Base ({ formula_base_heap = h;
            formula_base_pure = p;
            formula_base_pos = pos}) ->
    if !Globals.use_baga then tp_syn h p
    else tp_sem h p
  | Exists ({ formula_exists_qvars = qvars;
              formula_exists_heap = qh;
              formula_exists_pure = qp;
              formula_exists_pos = pos}) ->
    if !Globals.use_baga then tp_syn qh qp
    else tp_sem qh qp
  | Or _ -> report_error no_pos ("unsat_xpure : encountered a disjunctive formula \n")

(* type: Cast.prog_decl -> int ref -> CF.formula -> bool *)
and unsat_base_a prog (sat_subno:  int ref) f  : bool=
  let () = if !Globals.sleek_gen_sat then CF.sat_stk # push f else () in
  unsat_base_x prog sat_subno f

and unsat_base_nth (n:int) prog (sat_subno:  int ref) f  : bool =
  Debug.no_2_num n "unsat_base_nth"
    Cprinter.string_of_formula string_of_int string_of_bool
    (fun _ _ -> unsat_base_a prog sat_subno f) f n

and elim_unsat_es i (prog : prog_decl) (sat_subno:  int ref) (es : entail_state) : context =
  let pr1 = Cprinter.string_of_entail_state in
  let pr2 = Cprinter.string_of_context in
  Debug.no_1_num i "elim_unsat_es" pr1 pr2 (fun _ -> elim_unsat_es_x prog sat_subno es) es

and elim_unsat_es_x (prog : prog_decl) (sat_subno:  int ref) (es : entail_state) : context =
  if (es.es_unsat_flag) then Ctx es
  else elim_unsat_es_now 4 prog sat_subno es


and elim_unsat_ctx (prog : prog_decl) (sat_subno:  int ref) (ctx : context) : context =
  let rec helper c = match c with
    | Ctx es -> let exec ()= elim_unsat_es 1 prog sat_subno es
      in wrap_trace es.es_path_label exec ()
    | OCtx(c1,c2) -> OCtx(helper c1,helper c2)
  in helper ctx

and elim_unsat_es_now_new es =
  let r_int = ref 99 in
  elim_unsat_es_now_es (Cast.cprog_obj # get) r_int es

and elim_unsat_es_now i (prog : prog_decl) (sat_subno:  int ref) (es : entail_state) : context =
  let pr1 = Cprinter.string_of_entail_state_short in
  let pr2 = Cprinter.string_of_context_short in
  Debug.no_1_num i "elim_unsat_es_now" pr1 pr2 (fun _ -> elim_unsat_es_now_x prog sat_subno es) es

and elim_unsat_estate ?(sat_subno=vv_ref) prog es =
  let temp_f = if !Globals.unsat_consumed_heap then
      CF.mkStar_combine_heap es.es_formula es.es_heap CF.Flow_combine no_pos
    else es.es_formula
  in
  (* added consumed heap for unsat_now checking *)
  let () = Gen.reset_int2 () in
  let temp_f = if !Globals.sleek_gen_sat
    then Immutable.apply_subs es.CF.es_crt_holes temp_f else temp_f in
  let b = unsat_base_nth 1 prog sat_subno temp_f in
  let f = es.es_formula in
  x_tinfo_hp (add_str "es_formula" Cprinter.string_of_formula) f no_pos;
  (* Slicing: Set the flag memo_group_unsat to false *)
  let f = (* Wrapper.wrap_exception f *) x_add_1 CF.simplify_pure_f_old f in
  x_tinfo_hp (add_str "es_formula" Cprinter.string_of_formula) f no_pos;
  let f = reset_unsat_flag_formula f in
  x_tinfo_hp (add_str "es_formula(2)" Cprinter.string_of_formula) f no_pos;
  let es = { es with es_formula = f; es_unsat_flag = true } in
  (b,f,es)

and elim_unsat_es_now_es (prog : prog_decl) (sat_subno:  int ref) (es : entail_state) : entail_state =
  let (b,f,es) = elim_unsat_estate ~sat_subno:sat_subno prog es in
  if not b then es else
    false_es_with_orig_ante es f no_pos

and elim_unsat_es_now_x (prog : prog_decl) (sat_subno:  int ref) (es : entail_state) : context =
  Ctx (elim_unsat_es_now_es prog sat_subno es)

(*and elim_unsat_ctx_now i (prog : prog_decl) (sat_subno:  int ref) (ctx : context) : context =
  let rec helper c = match c with
  | Ctx es -> elim_unsat_es_now i prog sat_subno es
  | OCtx(c1,c2) -> OCtx(helper c1,helper c2)
  in helper ctx*)

and elim_unsat_for_unfold (prog : prog_decl) (f : formula) : formula =
  Debug.no_1 "elim_unsat_for_unfold" (Cprinter.string_of_formula) (Cprinter.string_of_formula)
    (fun f -> elim_unsat_for_unfold_x prog f) f

and elim_unsat_for_unfold_x (prog : prog_decl) (f : formula) : formula = match f with
  | Or _ -> elim_unsat_all prog f
  | _ -> f

and elim_unsat_all prog (f : formula): formula =
  Debug.no_1 "elim_unsat_all" (Cprinter.string_of_formula) (Cprinter.string_of_formula)
    (fun f -> elim_unsat_all_x prog f) f

and elim_unsat_all_x prog (f : formula): formula = match f with
  | Base _ | Exists _ ->
    let sat_subno = ref 1 in
    let () = Gen.reset_int2 () in
    (* (\*      print_endline (Cprinter.string_of_formula f);*\) *)
    (*   let pf, pfb = x_add xpure prog f in *)
    (*   let is_ok = *)
    (*   if pfb = [] then  *)
    (*   let f_lst = MCP.fold_mix_lst_to_lst pf false true true in *)
    (*   List.fold_left (fun a c-> if not a then a else TP.is_sat_sub_no c sat_subno) true f_lst  *)
    (*   else *)
    (*   let npf = MCP.fold_mem_lst (CP.mkTrue no_pos) false true pf in *)
    (*   List.fold_left (fun is_ok (label, pf1b) -> *)
    (*   if not is_ok then false  *)
    (*   else TP.is_sat_sub_no (CP.And (npf, pf1b, no_pos)) sat_subno ) true pfb in *)
    (*   TP.incr_sat_no (); *)
    (* (\*      if is_ok then print_endline "elim_unsat_all: true" else print_endline "elim_unsat_all: false";*\) *)
    let is_ok = unsat_base_nth 2 prog sat_subno f in
    if not is_ok then f else mkFalse (flow_formula_of_formula f) (pos_of_formula f)
  | Or ({ formula_or_f1 = f1;
          formula_or_f2 = f2;
          formula_or_pos = pos}) ->
    let nf1 = elim_unsat_all prog f1 in
    let nf2 = elim_unsat_all prog f2 in
    mkOr nf1 nf2 pos


and elim_unsat_all_debug prog (f : formula): formula =
  Debug.no_2 "elim_unsat " (fun c-> "?") (Cprinter.string_of_formula) (Cprinter.string_of_formula) elim_unsat_all prog f

and get_eqns_free (st : ((CP.spec_var * CP.spec_var) * LO.t) list) (evars : CP.spec_var list) (impl_inst : CP.spec_var list) fvars_rhs
    (expl_inst : CP.spec_var list) pos : CP.formula*CP.formula* (CP.spec_var * CP.spec_var) list =
  let pr_svl = Cprinter.string_of_spec_var_list in
  let pr_p =  Cprinter.string_of_pure_formula in
  let pr_st l  = pr_list (fun (c,_)-> pr_pair Cprinter.string_of_spec_var Cprinter.string_of_spec_var c) l in
  let pr_st2 l  = pr_list (pr_pair Cprinter.string_of_spec_var Cprinter.string_of_spec_var) l in
  let pr (lhs,rhs,s) = (pr_pair (add_str "to_lhs" pr_p) (add_str "to_rhs" pr_p) (lhs,rhs))^"subst:"^(pr_st2 s) in
  Debug.no_4 "get_eqns_free" pr_st (add_str "evars" pr_svl) (add_str "impl_inst" pr_svl)
    (add_str "expl_inst" pr_svl) pr (fun _ _ _ _ -> get_eqns_free_x st evars impl_inst fvars_rhs expl_inst pos) st evars impl_inst expl_inst

(* extracts those involve free vars from a set of equations  - here free means that it is not existential and it is not meant for explicit instantiation *)
(*NOTE: should (fr,t) be added for (CP.mem fr expl_inst)*)
and get_eqns_free_x (st : ((CP.spec_var * CP.spec_var) * LO.t) list) (evars : CP.spec_var list) (impl_inst : CP.spec_var list) fvars_rhs
    (expl_inst : CP.spec_var list) pos : CP.formula*CP.formula* (CP.spec_var * CP.spec_var) list =
  let rec aux st =
    match st with
    | ((fr, t), br_label) :: rest ->
      let (rest_left_eqns,rest_right_eqns,s_list) = aux rest in
      (* get_eqns_free_x rest evars impl_inst fvars_rhs expl_inst pos in *)
      if (CP.mem fr evars) (* || (CP.mem fr expl_inst) *)  (*TODO: should this be uncommented? || List.mem t evars *) then
        (rest_left_eqns,rest_right_eqns,(fr, t)::s_list)
      else
        let tmp = if (LO.is_unlabelled br_label)
          then CP.mkEqVar fr t pos
          else CP.mkAndList [(br_label,CP.mkEqVar fr t pos)] in
        let is_free = (CP.mem fr fvars_rhs) in (* from HRel *)
        (* WN: below cause a problem for ptr1/ex6e3f2.slk expl inst *)
        let is_expl = (CP.mem fr expl_inst) (* || not(is_free) *) in
        if (is_expl) then
          let () = y_tinfo_pp "expl branch" in
          let res = CP.mkAnd tmp rest_right_eqns pos in
          (rest_left_eqns,res,s_list)
        else
          let is_impl = (CP.mem fr impl_inst) || not(is_free) in
          if (is_impl) then
            let () = y_tinfo_pp "impl branch" in
            let res = CP.mkAnd tmp rest_left_eqns pos in
            (res,rest_right_eqns,s_list)
          else (* free *)
            let () = y_tinfo_pp "free branch?" in
            let () = if not(CP.mem fr expl_inst) then
                let msg = "free var to_conseq" in
                if !Globals.warn_fvars_rhs_match then
                  failwith msg
                else
                  y_winfo_hp (add_str msg !CP.print_sv) fr
            in
            let res = CP.mkAnd tmp rest_right_eqns pos in
            (rest_left_eqns,res,s_list)
    | [] -> (CP.mkTrue pos,CP.mkTrue pos,[])
  in aux st

(*
  ivar -> tvar (tvar in impl_var);
  expl_var += {ivar}
  evar -= {tvar}
  impl_var -= {tvar}
  ivar -> tvar (tvar in expl_var);
  ivar -> tvar (tvar in evar)

  returns  [(tvar->ivar)] [fvar->tvar]
*)

and subs_to_inst_vars (st : ((CP.spec_var * CP.spec_var) * LO.t) list) (ivars : CP.spec_var list)
    (impl_vars: CP.spec_var list) pos
  : (( CP.spec_var list * CP.spec_var list * (CP.spec_var * CP.spec_var) list) *   ((CP.spec_var * CP.spec_var)* LO.t) list) =
  let pr_svl = Cprinter.string_of_spec_var_list in
  let pr_sv = Cprinter.string_of_spec_var in
  let pr_subs xs = pr_list (pr_pair pr_sv pr_sv) xs in
  (* let pr_lf xs = pr_list Cprinter.string_of_pure_formula xs in *)
  let pr2 xs = pr_list (fun (c,_) -> pr_pair pr_sv pr_sv c) xs in
  let pr_r ((l1,l2,s1),s2)  = "(("^(pr_svl l1)^","^(pr_svl l2)^","^((add_str "ivars_to_conseq" pr_subs) s1)^"),"^((add_str "other_subs" pr2) s2)^")" in
  Debug.no_3 "subs_to_inst_vars" (add_str "subs" pr2)
    (add_str "ivars" pr_svl) (add_str "impl" pr_svl) pr_r (fun _ _ _-> subs_to_inst_vars_x st ivars impl_vars pos) st ivars impl_vars

and subs_to_inst_vars_x (st : ((CP.spec_var * CP.spec_var) * LO.t) list)
    (ivars : CP.spec_var list)
    (impl_vars: CP.spec_var list) pos
  : (( CP.spec_var list * CP.spec_var list * (CP.spec_var * CP.spec_var) list) *   ((CP.spec_var * CP.spec_var)* LO.t) list) =
  let rec helper st nsubs iv impl_v = match st with
    | ((rv, lv),_) :: rest ->
      let f = helper rest ((lv,rv)::nsubs) (lv::iv) in
      if (CP.mem rv impl_vars) then
        f (rv::impl_v)
      else (* t in ex_vars || t in expl_vars *)
        f impl_v
    | [] -> (impl_v,iv,nsubs) in
  (* impl_v to subtract from e_var and add to expl_var *)
  let (i_st, r_st) = List.partition (fun ((_,lv),_) -> CP.mem lv ivars) st  in
  (helper i_st [] [] [] ,r_st)

(*
  - extract the equations for the variables that are to be explicitly instantiated
  - remove the variables already instantiated from ivars
  - expl_vars will contain the vars that are next to be explicitly instantiated: for each equation ivar = v, it adds v to the list of vars that will be explicitly instantiated later
*)

(**************************************************************)
(* Check barrier consistency (db-consistency)                 *)
(* Check is done on combined states (after normalize_w_coer)  *)
(* Neccesary for soundness of frame rule and par rule         *)
(**************************************************************)

(*a formula (i.e. a combined state) is barrier-consistent if
  for any pair of its barrier nodes (in combined state)
  b1:barrier(c1,t1,a1)<p1> and b2::barrier(c2,t2,a2)<p2>
  where:

  [db-consistency]
  (b1=b2 => (c1!=0 & c2!=0 & p1=p2) \/
  (c1=0 & p1<=p2) \/
  (c2=0 & p2<=p1)

  Note that db-consistency is more general
  then b-consistency.
  For static barriers, c1,c2 always != 0
  Hence, [b-consistency] check is simplified to:
  (b1=b2 => p1=p2)


*)
and is_barrier_inconsistent_formula_x prog (f:formula) (es : entail_state) (sv:CP.spec_var) =
  let rec helper f = match f with
    | Base _ | Exists _ ->
      let h,p,vp,fl,t,a = split_components f in
      let new_f = mkBase h p vp t fl a no_pos in
      let empty_es = CF.empty_es (CF.mkTrueFlow ()) Label_only.Lab2_List.unlabelled no_pos in
      let new_es = {empty_es with CF.es_formula = new_f} in
      let heaps = split_star_conjunctions h in
      (*remove HTrue nodes*)
      let heaps = List.filter (fun h ->
          match h with
          | HEmp
          | HFalse
          | HTrue -> false
          | _ -> true) heaps
      in
      let barrier_nodes = List.filter (fun h ->
          let name = x_add CF.get_node_name 16 h in
          if (name="barrier") then true else false) heaps
      in
      if (List.length barrier_nodes <= 1) then (*consistent*) false
      else
        let rec pairs_of ls =
          match ls with
          | [] -> []
          | x::xs ->
            let res1 = pairs_of xs in
            let res2 = List.map (fun v -> (x,v)) xs in
            res1@res2
        in
        let pairs = pairs_of barrier_nodes in
        let rec helper (node1,node2) =
          let func e =
            match e with
            | Cpure.Bptriple ((c,t,a),_) -> (c,t,a)
            | _ -> report_error no_pos ("is_barrier_inconsistent_formula: expecting Bptriple")
          in
          let node1_perm = CF.get_node_perm node1 in
          let node1_perm = List.hd (Perm.get_cperm node1_perm) in
          let c1,t1,a1 = func node1_perm in
          let b1 = CF.get_node_var node1 in
          let node1_args = CF.get_node_args node1 in
          let p1 = List.hd node1_args in
          let node2_perm = CF.get_node_perm node2 in
          let node2_perm =  List.hd (Perm.get_cperm node2_perm) in
          let c2,t2,a2 = func node2_perm in
          let b2 = CF.get_node_var node2 in
          let node2_args = CF.get_node_args node2 in
          let p2 = List.hd node2_args in

          (* c1!=0 & c2!=0 & p1=p2 *)
          let c1_neq_0 = CP.mkNeqVarInt c1 0 no_pos in
          let c2_neq_0 = CP.mkNeqVarInt c2 0 no_pos in
          let p1_eq_p2 = CP.mkEqVar p1 p2 no_pos in
          let or_f1 = CP.mkAnd c1_neq_0 (CP.mkAnd c2_neq_0 p1_eq_p2 no_pos) no_pos in

          (* (c1=0 & p1<=p2) *)
          let c1_eq_0 = CP.mkEqVarInt c1 0 no_pos in
          let p1_lte_p2 = CP.mkLteVar p1 p2 no_pos in
          let or_f2 = CP.mkAnd c1_eq_0 p1_lte_p2 no_pos in

          (* (c2=0 & p2<=p1) *)
          let c2_eq_0 = CP.mkEqVarInt c2 0 no_pos in
          let p2_lte_p1 = CP.mkLteVar p2 p1 no_pos in
          let or_f3 = CP.mkAnd c2_eq_0 p2_lte_p1 no_pos in

          (* b1!=b2  *)
          let b1_neq_b2 = CP.mkNeqVar b1 b2 no_pos in

              (*
                Final formula:
                (b1=b2 => (c1!=0 & c2!=0 & p1=p2) \/
                (c1=0 & p1<=p2) \/
                (c2=0 & p2<=p1)
              *)
          let or_f = CP.mkOr b1_neq_b2 (CP.mkOr or_f1 (CP.mkOr or_f2 or_f3 None no_pos) None no_pos) None no_pos in
          or_f
        in
        if (pairs==[]) then false
        else
          (*before entailments could take long time.
            We first generate the consistency constraints
            and check them one time
          *)
          (*list of formulaes for consistency check*)
          let fs = List.map helper pairs in
          let new_f = List.fold_left (fun res f -> CP.mkAnd res f no_pos) (CP.mkTrue no_pos) fs
          in
          let new_f = CF.formula_of_pure_formula new_f no_pos in
          (*******************************************)
          let rs,prf = x_add heap_entail_one_context 15 prog false (CF.Ctx new_es) new_f None None None no_pos in
          (*if fail, cannot prove two nodes are consistent,
            conservatively say inconsistent - true*)
          (if (CF.isFailCtx rs) then true else false)
    | Or ({ formula_or_f1 = f1;
            formula_or_f2 = f2;
            formula_or_pos = pos}) ->
      let b1 = helper f1 in
      let b2 = helper f2 in
      (*either of it is inconsistent*)
      b1||b2
  in helper f

and is_barrier_inconsistent_formula prog (f:formula) (es : entail_state) (sv:CP.spec_var) =
  Debug.no_2 "is_barrier_inconsistent_formula"
    Cprinter.string_of_entail_state
    Cprinter.string_of_spec_var
    string_of_bool
    (fun _ _ -> is_barrier_inconsistent_formula_x prog f es sv) es sv

and check_barrier_inconsistency_context prog ctx (sv:CP.spec_var) pos =
  let rec helper ctx = match ctx with
    | OCtx (c1, c2) ->
      let rs1,prf1 = helper c1 in
      let rs2,prf2 = helper c2 in
      ((or_list_context rs1 rs2),(mkOrStrucLeft ctx (CF.struc_formula_of_heap HTrue pos) [prf1;prf2]))
    | Ctx es ->
      let f = es.es_formula in
      let b = is_barrier_inconsistent_formula prog f es sv in
      if not b then (SuccCtx [ctx] ,Unknown)
      else
        let err_msg = "Possibly inconsistent state detected" in
        let fe = mk_failure_may err_msg "Possibly inconsistent state" in
        (CF.mkFailCtx_in (Basic_Reason
                            ({fc_message =err_msg;
                              fc_current_lhs = es;
                              fc_current_ents = [];
                              fc_orig_conseq = CF.struc_formula_of_heap HTrue pos;
                              fc_prior_steps = es.es_prior_steps;
                              fc_current_conseq = CF.mkTrue (mkTrueFlow ()) pos;
                              fc_failure_pts =[];}, fe, es.es_trace))
           ({es with es_formula = CF.substitute_flow_into_f !mayerror_flow_int es.es_formula}, err_msg, Failure_May err_msg)
           (mk_cex false), Failure)
  in helper ctx

(*Only check barrier nodes related to svl*)
and check_barrier_inconsistency_context_svl_x prog ctx (svl : CP.spec_var list) pos =
  match svl with
  | [] ->  (SuccCtx [ctx] ,Unknown)
  | sv::xs ->
    let (res,prf) = check_barrier_inconsistency_context prog ctx sv pos in
    if (isFailCtx res) then (res,prf)
    else check_barrier_inconsistency_context_svl prog ctx xs pos

and check_barrier_inconsistency_context_svl prog ctx (svl : CP.spec_var list) pos =
  let pr_out (res,prf) = Cprinter.string_of_list_context res in
  Debug.no_2 "check_barrier_inconsistency_context_svl"
    Cprinter.string_of_context_short
    Cprinter.string_of_spec_var_list
    pr_out
    (fun _ _ -> check_barrier_inconsistency_context_svl_x prog ctx svl pos) ctx svl

and check_barrier_inconsistency_failesc_context prog cl (sv:CP.spec_var) pos  =
  let fail_branches, esc_branches, succ_branches  = cl in
  let res = List.map (fun (lbl,c2,oft)->
      let list_context_res,prf = check_barrier_inconsistency_context prog c2 sv pos in
      let esc_skeletal = List.map (fun (l,_) -> (l,[])) esc_branches in
      let res = match list_context_res with
        | FailCtx (t,_,_) -> [([(lbl,t)],esc_skeletal,[])]
        | SuccCtx ls -> List.map ( fun c-> ([],esc_skeletal,[(lbl,c,oft)])) ls in
      (res, prf)) succ_branches in
  let res_l,prf_l =List.split res in
  let res = List.fold_left (list_failesc_context_or Cprinter.string_of_esc_stack) [(fail_branches,esc_branches,[])] res_l in
  let proof = ContextList {
      context_list_ante = [];
      context_list_conseq = struc_formula_of_formula (mkTrue (mkTrueFlow ()) pos) pos;
      context_list_proofs = prf_l; } in
  (res, proof)

(*required before each wait(b1), sv=b1*)
and check_barrier_inconsistency_list_failesc_context prog lcl (sv:CP.spec_var) pos =
  let l = List.map (fun cl -> check_barrier_inconsistency_failesc_context prog cl sv pos) lcl in
  let l_ctx , prf_l = List.split l in
  let result = List.fold_left list_failesc_context_union (List.hd l_ctx) (List.tl l_ctx) in
  let proof = ContextList {
      context_list_ante = [];
      context_list_conseq = struc_formula_of_formula (mkTrue (mkTrueFlow ()) pos) pos;
      context_list_proofs = prf_l; } in
  (result, proof)

(*
  Return: None -> consistent
  Some res -> inconsistent with FailCtx "res"

*)
and check_consistency_context_x prog ctx pos =
  let rec helper ctx = match ctx with
    | OCtx (c1, c2) ->
      let rs1 = helper c1 in
      let rs2 = helper c2 in
      (match rs1,rs2 with
       | None, None -> None
       | Some res, _
       | _ ,  Some res -> Some res)
    | Ctx es ->
      let f = es.es_formula in
      if (CF.formula_is_eq_flow f !bfail_flow_int)
      then
        (*if detecting inconsistency (i.e. flow __Fail)*)
        let () = x_tinfo_pp "detecting inconsistency" no_pos in
        let err_msg = "__Fail: inconsistencies detected" in
        let fe = mk_failure_must err_msg "__Fail: inconsistencies detected" in
        let res =
          (CF.mkFailCtx_in (Basic_Reason
                              ({fc_message =err_msg;
                                fc_current_lhs = es;
                                fc_current_ents = [];
                                fc_orig_conseq = CF.struc_formula_of_heap HTrue pos;
                                fc_prior_steps = es.es_prior_steps;
                                fc_current_conseq = CF.mkTrue (mkTrueFlow ()) pos;
                                fc_failure_pts =[];}, fe, es.es_trace)) ({es with es_formula = CF.substitute_flow_into_f !error_flow_int es.es_formula}, err_msg, Failure_Must err_msg) (mk_cex true), Failure)
        in Some res
      else None
  in helper ctx

and check_consistency_context prog ctx pos =
  let pr1 (res,prf) = Cprinter.string_of_list_context res in
  let pr_out = pr_option pr1 in
  Debug.no_1 "check_consistency_context"
    Cprinter.string_of_context_short
    pr_out
    (fun _ -> check_consistency_context_x prog ctx pos) ctx

(**************************************************************)
(* heap entailment                                            *)
(**************************************************************)

and filter_set (cl : list_context) : list_context =
  if !Globals.use_set  then cl
  else match cl with
    | FailCtx _ -> cl
    | SuccCtx l -> if Gen.is_empty l then cl else SuccCtx [(List.hd l)]
(* setup the labeling in conseq and the fail context in cl *)

and heap_entail_failesc_prefix_init i (prog : prog_decl) (is_folding : bool)
  (has_post: bool)(cl : list_failesc_context) (conseq : 'a) (tid: CP.spec_var
  option) (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos
  (pid:control_path_id) ((rename_f: 'a->'a), (to_string:'a->string), (f:
  prog_decl->bool->bool->context->'a -> CP.spec_var option -> MCP.mix_formula
  option -> CP.spec_var option -> loc ->control_path_id->(list_context *
  proof))) : (list_failesc_context * proof) =
  let pr = to_string in
  let pr2 = Cprinter.string_of_list_failesc_context in
  Debug.no_2_num i "heap_entail_failesc_prefix_init" pr2 pr (fun (c,_) -> pr2 c)
    (fun _ _ -> heap_entail_failesc_prefix_init_x prog is_folding has_post cl
        conseq tid delayed_f join_id pos pid (rename_f,to_string,f))
    cl conseq

and heap_entail_failesc_prefix_init_x (prog : prog_decl) (is_folding : bool)
    (has_post: bool)(cl : list_failesc_context) (conseq : 'a)
    (tid: CP.spec_var option) (delayed_f: MCP.mix_formula option)
    (join_id: CP.spec_var option) pos (pid:control_path_id)
    ((rename_f: 'a->'a), (to_string:'a->string)
    , (f: prog_decl->bool->bool->context->'a -> CP.spec_var option ->
       MCP.mix_formula option -> CP.spec_var option -> loc ->control_path_id
       ->(list_context * proof))) : (list_failesc_context * proof) =
  if (List.length cl)<1
  then report_error pos
      ("heap_entail_failesc_prefix_init : encountered an empty
    list_partial_context \n")
  else
    (* TODO : must avoid empty context *)
    begin
      reset_formula_point_id();
      let rename_es es = {es with es_formula = rename_labels_formula_ante
                                      es.es_formula} in
      let conseq = rename_f conseq in
      let rec prepare_ctx es =
        {es with es_success_pts = ([]: (formula_label * formula_label) list);
                 es_residue_pts = residue_labels_in_formula es.es_formula;
                 es_id = (fst (fresh_formula_label ""));
        } in
      let cl_new = transform_list_failesc_context
          (idf,idf,(fun es-> Ctx(prepare_ctx (rename_es (reset_original_es es)))
                   )) cl in
      let entail_fct = fun c -> x_add heap_entail_struc_list_failesc_context
          prog is_folding has_post c conseq tid delayed_f join_id pos pid f
          to_string in
      let ctx, prf = heap_entail_agressive_prunning entail_fct
          (prune_ctx_failesc_list prog) (fun (c,_) -> isSuccessListFailescCtx c)
          cl_new in
      (subs_crt_holes_list_failesc_ctx ctx, prf)
    end

and heap_entail_prefix_init (prog : prog_decl) (is_folding : bool)  (has_post:
  bool)(cl : list_partial_context) (conseq : 'a) (tid: CP.spec_var option)
  (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos
  (pid:control_path_id) ((rename_f: 'a->'a), (to_string:'a->string), (f:
  prog_decl->bool->bool->context->'a -> CP.spec_var option-> MCP.mix_formula
  option -> CP.spec_var option -> loc ->control_path_id->(list_context *
  proof))) : (list_partial_context * proof) =
  if (List.length cl)<1 then report_error pos ("heap_entail_prefix_init : encountered an empty list_partial_context \n")
  else
    begin
      reset_formula_point_id();
      let rename_es es = {es with es_formula = rename_labels_formula_ante es.es_formula}in
      let conseq = rename_f conseq in
      let rec prepare_ctx es =
        {es with es_success_pts  = ([]: (formula_label * formula_label) list);
                 es_residue_pts  = residue_labels_in_formula es.es_formula;
                 es_id = (fst (fresh_formula_label ""));
        } in
      let cl_new = transform_list_partial_context
          ((fun es-> Ctx(prepare_ctx (rename_es es))),(fun c->c)) cl in
      heap_entail_struc_list_partial_context prog is_folding  has_post cl_new
        conseq tid delayed_f join_id pos pid f to_string
    end

and heap_entail_struc_list_partial_context (prog : prog_decl)
    (is_folding : bool)  (has_post: bool)(cl : list_partial_context)
    (conseq:'a) (tid: CP.spec_var option) (delayed_f: MCP.mix_formula option)
    (join_id: CP.spec_var option) pos (pid:control_path_id)
    (f: prog_decl->bool->bool->context->'a -> CP.spec_var option ->
     MCP.mix_formula option -> CP.spec_var option ->loc ->control_path_id
     ->(list_context * proof)) to_string
  : (list_partial_context * proof) =
  x_tinfo_zp (lazy ("heap_entail_struc_list_partial_context:"
                    ^ "\ntid:" ^ (pr_opt Cprinter.string_of_spec_var tid)
                    ^ "\ndelayed_f:" ^ (pr_opt Cprinter.string_of_mix_formula delayed_f)
                    ^ "\nctx:\n" ^ (Cprinter.string_of_list_partial_context cl)
                    ^ "\nconseq:\n" ^ (to_string conseq))) pos;
  let l = List.map
      (fun c-> heap_entail_struc_partial_context prog is_folding  has_post c
          conseq tid delayed_f join_id pos pid f to_string) cl in
  let l_ctx , prf_l = List.split l in
  let result = List.fold_left list_partial_context_union (List.hd l_ctx) (List.tl l_ctx) in
  let proof = ContextList {
      context_list_ante = [];
      context_list_conseq = struc_formula_of_formula (mkTrue (mkTrueFlow ()) pos) pos;
      context_list_proofs = prf_l; } in
  (result, proof)

and heap_entail_struc_list_failesc_context (prog : prog_decl)
    (is_folding:bool) (has_post: bool) (cl : list_failesc_context) conseq
    (tid: CP.spec_var option) (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos
  (pid:control_path_id) f to_string : (list_failesc_context * proof) =
  let pr1 = Cprinter.string_of_list_failesc_context in
  let pr2 (x,_) = Cprinter.string_of_list_failesc_context x in
  Debug.no_1 "heap_entail_struc_list_failesc_context" pr1 pr2
    (fun _ -> heap_entail_struc_list_failesc_context_x prog is_folding has_post cl
        (conseq) tid delayed_f join_id pos pid f to_string) cl

and heap_entail_struc_list_failesc_context_x (prog : prog_decl) (is_folding :
  bool) (has_post: bool)(cl : list_failesc_context) (conseq) (tid: CP.spec_var
  option) (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos
    (pid:control_path_id) f to_string : (list_failesc_context * proof) =
  (* let () = if !enable_repair || !infestor then
   *     let cl_formula = formula_of_list_failesc_context cl in
   *     let cl_vars = CF.fv cl_formula in
   *     let e_vars = CF.get_exists cl_formula in
   *     Synthesis.r_pre_vars := (cl_vars @ e_vars)
   *   else () in *)
  let l = List.map (fun c-> x_add heap_entail_struc_failesc_context prog
                       is_folding has_post c conseq tid delayed_f join_id pos
                       pid f to_string) cl in
  let l_ctx , prf_l = List.split l in
  let result = List.fold_left list_failesc_context_union (List.hd l_ctx)
      (List.tl l_ctx) in
  let proof = ContextList {
      context_list_ante = [];
      context_list_conseq = struc_formula_of_formula (mkTrue (mkTrueFlow ()) pos) pos;
      context_list_proofs = prf_l; } in
  (result, proof)

and heap_entail_struc_partial_context (prog : prog_decl) (is_folding : bool)
    (has_post: bool)(cl : partial_context) (conseq:'a) (tid: CP.spec_var option)
    (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos
    (pid:control_path_id) (f: prog_decl->bool->bool->context->'a ->
                           CP.spec_var option ->  MCP.mix_formula option ->
                           CP.spec_var option -> loc ->control_path_id
                           ->(list_context * proof)) to_string
  : (list_partial_context * proof) =
   x_tinfo_zp (lazy ("heap_entail_struc_partial_context:"
                    ^ "\ntid:" ^ (pr_opt Cprinter.string_of_spec_var tid)
                    ^ "\ndelayed_f:" ^ (pr_opt Cprinter.string_of_mix_formula delayed_f)
                    ^ "\nctx:\n" ^ (Cprinter.string_of_partial_context cl)
                    ^ "\nconseq:\n" ^ (to_string conseq))) pos;

  let heap_entail_one_branch unk_map (lbl,c2,oft)=
    let c20 = CF.update_hp_unk_map c2 unk_map in
    let list_context_res,prf = f prog is_folding has_post c20 conseq tid
        delayed_f join_id pos pid in
    let () = x_tinfo_hp (add_str "ctx" Cprinter.string_of_list_context) list_context_res no_pos in
    let res,new_unk_map = match list_context_res with
      | FailCtx (t,c,_) ->  begin
          if CF.is_en_error_exc_ctx c
          then
            ([([],[(lbl, c,Some t)])],[])
          else
            ([([(lbl,t)],[])],[])
        end
      | SuccCtx ls -> (List.map ( fun c-> begin
            if CF.is_en_error_exc_ctx c
            then
              match CF.get_final_error_ctx c with
              | None -> ([],[(lbl,c,None)])
              | Some (_,ft,_) -> ([],[(lbl,c,Some ft)])
            else  ([],[(lbl,c,None)])
          end
        ) ls,
                       List.concat (List.map CF.collect_hp_unk_map ls) )
    in
    (res, prf, new_unk_map)
  in
  let rec heap_entail_struc_partial_context_helper rem_branches unk_map res_l prf_l=
    match rem_branches with
    | [] -> res_l,prf_l
    | br::br_tl ->
      let () = x_tinfo_pp ("\n *****process one branch******\n") pos in
      let res, prf, new_unk_map= heap_entail_one_branch unk_map br in
      heap_entail_struc_partial_context_helper br_tl
        (unk_map@new_unk_map)
        (res_l@[res])
        (prf_l@[prf])
  in
  let fail_branches, succ_branches  = cl in
  let res_l,prf_l = heap_entail_struc_partial_context_helper succ_branches [] [] [] in
  let res = List.fold_left list_partial_context_or [(fail_branches,[])] res_l in
  let proof = ContextList {
      context_list_ante = [];
      context_list_conseq = struc_formula_of_formula (mkTrue (mkTrueFlow ()) pos) pos;
      context_list_proofs = prf_l; } in
  (res, proof)

and heap_entail_struc_failesc_context (prog : prog_decl) (is_folding : bool)
  (has_post: bool)(cl : failesc_context) (conseq:'a) (tid: CP.spec_var option)
  (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos
  (pid:control_path_id) f to_string: (list_failesc_context * proof) =
  let pr1 = Cprinter.string_of_failesc_context in
  let pr2 (x,_) = Cprinter.string_of_list_failesc_context x in
  Debug.no_1 "heap_entail_struc_failesc_context" pr1 pr2 (fun _ ->
      heap_entail_struc_failesc_context_x prog is_folding
        (has_post)(cl) (conseq) tid delayed_f join_id pos (pid) f to_string) cl

and heap_entail_struc_failesc_context_x (prog : prog_decl) (is_folding : bool)
  (has_post: bool) (cl : failesc_context) (conseq:'a) (tid: CP.spec_var option)
  (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos
  (pid:control_path_id) f to_string: (list_failesc_context * proof) =
  x_dinfo_zp (lazy ("heap_entail_struc_failesc_context:"
                    ^ "\ntid:" ^ (pr_opt Cprinter.string_of_spec_var tid)
                    ^ "\ndelayed_f:" ^ (pr_opt Cprinter.string_of_mix_formula delayed_f)
                    ^ "\nctx:\n" ^ (Cprinter.string_of_failesc_context cl)
                    ^ "\nconseq:\n" ^ (to_string conseq))) pos;
  let fail_branches, esc_branches, succ_branches = cl in
  let res = List.map (fun (lbl,c2,oft)->
      let list_context_res,prf = f prog is_folding has_post c2 conseq tid
          delayed_f join_id pos pid in
      let esc_skeletal = List.map (fun (l,_) -> (l,[])) esc_branches in
      let res = match list_context_res with
        | FailCtx (t,c,_) -> begin if !Globals.enable_error_as_exc
                                   || CF.is_en_error_exc_ctx c
                                   ||  (is_en_efa_exc ()) then
              ([([],esc_skeletal, [((lbl, c ,Some t))])])
            else [([(lbl,t)],esc_skeletal,[])]
          end
        | SuccCtx ls -> List.map ( fun c-> begin
              if !Globals.enable_error_as_exc || CF.is_en_error_exc_ctx c
                 || is_en_efa_exc () then
                match CF.get_final_error_ctx c with
                | None -> ([],esc_skeletal,[(lbl,c,None)])
                | Some (_,ft,_) -> ([],esc_skeletal,[(lbl,c,Some ft)])
              else ([],esc_skeletal,[(lbl,c, None)])
            end
          ) ls in
      (res, prf)) succ_branches in
  let res_l,prf_l = List.split res in
  let res = List.fold_left (list_failesc_context_or Cprinter.string_of_esc_stack
                           ) [(fail_branches,esc_branches,[])] res_l in

  let proof = ContextList {
      context_list_ante = [];
      context_list_conseq = struc_formula_of_formula (mkTrue (mkTrueFlow ()) pos) pos;
      context_list_proofs = prf_l; } in
  (res, proof)

and heap_entail_struc_init_bug_orig (prog : prog_decl) (is_folding : bool)  (has_post: bool) (cl : list_context) (conseq : struc_formula) pos (pid:control_path_id): (list_context * proof) =
  let (ans,prf) = x_add heap_entail_struc_init prog is_folding has_post cl conseq pos pid in
  (CF.convert_maymust_failure_to_value_orig ~mark:false ans, prf)

and heap_entail_struc_init_bug_inv_x (prog : prog_decl) (is_folding : bool)  (has_post: bool) (cl : list_context) (conseq : struc_formula) pos (pid:control_path_id): (list_context * proof) =
  heap_entail_struc_init_bug_orig prog is_folding has_post cl conseq pos pid

and heap_entail_struc_init_bug_inv (prog : prog_decl) (is_folding : bool)  (has_post: bool)(cl : list_context) (conseq : struc_formula) pos (pid:control_path_id): (list_context * proof) =
  Debug.no_2 "heap_entail_struc_init_bug_inv" Cprinter.string_of_list_context Cprinter.string_of_struc_formula
    (fun (ls,_) -> Cprinter.string_of_list_context ls) (fun a c -> heap_entail_struc_init_bug_inv_x prog is_folding has_post a c pos pid) cl conseq

(*this does not have thread id -> None*)
and heap_entail_struc_init_x (prog : prog_decl) (is_folding : bool)  (has_post: bool)(cl : list_context) (conseq : struc_formula) pos (pid:control_path_id): (list_context * proof) =
  x_dinfo_zp (lazy ("heap_entail_struc_init:"^ "\nctx:\n" ^ (Cprinter.string_of_list_context cl)^ "\nconseq:\n" ^ (Cprinter.string_of_struc_formula conseq))) pos;
  match cl with
  | FailCtx fr -> (cl,Failure)
  | SuccCtx _ ->
    reset_formula_point_id();
    let rename_es es = {es with es_formula = rename_labels_formula_ante es.es_formula}in
    let conseq = rename_labels_struc conseq in
    let rec prepare_ctx es = {es with
                              es_success_pts  = ([]: (formula_label * formula_label)  list)  ;(* successful pt from conseq *)
                              es_residue_pts  = residue_labels_in_formula es.es_formula ;(* residue pts from antecedent *)
                              es_id      = (fst (fresh_formula_label ""))              ; (* unique +ve id *)
                              (* es_orig_ante   = es.es_formula; *)
                              es_orig_conseq = conseq ;}in
    let cl_new = transform_list_context ( (fun es-> Ctx(prepare_ctx (rename_es es))),(fun c->c)) cl in
    let entail_fct = fun c-> x_add heap_entail_struc prog is_folding has_post c conseq None None None pos pid in
    let (ans,prf) = heap_entail_agressive_prunning entail_fct (prune_list_ctx prog) (fun (c,_)-> not (isFailCtx c)) cl_new in
    (ans,prf)

and wrap_collect_rel f a =
  let (lc,_) as ans = f a in
  if !Globals.old_infer_collect then ans
  else
    let inf_lst = CF.collect_infer_rel_list_context lc in
    let () = Infer.infer_rel_stk # push_list inf_lst in
    let () =  if inf_lst!=[] then if inf_lst!=[] then x_tinfo_hp (add_str "collect_rel (SLEEK)" (pr_list CP.print_lhs_rhs)) inf_lst no_pos in
    (* let () = x_tinfo_hp (add_str "XXXX lc" Cprinter.string_of_list_context_short) lc no_pos in *)
    ans

and wrap_collect_rel_lpc f a =
  let (lc,_) as ans = f a in
  if !Globals.old_infer_collect then ans
  else
    let inf_lst = CF.collect_infer_rel_list_partial_context lc in
    let () = Infer.infer_rel_stk # push_list inf_lst in
    let () =  if inf_lst!=[] then if inf_lst!=[] then x_tinfo_hp (add_str "collect_rel (HIP)" (pr_list CP.print_lhs_rhs)) inf_lst no_pos in
    (* let () = x_tinfo_hp (add_str "XXXX lpc" Cprinter.string_of_list_partial_context_short) lc no_pos in *)
    ans

and wrap_collect_rel_lfc f a =
  let (lc,_) as ans = f a in
  if !Globals.old_infer_collect then ans
  else
    let inf_lst = CF.collect_infer_rel_list_failesc_context lc in
    let () = Infer.infer_rel_stk # push_list inf_lst in
    let () =  if inf_lst!=[] then x_tinfo_hp (add_str "collect_rel (HIP)lfc" (pr_list CP.print_lhs_rhs)) inf_lst no_pos in
    ans


(* this is called mainly by sleek, and in hip for barrier entailment *)
and heap_entail_struc_init (prog : prog_decl) (is_folding : bool)  (has_post: bool)(cl : list_context) (conseq : struc_formula) pos (pid:control_path_id): (list_context * proof) =
  (*print just length of residue ctx list*)
  (* let length_ctx ctx = match ctx with *)
  (*   | CF.FailCtx _ -> 0 *)
  (*   | CF.SuccCtx ctx0 -> List.length ctx0 in *)
  let pr = Cprinter.string_of_list_context in
  let pr2 = Cprinter.string_of_struc_formula in
  (* let pr_out (ctx_lst, pf) = string_of_int (length_ctx ctx_lst) in  *)
  let pr_out (ctx_lst, pf) = Cprinter.string_of_list_context ctx_lst in
  Debug.no_2 "heap_entail_struc_init" pr pr2 pr_out (fun _ _ -> wrap_collect_rel (heap_entail_struc_init_x prog is_folding has_post cl conseq pos) pid) cl conseq

(* check entailment:                                          *)
(* each entailment should produce one proof, be it failure or *)
(* success. *)
and heap_entail_struc_x (prog : prog_decl) (is_folding : bool)  (has_post: bool)(cl : list_context) (conseq : struc_formula) (tid: CP.spec_var option) (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos pid: (list_context * proof) =
  let m = "***heap_entail_struc** " in
  let () = lemma_soundness # start_disjunct (m^x_loc) in
  match cl with
  | FailCtx _ -> (cl,Failure)
  | SuccCtx cl ->
    (* Do compaction for field annotations *)
    (* let () = print_string("\ncl:"^(pr_list_ln (Cprinter.string_of_context) cl)^"\n") in *)
    let conseq = Norm.imm_norm_struc prog conseq true unfold_for_abs_merge  pos in
    let unfold_fun fl h aset v uf =  (x_add_1 unfold_heap (prog, None)) h aset v fl uf pos in
    let cl = List.map (fun c -> CF.transform_context (fun es ->
        CF.Ctx{es with CF.es_formula = Norm.imm_norm_formula prog es.CF.es_formula unfold_for_abs_merge pos; }
      ) c) cl
    in
    (* let () = print_string("\ncl2:"^(pr_list_ln (Cprinter.string_of_context) cl)^"\n") in *)
    if !Globals.use_set || Gen.is_empty cl then
      let tmp1 = List.map (fun c -> x_add heap_entail_one_context_struc_nth 4 prog is_folding has_post c conseq tid delayed_f join_id pos pid) cl in
      let tmp2, tmp_prfs = List.split tmp1 in
      let prf = mkContextList cl conseq tmp_prfs in
      ((fold_context_left 20 tmp2), prf)
    else
      (x_add heap_entail_one_context_struc_nth 5 prog is_folding has_post (List.hd cl) conseq tid delayed_f join_id pos pid)

and filter_infer_search (lc,a) =
  let fn lc =
    match lc with
    | CF.FailCtx _ -> lc
    | CF.SuccCtx lc2 ->
      let r = List.filter (fun c -> CF.is_infer_none_ctx c) lc2 in
      if r==[] then  lc else CF.SuccCtx r
  in
  ((if !Globals.filter_infer_search then fn lc else lc),a)

and heap_entail_struc (prog : prog_decl) (is_folding : bool)  (has_post: bool)(cl : list_context) (conseq : struc_formula) (tid: CP.spec_var option) (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos (pid:control_path_id): (list_context * proof) =
  Debug.no_2 "heap_entail_struc" Cprinter.string_of_list_context Cprinter.string_of_struc_formula
    (fun (ls,_) -> Cprinter.string_of_list_context ls) (fun a c ->
        filter_infer_search (heap_entail_struc_x prog is_folding has_post a c tid delayed_f join_id pos pid)) cl conseq

and heap_entail_one_context_struc_nth n p i1 hp cl cs (tid: CP.spec_var option)
  (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos pid =
  let str="heap_entail_one_context_struc" in
  let n_str = string_of_int n in
  Gen.Profiling.do_3_num n_str str (heap_entail_one_context_struc n p i1 hp cl)
    cs tid delayed_f join_id pos pid

and heap_entail_one_context_struc i p i1 hp cl cs (tid: CP.spec_var option)
  (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos pid =
  Debug.no_4_num i "heap_entail_one_context_struc"
    (add_str "conseq" Cprinter.string_of_struc_formula)
    Cprinter.string_of_context
    (add_str "is_folding" string_of_bool)
    (add_str "has_post" string_of_bool)
    (fun (lctx, _) -> Cprinter.string_of_list_context lctx)
    (fun cs cl _ _ -> heap_entail_one_context_struc_x p i1 hp cl cs tid
        delayed_f join_id pos pid) cs cl i1 hp

(* should notice this function *)
and heap_entail_one_context_struc_x (prog : prog_decl) (is_folding : bool)
  has_post (ctx : context) (conseq : struc_formula) (tid: CP.spec_var option)
  (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos pid :
  (list_context * proof) =
  x_dinfo_zp (lazy ("heap_entail_one_context_struc:"^ "\nctx:\n"
                    ^ (Cprinter.string_of_context ctx)^ "\nconseq:\n"
                    ^ (Cprinter.string_of_struc_formula conseq))) pos;
  let rec get_pure_conseq_from_formula f =
    match f with
    | Or fo ->
      let () = x_tinfo_hp (add_str "formula" Cprinter.string_of_formula) f no_pos in
      let pfo1 = get_pure_conseq_from_formula fo.CF.formula_or_f1 in
      let pfo2 = get_pure_conseq_from_formula fo.CF.formula_or_f2 in
      CP.mkOr pfo1 pfo2 None fo.CF.formula_or_pos
    | _  ->
      let () = x_tinfo_hp (add_str "formula1" Cprinter.string_of_formula) f no_pos in
      let _,p,_,_,_,_ = CF.split_components f in (Mcpure.pure_of_mix p)
  in
  let flatten_struc sf = CF.flatten_struc_formula sf in
  let rec get_pure_conseq_from_struc sf =
    match sf with
    | EBase eb ->
      let f1 = get_pure_conseq_from_formula eb.CF.formula_struc_base in
      let f2 = match eb.CF.formula_struc_continuation with
        | None -> CP.mkTrue no_pos
        | Some cont -> get_pure_conseq_from_struc cont
      in
      CP.mkAnd f1 f2 no_pos
    | EInfer ei -> get_pure_conseq_from_struc ei.CF.formula_inf_continuation
    | EAssume ea -> get_pure_conseq_from_formula ea.CF.formula_assume_simpl
    | EList el -> List.fold_left (fun acc (_,sf) ->
        CP.mkOr acc (get_pure_conseq_from_struc sf) None no_pos
      ) (CP.mkFalse no_pos) el
    | ECase ec -> List.fold_left (fun acc (pf,sf) ->
        let new_f = CP.mkAnd pf (get_pure_conseq_from_struc sf) no_pos in
        CP.mkOr acc new_f None no_pos
      ) (CP.mkFalse no_pos) ec.CF.formula_case_branches
  in
  if (isAnyFalseCtx ctx) && !Globals.infer_false_imply_unknown then
    let pr_svl = Cprinter.string_of_typed_spec_var_list in
    let false_es = CF.get_false_entail_state ctx in
    let false_iv_rel = false_es.CF.es_infer_vars_rel in
    let false_iv = false_es.CF.es_infer_vars in
    let rhs = get_pure_conseq_from_struc conseq in
    let rel_id_conseq = CP.get_rel_id_list rhs in
    let () = x_tinfo_hp (add_str "false_iv_rel" pr_svl) false_iv_rel no_pos in
    let () = x_tinfo_hp (add_str "false_iv" pr_svl) false_iv no_pos in
    let () = x_tinfo_hp (add_str "rel_id_conseq" pr_svl) rel_id_conseq no_pos in
    let () = Debug.tinfo_hprint (add_str "rhs" Cprinter.string_of_pure_formula) rhs no_pos in
    let () = Debug.tinfo_hprint (add_str "conseq" Cprinter.string_of_struc_formula) conseq no_pos in
    (* let conseq_flow = !Exc.GTable.norm_flow_int in *)
    let conseq_flow = CF.mkNormalFlow () in
    let ans = x_add Infer.infer_collect_rel (fun _ -> true) false_es conseq_flow (Mcpure.mkMFalse no_pos) (Mcpure.mkMFalse no_pos) (Mcpure.mix_of_pure rhs) no_pos in
    let es,_,_,_,_ = ans in
    let () = Debug.ninfo_hprint (add_str "conseq" Cprinter.string_of_struc_formula) conseq no_pos in
    let () = Debug.ninfo_hprint (add_str "ctx" Cprinter.string_of_context_short) ctx no_pos in
    (* let bot_ctx = ctx in *)
    let bot_ctx = CF.Ctx es in
    let () = Debug.ninfo_hprint (add_str "bot_ctx" Cprinter.string_of_context_short) bot_ctx no_pos in
    let r = SuccCtx [bot_ctx] in
    let es = get_estate_from_ctx bot_ctx in
    let (_,cseq) = base_formula_of_struc_formula conseq in
    let () = x_add new_slk_log_g cseq 2 (* hec_num *) pos r es in
    (r, UnsatAnte)
  else if (isConstETrue conseq) && (join_id=None) then
    ((SuccCtx [ctx]), TrueConseq)
  else
    let () = Debug.tinfo_hprint (add_str "ctx 2763: " Cprinter.string_of_context) ctx no_pos in
    let result, prf =
      if Synthesis.contains_lseg prog ||            (* SLEEK does not handle lseg well *)
        SB.contains_hps prog ctx conseq then (* unknown predicate *)
        SB.heap_entail_after_sat_struc prog ctx conseq
      else if !songbird || !songbird_disproof then
        SB.heap_entail_after_sat_struc prog ctx conseq
      else
        let res = x_add heap_entail_after_sat_struc 1 prog is_folding
                    has_post ctx conseq tid delayed_f join_id pos pid [] in
        (* TRUNG: very temporarily way to export. to remove later *)
        let _ = if !songbird_export_all_entails then
            let _ = SB.heap_entail_after_sat_struc prog ctx conseq in
            () in
        res in
    let result = subs_crt_holes_list_ctx result in
    let () = Debug.dinfo_hprint (add_str "result 2766: " Cprinter.string_of_list_context) result no_pos in
    (result, prf)

and need_unfold_rhs prog vn=
  let rec look_up_view vn0=
    let vdef = x_add C.look_up_view_def_raw x_loc prog.C.prog_view_decls vn0.CF.h_formula_view_name in
    let fs = List.map fst vdef.view_un_struc_formula in
    let hv_opt = CF.is_only_viewnode false (CF.formula_of_disjuncts fs) in
    match hv_opt with
    | Some vn1 -> look_up_view vn1
    | None -> vdef
  in
  let vdef = look_up_view vn in
  let unk_hps = List.fold_left (fun r (f,_) ->
      match CF.extract_hrel_head f with
      | Some (hp) -> r@[hp]
      | None -> r
    ) [] vdef.view_un_struc_formula in
  if unk_hps <> [] then
    let () = Debug.ninfo_zprint (lazy (("    xxxa " ))) no_pos in
    ([(vn.CF.h_formula_view_name,vdef.C.view_un_struc_formula, vdef.C.view_vars)],unk_hps)
  else
    ([],[])


and heap_entail_after_sat_struc i prog is_folding  has_post
    ctx conseq (tid: CP.spec_var option) (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos pid (ss:steps) : (list_context * proof) =
  Debug.no_2_num i "heap_entail_after_sat_struc" Cprinter.string_of_context
    Cprinter.string_of_struc_formula
    (fun (lctx, _) -> Cprinter.string_of_list_context lctx)
    (fun _ _ -> heap_entail_after_sat_struc_x prog is_folding has_post ctx conseq tid delayed_f join_id pos pid ss) ctx conseq

and heap_entail_after_sat_struc_x prog is_folding has_post
    ctx conseq tid delayed_f join_id pos pid (ss:steps) : (list_context * proof) =
  match ctx with
  | OCtx (c1, c2) ->
    x_dinfo_zp (lazy ("heap_entail_after_sat_struc:"
                      ^ "\ntid:" ^ (pr_opt Cprinter.string_of_spec_var tid)
                      ^ "\ndelayed_f:" ^ (pr_opt Cprinter.string_of_mix_formula delayed_f)
                      ^ "\nctxx:\n" ^ (Cprinter.string_of_context ctx)^ "\nconseq:\n" ^ (Cprinter.string_of_struc_formula conseq))) pos;
    let rs1, prf1 = x_add heap_entail_after_sat_struc 2 prog is_folding
        has_post c1 conseq tid delayed_f join_id pos pid (CF.add_to_steps ss "left OR 5 on ante") in
    let rs2, prf2 = x_add heap_entail_after_sat_struc 3 prog is_folding
        (* WN : what is init_caller for? *)
        has_post c2 conseq tid delayed_f join_id pos pid (CF.add_to_steps ss "right OR 5 on ante") in
    ((or_list_context rs1 rs2),(mkOrStrucLeft ctx conseq [prf1;prf2]))
  | Ctx es ->
    let exec ()=
      begin
        let () = x_tinfo_hp (add_str "es(1)" Cprinter.string_of_entail_state_short) es no_pos in
        x_tinfo_zp (lazy ("heap_entail_after_sat_struc: invoking heap_entail_conjunct_lhs_struc"
                          ^ "\ntid:" ^ (pr_opt Cprinter.string_of_spec_var tid)
                          ^ "\ndelayed_f:" ^ (pr_opt Cprinter.string_of_mix_formula delayed_f)
                          ^ "\ncontext:\n" ^ (Cprinter.string_of_context ctx)^ "\nconseq:\n" ^ (Cprinter.string_of_struc_formula conseq))) pos;
        let vn_opt= CF.is_only_viewnode true es.CF.es_formula in
        let need_unfold, pr_views ,_, unk_hps= match vn_opt with
          | Some vn ->
            let pr_views,unk_hps = need_unfold_rhs prog vn in
            if unk_hps = [] || pr_views = [] then
              (false, [], [],[])
            else
              (true, pr_views,vn.CF.h_formula_view_node::vn.CF. h_formula_view_arguments,unk_hps)
          | None -> (false, [], [], [])
        in
        let fs = if need_unfold then
            let nf = CF.do_unfold_view prog pr_views es.CF.es_formula in
            let fs = CF.list_of_disjs nf in
            fs
          else []
        in
        let () = Debug.ninfo_hprint (add_str "fs" (pr_list Cprinter.string_of_formula)) fs no_pos in
        if need_unfold && List.length fs > 1 then
          let orctx = List.map (fun f ->
              Ctx {es with CF.es_formula = f;}
            ) fs
          in
          let n_ctx = List.fold_left (fun c1 c2 -> CF.OCtx (c1, c2)) (List.hd orctx) (List.tl orctx) in
          x_add heap_entail_after_sat_struc 4 prog is_folding has_post
            n_ctx conseq tid delayed_f join_id pos pid ss
        else
          (*let es = {es with es_formula = prune_preds prog es.es_formula } in*)
          let () = flush(stdout) in
          let () = x_dinfo_hp (add_str "es(2)" Cprinter.string_of_entail_state(* _short *)) es no_pos in
          let () = flush(stdout) in
          let es = (CF.add_to_estate_with_steps es ss) in
          let () = x_dinfo_hp (add_str "es(3)" Cprinter.string_of_entail_state) es no_pos in
          let () = flush(stdout) in
          let tmp, prf =
            x_add heap_entail_conjunct_lhs_struc prog is_folding has_post (Ctx es) conseq tid delayed_f join_id pos pid
          in
          let m = "***heap_entail_cnj_lhs_struc(after)** " in
          let () = lemma_soundness # start_disjunct (m^x_loc) in
          (filter_set tmp, prf)
      end
    in wrap_trace es.es_path_label exec ()

and sem_imply_add prog is_folding  ctx (p:CP.formula) only_syn:(context*bool) =
  let pr1 = Cprinter.string_of_context_short in
  let pr2 = Cprinter.string_of_pure_formula in
  let pr3 = pr_pair pr1 string_of_bool in
  Debug.no_2 "sem_imply_add" pr1 pr2 pr3
    (fun _ _ -> sem_imply_add_x prog is_folding  ctx (p:CP.formula) only_syn) ctx p


and sem_imply_add_x prog is_folding  ctx (p:CP.formula) only_syn:(context*bool) = match ctx with
  | OCtx _ -> report_error no_pos ("sem_imply_add: OCtx encountered \n")
  | Ctx c ->
    if (CP.isConstTrue p) then (ctx,true)
    else
    if (sintactic_search c.es_formula p) then
      (* let () = print_endline "syn true!" in *)
      (ctx,true)
    else if only_syn then (print_string "only syn\n"; (ctx,false))
    else
      let b = (xpure_imply prog is_folding  c p !Globals.imply_timeout_limit) in
      if b then
        (* let () = print_endline "xpure true!" in *)
        let new_es_formula = (mkAnd_pure c.es_formula (MCP.memoise_add_pure_N (MCP.mkMTrue no_pos) p) no_pos) in
        ((Ctx {c with
               es_formula =  new_es_formula }),true)
      else (ctx,false)


and syn_imply ctx p :bool = match ctx with
  | OCtx _ -> report_error no_pos ("syn_imply: OCtx encountered \n")
  | Ctx c ->
    if (sintactic_search c.es_formula p) then true
    else false

and count_octx x = match x with
  | OCtx (c1,c2) -> (count_octx c1) + (count_octx c2)
  | _ -> 1

(*
  es_f : entail state formula
  id : thread id / thread node

  RETURN:
  (delayed formula, resource, AND-conj, new_es) option
  Ctx option
*)
and find_thread_delayed_resource es es_f id pos =
  (*TO CHECK: asssume no disjuntive form in f*)
  let h, p, vp, ft, t,a = CF.split_components es_f in (*pickup pure constraints and threads*)
  let ids = MCP.find_closure_mix_formula id p in
  if (!Globals.allow_threads_as_resource) then
    begin
      let heaps =  (CF.split_star_conjunctions h) in (*TOCHECK: complex heaps might throw errors*)
      let t_heaps, r_heaps = List.partition (fun h ->
          match h with
          | ThreadNode _
          | ViewNode _
          | DataNode _ -> Gen.BList.mem_eq CP.eq_spec_var (CF.get_node_var h) ids
          | _ -> false) heaps
      in
      let () = if (List.length t_heaps) > 1 then
          print_endline_quiet ("[Warning] helper_inner: multiple ThreadNode, might need to normalize")
      in
      (if ((List.length t_heaps) == 0) then
         let error_msg = "Thrd node " ^ (Cprinter.string_of_spec_var id) ^ "not found when join" in
         let rs = (CF.mkFailCtx_in (Basic_Reason (mkFailContext error_msg es (CF.formula_of_heap HFalse pos) None pos, CF.mk_failure_must ("101 : "^ error_msg)  Globals.sl_error, es.es_trace)) ({es with es_formula = CF.substitute_flow_into_f !error_flow_int es.es_formula}, error_msg, Failure_Must error_msg) (mk_cex true), NoAlias) in
         (None, Some rs)
       else
         let tn = List.hd t_heaps in
         let dl,rsr =
           match tn with
           | ThreadNode t -> (t.CF.h_formula_thread_delayed, t.CF.h_formula_thread_resource)
           | _ -> report_error pos ("helper_inner: expecting ThreadNode")
         in
         let new_h = CF.join_star_conjunctions r_heaps in
         let new_es_f = CF.mkBase new_h p vp t ft a pos in
         (Some (dl,rsr,[],new_es_f),None))
    end
  else
    begin
      (*select the thread with id.*)
      let rec helper (ls:CF.one_formula list) vars : CF.one_formula option * (CF.one_formula list) =
        (match ls with
         | [] -> (None,[])
         | x::xs ->
           let id = x.CF.formula_thread in
           if (List.mem id vars) then
             (Some x),xs
           else
             let res1,res2 = helper xs vars in
             (match res1 with
              | None -> None,[]
              | Some f -> Some f, x::res2))
      in
      let res1,res2 = helper a ids in (*res1 is the thread, res2 is the rest*)
      (match res1 with
       | None ->
         (*FAIL to find the thread with id*)
         (*TO CHECK: become FALSE, which may not good enough*)
         let error_msg = ("Join: thread with id = " ^ (Cprinter.string_of_spec_var id) ^ " not found") in
         let ctx = (mkFailCtx_simple error_msg es (CF.mkTrue_nf pos) (mk_cex true) pos, Failure) in
         (None, Some ctx)
       | Some one_f ->
         let base = CF.formula_of_one_formula one_f in
         (******Checking the delayed constraints at join point >>> *******)
         (* Some variables in delayed constraints could be exist vars
            in estate. Therefore, need to rename them appropriately.
            The renaming is only used in proving delayed constraints.
            After proving, nothing changed
         *)
         let delayed_f = MCP.pure_of_mix one_f.CF.formula_delayed in
         (Some (delayed_f,base,res2,es_f), None))
    end

(*permfom delayed lockset before join(tid)
  es: old entail state
  new_es_f : new formula
  delayed_f: delayed lockset constraints
  base : resource/post condition of the thread tid
  res2 : AND-conj if not(!Globals.allow_threads_as_resource)
*)
and delayed_lockset_checking prog es new_es_f delayed_f base res2 pos =
  let evars = CF.get_exists_context (CF.Ctx es) in
  let () = x_dinfo_pp ("Proving delayed lockset constraints: before elim exists: \n "
                       ^ "\n### es = " ^ (Cprinter.string_of_estate es)
                       ^ "\n### delayed_f = " ^ (Cprinter.string_of_pure_formula delayed_f)
                       ^"\n") pos in
  (*Those exist vars that are free var in delayed constraints*)
  let devars =  Gen.BList.intersect_eq CP.eq_spec_var evars (CP.fv delayed_f) in
  (* let () = print_endline ("evars = " ^ (Cprinter.string_of_spec_var_list evars)) in *)
  (* let () = print_endline ("MCP.mfv delayed_f = " ^ (Cprinter.string_of_spec_var_list (MCP.mfv delayed_f))) in *)
  (* let () = print_endline ("devars = " ^ (Cprinter.string_of_spec_var_list devars)) in *)
  let delayed_f,new_es_f =
    if (devars = []) then (delayed_f,new_es_f)
    else
      (******helper>*****)
      let rec helper delayed_f (f:formula) =
        (match f with
         |  Exists {formula_exists_qvars = qvars;
                    formula_exists_heap = qh;
                    formula_exists_pure = qp;
                    formula_exists_vperm = qvp;
                    formula_exists_type = qt;
                    formula_exists_flow = qfl;
                    formula_exists_and = qa;
                    formula_exists_pos = pos} ->
           (*Only renamed those variables that are related to
             delayed constraints. Then, remove them from the evars*)
           let renamed_vars = Gen.BList.intersect_eq CP.eq_spec_var qvars devars in
           let remained_vars = Gen.BList.difference_eq CP.eq_spec_var qvars devars in
           let fresh_vars = CP.fresh_spec_vars renamed_vars in
           let st = List.combine renamed_vars fresh_vars in
           let new_f = if remained_vars=[] then
               mkBase qh qp qvp qt qfl qa pos
             else
               mkExists remained_vars qh qp qvp qt qfl qa pos
           in
           let new_f2 = x_add subst st new_f in
           let new_delayed_f = CP.subst st delayed_f in
           (new_delayed_f,new_f2)
         | Base b -> (delayed_f,Base b)
         | Or {formula_or_f1 = f1;
               formula_or_f2 = f2;
               formula_or_pos = p} ->
           let delayed_f1,new_f1 = helper delayed_f f1 in
           let delayed_f2,new_f2 = helper delayed_f1 f2 in
           let new_f = Or {formula_or_f1 = new_f1;
                           formula_or_f2 = new_f2;
                           formula_or_pos = p}
           in
           (delayed_f2,new_f))
      in
      (******<helper*****)
      let new_es_f,new_delayed_f = helper delayed_f new_es_f in
      new_es_f,new_delayed_f
  in
  let new_es = {es with es_formula = new_es_f; es_evars = Gen.BList.difference_eq CP.eq_spec_var es.es_evars devars} in
  let ls_var_uprimed = CP.mkLsVar Unprimed in
  let ls_var_primed = CP.mkLsVar Primed in
  let ndf = CP.apply_one (ls_var_uprimed, ls_var_primed) delayed_f in
  let new_f = CF.formula_of_pure_formula ndf no_pos in
  let () = x_dinfo_pp ("Proving delayed lockset constraints: after elim exists:  \n "
                       ^ "\n### es = " ^ (Cprinter.string_of_estate new_es)
                       ^ "\n### delayed_f = " ^ (Cprinter.string_of_formula new_f)
                       ^"\n") pos in
  let rs,prf = x_add heap_entail_one_context 12 prog false (CF.Ctx new_es) new_f None None None pos in
  rs, prf

and compose_thread_post_condition_x prog es new_es_f post res2 pos =
  (**********Compose variable permissions >>> *******)
  (* let ps,new_post = CF.filter_varperm_formula post in *)
  (* let full_vars = List.concat (List.map (fun f -> CP.varperm_of_formula f (Some VP_Full)) ps) in (\*only pickup @full*\) *)
  (* TODO: VPerm *)
  (* let full_vars = CF.get_varperm_formula post VP_Full in *)
  (* let new_post = CF.drop_varperm_formula post in         *)
  (* let zero_vars = es.CF.es_var_zero_perm in              *)
  let full_vars = [] in
  let new_post = post in
  let zero_vars = [] in
  let tmp = Gen.BList.difference_eq CP.eq_spec_var_ident full_vars zero_vars in
  if (tmp!=[]) then
    begin
      (*all @full in the conseq should be in @zero in the ante*)
      let msg = "check_exp: SCall: join: failed in adding " ^ (string_of_vp_ann VP_Full) ^ " variable permissions in conseq: " ^ (Cprinter.string_of_spec_var_list tmp)^ "is not" ^(string_of_vp_ann VP_Zero) in
      (mkFailCtx_simple msg es (CF.mkTrue_nf pos) (mk_cex true) pos , Failure)
    end
  else
    begin
      let vars1 = Gen.BList.difference_eq CP.eq_spec_var_ident zero_vars full_vars in
      let es = {es with CF.es_var_zero_perm=vars1} in
      (**********<<< Compose @full variable permissions *******)
      let new_es_f = if (!Globals.allow_threads_as_resource) then new_es_f else CF.replace_formula_and res2 new_es_f
      in
      let primed_full_vars = List.map (fun var -> match var with
          | CP.SpecVar(t,v,p) -> CP.SpecVar (t,v,Primed))  full_vars in
      (* let () = print_endline ("check_exp: SCall : join : \n ### new_es_f = " ^ (Cprinter.string_of_formula new_es_f) ^ " \n new_post = " ^ (Cprinter.string_of_formula new_post)) in *)
      (**** DO NOT COMPOSE lockset because they are thread-local*****)
      let new_f = CF.compose_formula_join new_es_f new_post (* one_f.F.formula_ref_vars *) (primed_full_vars) CF.Flow_combine pos in
      let new_es = {es with CF.es_formula = new_f;
                            es_unsat_flag = true;} in
      let nctx = CF.Ctx new_es in
      let rs = CF.transform_context (x_add elim_unsat_es_now 5 prog (ref 1)) nctx in
      let rs2 = prune_ctx prog rs in
      (*********CHECK db-consistency***********)
      let rs_norm = transform_context (normalize_entail_state_w_lemma prog) rs2 in
      let res = (if (!Globals.perm = Bperm) then
                   let hfv = (CF.fv_heap_of new_post) in
                   let bfv = List.filter (fun v -> (CP.type_of_spec_var v) = barrierT)  hfv in
                   (*Only check for consistency when there are barrier variables inside the post-condition*)
                   if (bfv == []) then None
                   else
                     (*normalize until a fixpoint is reached*)
                     (* check_barrier_inconsistency_context prog res1 *)
                     let res,prf = check_barrier_inconsistency_context_svl prog rs_norm bfv pos in
                     if (isFailCtx res) then Some (res,prf)
                     else None
                 else None)
      in
      (match res with
       | Some res -> res
       | None -> (SuccCtx [rs_norm] ,TrueConseq))
    end

and compose_thread_post_condition prog es new_es_f post res2 pos =
  Debug.no_2 "compose_thread_post_condition"
    Cprinter.string_of_formula
    Cprinter.string_of_formula
    pr_none
    (fun _ _ -> compose_thread_post_condition_x prog es new_es_f post res2 pos) new_es_f post

and heap_entail_conjunct_lhs_struc p is_folding  has_post ctx conseq
    (tid:CP.spec_var option) (delayed_f: MCP.mix_formula option)
    (join_id: CP.spec_var option) pos pid
  : (list_context * proof) =
  let slk_entail ctx conseq = heap_entail_conjunct_lhs_struc_x p is_folding
      has_post ctx conseq tid delayed_f join_id pos pid in
  (* WN : to log sleek commands here *)
  let pr x = (match x with Ctx _ -> "Ctx " | OCtx _ -> "OCtx ")
             ^ (Cprinter.string_of_context x) in
  Debug.no_2 "heap_entail_conjunct_lhs_struc"
    pr (Cprinter.string_of_struc_formula)
    (fun (a,b) -> Cprinter.string_of_list_context a)
    slk_entail ctx conseq

and heap_entail_conjunct_lhs_struc_x (prog : prog_decl)  (is_folding : bool) (has_post:bool) (ctx_00 : context)
    (conseq : struc_formula) (tid: CP.spec_var option) (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos pid : (list_context * proof) =
  let fv_s = CF.struc_fv ~vartype:Global_var.var_with_heap_only conseq in
  let impl_expl_vs = CF.collect_impl_expl_evars_context ctx_00 in
  let fv_s = CP.diff_svl fv_s (impl_expl_vs(* @evars_rhs *)) in
  if fv_s!=[]  then
    begin
      let msg = ("FREE VAR IN HEAP RHS :"^(!CP.print_svl fv_s)) in
      let () = x_tinfo_pp msg no_pos in
      (* let () = print_endline_quiet ((add_str "\nimpl/expl/evars vars" !CP.print_svl) impl_expl_vs) in
       * let () = print_endline_quiet ((add_str "LHS" Cprinter.string_of_context_short) ctx_00) in
       * let () = print_endline_quiet ((add_str "RHS" Cprinter.string_of_struc_formula) conseq) in *)
      if !Globals.warn_free_vars_conseq then
        failwith msg
      else ()
    end;
  let rec helper_inner i (ctx11: context) (f: struc_formula) : list_context * proof =
    Debug.no_2_num i (*loop*) "helper_inner" Cprinter.string_of_context Cprinter.string_of_struc_formula (fun (lc, _) -> Cprinter.string_of_list_context lc)
      (helper_inner_x) ctx11 f

  and helper_inner_x (ctx11 : context) (f:struc_formula) : list_context * proof =
    x_tinfo_pp ("ctx: " ^ (Cprinter.string_of_context ctx11)) pos;
    let () = x_tinfo_hp (add_str "f: " Cprinter.string_of_struc_formula) f no_pos in
    begin
      match ctx11 with (*redundant check*)
      | OCtx _ -> report_error post_pos#get ("[inner entailer" ^"] unexpected dealing with OCtx \n" ^ (Cprinter.string_of_context_short ctx11))
      | Ctx es -> ();
        let exec () =
          let () = x_tinfo_pp "inferring case Ctx esssss\n" no_pos in
          begin
            (**************** <<< Perform check when join *******)
            (****************************************************)
            (match join_id with
             | Some id ->
               let () = x_binfo_pp "inferring join_id some id\n" no_pos in
               let res,ctx_option = find_thread_delayed_resource es es.CF.es_formula id pos in
               (match res, ctx_option with
                | _ , Some ctx -> ctx (*often error ctx*)
                | Some (delayed_f,post,res2,new_es_f), _ ->
                  if (CP.isConstTrue delayed_f) then
                    (*if delayed_f is trivial -> no need to check*)
                    let () = x_dinfo_pp ("Delayed lockset constraints trivially satisfiable\n " ^ "\n") pos in
                    compose_thread_post_condition prog es new_es_f post res2 pos
                  else
                    let rs,prf = delayed_lockset_checking prog es new_es_f delayed_f post res2 pos in
                    (if (CF.isFailCtx rs) then
                       (*FAIL to satisfy the delayed constraints*)
                       (*TO CHECK: become FALSE, which may not good enough*)
                       let rs = CF.add_error_message_list_context "[[[DELAYED CHECKING FAILURE]]]" rs in
                       rs,prf
                     else
                       let () = x_dinfo_pp ("Delayed lockset constraints satisfiable\n " ^ "\n") pos in
                       (*******<<<Checking the delayed constraints at join point*****)
                       (*if checking succeeds --> proceed as normal*)
                       compose_thread_post_condition prog es new_es_f post res2 pos
                    ) (*END (if (CF.isFailCtx rs) then*)
                | _ ->
                  let error_msg = ("Join with thread with id = " ^ (Cprinter.string_of_spec_var id) ^" : unexpected ") in
                  (mkFailCtx_simple error_msg es (CF.mkTrue_nf pos) (mk_cex true) pos, Failure)
               ) (*END match res, ctx_option with *)
             | None ->
               let () = x_dinfo_pp "inferring join_id none\n" no_pos in
               (****************************************************)
               (**************** <<< Perform check when join *******)
               match f with
               | ECase b   ->
                 let () = x_tinfo_pp "inferring f ecase\n" no_pos in
                 let ctx = add_to_context_num 1 ctx11 "case rule" in
                 let ivs = collect_infer_vars ctx11 in
                 let case_brs = b.formula_case_branches in
                 let case_vs = match case_brs with
                   | [] -> []
                   | (p,_)::_ -> CP.fv p in
                 let d = CP.diff_svl case_vs ivs in
                 let combinator f ctx=
                   let f = (MCP.memoise_add_pure_N (MCP.mkMTrue pos) f) in
                   if !Globals.delay_case_sat then transform_context (combine_es_and prog f true) ctx
                   else
                     Wrapper.wrap_one_bool Globals.unsat_consumed_heap true
                       (combine_context_and_unsat_now prog ctx) f in
                 if (d==[] && case_vs!=[] && !Globals.infer_case_as_or_flag) then
                   begin
                     let () = x_tinfo_pp "inferring case imprecisely " no_pos in
                     let rs = List.map (fun (c1,c2) ->
                         (combinator c1 ctx, c1, c2)) case_brs in
                     (* remove away false context : need to keep at least one? *)
                     let rs2 = List.filter (fun (c1,_,_) -> not(isAnyFalseCtx c1)) rs in
                     let rs = if rs2==[] then [List.hd rs] else rs2 in
                     let res = List.map (fun (ctx,p,rhs) ->
                         let ctx = prune_ctx prog ctx in
                         let (r,prf) = x_add helper_inner 9 ctx rhs in
                         (* add infer_pure to result ctx in *)
                         let r = x_add add_infer_pure_to_list_context [p] r in
                         (r,prf)) rs in
                     let rez1, rez2 = List.split res in
                     let rez1 = List.fold_left (fun a c -> list_context_union a c) (List.hd rez1) (List.tl rez1) in
                     (rez1, (mkCaseStep ctx f rez2))
                   end
                 else if case_brs==[] then ((SuccCtx [ctx]),TrueConseq)
                 else
                   let () = x_tinfo_pp "inferring case precisely " no_pos in
                   let rec helper l = match l with
                     | [] -> None
                     | (p,e)::t ->
                       let tt = (syn_imply ctx p) in
                       if tt then Some (p,e) else helper t in
                   (* Find the branch whose condition is satisfied by the current context *)
                   (* Because these conditions are disjoint, the context can
                      only satisfy at most one condition *)
                   let r = helper case_brs in
                   let r = match r with
                     | None -> begin
                         List.map (fun (c1, c2) ->
                             let n_ctx = combinator c1 ctx in
                             (*this unsat check is essential for completeness of result*)
                             (*should return Failure bot instead*)
                             if (isAnyFalseCtx n_ctx) then
                               let es = CF.estate_of_context n_ctx no_pos in
                               let err_msg = "31. proving precondtition: unreachable" in
                               let fe = mk_failure_bot err_msg Globals.undefined_error in
                               (CF.mkFailCtx_in (Basic_Reason ({fc_message =err_msg;
                                                                fc_current_lhs  = es;
                                                                fc_current_ents = [];
                                                                fc_prior_steps = es.es_prior_steps;
                                                                fc_orig_conseq = f ;
                                                                fc_current_conseq = CF.formula_of_heap HFalse pos;
                                                                fc_failure_pts =  [];}, fe, es.es_trace)) (es, err_msg, Failure_Bot err_msg) (mk_cex true), UnsatAnte)
                             else
                               x_add helper_inner 2 (prune_ctx prog n_ctx) c2) case_brs
                       end
                     | Some (p, e) -> begin
                         [x_add helper_inner 3 ctx e] end in
                   let rez1, rez2 = List.split r in
                   let rez1 = List.fold_left (fun a c -> or_list_context (*list_context_union*) a c) (List.hd rez1) (List.tl rez1) in
                   (rez1, (mkCaseStep ctx f rez2))
               | EBase ({
                   formula_struc_explicit_inst = expl_inst;
                   formula_struc_implicit_inst = impl_inst;
                   formula_struc_exists = base_exists;
                   formula_struc_base = formula_base;
                   formula_struc_continuation = formula_cont;
                   formula_struc_is_requires = is_requires;
                 } as b) ->begin
                   let () = x_tinfo_pp "inferring ebase \n" no_pos in
                   let vn_opt= CF.is_only_viewnode true formula_base in
                   let need_unfold, pr_views ,args, unk_hps= match vn_opt with
                     | Some vn ->
                       let pr_views,unk_hps = need_unfold_rhs prog vn in
                       if unk_hps = [] || pr_views = [] then
                         (false, [], [],[])
                       else
                         (true, pr_views,vn.CF.h_formula_view_node::vn.CF. h_formula_view_arguments,unk_hps)
                     | None -> (false, [], [], [])
                   in
                   if need_unfold then
                     let () = x_binfo_pp "need_unfold \n" no_pos in
                     let nf = CF.do_unfold_view prog pr_views formula_base in
                     let fs = CF.list_of_disjs nf in
                     let struc_disj = List.map (fun f ->
                         let svl = CP.remove_dups_svl (CF.fv f) in
                         let ex_svl = List.filter (fun sv -> not (CP.is_hprel_typ sv)) (CP.diff_svl svl args) in
                         (Label_only.empty_spec_label_def,
                          CF.EBase {b with CF.formula_struc_base = f;
                                           CF.formula_struc_implicit_inst = CP.remove_dups_svl (b.CF.formula_struc_implicit_inst@ex_svl);
                                   })) fs in
                     let n_struc_f = CF.EList struc_disj in
                     let n_ctx = match ctx11 with
                       | OCtx _ -> report_error post_pos#get ("[inner entailer" ^"] unexpected dealing with OCtx \n" ^ (Cprinter.string_of_context_short ctx11))
                       | Ctx es -> Ctx {es with
                                        CF.es_infer_vars_hp_rel = CP.remove_dups_svl (es.CF.es_infer_vars_hp_rel@unk_hps);
                                        CF.es_infer_vars_sel_post_hp_rel = CP.remove_dups_svl (es.CF.es_infer_vars_sel_post_hp_rel@unk_hps);
                                       }
                     in
                     x_add helper_inner 14 n_ctx n_struc_f
                   else
                     let () = x_tinfo_pp "else inferring ebase \n" no_pos in
                     let rel_args = CF.get_rel_args formula_base in
                     let () = DD.tinfo_zprint  (lazy  ("  formula_base: " ^ (Cprinter.string_of_formula formula_base))) pos in
                     let formula_base = if CF.check_rel_args_quan_clash rel_args formula_base then
                         CF.elim_exists formula_base
                       else formula_base
                     in
                     if (List.length base_exists) > 0 then
                       let ws = CP.fresh_spec_vars base_exists in
                       let st = List.combine base_exists ws in
                       let new_struc = subst_struc st (EBase {b with formula_struc_exists = []})in
                       let new_ctx = push_exists_context ws ctx11 in
                       let nc, np = x_add helper_inner 4 new_ctx new_struc in
                       (nc, (mkEexStep ctx11 f np))
                     else
                       let () = x_tinfo_pp "list length base exists else \n" no_pos in
                       let n_ctx = (push_expl_impl_context expl_inst impl_inst ctx11 ) in
                       (*delayed lockset constraints*)
                       let cont_fn () =
                         match tid with
                         | None ->
                           let () = x_tinfo_pp "tid None \n" no_pos in
                           let n_ctx_list, prf = x_add heap_entail_one_context 13 prog (if formula_cont!=None then true else is_folding) n_ctx formula_base None None None pos in
                           (n_ctx_list, prf, None)
                         | Some id ->
                           let () = x_tinfo_pp "Some id \n" no_pos in
                           if (not !Globals.allow_ls) then
                             let n_ctx_list, prf = x_add heap_entail_one_context 14 prog (if formula_cont!=None then true else is_folding) n_ctx formula_base None None None pos in
                             (n_ctx_list, prf ,None)
                           else
                             (match delayed_f with
                              | Some mf ->
                                (* TO CHECK : if already has a delayed formula. propagate*)
                                let n_ctx_list, prf = x_add heap_entail_one_context 15 prog (if formula_cont!=None then true else is_folding) n_ctx formula_base tid delayed_f join_id pos in
                                (n_ctx_list, prf,delayed_f)
                              | None ->
                                (*Identify delayed constraints and propagate*)
                                let evars = CF.get_exists_context n_ctx in (*get exists vars from context*)
                                (*partion the post-condition based on LS*)
                                let df,new_formula_base = partLS (evars@impl_inst@expl_inst) formula_base in
                                (* let () = print_endline ("delayed formula df = " ^ (Cprinter.string_of_mix_formula df)) in *)
                                let n_ctx_list, prf = x_add heap_entail_one_context 16 prog (if formula_cont!=None then true else is_folding) n_ctx new_formula_base tid (Some df) join_id pos in
                                (n_ctx_list, prf ,Some df)
                             )
                       in
                       (* always do nonclassical reasoning whenever there is continuation in struct formula *)
                       (* let saved_classic_setting = !do_classic_frame_rule in *)
                       let n_ctx_list, prf, new_delayed_f =
                         if (CF.is_pre_post_cont formula_cont)
                         then Wrapper.wrap_classic x_loc (Some false) cont_fn ()
                         else cont_fn ()
                       in
                       let n_ctx_list = pop_expl_impl_context expl_inst impl_inst n_ctx_list in
                       (match n_ctx_list with
                        | FailCtx _ ->
                          if not is_requires then (n_ctx_list, prf) else
                          if is_en_error_exc_ctx n_ctx then
                            let err_ctx_list = Musterr.convert_list_context prog n_ctx_list in
                            let () = x_tinfo_hp (add_str "err_ctx_list" (Cprinter.string_of_list_context)) err_ctx_list no_pos in
                            (err_ctx_list, prf)
                          else (n_ctx_list, prf)
                        | SuccCtx _ ->
                          let () = x_tinfo_hp (add_str "n_ctx_list: " (Cprinter.string_of_list_context)) n_ctx_list no_pos in
                          let res_ctx, res_prf = match formula_cont with
                            | Some l -> x_add heap_entail_struc prog is_folding has_post n_ctx_list l tid new_delayed_f join_id pos pid (*also propagate tid*)
                            | None -> (n_ctx_list, prf) in
                          x_tinfo_hp (add_str "after pre 0: " (Cprinter.string_of_list_context)) res_ctx no_pos;
                          let res_ctx = if !wrap_exists_implicit_explicit then push_exists_list_context (expl_inst@impl_inst) res_ctx else res_ctx in
                          x_tinfo_hp (add_str "after pre 1: " (Cprinter.string_of_list_context)) res_ctx no_pos;
                          (res_ctx,res_prf)
                       )
                 end
               | EAssume {
                   formula_assume_simpl = post;
                   formula_assume_vars = ref_vars;
                   formula_assume_lbl = (i,y);} ->
                 x_tinfo_pp ("EAssune: " ^ (Cprinter.string_of_context ctx11)) pos;
                 x_tinfo_pp ("EAssune post: " ^ (Cprinter.string_of_formula post)) pos;
                 if not has_post then report_error pos ("malfunction: this formula "^ y ^" does not have a post condition!")
                 else
                   (match tid with
                    | Some id ->
                      (*ADD POST CONDITION as a concurrent thread in formula_*_and*)
                      let df = match delayed_f with
                        | None -> (MCP.mkMTrue pos)
                        | Some mf -> mf
                      in
                      let new_post = CF.removeLS post in
                      (*donot rename lockset variable when fork*)
                      let new_ref_vars = List.filter (fun v ->
                          let vname = CP.name_of_spec_var v in
                          vname <> Globals.ls_name && vname <> Globals.lsmu_name
                        ) ref_vars in
                      let rs2 = if (!Globals.allow_threads_as_resource) then
                          (*Threas as resource*)
                          let dl = CP.remove_redundant (MCP.pure_of_mix df) in
                          let ht = CF.mkThreadNode (CP.mkRes Globals.thrd_typ) Globals.thrd_name false SPLIT0 None [] true new_post dl None pos in
                          let f = CF.formula_of_heap ht no_pos in
                          let rs1 = compose_context_formula ctx11 f new_ref_vars true Flow_replace pos in
                          rs1
                        else
                          (*Threads as AND-conj*)
                          let f = CF.formula_of_pure_N (CP.mkEqVar (CP.mkRes thread_typ) id pos) pos in
                          let rs1 = CF.transform_context (normalize_es f pos true) ctx11 in
                          (*add the post condition into formul_*_and  special compose_context_formula for concurrency*)
                          let rs2 = compose_context_formula_and rs1 new_post df id new_ref_vars pos in
                          rs2
                      in

                      let rs3 = add_path_id rs2 (pid,i) (-1) in
                      let rs4 = prune_ctx prog rs3 in
                      ((SuccCtx [rs4]),TrueConseq)
                    | None ->
                      begin
                        (*check reachable or not*)
                        (*let ctx1,_= x_add heap_entail_one_context prog is_folding ctx11 (mkTrue_nf pos) pos in*)
                        x_tinfo_zp (lazy  ("  before consume post ctx11: " ^ (Cprinter.string_of_context ctx11))) pos;
                        let rs = clear_entailment_history (fun x -> Some (x_add xpure_heap_symbolic 6 prog x (MCP.mkMTrue no_pos) 0)) ctx11 in (* andreeac: why also clear hole info? *)
                        x_tinfo_pp ("rs: " ^ (Cprinter.string_of_context rs)) pos;
                        (* print_endline ("CTX11: " ^ (!print_context ctx11)); *)
                        (* print_endline ("RS CTX: " ^ (!print_context rs)); *)
                        (*************Compose variable permissions >>> ******************)
                        if (!Globals.ann_vp) then
                          x_dinfo_zp (lazy ("\nheap_entail_conjunct_lhs_struc: before checking VarPerm in EAssume:"^ "\n ###rs =" ^ (Cprinter.string_of_context rs)^ "\n ###f =" ^ (Cprinter.string_of_struc_formula f)^"\n")) pos;
                        (* TODO: VPerm *)
                        (* let full_vars = get_varperm_formula post VP_Full in *)
                        (* let new_post = drop_varperm_formula post in         *)
                        let full_vars = [] in
                        let new_post = post in
                        let add_vperm_full es =
                          let zero_vars = es.es_var_zero_perm in
                          let tmp = Gen.BList.difference_eq CP.eq_spec_var_ident full_vars zero_vars in
                          (*TO CHECK: reuse es_pure with care*)
                          (*currently, only extract constraints that
                            are not related to LS,waitlevel,float,varperm*)
                          (* let es_p = MCP.drop_varperm_mix_formula es.es_pure in *)
                          let es_p = es.es_pure in
                          (* let es_p = MCP.removeLS_mix_formula es_p in *)
                          let es_p = MCP.drop_float_formula_mix_formula es_p in
                          let es_p = MCP.drop_svl_mix_formula es_p [(CP.mkWaitlevelVar Unprimed);(CP.mkWaitlevelVar Primed)] in
                          let new_f = CF.add_mix_formula_to_formula es_p es.es_formula in
                          (****************)
                          if (tmp!=[]) then
                            (*all @full in the conseq should be in @zero in the ante*)
                            (x_dinfo_pp ("heap_entail_conjunct_lhs_struc: failed in adding " ^ (string_of_vp_ann VP_Full) ^ " variable permissions in conseq: " ^
                                         (Cprinter.string_of_spec_var_list tmp)^ "is not " ^(string_of_vp_ann VP_Zero)) pos;
                             Ctx {es with es_formula = mkFalse_nf pos})
                          else Ctx {es with
                                    es_formula = new_f;
                                    es_pure = MCP.mkMTrue pos;
                                    CF.es_var_zero_perm= Gen.BList.difference_eq CP.eq_spec_var_ident zero_vars full_vars;}
                        in
                        (*TO DO: add_vperm_full only when VPERM*)
                        let rs = if (!Globals.ann_vp) then
                            CF.transform_context add_vperm_full rs
                          else rs
                        in
                        (* let () = print_endline ("\n### rs = "^(Cprinter.string_of_context rs)) in *)

                        (************* <<< Compose variable permissions******************)
                        (* TOCHECK : why compose_context fail to set unsat_flag? *)
                        let ls_var = CP.mkLsVar Primed in
                        let lsmu_var = CP.mkLsmuVar Primed in
                        (*sequential spec does not have LOCKSET*)
                        (*this is similar to adding ls'=ls in the post-cond
                          of each spec*)
                        let post_fv = CF.fv new_post in
                        let new_ref_vars,new_post = if Gen.BList.mem_eq CP.eq_spec_var_ident ls_var post_fv
                          then (*if LOCKSET ghost var is in the post-condition*)
                            let waitlevel_var = CP.mkWaitlevelVar Primed in
                            let new_post =
                              if !Globals.allow_locklevel then
                                CF.translate_waitlevel_formula new_post
                              else
                                CF.drop_svl new_post [waitlevel_var]
                            in
                            (ls_var::lsmu_var::ref_vars),new_post
                          else (*if not -> do not consider ls_var as a ref-vars*)
                            ref_vars,new_post
                        in
                        let compose_context_formula_fnc= if (* CF.is_en_error_exc es && *) not (is_dis_error_exc es) then compose_context_formula_norm_flow else compose_context_formula in
                        let rs1 = compose_context_formula_fnc rs new_post new_ref_vars true Flow_replace pos in
                        (* print_endline ("RS CTX: " ^ (!print_context rs)); *)
                        (* print_endline ("RS1 CTX: " ^ (!print_context rs1)); *)
                        let rs1 = CF.transform_context (fun es -> CF.subst_hvar_es es es.CF.es_ho_vars_map) rs1 in
                        let f_waitS_rel es = {es with CF.es_formula = CF.translate_waitS_rel es.CF.es_formula;} in
                        let rel_sv = CP.mk_spec_var Globals.waitS_name in
                        let rs1 =
                          if (Gen.BList.mem_eq CP.eq_spec_var_ident rel_sv post_fv)
                          then CF.transform_context (fun es -> CF.Ctx (f_waitS_rel es)) rs1
                          else rs1
                        in
                        let rs1 = if !Globals.perm = Dperm then normalize_context_perm prog rs1 else rs1 in
                        let rs2 = if !Globals.force_post_sat then CF.transform_context (x_add elim_unsat_es_now 5 prog (ref 1)) rs1 else rs1 in
                        if (!Globals.ann_vp) then
                          x_dinfo_zp (lazy ("\nheap_entail_conjunct_lhs_struc: after checking VarPerm in EAssume: \n ### rs = "^(Cprinter.string_of_context rs2)^"\n")) pos;
                        let rs3 = add_path_id rs2 (pid,i) (-1) in
                        (* let () = print_endline ("\n### rs3 = "^(Cprinter.string_of_context rs3)) in *)
                        let rs4 = prune_ctx prog rs3 in
                        (* let () = print_endline ("\n### rs4 = "^(Cprinter.string_of_context rs4)) in *)
                        (*********CHECK db-consistency***********)
                        let hfv = (CF.fv_heap_of new_post) in
                        let bfv = List.filter (fun v -> (CP.type_of_spec_var v) = barrierT)  hfv in
                        let has_barriers = if (!Globals.perm = Bperm) then
                            if (bfv != [])  then true
                            else false
                          else false
                        in
                        (*normalize until a fixpoint is reached*)
                        let rs4 = if (has_barriers)
                          then transform_context (normalize_entail_state_w_lemma prog) rs4
                          else rs4
                        in
                        let res = if (has_barriers) then
                        (* check_barrier_inconsistency_context prog rs4
                         Note that rs4 was already normalized in previous step *)
                            let res,prf = check_barrier_inconsistency_context_svl prog rs4 bfv pos in
                            if (isFailCtx res) then Some (res,prf)
                            else None
                          else None
                        in
                        let res,rs4 =
                          if (res=None && !Globals.allow_exhaustive_norm) then
                            let tmp = transform_context (prop_entail_state_w_lemma prog) rs4 in
                            let tmp = transform_context (normalize_entail_state_w_lemma prog) tmp in
                            let res_norm = check_consistency_context prog tmp pos in
                            (res_norm,tmp)
                          else res,rs4
                        in
                        match res with
                        | Some res -> res
                        | None ->
                          let helper ctx postcond=
                            let es =  CF.estate_of_context ctx pos in
                            (CF.estate_of_context ctx pos, CF.get_lines ((CF.list_pos_of_formula es.CF.es_formula) @ (CF.list_pos_of_formula postcond)))
                          in
                          (*TO CHECK: this invert_ctx is supposed to deal with
                            non-disjunctive post-condition and non-OR ctx*)
                          let invert_ctx ctx postcond=
                            (*TO CHECK: what if post-cond has disjuntive form??? __norm or __exc
                              At the moment, flow_formula_of_formula throws an exception*)
                            (* TO CHECK: temporarily ignore this invert_ctx if
                               disj post-cond or Or-Ctx*)
                            if ((disj_count postcond > 1) || (not (is_one_context ctx))) then (SuccCtx [ctx]) else
                              let fl = CF.flow_formula_of_formula postcond in
                              if false then
                                (* if CF.equal_flow_interval fl.CF.formula_flow_interval !top_flow_int then *)
                                let es, ll = helper ctx postcond in
                                let fl = CF.get_top_flow postcond in
                                let err_name = (exlist # get_closest fl.CF.formula_flow_interval) in
                                let err_msg = "may_err (" ^ err_name ^ ") LOCS: [" ^ (Cprinter.string_of_list_int ll) ^ "]"in
                                let fe = mk_failure_may err_msg
                                    Globals.fnc_error in
                                let ctx =
                                  FailCtx ((Basic_Reason ({fc_message =err_msg;
                                                           fc_current_ents = [];
                                                         fc_current_lhs  = {es with es_formula = CF.substitute_flow_into_f !top_flow_int es.es_formula};
                                                         fc_prior_steps = es.es_prior_steps;
                                                         fc_orig_conseq = f ;
                                                         fc_current_conseq = post;
                                                         fc_failure_pts =  [];}, fe, es.es_trace)), Ctx ({es with es_formula = CF.substitute_flow_into_f !top_flow_int es.es_formula}),(mk_cex false))
                                in
                                let pr1 = Cprinter.string_of_list_context in
                                let () = x_binfo_hp (add_str "rs: " pr1) ctx no_pos in
                                ctx
                              else if x_add_1 CF.is_error_flow postcond then
                                let es, ll = helper ctx postcond in
                                let fl = CF.get_error_flow postcond in
                                let err_name = (exlist # get_closest fl.CF.formula_flow_interval) in
                                let err_msg = "must_err (" ^ err_name ^") LOCS: [" ^ (Cprinter.string_of_list_int ll) ^ "]"in
                                let fe = mk_failure_must err_msg Globals.fnc_error in
                                let ctx =
                                  FailCtx ((Basic_Reason ({fc_message =err_msg;
                                                           fc_current_ents = [];
                                                         fc_current_lhs  = {es with es_formula = CF.substitute_flow_into_f !error_flow_int es.es_formula};
                                                         fc_prior_steps = es.es_prior_steps;
                                                         fc_orig_conseq  = f;
                                                         fc_current_conseq = post;
                                                         fc_failure_pts =  [];}, fe, es.es_trace)),Ctx {es with es_formula = CF.substitute_flow_into_f !error_flow_int es.es_formula},(mk_cex false) )
                                in
                                let pr1 = Cprinter.string_of_list_context in
                                let () = x_binfo_hp (add_str "rs: " pr1) ctx no_pos in
                                ctx

                              else if CF.is_mayerror_flow postcond then
                                let es, ll = helper ctx postcond in
                                let fl = CF.get_error_flow postcond in
                                let err_name = (exlist # get_closest fl.CF.formula_flow_interval) in
                                let err_msg = "may_err (" ^ err_name ^") LOCS: [" ^ (Cprinter.string_of_list_int ll) ^ "]"in
                                let fe = mk_failure_may err_msg Globals.fnc_error in
                                FailCtx ((Basic_Reason ({fc_message =err_msg;
                                                         fc_current_ents = [];
                                                         fc_current_lhs  = {es with es_formula = CF.substitute_flow_into_f !mayerror_flow_int es.es_formula};
                                                         fc_prior_steps = es.es_prior_steps;
                                                         fc_orig_conseq  = f;
                                                         fc_current_conseq = post;
                                                         fc_failure_pts =  [];}, fe, es.es_trace)),Ctx {es with es_formula = CF.substitute_flow_into_f !error_flow_int es.es_formula},(mk_cex false) )
                              else
                                (SuccCtx [ctx])
                          in
                          (******************************************************)
                          (* let () = print_endline ("### rs4 (2) = "^(Cprinter.string_of_context rs4)) in *)
                          if not !Globals.disable_failure_explaining && not !Globals.enable_error_as_exc && not (CF.is_dis_error_exc_ctx rs4) &&
                             not (infer_const_obj # is_dis_err) then
                            let tmp_lctx = invert_ctx rs4 new_post in
                            (* let () = print_endline ("### tmp_lctx = "^(Cprinter.string_of_list_context tmp_lctx)) in *)
                            (tmp_lctx ,TrueConseq)
                          else (SuccCtx [rs4] ,TrueConseq)
                      end)
               | EInfer e ->
                 let inf_vars = e.CF.formula_inf_vars in
                 let templ_inf_vars = List.filter (fun (CP.SpecVar (t, _, _)) -> is_FuncT t) inf_vars in
                 let ctx11 = CF.add_infer_vars_templ_ctx ctx11 templ_inf_vars in
                 x_add helper_inner 22 ctx11 e.Cformula.formula_inf_continuation
               (* ignores any EInfer on the RHS *)
               (* assumes each EInfer contains exactly one continuation *)
               (* TODO : change the syntax of EInfer? *)
               | EList b ->
                 if (List.length b) > 0 then
                   (* let () = print_endline ("### xxx ELIST") in *)
                   let () = x_tinfo_zp  (lazy  ("  f: " ^ (Cprinter.string_of_struc_formula f))) pos in
                   let ctx = CF.add_to_context_num 2 ctx11 "para OR on conseq" in
                   let conseq = CF.Label_Spec.filter_label_rec (get_ctx_label ctx) b in
                   if (List.length conseq) = 0 then
                     let err_msg = "group label mismatch" in
                     (CF.mkFailCtx_in(Trivial_Reason (CF.mk_failure_must err_msg Globals.sl_error, es.es_trace))
                        ({es with es_formula = CF.substitute_flow_into_f !error_flow_int es.es_formula}, err_msg, Failure_Must err_msg)
                        (mk_cex true), UnsatConseq)
                   else
                     let cur_is_rhs_emp = !rhs_rest_emp in
                     let l1,l2 = List.split (List.map (fun c->
                         let () = rhs_rest_emp := cur_is_rhs_emp in
                         x_add helper_inner 10 ctx (snd c)
                       ) conseq) in
                     ((fold_context_left 42 l1),(mkCaseStep ctx (EList conseq) l2))
                 else
                   let err_msg = "struc conseq is [] meaning false" in
                   (CF.mkFailCtx_in(Trivial_Reason (CF.mk_failure_must err_msg Globals.sl_error, es.es_trace)) ({es with es_formula = CF.substitute_flow_into_f !error_flow_int es.es_formula}, err_msg, Failure_Must err_msg) (mk_cex true) , UnsatConseq)
                   (* TODO : can do a stronger falsity check on LHS *)
            ) (* END match join_id with *)
          end
        in wrap_trace es.es_path_label exec () (*exec ()*)
    end	in
  x_add helper_inner 8 ctx_00 conseq

and heap_entail_split_rhs (prog : prog_decl) (is_folding : bool) (ctx_0 : context) (conseq : formula)
    (rhs_h_matched_set: CP.spec_var list) pos : (list_context * proof) =
  let pr = Cprinter.string_of_formula in
  let pr2 = fun (lc,_) -> Cprinter.string_of_list_context lc in
  DD.no_1 "heap_entail_split_rhs" pr pr2 (fun _ -> heap_entail_split_rhs_x prog is_folding ctx_0 conseq rhs_h_matched_set pos) conseq

and heap_entail_split_rhs_x (prog : prog_decl) (is_folding : bool) (ctx_0 : context) (conseq : formula)
    (rhs_h_matched_set: CP.spec_var list) pos : (list_context * proof) =
  let ctx_with_rhs = let h, pure_rhs, vp, fl, t, a  = CF.split_components conseq in
    let eqns = (MCP.ptr_equations_without_null pure_rhs) in
    let rhs_p = MCP.pure_of_mix pure_rhs in
    CF.set_context (fun es -> {es with es_rhs_eqset=(es.es_rhs_eqset@eqns);}) ctx_0 in
  let helper ctx_00 h pure_rhs (func : CF.h_formula -> MCP.mix_formula -> CF.formula) =
    if not(Mem.check_mem_sat h prog.prog_view_decls)
    then (match ctx_00 with
        | Ctx estate ->
          let msg = "Memory Spec Error Conseq Heap not Satisfiable" in
          let fail_ctx = (mkFailContext msg estate conseq None pos) in
          let fail_ex = {fe_kind = Failure_Must msg; fe_name = Globals.logical_error;fe_locs=[]}
          in mkFailCtx_in (Basic_Reason (fail_ctx,fail_ex, estate.es_trace)) ({estate with es_formula = CF.substitute_flow_into_f !error_flow_int estate.es_formula}, msg, Failure_Must msg) (mk_cex true), UnsatConseq
        | _ -> report_error no_pos ("[solver.ml]: No disjunction on the RHS should reach this level\n"))
    else
      let h1, h2 = x_add_1 Mem.split_heap h in
      if (is_empty_heap h1) && (is_empty_heap h2)
      then x_add heap_entail_conjunct 12 prog is_folding ctx_00 conseq rhs_h_matched_set pos
      else
      if(is_empty_heap h1) && not(Mem.contains_conj h2) then
        let new_conseq = func h2 pure_rhs in
        x_add heap_entail_conjunct 13 prog is_folding ctx_00 new_conseq rhs_h_matched_set pos
      else if (is_empty_heap h2) && not(Mem.contains_conj h1) then
        let new_conseq = func h1 pure_rhs in
        x_add heap_entail_conjunct 13 prog is_folding ctx_00 new_conseq rhs_h_matched_set pos
      else
      if(is_empty_heap h2) then (* D |- h1 = D1 /\ h2 = HEmp*)
        let new_conseq = func h1 (MCP.mkMTrue pos) in
        let after_h1_ctx, after_h1_prfs = heap_entail_split_lhs prog is_folding ctx_00 new_conseq rhs_h_matched_set pos in
        match after_h1_ctx with
        | FailCtx _ -> (after_h1_ctx,after_h1_prfs)
        | SuccCtx (cl) -> let entail_p = List.map (fun c -> one_ctx_entail prog is_folding c conseq func pure_rhs pos) cl
          in
          let entail_p_ctx,entail_p_prf = List.split entail_p in
          let entail_p_prf = mkContextList cl (Cformula.struc_formula_of_formula conseq pos) entail_p_prf in
          let entail_p_ctx = fold_context_left 1 entail_p_ctx in
          (entail_p_ctx,entail_p_prf)
      else (* D |- h1 = D1 /\ h2 = D2 *)
        let after_h1_ctx, after_h1_prfs =
          (heap_entail_split_lhs prog is_folding ctx_00 (func h1 (MCP.mkMTrue pos)) rhs_h_matched_set pos) in
        match after_h1_ctx with
        | FailCtx _ -> (after_h1_ctx,after_h1_prfs)
        | SuccCtx (cl) -> let (ctx,prf) =
                            (match h2 with
                             | HTrue -> (after_h1_ctx,after_h1_prfs)
                             | _ -> let res = (* h2 may contain nested conjs *)
                                      List.map
                                        (fun c -> heap_entail_split_rhs prog is_folding c (func h2 pure_rhs) rhs_h_matched_set pos) cl
                               in
                               let res_ctx,res_prf = List.split res in
                               let res_prf = mkContextList cl (Cformula.struc_formula_of_formula conseq pos) res_prf in
                               let res_ctx = fold_context_left 2 res_ctx in
                               (res_ctx,res_prf))
          in ctx,prf
  in

  x_dinfo_zp (lazy ("heap_entail_split_rhs:
                            \nante:\n"
                    ^ (Cprinter.string_of_context ctx_0)
                    ^ "\nconseq:\n"
                    ^ (Cprinter.string_of_formula conseq))) pos;

  match ctx_0 with
  | Ctx estate -> begin
      let ante = estate.es_formula in
      match ante with
      | Exists ({formula_exists_qvars = qvars;
                 formula_exists_heap = qh;
                 formula_exists_pure = qp;
                 formula_exists_vperm = qvp;
                 formula_exists_type = qt;
                 formula_exists_flow = qfl;
                 formula_exists_pos = pos}) ->
        (* ws are the newly generated fresh vars for the existentially quantified vars in the LHS *)
        let ws = CP.fresh_spec_vars qvars in
        (* new ctx is the new context after substituting the fresh vars for the exist quantified vars *)
        let new_ctx = eliminate_exist_from_LHS qvars qh qp qvp qt qfl pos estate in
        (* call the entailment procedure for the new context - with the existential vars substituted by fresh vars *)
        let rs, prf1 =  heap_entail_split_rhs prog is_folding  new_ctx conseq rhs_h_matched_set pos in
        let new_rs =
          if !Globals.wrap_exist then
            (* the fresh vars - that have been used to substitute the existenaltially quantified vars - need to be existentially quantified after the entailment *)
            (add_exist_vars_to_ctx_list rs ws)
          else
            rs
        in
        (* log the transformation for the proof tracere *)
        let prf = mkExLeft ctx_0 conseq qvars ws prf1 in
        (new_rs, prf)
      | _ -> begin
          match conseq with
          | Base(bf) ->
            let h, p, vp, fl, t, a = CF.split_components conseq in
            helper ctx_with_rhs (* ctx_0 *) h p (fun xh xp -> CF.mkBase xh xp vp t fl a pos)
          | Exists ({formula_exists_qvars = qvars;
                     formula_exists_heap = qh;
                     formula_exists_pure = qp;
                     formula_exists_vperm = qvp;
                     formula_exists_type = qt;
                     formula_exists_flow = qfl;
                     formula_exists_and = qa;
                     formula_exists_pos = pos}) ->
            (* quantifiers on the RHS. Keep them for later processing *)
            let ws = CP.fresh_spec_vars qvars in
            let st = List.combine qvars ws in
            let baref = mkBase qh qp qvp qt qfl qa pos in
            let new_baref = x_add subst st baref in
            let new_ctx = Ctx {estate with es_evars = ws @ estate.es_evars} in
            let tmp_rs, tmp_prf = heap_entail_split_rhs prog is_folding  new_ctx new_baref rhs_h_matched_set pos
            in
            (match tmp_rs with
             | FailCtx _ -> (tmp_rs, tmp_prf)
             | SuccCtx sl ->
               let prf = mkExRight ctx_0 conseq qvars ws tmp_prf in
               let todo_unk = List.map (redundant_existential_check ws) sl in
               let res_ctx =
                 if !Globals.elim_exists_ff then List.map elim_exists_ctx sl
                 else sl in
               (SuccCtx res_ctx, prf))
          | _ -> report_error no_pos ("[solver.ml heap_entail_split_rhs 1]: No disjunction on the RHS should reach this level\n")
        end
    end
  | _ -> report_error no_pos ("[solver.ml heap_entail_split_rhs 2]: No disjunctive context should reach this level\n")

(* entailment method for splitting the antecedent *)
and heap_entail_split_lhs (prog : prog_decl) (is_folding : bool) (ctx0 : context) (conseq : formula)
    (rhs_h_matched_set : CP.spec_var list) pos : (list_context * proof) =
  x_dinfo_zp (lazy ("heap_entail_split_lhs: \nante:\n" ^ (Cprinter.string_of_context ctx0) ^ "\nconseq:\n"
                    ^ (Cprinter.string_of_formula conseq))) pos;

  (***** main helper method ******)
  (* called for both formula base and formula exists *)
  let rec helper_lhs h func : (list_context * proof) =
    (* split h such that:
       h1 = D1 /\ h2 = D2 |- D
    *)
    let h1, h2 = x_add_1 Mem.split_heap h in
    if (is_empty_heap h1) && not (Mem.contains_conj h2)
    then let final_ctx, final_prf =
           x_add heap_entail_conjunct 14 prog is_folding (CF.set_context_formula ctx0 (func h2)) conseq rhs_h_matched_set pos in
      match final_ctx with
      | SuccCtx(cl) ->
        (* substitute the holes due to the temporary removal of matched immutable nodes *)
        let cl1 = List.map (subs_crt_holes_ctx 1) cl in
        let cl1 = List.map (x_add_1 restore_tmp_ann_ctx) cl1 in
        (SuccCtx(cl1), final_prf)
      | FailCtx _ -> (final_ctx, final_prf)
    else
    if(is_empty_heap h1) && (Mem.contains_conj h2)
    then let final_ctx, final_prf =
           heap_entail_split_lhs prog is_folding (CF.set_context_formula ctx0 (func h2)) conseq rhs_h_matched_set pos in
      match final_ctx with
      | SuccCtx(cl) ->
        (* substitute the holes due to the temporary removal of matched immutable nodes *)
        let cl1 = List.map (subs_crt_holes_ctx 2) cl in
        let cl1 = List.map (x_add_1 restore_tmp_ann_ctx) cl1 in
        (SuccCtx(cl1), final_prf)
      | FailCtx _ -> (final_ctx, final_prf)
    else
    if (is_empty_heap h2)
    then
      (* lhs contains only one heap (no need to split)*)
      let new_ctx = CF.set_context_formula ctx0 (func h1) in
      (* in this case we directly call heap_entail_conjunct *)
      let final_ctx, final_prf = x_add heap_entail_conjunct 15 prog is_folding new_ctx conseq rhs_h_matched_set pos in
      match final_ctx with
      | SuccCtx(cl) ->
        (* substitute the holes due to the temporary removal of matched immutable nodes *)
        let cl1 = List.map (subs_crt_holes_ctx 3) cl in
        let cl1 = List.map (x_add_1 restore_tmp_ann_ctx) cl1 in
        (SuccCtx(cl1), final_prf)
      | FailCtx _ -> (final_ctx, final_prf)
    else
      (* lhs contains multiple conjs *)
      (******************************************************)
      (****** the first entailment uses h1 as lhs heap ******)
      (******************************************************)
      let lhs_h1 = func h1 in
      let h1_ctx = CF.set_context_formula ctx0 lhs_h1 in
      x_dinfo_zp (lazy ("heap_entail_split_lhs: \ncall heap_entail_conjunct with lhs = h1\n")) pos;
      let (with_h1_ctx, with_h1_prf) = x_add heap_entail_conjunct 16 prog is_folding h1_ctx conseq rhs_h_matched_set pos in
      (*******************************************************)
      (****** the second entailment uses h2 as lhs heap ******)
      (*******************************************************)
      (* todo: check whether the conseq != null (?)*)
      let (final_ctx, final_prf) =
        match with_h1_ctx with
        | SuccCtx(cl) ->
          (* h1 was enough, no need to use h2 *)
          (* substitute the holes due to the temporary removal of matched immutable nodes *)
          (* let () = print_string("Substitute the holes \n") in *)
          let cl = List.map (subs_crt_holes_ctx 4) cl in
          let cl =  List.map (x_add_1 restore_tmp_ann_ctx) cl in
          (* put back the frame consisting of h2 *)
          let cl = List.map (fun c -> insert_ho_frame c (fun f -> CF.mkConjH h2 f pos)) cl
          in
          (SuccCtx(cl), with_h1_prf)
        | FailCtx(ft) ->
          (* failed when using lhs = h1; need to try h2 *)
          (*let () = print_string(Cprinter.string_of_list_context with_h1_ctx) in*)
          match h2 with
          | HTrue -> (* h2 = true and hence it wont help *)
            (with_h1_ctx, with_h1_prf)
          | _ -> let lhs_h2 = func h2 in
            let h2_ctx = CF.set_context_formula ctx0 lhs_h2 in
            (*let () = print_string(Cprinter.string_of_list_context with_h1_ctx) in*)
            (*match ft with
              | Or_Continuation(ft1,ft2) ->
              let ctx1, prf1 = heap_entail_split_lhs prog is_folding h2_ctx conseq pos in
              let ctx2, prf2 = heap_entail_split_lhs prog is_folding h2_ctx conseq pos in
              ((fold_context_left [ctx1;ctx2]),(mkOrRight ctx0 conseq [prf1;prf2]))
              | _ ->*)
            let (with_h2_ctx, with_h2_prf) =
              heap_entail_split_lhs prog is_folding h2_ctx conseq rhs_h_matched_set pos in
            let (with_h2_ctx, with_h2_prf) =
              match with_h2_ctx with
              | FailCtx _ -> (with_h2_ctx, with_h2_prf)
              | SuccCtx (cl) ->
                (* substitute the holes due to the temporary removal of matched immutable nodes *)
                (* let () = print_string("Substitute the holes \n") in *)
                let cl = List.map (subs_crt_holes_ctx 5) cl in
                let cl =  List.map (x_add_1 restore_tmp_ann_ctx) cl in
                (* in case of success, put back the frame consisting of h1/\h2*[] *)
                (* first add the frame h2*[] *)
                let cl = List.map (fun x -> insert_ho_frame x (fun f -> CF.mkConjH h1 f pos)) cl in
                (* next add the frame h1/\[]*)
                let cl = List.map
                    (fun c -> CF.transform_context (fun es ->
                         CF.Ctx{es with CF.es_formula = Norm.imm_norm_formula prog es.CF.es_formula unfold_for_abs_merge pos;}) c) cl
                    (*let cl = List.map (fun x -> insert_ho_frame x (fun f -> CF.mkConjH h1 f pos)) cl
                      in*) in (SuccCtx(cl), with_h2_prf)
            in (with_h2_ctx, with_h2_prf)
            (*heap_entail_with_cont_lhs prog is_folding new_ctx conseq ft h1 h2 with_h1_ctx with_h1_prf func pos*)
      in
      (* union of states *)
      (*	let () = print_string("compute final answer\n") in*)
      ((fold_context_left 3 [with_h1_ctx; final_ctx]),( mkOrRight ctx0 conseq [with_h1_prf; final_prf]))

  in
  (* main method *)
  let lhs = CF.formula_of_context ctx0 in
  match lhs with
  | Base(bf) ->
    let h, p, vp, fl, t, a = CF.split_components lhs in
    if not(Mem.check_mem_sat h prog.prog_view_decls)
    then (match ctx0 with
        | Ctx estate ->
          (SuccCtx[false_ctx_with_flow_and_orig_ante estate fl lhs pos],UnsatAnte)
        | _ -> report_error no_pos ("[solver.ml]: No disjunction on the LHS should reach this level\n"))
    else
      helper_lhs h (fun xh -> CF.mkBase xh p vp t fl a pos)
  | Exists({formula_exists_qvars = qvars;
            formula_exists_heap = h;
            formula_exists_pure = p;
            formula_exists_vperm = vp;
            formula_exists_type = t;
            formula_exists_flow = fl;
            formula_exists_and = a;
            formula_exists_label = l;
            formula_exists_pos = pos }) ->  if not(Mem.check_mem_sat h prog.prog_view_decls)
    then (match ctx0 with
        | Ctx estate ->
          (SuccCtx[false_ctx_with_flow_and_orig_ante estate fl lhs pos],UnsatAnte)
        | _ -> report_error no_pos ("[solver.ml]: No disjunction on the LHS should reach this level\n"))
    else
      helper_lhs h (fun xh -> CF.mkExists qvars xh p vp t fl a pos)
  | _ -> report_error no_pos ("[solver.ml]: No disjunction on the LHS should reach this level\n")

and heap_entail_init (prog : prog_decl) (is_folding : bool)  (cl : list_context) (conseq : formula) pos : (list_context * proof) =
  Debug.no_2 "heap_entail_init"
    Cprinter.string_of_list_context
    Cprinter.string_of_formula
    (fun (rs, _) -> Cprinter.string_of_list_context rs)
    (fun cl conseq -> heap_entail_init_x prog is_folding cl conseq pos) cl conseq

and heap_entail_init_x (prog : prog_decl) (is_folding : bool)  (cl : list_context) (conseq : formula) pos : (list_context * proof) =
  match cl with
  | FailCtx fr -> (cl,Failure)
  | SuccCtx _ ->
    reset_formula_point_id();
    let conseq = rename_labels_formula conseq in
    let rename_es es = {es with es_formula = rename_labels_formula_ante es.es_formula}in
    let rec prepare_es es = {es with
                             es_success_pts  = ([]: (formula_label * formula_label)  list)  ;(* successful pt from conseq *)
                             es_residue_pts  = residue_labels_in_formula es.es_formula   ;(* residue pts from antecedent *)
                             es_id      = (fst (fresh_formula_label ""))              ; (* unique +ve id *)
                             (* es_orig_ante   = es.es_formula; *)
                             es_orig_conseq = struc_formula_of_formula conseq pos;} in
    let cl_new = transform_list_context ((fun es-> Ctx(prepare_es(rename_es (reset_original_es es)))),(fun c->c)) cl in
    let conseq_new = conseq in
    x_add heap_entail prog is_folding cl_new conseq_new pos

and heap_entail p is_folding cl conseq pos : (list_context * proof) =
  let pr = Cprinter.string_of_list_context in
  let pr_r (r, _) = pr r in
  let pr_f = Cprinter.string_of_formula in
  Debug.no_2 "heap_entail" pr pr_f pr_r
    (fun cl conseq -> heap_entail_x p is_folding cl conseq pos) cl conseq

and heap_entail_x (prog : prog_decl) (is_folding : bool) (cl : list_context) (conseq : formula) pos : (list_context * proof) =
  match cl with
  | FailCtx _ ->
    let () = x_tinfo_pp "FailCtx \n" no_pos in
    (cl, Failure)
  | SuccCtx cl ->
    let () = x_tinfo_pp "SuccCtx \n" no_pos in
    if !Globals.use_set || Gen.is_empty cl then
      let tmp1 = List.map (fun c -> x_add heap_entail_one_context 3 prog is_folding c conseq None None None pos) cl in
      let tmp2, tmp_prfs = List.split tmp1 in
      let prf = mkContextList cl (Cformula.formula_to_struc_formula conseq) tmp_prfs in
      ((fold_context_left 4 tmp2), prf)
    else (x_add heap_entail_one_context 4 prog is_folding (List.hd cl) conseq None None None pos)

(*conseq should be a struc_formula in order to have some thread id*)
and heap_entail_one_context i prog is_folding ctx conseq (tid: CP.spec_var option) (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos =
  let pr1 = Cprinter.string_of_context in
  let pr2 = Cprinter.string_of_formula in
  let pr3 = fun (l,p) -> Cprinter.string_of_list_context l in
  Debug.no_2_num i "heap_entail_one_context"
    (add_str "ctx" pr1) (add_str "conseq" pr2) pr3
    (fun ctx conseq -> heap_entail_one_context_a i prog is_folding ctx conseq pos) ctx conseq

(*only struc_formula can have some thread id*)
and heap_entail_one_context_a i (prog : prog_decl) (is_folding : bool) (ctx : context) (conseq : formula) pos : (list_context * proof) =
  Debug.vv_trace "heap_entail_one_context" ;
  let ctx = CF.transform_context (fun es ->
      CF.Ctx{es with CF.es_formula = Norm.imm_norm_formula prog es.CF.es_formula unfold_for_abs_merge pos; }) ctx
  in
  if (isAnyFalseCtx ctx)  then
    let () = x_tinfo_pp "is any false ctx \n" no_pos in
    let r = SuccCtx [ctx] in
    let es = get_estate_from_ctx ctx in
    let () = x_add new_slk_log_g conseq 2 (* hec_num *) pos r es in
    (r, UnsatAnte)
  else if (not (check_is_classic ())) && (isStrictConstTrue conseq) then
    let () = x_tinfo_pp "else if is any false ctx \n" no_pos in
    (SuccCtx [ctx], TrueConseq)
  else
    (* UNSAT check *)
    let () = x_tinfo_pp "UNSAT check \n" no_pos in
    let ctx =
      if isStrictConstTrue conseq || isTrivTerm conseq || trivFlowDischarge ctx conseq then ctx
      else
      if !Globals.delay_proving_sat then ctx
      else (let ctx = elim_unsat_ctx prog (ref 1) ctx in set_unsat_flag ctx true) in
    (* WN : this has been checked earlier! *)
    if isAnyFalseCtx ctx then
      (SuccCtx [ctx], UnsatAnte)
    else
      let () = x_tinfo_pp "heap_entail_after_sat \n" no_pos in
      let sleek_res = heap_entail_after_sat prog is_folding ctx conseq pos ([]) in
      sleek_res

and heap_entail_after_sat prog is_folding  (ctx:CF.context) (conseq:CF.formula) pos
    (ss:CF.steps) : (list_context * proof) =
  Debug.no_2 "heap_entail_after_sat"
    (Cprinter.string_of_context)
    (Cprinter.string_of_formula)
    (fun (l,p) -> Cprinter.string_of_list_context l)
    (fun ctx conseq -> heap_entail_after_sat_x prog is_folding ctx conseq pos ss) ctx conseq

and heap_entail_after_sat_x prog is_folding  (ctx:CF.context) (conseq:CF.formula) pos
    (ss:CF.steps) : (list_context * proof) =
  match ctx with
  | OCtx (c1, c2) ->
    x_dinfo_zp (lazy ("heap_entail_after_sat:"^ "\nctx:\n" ^ (Cprinter.string_of_context ctx)^ "\nconseq:\n" ^ (Cprinter.string_of_formula conseq))) pos;
    let rs1, prf1 = heap_entail_after_sat prog is_folding c1 conseq pos (CF.add_to_steps ss "left OR 1 on ante") in
    let rs2, prf2 = heap_entail_after_sat prog is_folding c2 conseq pos (CF.add_to_steps ss "right OR 1 on ante") in
    ((or_list_context rs1 rs2),(mkOrLeft ctx conseq [prf1;prf2]))
  | Ctx es ->
    let exec_old () =
      begin
        let pr = Cprinter.string_of_entail_state_short in
        Debug.devel_zprint (lazy ("heap_entail_after_sat: invoking heap_entail_conjunct_lhs"^ "\ncontext:\n" ^ (Cprinter.string_of_context ctx)^ "\nconseq:\n" ^ (Cprinter.string_of_formula conseq))) pos;
        let es = (CF.add_to_estate_with_steps es ss) in
        let tmp, prf = x_add heap_entail_conjunct_lhs 1 prog is_folding  (Ctx es) conseq pos in
        (filter_set tmp, prf)
      end in
    wrap_trace es.es_path_label exec_old ()

and early_hp_contra_detection_x hec_num prog estate conseq pos =
  if (Perm.allow_perm ()) then (true,false, None) else
    (* if there is no hp inf, post pone contra detection *)
    (* if (List.length estate.es_infer_vars_hp_rel == 0 ) then  (false, None) *)
  if (no_infer_all_all estate) || not (!Globals.early_contra_flag) || x_add_1 is_error_flow estate.es_formula
  then
    let () = x_tinfo_hp (* pr_hdebug *) (add_str "early_hp_contra_detection : " pr_id) "1" pos in
    (true,false, None)
  else
  if (* (isEmpFormula estate.es_formula) && *) (* is_trivial_heap_formula conseq *)
    (is_trivial_formula conseq)
  then
    let () = x_tinfo_hp (add_str "early_hp_contra_detection : " pr_id) "3" pos in
    (true, false, None)
  else
    begin
      let (r_inf_contr,real_c), relass = solver_detect_lhs_rhs_contra 1 prog estate conseq pos "EARLY CONTRA DETECTION" in
      let h_inf_args, hinf_args_map = get_heap_inf_args estate in
      let orig_inf_vars = estate.es_infer_vars in
      let orig_ante = estate.es_formula in
      let pr_svls = Cprinter.string_of_spec_var_list in
      let pure_only_flag = (estate.es_infer_vars_rel@estate.es_infer_vars_sel_hp_rel@ estate.es_infer_vars_sel_post_hp_rel==[]) && estate.es_infer_vars!=[] in
      x_tinfo_hp (add_str "infer_vars" pr_svls) estate.es_infer_vars no_pos;
      x_tinfo_hp (add_str "infer_vars_rel" pr_svls) estate.es_infer_vars_rel no_pos;
      x_tinfo_hp (add_str "infer_vars_sel_hp_rel" pr_svls) estate.es_infer_vars_sel_hp_rel no_pos;
      x_tinfo_hp (add_str "infer_vars_sel_post_hp_rel" pr_svls) estate.es_infer_vars_sel_post_hp_rel no_pos;
      x_tinfo_hp (add_str "orig_inf_vars" pr_svls) orig_inf_vars no_pos;
      match r_inf_contr with
      | Some (new_estate, pf) ->
        let () = x_tinfo_hp (add_str "early_hp_contra_detection : " pr_id) "..in Some" pos in
        let () = x_tinfo_hp (add_str "real_contra" string_of_bool) real_c no_pos in
        let () = x_tinfo_hp (add_str "infer pure?" !print_pure_f) pf no_pos in
        let new_estate = if pure_only_flag then
            {new_estate with es_infer_vars = orig_inf_vars;
                             es_orig_ante = Some orig_ante;
                             es_infer_pure = pf :: estate.es_infer_pure}
          else {new_estate with es_infer_vars = orig_inf_vars; es_orig_ante = Some orig_ante}
        in
        let temp_ctx = SuccCtx[false_ctx_with_orig_ante new_estate orig_ante pos] in
        (* let () = Debug.info_pprint ("*********1********") no_pos in *)
        (* andreeac: to construct a new method in infer.ml--> add_infer_hp_contr_to_estate maybe? *)
        let lhs_xpure,_,_ = x_add xpure 2 prog estate.CF.es_formula in
        let lhs_p = MCP.pure_of_mix lhs_xpure in
        let rhs_xpure,_,_ = x_add xpure 3 prog conseq in
        let p_rhs_xpure0 = MCP.pure_of_mix rhs_xpure in
        let p_rhs_xpure = x_add_1 Cputil.hloc_enum_to_symb p_rhs_xpure0 in
        (*check the contra is in LHS or between LHS and RHS*)
        let () = x_tinfo_hp (add_str "pf : " ( (!CP.print_formula))) pf pos in
        let () = x_tinfo_hp (add_str "lhs_p : " ( (!CP.print_formula))) lhs_p pos in
        (* let () = Debug.info_hprint (add_str "p_rhs_xpure : " ( (!CP.print_formula))) p_rhs_xpure pos in *)
        let pf,rele_p_rhs_xpure =
          if (CP.isConstFalse p_rhs_xpure) ||
             not (TP.is_sat_raw (MCP.mix_of_pure (CP.join_conjunctions ([lhs_p;pf]))))  then
            (pf,p_rhs_xpure)
          else
            (* let rele_rhs_xpure = CP.filter_var p_rhs_xpure  orig_inf_vars in *)
            let () = x_tinfo_hp (add_str "p_rhs_xpure : " ( (!CP.print_formula))) p_rhs_xpure pos in
            let () = x_tinfo_hp (add_str "orig_inf_vars : " ( (!CP.print_svl))) orig_inf_vars pos in
            (* let () = x_tinfo_hp (add_str "rele_rhs_xpure : " ( (!CP.print_formula))) rele_rhs_xpure pos in *)
            (* if CP.isConstTrue rele_rhs_xpure then (pf,rele_rhs_xpure) else *)
            let rele_svl = CP.fv pf in
            let sst = (MCP.ptr_equations_without_null lhs_xpure) in
            let rele_sst = List.fold_left (fun r (sv1,sv2) ->
                let b1 = CP.mem_svl sv1 rele_svl in
                let b2 = CP.mem_svl sv2 rele_svl in
                match b1,b2 with
                | false, true -> r@[(sv1,sv2)]
                | true,false -> r@[(sv2, sv1)]
                | false, false -> r
                | true, true -> r@[(sv1,sv2)]
              ) [] sst in
            let l_ps = CP.remove_redundant_helper (CP.split_conjunctions (CP.subst rele_sst lhs_p)) [] in
            let l_ps1 = List.filter (fun p -> CP.intersect_svl (CP.fv p) rele_svl != []) l_ps in
            let () = x_tinfo_hp (add_str "l_ps1 : " (pr_list (!CP.print_formula))) l_ps1 pos in
            let rele_rhs_xpure = CP.subst rele_sst p_rhs_xpure in
            (CP.join_conjunctions l_ps1, rele_rhs_xpure)
        in
        let res_ctx_opt =
          (* if CP.is_neq_null_exp pf then None else *)
          let p_contr_lhs = (CP.join_conjunctions ([lhs_p;pf])) in
          let () = Debug.ninfo_hprint (add_str "p_contr_lhs"  (!CP.print_formula)) p_contr_lhs pos in
          let () = Debug.ninfo_hprint (add_str "rele_p_rhs_xpure"  (!CP.print_formula)) rele_p_rhs_xpure pos in
          let () = Debug.ninfo_hprint (add_str "hinf_args_map"  (pr_list (pr_pair pr_none !CP.print_svl))) hinf_args_map pos in
          let () = x_tinfo_hp (add_str "p_contr_lhs : " ( (!CP.print_formula))) p_contr_lhs pos in
          let hinf_args_map0 = if Gen.BList.overlap_eq CP.eq_spec_var (CP.fv lhs_p) (CP.fv pf) then
              hinf_args_map
            else
              List.filter (fun (_,args) ->
                  let rele_p0 = CP.filter_var p_contr_lhs args in
                  let () = Debug.ninfo_hprint (add_str "rele_p0"  (!CP.print_formula)) rele_p0 pos in
                  let rele_ps0 = CP.list_of_conjs rele_p0 in
                  let rele_ps1 = List.filter (fun p -> not (CP.equalFormula p rele_p_rhs_xpure)) rele_ps0 in
                  let rele_p = CP.conj_of_list rele_ps1 (CP.pos_of_formula rele_p0) in
                  let () = Debug.ninfo_hprint (add_str "rele_p"  (!CP.print_formula)) rele_p pos in
                  TP.is_sat_raw (MCP.mix_of_pure rele_p)
                ) hinf_args_map in
          let () = x_tinfo_hp (add_str "hinf_args_map0"  (pr_list (pr_pair pr_none !CP.print_svl))) hinf_args_map0 pos in
          x_add Infer.add_infer_hp_contr_to_list_context hinf_args_map0 [pf] temp_ctx rele_p_rhs_xpure in
        let () = x_tinfo_hp (add_str "res_ctx opt"  (pr_option Cprinter.string_of_list_context)) res_ctx_opt pos in
        let () = x_tinfo_hp (add_str "inferred contradiction : " Cprinter.string_of_pure_formula) pf pos in
        let es =
          if pure_only_flag then new_estate
          else
            match res_ctx_opt with
            | None ->
              x_winfo_hp (add_str "WARNING : Inferred pure not added" !print_pure_f) pf no_pos;
              new_estate
            | Some res_ctx ->
              (* contra due to HP args *)
              let res_es_opt = Cformula.estate_opt_of_list_context res_ctx in
              (* let () = new_slk_log slk_no res_ctx new_estate in *)
              match res_es_opt with
              | Some res_es0 ->
                let res_es =
                  match relass with
                  | [(_,h,_)] -> x_add add_infer_rel_to_estate h res_es0
                  | _ -> res_es0 in
                res_es
              | None -> new_estate (* andreeac to check this one --- cand it ever get here? *)
        in
        (real_c,true, Some es)
      | None ->
        let () = x_tinfo_hp (add_str "WARNING: early_hp_contra_detection : " pr_id) "..in None" pos in
        match relass with
        | [(es,h,_)] ->
          let new_estate = { es with es_infer_vars = orig_inf_vars; es_orig_ante = Some orig_ante } in
          let new_estate = x_add add_infer_rel_to_estate h new_estate in
          let () = x_tinfo_hp (add_str "new_estate(with inf rel)" Cprinter.string_of_entail_state) new_estate pos in
          (* let () = new_slk_log r1 new_estate in *)
          (real_c,true, Some new_estate)
        | _ ->(real_c,false, None)
    end

and early_hp_contra_detection hec_num prog estate conseq pos =
  let contra_str contra = if (contra) then "CONTRADICTION DETECTED" else "no contra" in
  let pr_res (real_c,contra, es) = (contra_str contra) ^(if real_c then "" else "REAL_CONTRA")
                                   ^ ("\n es = " ^ (pr_option Cprinter.string_of_entail_state es)) in
  let pr2 = Cprinter.string_of_formula in
  let f = wrap_proving_kind PK_Early_Contra_Detect (early_hp_contra_detection_x hec_num prog estate conseq) in
  Debug.no_2_num hec_num "early_hp_contra_detection" Cprinter.string_of_entail_state_short pr2 pr_res
    (fun _ _ -> f pos) estate conseq

and early_hp_contra_detection_add_to_list_context_x hec_num prog estate conseq pos =
  let real_c,contra, es = x_add early_hp_contra_detection 1 prog estate conseq pos in
  if contra then
    match es with
    | Some es -> (real_c,contra, Some (CF.SuccCtx[CF.Ctx es]), Some UnsatAnte)
    | None    -> (real_c,contra, None, None)    (* andreeac: to check this case. is it ever possible to reach this? *)
  else
    (real_c,contra, None, None)

and early_hp_contra_detection_add_to_list_context hec_num prog estate conseq pos =
  let pr_res = pr_quad (add_str "real_c" string_of_bool) string_of_bool (pr_option (Cprinter.string_of_list_context )) pr_none in
  let pr2 = Cprinter.string_of_formula in
  Debug.no_2_num hec_num "early_hp_contra_detection_add_to_list_context" Cprinter.string_of_entail_state_short pr2 pr_res
    (fun _ _ -> early_hp_contra_detection_add_to_list_context_x hec_num prog estate conseq pos) estate conseq



and early_pure_contra_detection_x hec_num prog estate conseq pos msg is_folding =
  (* andreeac: check if this step is redundant *)
  let (r_inf_contr,real_c),relass = solver_detect_lhs_rhs_contra 2 prog estate conseq pos msg  in
  let h_inf_args, hinf_args_map = get_heap_inf_args estate in
  let esv = estate.es_infer_vars in

  let new_slk_log result es = x_add new_slk_log_g conseq hec_num pos result es in
  (* let it = CF.infer_type_of_entail_state es in *)
  (* let avoid = CF.is_emp_term conseq in *)
  (* let avoid = avoid || (not (hec_stack # is_empty)) in *)
  (* let caller = hec_stack # string_of_no_ln in *)
  (* (\* let slk_no = (\\* if avoid then 0 else *\\) (next_sleek_int ()) in *\) *)
  (* (\* let () = hec_stack # push slk_no in *\) *)
  (* (\* let r = hec a b c in *\) *)
  (* (\* let () = hec_stack # pop in *\) *)
  (* let () = x_add Log.add_sleek_logging (Some es) false 0. it esv (check_is_classic ()) caller (\* avoid *\) false hec_num slk_no  *)
  (*     es.es_formula conseq es.es_heap es.es_evars (Some result) pos in *)
  (* () in *)

  (* let () = Debug.info_pprint ("Andreea 3 : we need to add_new_sleek_logging_entry to do sleek_logging") no_pos in *)
  match r_inf_contr with
  | Some (new_estate,pf) -> (* if successful, should skip infer_collect_hp_rel below *)
    let new_estate = {new_estate with es_infer_vars = esv} in
    (* let () = Debug.info_hprint (add_str "inferred contradiction : " Cprinter.string_of_pure_formula) pf pos in *)
    let () = Debug.info_pprint ("Do we need to add_new_sleek_logging_entry to do sleek_logging") no_pos in
    (* add_new_sleek_logging_entry infer_vars classic_flag caller avoid hec slk_no ante conseq  *)
    (*     consumed_heap evars (result:CF.list_context) pos *)
    if (List.length relass)>1 then report_error pos "Length of relational assumption list > 1"
    else
      let ctx1 = (x_add elim_unsat_es_now 6 prog (ref 1) new_estate) in
      let () = x_tinfo_hp (add_str "ctx1"  Cprinter.string_of_context) ctx1 pos in
      let r1, prf = x_add heap_entail_one_context 9 prog is_folding ctx1 conseq None None None pos in
      let () = x_tinfo_hp (add_str "r1"  Cprinter.string_of_list_context) r1 pos in
      let () = Debug.info_pprint ("*********2********") no_pos in
      let slk_no = Log.last_cmd # start_sleek 1 in
      let rhs_xpure,_,_ = x_add xpure 4 prog conseq in
      let p_rhs_xpure = MCP.pure_of_mix rhs_xpure in
      let r1 = x_add Infer.add_infer_hp_contr_to_list_context hinf_args_map [pf] r1 p_rhs_xpure in
      begin
        (*r1 might be None if the inferred contradiction might span several predicates or if it includes non heap pred arguments*)
        match r1 with
        | Some r1 ->
          let r1 = match relass with
            | [(_,h,_)] -> add_infer_rel_to_list_context h r1
            | _ -> r1 in
          let () = new_slk_log r1 new_estate in
          (true, None, Some r1, Some prf)
        | None -> (false, None, None, None)
      end
  | None -> (false, None, None, None)


and early_pure_contra_detection hec_num prog estate conseq pos msg is_folding =
  let contra_str contra = if (contra) then "CONTRADICTION DETECTED" else "no contra" in
  let pr_res (contra, es, ctx, _) = (contra_str contra) ^
                                    match ctx with
                                    | Some ctx -> ("\n ctx = " ^ (Cprinter.string_of_list_context ctx))
                                    | None ->     ("\n estate: " ^ (pr_option Cprinter.string_of_entail_state_short es))  in
  let f = wrap_proving_kind PK_Contra_Detect_Pure (early_pure_contra_detection_x hec_num prog estate conseq pos msg) in
  Debug.no_1_num hec_num "early_pure_contra_detection" Cprinter.string_of_entail_state_short pr_res
    (fun _ -> f is_folding) estate

and heap_entail_conjunct_lhs hec_num prog is_folding  (ctx:context) conseq pos : (list_context * proof) =
  let pr1 = (fun _ -> "prog_decl") in
  let pr2 = string_of_bool in
  let pr3 = Cprinter.string_of_context in
  let pr4 = Cprinter.string_of_formula in
  let pr5 = string_of_loc in
  let pr_res (ctx,_) = ("\n ctx = "^(Cprinter.string_of_list_context ctx)) in
  Debug.no_3_num hec_num "heap_entail_conjunct_lhs" (add_str "is_folding" pr2)
    (add_str "ctx" pr3) (add_str "conseq" pr4) pr_res
    (fun _ _ _ -> heap_entail_conjunct_lhs_x hec_num prog is_folding ctx conseq pos) (* prog *) is_folding ctx conseq

(* check entailment when lhs is normal-form, rhs is a conjunct *)
and heap_entail_conjunct_lhs_x hec_num prog is_folding  (ctx:context) (conseq:CF.formula) pos : (list_context * proof) =
  (** [Internal] Collect the data and view nodes in a h_formula.
      @return The list of all DataNode and ViewNode **)
  Debug.vv_trace "heap_entail_conjunct_lhs" ;
  let rec collect_data_view (f : h_formula) = match f with
    | Star { h_formula_star_h1 = h1; h_formula_star_h2 = h2}
    | StarMinus { h_formula_starminus_h1 = h1; h_formula_starminus_h2 = h2}
    | Conj { h_formula_conj_h1 = h1; h_formula_conj_h2 = h2}
    | ConjStar { h_formula_conjstar_h1 = h1; h_formula_conjstar_h2 = h2}
    | ConjConj { h_formula_conjconj_h1 = h1; h_formula_conjconj_h2 = h2}
    | Phase { h_formula_phase_rd = h1; h_formula_phase_rw = h2;} ->
      List.append (collect_data_view h1) (collect_data_view h2)
    | DataNode _ | ViewNode _ -> [f]
    | ThreadNode _ -> [f]
    | Hole _ | FrmHole _ | HTrue | HFalse | HEmp | HVar _ | HRel _ -> []
  in (* End of function collect_data_view *)

  (** [Internal] Generate the action based on the list of node and its tail **)
  (* this is intended to unfold duplicated ptr for completeness *)
  let rec generate_action_x nodes eset =
    match nodes with
    | []
    | [_] -> Context.M_Nothing_to_do "No duplicated nodes!"
    | x::t ->
      try
        let y = List.find (fun e ->
            (CP.eq_spec_var_aset eset (get_node_var x) (get_node_var e))
            && (is_view_user_dupl_ptr_unfold x || is_view_user_dupl_ptr_unfold e)) t in
        x_tinfo_hp (add_str "y" Cprinter.string_of_h_formula) y no_pos;
        let xy = if (is_view_user_dupl_ptr_unfold x) then x else y in
        let mr = x_add Context.mk_match_res (* aset *) Context.Root xy x x x in
        Context.M_unfold (mr,1)
      with
      (* | Not_found -> Context.M_Nothing_to_do "No views to unfold!"  *)
      | Not_found -> generate_action_x t eset

  and generate_action nodes eset =
    let pr = pr_list Cprinter.string_of_h_formula in
    let pr_1 = P.EMapSV.string_of in
    let pr_2 = Context.string_of_action_res_simpl in
    Debug.no_2 "generate_action" pr pr_1 pr_2 (fun _ _ -> generate_action_x nodes eset) nodes eset

  (** [Internal] Compare two spec var syntactically. **)
  and compare_sv_syntax xn yn = match (xn,yn) with
    | (CP.SpecVar (_,_,Primed), CP.SpecVar (_,_,Unprimed)) -> -1
    | (CP.SpecVar (_,_,Unprimed), CP.SpecVar (_,_,Primed)) -> -1
    | (CP.SpecVar (_,xnn,_), CP.SpecVar (_,ynn,_)) ->
      if (String.compare xnn ynn)==0 then 0
      else -1

  (** [Internal] Compare spec var with equality taken into account **)
  and compare_sv_x xn yn eset =
    let c = P.EMapSV.is_equiv eset xn yn in
    if c then 0
    else compare_sv_syntax xn yn

  and compare_sv_old xn yn eset =
    if CP.eq_spec_var_aset eset xn yn then 0
    else -1

  (* comparing with previous method compare_sv_old *)
  and compare_sv xn yn eset =
    let pr = Cprinter.string_of_spec_var in
    Debug.no_2_cmp (fun _ _ -> compare_sv_old xn yn eset)
      "compare_sv" pr pr string_of_int (fun _ _ -> compare_sv_x xn yn eset) xn yn
  in

  (** [Internal] Process duplicated pointers in an entail state **)
  (* TO CHECK: currently ignore formula_*_and*)
  let process_entail_state (es : entail_state) =
    (* Extract the heap formula *)
    let f = es.es_formula in
    let h,p = match f with
      | Base b -> (b.formula_base_heap,b.formula_base_pure)
      | Or _ -> failwith "[heap_entail_conjunct_lhs_x]::Unexpected OR formula in context!"
      | Exists b -> (b.formula_exists_heap,b.formula_exists_pure)
    in
    let eqns = ptr_equations_with_null p in
    let eset = CP.EMapSV.build_eset eqns in
    (* Collect and sort the data and view predicates *)
    let dv = collect_data_view h in
    let pr = pr_list Cprinter.string_of_h_formula in
    let () = y_dinfo_hp (add_str "data view" pr) dv in
    let dv = List.sort (fun x y -> compare_sv (get_node_var x) (get_node_var y) eset) dv in
    let () = y_dinfo_hp (add_str "data view (after sort)" pr) dv in
    let () = y_tinfo_hp (add_str "heap for unfold" (pr_list !CF.print_h_formula)) dv in
    (* Produce an action to perform *)
    let action = x_add generate_action dv eset in
    (* Process the action to get the new entail state *)
    let b = {(CF.mkTrue_b_nf no_pos) with formula_base_and = formula_and_of_formula f} in
    (*TO CHECK: ignore formula_*_and *)
    let res,flag =
      match action with
      | Context.M_Nothing_to_do _ ->
        (* don't log such do_nothing actions *)
        (process_action_x ~caller:x_loc [] prog es conseq b b action [] is_folding pos,false)
      | _ -> let () = num_unfold_on_dup := !num_unfold_on_dup + 1 in
        (x_add (process_action ~caller:x_loc) 0 [] prog es conseq b b action [] is_folding pos,true)
    in
    (res, flag)
  in
  let process_entail_state (es : entail_state) =
    let pr = Cprinter.string_of_formula in
    let pr2 = Cprinter.string_of_entail_state in
    Debug.no_2 "process_entail_state"  pr pr
      (pr_pair (fun (b,_) -> Cprinter.string_of_list_context b) string_of_bool)
      (* (fun (_,b) -> string_of_bool b)  *)
      (fun _ _ -> process_entail_state es) es.es_formula conseq
  in
  (* Termination: Strip the LexVar in the pure part of conjunct LHS *)
  (* Move it to es_var_measures - Important for SLEEK *)
  let ctx = x_add_1 TermUtils.strip_lexvar_lhs ctx in
  (*********************************************)
  (* End of process_entail_state *)
  (*********************************************)

  (* Call the internal function to do the unfolding and do the checking *)
  (* Check duplication only when there are no permissions*)
  let temp,dup = if !unfold_duplicated_pointers && not (Perm.allow_perm ()) then
      match ctx with
      | Ctx es -> x_add_1 process_entail_state es
      | OCtx _ -> failwith "[heap_entail_conjunct_lhs_x]::Unexpected OCtx as input!"
    else
      (* Dummy result & set dup = false to do the usual checking. *)
      match ctx with
      | Ctx es -> ((FailCtx (Trivial_Reason (CF.mk_failure_must "Dummy list_context" Globals.sl_error, es.es_trace) ,Ctx (convert_to_must_es es), (mk_cex true)), Prooftracer.TrueConseq) ,false)
      | OCtx _ -> failwith "[heap_entail_conjunct_lhs_x]::Unexpected OCtx as input!"
  in
  let () = Debug.ninfo_hprint (add_str "temp" (pr_pair Cprinter.string_of_list_context pr_none )) temp no_pos in
  if dup then (* Contains duplicate --> already handled by process_action in process_entail_state *)
    temp
  else
    let (ctx, conseq) = (match !Globals.preprocess_disjunctive_consequence with
        | true -> handle_disjunctive_conseq ctx conseq
        | false -> ctx, conseq
      ) in
    let () = Debug.tinfo_hprint (add_str "[heap_entail_conjunct_lhs_x]:: conseq 2: " Cprinter.string_of_formula) conseq no_pos in
    match conseq with
    | Or ({formula_or_f1 = f1;
           formula_or_f2 = f2;
           formula_or_pos = pos1}) ->
      x_dinfo_zp (lazy ("heap_entail_conjunct_lhs: \nante:\n"
                        ^ (Cprinter.string_of_context ctx)
                        ^ "\nconseq:\n"
                        ^ (Cprinter.string_of_formula conseq))) pos;
      let ctx_L = CF.add_to_context_num 3 ctx "left OR 2 on conseq" in
      let ctx_R = CF.add_to_context_num 4 ctx "right OR 2 on conseq" in
      if !Globals.use_set then
        let rs1, prf1 = x_add heap_entail_conjunct_lhs 2 prog is_folding  ctx_L f1 pos in
        let () = Debug.ninfo_hprint (add_str "heap_entail_conjunct_lhs:conseq 1" (Cprinter.string_of_formula )) (f1)  no_pos in
        let () = Debug.ninfo_hprint (add_str "heap_entail_conjunct_lhs:conseq rel_ass_stk end 1" ( pr_list_ln Cprinter.string_of_hprel_short)) (Infer.rel_ass_stk# get_stk)  no_pos in
        let rs2, prf2 = x_add heap_entail_conjunct_lhs 3 prog is_folding  ctx_R f2 pos in
        let () = Debug.ninfo_hprint (add_str "heap_entail_conjunct_lhs:conseq 2" (Cprinter.string_of_formula )) (f2)  no_pos in
        let () = Debug.ninfo_hprint (add_str "heap_entail_conjunct_lhs:conseq rel_ass_stk end 2" ( pr_list_ln Cprinter.string_of_hprel_short)) (Infer.rel_ass_stk# get_stk)  no_pos in
        ((fold_context_left 5 [rs1;rs2]),( mkOrRight ctx conseq [prf1; prf2]))
      else
        let rs1, prf1 = x_add heap_entail_conjunct_lhs 4 prog is_folding  ctx_L f1 pos in
        if (isFailCtx rs1) then
          let rs2, prf2 = x_add heap_entail_conjunct_lhs 5 prog is_folding  ctx_R f2 pos in
          let () = Debug.info_hprint (add_str "heap_entail_conjunct_lhs:conseq rel_ass_stk end 4" ( pr_list_ln Cprinter.string_of_hprel_short)) (Infer.rel_ass_stk# get_stk)  no_pos in
          (filter_set rs2, prf2)
        else
          let () = Debug.info_hprint (add_str "heap_entail_conjunct_lhs:conseq rel_ass_stk end 3" ( pr_list_ln Cprinter.string_of_hprel_short)) (Infer.rel_ass_stk# get_stk)  no_pos in
          (filter_set rs1, prf1)
    | _ -> begin
        let () = x_tinfo_pp "base case conseq \n" no_pos in
        let r1,p1 =
          let heap_entail () = x_add heap_entail_conjunct 1 prog is_folding  ctx conseq [] pos
          in

          let (real_c,contra, r1, prf) =
            let es = get_estate_from_context ctx in
            match es with
            | Some estate ->
              early_hp_contra_detection_add_to_list_context hec_num prog estate conseq pos
            | None ->
              (true,false, None, None)
          in
          let () = Debug.dinfo_hprint (add_str "early contra detect" string_of_bool) contra no_pos in
          let () = Debug.dinfo_hprint (add_str "real_c" string_of_bool) real_c no_pos in
          let () = Debug.dinfo_hprint (add_str "ctx" Cprinter.string_of_context) ctx no_pos in
          if not(contra) then
            let () = x_tinfo_pp "not contra \n" no_pos in
            if real_c then
              let () = x_tinfo_pp "real c \n" no_pos in
              heap_entail()
            else (* early failure due to real lhs-rhs contra detected *)
              let () = Debug.binfo_pprint "Early lhs-rhs contra detected" no_pos in
              let pr = Cprinter.string_of_formula in
              let pr2 = Cprinter.string_of_context in
              let cex = (mk_cex true) in
              let ante, prf, estate = match ctx with
                | Ctx es -> es.es_formula,mkPure es (CP.mkTrue no_pos) (CP.mkTrue no_pos) true None, es
                | _ -> report_error no_pos "impossible to be multiple ctx" in

              let extract_pure f= let (mf,_,_) = x_add xpure 5 prog f in Cputil.hloc_enum_to_symb (MCP.pure_of_mix mf)  in
              let (fc, (contra_list, must_list, may_list)) = x_add Musterr.check_maymust_failure (extract_pure ante)
                  (extract_pure conseq) in
              let () = x_tinfo_pp "new estateee \n" no_pos in
              let new_estate = {
                estate with es_formula =
                              match fc with
                              | CF.Failure_Must _ -> CF.substitute_flow_into_f !error_flow_int estate.es_formula
                              | CF.Failure_May _ -> CF.substitute_flow_into_f !mayerror_flow_int estate.es_formula
                              (* this denotes a maybe error *)
                              | CF.Failure_Bot _
                              | CF.Failure_Valid -> estate.es_formula
              } in
              let fc_template = mkFailContext "" new_estate conseq None pos in
              let lc = x_add Musterr.build_and_failures 5 "early contra detect: " fc
                  Globals.logical_error (contra_list, must_list, may_list) fc_template cex new_estate.es_trace in
              let () = Debug.binfo_hprint  (add_str "lc457" Cprinter.string_of_list_context) lc no_pos  in
              (lc,prf)
          else
            match (r1,prf) with
            | Some r1, Some prf -> let () = log_contra_detect 1 conseq r1 pos in (r1,prf)
            | _ ->
              heap_entail()
        in
        (r1,p1)
      end

(* Trung : can we use new RHS \/ rule below *)
(*  P & not(p1) |- R2 * G                   *)
(* -----------------------------------      *)
(*  P |- (p1 \/ R2) * G                     *)
and handle_disjunctive_conseq (ctx:context) (conseq:CF.formula) : context * CF.formula =
  let rec split_pure_heap (f: CF.formula) = (
    match f with
    | CF.Or {CF.formula_or_f1 = f1; CF.formula_or_f2 = f2; CF.formula_or_pos = p} ->
      let h1, p1 = split_pure_heap f1 in
      let h2, p2 = split_pure_heap f2 in
      let newh_opt = (match h1, h2 with
          | None, None -> None
          | None, Some hf -> Some hf
          | Some hf, None -> Some hf
          | Some hf1, Some hf2 ->
            Some (CF.Or { CF.formula_or_f1 = hf1;
                          CF.formula_or_f2 = hf2;
                          CF.formula_or_pos = p;})
        ) in
      newh_opt, p1 @ p2
    | CF.Base {CF.formula_base_heap = HEmp;
               CF.formula_base_pure = pf} ->
      None, [pf]
    | CF.Exists {CF.formula_exists_heap = HEmp;
                 CF.formula_exists_pure = pf} ->
      None, [pf]
    | _ -> Some f , []
  ) in
  let rec add_pure_to_formula (f: CF.formula) pure_fs = (
    match f with
    | CF.Or {CF.formula_or_f1 = f1; CF.formula_or_f2 = f2; CF.formula_or_pos = p} ->
      let newf1 = add_pure_to_formula f1 pure_fs in
      let newf2 = add_pure_to_formula f2 pure_fs in
      CF.Or {CF.formula_or_f1 = newf1;
             CF.formula_or_f2 = newf2;
             CF.formula_or_pos = p}
    | CF.Base _ | CF.Exists _ ->
      List.fold_left (fun f1 pf ->
          match pf with
          | MemoF mf ->
            let f = MCP.pure_of_memo_pure mf in
            let neg_pf = OnePF (CP.mkNot_s f) in
            CF.add_mix_formula_to_formula neg_pf f1
          | OnePF f ->
            let neg_pf = OnePF (CP.mkNot_s f) in
            CF.add_mix_formula_to_formula neg_pf f1
        ) f pure_fs
  ) in
  let rec create_new_context ctx pure_fs = (match ctx with
      | Ctx es ->
        let ef = es.CF.es_formula in
        let new_ef = add_pure_to_formula ef pure_fs in
        Ctx {es with CF.es_formula = new_ef}
      | OCtx (ctx1, ctx2) ->
        let new_ctx1 = create_new_context ctx1 pure_fs in
        let new_ctx2 = create_new_context ctx2 pure_fs in
        OCtx (new_ctx1, new_ctx2)
    ) in
  let conseq_opt, pure_fs = split_pure_heap conseq in
  let new_ctx = create_new_context ctx pure_fs in
  let new_conseq = (match conseq_opt with
      | None -> mkTrue_nf no_pos
      | Some f -> f
    ) in
  (new_ctx, new_conseq)


(* sleek logging procedure *)
and new_slk_log_g (conseq:formula) hec_num pos result es  =
  let avoid = CF.is_emp_term conseq in
  let avoid = avoid || (not (hec_stack # is_empty)) in
  let caller = hec_stack # string_of_no_ln in
  let slk_no = (* if avoid then 0 else *) Log.(last_cmd # start_sleek 5) in
  (* let () = hec_stack # push slk_no in *)
  (* let r = hec a b c in *)
  (* let () = hec_stack # pop in *)
  let orig_ante = match es.es_orig_ante with
    | Some f -> f
    | None   -> es.es_formula in
  let it = CF.infer_type_of_entail_state es in
  let esv = es.es_infer_vars in
  let () = (* x_add *) Log.add_sleek_logging (Some es) false 0. it esv (check_is_classic ()) caller
      (* avoid *) false hec_num slk_no es.es_formula (* orig_ante *) conseq es.es_heap es.es_evars
      es.es_gen_impl_vars (Some result) pos in
  ()


and log_contra_detect hec_num conseq result pos =
  let new_slk_log result es = x_add new_slk_log_g conseq hec_num pos result es in
  (*   let avoid = CF.is_emp_term conseq in *)
  (*   let avoid = avoid || (not (hec_stack # is_empty)) in *)
  (*   let caller = hec_stack # string_of_no_ln in *)
  (*   let slk_no = (\* if avoid then 0 else *\) Log.(last_cmd # start_sleek 2) in *)
  (*   (\* let () = hec_stack # push slk_no in *\) *)
  (*   (\* let r = hec a b c in *\) *)
  (*   (\* let () = hec_stack # pop in *\) *)
  (*   let orig_ante = match es.es_orig_ante with *)
  (*     | Some f -> f *)
  (*     | None   -> es.es_formula in *)
  (*   let it = CF.infer_type_of_entail_state es in *)
  (*   let () = x_add Log.add_sleek_logging (Some es) false 0. it es.es_infer_vars (check_is_classic ()) caller  *)
  (*     (\* avoid *\) false hec_num slk_no orig_ante conseq es.es_heap es.es_evars (Some result) pos in *)
  (*   () *)
  (* in *)
  let f = wrap_proving_kind PK_Unknown (* Early_Contra_Detect *) (new_slk_log result) in
  let es_opt = estate_opt_of_list_context result in
  match es_opt with
  | Some es -> f es
  | None    -> ()

(* 23.10.2008 *)
(* for empty RHS heap:
   - move the explicit instantiations from the RHS to the LHS
   - remove the explicit instantiated vars from the existential vars of the conseq
   - add the existential vars from the conseq to the existential vars from the antecedent
   - f represents the consequent
*)

and move_expl_inst_ctx_list (ctx:list_context)(f:MCP.mix_formula):list_context =
  let pr1 = Cprinter.string_of_list_context_short in
  let pr2 = Cprinter.string_of_mix_formula in
  Debug.no_2 "move_expl_inst_ctx_list" pr1 pr2 pr1
    move_expl_inst_ctx_list_x ctx f

(*TO CHECK: *)
and move_expl_inst_ctx_list_x (ctx:list_context)(f:MCP.mix_formula):list_context =
  match ctx with
  | FailCtx _ -> ctx
  | SuccCtx cl ->
    let cl1 =
      List.map (fun c ->
          (transform_context
             (fun es -> Ctx(x_add move_expl_inst_estate es f)
             ) c)) cl
    in SuccCtx(cl1)

and get_expl_inst es (f : MCP.mix_formula) =
  let l_inst = es.es_gen_expl_vars(*@es.es_gen_impl_vars@es.es_ivars*) in
  let f = MCP.find_rel_constraints f l_inst in
  let to_elim_vars = es.es_gen_impl_vars@es.es_evars in
  if (to_elim_vars = []) then f
  else (elim_exists_mix_formula to_elim_vars f no_pos)


(* this method throws False_from_explicit_inst if explicit inst leads to contradiction *)
and move_expl_inst_estate_x es (f : MCP.mix_formula) =
  let inst_f,unsat_check,nf,nflg=
    let f2 = get_expl_inst es f in
    (* Debug.info_hprint (add_str "move_expl(f2)" !print_mix_formula) f2 no_pos; *)
    let flag = MCP.isConstMTrue f2 in
    let form = es.es_formula in
    let nform = CF.mkStar form (formula_of_mix_formula f2 no_pos) Flow_combine no_pos in
    let unsat_check = if not(flag) && not(isAnyConstFalse form) then
        begin
          (* let () = y_tinfo_hp (add_str "explicit inst must not lead to contradiction" !print_mix_formula) f2 in *)
          (* let () = y_tinfo_hp (add_str "form" !print_formula) form in *)
          (* let () = y_tinfo_hp (add_str "nform" !print_formula) nform in *)
          true
        end
      else false
    in
    f2,unsat_check,nform,flag in
  let  new_es = {es with
                 (* why isn't es_gen_expl_vars updated? *)
                 (* es_gen_impl_vars = Gen.BList.intersect_eq CP.eq_spec_var es.es_gen_impl_vars es.es_evars; *)
                 es_ante_evars = es.es_ante_evars @ es.es_gen_impl_vars@es.es_evars (*es.es_evars*);
                 es_formula = nf;
                 es_unsat_flag = es.es_unsat_flag && nflg; } in
  let last_es =
    if unsat_check then
      let ues = x_add_1 elim_unsat_es_now_new new_es in
      let f = ues.es_formula in
      (* let () = y_tinfo_hp (add_str "f(unsat?)" !print_formula) f in *)
      if isAnyConstFalse f then
        let lhs = (add_str "(ante)" !print_formula) es.es_formula in
        let rhs = (add_str " (expl inst)" !print_mix_formula) inst_f in
        raise (False_from_explicit_inst (lhs^rhs))
      else ues
    else new_es in
  last_es


and move_expl_inst_estate es (f:MCP.mix_formula) =
  let pr1 = Cprinter.string_of_entail_state in
  let pr2 = Cprinter.string_of_mix_formula in
  Debug.no_2 "move_expl_inst_estate" pr1 pr2 pr1 move_expl_inst_estate_x es f

and move_impl_inst_estate es (f:MCP.mix_formula) =
  let pr1 = Cprinter.string_of_entail_state in
  let pr2 = Cprinter.string_of_mix_formula in
  Debug.no_2 "move_impl_inst_estate" pr1 pr2 pr1 move_impl_inst_estate_x es f

and move_impl_inst_estate_x es (f:MCP.mix_formula) =
  let l_inst = es.es_gen_impl_vars@es.es_ivars in
  let f = MCP.find_rel_constraints f l_inst in
  let to_elim_vars = es.es_gen_expl_vars@es.es_evars in
  let f_v = MCP.mfv f in
  let inst_to_keep = Gen.BList.difference_eq CP.eq_spec_var l_inst f_v in
  let new_to_elim = Gen.BList.intersect_eq CP.eq_spec_var f_v to_elim_vars in
  x_tinfo_hp (add_str "move_impl(l_inst)" !CP.print_svl) l_inst no_pos;
  x_tinfo_hp (add_str "move_impl(to_elim_evars)" !CP.print_svl) to_elim_vars no_pos;
  x_tinfo_hp (add_str "move_impl(inst_to_keep)" !CP.print_svl) inst_to_keep no_pos;
  x_tinfo_hp (add_str "move_impl(f)" !print_mix_formula) f no_pos;
  x_tinfo_hp (add_str "move_impl(new_to_elim)" !CP.print_svl) new_to_elim no_pos;
  let _, mix_f, _, _, _, _  = CF.split_components es.es_formula in
  let mix_f = match (mix_f,f) with
    | (OnePF rhs,OnePF pure_f) ->
      let pure_f_conjuncts = CP.list_of_conjs rhs in
      let pure_f_conjuncts = List.filter (fun (a:CP.formula) -> match a with
          | BForm (( Eq (Var(a,l), Tsconst (b, c), d), e), f) -> CP.mem a (CP.fv pure_f)
          | _ ->false
        ) pure_f_conjuncts in
      OnePF (CP.conj_of_list pure_f_conjuncts no_pos)
    | _ -> mix_f
  in
  x_tinfo_hp (add_str "f(before):" !print_mix_formula) f no_pos;
  let f = match (f,mix_f) with
    | OnePF conseq1, OnePF pure_f ->
      let conjuncts = CP.list_of_conjs conseq1 in
      let lhs_perms = CP.list_of_conjs pure_f in
      if (List.length conjuncts > 1 && List.length l_inst > 0 && List.length lhs_perms > 0)  then
        let conj = List.hd conjuncts in
        let lhs_perm = List.hd lhs_perms in
        match conj,lhs_perm with
        | (BForm (( Eq (Var(a1,l1), Tsconst (b1, c1), d1), e1), f1), BForm (( Eq (Var(a2,l2), Tsconst (b2, c2), d2), e2), f2))  ->
          let new_tree = Tree_shares.Ts.subtract b2 b1 in
          let var = List.hd l_inst in
          let new_f = OnePF (BForm (( Eq (Var(var,l1), Tsconst (new_tree, c1), d1), e1), f1)) in
          new_f
        | (BForm (( Eq (Var(a1,l1), Tsconst (b1, c1), d1), e1), f1), _)  ->
          let new_tree = Tree_shares.Ts.neg_tree b1 in
          let var = List.hd l_inst in
          let new_f = OnePF (BForm (( Eq (Var(var,l1), Tsconst (new_tree, c1), d1), e1), f1)) in
          new_f
        | _ -> f
      else f
    | _ -> f
  in
  x_tinfo_hp (add_str "f(after):" !print_mix_formula) f no_pos;
  let nf,nflg =
    let f2 = if ( to_elim_vars = []) then f else
        (elim_exists_mix_formula to_elim_vars f no_pos) in
    (* let () = print_endline("cris: impl inst = " ^ (Cprinter.string_of_mix_formula f2)) in *)
    (* let () = print_endline("cris: f = " ^ (Cprinter.string_of_mix_formula f)) in *)
    (* Debug.info_hprint (add_str "move_impl(f2)" !print_mix_formula) f2 no_pos; *)
    CF.mkStar es.es_formula (formula_of_mix_formula f2 no_pos) Flow_combine no_pos , MCP.isConstMTrue f2 in
  {es with
   (* why isn't es_gen_expl_vars updated? *)
   es_gen_impl_vars = Gen.BList.intersect_eq CP.eq_spec_var es.es_gen_impl_vars (inst_to_keep @ to_elim_vars) (*es.es_evars*);
   (*es_ante_evars = es.es_ante_evars @ to_elim_vars;*)
   es_formula = nf;
   es_unsat_flag = es.es_unsat_flag && nflg; }


(* from a list containing equaltions of the form vi = wi -> obtain two lists [vi]  and [wi] *)
and obtain_subst l =
  match l with
  | CP.BForm ((CP.Eq(CP.Var(e1, _), CP.Var(e2, _), _), _), _)::r -> ((e1::(fst (obtain_subst r))), (e2::(snd (obtain_subst r))))
  | _::r -> ((fst (obtain_subst r)), (snd (obtain_subst r)))
  | [] -> ([],[])

and coer_target prog (coer : coercion_decl) (node:CF.h_formula) (target_rhs : CF.formula) (lhs : CF.formula) rhs_eqset: bool =
  let pr1 = pr_list (pr_pair !CP.print_sv !CP.print_sv ) in
  let pr_h = Cprinter.string_of_h_formula in
  let pr_f = Cprinter.string_of_formula in

  Debug.no_4 "coer_target" (* Cprinter.string_of_coercion  *)
    (add_str "node" pr_h) (add_str "target_rhs" pr_f) (add_str "lhs" pr_f)
    (add_str "rhs_eqset" pr1) string_of_bool
    (fun _ _ _ _ -> coer_target_a prog coer node target_rhs lhs rhs_eqset) node lhs target_rhs rhs_eqset

(* WN : I think coer_target is unnecessary since this is done at process_one_match *)
(* it also failed for ex16d2a.slk *)
and coer_target_a prog (coer : coercion_decl) (node:CF.h_formula) (target_rhs : CF.formula) (lhs : CF.formula) rhs_eqset: bool =
  if !Globals.old_coer_target then coer_target_b prog coer node target_rhs lhs rhs_eqset
  else true

(* check whether the target of a coercion is in the RHS of the entailment *)
(* coer: the coercion lemma to be applied *)
(* node: the node to which the coercion applies *)
(* lhs and rhs - the antecedent and consequent, respectively *)
and coer_target_b prog (coer : coercion_decl) (node:CF.h_formula) (target_rhs : CF.formula) (lhs : CF.formula) rhs_eqset: bool =
  let coer_lhs = coer.coercion_head in
  let coer_rhs = coer.coercion_body in
  let coer_lhs_heap, coer_lhs_guard, coer_lhs_vperm, coer_lhs_flow, _, _ = split_components coer_lhs in
  let rhs_heap, rhs_pure, rhs_vperm, rhs_flow, _ ,_ = split_components target_rhs in
  let lhs_heap, lhs_pure, lhs_vperm, lhs_flow, _ ,_ = split_components lhs in
  let coer_lhs_heap = if(coer.coercion_case = Cast.Ramify) then (match coer_lhs_heap with
      | StarMinus({h_formula_starminus_h1 = h1;
                   h_formula_starminus_h2 = h2}) -> h1
      | _ -> coer_lhs_heap)
    else coer_lhs_heap
  in
  (* node - the node to which we want to apply the coercion rule *)
  (* need to find the substitution *)
  match node, coer_lhs_heap with
  | ViewNode ({ h_formula_view_node = p1;
                h_formula_view_name = c1;
                h_formula_view_origins = origs;
                h_formula_view_perm = perm1;
                h_formula_view_arguments = ps1}),
    ViewNode ({h_formula_view_node = p2;
               h_formula_view_name = c2;
               h_formula_view_perm = perm2;
               h_formula_view_arguments = ps2}) (* when c1=c2 -> *)

  | DataNode ({ h_formula_data_node = p1;
                h_formula_data_name = c1;
                h_formula_data_origins = origs;
                h_formula_data_perm = perm1;
                h_formula_data_arguments = ps1}),
    DataNode ({h_formula_data_node = p2;
               h_formula_data_name = c2;
               h_formula_data_perm = perm2;
               h_formula_data_arguments = ps2}) when c1=c2 ->
    begin
      (* apply the substitution *) (*LDK: do we need to check for perm ???*)
      let coer_rhs_new = subst_avoid_capture (p2 :: ps2) (p1 :: ps1) coer_rhs in
      let coer_lhs_new = subst_avoid_capture (p2 :: ps2) (p1 :: ps1) coer_lhs in
      (* find the targets from the RHS of the coercion *)
      let top_level_vars = (CF.f_top_level_vars coer_rhs_new) in
      let () = y_tinfo_hp (add_str "coer_rhs_new" !CF.print_formula) coer_rhs_new in
      let () = y_tinfo_hp (add_str "top_level_vars" !CP.print_svl) top_level_vars in
      let target = (List.filter (fun x -> List.mem x top_level_vars) (CF.fv coer_rhs_new)) in
      let () = y_tinfo_hp (add_str "target0" !CP.print_svl) target in
      let target = (List.filter (fun x -> (List.mem x (CF.fv coer_lhs_new))) target) in
      let () = y_tinfo_hp (add_str "target" !CP.print_svl) target in
      let coer_rhs_h, _, _, _, _,_ = split_components coer_rhs_new in
      (* check for each target if it appears in the consequent *)
      let all_targets = (List.map (fun x -> (check_one_target prog node x lhs_pure rhs_pure rhs_heap coer_rhs_h rhs_eqset)) target) in
      List.exists(fun c->c) all_targets
    end
  | _ -> Error.report_error {Error.error_loc = no_pos; Error.error_text = "malfunction coer_target recieved non views"}
(* given a spec var -> return the entire node *)

and get_node (sv : CP.spec_var) (f : CF.h_formula) : CF.h_formula =
  match f with
  | Star({ h_formula_star_h1 = f1; h_formula_star_h2 = f2}) ->
    let res1 = (get_node sv f1) in
    begin
      match res1 with
      | HFalse -> (get_node sv f2)
      | _ -> res1
    end
  | DataNode({h_formula_data_node = sv1; h_formula_data_name = name}) ->
    if (CP.eq_spec_var sv sv1)
    then f
    else HFalse
  | ViewNode({h_formula_view_node = sv1; h_formula_view_name = name}) ->
    if (CP.eq_spec_var sv sv1)
    then f
    else HFalse
  | _ -> HFalse

(* checks whether a coercion is distributive *)
and is_distributive	(coer : coercion_decl) : bool =
  let coer_lhs = coer.coercion_head in
  let coer_rhs = coer.coercion_body in
  let coer_lhs_heap, _, _,_, _, _ = split_components coer_lhs in
  let coer_rhs_heap, _, _,_, _, _ = split_components coer_rhs in
  let top_level_lhs = top_level_vars coer_lhs_heap in
  let top_level_rhs = top_level_vars coer_rhs_heap in
  not(List.mem false (List.map (fun x -> check_one_node x top_level_rhs coer_lhs_heap coer_rhs_heap) top_level_lhs))

(*  checks whether sv is present on the lhs and points to the same view *)
and check_one_node (sv : CP.spec_var) (top_level_rhs : CP.spec_var list) (lhs_heap : CF.h_formula) (rhs_heap : CF.h_formula) : bool =
  match top_level_rhs with
  | h :: r ->
    if (CP.eq_spec_var h sv) && (String.compare (x_add CF.get_node_name 17 (get_node sv lhs_heap)) (x_add CF.get_node_name 18 (get_node h rhs_heap))) == 0 then
      true
    else (check_one_node sv r lhs_heap rhs_heap)
  | [] -> false

(* returns the list of free vars from the rhs that do not appear in the lhs *)
and fv_rhs (lhs : CF.formula) (rhs : CF.formula) : CP.spec_var list =
  let lhs_fv = (CF.fv lhs) in
  let rhs_fv = (CF.fv rhs) in
  (* (List.filter (fun x -> not(List.mem x lhs_fv)) rhs_fv) *)
  Gen.BList.difference_eq CP.eq_spec_var rhs_fv lhs_fv

and heap_entail_split_rhs_phases
    p is_folding  ctx0 conseq d
    pos : (list_context * proof) =
  Debug.no_2 "heap_entail_split_rhs_phases"
    (fun x -> Cprinter.string_of_context x)
    (Cprinter.string_of_formula)
    (fun (lc,_) -> Cprinter.string_of_list_context lc)
    (fun _ _ -> heap_entail_split_rhs_phases_x p is_folding  ctx0 conseq d pos) ctx0 conseq

and heap_entail_split_rhs_phases_x (prog : prog_decl) (is_folding : bool) (ctx_0 : context) (conseq : formula)
    (drop_read_phase : bool) pos : (list_context * proof) =
  let rec map_ctx ctx fnc=
    match ctx with
    | Ctx(estate) -> Ctx (fnc estate)
    | OCtx (c1, c2) -> OCtx (map_ctx c1 fnc, map_ctx c2 fnc)
  in
  let ctx_with_rhs =
    let h, rhs_pure, _, fl, t, a  = CF.split_components conseq in
    let () = x_tinfo_hp (add_str "rhs_pure (split_rhs_phases)" Cprinter.string_of_mix_formula) rhs_pure no_pos in
    let () = x_tinfo_hp (add_str "h (split_rhs_phases)" Cprinter.string_of_h_formula) h no_pos in
    let eqns = (MCP.ptr_equations_without_null rhs_pure) in
    CF.set_context (fun es ->
        (* let svl  = CF.fv es.CF.es_formula in *)
        (* let () = x_tinfo_hp (add_str "svl" !CP.print_svl) svl no_pos in *)
        (* let eqns1 = List.fold_left (fun r (sv1, sv2) -> if not (CP.mem_svl sv1 svl) && CP.mem_svl sv2 svl then
           (r@[(sv2,sv1)]) else (r@[(sv1, sv2)])) [] eqns in *)
        let rhs_p = MCP.pure_of_mix rhs_pure in
        {es with es_rhs_eqset=(es.es_rhs_eqset@eqns);
                 es_rhs_pure = Gen.map_opt_def (Some rhs_p) (fun x -> Some (CP.join_conjunctions [rhs_p;x])) es.es_rhs_pure
        }
      ) ctx_0
  in
  let helper ctx_00 h pure (func : CF.h_formula -> MCP.mix_formula -> CF.formula) =
    let () = x_tinfo_hp (add_str "heap(helper)" Cprinter.string_of_h_formula) h no_pos in
    let () = x_tinfo_hp (add_str "pure(helper)" Cprinter.string_of_mix_formula) pure no_pos in
    let h1, h2, h3 = split_phase 1 h in
    if(is_empty_heap h1) && (is_empty_heap h2) && (is_empty_heap h3) then (* no heap on the RHS *)
      let () = x_tinfo_hp (add_str "BRANCH1" pr_none) () no_pos in
      x_add heap_entail_conjunct 2 prog is_folding ctx_00 conseq [] pos
    else(* only h2!=true *)
    if ((is_empty_heap h1) && (is_empty_heap h3)) then
      let () = x_tinfo_hp (add_str "BRANCH2" pr_none) () no_pos in
      x_add heap_n_pure_entail 1 prog is_folding  ctx_00 conseq h2 pure func true pos
    else(* only h1!=true *)
    if ((is_empty_heap h2) && (is_empty_heap h3)) then
      x_add heap_n_pure_entail 2 prog is_folding  ctx_00 conseq h1 pure func false pos
    else(* only h3!=true *)
    if ((is_empty_heap h1) && (is_empty_heap h2)) then
      let new_conseq = func h3 pure in
      if not(Cformula.contains_phase h3) then (* h3 does not contain any nested phases *)
        x_add heap_n_pure_entail 3 prog is_folding  ctx_00  conseq (choose_not_empty_heap h1 h2 h3) pure func (consume_heap new_conseq) (*drop_read_phase*) pos
      else (* h3 contains nested phases *)
        heap_entail_split_rhs_phases prog is_folding ctx_00 new_conseq (consume_heap new_conseq) pos
    else
      let res_ctx, res_prf =
        (* this is not the last phase of the entailment *)
        let ctx_00 = disable_imm_last_phase_ctx ctx_00 in
        (* entail the read phase heap *)
        let () = Debug.ninfo_hprint (add_str "split " (pr_id)) "read" no_pos in
        let (after_rd_ctx, after_rd_prf) = heap_entail_rhs_read_phase prog is_folding  ctx_00 h1 h2 h3 func pos in
        (* entail the write phase heap *)
        let () = Debug.ninfo_hprint (add_str "split " (pr_id)) "write" no_pos in
        let after_wr_ctx, after_wr_prfs = heap_entail_rhs_write_phase prog is_folding  after_rd_ctx after_rd_prf conseq h1 h2 h3 func pos in
        (* entail the nested phase heap *)
        let () = Debug.ninfo_hprint (add_str "split " (pr_id)) "nested" no_pos in
        heap_entail_rhs_nested_phase prog is_folding  after_wr_ctx after_wr_prfs conseq h1 h2 h3 func drop_read_phase pos in
      (* entail the pure part *)
      (* this is the last phase of the entailment *)
      let res_ctx = enable_imm_last_phase res_ctx in
      match res_ctx with
      | SuccCtx (cl) ->
        (* let () = print_string("************************************************************************\n") in *)
        (* let () = print_string("[heap_n_pure_entail]: entail the pure part: p =" ^ (Cprinter.string_of_mix_formula p) ^ "\n") in *)
        (* let () = print_string("************************************************************************\n") in *)
        let () = x_tinfo_hp (add_str "pure" (Cprinter.string_of_mix_formula)) pure pos in
        let res = List.map (fun c ->
            let new_conseq1, aux_conseq_from_fold =
              (match c with
               | Ctx(estate) ->
                 subst_avoid_capture (fst estate.es_subst) (snd estate.es_subst) (func HEmp pure),
                 subst_avoid_capture (fst estate.es_subst) (snd estate.es_subst) (func HEmp (MCP.mix_of_pure estate.es_aux_conseq))
               | OCtx _ -> report_error no_pos ("Disjunctive context\n"))
            in
            let new_conseq = CF.mkStar new_conseq1 aux_conseq_from_fold Flow_combine pos in
            let () = x_tinfo_hp (add_str "new_conseq" (Cprinter.string_of_formula)) new_conseq pos in
            let () = x_tinfo_hp (add_str "new_conseq" Cprinter.string_of_formula) new_conseq no_pos in
            let () = x_tinfo_hp (add_str "new_conseq1" Cprinter.string_of_formula) new_conseq1 no_pos in
            (* let () = print_endline ("**********************************") in *)
            x_add heap_entail_conjunct 3 prog is_folding  c new_conseq []  pos) cl
        in
        let cl = List.map (fun c -> CF.transform_context (fun es ->
            CF.Ctx{es with CF.es_formula = Norm.imm_norm_formula prog es.CF.es_formula unfold_for_abs_merge pos;}) c)
            cl
        in
        let res_ctx, res_prf = List.split res in
        let res_prf = mkContextList cl (Cformula.struc_formula_of_formula conseq pos) res_prf in
        let res_ctx = fold_context_left 17 res_ctx in
        (res_ctx, res_prf)
      | FailCtx _ -> (res_ctx, res_prf)
  in

  x_dinfo_zp (lazy ("heap_entail_split_rhs_phases:
                            \nante:\n"
                    ^ (Cprinter.string_of_context ctx_0)
                    ^ "\nconseq:\n"
                    ^ (Cprinter.string_of_formula conseq))) pos;

  match ctx_0 with
  | Ctx estate -> begin
      let ante = estate.es_formula in
      match ante with
      | Exists ({formula_exists_qvars = qvars;
                 formula_exists_heap = qh;
                 formula_exists_pure = qp;
                 formula_exists_vperm = qvp;
                 formula_exists_type = qt;
                 formula_exists_flow = qfl;
                 formula_exists_pos = pos}) ->
        (* ws are the newly generated fresh vars for the existentially quantified vars in the LHS *)
        let ws = CP.fresh_spec_vars qvars in
        (* new ctx is the new context after substituting the fresh vars for the exist quantified vars *)
        let new_ctx = eliminate_exist_from_LHS qvars qh qp qvp qt qfl pos estate in
        (* call the entailment procedure for the new context - with the existential vars substituted by fresh vars *)
        let rs, prf1 =  heap_entail_split_rhs_phases prog is_folding  new_ctx conseq drop_read_phase pos in
        let new_rs =
          if !Globals.wrap_exist then
            (* the fresh vars - that have been used to substitute the existenaltially quantified vars - need to be existentially quantified after the entailment *)
            (add_exist_vars_to_ctx_list rs ws)
          else
            rs
        in
        (* log the transformation for the proof tracere *)
        let prf = mkExLeft ctx_0 conseq qvars ws prf1 in
        (new_rs, prf)
      | _ -> begin
          match conseq with
          | Base(bf) ->
            let h, p, vp, fl, t, a = CF.split_components conseq in
            let () =  Debug.ninfo_hprint (add_str "HERE mf: "  (Cprinter.string_of_mix_formula)) p no_pos in
            let null_p = CP.get_null_formula (MCP.pure_of_mix p) in
            let () =  Debug.ninfo_hprint (add_str "HERE pure: "  (Cprinter.string_of_pure_formula)) null_p no_pos in
            let n_ctx_with_rhs = if CP.isConstTrue null_p then ctx_with_rhs else
                map_ctx ctx_with_rhs (fun es -> {es with CF.es_conseq_pure_lemma = CP.mkAnd es.CF.es_conseq_pure_lemma null_p pos;})
            in
            helper n_ctx_with_rhs (* ctx_0 *) h p (fun xh xp -> CF.mkBase xh xp vp t fl a pos)
          | Exists ({formula_exists_qvars = qvars;
                     formula_exists_heap = qh;
                     formula_exists_pure = qp;
                     formula_exists_vperm = qvp;
                     formula_exists_type = qt;
                     formula_exists_flow = qfl;
                     formula_exists_and = qa;
                     formula_exists_pos = pos}) ->
            (* quantifiers on the RHS. Keep them for later processing *)
            (* let rel_args = CP.get_rel_args (MCP.pure_of_mix qp) in *)
            (* let () =  Debug.info_zprint  (lazy  ("XXXX qp: " ^ (Cprinter.string_of_mix_formula qp))) no_pos in *)
            (* let qvars1 = CP.diff_svl qvars rel_args in *)
            let ws = CP.fresh_spec_vars qvars in
            let st = List.combine qvars ws in
            let baref = mkBase qh qp qvp qt qfl qa pos in
            let new_baref = x_add subst st baref in
            let new_ctx = Ctx {estate with es_evars = ws @ estate.es_evars} in
            let tmp_rs, tmp_prf = heap_entail_split_rhs_phases prog is_folding  new_ctx new_baref drop_read_phase pos
            in
            (match tmp_rs with
             | FailCtx _ -> (tmp_rs, tmp_prf)
             | SuccCtx sl ->
               let prf = mkExRight ctx_0 conseq qvars ws tmp_prf in
               let todo_unk = List.map (redundant_existential_check ws) sl in
               let res_ctx =
                 if !Globals.elim_exists_ff then List.map elim_exists_ctx sl
                 else sl in
               (SuccCtx res_ctx, prf))
          | _ -> report_error no_pos ("[solver.ml]: No disjunction on the RHS should reach this level\n")
        end
    end
  | _ -> report_error no_pos ("[solver.ml]: No disjunctive context should reach this level\n")

and eliminate_exist_from_LHS qvars qh qp qvp qt qfl pos estate =
  let pr = Cprinter.string_of_spec_var_list in
  Debug.no_1 "eliminate_exist_from_LHS" pr pr_no (fun _ -> eliminate_exist_from_LHS_x qvars qh qp qvp qt qfl pos estate) qvars

and eliminate_exist_from_LHS_x qvars qh qp qvp qt qfl pos estate =
  (* eliminating existential quantifiers from the LHS *)
  (* ws are the newly generated fresh vars for the existentially quantified vars in the LHS *)
  let ws = CP.fresh_spec_vars qvars in
  let st = List.combine qvars ws in
  let a = formula_and_of_formula estate.es_formula in
  let baref = mkBase qh qp qvp qt qfl a pos in (*TO CHECK ???*)
  let new_baref = x_add subst st baref in
  (* new ctx is the new context after substituting the fresh vars for the exist quantified vars *)
  let new_ctx = Ctx {estate with
                     es_formula = new_baref;
                     es_ante_evars = ws @ estate.es_ante_evars;
                     es_term_res_lhs = List.map (CP.subst_term_ann st) estate.es_term_res_lhs;
                     es_unsat_flag = estate.es_unsat_flag;}
  in new_ctx

and heap_n_pure_entail(*_debug*) i prog is_folding  ctx0 conseq h p func drop_read_phase pos : (list_context * proof) =
  Debug.no_3_num i "heap_n_pure_entail" (Cprinter.string_of_context) Cprinter.string_of_h_formula Cprinter.string_of_mix_formula
    (fun (lc,_) -> match lc with FailCtx _ -> "Not OK" | SuccCtx _ -> "OK")  (fun ctx0 h p -> heap_n_pure_entail_x prog is_folding  ctx0 conseq h p func drop_read_phase pos) ctx0 h p

and heap_n_pure_entail_1 prog is_folding  ctx0 conseq h p func drop_read_phase pos =
  print_string "tracing heap_n_pure_entail_1\n"; (heap_n_pure_entail prog is_folding  ctx0 conseq h p func drop_read_phase pos)

and heap_n_pure_entail_2 prog is_folding  ctx0 conseq h p func drop_read_phase pos =
  print_string "tracing heap_n_pure_entail_2\n"; (heap_n_pure_entail prog is_folding  ctx0 conseq h p func drop_read_phase pos)

and heap_n_pure_entail_x (prog : prog_decl) (is_folding : bool) (ctx0 : context) (conseq : formula) (h : h_formula) rhs_pure func (drop_read_phase : bool)
    pos : (list_context * proof) =
  let ctx0 = disable_imm_last_phase_ctx ctx0 in
  let entail_h_ctx, entail_h_prf = x_add heap_entail_split_lhs_phases prog is_folding  ctx0 (func h (MCP.mkMTrue pos)) (consume_heap_h_formula h) pos in
  let entail_h_ctx = enable_imm_last_phase entail_h_ctx in
  match entail_h_ctx with
  | FailCtx _ -> (entail_h_ctx, entail_h_prf)
  | SuccCtx(cl) ->
    let entail_p = List.map (fun c ->
        let () = x_tinfo_hp (add_str "heap_n_pure_entail.rhs_pure" Cprinter.string_of_mix_formula) rhs_pure no_pos in
        one_ctx_entail prog is_folding c conseq func rhs_pure pos
      ) cl in
    let entail_p_ctx, entail_p_prf = List.split entail_p in
    let entail_p_prf = mkContextList cl (Cformula.struc_formula_of_formula conseq pos) entail_p_prf in
    let entail_p_ctx = fold_context_left 6 entail_p_ctx in
    (entail_p_ctx, entail_p_prf)

and one_ctx_entail prog is_folding  c conseq func p pos : (list_context * proof) =
  Debug.no_3 "one_ctx_entail" (Cprinter.string_of_context_short) Cprinter.string_of_formula Cprinter.string_of_mix_formula
    (* (fun (lc,_) -> match lc with FailCtx _ -> "Not OK" | SuccCtx _ -> "OK")  *)
    (fun (lc,_) -> Cprinter.string_of_list_context_short lc)
    (fun ctx0 conseq p ->  one_ctx_entail_x prog is_folding ctx0 conseq func p pos) c conseq p

and one_ctx_entail_x prog is_folding  c conseq func p pos : (list_context * proof) =
  (match c with
   | Ctx(estate) ->
     (* TODO : es_aux_conseq is an input here *)
     let h = match CF.split_components conseq with
       | HTrue, _, _, _, _, _ -> HTrue
       | _ -> HEmp in
     (*andreeac add info abt lhs constr*)
     let new_conseq = subst_avoid_capture (fst estate.es_subst) (snd estate.es_subst) (func h p) in
     let () = x_tinfo_hp (add_str "new_conseq one_ctx_entail" (Cprinter.string_of_formula)) new_conseq pos in
     let aux_c = estate.es_aux_conseq in
     let aux_c = match estate.es_exists_pure with
       | None      -> aux_c
       | Some ex_p -> CP.mkAnd ex_p aux_c pos in
     let aux_conseq = subst_avoid_capture (fst estate.es_subst) (snd estate.es_subst) (func h (MCP.mix_of_pure aux_c)) in
     let new_conseq = CF.mkStar new_conseq aux_conseq Flow_combine pos in
     (* TODO andreeac replace TempRes with known info in the resulted ctx of the following entail *)
     let (ctx,prf) = x_add heap_entail_conjunct 4 prog is_folding  c new_conseq []  pos in
     let ctx = Immutable.restore_tmp_ann_list_ctx ctx in
     (ctx, prf)
   | OCtx (c1, c2) ->
     let cl1, prf1 = one_ctx_entail prog is_folding  c1 conseq func p pos in
     let cl2, prf2 = one_ctx_entail prog is_folding  c2 conseq func p pos in
     let entail_p_ctx = x_add Cformula.or_list_context cl1 cl2  in
     let entail_p_prf = (match entail_p_ctx with
         | FailCtx _ -> mkContextList [] (Cformula.struc_formula_of_formula conseq pos) ([prf1]@[prf2])
         | SuccCtx cl -> mkContextList cl (Cformula.struc_formula_of_formula conseq pos) ([prf1]@[prf2])
       ) in
     (entail_p_ctx, entail_p_prf))

and heap_entail_rhs_read_phase prog is_folding  ctx0 h1 h2 h3 func pos =
  (* entail the read phase heap *)
  let new_conseq =
    if (is_empty_heap h2 && is_empty_heap h3) then func h1 (MCP.mkMTrue pos)
    else func h1 (MCP.mkMTrue pos) in
  let (after_rd_ctx, after_rd_prf) =
    x_add heap_entail_split_lhs_phases prog is_folding  ctx0 new_conseq false pos
  in (after_rd_ctx, after_rd_prf)

and heap_entail_rhs_write_phase prog is_folding  after_rd_ctx after_rd_prf conseq h1 h2 h3 func pos =
  match after_rd_ctx with
  | FailCtx _ -> (after_rd_ctx, after_rd_prf)
  | SuccCtx (cl) ->
    (* entail the write phase *)
    let new_conseq =
      if (is_empty_heap h3) then (func h2 (MCP.mkMTrue pos))
      else (func h2 (MCP.mkMTrue pos)) in
    let after_wr_ctx, after_wr_prfs =
      if not(is_empty_heap h2) then
        let after_wr = List.map (fun c -> x_add heap_entail_split_lhs_phases prog is_folding  c new_conseq true pos) cl in
        let after_wr_ctx, after_wr_prfs = List.split after_wr in
        let after_wr_prfs = mkContextList cl (Cformula.struc_formula_of_formula conseq pos) after_wr_prfs in
        let after_wr_ctx = fold_context_left 7 after_wr_ctx in
        (after_wr_ctx, after_wr_prfs)
      else
        (after_rd_ctx, after_rd_prf)
    in (after_wr_ctx, after_wr_prfs)

and heap_entail_rhs_nested_phase prog is_folding  after_wr_ctx after_wr_prfs conseq h1 h2 h3 func drop_read_phase pos =
  let pr = Cprinter.string_of_formula in
  Debug.no_1 "heap_entail_rhs_nested_phase" pr pr_none (fun _ -> heap_entail_rhs_nested_phase_x
                                                           prog is_folding  after_wr_ctx after_wr_prfs conseq h1 h2 h3 func drop_read_phase pos) conseq


and heap_entail_rhs_nested_phase_x prog is_folding  after_wr_ctx after_wr_prfs conseq h1 h2 h3 func drop_read_phase pos =
  match after_wr_ctx with
  |FailCtx _ ->  (after_wr_ctx, after_wr_prfs)
  | SuccCtx (cl) ->
    let (ctx, prf) =
      (match h3 with
       | HTrue ->
         (after_wr_ctx, after_wr_prfs)
       | _ ->
         if (CF.contains_phase h3) then
           let after_nested_phase = List.map (fun c -> heap_entail_split_rhs_phases prog is_folding  c (func h3 (MCP.mkMTrue pos)) drop_read_phase pos) cl in
           let after_nested_phase_ctx, after_nested_phase_prfs = List.split after_nested_phase in
           let after_nested_phase_prfs = mkContextList cl (Cformula.struc_formula_of_formula conseq pos) after_nested_phase_prfs in
           let after_nested_phase_ctx = fold_context_left 8 after_nested_phase_ctx in
           (after_nested_phase_ctx, after_nested_phase_prfs)
         else
           let after_nested_phase = List.map (fun c -> x_add heap_entail_split_lhs_phases prog is_folding  c (func h3 (MCP.mkMTrue pos)) drop_read_phase pos) cl in
           let after_nested_phase_ctx, after_nested_phase_prfs = List.split after_nested_phase in
           let after_nested_phase_prfs = mkContextList cl (Cformula.struc_formula_of_formula conseq pos) after_nested_phase_prfs in
           let after_nested_phase_ctx = fold_context_left 9 after_nested_phase_ctx in
           (after_nested_phase_ctx, after_nested_phase_prfs)
      )
    in (ctx, prf)

(* some helper methods *)
and insert_ho_frame_in2_formula_debug f ho =
  Debug.no_2 "insert_ho_frame_in2_formula" Cprinter.string_of_formula (fun _ -> "?") Cprinter.string_of_formula insert_ho_frame_in2_formula f ho

(* insert an higher order frame into a formula *)
and insert_ho_frame_in2_formula f ho_frame =
  (* if(!Globals.allow_field_ann) then f *)
  (* else  *)
  match f with
  | Base({formula_base_heap = h;
          formula_base_pure = p;
          formula_base_vperm = vp;
          formula_base_type = t;
          formula_base_flow = fl;
          formula_base_and = a;
          formula_base_label = l;
          formula_base_pos = pos}) ->
    mkBase (ho_frame h) p vp t fl a pos
  | Exists({formula_exists_qvars = qvars;
            formula_exists_heap = h;
            formula_exists_pure = p;
            formula_exists_vperm = vp;
            formula_exists_type = t;
            formula_exists_flow = fl;
            formula_exists_and = a;
            formula_exists_label = l;
            formula_exists_pos = pos}) ->
    mkExists qvars (ho_frame h) p vp t fl a pos
  | Or({formula_or_f1 = f1;
        formula_or_f2 = f2;
        formula_or_pos = pos;}) ->
    let new_f1 = insert_ho_frame_in2_formula f1 ho_frame in
    let new_f2 = insert_ho_frame_in2_formula f2 ho_frame in
    mkOr new_f1 new_f2 pos

and insert_ho_frame ctx ho_frame =
  match ctx with
  | Ctx(f) ->
    Ctx {f with es_formula =  insert_ho_frame_in2_formula f.es_formula ho_frame;}
  | OCtx(c1, c2) -> OCtx(insert_ho_frame c1 ho_frame, insert_ho_frame c2 ho_frame)

and choose_not_empty_heap h1 h2 h3 =
  if ((is_empty_heap h1) && (is_empty_heap h2)) then h3
  else if ((is_empty_heap h1) && (is_empty_heap h3)) then h2
  else h1

(* swaps the heap in f by h; returns the new formula and the extracted heap *)
and swap_heap (f : formula) (new_h : h_formula) pos : (formula * h_formula) =
  match f with
  | Base (bf) ->
    let h, p, vp, fl, t, a = CF.split_components f in
    (CF.mkBase new_h p vp t fl a pos, h)
  | Exists({formula_exists_qvars = qvars;
            formula_exists_heap = h;
            formula_exists_vperm = vp;
            formula_exists_pure = p;
            formula_exists_type = t;
            formula_exists_flow = fl;
            formula_exists_and = a;
            formula_exists_label = l;
            formula_exists_pos = pos }) ->
    (CF.mkExists qvars new_h p vp t fl a pos, h)
  | _ -> report_error no_pos ("solver.ml: No LHS disj should reach this point\n  ")


and heap_entail_split_lhs_phases p is_folding  ctx0 conseq d pos : (list_context * proof) =
  Debug.no_2 "heap_entail_split_lhs_phases" Cprinter.string_of_context (add_str "RHS" Cprinter.string_of_formula) (fun (c,_) -> Cprinter.string_of_list_context c)
    (fun ctx0 conseq -> heap_entail_split_lhs_phases_x p is_folding  ctx0 conseq d pos) ctx0 conseq

(* entailment method for splitting the antecedent *)
and heap_entail_split_lhs_phases_x (prog : prog_decl) (is_folding : bool) (ctx0 : context) (conseq : formula) (drop_read_phase : bool)
    pos : (list_context * proof) =
  (* WN : lhs_contra - need to check at beginning here if infer vars present *)
  x_dinfo_zp (lazy ("heap_entail_split_lhs_phases: \nante:\n" ^ (Cprinter.string_of_context ctx0) ^ "\nconseq:\n"
                    ^ (Cprinter.string_of_formula conseq))) pos;

  (***** main helper method ******)
  (* called for both formula base and formula exists *)
  let rec helper_lhs h func : (list_context * proof) =
    (* split h such that:
       h1 = rd phase
       h2 = write phase
       h3 = nested phase
    *)
    let h1, h2, h3 = split_phase(*_debug_lhs*) 2 h in
    if ((is_empty_heap h1) && (is_empty_heap h3)) || ((is_empty_heap h2) && (is_empty_heap h3))
    then
      (* lhs contains only one phase (no need to split) *)
      let new_ctx = CF.set_context_formula ctx0 (func (choose_not_empty_heap h1 h2 h3)) in
      x_tinfo_hp (add_str "new_ctx" Cprinter.string_of_context) new_ctx no_pos;
      (* in this case we directly call heap_entail_conjunct *)
      let final_ctx, final_prf = x_add heap_entail_conjunct 5 prog is_folding  new_ctx conseq []  pos in
      match final_ctx with
      | SuccCtx(cl) ->
        x_tinfo_hp (add_str "cl" (pr_list (Cprinter.string_of_context))) cl no_pos;
        (* substitute the holes due to the temporary removal of matched immutable nodes *)
        let cl1 = List.map (subs_crt_holes_ctx 6) cl in
        x_tinfo_hp (add_str "cl after subs" (pr_list (Cprinter.string_of_context))) cl no_pos;
        let cl1 = List.map (x_add_1 restore_tmp_ann_ctx) cl1 in
        x_tinfo_hp (add_str "cl after restore" (pr_list (Cprinter.string_of_context))) cl no_pos;
        (SuccCtx(cl1), final_prf)
      | FailCtx _ -> (final_ctx, final_prf)
    else
    if ((is_empty_heap h1) && (is_empty_heap h2)) then
      (* only the nested phase is different from true;*)
      let new_ctx = CF.set_context_formula ctx0 (func h3) in
      let final_ctx, final_prf =
        (* we must check whether this phase contains other nested phases *)
        if not(Cformula.contains_phase h3) then
          (* no other nested phases within h3 *)
          (* direct call to heap_entail_conjunct *)
          x_add heap_entail_conjunct 6 prog is_folding  new_ctx conseq [] pos
        else
          (* we need to recursively split the phases nested in h3 *)
          (* let () = print_string("\n\nRecursive call to heap_entail_split_lhs_phases\n") in *)
          x_add heap_entail_split_lhs_phases prog is_folding  new_ctx conseq drop_read_phase pos
      in
      match final_ctx with
      | SuccCtx(cl) ->
        (* substitute the holes due to the temporary removal of matched immutable nodes *)
        (* let () = print_string("Substitute the holes\n") in *)
        let cl1 = List.map (subs_crt_holes_ctx 7) cl in
        let cl1 = List.map (x_add_1 restore_tmp_ann_ctx) cl1 in
        (SuccCtx(cl1), final_prf)
      | FailCtx _ -> (final_ctx, final_prf)

    else
      (* lhs contains multiple phases *)
      (******************************************************)
      (****** the first entailment uses h1 as lhs heap ******)
      (******************************************************)
      let lhs_rd = func h1 in
      let rd_ctx = CF.set_context_formula ctx0 lhs_rd in
      x_dinfo_zp (lazy ("heap_entail_split_lhs_phases: \ncall heap_entail_conjunct with lhs = reading phase\n")) pos;
      let (with_rd_ctx, with_rd_prf) = x_add heap_entail_conjunct 7 prog is_folding  rd_ctx conseq [] pos in
      let with_rd_ctx =
        (match with_rd_ctx with
         | FailCtx _ -> with_rd_ctx
         | SuccCtx (cl) ->
           (* substitute the holes due to the temporary removal of matched immutable nodes *)
           (* let () = print_string("Substitute the holes \n") in *)
           let cl1 = List.map (subs_crt_holes_ctx 8) cl in
           let cl1 = List.map (x_add_1 restore_tmp_ann_ctx) cl1 in
           (* in case of success, put back the frame consisting of h2*h3 *)
           let cl2 = List.map (fun x -> insert_ho_frame x (fun f -> CF.mkPhaseH f (CF.mkStarH h2 h3 pos) pos)) cl1 in
           SuccCtx(cl2))
      in

      (*******************************************************)
      (****** the second entailment uses h2 as lhs heap ******)
      (*******************************************************)
      (* push h3 as a continuation in the current ctx *)
      let new_ctx = push_cont_ctx h3 ctx0 in
      (* set the es_formula to h2 *)
      let f_h2 = func h2 in
      let wr_ctx = CF.set_context_formula new_ctx f_h2 in
      x_dinfo_zp (lazy ("heap_entail_split_lhs_phases: \ncall heap_entail_conjunct with lhs = writing phase\n")) pos;
      let (with_wr_ctx, with_wr_prf) = x_add heap_entail_conjunct 8 prog is_folding  wr_ctx conseq []  pos in
      (******************************************************)
      (****** the third entailment uses h3 as lhs heap ******)
      (******************************************************)
      (* todo: check whether the conseq != null (?)*)
      (* check if there is need for another entailment that uses the continuation h3 *)
      let (final_ctx, final_prf) =
        match with_wr_ctx with
        | SuccCtx(cl) ->
          (* h2 was enough, no need to use h3 *)
          (* substitute the holes due to the temporary removal of matched immutable nodes *)
          (* let () = print_string("Substitute the holes \n") in *)
          let cl = List.map (subs_crt_holes_ctx 9) cl in
          let cl =  List.map (x_add_1 restore_tmp_ann_ctx) cl in
          (* put back the frame consisting of h1 and h3 *)
          (* first add the frame []*h3 *)
          let cl = List.map (fun x -> insert_ho_frame x (fun f -> CF.mkStarH f h3 pos)) cl in
          let cl =
            if not(consume_heap conseq) && not(drop_read_phase) then
              (* next add the frame h1;[]*)
              List.map (fun x -> insert_ho_frame x (fun f -> CF.mkPhaseH h1 f pos)) cl
            else
              (* else drop the read phase (don't add back the frame) *)
              let p1 = MCP.mkMTrue no_pos in (*TO CHECK: what is p1 ???*)
              let xpure_rd_0, _, memset_rd = x_add xpure_heap 2 prog h1 p1 0 in (*TO CHECK*)
              let xpure_rd_1, _, memset_rd = x_add xpure_heap 3 prog h1 p1 1 in
              (* add the pure info for the dropped reading phase *)
              List.map
                (Cformula.transform_context
                   (fun es ->
                      Ctx{es with
                          (* add xpure0 directly to the state formula *)
                          es_formula = mkStar es.es_formula (formula_of_mix_formula xpure_rd_0 pos) Flow_combine pos;
                          (* store xpure_1 of the dropped phase for the case it is needed later during the entailment (i.e. xpure0 is not enough) *)
                          es_aux_xpure_1 = MCP.merge_mems es.es_aux_xpure_1 xpure_rd_1 true;
                         })) cl
          in
          (SuccCtx(cl), with_wr_prf)
        | FailCtx(ft,_ ,_ ) ->
          (* insuccess when using lhs = h2; need to try the continuation *)
          match h3 with
          | HTrue -> (* h3 = true and hence it wont help *)
            (with_wr_ctx, with_wr_prf)
          | _ -> heap_entail_with_cont  prog is_folding  ctx0 conseq ft h1 h2 h3 with_wr_ctx with_wr_prf func drop_read_phase pos

      in
      (* union of states *)
      ((fold_context_left 10 [with_rd_ctx; final_ctx]),( mkOrRight ctx0 conseq [with_rd_prf; final_prf]))
  (*  end of helper method *)

  and heap_entail_with_cont (prog : prog_decl) (is_folding : bool) (ctx0 : context) (conseq : formula)
      (ft : fail_type) (h1 : h_formula) (h2 : h_formula) (h3 : h_formula) (with_wr_ctx : list_context)
      (with_wr_prf : proof) func (drop_read_phase : bool) pos : (list_context * proof) =

    Debug.no_2 "heap_entail_with_cont" (Cprinter.string_of_context) (fun _ -> "RHS") (fun _ -> "OUT")
      (fun ctx0 conseq -> heap_entail_with_cont_x prog is_folding  ctx0 conseq ft h1 h2 h3 with_wr_ctx with_wr_prf
          func drop_read_phase pos) ctx0 conseq

  (* handles the possible ent continuations *)
  and heap_entail_with_cont_x (prog : prog_decl)  (is_folding : bool) (ctx0 : context)  (conseq : formula)  (ft : fail_type)
      (h1 : h_formula) (h2 : h_formula) (h3 : h_formula) (with_wr_ctx : list_context)  (with_wr_prf : proof) func
      (drop_read_phase : bool) pos : (list_context * proof) =
    match ft with
    | ContinuationErr(fc,ft) ->
      begin
        (* check if there is any continuation in the continuation list es_cont *)
        let lhs = fc.fc_current_lhs in
        if (lhs.es_cont = []) then
          (* no continuation *)
          (* ---TODO:  need to enable folding --- *)
          (with_wr_ctx, with_wr_prf)
        else
          (* pop the continuation record *)
          (* the cont record contains (actual continuation to be used on the lhs, the failing lhs) *)
          (* actually, we already know the continuation is h3 *)
          let _, lhs = pop_cont_es lhs in
          (* retrieve the current conseq from the failed context *)
          let conseq = fc.fc_current_conseq in
          (* swap the current lhs heap (keep it as frame) and the continuation h3 *)
          let new_f, h2_rest = swap_heap lhs.es_formula h3 pos in
          (* create the current context containing the current estate *)
          let cont_ctx = Ctx({lhs with es_formula = new_f;}) in
          let after_wr_ctx, after_wr_prf =
            if (CF.contains_phase h3) then
              (x_winfo_zp (lazy ("heap_entail_split_lhs_phases: \ncall heap_entail_split_lhs_phase for the continuation\n")) pos;
               x_add heap_entail_split_lhs_phases prog is_folding  cont_ctx conseq drop_read_phase pos)
            else
              (x_winfo_zp (lazy ("heap_entail_split_lhs_phases: \ncall heap_entail_conjunct for the continuation\n")) pos;
               x_add heap_entail_conjunct 9 prog is_folding  cont_ctx conseq [] pos)
          in
          (match after_wr_ctx with
           | FailCtx _ -> (after_wr_ctx, after_wr_prf)
           | SuccCtx (cl) ->
             (* substitute the holes due to the temporary removal of matched immutable nodes *)
             (* let () = print_string("Substitute the holes\n") in *)
             let cl = List.map (subs_crt_holes_ctx 10) cl in
             let cl =  List.map (x_add_1 restore_tmp_ann_ctx) cl in
             (* in case of success, put back the frame consisting of h1 and what's left of h2 *)
             (* first add the frame h2_rest*[] *)
             let cl = List.map (fun x -> insert_ho_frame x (fun f -> CF.mkStarH h2_rest f pos)) cl in
             (* next add the frame h1;[]*)

             let cl =
               if not(consume_heap conseq)  && not(drop_read_phase) then
                 List.map (fun x -> insert_ho_frame x (fun f -> CF.mkPhaseH h1 f pos)) cl
               else
                 (* drop read phase *)
                 let p1 = MCP.mkMTrue no_pos in (*TO CHECK: what is p1 ???*)
                 let xpure_rd_0, _, memset_rd = x_add xpure_heap 4 prog h1 p1 0 in
                 let xpure_rd_1, _, memset_rd = x_add xpure_heap 5 prog h1 p1 1 in
                 (* add the pure info corresponding to the dropped reading phase *)
                 List.map
                   (Cformula.transform_context
                      (fun es ->
                         Ctx{es with
                             (* add xpure0 directly to the state formula *)
                             es_formula = mkStar es.es_formula (formula_of_mix_formula xpure_rd_0 pos) Flow_combine pos;
                             (* store xpure_1 of the dropped phase for the case it is needed later during the entailment (i.e. xpure0 is not enough) *)
                             es_aux_xpure_1 = MCP.merge_mems es.es_aux_xpure_1 xpure_rd_1 true;
                            })) cl

             in
             (SuccCtx(cl), after_wr_prf)
          )
      end
    | Or_Continuation(ft1, ft2) ->
      let ctx1, prf1 = heap_entail_with_cont prog is_folding  ctx0 conseq ft1 h1 h2 h3 with_wr_ctx with_wr_prf func drop_read_phase pos in
      let ctx2, prf2 = heap_entail_with_cont prog is_folding  ctx0 conseq ft2 h1 h2 h3 with_wr_ctx with_wr_prf func drop_read_phase pos in
      (* union of states *)
      ((fold_context_left 12 [ctx1; ctx2]),( mkOrRight ctx0 conseq [prf1; prf2]))
    | _ ->
      (* no continuation -> try to discharge the conseq by using h3 as lhs and h2*[] as frame *)
      (* create the new ctx *)
      let lhs_wr = func h3 in
      let wr_ctx = CF.set_context_formula ctx0 lhs_wr in
      let (with_wr_ctx, with_wr_prf) = x_add heap_entail_split_lhs_phases prog is_folding  wr_ctx conseq drop_read_phase pos in
      let (with_wr_ctx, with_wr_prf) =
        (match with_wr_ctx with
         | FailCtx _ -> (with_wr_ctx, with_wr_prf)
         | SuccCtx (cl) ->
           (* substitute the holes due to the temporary removal of matched immutable nodes *)
           (* let () = print_string("Substitute the holes \n") in *)

           let cl = List.map (subs_crt_holes_ctx 11) cl in
           let cl =  List.map (x_add_1 restore_tmp_ann_ctx) cl in
           (* in case of success, put back the frame consisting of h1;h2*[] *)
           (* first add the frame h2*[] *)
           let cl = List.map (fun x -> insert_ho_frame x (fun f -> CF.mkStarH h2 f pos)) cl in
           (* next add the frame h1;[]*)

           let cl =
             if not(consume_heap conseq)  && not(drop_read_phase) then
               List.map (fun x -> insert_ho_frame x (fun f -> CF.mkPhaseH h1 f pos)) cl
             else
               (* drop read phase *)
               let p1 = MCP.mkMTrue no_pos in (*TO CHECK: what is p1 ???*)
               let xpure_rd_0, _, memset_rd = x_add xpure_heap 6 prog h1 p1 0 in
               let xpure_rd_1, _, memset_rd = x_add xpure_heap 7 prog h1 p1 1 in
               (* add the pure info corresponding to the dropped reading phase *)
               List.map
                 (Cformula.transform_context
                    (fun es ->
                       Ctx{es with
                           (* add xpure0 directly to the state formula *)
                           es_formula = mkStar es.es_formula (formula_of_mix_formula xpure_rd_0 pos) Flow_combine pos;
                           (* store xpure_1 of the dropped phase for the case it is needed later during the entailment (i.e. xpure0 is not enough) *)
                           es_aux_xpure_1 = MCP.merge_mems es.es_aux_xpure_1 xpure_rd_1 true;
                          })) cl

           in (SuccCtx(cl), with_wr_prf)
        )
      in (with_wr_ctx, with_wr_prf)
  in

  (* main method *)
  let lhs = CF.formula_of_context ctx0
  in
  match lhs with
  | Base(bf) ->
    let h, p, vp, fl, t, a = CF.split_components lhs in
    helper_lhs h (fun xh -> CF.mkBase xh p vp t fl a pos)

  | Exists({formula_exists_qvars = qvars;
            formula_exists_heap = h;
            formula_exists_pure = p;
            formula_exists_vperm = vp;
            formula_exists_type = t;
            formula_exists_flow = fl;
            formula_exists_and = a;
            formula_exists_label = l;
            formula_exists_pos = pos }) ->
    helper_lhs h (fun xh -> CF.mkExists qvars xh p vp t fl a pos)
  | _ -> report_error no_pos ("[solver.ml]: No disjunction on the LHS should reach this level\n")


(*
  Find matched pairs of thread formula, do entailment, accumulate pure constraint
  a1 : child threads in the ante
  a2 : child threads in the conseq
  alla is total pure constraints in all threads of the ante (used to indentify thread id and assist proving)
  allc is total pure constraints in all threads of the conseq (used to identify thread id)
  return res1,res2,res2
  where
  res1 : None -> fail to entail the pairs, errors found in res2 (FAIL)
  Some p -> p=(to_ante,to_conseq),new_es (SUCCEED)
  where to_ante, to_conseq are the accumulate pure constraint
  new_es is the new entail_state with new instantiation vars and evars
  res2 : list_context of the entailment
  res3 :

  Others:
  estate: estate or ante of the main entailment. a1 belongs to estate
  conseq: conseq of the main entailment. a2 belongs to conseq
*)
(*NOTE: currently not support rhs with thread id as an evar
  or inst var*)
and heap_entail_thread prog (estate: entail_state) (conseq : formula) (a1: one_formula list) (a2: one_formula list) (alla: MCP.mix_formula) (allc: MCP.mix_formula) pos : ((MCP.mix_formula*MCP.mix_formula) * entail_state) option * (list_context * proof) * (one_formula list) =
  let pr_one_list = Cprinter.string_of_one_formula_list in
  let pr_out (a,(b1,b2),c) =
    let str1 = pr_opt (fun ((a1,a2),es) -> "\n\t ### to_ante = " ^ Cprinter.string_of_mix_formula a1 ^"\n\t ### to_conseq = " ^ Cprinter.string_of_mix_formula a2) a in
    let str2 = Cprinter.string_of_list_context b1 in
    let str3 = pr_one_list c in
    ("\n ### new_pure = " ^ str1 ^ "\n ### CTX = " ^ str2 ^ "\n ### rest_a = " ^ str3)
  in
  Debug.no_6 "heap_entail_thread"
    Cprinter.string_of_entail_state Cprinter.string_of_formula pr_one_list pr_one_list Cprinter.string_of_mix_formula Cprinter.string_of_mix_formula pr_out
    (fun _ _ _ _ _ _ -> heap_entail_thread_x prog estate conseq a1 a2 alla allc pos) estate conseq a1 a2 alla allc

and heap_entail_thread_x prog (estate: entail_state) (conseq : formula) (a1: one_formula list) (a2: one_formula list) (alla: MCP.mix_formula) (allc: MCP.mix_formula) pos : ((MCP.mix_formula*MCP.mix_formula) * entail_state) option * (list_context * proof) * (one_formula list) =
  (*return pair of matched one_formula of LHS and RHS*)
  (*MUST exist a Injective and non-surjective mapping from a2 to a1*)
  (*otherwise, failed*)
  let rhs_b = extr_rhs_b conseq in

  (*return a matched pair (f,one_f) and the rest (a1-f)*)
  let compute_thread_one_match_x a1 one_f alla allc =
    let rec helper a1 one_f =
      match a1 with
      | [] -> None,a1
      | x::xs ->
        let vs1 = MCP.find_closure_mix_formula x.formula_thread alla in
        let vs2 = MCP.find_closure_mix_formula one_f.formula_thread allc in
        let tmp = (Gen.BList.intersect_eq CP.eq_spec_var vs1 vs2) in
        (* if (CP.eq_spec_var x.formula_thread one_f.formula_thread) then *)
        if (tmp!=[]) then
          (Some (x,one_f),xs)
        else
          let res1,res2 = helper xs one_f in
          (res1,x::res2)
    in helper a1 one_f
  in
  let compute_thread_one_match (a1 : one_formula list) (one_f : one_formula) (alla:MCP.mix_formula) (allc: MCP.mix_formula) =
    let pr_out =
      pr_pair (pr_option (pr_pair Cprinter.string_of_one_formula Cprinter.string_of_one_formula)) (Cprinter.string_of_one_formula_list)
    in
    Debug.no_4 "compute_thread_one_match"
      Cprinter.string_of_one_formula_list  Cprinter.string_of_one_formula Cprinter.string_of_mix_formula Cprinter.string_of_mix_formula pr_out
      compute_thread_one_match_x a1 one_f alla allc
  in
  (*find all matched pairs*)
  let compute_thread_matches_x a1 a2 alla allc=
    let rec helper a1 a2 =
      match a2 with
      | [] -> (Some [], "empty",a1)
      | x::xs ->
        (*find a match for each iterm in a2*)
        let res1,a_rest = compute_thread_one_match a1 x alla allc in
        (match res1 with
         | None ->
           let error_msg = ("thread with id = " ^ (Cprinter.string_of_spec_var x.formula_thread) ^ " not found") in
           (None, error_msg,[])
         | Some (f1,f2) ->
           let res2,msg2,a1_rest = helper a_rest xs in
           (match res2 with
            | None -> (res2,msg2,[])
            | Some ls -> (Some ((f1,f2)::ls)) , "empty" , a1_rest))
    in helper a1 a2
  in
  let compute_thread_matches (a1 : one_formula list) (a2 : one_formula list) (alla:MCP.mix_formula) (allc: MCP.mix_formula) =
    let pr_one = Cprinter.string_of_one_formula in
    let pr_out (a,b,c) =
      let str1 = pr_option (pr_list (pr_pair pr_one pr_one)) a in
      let str2 = b in
      let str3 = Cprinter.string_of_one_formula_list c in
      ("\n ### matches = " ^ str1
       ^ "\n ### msg = " ^ str2
       ^ "\n ### rest_a = " ^ str3)
    in
    Debug.no_4 "compute_thread_matches"
      Cprinter.string_of_one_formula_list Cprinter.string_of_one_formula_list Cprinter.string_of_mix_formula Cprinter.string_of_mix_formula pr_out
      (fun _ _ _ _ -> compute_thread_matches_x a1 a2 alla allc) a1 a2 alla allc
  in
  (*compute matched pairs*)
  let res,msg,rest_a1 = compute_thread_matches a1 a2 alla allc in
  (*process matched pairs*)
  let res = match res with
    | None ->
      (None, (mkFailCtx_simple msg estate conseq (mk_cex true) pos, Failure),rest_a1)
    | Some matches ->
      (*try to entail f1 & p |- f2, p is additional pure constraints *)
      let process_thread_one_match_x estate (f1,f2 : one_formula * one_formula) =
        (*************************************************)
        (**************** matching VarPerm ***************)
        (*************************************************)
        (* CONVENTION: *)
        (*  @zero for the main thread *)
        (*  @full for the concurrent threads *)
        (* TODO: VPerm *)
        let f1_p = f1.formula_pure in
        (* let f1_vperms, new_f1_p = MCP.filter_varperm_mix_formula f1_p in                                                               *)
        (* let f1_full_vars = List.concat (List.map (fun f -> CP.varperm_of_formula f (Some VP_Full)) f1_vperms) in (*only pickup @full*) *)
        let f2_p = f2.formula_pure in
        (* let f2_vperms, new_f2_p = MCP.filter_varperm_mix_formula f2_p in                                                               *)
        (* let f2_full_vars = List.concat (List.map (fun f -> CP.varperm_of_formula f (Some VP_Full)) f2_vperms) in (*only pickup @full*) *)
        let f1_vperms, new_f1_p = [], f1_p in
        let f1_full_vars = [] in
        let f2_vperms, new_f2_p = [], f2_p in
        let f2_full_vars = [] in
        (*DO NOT CHECK permission for exists vars*)
        let f2_full_vars =
          if f1_full_vars=[] then f2_full_vars
          else Gen.BList.difference_eq CP.eq_spec_var_ident f2_full_vars estate.es_evars
        in
        (*----------------------------------------*)
        let vpem_str = ((string_of_vp_ann VP_Full) ^ (Cprinter.string_of_spec_var_list f1_full_vars) ^ " |- " ^ (string_of_vp_ann VP_Full) ^ (Cprinter.string_of_spec_var_list f2_full_vars)) in
        let () = if (f1_full_vars!=[] || f2_full_vars!=[]) then
            x_dinfo_pp ("\n process_thread_one_match: matching variable permissions of thread with id = " ^ (CP.string_of_spec_var f1.formula_thread) ^ " : " ^ vpem_str ^ "\n") pos
        in
        (*lhs should be more than rhs*)
        let tmp = Gen.BList.difference_eq CP.eq_spec_var_ident f2_full_vars f1_full_vars in
        if (tmp!=[]) then
          (*  let base_f1 = formula_of_one_formula f1 in*)
          (*  let base_f2 = formula_of_one_formula f2 in*)
          (*let new_es = {estate with es_formula=base_f1} in (*TO CHECK: should estate is a parameter*)*)
          (x_dinfo_pp ("heap_entail_thread: var " ^ (Cprinter.string_of_spec_var_list tmp)^ " MUST have full permission" ^ "\n") pos;
           x_dinfo_pp ("heap_entail_thread: failed in entailing variable permissions in conseq\n") pos;
           x_dinfo_pp ("heap_entail_empty_rhs_heap: formula is not valid\n") pos;
           let err_o = mkFailCtx_vperm "123" rhs_b estate conseq (mk_cex true) pos in
           (None, err_o))
        else
          (*************************************************)
          (*********<<<<<<< matching VarPerm ***************)
          (*************************************************)
          let new_f1 = {f1 with formula_pure = new_f1_p} in
          let new_f2 = {f2 with formula_pure = new_f2_p} in
          let base_f1 = formula_of_one_formula new_f1 in
          let base_f2 = formula_of_one_formula new_f2 in
          let new_es = {estate with es_formula=base_f1} in (*TO CHECK: should estate is a parameter*)
          let base_f2 = prune_preds prog true base_f2 in (* specialise --eps *)
          let new_ctx = Ctx new_es in
          x_dinfo_pp ("process_thread_one_match:"^"\n ### ante = " ^ (Cprinter.string_of_estate new_es)^"\n ###  conseq = " ^ (Cprinter.string_of_formula base_f2)) pos;
          (*a thread is a post-condition of its method. Therefore, it only has @full*)

          let rs0, prf0 = x_add (heap_entail_conjunct_helper ~caller:x_loc) 1 prog true new_ctx base_f2 [] pos in (*is_folding = true to collect the pure constraints of the RHS to es_pure*)
          (* check the flag to see whether should be true to result in es_pure*)
          (**************************************)
          (*        process_one 								*)
          (**************************************)
          let rec process_one rs1  =
            x_dinfo_pp ("process_thread_one_match: process_one: rs1:\n"^ (Cprinter.string_of_context rs1)) pos;
            match rs1 with
            | OCtx (c1, c2) ->
              (*Won't expect this case to happen*)
              let () = print_endline_quiet ("[WARNING] process_thread_one_match: process_one: unexpected disjunctive ctx \n") in
              (((MCP.mkMTrue pos) , (MCP.mkMTrue pos)),empty_es (mkTrueFlow ()) Label_only.Lab2_List.unlabelled pos)
            (* let tmp1 = process_one_x c1 in *)
            (* let tmp2 = process_one_x c2 in *)
            (* let tmp3 = (mkOCtx tmp1 tmp2 pos) in *)
            (* tmp3 *)
            | Ctx es ->
              (*Using es.es_pure for instantiation when needed*)
              let e_pure = MCP.fold_mem_lst (CP.mkTrue pos) true true es.es_pure in
              (*TO CHECK: this may have no effect at all*)
              let to_ante, to_conseq, new_evars =
                split_universal e_pure es.es_evars es.es_gen_expl_vars es.es_gen_impl_vars [] pos in
              (*ignore formula_branches at the moment*)
              (* TO CHECK: es.es_formula *)
              let _,p,_,_,_,_ = split_components es.es_formula in
              (* propagate the pure constraint to LHS of other threads *)
              (*instatiation*)
              let l_inst = es.es_gen_expl_vars@es.es_gen_impl_vars@es.es_ivars in
              let f = MCP.find_rel_constraints p l_inst in
              (*elim f1_full_vars because it can not appear in other threads*)
              let eli_evars = List.map (fun var -> match var with
                  | CP.SpecVar(t,v,p) -> CP.SpecVar (t,v,Primed)) f1_full_vars in
              let eli_evars=eli_evars@es.es_evars in
              let f2 = if (eli_evars = []) then f else
                  (elim_exists_mix_formula(*_debug*) eli_evars f no_pos) in
              let to_ante = (MCP.memoise_add_pure_N f2 to_ante) in
              (* let to_ante = remove_dupl_conj_eq_mix_formula to_ante in *)
              let to_conseq = (MCP.memoise_add_pure_N (MCP.mkMTrue no_pos) to_conseq) in
              (*TO DO: check for evars, ivars, expl_inst, impl_inst*)
              let new_impl_vars = Gen.BList.difference_eq CP.eq_spec_var es.es_gen_impl_vars (MCP.mfv to_ante) in
              let new_expl_vars = Gen.BList.difference_eq CP.eq_spec_var es.es_gen_expl_vars (MCP.mfv to_ante) in
              let new_ivars = Gen.BList.difference_eq CP.eq_spec_var es.es_ivars (MCP.mfv to_ante) in
              let new_estate = {es with
                                es_evars = new_evars;
                                es_ivars = new_ivars;
                                es_gen_impl_vars = new_impl_vars;
                                es_gen_expl_vars = new_expl_vars;}
              in
              ((to_ante, to_conseq),new_estate)
          in
          let res = match rs0 with
            | FailCtx (_,_, cex) ->
              let msg = ("Concurrency Error: could not match LHS and RHS of the thread with id = " ^ (CP.string_of_spec_var f1.formula_thread)) in
              (None, mkFailCtx_simple msg estate conseq cex pos)
            | SuccCtx l ->
              let ctx = List.hd l in (*Expecting a single ctx*)
              let res_p = process_one ctx  in
              (Some res_p, rs0)
          in res
      in
      let process_thread_one_match estate (f1,f2 : one_formula * one_formula) =
        let pr = pr_pair Cprinter.string_of_one_formula Cprinter.string_of_one_formula in
        let pr_out (res,rs0) =
          let pr ((a1,a2),new_es) = ("\n ### to_ante = " ^ (Cprinter.string_of_mix_formula a1)^"\n ### to_conseq = " ^ (Cprinter.string_of_mix_formula a2))  in
          pr_opt pr res
        in
        Debug.no_2 "process_thread_one_match"
          Cprinter.string_of_entail_state pr pr_out
          process_thread_one_match_x estate (f1,f2)
      in
      (*entail all threads*)
      (*return (to_ante,to_conseq) * list_context *)
      let process_thread_matches_x estate matches to_ante to_conseq =
        let rec helper estate matches to_ante to_conseq =
          (match matches with
           | [] -> (Some ((to_ante,to_conseq),estate), (SuccCtx []))
           | x::xs ->
             let f1,f2 = x in
             let new_p1 = add_mix_formula_to_mix_formula to_ante f1.formula_pure in
             (*TO DO: remove_dupl_conj*)
             let new_p1 = remove_dupl_conj_eq_mix_formula new_p1 in
             let new_f1 = {f1 with formula_pure = new_p1} in
             let new_p2 = add_mix_formula_to_mix_formula to_conseq f2.formula_pure in
             let new_p2 = remove_dupl_conj_eq_mix_formula new_p2 in
             let new_f2 = {f2 with formula_pure = new_p2} in
             let pure1, ctx1 = process_thread_one_match estate (new_f1,new_f2) in
             (match pure1 with
              | None -> (None,ctx1)
              | Some (p1,es1) ->
                let (to_ante, to_conseq) = p1 in
                let pure2,ctx2 = helper es1 xs to_ante to_conseq in
                (match pure2 with
                 | None -> (pure2,ctx2)
                 | Some (p2,es2)->
                   (*let to_ante2, to_conseq2 = p2 in*)
                   (* let new_pure = add_mix_formula_to_mix_formula p2 p1 in *)
                   (Some (p2,es2),ctx2))))
        in helper estate matches to_ante to_conseq
      in
      (*alla is total pure constraints in all threads of the ante*)
      let process_thread_matches estate matches to_ante to_conseq =
        let pr_one = Cprinter.string_of_one_formula in
        let pr = pr_list (pr_pair pr_one pr_one) in
        let pr_out (a,b) =
          let str1 = pr_opt (fun ((a1,a2),es) ->
              "\n\t ### to_ante = " ^ Cprinter.string_of_mix_formula a1
              ^"\n\t ### to_conseq = " ^ Cprinter.string_of_mix_formula a2
            ) a in
          let str2 = Cprinter.string_of_list_context b in
          ("\n ### new_pure = " ^ str1 ^ "\n ### CTX = " ^ str2)
        in
        Debug.no_2 "process_thread_matches"
          pr Cprinter.string_of_mix_formula pr_out
          (fun _ _ -> process_thread_matches_x estate matches to_ante to_conseq) matches to_ante
      in
      let to_conseq = (MCP.mkMTrue pos) in
      let res_p,res_ctx = process_thread_matches estate matches alla to_conseq in
      (res_p, (res_ctx,Unknown),rest_a1)
  in res

(* check the entailment of two conjuncts  *)
(* return value: if fst res = true, then  *)
(* snd res is the residual. Otherwise     *)
(* snd res is the constraint that causes  *)
(* the check to fail.                     *)

and hec_stack = new Gen.stack_pr "hec-stk" (string_of_int) (==)

(* hec_num denotes particular id of caller *)
and heap_entail_conjunct hec_num (prog : prog_decl) (is_folding : bool)  (ctx0 : context) (conseq : formula)
    (rhs_h_matched_set:CP.spec_var list) pos : (list_context * proof) =
  (* Trung: TODO remove it later *)
  (* let () = Solver_dp.prove_entailment conseq conseq in *)
  let hec is_folding ctx0 c =
    let res, prf = heap_entail_conjunct_x prog is_folding ctx0 c rhs_h_matched_set pos in
    let res1 =
      if (* false *)
        CF.is_en_error_exc_ctx ctx0
      then
        if not(!Globals.temp_opt_flag) then
          (* let () = x_tinfo_pp "temp_opt:convert_maymust" no_pos in *)
          CF.convert_maymust_failure_to_value_orig ~mark:true res
        else
          (*   let () = x_tinfo_pp "temp_opt:no convert_maymust" no_pos in *)
          res
      else
        (* let () = x_tinfo_pp "no convert_maymust" no_pos in *)
        res
    in
    (res1,prf)
  in
  let es_opt = match ctx0 with
    | Ctx es -> Some es
    | _ -> None in (* WN : info seems before entailment *)
  let hec a b c =
    let (ante,consumed_heap,evars,impl_vars,infer_type,infer_vars) =
      match ctx0 with
      | OCtx _ -> (CF.mkTrue (CF.mkTrueFlow ()) pos (* impossible *),
                   CF.HEmp, [],[], None, [])
      | Ctx estate ->
        let proving_kind = find_impt_proving_kind () in
        let lex_lhs =
          let collect_lexvar m =
            match m with
            | None -> []
            | Some (ann, rnk, _) -> [CP.mkLexVar_pure ann rnk []]
            (* if CP.is_MayLoop ann then []       *)
            (* else [CP.mkLexVar_pure ann rnk []] *)
          in
          match proving_kind with
          | PK_POST ->
            if estate.es_term_res_lhs != [] then
              List.map (fun ann -> CP.mkLexVar_pure ann [] []) estate.es_term_res_lhs
            else collect_lexvar estate.es_var_measures
          | _ -> collect_lexvar estate.es_var_measures
        in
        let es = List.fold_left (fun es lv -> fst
                                    (CF.combine_and es (MCP.mix_of_pure lv))) estate.es_formula lex_lhs in
        (es,estate.es_heap,estate.es_evars,estate.es_gen_impl_vars,CF.infer_type_of_entail_state estate,
         (estate.es_infer_vars@estate.es_infer_vars_rel@estate.es_infer_vars_hp_rel@estate.es_infer_vars_templ))
    in
    (* WN : what if evars not used in the conseq? *)
    let conseq = CF.push_exists evars conseq in
    let avoid = (hec_num=11) in
    let avoid = avoid || ((hec_num=1 || hec_num=2) && CF.isTrivTerm conseq) in
    (* let avoid = avoid || ((hec_num=1 || hec_num=2) && CF.is_emp_term conseq) in*)
    let avoid = avoid || (not (hec_stack # is_empty)) in
    let caller = hec_stack # string_of_no_ln in
    let slk_no = (* if avoid then 0 else *) (Log.last_cmd # start_sleek 3) in
    (* let () = Log.last_sleek_command # set (Some (ante,conseq)) in *)
    let () = hec_stack # push slk_no in
    (* let () = y_tinfo_hp (add_str "slk no" string_of_int) slk_no in *)
    let logger fr tt timeout =
      let () =
        x_add Log.add_sleek_logging es_opt timeout tt infer_type infer_vars (check_is_classic ())
          caller avoid hec_num slk_no ante conseq consumed_heap evars impl_vars
          (match fr with Some (lc,_) -> Some lc | None -> None) pos in
      ("sleek",(string_of_int slk_no))
    in
    let r =
      if not(slk_no = !Debug.devel_debug_sleek_proof) then
        Timelog.log_wrapper "sleek-hec" logger (hec a b) c
      else
        let s = "Sleek Proof No "^(string_of_int slk_no) in
        Wrapper.wrap_dd s (Timelog.log_wrapper "sleek-hec" logger (hec a b)) c
    in
    (* let tstart = Gen.Profiling.get_time () in		 *)
    (* let r = hec a b c in *)
    (* let tstop = Gen.Profiling.get_time () in *)
    (* let ttime = tstop -. tstart in *)
    let () = hec_stack # pop in
    let (lc,_) = r in
    (* let () = x_add Log.add_sleek_logging false ttime infer_vars (check_is_classic ()) caller avoid hec_num slk_no ante conseq consumed_heap evars lc pos in *)
    let () = x_tinfo_hp (add_str "avoid" string_of_bool) avoid no_pos in
    let () = x_tinfo_hp (add_str "slk no" string_of_int) slk_no no_pos in
    (* let () = Debug.ninfo_hprint (add_str "lc" Cprinter.string_of_list_context) lc no_pos in *)
    r
  in
  Debug.no_3_num hec_num "heap_entail_conjunct" string_of_bool Cprinter.string_of_context Cprinter.string_of_formula
    (fun (c,_) -> Cprinter.string_of_list_context c)
    hec is_folding ctx0 conseq

and heap_entail_conjunct_x (prog : prog_decl) (is_folding : bool)  (ctx0 : context) (conseq : formula) rhs_matched_set pos : (list_context * proof) =
  (* PRE : BOTH LHS and RHS are not disjunctive *)
  x_ninfo_zp (lazy ("heap_entail_conjunct:\ncontext:\n" ^ (Cprinter.string_of_context ctx0) ^ "\nconseq:\n" ^ (Cprinter.string_of_formula conseq))) pos;
  let ls, prf = x_add (heap_entail_conjunct_helper ~caller:x_loc) 3 prog is_folding  ctx0 conseq rhs_matched_set pos in
  let ls, prf = post_process_result ls prf in
  (* to convert failure -> normal with corr. error flows *)
  let ls1 = ls
  in
  ls1,prf
(* check the entailment of two conjuncts  *)
(* return value: if fst res = true, then  *)
(* snd res is the residual. Otherwise     *)
(* snd res is the constraint that causes  *)
(* the check to fail.                     *)

and heap_entail_conjunct_helper ?(caller="") i (prog : prog_decl) (is_folding : bool)  (ctx0 : context) (conseq : formula)
    (rhs_h_matched_set:CP.spec_var list) pos : (list_context * proof) =
  let pr1 = Cprinter.string_of_context in
  let pr2 (r,_) = Cprinter.string_of_list_context r in
  let pr3  = Cprinter.string_of_formula in
  Debug.no_2_num(* _loop *) i "heap_entail_conjunct_helper" pr1  pr3 pr2
    (fun _ _ -> heap_entail_conjunct_helper_x ~caller:caller prog is_folding ctx0 conseq rhs_h_matched_set pos) ctx0 conseq

and heap_entail_conjunct_helper_x ?(caller="") (prog : prog_decl) (is_folding : bool)  (ctx0 : context) (conseq : formula)
    (rhs_h_matched_set:CP.spec_var list) pos : (list_context * proof) =
  x_dinfo_zp (lazy ("heap_entail_conjunct_helper:\ncontext:\n" ^ (Cprinter.string_of_context ctx0)^ "\nconseq:\n" ^ (Cprinter.string_of_formula conseq))) pos;
  (* let () = print_endline ("locle cons: " ^ (Cprinter.string_of_formula conseq)) in *)
  match ctx0 with
  | OCtx _ -> report_error pos ("heap_entail_conjunct_helper: context is disjunctive or fail!!!")
  | Ctx estate ->
    x_tinfo_hp (add_str "ctx0.es_heap bef" (Cprinter.string_of_h_formula)) estate.es_heap no_pos;
    let ante0 = estate.es_formula in
    (* let () = y_tinfo_pp "==================================================" in *)
    (* let () = y_tinfo_hp (add_str "LHS " Cprinter.string_of_formula) ante0 in *)
    (* let () = y_tinfo_hp (add_str "RHS " Cprinter.string_of_formula) conseq in *)
    (* let () = y_tinfo_pp "==================================================" in *)
    (*print_string ("\nAN HOA CHECKPOINT :: Antecedent: " ^ (Cprinter.string_of_formula ante))*)
    let ante = if(!Globals.allow_mem) then Mem.ramify_starminus_in_formula ante0 prog.prog_view_decls else ante0 in
    (*let ante = if(!Globals.allow_field_ann) then Mem.compact_nodes_with_same_name_in_formula ante else ante in *)
    x_tinfo_hp (add_str "heap_entail_conjunct_helper conseq" (Cprinter.string_of_formula)) conseq no_pos;
    let conseq = if(!Globals.allow_mem) then Mem.remove_accs_from_formula conseq else conseq in
    let ctx0 = Ctx{estate with es_formula = ante;} in

    match ctx0 with
    | OCtx _ -> report_error pos ("heap_entail_conjunct_helper: context is disjunctive or fail!!!")
    | Ctx estate -> (
        let ante = estate.es_formula in
        x_tinfo_hp (add_str "ctx0.es_heap after" (Cprinter.string_of_h_formula)) estate.es_heap no_pos;
        let () = Debug.tinfo_hprint (add_str "heap_entail_conjunct_helper:es_form " Cprinter.string_of_formula) estate.es_formula no_pos in
        match ante with
        | Exists {formula_exists_qvars = qvars;
                  formula_exists_heap = qh;
                  formula_exists_pure = qp;
                  formula_exists_vperm = qvp;
                  formula_exists_type = qt;
                  formula_exists_flow = qfl;
                  formula_exists_and = qa;
                  formula_exists_pos = pos} -> (
            (* eliminating existential quantifiers from the LHS *)
            (* ws are the newly generated fresh vars for the existentially quantified vars in the LHS *)
            let ws = CP.fresh_spec_vars qvars in
            (* TODO : for memo-pure, these fresh_vars seem to affect partitioning *)
            let st = List.combine qvars ws in
            let baref = mkBase qh qp qvp qt qfl qa pos in
            let new_baref = x_add subst st baref in
            let fct st v =
              try
                let (_,v2) = List.find (fun (v1,_) -> CP.eq_spec_var_ident v v1) st in
                (*If zero_perm is an exists var -> rename it *)
                v2
              with _ -> v in
            let new_zero_vars = List.map (fct st) estate.es_var_zero_perm in
            (* let () = print_endline ("heap_entail_conjunct_helper: rename es.es_var_zero_perm: \n ### old = " ^ (Cprinter.string_of_spec_var_list estate.es_var_zero_perm) ^ "\n ### new = " ^ (Cprinter.string_of_spec_var_list new_zero_vars)) in *)
            (* let () =  print_endline ("new_baref:" ^ (Cprinter.string_of_formula new_baref) )  in *)
            (* new ctx is the new context after substituting the fresh vars for the exist quantified vars *)
            let new_ctx = Ctx {estate with es_var_zero_perm = new_zero_vars;
                                           es_formula = new_baref (* estate.es_formula *);
                                           es_ante_evars = ws @ estate.es_ante_evars;
                                           es_term_res_lhs = List.map (CP.subst_term_ann st) estate.es_term_res_lhs;
                                           es_unsat_flag = estate.es_unsat_flag;} in
            Debug.ninfo_hprint (add_str "new_ctx (exists)" (Cprinter.string_of_context)) new_ctx no_pos;
            (* call the entailment procedure for the new context - with the existential vars substituted by fresh vars *)
            (* WN : need to drop outer Exist to avoid looping *)
            let rs, prf1 = x_add (heap_entail_conjunct_helper ~caller:(x_loc^":"^caller)) 2 prog is_folding  new_ctx conseq rhs_h_matched_set pos in
            (* --- added 11.05.2008 *)
            let new_rs =
              if !Globals.wrap_exist then
                (* the fresh vars - that have been used to substitute the existenaltially quantified vars - need to be existentially quantified after the entailment *)
                (add_exist_vars_to_ctx_list rs ws)
              else
                rs in
            Debug.ninfo_hprint (add_str "new_rs (exists)" (Cprinter.string_of_list_context)) new_rs no_pos;
            (* log the transformation for the proof tracere *)
            let prf = mkExLeft ctx0 conseq qvars ws prf1 in
            (new_rs, prf)
          )
        | _ -> (
            match conseq with
            | Exists {formula_exists_qvars = qvars;
                      formula_exists_heap = qh;
                      formula_exists_pure = qp;
                      formula_exists_vperm = qvp;
                      formula_exists_type = qt;
                      formula_exists_flow = qfl;
                      formula_exists_and = qa;
                      formula_exists_pos = pos} -> (
                (* quantifiers on the RHS. Keep them for later processing *)
                let qvars_fo = List.filter (fun (CP.SpecVar (t,_,_)) ->
                    match t with
                    | RelT _ | HpT -> false
                    | _ -> true
                  ) qvars in
                Debug.ninfo_hprint (add_str "qvars " !CP.print_svl) qvars no_pos;
                Debug.ninfo_hprint (add_str "qvars_fo " !CP.print_svl) qvars_fo no_pos;
                (* let ws = CP.fresh_spec_vars qvars in *)
                let ws = CP.fresh_spec_vars qvars_fo in
                (* let st = List.combine qvars ws in *)
                let st_fo = List.combine qvars_fo ws in
                let baref = mkBase qh qp qvp qt qfl qa pos in
                let new_baref = x_add subst (* st *) st_fo baref in
                Debug.ninfo_hprint (add_str " baref " Cprinter.string_of_formula) baref no_pos;
                Debug.ninfo_hprint (add_str " new_baref " Cprinter.string_of_formula) new_baref no_pos;
                let new_ctx = Ctx {estate with es_evars = ws @ estate.es_evars} in
                x_tinfo_hp (add_str "new_ctx match" (Cprinter.string_of_context)) new_ctx no_pos;
                let tmp_rs, tmp_prf = heap_entail_conjunct_helper_x ~caller:(x_loc^":"^caller) (* 5 *) prog is_folding  new_ctx new_baref rhs_h_matched_set pos in
                match tmp_rs with
                | FailCtx _ -> (tmp_rs, tmp_prf)
                | SuccCtx sl ->
                  let prf = mkExRight ctx0 conseq qvars ws tmp_prf in
                  (*added 09-05-2008 , by Cristian, checks that after the RHS existential elimination the newly introduced variables will no appear in the residue hence no need to quantify*)
                  let todo_unk = List.map (redundant_existential_check ws) sl in
                  let res_ctx =
                    if !Globals.elim_exists_ff then List.map elim_exists_ctx sl
                    else sl in
                  let r = SuccCtx res_ctx in
                  (r, prf)
              )
            | _ -> (
                let h1, p1, vp1, fl1, t1, a1 = split_components ante in
                (* moved to classic unfolding *)
                (* let base_lhs = CF.get_formula_base ante in *)
                let h2, p2, vp2, fl2, t2, a2 = split_components conseq in
                let pure_rhs = p2 in
                let () = x_tinfo_hp  (add_str "entail_conjunct h1" (Cprinter.string_of_h_formula)) h1 no_pos in
                let () = x_tinfo_hp  (add_str "entail_conjunct h2" (Cprinter.string_of_h_formula)) h2 no_pos in
                let () = x_tinfo_hp  (add_str "entail_conjunct p1" (Cprinter.string_of_mix_formula)) p1 no_pos in
                let () = x_tinfo_hp  (add_str "entail_conjunct p2" (Cprinter.string_of_mix_formula)) p2 no_pos in

                let estate = if !Globals.allow_imm || (!Globals.allow_field_ann) then estate else
                    let null_p = CP.get_null_formula (MCP.pure_of_mix p2) in
                    let ctx_with_rhs es=
                      let () = x_tinfo_hp (add_str "rhs_pure" Cprinter.string_of_mix_formula) p2 no_pos in
                      let eqns = (MCP.ptr_equations_without_null p2) in
                      {es with es_rhs_eqset=(es.es_rhs_eqset@eqns);}
                    in
                    if CP.isConstTrue null_p then ctx_with_rhs estate else
                      let es1 = (ctx_with_rhs estate) in
                      {es1 with CF.es_conseq_pure_lemma = CP.mkAnd es1.CF.es_conseq_pure_lemma null_p pos;}
                in
                x_tinfo_hp (add_str "estate" (Cprinter.string_of_entail_state)) estate no_pos;

                if (not(is_false_flow fl2.formula_flow_interval)) && not(CF.subsume_flow_ff fl2 fl1)
                then (
                  x_tinfo_zp (lazy ("heap_entail_conjunct_helper: conseq has an incompatible flow type\ncontext:\n"
                                    ^ (Cprinter.string_of_context ctx0) ^ "\nconseq:\n" ^ (Cprinter.string_of_formula conseq))) pos;
                  (* what if must failure on the ante -> conseq *)
                  let f1_exc = (exlist # get_closest fl1.CF.formula_flow_interval) in
                  let f2_exc = (exlist # get_closest fl2.CF.formula_flow_interval) in
                  let () = x_tinfo_hp (add_str "fl1_exc" pr_id) f1_exc no_pos in
                  let () = x_tinfo_hp (add_str "fl2_exc" pr_id) f2_exc no_pos in
                  if (CF.overlap_flow_ff fl2 fl1) then (
                    let () = x_tinfo_pp "(overlap_flow):then" no_pos in

                    let err_msg =
                      if (CF.subsume_flow_f !error_flow_int fl1) then
                        ("1.2a: " ^ (f1_exc))
                      else
                        let msg = "1.2b: ante flow:"^f1_exc^" conseq flow: "^f2_exc^" are incompatible flow types" in
                        x_add repl_msg_final_error msg estate
                    in
                    let fe = mk_failure_may err_msg undefined_error in
                    let may_flow_failure =
                      FailCtx ((Basic_Reason ({fc_message = err_msg;
                                               fc_current_ents = [];
                                               fc_current_lhs = estate;
                                               fc_orig_conseq = struc_formula_of_formula conseq pos;
                                               fc_prior_steps = estate.es_prior_steps;
                                               fc_current_conseq = CF.formula_of_heap HFalse pos;
                                               fc_failure_pts =[];}, fe, estate.es_trace)), Ctx (convert_to_must_es estate), mk_cex true) in
                    (may_flow_failure, UnsatConseq)
                  )
                  else (
                    let () = x_tinfo_pp "not(overlap_flow)_ff:else" no_pos in
                    let err_msg=
                      let msg = "1.2c: ante flow:"^f1_exc^" conseq flow: "^f2_exc^" are incompatible flow types" in
                      x_add repl_msg_final_error msg estate in
                    let fe = mk_failure_must err_msg "incompatible types" in
                    let err_f = CF.substitute_flow_into_f !error_flow_int estate.CF.es_formula in
                    (CF.mkFailCtx_in (Basic_Reason ({fc_message =err_msg;
                                                     fc_current_ents = [];
                                                     fc_current_lhs = if !Globals.temp_opt_flag then
                                                         { estate with CF.es_formula = err_f} else estate;
                                                     fc_orig_conseq = struc_formula_of_formula conseq pos;
                                                     fc_prior_steps = estate.es_prior_steps;
                                                     fc_current_conseq = CF.formula_of_heap HFalse pos;
                                                     fc_failure_pts =[];}, fe, estate.es_trace)) ({estate with es_formula = CF.substitute_flow_into_f !error_flow_int estate.es_formula}, err_msg, Failure_Must err_msg) (mk_cex true), UnsatConseq)
                  )
                )
                else (
                  if ((List.length a2) > (List.length a1)) then
                    let msg = "Concurrency Error: conseq has more threads than ante" in
                    (mkFailCtx_simple msg estate conseq (mk_cex true) pos , Failure)
                  else (
                    if (a2==[]) then (
                      (* if conseq has no concurrent threads,
                         carry on normally and the concurrent threads
                         in the ante will be passed throught the entailment*)
                      match h2 with
                      | HFalse | HEmp | HTrue (* | HRel _ *) -> (
                          x_tinfo_zp (lazy ("heap_entail_conjunct_helper: conseq has an empty heap component"
                                            ^ "\ncontext:\n" ^ (Cprinter.string_of_context ctx0)
                                            ^ "\nconseq:\n"  ^ (Cprinter.string_of_formula conseq))) pos;
                          (*simplify htrue in LHS*)
                          let h1 = x_add_1 Cfutil.simplify_htrue h1 in
                          let estate = {estate with es_formula =
                                                      formula_trans_heap_node Cfutil.simplify_htrue estate.es_formula} in
                          let () = x_tinfo_hp (add_str "!rhs_rest_emp" string_of_bool) (!rhs_rest_emp) no_pos in
                          let () = x_tinfo_hp (add_str "is_folding" string_of_bool) (is_folding) no_pos in
                          let base_lhs = CF.get_formula_base ante in
                          let prep_h1 = h1 in
                          let is_lhs_emp =
                            if ((check_is_classic ()) && (h2 = HEmp)) then
                              Some (is_classic_lhs_emp prog h1 ante pos)
                            else None
                          in
                          let () = x_tinfo_hp (add_str "h1: " !CF.print_h_formula) h1 no_pos in
                          let () = x_tinfo_hp (add_str "h2: " !CF.print_h_formula) h2 no_pos in
                          let () = x_tinfo_hp (add_str "base_lhs " !CF.print_formula) (Base base_lhs) no_pos in
                          let new_flag = match is_lhs_emp with
                            | None -> false
                            | Some f -> not f in
                          let is_rhs_emp = not is_folding && !rhs_rest_emp in
                          if ((check_is_classic ()) && (h2 = HEmp)
                              && is_rhs_emp
                              && new_flag
                              && (not ( Cformula.is_HRel prep_h1))
                             )
                          then (
                            (* WN : shouldn't we fail if no_infer_hp_rel *)
                            if  (* not *) (no_infer_hp_rel estate) then
                              let () = x_tinfo_pp "no_infer_hp_rel? " no_pos in
                              let err_msg =  "residue is forbidden.(1)" in
                              let fail_ctx = mkFailContext "classical separation logic" estate conseq None pos in
                              let ls_ctx = CF.mkFailCtx_in (Basic_Reason (fail_ctx, CF.mk_failure_must (* "residue is forbidden.(1)" *) err_msg "" , estate.es_trace)) ({estate with es_formula = CF.substitute_flow_into_f !error_flow_int estate.es_formula}, err_msg, Failure_Must err_msg) (mk_cex true) in
                              let proof = mkClassicSepLogic ctx0 conseq in
                              let () = x_tinfo_hp (add_str "ls_ctx" Cprinter.string_of_list_context) ls_ctx no_pos in
                              (ls_ctx, proof)
                            else (* not !Globals.old_infer_hp_rel_classic *)
                              (* this is to make infer_collect_hp_rel_classsic  obsolete *)
                              let () = x_tinfo_hp (add_str "prep_h1(for classic): " !CF.print_h_formula) prep_h1 no_pos in
                              let ctx, proof = x_add heap_entail_empty_rhs_heap 3 prog conseq is_folding estate base_lhs pure_rhs rhs_h_matched_set pos in
                              (ctx, proof)
                          )
                          else (
                            let b1 = {formula_base_heap = h1;
                                      formula_base_pure = p1;
                                      formula_base_vperm = vp1;
                                      formula_base_type = t1;
                                      formula_base_and = a1; (*TO CHECK: Done: pass a1 through*)
                                      formula_base_flow = fl1;
                                      formula_base_label = None;
                                      formula_base_pos = pos } in
                            (* at the end of an entailment due to the epplication of an universal lemma, we need to move the explicit instantiation to the antecedent  *)
                            (* Remark: for universal lemmas we use the explicit instantiation mechanism,  while, for the rest of the cases, we use implicit instantiation *)

                            let () = x_tinfo_hp (add_str "h1: " !CF.print_h_formula) h1 no_pos in
                            let () = x_tinfo_hp (add_str "h2: " !CF.print_h_formula) h2 no_pos in
                            let () = x_tinfo_hp (add_str "prep_h1: " !CF.print_h_formula) prep_h1 no_pos in
                            let () = x_tinfo_hp (add_str "rhs_rest_emp: " string_of_bool) (!rhs_rest_emp) no_pos in
                            let () = x_tinfo_hp (add_str "is_folding: " string_of_bool) (is_folding) no_pos in
                            let () = x_tinfo_hp (add_str "(check_is_classic ())" string_of_bool) ((check_is_classic ())) no_pos in
                            let () = x_tinfo_hp (add_str "is_rhs_emp" string_of_bool) (is_rhs_emp) no_pos in
                            let () = x_tinfo_hp (add_str "conseq" !CF.print_formula) conseq no_pos in
                            let ctx, proof = x_add heap_entail_empty_rhs_heap 1 prog conseq is_folding  estate b1 p2 rhs_h_matched_set pos in
                            let new_ctx =
                              try
                                match ctx with
                                | FailCtx _ -> ctx
                                | SuccCtx cl ->
                                  let new_cl =
                                    List.map (fun c ->
                                        (transform_context
                                           (fun es ->
                                              let l_inst = get_expl_inst es p2 in
                                              x_tinfo_hp (add_str "l_inst" Cprinter.string_of_mix_formula) l_inst no_pos;
                                              x_tinfo_hp (add_str "p2" Cprinter.string_of_mix_formula) p2 no_pos;
                                              let es = x_add move_impl_inst_estate es p2 in
                                              Ctx (if (es.es_imm_last_phase) then
                                                     x_add move_expl_inst_estate es p2
                                                   else begin
                                                     x_tinfo_hp (add_str "es" Cprinter.string_of_entail_state) es no_pos;
                                                     let new_es = add_to_aux_conseq_estate es (MCP.pure_of_mix l_inst) pos in
                                                     x_tinfo_hp (add_str "new_es" Cprinter.string_of_entail_state) new_es no_pos;
                                                     new_es
                                                   end )
                                           )  c)) cl in
                                  SuccCtx(new_cl)
                              with False_from_explicit_inst msg ->
                                let ls_ctx = Errctx.mkFailCtx_may x_loc ("False from explicit inst "^msg) estate pos in
                                ls_ctx
                            in
                            (* let () = print_string("\nNEW Ctx: "^(Cprinter.string_of_list_context new_ctx)^"\n") in *)
                            x_tinfo_hp (add_str "new_ctx" (Cprinter.string_of_list_context)) new_ctx no_pos;
                            (new_ctx, proof)
                          )
                        )
                      | _ -> (
                          x_dinfo_zp (lazy ("heap_entail_conjunct_helper: "
                                            ^ "conseq has an non-empty heap component"
                                            ^ "\ncontext:\n" ^ (Cprinter.string_of_context ctx0)
                                            ^ "\nconseq:\n" ^ (Cprinter.string_of_formula conseq))) pos;
                          let b1 = {formula_base_heap = h1;
                                    formula_base_pure = p1;
                                    formula_base_vperm = vp1;
                                    formula_base_type = t1;
                                    formula_base_and = a1; (*TO CHECK: Done: pass a1 throught*)
                                    formula_base_flow = fl1;
                                    formula_base_label = None;
                                    formula_base_pos = pos } in
                          let b2 = {formula_base_heap = h2;
                                    formula_base_pure = p2;
                                    formula_base_vperm = vp2;
                                    formula_base_type = t2;
                                    formula_base_and = a2; (*TO CHECK: Done: pass a2 throught*)
                                    formula_base_flow = fl2;
                                    formula_base_label = None;
                                    formula_base_pos = pos } in
                          (*ctx0 and b1 is identical*)
                          Debug.ninfo_hprint (add_str "estate.es_heap match_" (Cprinter.string_of_h_formula)) estate.es_heap no_pos;
                          x_tinfo_hp (add_str "ctx0 match_" (Cprinter.string_of_context)) ctx0 no_pos;
                          let ctx_lst, prf = x_add (heap_entail_non_empty_rhs_heap ~caller:(x_loc^":"^caller)) prog is_folding ctx0 estate ante conseq b1 b2 rhs_h_matched_set pos in
                          x_tinfo_hp (add_str "ctx0_lst match_" (Cprinter.string_of_list_context)) ctx_lst no_pos;
                          (ctx_lst, prf)
                        )
                    )
                    else (
                      (* ante and conseq with concurrent threads*)
                      (* PRE: a1!=[] and a2!=[] and |a1|>=|a2|*)
                      (* if ante and conseq has valid #threads*)
                      (*ENTAIL the child thread first, then the main thread*)
                      (*TO DO: re-organize the code*)
                      x_dinfo_pp ("\nheap_entail_conjunct_helper: with threads: "
                                  ^ "\ncontext:\n" ^ (Cprinter.string_of_context ctx0)
                                  ^ "\nconseq:\n" ^ (Cprinter.string_of_formula conseq)) pos;
                      let b1 = {formula_base_heap = h1;
                                formula_base_pure = p1;
                                formula_base_vperm = vp1;
                                formula_base_type = t1;
                                formula_base_and = a1; (*TO CHECK: ???*)
                                formula_base_flow = fl1;
                                formula_base_label = None;
                                formula_base_pos = pos } in
                      let b2 = {formula_base_heap = h2;
                                formula_base_pure = p2;
                                formula_base_vperm = vp2;
                                formula_base_type = t2;
                                formula_base_and = a2; (*TO CHECK: ???*)
                                formula_base_flow = fl2;
                                formula_base_label = None;
                                formula_base_pos = pos } in
                      (*alla is the pure constraints in all threads*)
                      let alla = List.fold_left (fun a f -> add_mix_formula_to_mix_formula f.formula_pure a) p1 a1 in
                      (*01/02/2012: TO CHECK: we only propagate pure constraints
                        related to thread id and logical variables in the heap nodes*)
                      (*pure constraints related to actual variables are not added
                        to ensure a consistent view among threads because a thread does not
                        know the values of variables of another thread.*)
                      (*This can not happen now because of Vperm will ensure
                        exclusive access => can pass all constraints in all threads*)
                      (* let a_h_vars = List.concat (List.map fv_heap_of_one_formula a1)  in *)
                      (* let a_id_vars = (List.map (fun f -> f.formula_thread) a1) in *)
                      (* let a_vars = CP.remove_dups_svl (a_h_vars@a_id_vars) in *)
                      (* let alla = MCP.find_rel_constraints p1 a_vars in *)
                      (* let allc = List.fold_left (fun a f -> add_mix_formula_to_mix_formula f.formula_pure a) p2 a2 in *)
                      let allc = p2 in (*TO CHECK: p2 only to find closure*)
                      (*remove @zero of the main thread from the entail state
                        need to re-add after entail_thread*)
                      let zero_vars = estate.es_var_zero_perm in
                      let estate = {estate with es_var_zero_perm = []} in
                      let new_p, lctx,rest_a = heap_entail_thread prog estate conseq a1 a2 alla allc pos in
                      match new_p with
                      | None -> lctx (*Failed when entail threads*)
                      | Some ((to_ante,to_conseq),new_es) ->
                        (*TO DO: use split_universal to decide where to move the pure constraints*)
                        (* let () = print_endline ("\n### to_ante = " ^ (Cprinter.string_of_mix_formula to_ante) ^"\n### to_conseq = " ^ (Cprinter.string_of_mix_formula to_conseq)) in *)
                        let new_p2 = add_mix_formula_to_mix_formula to_conseq p2 in
                        (*LDK: remove duplicated conj from the new_p2*)
                        let new_p2 = remove_dupl_conj_eq_mix_formula new_p2 in
                        let new_p1 = add_mix_formula_to_mix_formula to_ante p1 in
                        let new_b1 = {b1 with formula_base_pure=new_p1;
                                              formula_base_and = rest_a} in
                        let new_b2 = {b2 with formula_base_pure=new_p2;
                                              formula_base_and = []} in
                        let new_estate = {estate with es_formula = (Base new_b1);
                                                      es_evars = new_es.es_evars;
                                                      es_ivars = new_es.es_ivars;
                                                      es_var_zero_perm = zero_vars; (*re-add @zero of the main thread*)
                                                      es_gen_impl_vars = new_es.es_gen_impl_vars;
                                                      es_gen_expl_vars = new_es.es_gen_expl_vars;} in
                        let new_conseq = (Base new_b2) in
                        x_dinfo_pp ("\nheap_entail_conjunct_helper: after heap_entail_thread: "
                                    ^ "\nnew_ante:\n" ^ (Cprinter.string_of_entail_state new_estate)
                                    ^ "\nnew_conseq:\n" ^ (Cprinter.string_of_formula new_conseq)) pos;
                        let ctx, proof =  heap_entail_conjunct_helper_x ~caller:(x_loc^":"^caller) (* 6 *) prog is_folding  (Ctx new_estate) new_conseq rhs_h_matched_set pos in
                        (ctx,proof)
                    )
                  )
                )
              )
          )
      )

and heap_entail_build_mix_formula_check_a (evars : CP.spec_var list) (ante : MCP.mix_formula) (conseq : MCP.mix_formula) pos : (MCP.mix_formula * MCP.mix_formula) =
  (* let () = print_string ("An Hoa :: heap_entail_build_mix_formula_check :: INPUTS\n" ^ *)
  (* "EXISTENTIAL VARIABLES = " ^ (String.concat "," (List.map Cprinter.string_of_spec_var evars)) ^ "\n" ^ *)
  (* "ANTECEDENT = " ^ (Cprinter.string_of_mix_formula ante) ^ "\n" ^ *)
  (* "CONSEQUENCE = " ^ (Cprinter.string_of_mix_formula conseq)  ^ "\n") in   *)
  let avars = mfv ante in
  let sevars = (* List.map CP.to_int_var *) evars in
  let outer_vars, inner_vars = List.partition (fun v -> CP.mem v avars) sevars in
  let conseq = if !no_RHS_prop_drop then conseq else  MCP.mix_cons_filter conseq MCP.isImplT in
  let tmp1 = elim_exists_mix_formula inner_vars conseq no_pos in
  let tmp2 = MCP.mix_push_exists outer_vars tmp1 in
  (* let () = print_string ("outer_vars: "^(pr_list Cprinter.string_of_spec_var outer_vars)^"\n inner_vars: "^(pr_list Cprinter.string_of_spec_var inner_vars)^"\n conseq: "^(Cprinter.string_of_mix_formula conseq) *)
  (*   ^"\n added inner: "^(Cprinter.string_of_mix_formula tmp1)^"\n added outer: "^(Cprinter.string_of_mix_formula tmp2)^"\n") in *)
  (ante,tmp2)

and heap_entail_build_mix_formula_check i (evars : CP.spec_var list) (ante : MCP.mix_formula) (conseq : MCP.mix_formula) pos : (MCP.mix_formula * MCP.mix_formula) =
  let pr = Cprinter.string_of_mix_formula in
  Debug.no_3_num i "heap_entail_build_mix_formula_check"
    (add_str "evars" (fun l -> Cprinter.string_of_spec_var_list l))
    (add_str "ante" pr) (add_str "conseq" pr) (pr_pair pr pr)
    ( fun c1 ante c2 -> heap_entail_build_mix_formula_check_a c1 ante c2 pos) evars ante conseq

and heap_entail_build_pure_check ev an cq pos =
  Debug.no_1 "heap_entail_build_pure_check"
    Cprinter.string_of_pure_formula
    (fun (f1,f2) -> "f1 = " ^ (Cprinter.string_of_pure_formula f1) ^ "; f2 = " ^ (Cprinter.string_of_pure_formula f2) ^ "\n")
    (fun cq -> heap_entail_build_pure_check_a ev an cq pos) cq

and heap_entail_build_pure_check_a (evars : CP.spec_var list) (ante : CP.formula) (conseq : CP.formula) pos : (CP.formula * CP.formula) =
  let tmp1 = CP.mkExists evars conseq None no_pos in
  (ante, tmp1)

and xpure_imply (prog : prog_decl) (is_folding : bool)   lhs rhs_p timeout : bool =
  let pr1 = Cprinter.string_of_entail_state in
  let pr2 = Cprinter.string_of_pure_formula in
  Debug.no_2 "xpure_imply" pr1 pr2 string_of_bool
    (fun _ _ -> xpure_imply_x (prog : prog_decl) (is_folding : bool)   lhs rhs_p timeout) lhs rhs_p

and xpure_imply_x (prog : prog_decl) (is_folding : bool)   lhs rhs_p timeout : bool =
  let imp_subno = ref 0 in
  let estate = lhs in
  let pos = no_pos in
  let formula = estate.es_formula in
  let formula4xpure = match formula with
    | Or _ -> report_error no_pos ("xpure_imply: encountered Or formula on lhs")
    | Base b -> Base {b with formula_base_heap = mkStarH b.formula_base_heap estate.es_heap pos}
    | Exists b ->  report_error no_pos ("xpure_imply: encountered Exists formula on lhs") in
  let formula4xpure = Norm.imm_norm_formula prog formula4xpure unfold_for_abs_merge pos in
  let rrr,c = match formula4xpure with
    | Or _ -> report_error no_pos ("xpure_imply: encountered Or formula on lhs")
    | Base b ->  (b,lhs)
    | Exists b ->  report_error no_pos ("xpure_imply: encountered Exists formula on lhs")in
  let lhs_h = rrr.formula_base_heap in
  let lhs_p = rrr.formula_base_pure in
  let () = Gen.reset_int2 () in
  (* let heapf = (mkStarH lhs_h estate.es_heap pos) in *)
  let heap_f = lhs_h in
  let xpure_lhs_h, _, memset = x_add xpure_heap 8 prog heap_f lhs_p 1 in
  let tmp1 = MCP.merge_mems lhs_p xpure_lhs_h true in
  let new_ante, new_conseq = x_add heap_entail_build_mix_formula_check 1 (estate.es_evars@estate.es_gen_expl_vars@estate.es_gen_impl_vars@estate.es_ivars) tmp1
      (MCP.memoise_add_pure_N (MCP.mkMTrue pos) rhs_p) pos in
  let (res,_,_) = imply_mix_formula_no_memo 1 new_ante new_conseq !imp_no !imp_subno (Some timeout) memset in
  imp_subno := !imp_subno+1;
  res

(** An Hoa : Extract the relations that appears in the input formula
    *  RETURN : a list of b_formula, each of which is a RelForm
*)
and extract_relations (f : CP.formula) : (CP.b_formula list) =
  match f with
  | CP.BForm (b, _) -> (let (p, _) = b in match p with
    | CP.RelForm _ -> [b]
    | _ -> [])
  | CP.And (f1, f2,_) -> (extract_relations f1) @ (extract_relations f2)
  | CP.AndList b -> []
  | _ -> [] (* Or, Not, Exists, Forall contains "negative" information! *)

(** An Hoa : Extract equalities in a formula so that we can check identity latter.
    *  RETURN : A formula of a big conjunction /\ (e1 = e2).
*)
and extract_equality (f : CP.formula) : CP.formula =
  match f with
  | CP.BForm (b, _) -> (let (p, _) = b in match p with
    | CP.Eq _ -> f
    | _ -> CP.mkTrue no_pos)
  | CP.And (f1, f2, _) -> CP.mkAnd (extract_equality f1) (extract_equality f2) no_pos
  | _ -> CP.mkTrue no_pos

(** An Hoa : Check if two expressions are exactly identical.
    *  RETURN : true/false
*)
and is_identical (exp1 : CP.exp) (exp2 : CP.exp) : bool =
  match exp1 with
  | CP.Var (CP.SpecVar (t1,vn1,p1),_) -> (match exp2 with
      | CP.Var (CP.SpecVar (t2,vn2,p2),_) -> vn1 = vn2 && p1 = p2
      | _ -> false)
  | CP.IConst (c1,_) -> (match exp2 with
      | CP.IConst (c2,_) -> c1 = c2
      | _ -> false)
  | CP.FConst (c1,_) -> (match exp2 with
      | CP.FConst (c2,_) -> c1 = c2
      | _ -> false)
  | _ -> false

(** An Hoa : Check if two expressions are exactly identical
    *           with respect to a collection of equality constraints.
    *  RETURN : true/false
*)
and is_relative_identical (eqctr : CP.formula) (exp1 : CP.exp) (exp2 : CP.exp) : bool =
  (is_identical exp1 exp2) || let res,_,_ = x_add TP.imply_one 27 eqctr (CP.mkEqExp exp1 exp2 no_pos) "" true None in res

(** An Hoa : Construct a formula of form /\ (v = e) for v in vars, e being terms
    over the free variables in lhs.
    RETURN : a formula
*)
and pure_match (vars : CP.spec_var list) (lhs : MCP.mix_formula) (rhs : MCP.mix_formula) : CP.formula =
  let lhs = MCP.fold_mix_lst_to_lst lhs true true true in
  let rhs = MCP.fold_mix_lst_to_lst rhs true true true in
  let rl = List.concat (List.map extract_relations lhs) in (* Relations in LHS *)
  let rr = List.concat (List.map extract_relations rhs) in (* Relations in RHS *)
  (*let fl = CP.fv lhs in Free variables in LHS, assume that fl intersects vars is empty *)
  let pr = List.flatten (List.map (fun x -> List.map (fun y -> (x,y)) rr) rl) in (* Cartesian product of rl and rr. *)
  let eqctr = extract_equality (CP.conj_of_list lhs no_pos) in
  (*let () = print_string "pure_match :: pairs of relations found : \n" in
    let todo_unk = List.map (fun (x,y) -> print_string ("(" ^ Cprinter.string_of_b_formula x ^ "," ^ Cprinter.string_of_b_formula y ^ "\n")) pr in*)
  (* Internal function rel_match to perform matching of two relations *)
  let rel_match  (vars : CP.spec_var list) (rpair : CP.b_formula * CP.b_formula) : CP.formula =
    let (r1, _) = fst rpair in
    let (r2, _) = snd rpair in
    (*let () = print_string ("rel_match :: on " ^ "{" ^ Cprinter.string_of_b_formula r1 ^ "," ^ Cprinter.string_of_b_formula r2 ^ "}\n") in*)
    (match r1 with
     | CP.RelForm (rn1, args1, _) -> (match r2 with
         | CP.RelForm (rn2, args2, _) -> (* TODO Implement *)
           if (CP.eq_spec_var rn1 rn2) then
             (* If the arguments at non-vars positions matched*)
             (* then we add the args1[i] = args2[i] where *)
             (* args2[i] should be a variable in vars *)
             let correspondences = List.map2 (fun x y -> match y with
                 | CP.Var (s,_) -> if (List.mem s vars) then true
                   else is_relative_identical eqctr x y
                 | _ -> is_relative_identical eqctr x y) args1 args2 in
             (*let todo_unk = List.map (fun x -> print_string ((string_of_bool x) ^ " , ")) correspondences in
               let () = print_string " --> " in*)
             let matched_nonvars = List.fold_left (&&) true correspondences in
             if matched_nonvars then (* Make a big conjunction of args1[i] = args2[i] *)
               (*let () = print_string "Relation matched! " in*)
               let result = List.fold_left (fun x y -> CP.mkAnd x y no_pos)
                   (CP.mkTrue no_pos)
                   (List.map2 (fun x y -> CP.mkEqExp x y no_pos) args1 args2) in
               (*let () = print_string ("Result binding : " ^ (Cprinter.string_of_pure_formula result) ^ "\n") in*)
               result
             else
               CP.mkTrue no_pos (* Some arguments does not fit, no constraint *)
           else
             (* Two relations of different names => no constraint between the arguments *)
             CP.mkTrue no_pos
         | _ -> failwith ("rel_match :: input should be a relation formula!"))
     | _ -> failwith ("rel_match :: input should be a relation formula!")) (* End of internal function rel_match *) in
  let match_conditions = List.map (rel_match vars) pr in (* Matches conditions are in m, just take a big conjunction of pr *)
  List.fold_left (fun x y -> CP.mkAnd x y no_pos) (CP.mkTrue no_pos) match_conditions
(* End of pure_match *)


(* Termination: Try to prove rhs_wf with inference *)
(* rhs_wf = None --> measure succeeded *)
(* lctx = Fail --> well-founded termination failure *)
(* lctx = Succ --> termination succeeded with inference *)
and heap_infer_decreasing_wf_x prog conseq estate rank is_folding lhs pos =
  let lctx, _ = x_add heap_entail_empty_rhs_heap 2 prog conseq is_folding estate lhs (MCP.mix_of_pure rank) [] pos
  in CF.estate_opt_of_list_context lctx

and heap_infer_decreasing_wf prog conseq estate rank is_folding lhs pos =
  let pr = !CP.print_formula in
  Debug.no_1 "heap_infer_decreasing_wf" pr pr_no
    (fun _ -> heap_infer_decreasing_wf_x prog conseq estate rank is_folding lhs pos) rank

(*CP.mkTrue pos, CP.isConstTrue*)
and subst_rel_by_def_x rel_w_defs (f0:CP.formula) =
  let pos = CP.pos_of_formula f0 in
  let rec look_up_def id args ls=
    match ls with
    | [] -> raise Not_found
    | rl::rest -> if String.compare id rl.Cast.rel_name = 0 &&
                     (List.length args) = (List.length rl.Cast.rel_vars)then
        let ss = List.combine rl.Cast.rel_vars args in
        (CP.subst ss rl.Cast.rel_formula)
      else look_up_def id args rest
  in
  let rec helper f=
    match f with
    | CP.BForm ((bf,_),_) -> begin
        match bf with
        | CP.RelForm(id,eargs,_) -> begin
            try
              let args = List.concat (List.map CP.afv eargs) in
              let def = look_up_def (CP.name_of_spec_var id) args rel_w_defs in
              def
            with Not_found ->
              f
          end
        | _ -> f
      end
    | CP.And (p1,p2,pos1) -> CP.And ((helper p1), (helper p2),pos1)
    | CP.AndList al ->
      let nal = List.fold_left (fun sl1 (sl,p) ->
          let p2 = helper p in sl1@[(sl,p2)]) [] al in
      (CP.AndList nal)
    | CP.Or (p1,p2,ofl,pos1) -> CP.Or ((helper p1,helper p2,ofl,pos1))
    | CP.Not (p1,ofl,pos1) -> (CP.Not (helper p1,ofl,pos1))
    | CP.Forall (sv,p1,ofl,pos1) -> CP.Forall (sv,helper p1,ofl,pos1)
    | CP.Exists (sv,p1,ofl,pos1) -> CP.Exists (sv,helper p1,ofl,pos1)
  in
  helper f0

and subst_rel_by_def rel_w_defs (f0:CP.formula) =
  let pr1= !CP.print_formula in
  let pr2 = Cprinter.string_of_rel_decl_list in
  Debug.no_2 "subst_rel_by_def" pr2 pr1 pr1
    (fun _ _ -> subst_rel_by_def_x rel_w_defs f0) rel_w_defs f0

and subst_rel_by_def_mix rel_w_defs mf =
  let p =  subst_rel_by_def rel_w_defs (MCP.pure_of_mix mf) in
  (MCP.mix_of_pure p)

(* type: int -> *)
(*   Cast.prog_decl -> *)
(*   Mem.CF.formula -> *)
(*   bool -> *)
(*   CF.entail_state -> *)
(*   Cformula.formula_base -> *)
(*   Cformula.MCP.mix_formula -> *)
(*   Slsat.CP.spec_var list -> VarGen.loc -> CF.list_context * Prooftracer.proof *)
and heap_entail_empty_rhs_heap i p conseq i_f es lhs rhs rhs_matched_set pos =
  let pr (e,_) = Cprinter.string_of_list_context e in
  Debug.no_4_num i "heap_entail_empty_rhs_heap"
    (add_str "es" Cprinter.string_of_entail_state)
    (add_str "lhs-base-f" (fun c-> Cprinter.string_of_formula(Base c)))
    (add_str "rhs-mix" Cprinter.string_of_mix_formula)
    (add_str "is_folding" string_of_bool) pr
    (fun _ _ _ _ -> TP.wrap_remove_univ_rhs (heap_entail_empty_rhs_heap_x p conseq i_f es lhs rhs rhs_matched_set) pos) es lhs rhs i_f

and heap_entail_empty_rhs_heap_x (prog : prog_decl) conseq (is_folding : bool)  estate_orig lhs (rhs_p:MCP.mix_formula) rhs_matched_set pos : (list_context * proof) =
  (**** INTERNAL****)
  let ante = CF.Base lhs in
  let neg_mcp_x mf=
    let p = MCP.pure_of_mix mf in
    match p with
    | CP.BForm (pf,lbl) -> MCP.mix_of_pure (CP.BForm (MCP.memo_f_neg1 pf, lbl))
    | _ -> report_error pos "heap_entail_empty_rhs_heap: to handle"
  in
  let neg_mcp mf=
    let pr1 = Cprinter.string_of_mix_formula in
    Debug.no_1 "neg_mcp" pr1 pr1
      (fun _ -> neg_mcp_x mf) mf
  in
  let rec neg_empty_heap_formula f=
    match f with
    | CF.Base fb -> if CF.is_empty_heap fb.CF.formula_base_heap then
        let neg_mf = neg_mcp fb.CF.formula_base_pure in
        CF.Base {fb with CF.formula_base_pure = neg_mf; }
      else report_error pos "heap_entail_empty_rhs_heap: conseq must have empty heap"
    | CF.Exists _ -> let quans, base_f = CF.split_quantifiers f in
      let neg_f = neg_empty_heap_formula base_f in
      CF.add_quantifiers quans neg_f
    | CF.Or orf -> report_error pos "heap_entail_empty_rhs_heap: conseq must not contain or"
  in
  let safe_exc () =
    (* infer empty HP_Rel for classic reasoning *)
    let classic_flag = estate_orig.CF.es_infer_obj # is_classic_all in
    let () = x_tinfo_hp (add_str "lhs" Cprinter.string_of_formula_base) lhs no_pos in
    let () = x_tinfo_hp (add_str "conseq" !CF.print_formula) conseq no_pos in
    let () = x_tinfo_hp (add_str "classic_flag" string_of_bool) classic_flag no_pos in
    (* L2: why not classic enven post proving? incr/ex10a-ll-size, skip2,skip3 *)
    let () = x_tinfo_hp (add_str "(check_is_classic ())" string_of_bool) (check_is_classic ()) no_pos in
    let h2, p2, _, _, _, _ = split_components conseq in
    (* I guess this should be unfolding hp_rel *)
    let estate_orig1, hprel_ass, lhs=
      if (h2 = HEmp || h2 = HTrue) && not(is_folding) &&
         (!Globals.old_collect_hprel || (check_is_classic ()))
      then
        (*L2: should we need classic for emp inference?*)
        (* WN: I would think so. Any counter-example? *)
        let (res,new_estate, rels, new_lhs) = x_add InferHP.infer_collect_hp_rel_empty_rhs 1 prog estate_orig lhs (* h2 *) p2 pos in
        if res then new_estate,rels,new_lhs else estate_orig,[], lhs
      else estate_orig,[], lhs
    in
    let ante = estate_orig1.CF.es_formula in
    let h1, _, _, _, _, _ = split_components ante in
    let lhs1 = {lhs with formula_base_heap = h1;} in
    (* TODO:WN : need to be careful with fix below *)
    let flag = h2 = HEmp && (check_is_classic ())  && not(is_folding) in
    let hprel_in_h1 = CF.get_hprel_h_formula h1 in
    let () = x_tinfo_hp (add_str "XXXX(hp_rel)" (pr_list pr_none)) hprel_in_h1 no_pos in
    let is_not_lhs_emp =
      if flag && (not(!Globals.old_classic_rhs_emp)) then
        begin
          let () = x_tinfo_hp (add_str "XXXX(h1)" !CF.print_h_formula) h1 no_pos in
          let () = x_tinfo_hp (add_str "do_classic_frame_rule" string_of_bool) (check_is_classic ()) no_pos in
          let () = x_tinfo_hp (add_str "is_folding" string_of_bool) is_folding no_pos  in
          let flag = is_classic_lhs_emp prog h1 ante pos in
          let () = y_tinfo_hp (add_str "is_classic_lhs_emp prog h1 ante pos" string_of_bool) flag in
          let () = y_tinfo_hp (add_str "h1" !CF.print_h_formula) h1 in
          let () = y_tinfo_hp (add_str "ante" !CF.print_formula) ante in
          not(flag)
        end
      else false
    in
    let () = y_tinfo_hp (add_str "is_not_lhs_emp" string_of_bool) is_not_lhs_emp in
    let () = y_tinfo_hp (add_str "h2 = HEmp && (check_is_classic ())  && not(is_folding)" string_of_bool) flag in
    if flag &&  (is_not_lhs_emp ||  (hprel_in_h1!= [] && !Globals.old_classic_rhs_emp))  then
      let fail_ctx = mkFailContext mem_leak estate_orig1 conseq None pos in
      let es_string = Cprinter.string_of_formula estate_orig1.es_formula in
      let err_msg = es_string^ ": possible memory leak failure : residue is forbidden." in
      let ls_ctx = Errctx.mkFailCtx_may ~conseq:(Some conseq) x_loc mem_leak estate_orig1 pos in
      Debug.tinfo_hprint (add_str " ls_ctx" Cprinter.string_of_list_context) ls_ctx no_pos;
      let proof = mkClassicSepLogic (Ctx estate_orig1) conseq in
      (ls_ctx, proof)
    else
      let () = x_tinfo_pp ("else ..Need to normalize h2 :"^(!print_h_formula h2)) no_pos in
      let () = x_tinfo_hp (add_str "TODO : not set classic_flag" string_of_bool) classic_flag no_pos in
      let () = x_tinfo_hp (add_str "h2" !print_h_formula) h2 no_pos in
      let () = x_tinfo_hp (add_str "estate_orig1" Cprinter.string_of_entail_state_short) estate_orig1 no_pos in
      let () = x_tinfo_hp (add_str "lhs1" !CF.print_formula) (CF.Base lhs1) no_pos in
      let estate_orig1,lhs1 =
        if h2 = HTrue then
          if (check_is_classic ()) then
            (* remove all heap components inside estate_orig1 *)
            let () = x_tinfo_pp "classic then-branch?" no_pos in
            CF.mkEmp_es estate_orig1,{lhs1 with formula_base_heap = HEmp}
          else
            (* remove all htrue from lhs *)
            let () = x_tinfo_pp "non-classic branch?" no_pos in
            if !Globals.new_rm_htrue then
              (CF.rm_htrue_estate estate_orig1
              ,{lhs1 with formula_base_heap = CF.rm_htrue_heap lhs1.formula_base_heap})
            else estate_orig1,lhs1
        else
          let () = x_tinfo_pp "not HTrue branch?" no_pos in
          estate_orig1,lhs1 in
      let ctx, proof = heap_entail_empty_rhs_heap_one_flow prog conseq is_folding estate_orig1 lhs1 rhs_p rhs_matched_set pos in
      let new_ctx =
        match ctx with
        | FailCtx _ -> ctx
        | SuccCtx cl ->
          if !Globals.old_infer_hp_collect then
            begin
              x_tinfo_hp (add_str "HPRelInferred" (pr_list_ln Cprinter.string_of_hprel_short)) hprel_ass pos;
              let () = Infer.rel_ass_stk # push_list hprel_ass in
              let () = Log.current_hprel_ass_stk # push_list hprel_ass in
              ()
            end;
          let new_cl = List.map (fun c ->
              (transform_context
                 (fun es ->
                    let () = es.CF.es_infer_hp_rel # push_list_loc x_loc hprel_ass in
                    Ctx es
                 ) c)) cl in
          SuccCtx(new_cl) in
      new_ctx, proof
  in
  (**** END INTERNAL****)

  (* if must_error, and need to infer *)
  let res =
    if (CF.is_en_error_exc estate_orig || CF.is_err_must_only_exc estate_orig) && not (no_infer_pure estate_orig) && not (CF.is_emp_term conseq) then
      (* negation of rhs *)
      let () = x_tinfo_pp "first if-then" no_pos in
      let neg_conseq = neg_empty_heap_formula conseq in
      let err_conseq = if CF.is_err_must_exc estate_orig || CF.is_err_must_only_exc  estate_orig then
          CF.substitute_flow_into_f !error_flow_int neg_conseq
        else neg_conseq
      in
      let neg_rhs_p = neg_mcp rhs_p in
      let error_lc, error_prf = heap_entail_empty_rhs_heap_one_flow prog err_conseq is_folding  estate_orig lhs neg_rhs_p rhs_matched_set pos in
      (* to add proof for error-infer *)
      if CF.is_err_must_only_exc estate_orig
      then
        let () = x_tinfo_pp "Why are we skipping safe_exc?" no_pos in
        (error_lc, error_prf)
      else
        let safe_lc, safe_prf = (safe_exc ()) in
        (list_context_union safe_lc error_lc, safe_prf)
    else
      let () = x_tinfo_pp "first if-else" no_pos in
      (safe_exc ())
  in res

and heap_entail_empty_rhs_heap_one_flow (prog : prog_decl) conseq (is_folding : bool)  estate_orig lhs (rhs_p:MCP.mix_formula) rhs_matched_set pos : (list_context * proof) =
  (* An Hoa note: RHS has no heap so that we only have to consider whether "pure of LHS" |- RHS *)
  let rel_w_defs = List.filter (fun rel -> not (CP.isConstTrue rel.Cast.rel_formula)) (prog.Cast.prog_rel_decls # get_stk) in
  (* Changed for merge.ss on 9/3/2013 *)
  let rhs_p = if not(estate_orig.es_infer_rel # is_empty_recent) then subst_rel_by_def_mix rel_w_defs rhs_p else rhs_p in
  (*TODO: let estate_orig = {estate_orig with CF.subst_rel_by_def_formula estate_orig.CF.es_formula}*)
  let smart_unsat_estate = ref None in
  let lhs_h = lhs.formula_base_heap in
  let lhs_p = lhs.formula_base_pure in
  let pr_mf = Cprinter.string_of_mix_formula in
  let () = x_tinfo_hp (add_str "lhs_p(0)" pr_mf) lhs_p no_pos in
  let lhs_vp = lhs.formula_base_vperm in
  (* Changed for merge.ss on 9/3/2013 *)
  let lhs_p = if not (estate_orig.es_infer_rel # is_empty_recent) then subst_rel_by_def_mix rel_w_defs lhs_p else lhs_p in
  let () = x_tinfo_hp (add_str "lhs_p(1)" pr_mf) lhs_p no_pos in
  (* memo slices that may not have been unsat *)
  let lhs_t = lhs.formula_base_type in
  let lhs_fl = lhs.formula_base_flow in
  let lhs_a = lhs.formula_base_and in
  let evarstoi = estate_orig.es_gen_expl_vars in
  let lhs_p = if (evarstoi = []) then (* Nothing to instantiate *) lhs_p
    else (* let () = print_endline ("\n\nheap_entail_empty_rhs_heap_x : Variables to be instantiated : " ^ (String.concat "," (List.map Cprinter.string_of_spec_var evarstoi))) in *)
      (* Temporarily suppress output of implication checking *)
      let () = Smtsolver.suppress_all_output () in
      let () = Z3.suppress_all_output () in
      let () = Tpdispatcher.push_suppress_imply_output_state () in
      let () = Tpdispatcher.suppress_imply_output () in
      let inst = pure_match evarstoi lhs_p rhs_p in (* Do matching! *)
      let lhs_p = MCP.memoise_add_pure_N lhs_p inst in
      (* Unsuppress the printing *)
      let () = Smtsolver.unsuppress_all_output ()  in
      let () = Z3.unsuppress_all_output ()  in
      let () = Tpdispatcher.restore_suppress_imply_output_state () in
      (* let () = print_string ("An Hoa :: New LHS with instantiation : " ^ (Cprinter.string_of_mix_formula lhs_p) ^ "\n\n") in *)
      lhs_p
  in
  let () = x_tinfo_hp (add_str "lhs_p(2)" pr_mf) lhs_p no_pos in
  (* remove variables that are already instantiated in the right hand side *)
  (*let fvlhs = MCP.mfv lhs_p in
    (* WN : any reason why estate below is not being used .. *)
    let estate = {estate_orig with es_gen_expl_vars = List.filter (fun x -> not (List.mem x fvlhs)) estate_orig.es_gen_expl_vars } in*) (*Clean warning*)
  (* ========== Immutability normalization ======== *)
  (* let lhs_h, estate_orig = Immutable.imm_norm_for_entail_empty_rhs lhs_h lhs_p  estate_orig in *)
  (* ========== end - Immutability normalization ======== *)

  let () = Gen.reset_int2 () in
  x_tinfo_hp (add_str "rhs_p" (Cprinter.string_of_mix_formula)) rhs_p pos;
  x_tinfo_hp (add_str "lhs_h" (Cprinter.string_of_h_formula)) lhs_h pos;
  x_tinfo_hp (add_str "estate_orig.es_heap" (Cprinter.string_of_h_formula)) estate_orig.es_heap pos;
  (* TODO-EXPURE lhs heap here *)
  (* Why did we combine lhs_h with es_heap? Is es_heap the consumed heap? *)
  let curr_lhs_h = (mkStarH lhs_h estate_orig.es_heap pos) in
  let lhs_baga = (* Long : why we need lhs_baga *)
    if false (* !Globals.use_baga *) (* !Globals.gen_baga_inv *) then
      let views = prog.Cast.prog_view_decls in
      let t1 = Expure.build_ef_heap_formula false curr_lhs_h views in
      let () = Debug.ninfo_hprint (add_str "hf" (Cprinter.string_of_h_formula)) curr_lhs_h no_pos in
      let () = Debug.ninfo_hprint (add_str "t1" (Cprinter.string_of_ef_pure_disj)) t1 no_pos in
      let t2 = x_add_1 Expure.build_ef_pure_formula (Mcpure.pure_of_mix lhs_p) in
      let () = Debug.ninfo_hprint (add_str "pf" (Cprinter.string_of_pure_formula)) (Mcpure.pure_of_mix lhs_p) no_pos in
      let () = Debug.ninfo_hprint (add_str "t2" (Cprinter.string_of_ef_pure_disj)) t2 no_pos in
      let d = Excore.EPureI.mk_star_disj t1 t2 in
      let () = Debug.ninfo_hprint (add_str "d1" (Cprinter.string_of_ef_pure_disj)) d no_pos in
      let d = x_add Excore.EPureI.elim_unsat_disj false d in
      let () = Debug.ninfo_hprint (add_str "d2" (Cprinter.string_of_ef_pure_disj)) d no_pos in
      Some d
    else None in
  x_tinfo_hp (add_str "curr_lhs_h" (Cprinter.string_of_h_formula)) curr_lhs_h pos;
  x_tinfo_hp (add_str "lhs_p" !Cast.print_mix_formula) lhs_p no_pos;
  let curr_lhs_h, lhs_p = normalize_frac_heap prog curr_lhs_h lhs_p lhs_vp in
  x_tinfo_hp (add_str "estate_orig" (Cprinter.string_of_entail_state)) estate_orig pos;
  x_tinfo_hp (add_str "curr_lhs_h0" (Cprinter.string_of_h_formula)) curr_lhs_h pos;
  let unk_heaps = x_add_1 CF.keep_hrel curr_lhs_h in
  let cur_force_verbose_xpure = !force_verbose_xpure in
  (*for pure inference, we need return verbose xpure to expose the disjunction:
    infer [n] x::ll<n> |- x!=null
  *)
  let () = if !Globals.en_slc_ps && not (no_infer_pure estate_orig) then
      let () = force_verbose_xpure := true in ()
    else ()
  in
  (* WN:TODO can we invoke a single xpure if the formula are identical? *)
  (* it's sound to restore hols for curr_lhs_h at this point as this expression is only used for computing the different xpures *)
  let curr_lhs_h = Immutable.apply_subs_h_formula estate_orig.es_crt_holes curr_lhs_h in
  (* below merges and normalizes aliased nodes *)
  let curr_lhs_h, lhs_p = Norm.imm_norm_h_formula prog curr_lhs_h lhs_p unfold_for_abs_merge pos in
  let (xpure_lhs_h1, yy, memset) as xp1a =
    x_add xpure_heap 9 prog curr_lhs_h lhs_p 1 in
  let diff_num2 = Gen.seq_number2 # diff in
  let () = x_tinfo_hp (add_str "used seq_number2" string_of_int) (diff_num2) no_pos in
  (* xpure_lhs_h1_sym needed by infer_collect *)
  let (xpure_lhs_h1_sym, _, _) as xp1b =
    if diff_num2==0 then xp1a
    else x_add xpure_heap_sym 19 prog curr_lhs_h lhs_p 1 in
  (* x=1 is the same as x>0 for single node *)
  (* let xpure_lhs_h1 = if diff_num2==1 then xpure_lhs_h1_sym else xpure_lhs_h1 in *)
  let () = force_verbose_xpure := cur_force_verbose_xpure in
  (*let () = print_string("\nxpure_lhs_h1-1:"^(Cprinter.string_of_mix_formula xpure_lhs_h1)) in*)
  let diff_flag = not(!smart_same_flag) in
  let () = Globals.super_smart_xpure := !Globals.smart_xpure && diff_flag in
  let (xpure_lhs_h0, _, _) as xp0a =
    if diff_flag then x_add xpure_heap 10 prog curr_lhs_h lhs_p 0
    else xp1a in
  let (xpure_lhs_h0_sym, _, _) as xp0b =
    if diff_flag then x_add xpure_heap_sym 20 prog curr_lhs_h lhs_p 0
    else xp1b in
  let xp1 = if diff_flag then xp0b else (xpure_lhs_h0,yy,memset) in
  let pr = Cprinter.string_of_mix_formula in
  let () = x_tinfo_hp (add_str "xpure_lhs_h1" pr) xpure_lhs_h1 no_pos in
  let () = x_tinfo_hp (add_str "xpure_lhs_h1_sym" pr) xpure_lhs_h1_sym no_pos in
  let () = x_tinfo_hp (add_str "diff_flag" string_of_bool) diff_flag no_pos in
  let () = x_tinfo_hp (add_str "super_smart_xpure" string_of_bool) !Globals.super_smart_xpure no_pos in
  let xpure_lhs_h0, _, _ =
    if (!Globals.super_smart_xpure) then xp0a
    else xp1
  in
  (* add the information about the dropped reading phases *)
  x_tinfo_hp (add_str "xpure_lhs_h1(bef merge)" !Cast.print_mix_formula) xpure_lhs_h1 no_pos;
  let xpure_lhs_h1 = MCP.merge_mems xpure_lhs_h1 estate_orig.es_aux_xpure_1 true in
  let xpure_lhs_h1_sym = MCP.merge_mems xpure_lhs_h1_sym estate_orig.es_aux_xpure_1 true in
  let xpure_lhs_h0_sym =
    if diff_flag then MCP.merge_mems xpure_lhs_h0_sym estate_orig.es_aux_xpure_1 true
    else xpure_lhs_h1_sym in
  x_tinfo_hp (add_str "xpure_lhs_h1" !Cast.print_mix_formula) xpure_lhs_h1 no_pos;
  let rel_args = CP.get_rel_args (MCP.pure_of_mix rhs_p) in
  let lhs_p2 = if CP.intersect_svl rel_args estate_orig.CF.es_evars <> [] then
      let eqs = MCP.ptr_equations_without_null rhs_p in
      let eq_p = CP.get_eqs_rel_args (MCP.pure_of_mix rhs_p) eqs rel_args no_pos in
      MCP.mix_of_pure (CP.mkAnd (MCP.pure_of_mix lhs_p) eq_p no_pos)
    else lhs_p
  in
  let stk_inf_pure = new Gen.stack_pr "stk_inf_pure" (!CP.print_formula) (==) in (* of xpure *)
  let stk_rel_ass = new Gen.stack_pr "stk-rel-ass" (add_str "(stk_rel_ass)" CP.string_of_infer_rel) (==) in (* of rel_ass *)
  let stk_estate = new Gen.stack in (* of estate *)
  (* let () = print_string ("lhs_p2 : " ^ (Cprinter.string_of_mix_formula lhs_p2) ^ "\n\n") in *)
  (* infer must NOT use baga_enum outcome *)
  let pr = Cprinter.string_of_mix_formula in
  let () = x_tinfo_hp (add_str "xpure_lhs_h1" pr) xpure_lhs_h1 no_pos in
  let () = x_tinfo_hp (add_str "xpure_lhs_h1_sym (wo pure)" pr) xpure_lhs_h1_sym no_pos in
  let () = x_tinfo_hp (add_str "NO RHS: lhs_p2 (wo heap)" pr) lhs_p2 no_pos in
  let () = x_tinfo_hp (add_str "conseq1:" !CF.print_formula) conseq no_pos in
  let conseq_flow = CF.flow_formula_of_formula conseq in
  let (estate,lhs_new,rhs_p,neg_lhs,rel_ass) = x_add Infer.infer_collect_rel
      (fun x -> TP.is_sat_raw (MCP.mix_of_pure x)) estate_orig conseq_flow xpure_lhs_h1_sym lhs_p2 rhs_p pos in
  let () = match neg_lhs,rel_ass with
    | None,[] -> ()
    | None,[(h1,h2,_)] ->
      let () = Debug.ninfo_pprint "WARNING : pushing stk_estate (1)" pos in
      (stk_rel_ass # push_list h2;
       stk_estate # push h1)
    | Some (es,p),[] ->
      let () = Debug.ninfo_pprint "WARNING : pushing stk_estate (2)" pos in
      (stk_inf_pure # push_list_loc x_loc [p];
       stk_estate # push es)
    | Some (es,p),[(h1,h2,_)] ->
      let () = Debug.ninfo_pprint "WARNING : pushing stk_estate (3)" pos in
      (stk_inf_pure # push_list_loc x_loc [p];
       stk_rel_ass # push_list h2;
       stk_estate # push es)
    | _,_ -> report_error pos "Length of relational assumption list > 1"
  in
  (* Termination: Only strip lexvar in RHS and                        *)
  (* Delay term checking until we have the entailment checking result *)
  let rhs_p_lexvar = rhs_p in
  let _, rhs_p = x_add_1 TermUtils.strip_lexvar_mix_formula rhs_p in
  x_dinfo_hp (add_str "rhs_p : " Cprinter.string_of_mix_formula) rhs_p pos;
  x_dinfo_zp (lazy ("heap_entail_empty_heap: ctx:\n" ^ (Cprinter.string_of_estate estate))) pos;
  x_tinfo_zp (lazy ("heap_entail_empty_heap: rhs:\n" ^ (Cprinter.string_of_mix_formula rhs_p))) pos;
  (* TO DOCUMENT : Loc : What are result types here? *)
  (* 1. bool - succeed or not
     2. list of pairs of formula label options
     3. label option
     4. (failure list, (list, list, list))
  *)
  let fold_fun_impt (is_ok,succs,fails, (fc_kind,(contra_list, must_list, may_list))) (rhs_p:MCP.mix_formula) =
    begin
      x_tinfo_hp (add_str "estate_orig : " Cprinter.string_of_entail_state) estate_orig pos;
      (* adding back existential substitution to resolve ex6f1c6.slk *)
      let subst_fr,subst_to = estate_orig.es_subst in
      let rhs_p = MCP.subst_avoid_capture_memo subst_fr subst_to rhs_p in
      let () = x_tinfo_hp (add_str "rhs_p " Cprinter.string_of_mix_formula) rhs_p no_pos in
      let m_lhs = lhs_new in
      x_tinfo_hp (add_str "m_lhs" (Cprinter.string_of_mix_formula)) m_lhs pos;
      let tmp3 = MCP.merge_mems m_lhs xpure_lhs_h1 true in
      let tmp3_sym = MCP.merge_mems m_lhs xpure_lhs_h1_sym true in
      let tmp0_sym =
        if (xpure_lhs_h1_sym==xpure_lhs_h0_sym) then tmp3_sym
        else MCP.merge_mems m_lhs xpure_lhs_h0_sym true in
      x_tinfo_hp (add_str "tmp3" (Cprinter.string_of_mix_formula)) tmp3 pos;
      let tmp2 =
        if (!Globals.super_smart_xpure) then MCP.merge_mems m_lhs xpure_lhs_h0 true
        else tmp3
      in
      (*Loc: why smart_lem_search?? append_sll_cll_slk-15.smt2.slk from must failure to may failure?? *)
      let contra, temp_rhs = if (!Globals.smart_lem_search && is_folding) then
          (* let pp_rhs_len = rhs_pure_stk # len in *)
          let pp_rhs_stk = rhs_pure_stk # get_stk in
          let pp_rhs = List.fold_left (fun acc p ->  (CP.mkAnd  acc (MCP.pure_of_mix p) pos)) (MCP.pure_of_mix rhs_p) pp_rhs_stk in
          let () = Debug.ninfo_hprint (add_str " folding: " string_of_bool ) is_folding pos in
          let tmp_rhs =  pp_rhs in (* (CP.mkAnd  (MCP.pure_of_mix rhs_p) (MCP.pure_of_mix pp_rhs) pos) in  *)
          Debug.ninfo_hprint (add_str "contra detect, tmp2" !MCP.print_mix_formula) tmp2 pos;
          Debug.ninfo_hprint (add_str "contra detect, tmp_rhs" !CP.print_formula) tmp_rhs pos;
          let contr, _ = x_add Infer.detect_lhs_rhs_contra (MCP.pure_of_mix tmp2) tmp_rhs pos in
          Debug.ninfo_hprint (add_str "contra detect, res" string_of_bool) contr pos;
          (* let () =  rhs_pure_stk # push  pp_rhs in *)
          (contr, tmp_rhs)
        else (true, (MCP.pure_of_mix rhs_p)) in
      if not (contra) then
        let () = Debug.ninfo_hprint (add_str "contra in empty rhs heap - folding: " (fun b ->  if not b then "CONTRA DETECTED" else "no contra")) contra pos in
        (false,[],None, (Failure_Valid, ([( (MCP.pure_of_mix tmp2), temp_rhs)],[],[])))
      else
        let exist_vars = estate.es_evars@estate.es_gen_expl_vars@estate.es_ivars (* @estate.es_gen_impl_vars *) in (*TO CHECK: ???*)
        (* TODO-EXPURE : need to build new expure stuff *)
        let remove_univ_vars f vs =
          let f = MCP.pure_of_mix f in
          let univ_vs = TP.get_univs_from_ante f in
          let () = x_tinfo_hp (add_str "univ_vs" Cprinter.string_of_spec_var_list) univ_vs no_pos in
          CP.diff_svl vs univ_vs
        in
        let exist_vars = remove_univ_vars tmp3_sym exist_vars in
        let () = x_tinfo_hp (add_str "exist_vars" Cprinter.string_of_spec_var_list) exist_vars no_pos in
        let () = x_tinfo_hp (add_str "rhs_p " Cprinter.string_of_mix_formula) rhs_p no_pos in
        let (split_ante1, new_conseq1) as xx = x_add heap_entail_build_mix_formula_check 2 exist_vars tmp3 rhs_p pos in
        let (split_ante1_sym, _) as xx1 = x_add heap_entail_build_mix_formula_check 2 exist_vars tmp3_sym rhs_p pos in
        let () = y_tinfo_hp (add_str "es_ivars" Cprinter.string_of_spec_var_list) estate.es_ivars  in
        let () = y_tinfo_hp (add_str "es_gen_expl_vars" Cprinter.string_of_spec_var_list) estate.es_gen_expl_vars  in
        let () = y_tinfo_hp (add_str "es_evars" Cprinter.string_of_spec_var_list) estate.es_evars  in
        let () = x_tinfo_hp (add_str "split_ante1 " Cprinter.string_of_mix_formula) split_ante1 no_pos in
        let () = x_tinfo_hp (add_str "split_ante1_sym " Cprinter.string_of_mix_formula) split_ante1_sym no_pos in
        let flag1=(tmp3_sym==tmp0_sym) in
        let () = y_tinfo_hp (add_str "heap_entail_build (flag1)" string_of_bool) flag1 in
        let (split_ante0_sym, _) as xx =
          if flag1 then xx1
          else
            x_add heap_entail_build_mix_formula_check 2 exist_vars tmp0_sym rhs_p pos in
        let () = y_tinfo_hp (add_str "heap_entail_build (super_smart_xpure" string_of_bool) !Globals.super_smart_xpure in
        let split_ante0, new_conseq0 =
          if (* true || *) (!Globals.super_smart_xpure) then
            let () = y_tinfo_pp "heap_entail_build (after super_smart_xpure)" in
            x_add heap_entail_build_mix_formula_check 3 exist_vars tmp2 rhs_p pos
          else xx
        in
        let () = x_tinfo_hp (add_str "split_ante0 " Cprinter.string_of_mix_formula) split_ante0 no_pos in
        let () = x_tinfo_hp (add_str "split_ante0_sym " Cprinter.string_of_mix_formula) split_ante0_sym no_pos in
        (*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*)
        (* TODO: if xpure 1 is needed, then perform the same simplifications as for xpure 0 *)
        (*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*)
        x_tinfo_hp (add_str "rhs_p : " Cprinter.string_of_mix_formula) rhs_p pos;
        x_tinfo_hp (add_str "conseq0 : " Cprinter.string_of_mix_formula) new_conseq0 pos;
        x_tinfo_hp (add_str "conseq1-1 : " Cprinter.string_of_mix_formula) new_conseq1 pos;
        let split_conseq =
          if !omega_simpl && not(TP.is_mix_bag_constraint new_conseq0)&& not(TP.is_mix_list_constraint new_conseq0)
          then memo_normalize_to_CNF_new (MCP.memo_arith_simplify new_conseq0) pos
          else new_conseq0 in
        x_dinfo_pp ">>>>>> entail_empty_heap: cp1 <<<<<<" pos;
        x_dinfo_hp (add_str "ante0 : " Cprinter.string_of_mix_formula) split_ante0 pos;
        x_dinfo_hp (add_str "ante1 : " Cprinter.string_of_mix_formula) split_ante1 pos;
        x_dinfo_hp (add_str "conseq : " Cprinter.string_of_mix_formula) split_conseq pos;
        (* what exactly is split_a_opt??? *)
        let (i_res1, i_res2, i_res3), _ =
          if (MCP.isConstMTrue rhs_p) then ((true, [], None), None)
          else
            let () = x_dinfo_pp ("astaq?") no_pos in
            let () = x_dinfo_pp ("IMP #" ^ (string_of_int !imp_no)) no_pos in
            (* TODO-EXPURE - need to use syntactic imply & move upwards? *)
            match lhs_baga with
            | Some lhs ->
              let rhs = x_add_1 Expure.build_ef_pure_formula (Mcpure.pure_of_mix rhs_p) in
              (* let flag = Excore.EPureI.imply_disj lhs rhs in *)
              let ((flag2,_,_),_) as r = x_add imply_mix_formula 1 split_ante0 split_ante1 split_conseq imp_no memset in
              r
            | None ->
              let () = Debug.ninfo_hprint (add_str "split_ante0 " Cprinter.string_of_mix_formula) split_ante0 no_pos in
              let () = x_tinfo_hp (add_str "split_ante1 " Cprinter.string_of_mix_formula) split_ante1 no_pos in
              let () = Debug.ninfo_hprint (add_str "split_conseq " Cprinter.string_of_mix_formula) split_conseq no_pos in
              (x_add imply_mix_formula 1 split_ante0 split_ante1 split_conseq imp_no memset)
        in
        let i_res1, i_res2, i_res3 =
          if not(stk_estate # is_empty)
          then (true, [], None)
          else
          if i_res1 == true
          then (i_res1, i_res2, i_res3)
          else
            let finish_flag =
              if (!Globals.delay_proving_sat && !smart_unsat_estate==None) then
                if (!Globals.filtering_flag || (not !Globals.dis_ps))
                (* !Globals.allow_pred_spec || !Globals.do_slicing *)
                then
                  let estate = mark_estate_sat_slices estate !memo_impl_fail_vars in
                  let n_es = elim_unsat_es 11 prog (ref 1) estate in
                  if CF.isAnyFalseCtx n_es then
                    (smart_unsat_estate := Some (estate_of_context n_es no_pos); true)
                  else false
                else false
              else false  in
            let () = x_tinfo_hp (add_str "finish_flag:" string_of_bool) finish_flag no_pos in
            if finish_flag
            then (true, [], None)
            else
              let estate = Gen.unsome_safe !smart_unsat_estate estate in
              let () = x_tinfo_hp (add_str "xpure_lhs_h1_sym (b4 infer_pure)" Cprinter.string_of_mix_formula) xpure_lhs_h1_sym no_pos in
              let lhs_heap_xpure1 = xpure_lhs_h1_sym in
              let res_safe =
                x_add Infer.infer_pure_top_level estate unk_heaps lhs_heap_xpure1 split_ante1_sym split_ante0_sym (*sym?*) m_lhs split_conseq pos
              in
              let res = res_safe in
              let or_option (o1,o2) = (match o1,o2 with
                  | None,_ -> o2
                  | _,None -> o1
                  | Some pf1,Some pf2 -> Some (CP.mkOr pf1 pf2 None pos))
              in
              let merge_rel_ass (rs1,rs2) =
                rs1 @ rs2 in
              let (ip1,ip2,relass,entail_states,false_es) =
                let is_fail = List.exists (fun (neg,pure,rel,_,_,ante) ->
                    match neg,pure,rel with
                    | None,None,[] ->
                      (fun ((a,_,_),_) -> not a)
                        (* WN : inefficient to use same antecedent *)
                        (x_add imply_mix_formula 0 ante ante split_conseq imp_no memset)
                    | _,_,_ -> false) res in
                if is_fail then None,None,[],[],false
                else
                  List.fold_left (fun (a,b,c,d,e) (a1,b1,c1,d1,e1,_) ->
                      (or_option (a,a1),or_option (b,b1),merge_rel_ass (c,c1),d@d1,e||e1))
                    (None,None,[],[],false) res
              in
              begin
                match ip1 with
                | Some p ->
                  let () = x_tinfo_pp "marking \n" no_pos in
                  begin
                    let () = y_tinfo_pp "here.." in
                    match relass with
                    | [] ->
                      let () = y_tinfo_hp (add_str "ip1" !CP.print_formula) p in
                      (let () = if not (CP.isConstTrue p) then stk_inf_pure # push_list_loc x_loc [p] in
                       let () =
                         if entail_states = [] then
                           report_error pos "Expecting a non-empty list of entail states"
                         else
                           let n = List.length entail_states in
                           let () = Debug.ninfo_zprint  (lazy  ("WARNING : Pushing "^(string_of_int n)^" stk_estate (4)")) pos in
                           stk_estate # push_list entail_states
                       in
                       (true,[],None))
                    | _ ->
                      (stk_inf_pure # push_list_loc x_loc [p];
                       stk_rel_ass # push_list_pr x_loc relass;
                       let () =
                         if entail_states = [] then
                           report_error pos "Expecting a non-empty list of entail states"
                         else
                           let n = List.length entail_states in
                           let () = Debug.ninfo_zprint  (lazy  ("WARNING : Pushing  "^(string_of_int n)^"stk_estate (5)")) pos in
                           stk_estate # push_list entail_states
                       in
                       (true,[],None))
                  end
                | None ->
                  let () = x_tinfo_pp "marking \n" no_pos in
                  begin
                    match ip2 with
                    | None ->
                      let () = x_tinfo_pp "marking \n" no_pos in
                      begin
                        match relass with
                        | [] ->
                          i_res1,i_res2,i_res3
                        | _ -> (* stk_inf_pure # push pf; *)
                          stk_rel_ass # push_list relass;
                          let () =
                            if entail_states = [] then
                              report_error pos "Expecting a non-empty list of entail states"
                            else
                            if not(false_es) then ()
                            else
                              let n = List.length entail_states in
                              let () = Debug.ninfo_zprint  (lazy  ("WARNING : Pushing "^(string_of_int n)^"stk_estate (6)")) pos in
                              stk_estate # push_list entail_states in
                          (true,[],None)
                      end
                    | Some pf ->
                      let () = x_tinfo_pp "marking \n" no_pos in
                      begin
                        match relass with
                        | [] ->
                          let () = x_tinfo_pp "marking \n" no_pos in
                          stk_inf_pure # push_list_loc x_loc [pf];
                          let new_pf = MCP.mix_of_pure pf in
                          let split_ante0 = MCP.merge_mems split_ante0 new_pf true in
                          let split_ante1 = MCP.merge_mems split_ante1 new_pf true in
                          let () = x_tinfo_hp (add_str "new_pf "!print_mix_formula) new_pf no_pos in
                          let () = x_tinfo_hp (add_str "split_ante0" !print_mix_formula) split_ante0 no_pos in
                          let () = x_tinfo_pp ("IMP #" ^ (string_of_int !imp_no)) no_pos in
                          fst (x_add imply_mix_formula 2 split_ante0 split_ante1 split_conseq imp_no memset)
                        | _ ->
                          (* TODO: to check the implication of new ante *)
                          stk_inf_pure # push_list_loc x_loc [pf];
                          stk_rel_ass # push_list relass;
                          let () =
                            if entail_states = [] then
                              report_error pos "Expecting a non-empty list of entail states"
                            else
                            if not(false_es) then ()
                            else
                              let n = List.length entail_states in
                              let () = Debug.tinfo_zprint  (lazy  ("WARNING : Pushing "^(string_of_int n)^"stk_estate (6)")) pos in
                              stk_estate # push_list entail_states in
                          (true,[],None)
                      end
                  end
              end in
        let res1,res2,re3, (fn_fc_kind, (fn_contra_list, fn_must_list, fn_may_list)) =
          let () = x_tinfo_pp "marking \n" no_pos in
          if i_res1 = false then
            begin
              let (new_fc_kind, (new_contra_list, new_must_list, new_may_list)) =
                (*check_maymust: maximising must bug with AND (error information)*)
                let cons4 = (MCP.pure_of_mix split_conseq) in
                (* Check MAY/MUST: if being invalid and (exists (ante & conseq)) = true then that's MAY failure,otherwise MUST failure *)
                (*check maymust for ante0*)
                let (fc, (contra_list, must_list, may_list)) =
                  x_add Musterr.check_maymust_failure (MCP.pure_of_mix split_ante0) cons4 in
                x_dinfo_hp (add_str "add_to_rhs" Cprinter.string_of_pure_formula) (MCP.pure_of_mix split_ante1) pos;
                match fc with
                | Failure_May _ -> Musterr.check_maymust_failure (MCP.pure_of_mix split_ante1) cons4
                | _ -> (fc, (contra_list, must_list, may_list)) in
              (false,[],None, (new_fc_kind, (new_contra_list, new_must_list, new_may_list)))
            end
          else (i_res1,i_res2,i_res3, (fc_kind, (contra_list, must_list, may_list)))
        in
        (imp_no := !imp_no+1;
         (res1, res2@succs,i_res3, (fn_fc_kind, (fn_contra_list, fn_must_list, fn_may_list))))
    end (* end of fold_fun_impt *)
  in
(*
type: bool *
  (Globals.formula_label option * Globals.formula_label option) list
  * Globals.formula_label option *
  (Musterr.CF.failure_kind *
   ((Musterr.CP.formula * CP.formula) list *
    (Musterr.CP.formula * Musterr.CP.formula) list *
    (Musterr.CP.formula * Musterr.CP.formula) list)) ->
  string
*)
  let fold_fun_impt x (rhs_p:MCP.mix_formula) =
    let () = x_tinfo_pp "marking \n" no_pos in
    let pr = Cprinter.string_of_mix_formula in
    let pr_lp = pr_list (pr_pair !CF.print_pure_f  !CF.print_pure_f) in
    let pr1 (r, _, _, (_,(lp,_,_))) = pr_pair string_of_bool pr_lp (r,lp) in
    Debug.no_1 "fold_fun_impt" pr pr1 (fun _ -> fold_fun_impt x rhs_p) rhs_p
  in
  let () = x_tinfo_hp (add_str "estate" Cprinter.string_of_entail_state) estate no_pos in
  let prf = mkPure estate (CP.mkTrue no_pos) (CP.mkTrue no_pos) true None in
  let (r_rez,r_succ_match, r_fail_match, (fc_kind, (contra_list, must_list, may_list))) =
    x_add fold_fun_impt  (true,[],None, (Failure_Valid, ([],[],[]))) rhs_p in

  let ctx, prf =
    if r_rez then begin
      (* Entailment is valid *)
      let add_univ_pure es =
        let univ_rhs_store = TP.univ_rhs_store in
        if univ_rhs_store # is_empty then es
        else
          let nf = univ_rhs_store # get_rm in
          let () = y_dinfo_hp (add_str "univ pure --> lhs" !CP.print_formula) nf in
          CF.add_pure_estate es nf
      in
      let add_univ_pure es =
        let pr =  Cprinter.string_of_entail_state_short in
        Debug.no_1 "add_univ_pure" pr pr add_univ_pure es in
      let flag = stk_estate # is_empty in
      let () = y_tinfo_hp (add_str "stk_estate # is_empty" string_of_bool) flag in
      let () = y_tinfo_hp (add_str "estate" Cprinter.string_of_entail_state) estate in
      if not(flag) || !Globals.adhoc_flag_5 then
        let pr = Cprinter.string_of_entail_state_short in
        let () = x_tinfo_pp "marking \n" no_pos in
        let () = x_tinfo_hp (add_str "stk_estate: " (pr_list pr)) (stk_estate # get_stk) no_pos in
        let new_estate = stk_estate # top in
        let new_ante_fmls = List.map (fun es -> es.es_formula) (stk_estate # get_stk) in
        let new_estate = {new_estate with es_formula = disj_of_list_pure new_ante_fmls pos} in
        let () = x_tinfo_hp (add_str "new_estate" Cprinter.string_of_entail_state) new_estate no_pos in
        let orig_ante = new_estate.es_orig_ante in
        (* infer_deep_ante_issues : unsat fail unless we have single ctx *)
        (* soln : as heap is same, convert into disj pure *)
        let () = Debug.ninfo_pprint "infer_deep_ante_issues triggered by --iesa" no_pos in
        let () = Debug.ninfo_pprint "if stk_estate > 1, can cause unsat_xpure exception" no_pos in
        let () = Debug.ninfo_pprint "Thai : can we convert below to single ctx by using pure or rather than CtxOr" no_pos in
        let () = Debug.ninfo_hprint (add_str "new_ante_fmls" (pr_list Cprinter.string_of_formula)) new_ante_fmls no_pos in
        let ctx1 = (x_add elim_unsat_es_now 8 prog (ref 1) new_estate) in
        let ctx1 = match ctx1 with
          | Ctx es -> Ctx {es with es_orig_ante = orig_ante}
          | _ -> ctx1 in
        let inf_p = stk_inf_pure # get_stk in
        let () = y_tinfo_hp (add_str "inf_p" (pr_list !CP.print_formula)) inf_p in
        let ctx1 = x_add add_infer_pure_to_ctx (stk_inf_pure # get_stk_and_reset) ctx1 in
        let ctx1 = x_add add_infer_rel_to_ctx (stk_rel_ass # get_stk_and_reset) ctx1 in
        let () = x_tinfo_hp (add_str "ctx1 1" Cprinter.string_of_context) ctx1 no_pos in
        (SuccCtx[ctx1],UnsatAnte)
      else
        let estate = Gen.unsome_safe !smart_unsat_estate estate in
        let (lhs_h,lhs_p) = if (CF.isAnyConstFalse estate.es_formula)
          then  (HFalse,MCP.mkMFalse no_pos)
          else
            (lhs_h,lhs_p)
        in
        (* else (lhs_h,lhs_p) in *)
        let inf_p = stk_inf_pure # get_stk in
        let inf_relass = stk_rel_ass # get_stk_and_reset in
        (* let inf_heap_ass = stk_rel_ass # get_stk in *)
        let estate = add_infer_pure_to_estate inf_p estate in
        let () = y_tinfo_pp "to add univ inst" in
        let () = y_tinfo_hp (add_str "inf_pure" (pr_list !CP.print_formula)) inf_p in
        let () = y_tinfo_hp (add_str "estate" Cprinter.string_of_entail_state) estate in
        let estate = x_add add_infer_rel_to_estate inf_relass estate in
        let to_add_rel_ass =
          (match !Globals.pre_residue_lvl with
           | 0 -> let x = List.map (fun (_,_,a) -> a) inf_relass in
             if List.exists CP.is_disjunct x then [] else x
           | 1 -> List.map (fun (_,_,a) -> a) inf_relass
           | -1 -> []
           | _ -> report_error pos "pre_residue_lvl is not -1 or 0 or 1")
        in
        let to_add = MCP.mix_of_pure (CP.join_conjunctions (inf_p@to_add_rel_ass)) in
        let lhs_p = MCP.merge_mems lhs_new to_add true in
        let res_delta = mkBase lhs_h lhs_p lhs_vp lhs_t lhs_fl lhs_a no_pos in (* TODO: res_vp *)
        let res_delta = x_add_1 CF.simplify_pure_f_old res_delta in
        let estate = { estate with es_formula = res_delta; } in
        let estate = x_add_1 add_univ_pure estate in

        (* Termination *)
        (* let pr = Cprinter.string_of_formula in *)
        (* let () = Debug.info_hprint (add_str "stk_estate" (pr_list pr))  *)
        (*   (List.map (fun es -> es.es_formula) (stk_estate # get_stk)) no_pos in *)
        let (estate, _, (* rhs_p, *) rhs_wf) =
          if not !Globals.dis_term_chk then
            Term.check_term_rhs prog estate lhs_p xpure_lhs_h0 xpure_lhs_h1 rhs_p_lexvar pos
          else
            (* let _, rhs_p = x_add_1 TermUtils.strip_lexvar_mix_formula rhs_p in *)
            (estate, lhs_p, (* rhs_p, *) None)
        in
        (* Termination: Try to prove rhs_wf with inference *)
        (* rhs_wf = None --> measure succeeded or no striggered inference *)
        (* lctx = Fail --> well-founded termination failure - No need to update term_res_stk *)
        (* lctx = Succ --> termination succeeded with inference *)
        let estate = match rhs_wf with
          | None -> estate
          | Some rank ->
            begin
              let () = Debug.ninfo_hprint (add_str "conseq1" pr_no) conseq no_pos in
              match (heap_infer_decreasing_wf prog conseq estate rank is_folding lhs pos) with
              | None ->
                (try
                   let t_ann, ml, il = Term.find_lexvar_es estate in
                   let term_pos, t_ann_trans, orig_ante, _ = Term.term_res_stk # top in
                   let term_measures, term_res, term_err_msg =
                     Some (CP.Fail CP.TermErr_May, ml, il),
                     (term_pos, t_ann_trans, orig_ante,
                      Term.MayTerm_S (Term.Not_Decreasing_Measure t_ann_trans)),
                     Some (Term.string_of_term_res (term_pos, t_ann_trans, None, Term.TermErr (Term.Not_Decreasing_Measure t_ann_trans)))
                   in
                   let term_stack = match term_err_msg with
                     | None -> estate.CF.es_var_stack
                     | Some msg -> msg::estate.CF.es_var_stack
                   in
                   Term.term_res_stk # pop;
                   Term.term_res_stk # push term_res;
                   { estate with
                     CF.es_var_measures = term_measures;
                     CF.es_var_stack = term_stack;
                     CF.es_term_err = term_err_msg;
                   }
                 with _ -> estate)
              | Some es -> es
            end
        in

        (*************************************************************************)
        (********** BEGIN ENTAIL VarPerm [lhs_vperm_vars] |- rhs_vperms **********)
        (*************************************************************************)
        let vperm_res = x_add Vperm.vperm_entail_rhs estate conseq pos in
        match vperm_res with
        | Vperm.Fail rctx -> (rctx, Failure)
        | Vperm.Succ estate ->
          (*************************************************************************)
          (*************************** END *****************************************)
          (*************************************************************************)
          (*if there exist VarPerm, they will be automatically
            dropped during the proving process*)

          if is_folding then begin
            (*LDK: the rhs_p is considered a part of residue and
              is added to es_pure only when folding.
              Rule F-EMP in Mr Hai thesis, p86*)
            (*filter out vperm which has been proven in rhs_p*)
            (* let rhs_p = MCP.drop_varperm_mix_formula rhs_p in *)
            let to_keep = estate.es_gen_impl_vars @ estate.es_gen_expl_vars in
            let to_remove =  Gen.BList.difference_eq CP.eq_spec_var (MCP.mfv rhs_p)to_keep in
            (* Debug.info_hprint (add_str "es_formula" !CF.print_formula) estate.es_formula no_pos; *)
            (* Debug.info_hprint (add_str "es_pure" !print_mix_formula) estate.es_pure no_pos; *)
            (* Debug.info_hprint (add_str "rhs_p" !print_mix_formula) rhs_p no_pos; *)
            (* Debug.info_hprint (add_str "impl" !print_svl) estate.es_gen_impl_vars no_pos; *)
            (* Debug.info_hprint (add_str "expl" !print_svl) estate.es_gen_expl_vars no_pos; *)
            (* Debug.info_hprint (add_str "evars" !print_svl) estate.es_evars no_pos; *)
            (* x_tinfo_hp (add_str "to_remove" !print_svl) to_remove no_pos; *)
            (* x_tinfo_hp (add_str "to_keep" !print_svl) to_keep no_pos; *)
            let res_es = {estate with (* es_formula = res_delta; *)
                          es_pure = MCP.merge_mems rhs_p estate.es_pure true;
                          es_success_pts = (List.fold_left (fun a (c1,c2)-> match (c1,c2) with
                              | Some s1,Some s2 -> (s1,s2)::a
                              | _ -> a) [] r_succ_match)@estate.es_success_pts;
                          es_unsat_flag = false; (*the new context could be unsat*)
                          (* es_unsat_flag = estate.es_unsat_flag && (no_infer_rel estate); *)
                         } in
            let res_ctx = Ctx (CF.add_to_estate res_es "folding performed") in
            (* TODO-WN why are there two elim_unsat_ctx? *)
            let res_ctx = elim_unsat_ctx prog (ref 1) res_ctx in
            x_dinfo_zp (lazy ("heap_entail_empty_heap: folding: formula is valid")) pos;
            x_dinfo_zp (lazy ("heap_entail_empty_heap: folding: res_ctx:\n" ^ (Cprinter.string_of_context res_ctx))) pos;
            (SuccCtx[res_ctx], prf)
          end
          else
            begin
              let estate1 = if CF.is_error_flow conseq then
                  let err_msg = "error-infer" in
                  let estate = {estate with es_formula = CF.substitute_flow_into_f !error_flow_int estate.CF.es_formula;
                               } in
                  let fc_kind = Failure_Must err_msg in
                  {estate with es_formula = CF.substitute_flow_into_f !error_flow_int estate.CF.es_formula;
                  }
                else estate in
              let res_ctx = Ctx {estate1 with (* es_formula = res_delta; *)
                                 es_unsat_flag = false; (*the new context could be unsat*)
                                 es_success_pts = (List.fold_left (fun a (c1,c2)->
                                     match (c1,c2) with
                                     | Some s1,Some s2 -> (s1,s2)::a
                                     | _ -> a) [] r_succ_match)@estate.es_success_pts;} in
              (* TODO-WN why is there another elim_unsat_ctx? *)
              let res_ctx = elim_unsat_ctx prog (ref 1) res_ctx in
              x_tinfo_zp (lazy ("heap_entail_empty_heap: formula is valid")) pos;
              x_tinfo_zp (lazy ("heap_entail_empty_heap: res_ctx:\n" ^ (Cprinter.string_of_context res_ctx))) pos;
              (SuccCtx[res_ctx], prf)
            end
    end
    else
      (*** CODE TO INFER PRECOND ***)
      begin
        x_tinfo_zp (lazy ("heap_entail_empty_rhs_heap: formula is not valid\n")) pos;
        (*compute lub of estate.es_formula and current fc_flow*)
      (*
        fc_flow: safe -> normal_flow --or higher
        must bug -> sleek_mustbug_flow
        may bug -> sleek_maybug_flow
      *)
        let cex = x_add Slsat.check_sat_empty_rhs_with_uo estate_orig lhs (MCP.pure_of_mix rhs_p) rhs_matched_set in
        let is_sat = CF.is_sat_fail cex in
        if not !disable_failure_explaining then
          let new_estate = if
            (CF.is_en_error_exc estate) then {
              estate with es_formula =
                            match fc_kind with
                            | CF.Failure_Must _ -> if estate.es_infer_obj # is_err_may_all then
                                CF.substitute_flow_into_f !mayerror_flow_int estate.es_formula
                              else
                                CF.substitute_flow_into_f !error_flow_int estate.es_formula
                            | CF.Failure_May _ ->
                               CF.substitute_flow_into_f !mayerror_flow_int estate.es_formula
                            (* this denotes a maybe error *)
                            | CF.Failure_Bot _ -> estate.es_formula
                            | CF.Failure_Valid -> estate.es_formula
            } else estate in
          let fc_template = {
            fc_message = "??? 4785";
            fc_current_ents = [];
            fc_current_lhs  = new_estate;
            fc_prior_steps = estate.es_prior_steps;
            fc_orig_conseq  = struc_formula_of_formula (formula_of_mix_formula rhs_p pos) pos;
            fc_current_conseq = CF.formula_of_heap HFalse pos;
            fc_failure_pts = match r_fail_match with | Some s -> [s]| None-> [];} in
          let must_list1, may_list1,contra_list1 = (* if is_sat then (must_list@may_list, []) else *)
            (* if annotate err_may: no must error at the end*)
            if estate.es_infer_obj # is_err_may_all then ([],must_list@may_list@contra_list, [])
            else
              (must_list, may_list, contra_list)
          in
          let pr_es = Cprinter.string_of_entail_state in
          let () = x_tinfo_zp (lazy ("ndldlfew estate: " ^ (pr_es new_estate))) pos in
          let lc0 = x_add Musterr.build_and_failures 1 "213" fc_kind Globals.logical_error (contra_list1, must_list1, may_list1) fc_template cex new_estate.es_trace in
          (lc0, prf)
        else
          let () = x_tinfo_pp "marking \n" no_pos in
          let err_msg = "failed in entailing pure formula(s) in conseq" in
          (CF.mkFailCtx_in (Basic_Reason ({
               fc_message = err_msg;
               fc_current_ents = [];
               fc_current_lhs  = estate;
               fc_prior_steps = estate.es_prior_steps;
               fc_orig_conseq  = struc_formula_of_formula (formula_of_mix_formula rhs_p pos) pos;
               fc_current_conseq = CF.formula_of_heap HFalse pos;
               fc_failure_pts = match r_fail_match with | Some s -> [s]| None-> [];},
               {fe_kind = fc_kind; fe_name = Globals.logical_error ;fe_locs=[]}, estate.es_trace)) ((convert_to_may_es estate), err_msg, Failure_May err_msg) cex, prf)
      end in
  (ctx, prf)
(****************************************************************)
(* utilities for splitting the disjunctions in the antecedent and the
            conjunctions in the consequent *)
(****************************************************************)
(*
try to solve the inequalities from the rhs by making queries to the memory set:
- if the inequality cannot be solved -> leave it in the conseq
- if the equality is solved -> remove it from conseq
        *)

and post_process_result ctx prf =
  let ctx = Immutable.imm_post_process_for_entail_empty_rhs ctx in
  (ctx,prf)

(* detect if there is a constradiction between the ptr equations generated by ante and the disjointness sets in memset *)
and detect_false (ante : MCP.mix_formula) (memset : CF.mem_formula) : bool =
  let pr1 = Cprinter.string_of_mix_formula in
  let pr2 = Cprinter.string_of_mem_formula in
  Debug.no_2 "detect_false" pr1 pr2 string_of_bool detect_false_x ante memset

and detect_false_x (ante : MCP.mix_formula) (memset : CF.mem_formula) : bool =
  (* if not (TP.is_sat_mix_sub_no ante (ref 1) true true) then true
     else *)
  if not(!Globals.ineq_opt_flag)
  then false
  else
    let eqset = match ante with
      | MCP.MemoF at ->
        MCP.ptr_equations_aux_mp false at
      | MCP.OnePF at ->
        CP.pure_ptr_equations at
    in
    let eqset = CP.EMapSV.build_eset eqset in
    (* let neq_pairs = CF.generate_disj_pairs_from_memf memset in *)
    (* List.fold_left *)
    (*    (fun x y -> x || (CP.EMapSV.is_equiv eqset (fst y) (snd y))) false neq_pairs *)
    let m = memset.mem_formula_mset in
    let rec helper l =
      match l with
      | h::r ->
        if (r!=[]) then
          (List.fold_left
             (fun x y -> x || CP.EMapSV.is_equiv eqset h y) false r) || (helper r)
        else false
      | [] -> false
    in
    List.fold_left
      (fun x y -> x || (helper y)) false m

and solve_ineq a m c =
  Debug.no_3 "solve_ineq "
    (Cprinter.string_of_mix_formula)
    (Cprinter.string_of_mem_formula)
    (Cprinter.string_of_mix_formula)
    (Cprinter.string_of_mix_formula) (fun _ _ _ -> solve_ineq_x a m c) a m c

and solve_ineq_x (ante_m0:MCP.mix_formula) (memset : Cformula.mem_formula)
    (conseq : MCP.mix_formula) : MCP.mix_formula =
  (* let memset = {mem_formula_mset = [[Cpure.SpecVar (Cpure.Prim Int, "x", Unprimed);Cpure.SpecVar (Cpure.Prim Int, "y", Unprimed)]]} in *)
  if not(!Globals.ineq_opt_flag)
  then conseq
  else
    match ante_m0,conseq with
    | (MCP.MemoF at,MCP.MemoF f) ->
      begin
        (* print_endline "solve_ineq: first"; *)
        MCP.MemoF (solve_ineq_memo_formula at memset f)
      end
    | (MCP.OnePF at,MCP.OnePF f) ->
      begin
        (* print_endline "solve_ineq: second"; *)
        MCP.OnePF (solve_ineq_pure_formula at memset f)
      end
    |  _ ->  Error.report_error
               {Error.error_loc = no_pos; Error.error_text = ("antecedent and consequent mismatch")}

and solve_ineq_memo_formula (ante : memo_pure) (memset : Cformula.mem_formula) (conseq : memo_pure) : memo_pure =
  let eqset = CP.EMapSV.build_eset (MCP.ptr_equations_aux_mp false ante) in
  let eq x y = CP.EMapSV.is_equiv eqset x y in
  let f_memo x = None in
  let f_aset x = None in
  let f_formula x = None in
  let f_b_formula e =
    let (pf,il) = e in
    match pf with
    | CP.Neq (e1,e2,_) -> 	if (CP.is_var e1) && (CP.is_var e2) then
        let v1 = CP.to_var e1 in
        let v2 = CP.to_var e2 in
        let discharge = CP.DisjSetSV.is_disj eq memset.Cformula.mem_formula_mset v1 v2 in
        let ans = (if discharge then (CP.BConst(true,no_pos),il) else e) in
        Some ans
      else None
    | _ -> None in
  let f_exp x = None in
  let f = (f_memo, f_aset, f_formula, f_b_formula, f_exp) in
  MCP.transform_memo_formula f conseq

(* check whether the disjunction is of the form (x<y | y<x) which can be discharged by using the memory set *)
and check_disj ante memset l (f1 : Cpure.formula) (f2 : Cpure.formula) pos : Cpure.formula =
  let s_ineq = solve_ineq_pure_formula ante memset in
  match f1, f2 with
  | CP.BForm((pf1, il1), label1), CP.BForm((pf2, il2), label2) ->
    (match pf1, pf2 with
     | CP.Lt(e1, e2, _), CP.Lt(e3, e4, _) ->
       (match e1, e2, e3, e4 with
        | CP.Var(sv1, _), CP.Var(sv2, _), CP.Var(sv3, _), CP.Var(sv4, _) ->
          if (CP.eq_spec_var sv1 sv4) && (CP.eq_spec_var sv2 sv3)
          then
            s_ineq  (CP.BForm ((CP.Neq(CP.Var(sv1, pos), CP.Var(sv2, pos), pos), il1), label1))
          else
            Cpure.mkOr (s_ineq f1) (s_ineq f2) l pos
        | _, _, _, _ -> Cpure.Or((s_ineq f1), (s_ineq f2), l, pos)
       )
     | _, _ -> Cpure.mkOr (s_ineq f1) (s_ineq f2) l pos
    )
  | _, _ -> Cpure.mkOr (s_ineq f1) (s_ineq f2) l pos

(*************************************
  methods for implication discharging
 ***************************************)
(*
  and imply_mix_formula_new ante_m0 ante_m1 conseq_m imp_no memset
  :bool *(formula_label option * formula_label option) list * formula_label option =
(* let () = print_string ("\nSolver.ml: imply_mix_formula " ^ (string_of_int !imp_no)) in *)
(* detect whether memset contradicts with any of the ptr equalities from antecedent *)
  let ante_m0 = if detect_false ante_m0 memset then MCP.mkMFalse no_pos else ante_m0 in
  let conseq_m = solve_ineq ante_m0 memset conseq_m in
  match ante_m0,ante_m1,conseq_m with
  | MCP.MemoF a, _, MCP.MemoF c -> MCP.imply_memo a c TP.imply imp_no
  | MCP.OnePF a0, MCP.OnePF a1 ,MCP.OnePF c ->
  let increm_funct =
  if !enable_incremental_proving then Some !TP.incremMethodsO
  else None in
  CP.imply_disj
  (CP.split_disjunctions a0) (* list with xpure0 antecedent disjunctions *)
  (CP.split_disjunctions a1) (* list with xpure1 antecedent disjunctions *)
  (CP.split_conjunctions c) (* list with consequent conjunctions *)
  TP.imply         (* imply method to be used for implication proving *)
  increm_funct
  imp_no
  | _ -> report_error no_pos ("imply_mix_formula: mix_formula mismatch")
*)
and imply_mix_formula i ante_m0 ante_m1 conseq_m imp_no memset =
  let new_ante_m1 = if ante_m0==ante_m1 then None else Some ante_m1 in
  let pr2 = pr_list Cprinter.string_of_pure_formula in
  let prr ((r,_,_),sp) = (pr_pair string_of_bool (pr_option (pr_pair pr2 pr2))) (r,sp) in
  let pr = Cprinter.string_of_mix_formula in
  Debug.no_4_num i "imply_mix_formula" pr
    (pr_option pr) pr Cprinter.string_of_mem_formula
    prr
    (fun _ _ _ _ -> imply_mix_formula_x ante_m0 new_ante_m1 conseq_m imp_no memset)
    ante_m0 new_ante_m1 conseq_m memset
(*
type: MCP.mix_formula -> MCP.mix_formula -> MCP.mix_formula -> int ref ->
  CF.mem_formula ->
  (bool *
   (Globals.formula_label option * Globals.formula_label option) list *
   Globals.formula_label option) *
  (Cpure.Label_Pure.exp_ty list * CP.formula list) option


 bool * (Globals.formula_label option * Globals.formula_label option) list *
  Globals.formula_label option

*)
and imply_mix_formula_x ante_m0 ante_m1 conseq_m imp_no memset =
  (* detect whether memset contradicts with any of the ptr equalities from antecedent *)
  let ante_m0 = if detect_false ante_m0 memset then MCP.mkMFalse no_pos else ante_m0 in
  let conseq_m = solve_ineq ante_m0 memset conseq_m in
  match ante_m0, conseq_m with
  | MCP.MemoF a, MCP.MemoF c ->
    begin
      x_tinfo_pp ">>>>>> imply_mix_formula: memo <<<<<<" no_pos;
      (*print_endline "imply_mix_formula: first";*)
      if (MCP.isConstMFalse conseq_m) then ((false,[],None),None)
      else
        let r1,r2,r3 = x_add MCP.imply_memo 1 a c (x_add TP.imply_one 27) imp_no in
        if r1 || not(!Globals.super_smart_xpure) then ((r1,r2,r3),None)
        else
          begin
            match ante_m1 with
            | None -> ((r1,r2,r3),None)
            | Some (MCP.MemoF a1) -> (x_add MCP.imply_memo 2 a1 c (x_add TP.imply_one 28) imp_no,None)
            | _ -> report_error no_pos ("imply_mix_formula: mix_formula mismatch")
          end
          (* TODO : This to be avoided if a1 is the same as a0; also pick just complex constraints *)
    end
  | MCP.OnePF a0, MCP.OnePF c ->
    begin
      x_tinfo_pp ">>>>>> imply_mix_formula: pure <<<<<<" no_pos;
      let f a0 =
        let a0 = (* Wrapper.wrap_exception a0 TP.simplify_omega *) a0 in
        if CP.no_andl a0 && !Globals.deep_split_disjuncts
        then
          let a0 = CP.drop_exists a0 in
          List.filter CP.is_sat_eq_ineq (CP.split_disjunctions_deep a0)
        else
        if CP.no_andl a0
        then
          (* let () = print_endline "no deep split" in *)
          (* infer_deep_ante_issues : WN : why not we handle deep? *)
          CP.split_disjunctions a0
        else
          (* why andl need to be handled in a special way *)
          let r = ref (-999) in
          let is_sat f = CP.is_sat_eq_ineq f (*TP.is_sat_sub_no 6 f r*) in
          let a0l = if !label_split_ante then CP.split_disjunctions a0 else [a0] in
          let a0l = List.filter is_sat a0l in a0l
      in
      let process_univ univ_vars ante0 conseq0 =
        if not (TP.connected_rhs univ_vars conseq0) then ()
        else
          let prev_inst = TP.univ_rhs_store # get in
          let ante0 = CP.drop_rel_formula ante0 in
          let ante1 =TP.filter_inv ante0 in
          let new_conseq = CP.mkAnd ante1 prev_inst no_pos in
          let new_conseq = CP.mkAnd new_conseq conseq0 no_pos in
          let new_conseq = CP.mkExists univ_vars new_conseq None no_pos in
          let b = x_add !CP.tp_imply ante0 new_conseq in
          if b then
            let () = y_tinfo_hp (add_str "process_univ added!" Cprinter.string_of_pure_formula) conseq0 in
            TP.univ_rhs_store # set conseq0
          else
            ()
      in
      let process_univ univ_vars ante0 conseq0 =
        Debug.no_3 "process_univ" !CP.print_svl Cprinter.string_of_pure_formula Cprinter.string_of_pure_formula (fun x -> "()") process_univ univ_vars ante0 conseq0
      in
      let univ_vars = TP.get_univs_from_ante a0 in
      let new_rhs = if !Globals.split_rhs_flag then (CP.split_conjunctions c) else [c] in
      let a0l = f a0 in
      let a1l = match ante_m1 with
        | Some (MCP.OnePF a1) -> f a1
        | None -> []
        | _ -> report_error no_pos ("imply_mix_formula: mix_formula mismatch")
      in
      let ln0 = List.length a0l in
      let ln1 = List.length a1l in
      let extra_step =
        if ln0>1 || ln1>1 then Some(a0l,a1l)
        (* then if ln0>ln1 then Some (a0l,[]) else Some(a1l,[])  *)
        else None in
      let pr = Cprinter.string_of_pure_formula in
      x_ninfo_hp (add_str "a0" pr) a0 no_pos;
      x_dinfo_hp (add_str "ante-a0l" (pr_list pr)) a0l no_pos;
      x_dinfo_hp (add_str "ante-a1l" (pr_list pr)) a1l no_pos;
      let () = CP.store_tp_is_sat := (fun f -> TP.is_sat 77 f "store_tp_is_sat" true) in
      (x_add CP.imply_conj_orig (ante_m1==None) a0l a1l new_rhs (x_add TP.imply_one 29) imp_no, extra_step)
    end
  | _ -> report_error no_pos ("imply_mix_formula: mix_formula mismatch")

and imply_mix_formula_no_memo i new_ante new_conseq imp_no imp_subno timeout memset =
  Debug.no_3_num i "imply_mix_formula_no_memo" Cprinter.string_of_mix_formula Cprinter.string_of_mix_formula Cprinter.string_of_mem_formula
    (fun (r,_,_) -> string_of_bool r)
    (fun new_ante new_conseq memset -> imply_mix_formula_no_memo_x new_ante new_conseq imp_no imp_subno timeout memset)
    new_ante new_conseq memset

(* WN TODO : temporary change to call imply_mix_formula; need to redo properly *)
and imply_mix_formula_no_memo_x new_ante new_conseq imp_no imp_subno timeout memset =
  (* detect whether memset contradicts with any of the ptr equalities from antecedent *)
  let drop_last_item ((b,l,o1),_) = (b,l,o1) in
  let new_ante = if detect_false new_ante memset then MCP.mkMFalse no_pos else new_ante in
  let new_conseq = solve_ineq new_ante memset new_conseq in
  let (r1,r2,r3) =
    let xx = ref imp_no in
    match timeout with
    | None -> drop_last_item (x_add imply_mix_formula 98 new_ante new_ante new_conseq xx memset)
    (* TP.mix_imply new_ante new_conseq ((string_of_int imp_no) ^ "." ^ (string_of_int imp_subno)) *)
    | Some t -> drop_last_item (x_add imply_mix_formula 99 new_ante new_ante new_conseq xx memset )
    (* TODO : lost timeout here *)
    (* TP.mix_imply_timeout new_ante new_conseq ((string_of_int imp_no) ^ "." ^ (string_of_int imp_subno)) t *)
  in
  let () = x_dinfo_pp ("asta5?") no_pos in
  x_dinfo_zp (lazy ("IMP #" ^ (string_of_int imp_no) ^ "." ^ (string_of_int imp_subno))) no_pos;
  (r1,r2,r3)

and do_base_case_unfold_only prog ante conseq estate lhs_node rhs_node  is_folding pos rhs_b =
  let pr x = match x with
    | None -> "None"
    | Some _ -> "Some" in
  Debug.no_4 "do_base_case_unfold_only"
    (* Cprinter.string_of_formula  *)
    (add_str "ante:" Cprinter.string_of_formula)
    (add_str "conseq:" Cprinter.string_of_formula)
    (add_str "LHS node" Cprinter.string_of_h_formula)
    (add_str "RHS node" Cprinter.string_of_h_formula)
    pr
    (fun _ _ _ _ -> do_base_case_unfold_only_x prog ante conseq estate lhs_node rhs_node is_folding pos rhs_b)
    ante conseq lhs_node rhs_node

and do_unfold_hp_rel_x prog estate lhs_b_orig conseq rhs_node is_folding pos hp vs=
  let rec subst_hprel_2_view hp args vn hf=
    match hf with
    | HRel (hp1, eargs1, _) ->
      let args1 = List.map CP.exp_to_sv eargs1 in
      if CP.eq_spec_var hp hp1 && CP.eq_spec_var_order_list args args1 then vn
      else hf
    | CF.Star {CF.h_formula_star_h1 = hf1;
               CF.h_formula_star_h2 = hf2;
               CF.h_formula_star_pos = pos} ->
      F.Star {CF.h_formula_star_h1 = subst_hprel_2_view hp args vn hf1;
              CF.h_formula_star_h2 = subst_hprel_2_view hp args vn hf2;
              CF.h_formula_star_pos = pos}
    | _ -> hf
  in
  let () = y_tinfo_pp "do_base_unfold_hp_rel (TBI)" in
  let knd = CP.RelAssume [hp] in
  let es_cond_path = CF.get_es_cond_path estate in
  let matched_svl = [] in
  let estate_lhs = estate.CF.es_formula in
  let (lhf,mlf,_,_,_,_) = CF.split_components estate_lhs in
  let lhds, _, _ = CF.get_hp_rel_h_formula lhf in
  let leqs = (MCP.ptr_equations_without_null mlf) in
  let leqNulls = MCP.get_null_ptrs mlf in
  let norm_rhs_view_node_args = (CP.diff_svl (CF.get_ptrs_w_args ~en_pure_field:estate.CF.es_infer_obj # is_pure_field_all rhs_node) vs) in
  let rhs_view_node_args = CP.subst_var_list estate.CF.es_rhs_eqset norm_rhs_view_node_args in
  let ass_guard = x_add InferHP.find_guard prog lhds leqs leqNulls
      [(hp,CP.diff_svl ((* CP.remove_dups_svl *) (vs(* @rhs_view_node_args *))) leqNulls)] (* rhs_arg *)(CP.diff_svl  (rhs_view_node_args) leqNulls) (* [] *) in
  let sel_eqns_svl = match ass_guard with
    | None -> vs
    | Some f -> CP.intersect_svl vs ((CF.get_ptrs f)@ (CF.get_ptrs rhs_node)) in
  let () = y_tinfo_hp (add_str "sel_eqns_svl" !CP.print_svl) sel_eqns_svl in
  let rhs_p = CP.gen_cl_eqs pos (CP.remove_dups_svl sel_eqns_svl) (CP.mkTrue pos) in
  let is_sat = TP.is_sat_raw (MCP.memoise_add_pure_N mlf rhs_p) in
  if not is_sat then
    let ls_ctx = Errctx.mkFailCtx_may ~conseq:(Some conseq) x_loc "do_unfold (false)" estate pos in
    (ls_ctx, Unknown)
  else
    let rhs_b = CF.formula_base_of_pure (MCP.mix_of_pure rhs_p) pos in
    (* let rhs = CF.formula_of_pure_formula rhs_p pos in *)
    let rhs = CF.Base rhs_b in
    let lhs_b = CF.formula_base_of_heap (CF.HRel (hp,List.map (fun sv -> CP.Var (sv, pos)) vs,pos)) pos in
    let lhs = CF.Base lhs_b in
    let grd = x_add InferHP.check_guard estate ass_guard lhs_b_orig lhs_b rhs_b pos in
    (* from unfolding *)
    let hp_rel = CF.mkHprel ~fold_type:false knd [] [] matched_svl lhs grd rhs es_cond_path in
    let () = y_tinfo_hp (add_str "do_unfold:hp_rel" Cprinter.string_of_hprel_short) hp_rel in
    let () = y_tinfo_hp (add_str "do_unfold:estate_lhs" !CF.print_formula) estate_lhs in
    if !Globals.old_infer_hp_collect then
      begin
        x_winfo_hp (add_str "HPRelInferred" (pr_list_ln Cprinter.string_of_hprel_short)) [hp_rel] no_pos;
        let () = Infer.rel_ass_stk # push_list ([hp_rel]) in
        let () = Log.current_hprel_ass_stk # push_list ([hp_rel]) in
        ()
      end;
    let () = estate.CF.es_infer_hp_rel # push_list_loc x_loc [hp_rel] in
    let vdecl = Cast.mk_view_decl_for_hp_rel (CP.name_of_spec_var hp) (List.map (fun sv -> (sv, NI)) (List.tl vs)) false pos in
    let vdecl_w_def = {vdecl with Cast.view_formula = CF.struc_formula_of_formula rhs pos;
                                  Cast.view_un_struc_formula = [(rhs, (fresh_int (),""))];
                                  view_raw_base_case = Some rhs;
                                  Cast.view_base_case = Some (rhs_p, MCP.mix_of_pure rhs_p);
                      } in
    let () = prog.Cast.prog_view_decls <- prog.Cast.prog_view_decls@[vdecl_w_def] in
    let lhs_node = CF.mkViewNode (List.hd vs) (CP.name_of_spec_var hp) (List.tl vs) pos in
    let estate = {estate with es_formula = formula_map (subst_hprel_2_view hp vs lhs_node) estate.CF.es_formula} in
    let unfold_num = 1 in
    let delta1,_ = unfold_nth 1 (prog,None) estate.es_formula (List.hd vs) true unfold_num pos in (* update unfold_num *)
    let ctx1 = build_context (Ctx estate) delta1 pos in
    let rec prune_helper c =
      match c with
      | OCtx (c1,c2) -> OCtx(prune_helper c1, prune_helper c2)
      | Ctx es -> Ctx ({es with es_formula = prune_preds prog false (*true*) es.es_formula})
    in
    let res_rs, prf1 = x_add heap_entail_one_context 8 prog is_folding (prune_helper ctx1) (*ctx1*) conseq None None None pos in
    let () = y_tinfo_hp (add_str "ctx1" !CF.print_context) ctx1 in
    let () = y_tinfo_hp (add_str "conseq" !CF.print_formula) conseq in
    let () = y_tinfo_hp (add_str "res_rs" !CF.print_list_context) res_rs in
    let prf = mkUnfold (Ctx estate) conseq lhs_node prf1 in
    (res_rs, prf)

and do_unfold_hp_rel prog estate lhs_b conseq rhs_node is_folding pos hp vs=
  (* let pr1 = pr_none in *)
  let pr1 (e,_) = Cprinter.string_of_list_context_short e in
  let pr2 = !CF.print_h_formula in
  Debug.no_4 "do_unfold_hp_rel"
    (add_str "estate" Cprinter.string_of_entail_state)
    (add_str "hp" !CP.print_sv)
    (add_str "vs" !CP.print_svl)
    (add_str "rhs_node" pr2) pr1
    (fun _ _ _ _ -> do_unfold_hp_rel_x prog estate lhs_b conseq rhs_node is_folding pos hp vs) estate hp vs rhs_node

and do_base_case_unfold_only_x prog ante conseq estate lhs_node rhs_node is_folding pos rhs_b =
  if (is_data lhs_node) then None
  else begin
    (x_dinfo_zp (lazy ("do_base_case_unfold attempt for : " ^
                       (Cprinter.string_of_h_formula lhs_node))) pos);
    (* match lhs_node with *)
    (*   | HRel (hp,args,_) -> *)
    (*         if CF.is_exists_hp_rel hp estate then *)
    (*           let vs = List.map CP.exp_to_sv args in *)
    (*           do_base_unfold_hp_rel prog estate pos hp vs *)
    (*         else *)
    (*           None *)
    (*   | _ -> *)
    (* c1,v1,p1 *)
    let lhs_name,lhs_arg,lhs_var = get_node_name 19 lhs_node, get_node_args lhs_node , get_node_var lhs_node in
    let () = Gen.Profiling.push_time "empty_predicate_testing" in
    let lhs_vd = (look_up_view_def_raw x_loc prog.prog_view_decls lhs_name) in
    let fold_ctx = Ctx {(empty_es (mkTrueFlow ()) estate.es_group_lbl pos) with
                        es_formula = ante;
                        es_heap = estate.es_heap;
                        es_evars = estate.es_evars;
                        es_gen_expl_vars = estate.es_gen_expl_vars;
                        es_gen_impl_vars = estate.es_gen_impl_vars;
                        es_ante_evars = estate.es_ante_evars;
                        es_unsat_flag = false;
                        es_var_zero_perm = estate.es_var_zero_perm;
                        es_prior_steps = estate.es_prior_steps;
                        es_path_label = estate.es_path_label;
                        es_cond_path = estate.es_cond_path ;
                        es_var_measures = estate.es_var_measures;
                        (* es_infer_tnt = estate.es_infer_tnt; *)
                        es_infer_obj = estate.es_infer_obj;
                        es_var_stack = estate.es_var_stack;
                        es_orig_ante = estate.es_orig_ante;
                        es_infer_vars = estate.es_infer_vars;
                        es_infer_vars_dead = estate.es_infer_vars_dead;
                        es_infer_vars_rel = estate.es_infer_vars_rel;
                        es_infer_vars_templ = estate.es_infer_vars_templ;
                        es_infer_vars_hp_rel = estate.es_infer_vars_hp_rel;
                        es_infer_vars_sel_hp_rel = estate.es_infer_vars_sel_hp_rel;
                        es_infer_vars_sel_post_hp_rel = estate.es_infer_vars_sel_post_hp_rel;
                        es_infer_hp_unk_map = estate.es_infer_hp_unk_map;
                        es_infer_heap = estate.es_infer_heap;
                        es_infer_templ = estate.es_infer_templ;
                        es_infer_templ_assume = estate.es_infer_templ_assume;
                        es_infer_pure = estate.es_infer_pure;
                        es_infer_pure_thus = estate.es_infer_pure_thus;
                        es_infer_term_rel = estate.es_infer_term_rel;
                        es_infer_rel = estate.es_infer_rel # clone;
                        es_infer_hp_rel = estate.es_infer_hp_rel # clone;
                        es_group_lbl = estate.es_group_lbl;
                        es_term_err = estate.es_term_err;
                        es_trace = estate.es_trace;
                       } in
    let na,prf = match lhs_vd.view_base_case with
      | None ->  let () = Debug.ninfo_hprint (add_str "NONE 1" pr_id) "1" no_pos in
        x_dinfo_zp (lazy ("do_base_case_unfold attempt : unsuccessful for : " ^
                          (Cprinter.string_of_h_formula lhs_node))) pos;
        let err_msg = "failure 1 ?? when checking for aliased node" in
        (CF.mkFailCtx_in(Basic_Reason ( {
             fc_message = err_msg;
             fc_current_lhs = estate;
             fc_current_ents = [];
             fc_prior_steps = estate.es_prior_steps;
             fc_orig_conseq = struc_formula_of_formula conseq pos; (* estate.es_orig_conseq; *)
             fc_current_conseq = conseq;
             fc_failure_pts = match (get_node_label rhs_node) with | Some s-> [s] | _ -> [];},
             CF.mk_failure_must "9999" Globals.sl_error, estate.es_trace)) ((convert_to_must_es estate), err_msg, Failure_Must err_msg) (mk_cex true), UnsatConseq)
      | Some (bc1,base1) ->
        begin
          let fr_vars = (CP.SpecVar (Named lhs_vd.Cast.view_data_name, self,
                                     Unprimed)) :: lhs_vd.view_vars in
          let to_vars = lhs_var :: lhs_arg in
          let base = MCP.subst_avoid_capture_memo fr_vars to_vars base1 in
          let bc1 = Cpure.subst_avoid_capture fr_vars to_vars bc1 in
          let (nctx,b) = sem_imply_add prog is_folding  fold_ctx bc1 !enable_syn_base_case in
          if b then
            (* TODO : need to trigger UNSAT checking here *)
            let ctx = unfold_context_unsat_now prog (prog, Some (base,(lhs_name,lhs_arg))) (SuccCtx[nctx]) lhs_var pos in

            x_dinfo_zp (lazy ("do_base_case_unfold attempt : successful : " ^
                              (Cprinter.string_of_h_formula lhs_node)^
                              "\n Start Ante :"^(Cprinter.string_of_formula ante)^
                              "\n New Ante :"^(Cprinter.string_of_list_context_short ctx))) pos;
            (ctx,TrueConseq)
          else begin
            x_dinfo_zp (lazy ("do_base_case_unfold attempt : unsuccessful for : " ^
                              (Cprinter.string_of_h_formula lhs_node))) pos;
            let err_msg = "failure 2 ?? when checking for aliased node" in
            (CF.mkFailCtx_in(Basic_Reason  ( {
                 fc_message = err_msg;
                 fc_current_ents = [];
                 fc_current_lhs = estate;
                 fc_prior_steps = estate.es_prior_steps;
                 fc_orig_conseq = struc_formula_of_formula conseq pos; (* estate.es_orig_conseq; *)
                 fc_current_conseq = conseq;
                 fc_failure_pts = match (get_node_label rhs_node) with | Some s-> [s] | _ -> [];},
                 CF.mk_failure_must "99" Globals.sl_error, estate.es_trace)) ((convert_to_must_es estate), err_msg, Failure_Must err_msg) (mk_cex true),TrueConseq)
          end
        end in
    let () = Gen.Profiling.pop_time "empty_predicate_testing" in
    if (isFailCtx na) then None
    else
      let cx = match na with | SuccCtx l -> List.hd l |_ -> report_error pos("do_base_case_unfold_only: something wrong has happened with the context") in
      let () = Gen.Profiling.push_time "proof_after_base_case" in
      let do_fold_result,prf = x_add heap_entail_one_context 5 prog is_folding cx (CF.Base rhs_b) None None None pos in
      let () = Gen.Profiling.pop_time "proof_after_base_case" in
      Some(do_fold_result,prf)
  end

and is_classic_lhs_emp prog h1 ante pos =
  let h1_unfold =
    let prep_ante = do_unfold_for_classic_reasoning prog ante pos in
    match prep_ante with
    | CF.Or _ -> h1
    | _ -> let h,_,_,_,_,_ = split_components prep_ante in h
    (* if flag then *)
    (* else h1 *)
  in
  let () = x_tinfo_hp (add_str "h1_unfold" !CF.print_h_formula) h1_unfold no_pos
  in
  h1_unfold==HEmp || (is_resourceless_h_formula prog h1_unfold)
  || (is_classic_lending_hformula h1_unfold)

and do_unfold_for_classic_reasoning prog (f: CF.formula) (pos : loc) =
  let pr_in = Cprinter.string_of_formula in
  let pr_out = Cprinter.string_of_formula in
  Debug.no_1 "do_unfold_for_classic_reasoning" pr_in pr_out
    (fun _ -> do_unfold_for_classic_reasoning_x prog f pos) f


and do_unfold_for_classic_reasoning_x prog (f: CF.formula) (pos : loc) =
  let rec collect_view_hvars_formula (f: CF.formula) : CP.spec_var list = (
    match f with
    | CF.Base { CF.formula_base_heap = h } -> collect_view_hvars_hformula h
    | CF.Or { CF.formula_or_f1 = f1;
              CF.formula_or_f2 = f2; } -> (
        let r1 = collect_view_hvars_formula f1 in
        let r2 = collect_view_hvars_formula f2 in
        CP.remove_dups_svl (r1 @ r2)
      )
    | CF.Exists { CF.formula_exists_heap = h} -> collect_view_hvars_hformula h
  )
  and collect_view_hvars_hformula (h: CF.h_formula) : CP.spec_var list = (
    match h with
    | CF.Star { CF.h_formula_star_h1 = h1;
                CF.h_formula_star_h2 = h2 } ->
      let r1 = collect_view_hvars_hformula h1 in
      let r2 = collect_view_hvars_hformula h2 in
      CP.remove_dups_svl (r1 @ r2)
    | CF.StarMinus { CF.h_formula_starminus_h1 = h1;
                     CF.h_formula_starminus_h2 = h2; } ->
      let r1 = collect_view_hvars_hformula h1 in
      let r2 = collect_view_hvars_hformula h2 in
      CP.remove_dups_svl (r1 @ r2)
    | CF.Conj { CF.h_formula_conj_h1 = h1;
                CF.h_formula_conj_h2 = h2; } ->
      let r1 = collect_view_hvars_hformula h1 in
      let r2 = collect_view_hvars_hformula h2 in
      CP.remove_dups_svl (r1 @ r2)
    | CF.ConjStar { CF.h_formula_conjstar_h1 = h1;
                    CF.h_formula_conjstar_h2 = h2; } ->
      let r1 = collect_view_hvars_hformula h1 in
      let r2 = collect_view_hvars_hformula h2 in
      CP.remove_dups_svl (r1 @ r2)
    | CF.ConjConj { CF.h_formula_conjconj_h1 = h1;
                    CF.h_formula_conjconj_h2 = h2; } ->
      let r1 = collect_view_hvars_hformula h1 in
      let r2 = collect_view_hvars_hformula h2 in
      CP.remove_dups_svl (r1 @ r2)
    | CF.Phase { CF.h_formula_phase_rd = h1;
                 CF.h_formula_phase_rw = h2; } ->
      let r1 = collect_view_hvars_hformula h1 in
      let r2 = collect_view_hvars_hformula h2 in
      CP.remove_dups_svl (r1 @ r2)
    | CF.ViewNode { CF.h_formula_view_node = c } -> [c]
    | CF.DataNode _ -> []
    | CF.ThreadNode _ -> [] (*TOCHECK*)
    | CF.Hole _ | CF.FrmHole _ -> []
    | CF.HRel _ -> []
    | CF.HTrue -> []
    | CF.HFalse -> []
    | CF.HEmp  | CF.HVar _ -> []
  ) in
  let view_hvars = collect_view_hvars_formula f in
  let unfolded_f = List.fold_left (fun old_f v ->
      let nf,_ = unfold_nth 1 (prog, None) old_f v false 0 pos in
      nf
    ) f view_hvars in
  let res = elim_unsat_for_unfold prog unfolded_f in
  (* return *)
  res

(*LDK*)
and do_lhs_case prog ante conseq estate lhs_node rhs_node is_folding pos =
  let pr x = match x with
    | None -> "None"
    | Some _ -> "Some" in
  Debug.no_4 "do_lhs_case"
    (add_str "ante" Cprinter.string_of_formula)
    (add_str "conseq" Cprinter.string_of_formula)
    (add_str "lhs node" Cprinter.string_of_h_formula)
    (add_str "rhs node" Cprinter.string_of_h_formula)
    pr
    (fun _ _ _ _-> do_lhs_case_x prog ante conseq estate lhs_node rhs_node is_folding pos)
    ante conseq lhs_node rhs_node

and do_lhs_case_x prog ante conseq estate lhs_node rhs_node is_folding pos=
  let c1,v1,p1 = get_node_name 20 lhs_node, get_node_args lhs_node , get_node_var lhs_node in
  let () = x_binfo_pp "marking" no_pos in
  let vd = (look_up_view_def_raw x_loc prog.prog_view_decls c1) in
  let () = x_binfo_pp "marking" no_pos in
  let na,prf =
    (match vd.view_base_case with
     | None ->
       x_dinfo_zp (lazy ("do_lhs_case : unsuccessful for : "
                         ^ (Cprinter.string_of_h_formula lhs_node))) pos;
       let err_msg = "failure 1 ?? no vd.view_base_case to do case analysis" in
       (CF.mkFailCtx_in(Basic_Reason ( {
            fc_message = err_msg;
            fc_current_ents = [];
            fc_current_lhs = estate;
            fc_prior_steps = estate.es_prior_steps;
            fc_orig_conseq = struc_formula_of_formula conseq pos; (* estate.es_orig_conseq; *)
            fc_current_conseq = conseq;
            fc_failure_pts = match (get_node_label rhs_node) with | Some s-> [s] | _ -> [];},
            CF.mk_failure_must "9999" Globals.sl_error, estate.es_trace)) ((convert_to_must_es estate), err_msg, Failure_Must err_msg) (mk_cex true), UnsatConseq)
     |  Some (bc1,base1) ->
       (*Turn off lhs_case flag to disable further case analysis *)
       let new_ante = CF.set_lhs_case_of_a_view ante c1 false in
       let fr_vars = (CP.SpecVar (Named vd.Cast.view_data_name, self, Unprimed)) :: vd.view_vars in
       let to_vars = p1 :: v1 in
       let bc1 = Cpure.subst_avoid_capture fr_vars to_vars bc1 in
       let not_bc1 = x_add_1 Cpure.mkNot bc1 None no_pos in

       let fold_ctx = Ctx {(empty_es (mkTrueFlow ()) estate.es_group_lbl pos) with es_formula = ante;
                                                                                   es_heap = estate.es_heap;
                                                                                   es_evars = estate.es_evars;
                                                                                   es_gen_expl_vars = estate.es_gen_expl_vars;
                                                                                   es_gen_impl_vars = estate.es_gen_impl_vars;
                                                                                   es_ante_evars = estate.es_ante_evars;
                                                                                   es_unsat_flag = false;
                                                                                   es_prior_steps = estate.es_prior_steps;
                                                                                   es_path_label = estate.es_path_label;
                                                                                   es_cond_path = estate.es_cond_path ;
                                                                                   es_orig_ante = estate.es_orig_ante;
                                                                                   es_infer_vars = estate.es_infer_vars;
                                                                                   es_infer_heap = estate.es_infer_heap;
                                                                                   es_infer_templ = estate.es_infer_templ;
                                                                                   es_infer_templ_assume = estate.es_infer_templ_assume;
                                                                                   es_infer_term_rel = estate.es_infer_term_rel;
                                                                                   (* es_infer_tnt = estate.es_infer_tnt; *)
                                                                                   es_infer_obj = estate.es_infer_obj;
                                                                                   es_infer_pure = estate.es_infer_pure;
                                                                                   es_var_zero_perm = estate.es_var_zero_perm;
                                                                                   es_infer_pure_thus = estate.es_infer_pure_thus;
                                                                                   es_infer_rel = estate.es_infer_rel # clone;
                                                                                   (* WN Check : do we need to restore infer_heap/pure
                                                                                      here *)
                                                                                   es_var_measures = estate.es_var_measures;
                                                                                   es_var_stack = estate.es_var_stack;
                                                                                   es_group_lbl = estate.es_group_lbl;
                                                                                   es_term_err = estate.es_term_err;
                          } in
       (*to eliminate redundant case analysis, we check whether
         current antecedent implies the base case condition that
         we want to do case analysis
         if (ante |- bc) or (ante |- bc1) => don't need case analysis
       *)
       let (_,b1) = sem_imply_add prog is_folding  fold_ctx bc1 !enable_syn_base_case in
       let (_,b2) = sem_imply_add prog is_folding  fold_ctx not_bc1 !enable_syn_base_case in
       let new_ante1 =
         if (b1 || b2) then
           (*no case analysis*)
           new_ante
         else


           (*Doing case analysis on LHS: ante & (base \/ not(base) ) *)

           (*this way not correct ??? *)
           (* let case_formula = Cpure.mkOr bc1 not_bc1 None no_pos in *)
           (* let new_ante1 = CF.normalize_combine new_ante (CF.formula_of_pure_formula case_formula no_pos) no_pos in *)

           let or1 = CF.normalize_combine new_ante (CF.formula_of_pure_formula bc1 no_pos) no_pos in
           let or2 = CF.normalize_combine new_ante (CF.formula_of_pure_formula not_bc1 no_pos) no_pos in
           (CF.mkOr or1 or2 pos)
       in
       let ctx = build_context (Ctx estate) new_ante1 pos in
       let res_rs, prf1 = x_add heap_entail_one_context 6 prog is_folding ctx conseq None None None pos in
       (res_rs, prf1)
    )
  in
  Some (na,prf)

(*match and instatiate perm vars*)
(*Return a substitution, labels, to_ante,to_conseq*)
and do_match_inst_perm_vars_x (l_perm:P.exp option) (r_perm:P.exp option) (l_args:P.spec_var list) (r_args:P.spec_var list) label_list (evars:P.spec_var list) ivars impl_vars expl_vars glob_vs =
  let pr_subs = pr_list (pr_pair !CP.print_sv !CP.print_sv) in
  let prep_subs left right impl glob_vs =
    let subs =
      try
        List.combine left right
      with _ ->
        let () = x_winfo_pp ((add_str "WARNING: not same length" (pr_pair !print_svl !print_svl)) (left,right)) no_pos in
        []
    in
    let subs = List.filter (fun (l,r) -> not(CP.eq_spec_var l r)) subs in
    let (lst_impl,lst_ex) = List.partition (fun (l,_) -> CP.mem_svl l impl_vars) subs in
    let (lst_glob,lst_ex) = List.partition (fun (l,_) ->
        if !Globals.old_empty_to_conseq then false else CP.mem_svl l glob_vs) lst_ex in
    let subs = lst_impl @ lst_ex in
    let pr_subs = pr_list (pr_pair !print_sv !print_sv) in
    let to_ante = List.fold_left  (fun e (l,r) -> CP.mkAnd e (CP.mkEqVar l r no_pos) no_pos) (CP.mkTrue no_pos) lst_impl in
    let () = x_tinfo_hp (add_str "impl_vars" !print_svl) impl_vars no_pos in
    let () = x_tinfo_hp (add_str "glob_vs" !print_svl) glob_vs no_pos in
    let msg = (add_str "to_conseq(glob)" pr_subs) lst_glob in
    let () = x_tinfo_pp msg no_pos in
    let () = x_tinfo_hp (add_str "impl_inst(subs)" pr_subs) lst_impl no_pos in
    let () = x_tinfo_hp (add_str "ex_subs" pr_subs) lst_ex no_pos in
    let () = if !Globals.assert_no_glob_vars && lst_glob!=[] then
        let () = x_winfo_hp (add_str "impl_vars" !print_svl) impl_vars no_pos in
        let () = x_winfo_hp (add_str "glob_vs" !print_svl) glob_vs no_pos in
        let () = x_winfo_hp (add_str "evars" !print_svl) evars no_pos in
        let () = x_winfo_hp (add_str "ivars" !print_svl) ivars no_pos in
        failwith ("non-empty global vars "^msg)
    in
    let to_conseq = List.fold_left  (fun e (l,r) -> CP.mkAnd e (CP.mkEqVar l r no_pos) no_pos) (CP.mkTrue no_pos) lst_glob in
    (to_ante, (* CP.mkTrue no_pos *) to_conseq, subs) in
  begin
    (* to_ante & to_conseq not properly built below *)
    if (Perm.allow_perm ()) then
      let () = x_winfo_pp "impl_inst and to_conseq not properly built" no_pos in
      (match l_perm, r_perm with
       | Some f1, Some f2 ->
         let ls1 = Perm.get_cperm_var l_perm in
         let ls2 = Perm.get_cperm_var r_perm in
         let rho_0 = List.combine (ls2@r_args) (ls1@l_args) in
         let () = x_tinfo_hp (add_str "rho_0" pr_subs) rho_0 no_pos in
         let label_list1 =
           match !Globals.perm with
           | Bperm -> [LO.unlabelled; LO.unlabelled; LO.unlabelled]
           | _ -> [LO.unlabelled]
         in
         let label_list = (label_list1@label_list) in
         (rho_0, label_list,CP.mkTrue no_pos,CP.mkTrue no_pos)
       | None, Some f2 ->
         (match !Globals.perm with
          | Bperm -> report_error no_pos "[solver.ml] do_match_inst_perm_vars : unexpected for bperm"
          | _ ->
            let f2 = Cpure.get_var f2 in
            let rho_0 = List.combine (f2::r_args) (full_perm_var ()::l_args) in
            let () = x_tinfo_hp (add_str "rho_0" pr_subs) rho_0 no_pos in
            let label_list = (LO.unlabelled::label_list) in
            (rho_0, label_list,CP.mkTrue no_pos,CP.mkTrue no_pos))

       (*(if (List.mem f2 evars) then
         (*rename only*)
         let rho_0 = List.combine (f2::r_args) (full_perm_var () ::l_args) in
         let label_list = (LO.unlabelled::label_list) in
         (rho_0, label_list,CP.mkTrue no_pos,CP.mkTrue no_pos)
         else if (List.mem f2 expl_vars) then
         (*f2=full to RHS to inst later*)
         let rho_0 = List.combine (r_args) (l_args) in
         let p_conseq = mkFullPerm_pure () f2 in
         let label_list = (label_list) in
         (rho_0, label_list,CP.mkTrue no_pos,p_conseq)
         else if (List.mem f2 impl_vars) then
         (*instantiate: f2=full to LHS. REMEMBER to remove it from impl_vars*)
         let rho_0 = List.combine (r_args) (l_args) in
         let p_ante = mkFullPerm_pure () f2 in
         let label_list = (label_list) in
         (rho_0, label_list,p_ante,CP.mkTrue no_pos)
         else (*global vars*)
         (*f2=full to RHS*)
         let rho_0 = List.combine (r_args) (l_args) in
         let p_conseq = mkFullPerm_pure () f2 in
         let label_list = (label_list) in
         (rho_0, label_list,CP.mkTrue no_pos,p_conseq))*)
       | Some f1, None ->
         (match !Globals.perm with
          | Bperm -> report_error no_pos "[solver.ml] do_match_inst_perm_vars : unexpected for bperm"
          | _ ->
            let f1 = Cpure.get_var f1 in
            (*f1 is either ivar or global
              if it is ivar, REMEMBER to convert it to expl_var*)
            let rho_0 = List.combine r_args l_args in
            let () = x_tinfo_hp (add_str "rho_0" pr_subs) rho_0 no_pos in
            let label_list = (label_list) in
            let t_conseq =
              mkFullPerm_pure () f1 in
            (rho_0, label_list,CP.mkTrue no_pos,t_conseq))
       | _ -> let rho_0 = List.combine r_args l_args in
         let () = x_tinfo_hp (add_str "rho_0" pr_subs) rho_0 no_pos in
         (rho_0, label_list, CP.mkTrue no_pos,CP.mkTrue no_pos)
      )
    else
      let (to_ante,to_conseq,rho_0) = prep_subs r_args l_args impl_vars glob_vs in
      (* try *)
      (*   List.combine r_args l_args *)
      (* with _ -> [] (\*matching with cyclic proof is not the same predicate*\) in *)
      let () = x_tinfo_hp (add_str "rho_0" pr_subs) rho_0 no_pos in
      let () = x_tinfo_hp (add_str "to_ante" !CP.print_formula) to_ante no_pos in
      let () = x_tinfo_hp (add_str "to_conseq" !CP.print_formula) to_conseq no_pos in
      (* without branch label *)
      (* let to_ante =(\*  List.fold_left (fun acc_p p -> CP.mkAnd acc_p p no_pos) (CP.mkTrue no_pos) *\) *)
      (*   (\* (List.map (fun (sv1,sv2) -> CP.mkEqVar sv1 sv2 no_pos) rho_0) *\) *)
      (*   CP.mkTrue no_pos *)
      (* in *)
      (rho_0, label_list, to_ante (* CP.mkTrue no_pos *),to_conseq (* CP.mkTrue no_pos *))

  end

and do_match_inst_perm_vars l_perm r_perm l_args r_args label_list evars ivars impl_vars expl_vars glob_vs =
  do_match_inst_perm_vars_x l_perm r_perm l_args r_args label_list evars ivars impl_vars expl_vars glob_vs
(* let pr_out (rho,lbl,ante,conseq) = *)
(*   let s1 = pr_pair Cprinter.string_of_pure_formula Cprinter.string_of_pure_formula (ante,conseq) in *)
(*   let s2 = pr_list (pr_pair Cprinter.string_of_spec_var Cprinter.string_of_spec_var) rho in *)
(*   "rho: "^s2^"\n to_ante; to_conseq: "^s1 *)
(* in *)
(* Debug.no_6 "do_match_inst_perm_vars"  *)
(*   (string_of_cperm ()) *)
(*   (string_of_cperm ()) *)
(*   (add_str "evars" string_of_spec_var_list) *)
(*   (add_str "impl_vars" string_of_spec_var_list) *)
(*   (add_str "l_args" string_of_spec_var_list) *)
(*   (add_str "r_args" string_of_spec_var_list) *)
(*   pr_out *)
(*   (fun _ _ _ _ _ _ -> do_match_inst_perm_vars_x l_perm r_perm l_args r_args label_list evars ivars impl_vars expl_vars glob_vs)  *)
(*   l_perm r_perm evars impl_vars l_args r_args *)

(*Modified a set of vars in estate to reflect instantiation
  when matching 2 perm vars*)
and do_match_perm_vars (l_perm:P.exp option) (r_perm:P.exp option) evars ivars impl_vars expl_vars =
  begin
    if (Perm.allow_perm ()) then
      (match l_perm, r_perm with
       | Some f1, Some f2 ->
         (*these cases will be handled by existing mechanism*)
         evars,ivars,impl_vars, expl_vars
       | None, None  ->
         (*no change*)
         evars,ivars,impl_vars, expl_vars
       | None, Some f2 ->
         let f2 = Cpure.get_var f2 in
         (if (List.mem f2 evars) then
            (*rename only. May not need to remove it from evars*)
            evars,ivars,impl_vars, expl_vars
          else if (List.mem f2 expl_vars) then
            (*f2=full to RHS to inst later*)
            evars,ivars,impl_vars, expl_vars
          else if (List.mem f2 impl_vars) then
            (*instantiate: f2=full to LHS. REMEMBER to remove it from impl_vars*)
            let new_impl_vars = Gen.BList.difference_eq CP.eq_spec_var impl_vars [f2] in
            (evars,ivars,new_impl_vars, expl_vars)
          else
            (*global vars. No change*)
            (*f2=full to RHS*)
            evars,ivars,impl_vars, expl_vars)
       | Some f1, None ->
         let f1 = Cpure.get_var f1 in
         (*f1 is either ivar or global
           if it is ivar, REMEMBER to convert it to expl_var*)
         (if (List.mem f1 ivars) then
            let new_ivars = Gen.BList.difference_eq CP.eq_spec_var ivars [f1] in
            let new_expl_vars = f1::expl_vars in
            (evars,new_ivars,impl_vars,new_expl_vars)
          else
            (evars,ivars,impl_vars,expl_vars)
         )
      )
    else
      (*not changed of no perm*)
      evars,ivars,impl_vars, expl_vars
  end

(*generate rel formula for relational args of views*)
and generate_rel_formulas_x prog (lrel,rrel) pos=
  try
    let ldef = Cast.look_up_rel_def_raw (prog.Cast.prog_rel_decls # get_stk) (CP.name_of_spec_var lrel) in
    let rdef = Cast.look_up_rel_def_raw (prog.Cast.prog_rel_decls # get_stk) (CP.name_of_spec_var rrel) in
    if List.length ldef.Cast.rel_vars = List.length rdef.Cast.rel_vars then
      let new_args= CP.fresh_spec_vars ldef.Cast.rel_vars  in
      let exps = List.map (fun sv -> CP.mkVar sv pos) new_args in
      let lp_rel= CP.mkRel lrel exps pos in
      let rp_rel= CP.mkRel rrel exps pos in
      (lp_rel, rp_rel)
    else
      report_error pos "solver.generate_rel_formula: relations should be relational args of one view"
  with Not_found -> report_error pos "solver.generate_rel_formula: relation defs should be there"

and generate_rel_formulas prog (lrel,rrel) pos=
  let pr1 = pr_pair !CP.print_sv !CP.print_sv in
  let pr2= pr_pair !CP.print_formula !CP.print_formula in
  Debug.no_1 "generate_rel_formulas" pr1 pr2
    (fun _ -> generate_rel_formulas_x prog (lrel,rrel) pos) (lrel,rrel)

and generate_rels_formulas prog rels pos=
  let rec helper lp rp ls=
    match ls with
    | [] -> lp,rp
    | pair::tl ->
      let lp1,rp1 = generate_rel_formulas prog pair pos in
      let new_lp = CP.mkAnd lp lp1 pos in
      let new_rp = CP.mkAnd rp rp1 pos in
      helper new_lp new_rp tl
  in
  helper (CP.mkTrue pos) (CP.mkTrue pos) rels

(* Compute syntactic matching number of two resources eq_rsr: l_rsr |- r_rsr
   0 : completely matched -> MATCH
   1 : possibly matched with some substitution -> (try)MATCH
   2 : unmatched, lhs>rhs -> (syntatic) SPLIT
   3 : unmatched, lhs>rhs or lhs!=rhs -> FAIL (will try semantic MATCH/SPLIT)
   -1 : not care

   l_idents: root vars to guide the syntatic comparision
   RETURN (matching number, mapping table , remained_rsr)
      - Matching number (above)
      - mapping table: [(from,to)] -> possible substitutions
        so that the delayed/resource are equal.
      - remained_rsr: resource left after split
*)
and compute_matching_thread_nodes l_idents l_rsr r_rsr =
  let pr i = match i with
    | 0 -> "MATCH"
    | 1 -> "(may)MATCH"
    | 2 -> "(syn)SPLIT"
    | 3 -> "FAIL"
    | _ -> "UNKNOWN"
  in
  let pr_out = pr_triple pr Cprinter.string_of_subst (pr_option (pr_list Cprinter.string_of_formula)) in
  Debug.no_3 "compute_matching_thread_nodes"
    string_of_ident_list
    Cprinter.string_of_formula
    Cprinter.string_of_formula
    pr_out
    compute_matching_thread_nodes_x l_idents l_rsr r_rsr

and compute_matching_thread_nodes_x l_idents l_rsr r_rsr =
  let (eq_rsr,mtl_rsr) = x_add Checkeq.checkeq_formulas_with_diff l_idents l_rsr r_rsr in
  if eq_rsr then
    (*possibly matched*)
    if (mtl_rsr==[]) then (0,[],None) (*exacly match*)
    else
      (*TOCHECK: pick the first one only*)
      let (mt_rsr,_,_) = List.hd mtl_rsr in
      let mt_rsr = Checkeq.remove_trivial_mt (Checkeq.remove_dupl_mt mt_rsr) in
      if (mt_rsr==[]) then (0,[],None) (*exactly matched*)
      else (1,mt_rsr,None) (*possibly matched, with some subsitition mt_rsr*)
  else
    (*UNMATCH: see whether it is a split or a failure*)
  if (mtl_rsr==[]) then report_error no_pos "[solver.ml] do_match_thread_nodes: unexpected"
  else
    (*TOCHECK: pick the first one only*)
    let (mt_rsr, l_residue , r_residue) = List.hd mtl_rsr in
    if not (CF.isStrictConstEmp r_residue) then (*lhs<rhs: FAIL*) (3,[],None)
    else (2,mt_rsr,Some [l_residue]) (*SPLIT*)

(***********begin-of do_match_thread_nodes*****************)
(*Handle Threads as Resource:

  checkeq(l_dl,r_dl)       checkeq(l_rsr,r_rsr)
  --------------------------------------------------------[MATCH]
  t1::thread<l_rsr> |- t1::thread<r_rsr>


  checkeq(l_dl,r_dl)         !checkeq(l_rsr,r_rsr)
  l_rsr |- r_rsr * remained_rsr
  --------------------------------------------------------[SPLIT]
  t1::thread<l_rsr> |- t1::thread<r_rsr> * t1::thread<rsr3>


  !checkeq(l_dl,r_dl) or l_rsr |/- r_rsr
  --------------------------------------------------------[FAIL]
  t1::thread<l_rsr> |/- t1::thread<r_rsr>

*)
(* RETURN:
   new label_list
   new l_args
   new r_args
   (is_thread, is_matched, rs_matched, rs_split)
   is_threads=true -> matching two ThreadNodes
   eq_dl=true -> two delayed formulas are eq
   is_matched -> whether a matching happened

*)
(*Only care about this if you are matching two HeapNode*)
and do_match_thread_nodes prog estate l_node r_node rhs rhs_matched_set is_folding pos l_args r_args label_list =
  let is_thread,eq_dl,match_number,subst, remained_rsr =
    (match (l_node,r_node) with
     | ThreadNode ({CF.h_formula_thread_delayed = l_dl;
                    CF.h_formula_thread_resource = l_rsr;}),
       ThreadNode ({CF.h_formula_thread_delayed = r_dl;
                    CF.h_formula_thread_resource = r_rsr;} as r_t) ->
       let () = print_endline_quiet ("Matching ThreadNodes") in
       (*Whether the delayed constraints are syntatically eq*)
       let (eq_dl,mt_dl) = x_add Checkeq.checkeq_p_formula [] l_dl r_dl [[]] in
       let mt1 = Checkeq.remove_trivial_mt (Checkeq.remove_dupl_mt (List.concat mt_dl)) in
       (* non-empty mt_dl means l_dl and r_dl are not exactly match
          This may be too strict, will re-consider later *)
       let eq_dl = if mt1!=[] then false else eq_dl in
       (*Whether the resources are syntatically eq*)
       let l_idents = List.map CP.name_of_spec_var (CF.collect_node_var_formula l_rsr) in
       let match_number, mt_rsr, remained_rsr = compute_matching_thread_nodes l_idents l_rsr r_rsr in

       let mt = (List.concat mt_dl)@mt_rsr in
       let subst = Checkeq.remove_trivial_mt (Checkeq.remove_dupl_mt mt) in
       true,eq_dl,match_number,subst, remained_rsr
     | _ -> false,false,-1,[],None)
  in
  (match is_thread, eq_dl, match_number with
   | false, _ , _ -> label_list, l_args, r_args, (is_thread,true,None,None)
   | true, false, _ ->
     let () = print_endline_quiet ("MATCH of ThreadNodes failed") in
     let err_msg = "delayed formulas unmatched between LHS node and RHS node" in
     let rs = (CF.mkFailCtx_in (Basic_Reason (mkFailContext (* "delayed formulas unmatched between LHS node and RHS node" *)err_msg estate (CF.formula_of_heap HFalse pos) None pos, CF.mk_failure_must "101 : delayed formulas unmatched between LHS node and RHS node" Globals.sl_error, estate.es_trace)) ((convert_to_must_es estate), err_msg, Failure_Must err_msg) (mk_cex true), NoAlias) in
     label_list, l_args, r_args, (is_thread,false,Some rs,None)
   | true, true, 0
   | true, true, 1 ->
     (*For matching two thread nodes*)
     let () = print_endline_quiet ("Attempt Syntatic MATCH of ThreadNodes") in
     let label_list = if ((List.length subst) ==0 ) then label_list
       else
         (*Create a list of empty labels*)
         let rec helper i =
           if (i==0) then []
           else
             let res = helper (i-1) in
             (LO.unlabelled)::res
         in
         let lbs = helper (List.length subst) in
         lbs@label_list
     in
     let l_subst,r_subst = List.split subst in
     let l_args = l_subst@l_args in
     let r_args = r_subst@r_args in
     let is_matched = true in
     label_list, l_args, r_args, (is_thread,is_matched,None,None)
   | true, true, 2 ->
     (*For Syntatic SPLIT
       TOCHECK: currently ignore pure constraints for the resource*)
     let () = print_endline_quiet ("Attempt Syntatic SPLIT of ThreadNodes") in
     let label_list = if ((List.length subst) ==0 ) then label_list
       else
         (*Create a list of empty labels*)
         let rec helper i =
           if (i==0) then []
           else
             let res = helper (i-1) in
             (LO.unlabelled)::res
         in
         let lbs = helper (List.length subst) in
         lbs@label_list
     in
     let l_subst,r_subst = List.split subst in
     let l_args = l_subst@l_args in
     let r_args = r_subst@r_args in
     let is_matched = true in
     label_list, l_args, r_args, (is_thread,is_matched, None, remained_rsr)
   | true, true, 3 (*EVEN if syntatically failed, try to prove semantically*)
     (* -> let rs = (CF.mkFailCtx_in (Basic_Reason (mkFailContext "resources syntatically unmatched between LHS node and RHS node" estate (CF.formula_of_heap HFalse pos) None pos, CF.mk_failure_must "102 : resources syntatically unmatched between LHS node and RHS node" Globals.sl_error)), NoAlias) in *)
     (* label_list, l_args, r_args, (is_thread,false,Some rs, None) *)

     ->

     (*If NOT syntatic MATCH/SPLIT, try to permform semantic MATCH/SPLIT*)
     (*This will invoke provers, hence, is often slow.
       Therefore, we do a syntatic check above first,
       before going with this option *)
     (match (l_node,r_node) with
      | ThreadNode ({CF.h_formula_thread_resource = l_rsr;}),
        ThreadNode ({CF.h_formula_thread_resource = r_rsr;}) ->
        let es_f = if (Perm.allow_perm ()) then CF.add_mix_formula_to_formula (Perm.full_perm_constraint ()) l_rsr else l_rsr in
        let new_estate = {estate with es_formula = es_f;} in
        let new_ctx = Ctx (CF.add_to_estate new_estate "matching of resources") in
        let new_conseq = r_rsr in
        (* let () = print_endline ("Attempt Semantic Matching of ThreadNodes") in *)
        let res_ctx, res_prf = x_add heap_entail_conjunct 11 prog is_folding new_ctx new_conseq rhs_matched_set pos in
        (match res_ctx with
         | SuccCtx(cl) ->
           let formulas = List.map (fun c -> match c with
               | Ctx es ->
                 let evars = CP.remove_dups_svl (es.es_ivars @ es.es_evars @ es.es_ante_evars) in
                 let f = CF. push_exists evars es.es_formula in
                 (*Simplify the remained resources*)
                 let f = CF.elim_exists f in
                 (CF.simplify_pure_f f)
               | OCtx _ -> report_error no_pos "[solver.ml] do_match_thread_nodes: unexpected Octx. Not yet handled"
             ) cl
           in
           let is_matched = true in
           label_list, l_args, r_args, (is_thread,is_matched, None, Some formulas)
         | FailCtx _ ->
           let err_msg =  "103 : resources semantically unmatched between LHS and RHS thread nodes" in
           let rs = (CF.mkFailCtx_in (Basic_Reason (mkFailContext "resources semantically unmatched between LHS node and RHS node" new_estate new_conseq None pos, CF.mk_failure_must (* "103 : resources semantically unmatched between LHS and RHS thread nodes" *) err_msg Globals.sl_error, new_estate.es_trace)) ((convert_to_must_es estate), err_msg, Failure_Must err_msg) (mk_cex true), NoAlias) in
           label_list, l_args, r_args, (is_thread,false,Some rs,None))
      | _ ->
        report_error no_pos "[solver.ml] do_match_thread_nodes: unexpected")
   | true, true, _ ->
     report_error no_pos "[solver.ml] do_match_thread_nodes: unexpected")
(***********END-of do_match_thread_nodes*****************)

and do_match prog estate l_node r_node rhs (rhs_matched_set:CP.spec_var list) is_folding pos : list_context *proof =
  let pr (e,_) = Cprinter.string_of_list_context e in
  let pr_h = Cprinter.string_of_h_formula in
  Debug.no_5 "do_match" pr_h pr_h Cprinter.string_of_estate Cprinter.string_of_formula
    Cprinter.string_of_spec_var_list pr
    (fun _ _ _ _ _ -> do_match_x prog estate l_node r_node rhs rhs_matched_set is_folding pos)
    l_node r_node estate rhs rhs_matched_set

(* Pre-condition : should be called with only views and nodes *)
and do_match_x prog estate l_node r_node rhs (rhs_matched_set:CP.spec_var list) is_folding pos :
  list_context * proof =
  let estate, ((iadd_to_lhs, iadd_to_rhs, iadd_to_rhs_ex),subst) = x_add Context.imm_split_lhs_node estate l_node r_node in
  let () = x_tinfo_hp (add_str "subst" (pr_list (pr_pair !CP.print_sv !CP.print_sv))) subst pos in
  (* print_endline ("\n\n(andreeac)[do_match] input LHS = "^ (Cprinter.string_of_entail_state estate)); *)
  (* print_endline ("[do_match] RHS = "^ (Cprinter.string_of_formula rhs)); *)
  (* print_endline ("[do_match] matching " ^ (Cprinter.string_of_h_formula l_node) ^ " |- " ^ (Cprinter.string_of_h_formula r_node)); *)
  let m_str = (Cprinter.string_of_h_formula l_node) ^ " to prove " ^
              (Cprinter.string_of_h_formula r_node) in
  let () = x_tinfo_zp (lazy ("do_match: using " ^m_str)) no_pos in
  let lhs_self,rhs_self = match l_node,r_node with
    | DataNode {h_formula_data_node = l}, DataNode {h_formula_data_node = r}
      -> (l,r)
    | ViewNode {h_formula_view_node = l}, ViewNode {h_formula_view_node = r}
      -> (l,r)
    | HRel (hp1,_,_), HRel(hp2,_,_)
      -> let () = y_tinfo_pp ("HRel matching :"^m_str) in
      (hp1,hp2)
    | HVar (v1, _), HVar (v2, _) -> (v1, v2)
    | _, _ -> failwith ("do match failure: "^m_str)
  in
  let () = x_tinfo_hp (add_str "[LHS,RHS]" !print_svl) [lhs_self;rhs_self] no_pos in
  let () = x_tinfo_zp (lazy ("do_match: source LHS: " ^ (Cprinter.string_of_entail_state estate))) pos in
  let () = x_tinfo_zp (lazy ("do_match: source RHS: " ^ (Cprinter.string_of_formula rhs))) pos in
  let () = x_tinfo_hp (add_str "es_aux_conseq" !CP.print_formula) estate.es_aux_conseq no_pos in
  let () = x_tinfo_hp (add_str "es_rhs_pure" (pr_opt !CP.print_formula)) estate.es_rhs_pure no_pos in
  let () = x_tinfo_hp (add_str "es_aux_pure_lemma" !CP.print_formula) estate.es_conseq_pure_lemma no_pos in
  let () = x_tinfo_hp (add_str "es_aux_xpure_1" !MCP.print_mix_formula) estate.es_aux_xpure_1 no_pos in
  (* x_tinfo_hp (add_str "source LHS estate" (Cprinter.string_of_entail_state)) estate pos; *)
  (* x_tinfo_hp (add_str "source RHS rhs" (Cprinter.string_of_formula)) rhs pos; *)
  let l_ho_args, l_args, l_node_name, node_kind,_, l_perm, l_ann, l_param_ann
    = x_add_1 CF.get_args_of_node l_node in
  let r_ho_args, r_args, r_node_name, _, r_var, r_perm, r_ann, r_param_ann
    = x_add_1 CF.get_args_of_node r_node in
  let fvars_rhs = CF.get_args_of_hrel r_node in
  let () = y_tinfo_hp (add_str "l_args(do match)" !CP.print_svl) l_args in
  let () = y_tinfo_hp (add_str "r_args(do match)" !CP.print_svl) r_args in
  (*   match l_node with *)
  (*   | ThreadNode { *)
  (*       h_formula_thread_name = l_node_name; *)
  (*       h_formula_thread_perm = perm; } ->  *)
  (*     ([], [], l_node_name, "thread", perm, CP.ConstAnn(Mutable), []) *)
  (*   | DataNode { *)
  (*       h_formula_data_name = l_node_name; *)
  (*       h_formula_data_perm = perm; *)
  (*       h_formula_data_imm = ann; *)
  (*       h_formula_data_param_imm = param_ann; *)
  (*       h_formula_data_arguments = l_args } ->  *)
  (*     ([], l_args, l_node_name, "data", perm, ann, param_ann) *)
  (*   | ViewNode { *)
  (*       h_formula_view_name = l_node_name; *)
  (*       h_formula_view_perm = perm; *)
  (*       h_formula_view_imm = ann; *)
  (*       h_formula_view_arguments = l_args; *)
  (*       h_formula_view_ho_arguments = l_ho_args; *)
  (*       h_formula_view_annot_arg = l_annot } ->  *)
  (*     (l_ho_args, l_args, l_node_name, "view", perm, ann, (CP.annot_arg_to_imm_ann_list (List.map fst l_annot))) *)
  (*   (\* TODO:WN:HVar -*\) *)
  (*   | HVar (v,hvar_vs) -> ([], [], CP.name_of_spec_var v, "ho_var", None, CP.ConstAnn Mutable, []) *)
  (*   | HRel (_, eargs, _) -> ([], (List.fold_left List.append [] (List.map CP.afv eargs)), "", "hrel", None, CP.ConstAnn Mutable, []) *)
  (*   | _ -> report_error no_pos "[solver.ml]: do_match non view input lhs\n"  *)
  (* in *)
  (*   match r_node with *)
  (*   | ThreadNode { *)
  (*       h_formula_thread_name = r_node_name; *)
  (*       h_formula_thread_node = r_var; *)
  (*       h_formula_thread_perm = perm; } ->  *)
  (*     ([], [], r_node_name, r_var, perm, CP.ConstAnn(Mutable), []) *)
  (*   | DataNode { *)
  (*       h_formula_data_name = r_node_name; *)
  (*       h_formula_data_perm = perm; *)
  (*       h_formula_data_imm = ann; *)
  (*       h_formula_data_param_imm = param_ann; *)
  (*       h_formula_data_arguments = r_args; *)
  (*       h_formula_data_node = r_var } ->  *)
  (*     ([], r_args, r_node_name, r_var, perm, ann, param_ann) *)
  (*   | ViewNode { *)
  (*       h_formula_view_name = r_node_name; *)
  (*       h_formula_view_perm = perm; *)
  (*       h_formula_view_imm = ann; *)
  (*       h_formula_view_arguments = r_args; *)
  (*       h_formula_view_ho_arguments = r_ho_args; *)
  (*       h_formula_view_annot_arg = r_annot; *)
  (*       h_formula_view_node = r_var } ->  *)
  (*     (r_ho_args, r_args, r_node_name, r_var, perm, ann, (CP.annot_arg_to_imm_ann_list (List.map fst r_annot))) *)
  (*   (\* TODO:WN:HVar -*\) *)
  (*   | HVar (v,hvar_vs) -> ([], [], CP.name_of_spec_var v, v, None, CP.ConstAnn Mutable, []) *)
  (*   | HRel (rhp, eargs, _) -> ([], (List.fold_left List.append [] (List.map CP.afv eargs)), "", rhp, None, CP.ConstAnn Mutable, []) *)
  (*   | _ -> report_error no_pos "[solver.ml]: do_match non view input rhs\n"  *)
  (* in *)

  (* An Hoa : found out that the current design of do_match
     will eventually remove both nodes. Here, I detected that
     l_h & r_h captures the heap part. In order to capture
     the remaining part, we need to update l_h and r_h with
     the remaining of the l_node and r_node after matching
     (respectively. *)
  let es_impl_vars = estate.es_gen_impl_vars in
  let es_evars = estate.es_evars in
  let subtract = Gen.BList.difference_eq CP.eq_spec_var in
  let es_impl_vars = subtract es_impl_vars l_args in
  let estate = { estate with es_gen_impl_vars = es_impl_vars } in
  (* let es_impl_vars = diff es_impl_vars lhs_vars in *)
  (* let () = print_string("--C: r_node = " ^ (r_node_name) ^ "  spec var:" ^ (Cprinter.string_of_spec_var r_var) ^ "\n") in *)
  (* let () = print_string("--C: l_node = " ^ (l_node_name) ^ "\n") in *)
  (* let () = print_string("--C: r_ann = " ^ (Cprinter.string_of_imm r_ann) ^ "\n") in *)
  (* let () = print_string("--C: l_ann = " ^ (Cprinter.string_of_imm l_ann) ^ "\n") in *)
  (* check subtyping between lhs and rhs node ann, and collect info between ann vars and const vars *)
  let es_at_par = estate.es_infer_obj # is_par in
  let rhs_for_imm_inst = map_opt_def rhs (fun x ->  add_pure_formula_to_formula x rhs) estate.es_rhs_pure in
  let (subtyp, add_to_lhs, add_to_rhs, add_to_rhs_ex) =
    (* if ((\*not(!allow_field_ann) &&*\) (!allow_imm)) then *)
    (*   subtype_ann_gen es_impl_vars es_evars l_ann r_ann *)
    (* else (true, [], [],[])  (\*ignore node ann is field ann enable*\) in *)
    if not es_at_par then
      x_add (subtype_ann_gen ~rhs:rhs_for_imm_inst ~lhs:estate.es_formula) es_impl_vars es_evars l_ann r_ann
    else
      match l_ann, r_ann with
      | CP.ConstAnn Mutable, CP.ConstAnn Lend -> (false, [], [], [])
      | _ -> x_add (subtype_ann_gen ~rhs:rhs_for_imm_inst ~lhs:estate.es_formula) es_impl_vars es_evars l_ann r_ann
  in
  x_tinfo_hp (add_str "add_to_lhs" (pr_list Cprinter.string_of_pure_formula)) add_to_lhs pos;
  x_tinfo_hp (add_str "add_to_rhs" (pr_list Cprinter.string_of_pure_formula)) add_to_rhs pos;
  x_tinfo_hp (add_str "Imm annotation mismatch (node lvl)" (string_of_bool)) (not(subtyp)) pos;
  (* check imm subtyping between lhs and rhs node fields, and collect info between vars and consts - makes sense only for data nodes *)
  let (rl, param_ann_lhs, param_ann_rhs, param_ann_rhs_ex) =
    if (!allow_field_ann) then
      x_add (subtype_ann_list ~rhs:rhs_for_imm_inst ~lhs:estate.es_formula) es_impl_vars es_evars l_param_ann r_param_ann
    else (true, [], [], [])
  in
  x_tinfo_hp (add_str "param_ann_lhs" (pr_list ( Cprinter.string_of_pure_formula))) param_ann_lhs pos;
  x_tinfo_hp (add_str "param_ann_rhs" (pr_list ( Cprinter.string_of_pure_formula))) param_ann_rhs pos;
  x_tinfo_hp (add_str "Imm annotation mismatch (field lvl)" (string_of_bool)) (not(rl)) pos;
  (* let join_ann_constr ann ann_lst = *)
  (*   let f_lst = CP.remove_dupl_conj_opt_list (ann :: ann_lst) in *)
  (*   List.fold_left Immutable.mkAndOpt None f_lst in *)
  let join_ann_constr ann ann_lst =
    if List.length (ann@ann_lst) == 0 then None
    else Some (CP.join_conjunctions (ann@ann_lst))
  in
  (* construct two formulae for lhs and, respectively rhs, combining the constraints collected from both node ann and field ann *)
  let (r, ann_lhs, ann_rhs, ann_rhs_ex) = (
    subtyp && rl,
    join_ann_constr add_to_lhs (param_ann_lhs@iadd_to_lhs),
    join_ann_constr add_to_rhs (param_ann_rhs@iadd_to_rhs),
    join_ann_constr add_to_rhs_ex (param_ann_rhs_ex@iadd_to_rhs_ex)) in
  (* andreeac IMP add ann_to_rhs_ex to add_to_rhs *)
  (* If the matched view args are param-ann check those as well *)
  let l_args_ann = List.filter (fun c -> CP.is_ann_type (CP.type_of_spec_var c)) l_args in
  let r_args_ann = List.filter (fun c -> CP.is_ann_type (CP.type_of_spec_var c)) r_args in
  x_tinfo_hp (add_str "l_args_ann" Cprinter.string_of_spec_var_list ) l_args_ann  pos;
  x_tinfo_hp (add_str "r_args_ann" Cprinter.string_of_spec_var_list ) r_args_ann  pos;
  let (rvl, view_param_ann_lhs, view_param_ann_rhs, view_param_ann_rhs_ex) =  if (!allow_field_ann)
    then Mem.subtype_sv_ann_gen_list es_impl_vars l_args_ann r_args_ann
    else (true, None, None, None) in  (* andreeac: add ann view for ex *)
  x_tinfo_hp (add_str "view_param_ann_lhs" (pr_opt Cprinter.string_of_pure_formula)) view_param_ann_lhs pos;
  x_tinfo_hp (add_str "view_param_ann_rhs" (pr_opt Cprinter.string_of_pure_formula)) view_param_ann_rhs pos;
  x_tinfo_hp (add_str "Imm annotation mismatch (view param)" (string_of_bool)) (not(rvl)) pos;
  x_tinfo_hp (add_str "r,rvl" (pr_pair string_of_bool string_of_bool)) (r,rvl) no_pos;
  let (r, ann_lhs, ann_rhs, ann_rhs_ex) = (
    r && rvl,
    Immutable.mkAndOpt ann_lhs view_param_ann_lhs,
    Immutable.mkAndOpt ann_rhs view_param_ann_rhs,
    Immutable.mkAndOpt ann_rhs_ex view_param_ann_rhs_ex)
  in
  x_tinfo_hp (add_str "ann_lhs" (pr_opt Cprinter.string_of_pure_formula)) ann_lhs pos;
  x_tinfo_hp (add_str "ann_rhs" (pr_opt Cprinter.string_of_pure_formula)) ann_rhs pos;
  x_tinfo_hp (add_str "Imm annotation mismatch" (string_of_bool)) (not(r)) pos;
  if r == false
  then
    let at_par = if es_at_par then " @par " else " " in
    let err_msg = (* ("Imm annotation" ^ at_par ^ "mismatches") *) ("mismatched imm annotation" ^ at_par ^ "for " ^ node_kind ^ " " ^ l_node_name) in
    let fe = CF.mk_failure_must err_msg Globals.sl_error in
    (CF.mkFailCtx_in (Basic_Reason (mkFailContext err_msg estate (CF.formula_of_heap HFalse pos) None pos,
                                    fe, estate.es_trace))
       ((convert_to_must_es estate), err_msg, Failure_Must err_msg) (mk_cex true), NoAlias)
  else
    let () = x_tinfo_zp (lazy ("estate: "^ (Cprinter.string_of_entail_state estate))) pos in
    let l_h, l_p, l_vp, l_fl, l_t, l_a = split_components estate.es_formula in
    x_tinfo_hp (add_str "l_h" (Cprinter.string_of_h_formula)) l_h pos;
    x_tinfo_hp (add_str "l_p" (Cprinter.string_of_pure_formula))
      (MCP.pure_of_mix l_p) pos;
    let restore_hole h estate =
      let restore_hole_b = ((* isPoly r_ann && *) (isMutable l_ann || isImm l_ann)) || (CP.isPoly r_ann && CP.isPoly l_ann) in
      x_tinfo_hp (add_str "restore_hole_b" (string_of_bool)) restore_hole_b pos;
      if restore_hole_b then
        match h with
        | Hole _ ->
          let new_l_h = Immutable.apply_subs_h_formula estate.es_crt_holes l_h (* restore hole and update estate *) in
          x_tinfo_hp (add_str "new_l_h" (Cprinter.string_of_h_formula)) new_l_h pos;
          x_tinfo_hp (add_str "es_crt_holes length" (string_of_int)) (List.length estate.es_crt_holes) pos;
          let updated_ante = mkBase new_l_h l_p l_vp l_t l_fl l_a pos in
          let new_es = {estate with es_formula = updated_ante} in
          (new_l_h, new_es)
        | _ -> (l_h, estate)
      else (l_h, estate)
    in
    let replace_hole_w_emp h estate =
      (* if rhs ann is variable do no consume yet, restore the hole, works ok for impl quantif on rhs (w/o fields ann) *)
      let restore_hole_b = CP.isPoly r_ann && (CP.isMutable l_ann || CP.isImm l_ann) in
      if restore_hole_b then
        match h with
        | Hole _ ->
          let new_l_h = HEmp in
          x_tinfo_hp (add_str "new_l_h" (Cprinter.string_of_h_formula)) new_l_h pos;
          x_tinfo_hp (add_str "es_crt_holes length" (string_of_int)) (List.length estate.es_crt_holes) pos;
          let updated_ante = mkBase new_l_h l_p l_vp l_t l_fl l_a pos in
          let new_es = {estate with es_formula = updated_ante} in
          (new_l_h, new_es)
        | _ -> (l_h, estate)
      else (l_h, estate)
    in
    (* let (l_h, estate) = replace_hole_w_emp l_h estate in *)
    let (l_h, estate) = restore_hole l_h estate in
    x_tinfo_hp (add_str "l_h" (Cprinter.string_of_h_formula)) l_h pos;
    x_tinfo_hp (add_str "estate" (Cprinter.string_of_entail_state)) estate pos;
    let r_h, r_p, r_vp, r_fl, r_t, r_a = split_components rhs in
    x_tinfo_hp (add_str "r_h" (Cprinter.string_of_h_formula)) r_h pos;
    x_tinfo_hp (add_str "rhs" (Cprinter.string_of_formula)) rhs pos;
    let rem_l_node, rem_r_node, l_args, r_args, l_param_ann, r_param_ann =
      match (l_node, r_node) with
      | (DataNode dnl, DataNode dnr) ->
        let new_args = List.combine l_args r_args in
        let hole = CP.SpecVar (UNK, "#", Unprimed) in
        (* [Internal] function to cancel out two variables *)
        let cancel_fun (x,y) =
          if (CP.is_hole_spec_var x || CP.is_hole_spec_var y)
          then (x, y) else (hole, hole)
        in
        let new_args = List.map cancel_fun new_args in
        let new_l_args, new_r_args = List.split new_args in
        let new_l_holes = CF.compute_holes_list new_l_args in
        let new_r_holes = CF.compute_holes_list new_r_args in
        (* An Hoa : DO NOT ADD THE REMAINING TO THE LEFT HAND SIDE - *)
        (* IT MIGHT CAUSE INFINITE LOOP & CONTRADICTION AS           *)
        (* THE l_h IS ALWAYS ADDED TO THE HEAP PART.                 *)
        x_tinfo_hp (add_str "new_l_args" (pr_list string_of_spec_var)) new_l_args pos;
        x_tinfo_hp (add_str "new_r_args" (pr_list string_of_spec_var)) new_r_args pos;
        x_tinfo_hp (add_str "new_l_holes" (pr_list string_of_int)) new_l_holes pos;
        x_tinfo_hp (add_str "new_r_holes" (pr_list string_of_int)) new_r_holes pos;
        let rem_l_node =
          if (CF.all_hole_vars new_l_args) then HEmp
          else DataNode { dnl with
                          h_formula_data_arguments = new_l_args;
                          h_formula_data_holes = new_l_holes; }
        in
        let rem_r_node =
          if (CF.all_hole_vars new_r_args) then HEmp
          else DataNode { dnr with
                          h_formula_data_arguments = new_r_args;
                          h_formula_data_holes = new_r_holes; }
        in
        x_tinfo_hp (add_str "rem_l_node" (Cprinter.string_of_h_formula)) rem_l_node pos;
        x_tinfo_hp (add_str "rem_r_node" (Cprinter.string_of_h_formula)) rem_r_node pos;
        (* let () = print_string ("\n(andreeac) solver.ml rem_l_node: " ^ (Cprinter.string_of_h_formula rem_l_node)) in *)
        (* let () = print_string ("\n(andreeac) solver.ml rem_r_node: " ^ (Cprinter.string_of_h_formula rem_r_node)) in *)
        (* Filter out variables with @A on either lhs or rhs so that they do not form unnecessary equalities*)
        if (!Globals.allow_field_ann) then
          let lst1 = List.combine l_args l_param_ann in
          let lst2 = List.combine r_args r_param_ann in
          let lst = List.combine lst1 lst2 in
          let new_lst = List.filter (fun (l,r) -> true) (* (fun (l,r) -> if isAccs(snd l) || isAccs(snd r) then false else true) *) lst in (*andreeac tmp disalow filter*)
          let lst1, lst2 = List.split new_lst in
          let new_l_args, new_l_param_ann = List.split lst1 in
          let new_r_args, new_r_param_ann = List.split lst2 in
          x_tinfo_hp (add_str "new_l_args" (pr_list string_of_spec_var)) new_l_args pos;
          x_tinfo_hp (add_str "new_r_args" (pr_list string_of_spec_var)) new_r_args pos;
          x_tinfo_hp (add_str "l_param_ann" (pr_list Cprinter.string_of_imm)) l_param_ann pos;
          x_tinfo_hp (add_str "r_param_ann" (pr_list Cprinter.string_of_imm)) r_param_ann pos;
          (rem_l_node, rem_r_node, new_l_args, new_r_args, new_l_param_ann, new_r_param_ann)
        else (rem_l_node, rem_r_node, l_args, r_args, l_param_ann, r_param_ann)
      (* (rem_l_node,rem_r_node,l_args, r_args, l_param_ann, r_param_ann) *)
      | _ -> (HEmp, HEmp, l_args, r_args, l_param_ann, r_param_ann)
    in (* rem_l_node, rem_r_node, l_args, r_args, l_param_ann, r_param_ann *)
    match rem_r_node with (* Fail whenever the l_node cannot entail r_node *)
    | DataNode _ ->
      let err_msg = "Cannot match LHS node and RHS node" in
      (CF.mkFailCtx_in (Basic_Reason (mkFailContext (* "Cannot match LHS node and RHS node" *) err_msg estate (CF.formula_of_heap HFalse pos) None pos,
                                      CF.mk_failure_must "99" Globals.sl_error, estate.es_trace)) ((convert_to_must_es estate), err_msg, Failure_Must err_msg)  (mk_cex true), NoAlias)
    | _ ->
      (* An Hoa : end added code *)
      let label_list =
        try
          let vdef = x_add Cast.look_up_view_def_raw x_loc prog.prog_view_decls l_node_name in
          vdef.Cast.view_labels
        with Not_found ->
          begin List.map (fun _ -> LO.unlabelled) l_args end
      in

      (*** BEGIN threads as resource *****)
      let label_list, l_args, r_args, (is_thread, is_matched, rs_matched, remained_rsr) =
        do_match_thread_nodes prog estate l_node r_node rhs rhs_matched_set is_folding pos l_args r_args label_list
      in
      if (is_thread && (not is_matched)) then
        match rs_matched with (* EXIT points of do_match *)
        | None -> report_error no_pos "[solver.ml] do_match: expecting some result"
        | Some rs -> rs
      else
        let remained_thread_node =
          if (is_thread && is_matched) then
            (match remained_rsr with
             | None -> CF.HTrue
             | Some f ->
               (* LDK TODO: currently try the first only *)
               let f = List.hd f in
               (match l_node with
                | ThreadNode t -> ThreadNode {t with CF.h_formula_thread_resource = f;}
                | _ -> report_error no_pos "[solver.ml] do_match: expecting a ThreadNode"
               ))
          else CF.HTrue
        in
        (*** END threads as resource *****)
        (* LDK: using fractional permission *)
        (* introduces 1 more spec var       *)
        (* We also need to add 1 more label *)
        (* renamed and instantiate perm var *)
        let evars = estate.es_evars in
        let ivars = estate.es_ivars in
        let expl_vars = estate.es_gen_expl_vars in
        let impl_vars = estate.es_gen_impl_vars in
        let glob_vs = CP.diff_svl r_args (evars@impl_vars@expl_vars) in
        let () = x_tinfo_hp (add_str "evars" !print_svl) evars no_pos in
        let () = x_tinfo_hp (add_str "ivars" !print_svl) ivars no_pos in
        let () = x_tinfo_hp (add_str "expl_vars" !print_svl) expl_vars no_pos in
        let () = x_tinfo_hp (add_str "impl_vars" !print_svl) impl_vars no_pos in
        let () = x_tinfo_hp (add_str "glob_vs" !print_svl) glob_vs no_pos in
        (* existentially matched var need not be placed in subs *)
        let l_args,r_args,label_list =
          if (CP.eq_spec_var lhs_self rhs_self) || not(CP.mem rhs_self impl_vars) then l_args,r_args,label_list
          else lhs_self::l_args, rhs_self::r_args, LO.unlabelled::label_list in
        let () = x_tinfo_hp (add_str "l_args" !print_svl) l_args no_pos in
        let () = x_tinfo_hp (add_str "r_args" !print_svl) r_args no_pos in
        let rho_0, label_list, p_ante, p_conseq =
          x_add do_match_inst_perm_vars l_perm r_perm l_args r_args label_list evars ivars impl_vars expl_vars glob_vs
        in
        let rho =
          try
            List.combine rho_0 label_list
          with _ ->
            let dummy_label = List.map (fun _ -> Cast.LO.unlabelled) rho_0 in
            List.combine rho_0 dummy_label
            (* failwith "rho mismatched label_list" *)
            (* matching with cyclic proof is not the same predicate *)
        in (* with branch label *)
        let evars, ivars, impl_vars, expl_vars =
          do_match_perm_vars l_perm r_perm evars ivars impl_vars expl_vars
        in
        let () =  x_tinfo_hp  (add_str   (" impl_vars: ")  !CP.print_svl )impl_vars no_pos in
        let ((impl_tvars, tmp_ivars, ivar_subs_to_conseq), other_subs) =
          x_add subs_to_inst_vars rho ivars impl_vars pos
        in
        let () = x_dinfo_hp (add_str "other subs"
                               (pr_list (pr_pair ( pr_pair Cprinter.string_of_spec_var Cprinter.string_of_spec_var) pr_none ))) other_subs pos in
        (* BEGIN check_rel_consistency *)
        let rec check_rel_consistency cur_other_subs rels =
          match cur_other_subs with
          | [] -> true, rels
          | ((x,y), _)::tl ->
            let b, new_rels=
              if (CP.is_rel_typ x && CP.is_rel_typ y && not (CP.eq_spec_var x y))
              then
                if (CP.intersect_svl [x;y] estate.es_infer_vars_rel = [])
                then false, []
                else true, (rels@[(y,x)])
              else true, rels
            in
            if not b then false, new_rels
            else check_rel_consistency tl new_rels
        in (* END check_rel_consistency *)
        let b, rels = check_rel_consistency other_subs [] in
        (* check_rel_consistency -> true *)
        if b then
          (* let lrels, rrels = List.split rels in *)
          (* let estate = {estate with CF.es_infer_vars_rel = CP.remove_dups_svl *)
          (*     (estate.CF.es_infer_vars_rel@lrels@rrels)} in *)
          let lp_rels, rp_rels = generate_rels_formulas prog rels pos in
          (* let () =  Debug.info_zprint  (lazy  ("lp_rels: " ^ (!CP.print_formula lp_rels))) no_pos in *)
          (* let () =  Debug.info_zprint  (lazy  ("rp_rels: " ^ (!CP.print_formula rp_rels))) no_pos in *)
          (* let pr = pr_list (pr_pair !CP.print_sv !CP.print_sv) in *)
          (* let () =  Debug.info_zprint  (lazy  ("ivar_subs_to_conseq: " ^ (pr ivar_subs_to_conseq))) no_pos in *)
          (* let () =  Debug.info_zprint  (lazy  ("tmp_ivars: " ^ (!CP.print_svl tmp_ivars))) no_pos in *)
          (* let () =  Debug.info_zprint  (lazy  ("impl_tvars: " ^ (!CP.print_svl impl_tvars))) no_pos in *)
          (* let () =  Debug.info_zprint  (lazy  ("estate.es_gen_expl_vars: " ^ (!CP.print_svl estate.es_gen_expl_vars))) no_pos in *)
          let subtract = Gen.BList.difference_eq CP.eq_spec_var in
          let new_impl_vars = subtract impl_vars impl_tvars in
          let new_exist_vars = evars(* @tmp_ivars *) in
          let new_expl_vars = expl_vars@impl_tvars in
          let new_expl_vars = List.filter (fun sv -> not (CP.is_rel_typ sv)) new_expl_vars in
          let new_ivars = subtract ivars tmp_ivars in
          (* let (expl_inst, tmp_ivars', expl_vars') = (get_eqns_expl_inst rho_0 ivars pos) in *)

          (* to_lhs only contains bindings for free vars                 *)
          (* that are not to be explicitly instantiated                  *)
          (* Only instantiate an RHS impl_var to LHS                     *)
          (*   if it is not matched with an ivar of LHS.                 *)
          (*   if it is matched, it becomes expl_inst in new_expl_ins.   *)
          (* Note: other_subs will never contain any impl_tvars          *)
          (*       because of the pre-processed subs_to_inst_vars        *)
          (* An Hoa : strip all the pair of equality involving # *)
          let () = x_tinfo_hp (add_str "other_subs(b4 filter)" (pr_list (pr_pair (pr_pair Cprinter.string_of_spec_var Cprinter.string_of_spec_var) pr_none) )) other_subs pos in
          let other_subs = List.filter (fun ((x, y), _) ->
              not (CP.is_hole_spec_var x || CP.is_hole_spec_var y) && not (CP.is_rel_typ x)
              (* && not((CP.is_ann_typ y) && (Gen.BList.mem_eq CP.eq_spec_var y estate.es_ante_evars)) *)
            ) other_subs
          in
          (* let pr1 (a,b) = let pr = (pr_pair !CP.print_sv !CP.print_sv) in pr a in *)
          (* let () =  Debug.ninfo_zprint  (lazy  ("other_subs: " ^ (pr_list pr1 other_subs))) no_pos in *)
          let () = x_tinfo_hp (add_str "other_subs" (pr_list (pr_pair (pr_pair Cprinter.string_of_spec_var Cprinter.string_of_spec_var) pr_none) )) other_subs pos in
          (* let () =  Debug.info_zprint  (lazy  ("new_exist_vars: " ^ (!CP.print_svl new_exist_vars))) no_pos in *)
          (* let () =  Debug.info_zprint  (lazy  ("impl_tvars: " ^ (!CP.print_svl impl_tvars))) no_pos in *)
          (* let () =  Debug.info_zprint  (lazy  ("estate.es_gen_expl_vars: " ^ (!CP.print_svl estate.es_gen_expl_vars))) no_pos in *)
          let to_lhs, to_rhs, ext_subst = x_add get_eqns_free other_subs new_exist_vars new_impl_vars (* impl_tvars *) fvars_rhs estate.es_gen_expl_vars pos in
          let ext_subst = ext_subst @ subst in
          (* let is_ann a = CP.is_ann_type (CP.type_of_spec_var a) in *)
          let () =  Debug.ninfo_zprint  (lazy  ("to_lhs: " ^ (!CP.print_formula to_lhs))) no_pos in
          (* let () =  x_tinfo_hp  (add_str  ("ext_subst: "  (pr_pair  ext_subst))) no_pos in *)
          (* Adding pure formula for relational args of view *)
          let to_lhs = CP.mkAnd to_lhs lp_rels no_pos in
          let to_rhs = CP.mkAnd to_rhs rp_rels no_pos in
          let () = x_tinfo_hp (add_str "to_rhs(bef ann)" (Cprinter.string_of_pure_formula)) to_rhs pos in
          let () = x_tinfo_hp (add_str "to_lhs(bef ann)" (Cprinter.string_of_pure_formula)) to_lhs pos in
          let () = x_tinfo_hp (add_str "ext_subst(bef ann)" (pr_list (pr_pair Cprinter.string_of_spec_var Cprinter.string_of_spec_var))) ext_subst pos in
          (* Adding annotation constraints matched *)
          let to_rhs =
            match ann_rhs with
            | None -> to_rhs
            | Some bf -> CP.mkAnd bf to_rhs no_pos in
          let () = x_tinfo_hp (add_str "to_rhs" (Cprinter.string_of_pure_formula)) to_rhs pos in
          (* let () = print_string("cris: to_rhs = " ^
             (Cprinter.string_of_pure_formula to_rhs) ^ "\n") in *)
          let () = x_tinfo_hp (add_str "to_lhs" (Cprinter.string_of_pure_formula)) to_lhs pos in
          let to_lhs =
            match ann_lhs with
            | None -> to_lhs
            | Some bf -> CP.mkAnd bf to_lhs no_pos in
          let () = x_tinfo_hp (add_str "to_lhs" (Cprinter.string_of_pure_formula)) to_lhs pos in
          (* In the presence of ho_arg, r_args is bound with l_args   *)
          (* and is moved inside the binding of high-order argument.  *)
          (* Therefore, if this is a match of 2 high-order view node, *)
          (* the instantiation to_lhs is moved to high-order binding. *)
          (* TODO: consider a general case where we have permissions. *)
          let to_lhs, to_ho_lhs, to_bound =
            if (l_ho_args = []) then (to_lhs, CP.mkTrue no_pos, [])
            else
              let ls = CP.split_conjunctions to_lhs in
              let ls_ho_lhs, ls_lhs = List.partition (fun f ->
                  Gen.BList.intersect_eq CP.eq_spec_var (CP.fv f) l_args != []) ls
              in
              let to_ho_lhs = CP.join_conjunctions ls_ho_lhs in
              let to_lhs = CP.join_conjunctions ls_lhs in
              let to_bound = List.map (fun ((_,v), _) -> v) other_subs in
              (* Only consider variables that have bindings *)
              let bind_fv = CP.fv to_ho_lhs in
              let to_bound = List.filter (fun v -> Gen.BList.mem_eq CP.eq_spec_var v bind_fv) to_bound in
              (to_lhs, to_ho_lhs, to_bound)
          in
          (************************************************************************)
          (* handle both explicit and implicit instantiation                      *)
          (* for the universal vars from universal lemmas,                        *)
          (* we use the explicit instantiation mechanism,                         *)
          (* while, for the rest of the cases, we use implicit instantiation      *)
          (* explicit instantiation is like delaying the movement of the bindings *)
          (* for the free vars from the RHS to the LHS                            *)
          (************************************************************************)
          let new_ante_p = (MCP.memoise_add_pure_N l_p to_lhs) in
          let () = y_tinfo_hp (add_str "new_ante_p" !CP.print_formula)
              (MCP.pure_of_mix new_ante_p) in
          let () = y_tinfo_hp (add_str "to_lhs" !CP.print_formula) to_lhs in
          let () = x_tinfo_hp (add_str "to_rhs, before adding" (Cprinter.string_of_pure_formula)) to_rhs pos in
          let new_conseq_p = (MCP.memoise_add_pure_N r_p to_rhs) in
          (* let () = print_endline ("new_ante_pure = " ^ (Cprinter.string_of_mix_formula new_ante_p)) in     *)
          (* let () = print_endline ("new_conseq_pure = " ^ (Cprinter.string_of_mix_formula new_conseq_p)) in *)
          (* Add instantiation for perm vars *)
          let new_ante_p = (MCP.memoise_add_pure_N new_ante_p p_ante) in
          let () = y_tinfo_hp (add_str "new_ante_p" !CP.print_formula)
              (MCP.pure_of_mix new_ante_p) in
          let new_conseq_p = (MCP.memoise_add_pure_N new_conseq_p p_conseq) in
          (* (i) find Univ in LHS (2) find univ inst in conseq (3) perform univ inst proving *)
          (* ==================== Extract equation expression related to Univ vars ==================== *)
          let pure_new_ante_p = MCP.pure_of_mix new_ante_p in
          let pure_new_conseq_p = MCP.pure_of_mix new_conseq_p in
          let univ_vs = TP.get_univs_from_ante pure_new_ante_p in
          (* eqlst is a list of pair. In each pair, two expressions are equal and one of them contains Univ vars *)
          let () = x_dinfo_hp (add_str "univ_vs" Cprinter.string_of_spec_var_list) univ_vs no_pos in
          let () = y_dinfo_hp (add_str "to_lhs" !CP.print_formula) to_lhs in
          let () = y_dinfo_hp (add_str "to_rhs" !CP.print_formula) to_rhs in
          let () = y_dinfo_hp (add_str "p_ante" !CP.print_formula) p_ante in
          let () = y_tinfo_hp (add_str "pure_new_ante_p" !CP.print_formula) pure_new_ante_p in
          let () = y_dinfo_hp (add_str "pure_new_conseq_p" !CP.print_formula) pure_new_conseq_p in
          let (to_lst,fr_lst) = List.split ivar_subs_to_conseq in
          let pure_new_conseq_p = CP.subst_avoid_capture fr_lst to_lst pure_new_conseq_p in
          let () = y_dinfo_hp (add_str "pure_new_conseq_p (after univ subs)" !CP.print_formula) pure_new_conseq_p in
          let () = y_dinfo_hp (add_str "ext_subst" (pr_list (pr_pair Cprinter.string_of_spec_var Cprinter.string_of_spec_var))) ext_subst in
          let e_subs = ivar_subs_to_conseq @ ext_subst in
          let () = y_tinfo_hp (add_str "e_subs" (pr_list (pr_pair Cprinter.string_of_spec_var Cprinter.string_of_spec_var))) e_subs in
          (* let () = y_tinfo_hp (add_str "to_bound" (!CP.print_svl)) to_bound in *)
          let (conseq_lst_univ,new_conseq_p2) =
            let no_chx = ([],new_conseq_p)in
            if TP.connected_rhs univ_vs pure_new_conseq_p
            then
              let () = y_dinfo_pp "do_match: Processing univ instantiation" in
              let conseq_lst = CP.split_conjunctions pure_new_conseq_p in
              let (conseq_lst_univ,conseq_lst_others) = List.partition (fun f ->
                  let vs = CP.fv f in
                  (CP.intersect_svl vs univ_vs)!=[]
                ) conseq_lst in
              if conseq_lst_univ==[] then no_chx
              else (conseq_lst_univ,MCP.mix_of_pure (CP.join_conjunctions conseq_lst_others))
              (* let eqlst = CP.find_eq_at_toplevel pure_new_conseq_p in *)
              (* let () = y_tinfo_hp (add_str "conseq_lst: " (pr_list !CP.print_formula)) conseq_lst in *)
              (* let () = y_tinfo_hp (add_str "conseq_lst_univ: " (pr_list !CP.print_formula)) conseq_lst_univ in *)
              (* let () = y_tinfo_hp (add_str "conseq_lst_others: " (pr_list !CP.print_formula)) conseq_lst_others in *)
              (* let () = y_tinfo_hp (add_str "elst: " (pr_list (pr_pair !CP.print_exp !CP.print_exp))) eqlst in *)
              (* let eqlst = List.filter (fun (e1,e2) -> (List.length (CP.intersect_svl ((CP.afv e1)@(CP.afv e2)) univ_vs))>0) eqlst in *)
              (* let () = y_tinfo_hp (add_str "elst (filter out): " (pr_list (pr_pair !CP.print_exp !CP.print_exp))) eqlst in *)
              (* eqlst *)
            else
              no_chx
          in
          let l_h = match rem_l_node with
            | HRel _ | HTrue | HFalse | HEmp -> l_h
            | _ -> mkStarH rem_l_node l_h pos in
          (* Add remained resource *)
          let l_h = if (is_thread && is_matched)
            then mkStarH remained_thread_node l_h pos
            else l_h
          in
          (* x_tinfo_hp (add_str "new_ante_p" (Cprinter.string_of_mix_formula)) new_ante_p pos; *)
          x_tinfo_hp (add_str "l_h" (Cprinter.string_of_h_formula)) l_h pos;
          let process_early univ_vs new_ante_p conseq_univ  =
            let () = y_dinfo_pp "TODO: process early univ instantiation" in
            let () = y_dinfo_pp "=========================================" in
            let () = x_dinfo_hp (add_str "univ_vs" Cprinter.string_of_spec_var_list) univ_vs no_pos in
            let () = y_dinfo_hp (add_str "to_lhs" !CP.print_formula) to_lhs in
            let () = y_dinfo_hp (add_str "p_ante" !CP.print_formula) p_ante in
            let () = y_dinfo_hp (add_str "new_ante_p" (Cprinter.string_of_mix_formula)) new_ante_p in
            let () = y_dinfo_hp (add_str "new_conseq_p2" (Cprinter.string_of_mix_formula)) new_conseq_p2 in
            let () = y_dinfo_hp (add_str "conseq_univ" (!CP.print_formula)) conseq_univ in
            let lhs1 = MCP.pure_of_mix new_ante_p in
            let (b,_,_) = TP.imply_timeout_univ univ_vs lhs1 conseq_univ "666" 0.0 None in
            let () = y_dinfo_hp (add_str "outcome" string_of_bool) b in
            if b then
              let r = TP.univ_rhs_store # get_rm in
              let new_ante = CP.mkAnd lhs1 r no_pos in
              (b,MCP.mix_of_pure new_ante)
            else (b,new_ante_p)
            (* failwith ("early univ inst proc here"^x_tbi) *)
          in
          let new_conseq_p,new_ante_p =
            if conseq_lst_univ!=[] then
              let conseq_univ = CP.join_conjunctions conseq_lst_univ in
              let (flag,ante) = process_early univ_vs new_ante_p conseq_univ in
              if flag then (new_conseq_p2,ante)
              else (new_conseq_p,new_ante_p)
            else new_conseq_p,new_ante_p in
          (* An Hoa : put the remain of l_node back to lhs if there is memory remaining after matching *)
          (* let () = print_string("\nl_h : "^(Cprinter.string_of_h_formula l_h)^"\n") in             *)
          (* let () = print_string("rem_l_node : "^(Cprinter.string_of_h_formula rem_l_node)^"\n") in *)
          (* let () = print_string("l_node : "^(Cprinter.string_of_h_formula l_node)^"\n") in         *)
          (* An Hoa : fix new_ante *)
          let new_ante = mkBase l_h new_ante_p l_vp l_t l_fl l_a pos in
          let tmp_conseq = mkBase r_h new_conseq_p r_vp r_t r_fl r_a pos  in
          let () = x_dinfo_hp (add_str "tmp_conseq" (Cprinter.string_of_formula)) tmp_conseq pos in
          let () = x_tinfo_hp (add_str "new_ante 00" (Cprinter.string_of_formula)) new_ante pos in
          let lhs_vars = CP.fv to_lhs in
          (* Apply the new bindings to the consequent *)
          (* let e_subs = ivar_subs_to_conseq @ ext_subst in *)
          (* Do not subst heap relation*)
          let e_subs = List.filter (fun (sv1, sv2) -> (not (CP.is_rel_typ sv1)) && (not(CP.is_rel_typ sv2))) e_subs in
          let () = Debug.ninfo_hprint (add_str "e_subs" (pr_list (pr_pair Cprinter.string_of_spec_var Cprinter.string_of_spec_var))) e_subs pos in
          let r_subs, l_subs = List.split e_subs in
          (* IMPORTANT TODO: global existential not took into consideration *)
          (* let r_subs = List.filter (fun sv -> not (CP.is_rel_typ sv)) r_subs in *)
          (* let l_subs = List.filter (fun sv -> not (CP.is_rel_typ sv)) l_subs in *)
          let () = Debug.ninfo_hprint (add_str "r_subs" Cprinter.string_of_spec_var_list) r_subs pos in
          let () = Debug.ninfo_hprint (add_str "l_subs" Cprinter.string_of_spec_var_list) l_subs pos in
          let () = x_tinfo_zp (lazy ((" tmp_conseq: " ^ (Cprinter.prtt_string_of_formula tmp_conseq)))) no_pos in
          let rhs_eqset = estate.es_rhs_eqset in
          let subs_rhs_eqset =
            if !Globals.allow_imm_subs_rhs then
              subst_eqset e_subs rhs_eqset
            else rhs_eqset in
          let tmp_conseq' = subst_avoid_capture r_subs l_subs tmp_conseq in
          let tmp_h2, tmp_p2, tmp_vp2, tmp_fl2, _, tmp_a2 = split_components tmp_conseq' in
          let new_conseq = mkBase tmp_h2 tmp_p2 tmp_vp2 r_t r_fl tmp_a2 pos in (* conseq after renaming *)
          let () = x_tinfo_zp (lazy ((" new_conseq: " ^ (Cprinter.prtt_string_of_formula new_conseq)))) no_pos in
          (* An Hoa : TODO fix the consumption here - THIS CAUSES THE CONTRADICTION ON LEFT HAND SIDE! *)
          (* only add the consumed node if the node matched on the rhs is mutable *)
          let consumed_h =  (match rem_l_node with
              | HRel _ | HTrue | HFalse | HEmp ->
                (match l_node with
                 | DataNode dnl ->
                   if (!Globals.allow_field_ann) then HEmp
                   (* es_heap is already updated with consumed heap from beginning of do_match: Context.imm_split_lhs_node *)
                   else l_node
                 | ViewNode _ -> if (!Globals.allow_field_ann) then HEmp else l_node
                 | _ -> l_node)
              | _ ->
                (* TO DO: this may not be correct because *)
                (* we may also have to update the holes   *)
                subst_one_by_one_h rho_0 r_node)
          in (* consumed_h *)
          (* let poly_consumes = isPoly r_ann && (isMutable l_ann || isImm l_ann) in *)
          x_tinfo_hp (add_str "r_ann" (Cprinter.string_of_imm)) r_ann pos;
          let new_consumed =
            (* if not(!Globals.allow_imm) && not(!Globals.allow_field_ann) then mkStarH consumed_h estate.es_heap pos *)
            (* else  *)
            (* if (!Globals.allow_imm) && not(!Globals.allow_field_ann) then *)
            if not(!Globals.allow_field_ann) then
              begin
                if (CP.isLend r_ann || CP.isAccs r_ann || (CP.isPoly r_ann (* && (isLend l_ann || isAccs l_ann) *)) (* || (isPoly r_ann && isPoly l_ann) *)) (*&& not(!allow_field_ann)*)
                then estate.es_heap (* do not consume *)
                else mkStarH consumed_h estate.es_heap pos
              end
            else
              (* estate.es_heap *)
              (* if (!Globals.allow_field_ann) then estate.es_heap *)
              (* else *) mkStarH consumed_h estate.es_heap pos
          in
          let n_es_res, n_es_succ = match ((get_node_label l_node), (get_node_label r_node)) with
            | Some s1, Some s2 -> ((Gen.BList.remove_elem_eq (=) s1 estate.es_residue_pts), ((s1,s2)::estate.es_success_pts))
            | None, Some s2 -> (estate.es_residue_pts, estate.es_success_pts)
            | Some s1, None -> ((Gen.BList.remove_elem_eq (=) s1 estate.es_residue_pts), estate.es_success_pts)
            | None, None -> (estate.es_residue_pts, estate.es_success_pts) in
          (* let () = DD.info_pprint ("  new_consumed: " ^ (Cprinter.string_of_h_formula new_consumed)) pos in *)
          (* let () = DD.info_zprint  (lazy  ("  rhs: " ^ (Cprinter.string_of_formula rhs))) pos in *)
          (* let () = DD.info_zprint  (lazy  ("  estate.es_formula: " ^ (Cprinter.string_of_formula estate.es_formula))) pos in *)
          (* let () = DD.info_zprint  (lazy  ("  new_ante: " ^ (Cprinter.string_of_formula new_ante))) pos in *)

          (* ======================================================= *)
          (************ Handle high-order arguments: BEGIN ***********)
          (* ======================================================= *)
          let fail_res, new_ante, new_conseq, new_exist_vars, new_maps =
            if not (node_kind="view" && l_ho_args!=[]) then
              (* If not high-order, do nothing *)
              (None, new_ante, new_conseq, new_exist_vars, [])
            else
              (* DONE: check for (List.length l_ho_args != List.length
                 r_ho_args) in: #ho_args in astsimp *)
              let () = x_binfo_pp "marking" no_pos in
              let l_vdef = x_add Cast.look_up_view_def_raw x_loc prog.prog_view_decls l_node_name in
              let () = x_binfo_pp "marking" no_pos in
              let l_vdef_hvar_split_kinds = List.map (fun (_, _, sk) -> sk) l_vdef.view_ho_vars in
              let r_ho_args = List.map (trans_rflow_formula (subst_avoid_capture r_subs l_subs)) r_ho_args in
              let args = List.combine l_ho_args r_ho_args in
              let args = List.combine args l_vdef_hvar_split_kinds in

              (* For each lhs, rhs, and a kind k, possible situations:                  *)
              (*  - A new mapping: rhs -> lhs                                           *)
              (*  - ho_arg split if k = HO_SPLIT                                        *)
              (*  - ho_arg match, otherwise                                             *)
              (*  Expected return value: A list of                                      *)
              (* (fail_ctx option, ho residue option, pure residue option mapping list) *)
              let match_one_ho_arg_x (((lhs, rhs), k) : (CF.rflow_formula * CF.rflow_formula) * ho_split_kind):
                (((CF.list_context * Prooftracer.proof) option) * (CF.formula option) *
                 (MCP.mix_formula option) * ((CP.spec_var * CF.formula) list)) =
                (* lhs <==> rhs: instantiate any high-order variables in rhs *)
                (* We use flow_ann to decide                     *)
                (* contravariant (-) or covariant (+) entailment *)
                let flow_ann = lhs.CF.rflow_kind in
                let ho_lhs = lhs.CF.rflow_base in
                let ho_rhs = rhs.CF.rflow_base in
                let shvars = CF.extract_single_hvar_f ho_rhs in
                let () = x_tinfo_hp (add_str "single rhs hvar" (pr_option Cprinter.string_of_spec_var))  shvars no_pos in
                let hvars = CF.extract_hvar_f ho_rhs in
                let () = x_tinfo_hp (add_str "hvars" Cprinter.string_of_spec_var_list)  hvars no_pos in
                match shvars with
                | Some v -> (None,None,None,[(v,ho_lhs)])
                | None ->
                  let evars = subtract (new_exist_vars @ new_expl_vars @ new_impl_vars) (CP.fv to_ho_lhs) in
                  let evars = Gen.BList.intersect_eq CP.eq_spec_var evars (CF.fv ho_rhs) in
                  let new_es = CF.empty_es (CF.mkTrueFlow ()) (None,[]) pos in
                  let new_es = { new_es with
                                 es_evars = evars;
                                 es_gen_impl_vars = new_impl_vars @ hvars;
                                 es_unsat_flag = false; }
                  in
                  (* let lhs_lhs = { new_es with es_formula = ho_lhs; } in *)
                  (* let pr = Cprinter.string_of_formula in *)
                  (* let () = x_tinfo_hp (add_str "lhs_lhs" pr) lhs_lhs.es_formula no_pos in *)
                  (* tmp_ho_var is used to capture residue after matching *)
                  let tmp_ho_var, new_es, new_ho_rhs =
                    match hvars with
                    | [] ->
                      begin match k with
                        | HO_SPLIT ->
                          let v = CP.fresh_spec_var (CP.SpecVar (FORM, "V", Unprimed)) in
                          let new_ho_rhs =
                            match ho_rhs with
                            | Base f -> Base { f with formula_base_heap = mkStarH f.formula_base_heap (HVar (v,[])) pos }
                            | Exists f -> Exists { f with formula_exists_heap = mkStarH f.formula_exists_heap (HVar (v,[])) pos }
                            | _ -> failwith "ho arguments: not expecting OR formula"
                          in
                          Some v,
                          { new_es with
                            es_gen_impl_vars = new_es.es_gen_impl_vars @ [v]; },
                          new_ho_rhs
                        | HO_NONE -> None, new_es, ho_rhs
                      end
                    | _ -> None, new_es, ho_rhs
                  in
                  let f_es, f_rhs =
                    match flow_ann with
                    | INFLOW ->
                      (match k with
                       | HO_SPLIT ->
                         let vpl = CF.get_vperm_set ho_lhs in
                         let vpr = CF.get_vperm_set new_ho_rhs in
                         let contra_lhs = CF.write_vperm_set new_ho_rhs vpl in
                         let contra_rhs = CF.write_vperm_set ho_lhs vpr in
                         { new_es with es_formula = contra_lhs; }, contra_rhs
                       | _ -> { new_es with es_formula = new_ho_rhs; }, ho_lhs
                      )
                    | _ -> { new_es with es_formula = ho_lhs; }, new_ho_rhs
                  in
                  let pr = Cprinter.string_of_formula in
                  let () = x_tinfo_hp (add_str "new_ho_lhs" pr) f_es.es_formula no_pos in
                  let () = x_tinfo_hp (add_str "new_ho_rhs" pr) f_rhs no_pos in
                  let f_ctx = x_add elim_unsat_es_now 13 prog (ref 1) f_es in
                  let res_ctx, res_prf =
                    Wrapper.wrap_classic x_loc (Some true) (* exact *)
                      (fun v -> x_add heap_entail_conjunct 20 prog false f_ctx f_rhs [] pos) true
                  in
                  begin match res_ctx with
                    | FailCtx (ft,_,_) ->
                      let ex_msg = match get_final_error res_ctx with Some (s,_,_) -> s | None -> "None??"in
                      let err_str = "matching of ho_args failed ("^ex_msg^")" in
                      let rs = (CF.mkFailCtx_in (Basic_Reason (mkFailContext err_str new_es new_conseq None pos,
                                                               CF.mk_failure_must err_str Globals.sl_error, new_es.es_trace)) ( (convert_to_must_es new_es), err_str, Failure_Must err_str) (mk_cex true), NoAlias)
                      in (Some rs, None, None, [])
                    | SuccCtx cl ->
                      begin match cl with
                        | [] -> (None, None, None, [])
                        | c::_ ->
                          match c with
                          | Ctx es ->
                            let _, p_res, vp_res, _, _, _ = CF.split_components es.es_formula in
                            let p_res_opt =
                              if MCP.isConstMTrue p_res then None
                              else Some p_res
                            in
                            begin match tmp_ho_var with
                              | None -> (None, None, p_res_opt, es.es_ho_vars_map)
                              | Some v ->
                                try
                                  let pr = pr_list (pr_pair Cprinter.string_of_spec_var Cprinter.string_of_formula) in
                                  let () = x_tinfo_hp (add_str "es_ho_vars_map" pr) es.es_ho_vars_map no_pos in
                                  let _, v_binding = List.find (fun (vr, _) -> CP.eq_spec_var v vr) es.es_ho_vars_map in
                                  let v_binding = CF.write_vperm_set v_binding vp_res in
                                  let () = x_tinfo_hp (add_str "v_binding" Cprinter.string_of_formula) v_binding no_pos in
                                  let other_bindings = List.filter (fun (vr, _) -> not (CP.eq_spec_var v vr)) es.es_ho_vars_map in
                                  (None, Some v_binding, p_res_opt, other_bindings)
                                with _ -> (None, None, p_res_opt, es.es_ho_vars_map)
                            end
                          | _ -> (None, None, None, [])
                      end
                  end

              (* if ((List.length hvars) == 0) then                                                                                                       *)
              (*   (* renaming before entailment *)                                                                                                       *)
              (*   (* let lhs = CF.add_pure_formula_to_formula to_ho_lhs lhs in *)                                                                        *)
              (*   (* TOCHECK: current ivars&evars are considered evars *)                                                                                *)
              (*   let evars = subtract (new_exist_vars@new_expl_vars@new_impl_vars) (CP.fv to_ho_lhs)in                                                  *)
              (*   let evars = Gen.BList.intersect_eq CP.eq_spec_var evars (CF.fv rhs) in                                                                 *)
              (*   let es_f = if (Perm.allow_perm ()) then CF.add_mix_formula_to_formula (Perm.full_perm_constraint ()) lhs else lhs in                   *)
              (*   let new_estate = CF.empty_es (CF.mkTrueFlow ()) (None,[]) no_pos in                                                                    *)
              (*   let new_estate = {new_estate with es_formula = es_f; es_evars = evars; es_unsat_flag = false;} in                                      *)
              (*   let new_ctx = elim_unsat_es_now 13 prog (ref 1) new_estate in                                                                          *)
              (*   (* let new_ctx = Ctx (CF.add_to_estate new_estate "matching of ho_args") in *)                                                         *)
              (*   (* let () = print_endline ("Attempt semantic entailment of ho_args") in *)                                                              *)
              (*   let res_ctx, res_prf =                                                                                                                 *)
              (*     match k with                                                                                                                         *)
              (*     | HO_NONE -> Wrapper.wrap_classic (Some true) (fun v -> heap_entail_conjunct 20 prog false new_ctx rhs [] pos) true (* exact *)      *)
              (*     | HO_SPLIT -> Wrapper.wrap_classic (Some false) (fun v -> heap_entail_conjunct 21 prog false new_ctx rhs [] pos) false (* inexact *) *)
              (*   in                                                                                                                                     *)
              (*   (match res_ctx with                                                                                                                    *)
              (*     | SuccCtx(cl) -> (match k with                                                                                                       *)
              (*       | HO_NONE -> [None, None, None]                                                                                                    *)
              (*       | HO_SPLIT ->                                                                                                                      *)
              (*         let formulas = List.map (fun c ->                                                                                                *)
              (*           match c with                                                                                                                   *)
              (*           | Ctx es ->                                                                                                                    *)
              (*             let evars = CP.remove_dups_svl (es.es_ivars @ es.es_evars @ es.es_ante_evars) in                                             *)
              (*             let f = CF.push_exists evars es.es_formula in                                                                                *)
              (*             (* Simplify the remained resources *)                                                                                        *)
              (*             let f = CF.elim_exists f in                                                                                                  *)
              (*             CF.simplify_pure_f f                                                                                                         *)
              (*           | OCtx _ -> report_error no_pos "[solver.ml] do_match: unexpected Octx!"                                                       *)
              (*           ) cl (* End List.map *)                                                                                                        *)
              (*         in                                                                                                                               *)
              (*         (* Temporarily pickup first formula *)                                                                                           *)
              (*         [None, Some (List.hd formulas), None])                                                                                           *)
              (*     | FailCtx _ ->                                                                                                                       *)
              (*       let err_str = "matching of ho_args failed" in                                                                                      *)
              (*       let rs = (CF.mkFailCtx_in (Basic_Reason (mkFailContext err_str new_estate new_conseq None pos,                                     *)
              (*                 CF.mk_failure_must ("105" ^ err_str) Globals.sl_error, new_estate.es_trace)) (mk_cex true), NoAlias) in                  *)
              (*       [Some rs, None, None])                                                                                                             *)
              (* else if ((List.length hvars) == 1) then                                                                                                  *)
              (*   (* One hvar in rhs => bind hvar with lhs *)                                                                                            *)
              (*   (* let vs1 = CF.fv lhs in *)                                                                                                           *)
              (*   (* let vs2 = CP.fv to_ho_lhs in *)                                                                                                     *)
              (*   (* INPORTANT: Assumes lhs does not have global var *)                                                                                  *)
              (*   let pr = Cprinter.string_of_spec_var_list in                                                                                           *)
              (*   (* x_tinfo_hp (add_str "fv(lhs)" pr) vs1 no_pos; *)                                                                            *)
              (*   (* x_tinfo_hp (add_str "fv(ho_inst)" pr) vs2 no_pos; *)                                                                        *)
              (*   x_tinfo_hp (add_str "to_bound" pr) to_bound no_pos;                                                                            *)
              (*   let lhs = push_exists to_bound (CF.add_pure_formula_to_formula to_ho_lhs lhs) in                                                       *)
              (*   [None, None, Some (List.hd hvars, lhs)] (* Bindings hvar in RHS => LHS *)                                                              *)
              (* else report_error no_pos ("do_match: unexpected multiple hvars in rhs")                                                                  *)
              in
              (* End of match_one_ho_arg *)

              let match_one_ho_arg (((lhs, rhs), k) : (CF.rflow_formula * CF.rflow_formula) * ho_split_kind):
                (((CF.list_context * Prooftracer.proof) option) * (CF.formula option) *
                 (MCP.mix_formula option) * ((CP.spec_var * CF.formula) list)) =
                let pr_rflow = Cprinter.string_of_rflow_formula in
                let pr1 = pr_pair (pr_pair pr_rflow pr_rflow) string_of_ho_split_kind in
                let pr3 = pr_option !MCP.print_mix_formula in
                let pr4 = pr_option Cprinter.string_of_formula in
                let pr5 = pr_list (pr_pair Cprinter.string_of_spec_var Cprinter.string_of_formula) in
                let pr2 (_, hor, pur, maps) = pr_triple pr4 pr3 pr5 (hor, pur, maps) in
                Debug.no_1 "match_one_ho_arg" pr1 pr2 match_one_ho_arg_x ((lhs, rhs), k)
              in

              let res = List.map match_one_ho_arg args in
              let failures = List.filter (fun (r, _, _, _) -> r != None) res in
              if (failures != []) then
                (* Failure case *)
                let failure, _, _, _ = (List.hd failures) in
                (failure, new_ante, new_conseq, new_exist_vars, [])
              else
                (* Update new mappings *)
                (* TODO: Check consistency in mappings *)
                let new_maps = List.concat (List.map (fun (_, _, _, m) -> m) res) in
                let residues = List.map (fun (_, m, _, _) -> m) res in
                let pure_residues = List.map (fun (_, _, m, _) -> m) res in
                let new_ante = CF.subst_hvar new_ante new_maps in
                let new_ante = List.fold_left (fun ante pr ->
                    match pr with
                    | None -> ante
                    | Some p -> CF.mkAnd_pure ante p pos) new_ante pure_residues in
                (* Update conseq and evars *)
                let new_conseq = CF.subst_hvar new_conseq new_maps in
                let qvars, new_conseq = CF.split_quantifiers new_conseq in
                let new_exist_vars = Gen.BList.remove_dups_eq CP.eq_spec_var (new_exist_vars @ qvars) in
                (* Check any @split and add to ante *)
                (* return: is_split, new_l_ho_args *)
                let rec check_split ls =
                  (match ls with
                   | [] -> false, []
                   | (residue, arg)::xs ->
                     let flag, result = check_split xs in
                     (match residue with
                      | None -> (flag, arg::result)
                      | Some r ->
                        if (CVP.is_empty_vperm_sets (CF.get_vperm_set r) && ((isConstEmpFormula r) || (isConstTrueFormula2 r)))
                        then (flag, arg::result) (* splitable but empty residue *)
                        else
                          let arg_r = { arg with CF.rflow_base = r; } in
                          (true, arg_r::result)))
                in
                let is_split, new_l_ho_args = check_split (List.combine residues l_ho_args) in
                let new_ante =
                  if (not is_split) then new_ante
                  else
                    (match l_node with
                     | ViewNode t ->
                       let remained_node = ViewNode { t with CF.h_formula_view_ho_arguments = new_l_ho_args; } in
                       normalize_combine_heap new_ante remained_node
                     | _ -> report_error no_pos "[solver.ml] do_match: expecting a ViewNode")
                in
                (None, new_ante, new_conseq, new_exist_vars, new_maps)
          in (* fail_res, new_ante, new_conseq, new_exist_vars, new_maps *)
          (* ================================================== *)
          (*********** Handle high-order argument: END **********)
          (* ================================================== *)
          match fail_res with
          | Some fail -> fail (* finish do_match with a failure *)
          | None ->
            x_tinfo_hp (add_str "consumed_h" (Cprinter.string_of_h_formula)) consumed_h pos;
            x_tinfo_hp (add_str "new_consumed" (Cprinter.string_of_h_formula)) new_consumed pos;
            x_tinfo_hp (add_str "new_ante" (Cprinter.string_of_formula)) new_ante pos;
            x_tinfo_hp (add_str "new_conseq" (Cprinter.string_of_formula)) new_conseq pos;

            let new_es = { estate with
                           es_formula = new_ante;
                           (* add the new vars to be explicitly instantiated *)
                           (* transferring expl_vars' from gen_impl_vars,evars ==> gen_expl_vars *)
                           es_gen_expl_vars = new_expl_vars (* estate.es_gen_expl_vars@expl_vars' *);
                           (* update ivars - basically, those univ vars for which binsings have been found will be removed:
                              for each new binding uvar = x, uvar will be removed from es_ivars and x will be added to the es_expl_vars *)
                           es_gen_impl_vars = subtract new_impl_vars lhs_vars (* Gen.BList.difference_eq CP.eq_spec_var impl_vars (lhs_vars@expl_vars') *);
                           es_evars = List.filter (fun sv -> not (CP.is_rel_typ sv)) new_exist_vars (* Gen.BList.difference_eq CP.eq_spec_var evars expl_vars' *);
                           es_ivars = new_ivars (* tmp_ivars' *);
                           es_heap = new_consumed;
                           es_residue_pts = n_es_res;
                           es_success_pts = n_es_succ;
                           es_rhs_eqset = subs_rhs_eqset;
                           es_ho_vars_map = new_maps @ estate.es_ho_vars_map; }
            in
            x_tinfo_hp (add_str "new_es" (Cprinter.string_of_entail_state)) new_es pos;
            (* An Hoa : trace detected: need to change the left hand side before this point which forces to change the new_ante at an earlier check point *)
            let new_es' = new_es in
            let new_es = pop_exists_estate ivars new_es' in
            let new_ctx = Ctx (CF.add_to_estate new_es "matching of view/node") in
            x_tinfo_zp (lazy ("do_match (after): LHS: "^ (Cprinter.string_of_context new_ctx))) pos;
            x_dinfo_zp (lazy ("do_match (after): RHS:" ^ (Cprinter.string_of_formula new_conseq))) pos;
            (* let () = print_string("cris: new_conseq = " ^ (Cprinter.string_of_formula new_conseq) ^ "\n") in *)
            let new_ctx = x_add_1 Immutable.restore_tmp_ann_ctx new_ctx in
            let res_es1, prf1 =
              if (!Globals.allow_mem) then
                heap_entail_split_rhs prog is_folding new_ctx new_conseq (rhs_matched_set @ [r_var]) pos
              else x_add heap_entail_conjunct 11 prog is_folding new_ctx new_conseq (rhs_matched_set @ [r_var]) pos in
            let res_es1 = x_add Cformula.add_to_subst res_es1 r_subs l_subs in
            let res_es1 = Cformula.add_to_exists_pure res_es1 ann_rhs_ex pos (* in *)
            (* let res_es1 = Immutable.restore_tmp_ann_list_ctx res_es1 *)
            in (res_es1, prf1)
            (* match final_ctx with                                                                                             *)
            (* | SuccCtx(cl) ->                                                                                                 *)
            (*   (* substitute the holes due to the temporary removal of matched immutable nodes *)                             *)
            (*   let () = print_string("asankhs: new_context = " ^ (Cprinter.string_of_list_context final_ctx) ^ "\n") in        *)
            (*   let cl1 = List.map subs_crt_holes_ctx cl in                                                                    *)
            (*   let cl1 = List.map (x_add_1 restore_tmp_ann_ctx) cl1 in                                                                  *)
            (*   let () = print_string("asankhs: after_context = " ^ (Cprinter.string_of_list_context (SuccCtx(cl1))) ^ "\n") in *)
            (*   (SuccCtx(cl1), final_prf)                                                                                      *)
            (* | FailCtx _ -> (final_ctx, final_prf)                                                                            *)
        else (* check_rel_consistency -> false *)
          let err_msg = "Cannot match LHS node and RHS node" in
          (CF.mkFailCtx_in (Basic_Reason (mkFailContext (* "Cannot match LHS node and RHS node" *)err_msg estate (CF.formula_of_heap HFalse pos) None pos,
                                          CF.mk_failure_must "99" Globals.sl_error, estate.es_trace)) ((convert_to_must_es estate), err_msg, Failure_Must err_msg) (mk_cex true), NoAlias)

(* (andreeac) you don't use ctx0, is there any point to have it as a parameter?  *)
and heap_entail_non_empty_rhs_heap_x ?(caller="") ?(cont_act=[]) prog is_folding  ctx0 estate ante conseq lhs_b rhs_b (rhs_h_matched_set:CP.spec_var list) pos : (list_context * proof) =
  x_tinfo_zp (lazy ("heap_entail_conjunct_non_empty_rhs_heap:\ncontext:\n" ^ (Cprinter.string_of_context ctx0)
                    ^ "\nconseq:\n" ^ (Cprinter.string_of_formula conseq))) pos;
  let posib_r_alias = (estate.es_evars @ estate.es_gen_impl_vars @ estate.es_gen_expl_vars) in
  let () = x_tinfo_hp (add_str " ante" Cprinter.prtt_string_of_formula) ante no_pos in
  let () = x_tinfo_hp (add_str " conseq" Cprinter.prtt_string_of_formula) conseq no_pos in
  let () = x_tinfo_hp (add_str " estate.es_rhs_eqset" (pr_list (pr_pair !CP.print_sv !CP.print_sv))) estate.es_rhs_eqset  no_pos in
  let () = x_tinfo_hp (add_str " estate.es_evars" !CP.print_svl) estate.es_evars  no_pos in
  let () = x_tinfo_hp (add_str " state.es_gen_impl_vars" !CP.print_svl) estate.es_gen_impl_vars no_pos in
  let () = x_tinfo_hp (add_str " state.es_gen_expl_vars" !CP.print_svl) estate.es_gen_expl_vars no_pos in
  let lhs_h,lhs_p,_,_,_,_ = CF.extr_formula_base lhs_b in
  let rhs_h,rhs_p,_,_,_,_ = CF.extr_formula_base rhs_b in
  let rhs_lst = split_linear_node_guided ( CP.remove_dups_svl (h_fv lhs_h @ MCP.mfv lhs_p)) rhs_h in
  let rhs_lst = List.map (fun (h1,h2) -> (h1,h2,rhs_p)) rhs_lst in
  let () = x_tinfo_hp (add_str " Aliases" (Cprinter.string_of_list_f Cprinter.string_of_spec_var)) posib_r_alias no_pos in
  let rhs_eqset = (* if !Globals.allow_imm then *)Gen.BList.remove_dups_eq (fun (sv11,sv12) (sv21,sv22) ->
      CP.eq_spec_var sv11 sv21 && CP.eq_spec_var sv12 sv22
    ) estate.es_rhs_eqset
  (* else let eqns = (MCP.ptr_equations_without_null rhs_p) in *)
  (* let () = DD.info_hprint (add_str "rhs_p" Cprinter.string_of_mix_formula) rhs_p no_pos in *)
  (* eqns *)
  in
  (* let () = print_endline "CA:1" in *)
  let () = x_tinfo_hp (add_str " xxxxxxxxxxxxxx1" pr_id) "START"  no_pos in
  (* let () = print_string("\n estate.es_aux_conseq: "^(Cprinter.string_of_pure_formula estate.es_aux_conseq)^"\n") in *)
  let () = x_tinfo_hp (add_str "estate.es_pure" Cprinter.string_of_mix_formula) estate.es_pure  no_pos in
  let () = x_tinfo_hp (add_str "conseq" Cprinter.string_of_formula) conseq  no_pos in
  let () = x_tinfo_hp (add_str "ctx0" Cprinter.string_of_context_short) ctx0  no_pos in
  let () = x_tinfo_hp (add_str "estate.es_folding_conseq_pure " (pr_option Cprinter.string_of_mix_formula)) estate.es_folding_conseq_pure pos in
  let actions,cont_act = match cont_act with
      [] -> (x_add Context.compute_actions prog estate rhs_eqset lhs_h lhs_p rhs_p
               posib_r_alias rhs_lst estate.es_is_normalizing conseq pos,[])
    | (_,a)::lst -> (a,lst)
  in
  let () = x_tinfo_hp (add_str "actions" Context.string_of_action_res) actions  no_pos in
  (* let () = x_tinfo_hp (add_str " xxxxxxxxxxxxxx1" pr_id) "END"  no_pos in *)
  (* !!!!!!!!
     (fun _ _ _ _ _ _ -> process_action_x caller prog estate conseq lhs_b rhs_b a rhs_h_matched_set is_folding pos)
     caller a estate conseq (Base lhs_b) (Base rhs_b)
  *)
  (*check cyclic*)
  let is_cycle,estate = if !Globals.cyc_proof_syn && Context.need_check_cyclic actions then
      let l_emap = Infer.get_eqset (MCP.pure_of_mix lhs_p) in
      let r_emap = CP.EMapSV.mkEmpty in
      let r_eqsetmap = CP.EMapSV.build_eset estate.CF.es_rhs_eqset in
      let lhs_b1, rhs_b1, _,_ = x_add Cfutil.smart_subst_new lhs_b rhs_b [] l_emap r_emap r_eqsetmap [] [] in
      let ante1 = CF.Base lhs_b1 in
      let conseq1 = CF.Base rhs_b1 in
      (* let () = DD.info_hprint (add_str " ante1" Cprinter.prtt_string_of_formula) ante1 no_pos in *)
      (* let () = DD.info_hprint (add_str " conseq1" Cprinter.prtt_string_of_formula) conseq1 no_pos in *)
      let r = x_add Syn_checkeq.check_exists_cyclic_proofs estate (ante1, conseq1) in
      let estate = {estate with CF.es_proof_traces = estate.CF.es_proof_traces@[(ante1, conseq1)]} in
      let () = x_tinfo_hp (add_str "estate1" (Cprinter.string_of_entail_state)) estate pos in
      (r,estate)
    else
      (false, estate)
  in
  if is_cycle then
    (SuccCtx [(Ctx estate)], CyclicProof (ante, conseq))
  else
    let () = x_tinfo_hp (add_str "estate2" (Cprinter.string_of_entail_state)) estate pos in
    x_add (process_action ~caller:(x_loc ^ ":" ^ caller)) 1 cont_act prog estate conseq lhs_b rhs_b actions rhs_h_matched_set is_folding pos

and heap_entail_non_empty_rhs_heap ?(caller="") ?(cont_act=[]) prog is_folding  ctx0 estate ante conseq lhs_b rhs_b (rhs_h_matched_set:CP.spec_var list) pos : (list_context * proof) =
  (*LDK*)
  Debug.no_6  "heap_entail_non_empty_rhs_heap"
    Cprinter.string_of_entail_state(* _short *)
    (add_str "LHS base" Cprinter.string_of_formula_base )
    (add_str "RHS base" Cprinter.string_of_formula_base )
    (add_str "ante    " Cprinter.string_of_formula)
    (add_str "conseq  " Cprinter.string_of_formula)
    (add_str "matched_set" Cprinter.string_of_spec_var_list)
    (pr_pair Cprinter.string_of_list_context string_of_proof)
    (fun _ _ _ _ _ _-> heap_entail_non_empty_rhs_heap_x ~caller:caller ~cont_act:cont_act prog is_folding  ctx0 estate ante conseq lhs_b rhs_b rhs_h_matched_set pos) estate lhs_b rhs_b ante conseq rhs_h_matched_set

(* Debug.loop_3_no "heap_entail_non_empty_rhs_heap" Cprinter.string_of_formula_base Cprinter.string_of_formula *)
(*     Cprinter.string_of_spec_var_list (fun _ -> "?") (fun _ _ _-> heap_entail_non_empty_rhs_heap_x prog is_folding  ctx0 estate ante conseq lhs_b rhs_b rhs_h_matched_set pos) lhs_b conseq rhs_h_matched_set *)

and existential_eliminator_helper prog estate (var_to_fold:Cpure.spec_var) (c2:ident) (v2:Cpure.spec_var list) rhs_p =
  let pr_svl = Cprinter.string_of_spec_var_list in
  let pr p = pr_pair pr_svl (pr_option Cprinter.string_of_pure_formula) p in
  let pr_rhs = Cprinter.string_of_mix_formula in
  let pr_es = Cprinter.string_of_entail_state in
  (*let t (r,_) = not(Gen.BList.list_equiv_eq CP.eq_spec_var (var_to_fold::v2) r) in*)
  Debug.no_5(*_opt t*) "existential_eliminator_helper"
    pr_es
    (add_str "Var2Fold:" Cprinter.string_of_spec_var)
    (add_str "Pred:" pr_id)
    (add_str "SVL:" Cprinter.string_of_spec_var_list)
    (add_str "RHS pure:" pr_rhs)
    pr
    (fun _ _ _ _ _ -> existential_eliminator_helper_x prog estate (var_to_fold:Cpure.spec_var) (c2:ident) (v2:Cpure.spec_var list) rhs_p)
    estate var_to_fold c2 v2 rhs_p

(* this helper does not seem to eliminate anything *)
and existential_eliminator_helper_x prog estate (var_to_fold:Cpure.spec_var) (c2:ident) (v2:Cpure.spec_var list) rhs_p =
  let comparator v1 v2 = (String.compare (Cpure.name_of_spec_var v1) (Cpure.name_of_spec_var v2))==0 in
  let pure =
    (* if (estate.es_imm_pure_stk!=[]) *)
    (* then MCP.pure_of_mix (List.hd estate.es_imm_pure_stk) *)
    (* else  *)
    MCP.pure_of_mix rhs_p in
  let ptr_eq = MCP.ptr_equations_with_null rhs_p in

  (* below are equality in RHS taken away during --imm option *)
  (* let () = print_line "Adding es_rhs_eqset into RHS ptrs" in *)
  let ptr_eq = (* Cprinter.app_sv_print *) ptr_eq@(estate.es_rhs_eqset) in
  let ptr_eq = (List.map (fun c->(c,c)) v2) @ ptr_eq in
  let asets = Csvutil.alias_nth 9 ptr_eq in
  try
    let vdef = look_up_view_def_raw x_loc prog.Cast.prog_view_decls c2 in
    let subs_vars = List.combine vdef.view_vars v2 in
    let sf = (CP.SpecVar (Named vdef.Cast.view_data_name, self, Unprimed)) in
    let subs_vars = (sf,var_to_fold)::subs_vars in
    let vars_of_int = List.fold_left (fun a (c1,c2)-> if (List.exists (comparator c1) vdef.view_case_vars) then  c2::a else a) [] subs_vars in
    let vars_of_int = Gen.BList.intersect_eq comparator estate.es_gen_expl_vars vars_of_int in
    let posib_inst = CP.compute_instantiations pure vars_of_int (CF.fv estate.es_formula) in
    let l_args,pr = List.fold_left (fun (a,p) (c1,c2)->
        if (List.exists (comparator c1) vdef.view_case_vars) then
          let ex_vars = estate.es_evars@estate.es_gen_impl_vars@estate.es_gen_expl_vars in
          if (List.exists (comparator c2) ex_vars) then
            try
              let c21 = List.find (fun c -> not (List.exists (comparator c) (ex_vars) )) (Csvutil.get_aset asets c2) in
              (c21::a,p)
            with
            | Not_found ->
              let _,np = List.find (fun (v,_)-> comparator v c2) posib_inst in
              (c2::a,CP.mkAnd p np no_pos)
          else (c2::a,p)
        else (c2::a,p)
      ) ([],Cpure.mkTrue no_pos) subs_vars in
    (List.rev l_args, Some pr)
  with | Not_found -> (var_to_fold::v2,None)

and inst_before_fold estate rhs_p view_vars =
  let pr_sv = Cprinter.string_of_spec_var in
  let pr_1 = Cprinter.string_of_entail_state in
  let pr_2 = Cprinter.string_of_mix_formula in
  let pr_3 = Gen.Basic.pr_list pr_sv in
  let pr_r = Gen.Basic.pr_triple pr_1 pr_2 (Gen.Basic.pr_list (Gen.Basic.pr_pair pr_sv pr_sv)) in
  Debug.no_3 "inst_before_fold"  pr_1 pr_2 pr_3 pr_r
    (fun _ _ _ -> inst_before_fold_x estate rhs_p view_vars) estate rhs_p view_vars

and inst_before_fold_x estate rhs_p case_vars =
  let lhs_fv = fv estate.es_formula in
  let of_interest = (*case_vars*) estate.es_gen_impl_vars in

  let rec filter b = match (fst b) with
    | CP.Eq (lhs_e, rhs_e, _) ->
      let lfv = CP.afv lhs_e in
      let rfv = CP.afv rhs_e in
      let l_inter = Gen.BList.intersect_eq CP.eq_spec_var lfv of_interest in
      let r_inter = Gen.BList.intersect_eq CP.eq_spec_var rfv of_interest in
      let v_l = l_inter@r_inter in
      let cond =
        let rec prop_e e = match e with
          | CP.Null _ | CP.Var _ | CP.IConst _ | CP.FConst _ | CP.AConst _ | CP.Tsconst _ | CP.InfConst _ | CP.NegInfConst _
          | CP.Bptriple _ (*TOCHECK*)
          | CP.Level _ (*TOCHECK*) -> true
          | CP.Subtract (e1,e2,_) | CP.Mult (e1,e2,_) | CP.Div (e1,e2,_) | CP.Add (e1,e2,_) | CP.Tup2 ((e1,e2),_) -> prop_e e1 && prop_e e2
          | CP.TypeCast (_, e1, _) -> prop_e e1
          | CP.Bag (l,_) | CP.BagUnion (l,_) | CP.BagIntersect (l,_) -> List.for_all prop_e l
          | CP.Max _ | CP.Min _ | CP.BagDiff _ | CP.List _ | CP.ListCons _ | CP.ListHead _
          | CP.ListTail _ | CP.ListLength _ | CP.ListAppend _	| CP.ListReverse _ | CP.ArrayAt _ | CP.Func _
          | CP.Template _ -> false in
        ((List.length v_l)=1) && (Gen.BList.disjoint_eq CP.eq_spec_var lfv rfv)&&
        ((Gen.BList.list_subset_eq CP.eq_spec_var lfv lhs_fv && List.length r_inter == 1 && Gen.BList.list_subset_eq CP.eq_spec_var rfv (r_inter@lhs_fv) && prop_e rhs_e)||
         (Gen.BList.list_subset_eq CP.eq_spec_var rfv lhs_fv && List.length l_inter == 1 && Gen.BList.list_subset_eq CP.eq_spec_var lfv (l_inter@lhs_fv)&& prop_e lhs_e)) in
      if cond then (false,[(b,List.hd v_l)]) (*the bool states if the constraint needs to be moved or not from the RHS*)
      else (true,[])
    | _ -> (true,[])in
  let new_c,to_a = MCP.constraint_collector filter rhs_p in
  let to_a_e,to_a_i = List.partition (fun (_,v)-> List.exists (CP.eq_spec_var v) estate.es_evars ) to_a in
  let to_a_e,rho = List.split (List.map (fun (f,v) ->
      let v1 = CP.fresh_spec_var v in
      (CP.b_subst [(v,v1)] f, (v,v1))) to_a_e) in
  let to_a = (fst (List.split to_a_i))@to_a_e in
  let to_a = MCP.mix_of_pure (CP.conj_of_list (List.map (fun f-> CP.BForm (f,None)) to_a) no_pos) in
  let mv_fv = MCP.mfv to_a in
  let estate1 = {estate with es_formula =
                               normalize_combine estate.es_formula (formula_of_mix_formula to_a no_pos) no_pos;
                             (*es_pure = ((MCP.memoise_add_pure_N (fst estate.es_pure) to_a), snd estate.es_pure);*)
                             (*es_gen_expl_vars = Gen.BList.difference_eq CP.eq_spec_var estate.es_gen_expl_vars mv_fv; *)
                             es_evars = Gen.BList.difference_eq CP.eq_spec_var estate.es_evars mv_fv;
                             es_gen_impl_vars = Gen.BList.difference_eq CP.eq_spec_var estate.es_gen_impl_vars mv_fv;} in
  (estate1,new_c, rho)

and do_fold_w_ctx ?(root_inst=None) fold_ctx prog estate conseq rhs_node vd rhs_rest rhs_b is_folding pos =
  let pr2 x = match x with
    | None -> "None"
    | Some (iv,ivr,f) -> Cprinter.string_of_struc_formula f.view_formula in
  let pr (x,_) = Cprinter.string_of_list_context(* _short *) x in
  let pr1 (conseq, rhs_node, vd ,rhs_rest,rhs_b) =
    ("\n conseq = "^(Cprinter.string_of_formula conseq)
     ^ "\n rhs_node = "^(Cprinter.string_of_h_formula rhs_node)
     ^ "\n vd = "^(pr2 vd)
     ^ "\n rhs_rest = "^(Cprinter.string_of_h_formula rhs_rest)
     ^ "\n rhs_b = "^(Cprinter.string_of_formula_base rhs_b)
     ^ "") in
  Debug.no_3(* _no *)  "do_fold_w_ctx"
    Cprinter.string_of_context
    (* Cprinter.string_of_entail_state *)
    pr1
    string_of_bool
    pr
    (fun _ _ _ -> do_fold_w_ctx_x ~root_inst:root_inst fold_ctx prog estate conseq rhs_node vd rhs_rest rhs_b is_folding pos)
    fold_ctx (* estate  *)(conseq, rhs_node, vd ,rhs_rest,rhs_b) is_folding

(* Debug.loop_3(\* _no *\)  "do_fold_w_ctx" Cprinter.string_of_context Cprinter.string_of_h_formula pr2 pr *)
(*     (fun _ _ _ -> do_fold_w_ctx_x fold_ctx prog estate conseq rhs_node vd rhs_rest rhs_b is_folding pos)  *)
(*     fold_ctx rhs_node vd *)
(*
  ln2 = p2 (node) c2 (name) v2 (arguments) r_rem_brs (remaining branches) r_p_cond (pruning conditions) pos2 (pos)
  resth2 = rhs_h - ln2
  ctx0?
  is_folding?
*)

(*LDK:
  ln2: node to fold

*)
and do_fold_w_ctx_x ?(root_inst=None) fold_ctx prog estate conseq ln2 vd resth2 rhs_b is_folding pos =
  let (ivars,ivars_rel,vd) = match vd with
    | None -> ([],[],None)
    | Some (iv,ivr,f) -> (iv,ivr, Some f) in
  let var_to_fold =
    match ln2 with
    | HRel (hp, e, _) ->  let args = CP.diff_svl (get_all_sv  ln2) [hp] in
      let root, _  = x_add Sautil.find_root prog [hp] args  [] in
      root
    | _ ->  get_node_var ln2 in
  let ctx0 = Ctx estate in
  let rhs_h,rhs_p,rhs_vp,rhs_t,rhs_fl,rhs_a = CF.extr_formula_base rhs_b in
  let () = x_tinfo_hp (add_str "do_fold_w: rhs_b " (Cprinter.string_of_formula_base)) rhs_b pos in
  let () = x_tinfo_hp (add_str "do_fold_w: rhs_p " (Cprinter.string_of_mix_formula)) rhs_p pos in
  let (p2,c2,perm,v2,pid,r_rem_brs,r_p_cond,pos2) =
    match ln2 with
    | DataNode ({ h_formula_data_node = p2;
                  h_formula_data_name = c2;
                  h_formula_data_imm = imm2;
                  h_formula_data_perm = perm;
                  h_formula_data_arguments = v2;
                  h_formula_data_label = pid;
                  h_formula_data_remaining_branches =r_rem_brs;
                  h_formula_data_pruning_conditions = r_p_cond;
                  h_formula_data_pos = pos2})
    | ViewNode ({ h_formula_view_node = p2;
                  h_formula_view_name = c2;
                  h_formula_view_imm = imm2;
                  h_formula_view_perm = perm; (*LDK*)
                  h_formula_view_arguments = v2;
                  h_formula_view_label = pid;
                  h_formula_view_remaining_branches = r_rem_brs;
                  h_formula_view_pruning_conditions = r_p_cond;
                  h_formula_view_pos = pos2}) -> (p2,c2,perm,v2,pid,r_rem_brs,r_p_cond,pos2)
    | _ -> report_error no_pos ("do_fold_w_ctx: data/view expected but instead ln2 is "^(Cprinter.string_of_h_formula ln2) ) in
  (* let () = print_string("in do_fold\n") in *)
  let original2 = if (is_view ln2) then (get_view_original ln2) else true in
  let unfold_num = (get_view_unfold_num ln2) in
  let folding_conseq_pure = match estate.es_folding_conseq_pure with
    | Some _ -> estate.es_folding_conseq_pure
    | None -> Some (rhs_p)
  in
  let estate = estate_of_context fold_ctx pos2 in
  let () = x_tinfo_zp (lazy ("estate_of_context fold_ctx: es_pure: " ^(Cprinter.string_of_mix_formula estate.es_pure))) pos in
  let () = Debug.tinfo_hprint (add_str "estate (from fctx):" (Cprinter.string_of_entail_state)) estate pos in
  (*TO CHECK: what for ??? instantiate before folding*)
  (*  let estate,rhs_p,rho = inst_before_fold estate rhs_p [] in*)
  let (new_v2,case_inst) = existential_eliminator_helper prog estate (var_to_fold:Cpure.spec_var) (c2:ident) (v2:Cpure.spec_var list) rhs_p in
  let view_to_fold = ViewNode ({
      h_formula_view_node = List.hd new_v2 (*var_to_fold*);
      h_formula_view_name = c2;
      h_formula_view_derv = get_view_derv ln2;
      h_formula_view_split = get_view_split ln2;
      h_formula_view_imm = get_view_imm ln2;
      h_formula_view_original = original2;
      h_formula_view_unfold_num = unfold_num;
      h_formula_view_perm = perm; (*LDK*)
      h_formula_view_ho_arguments = []; (* TODO:HO *)
      h_formula_view_arguments = List.tl new_v2;
      h_formula_view_annot_arg = get_node_annot_args_w_pos ln2;
      h_formula_view_args_orig = get_node_args_orig_w_pos ln2;
      h_formula_view_modes = get_view_modes ln2;
      h_formula_view_coercible = true;
      h_formula_view_lhs_case = false;
      h_formula_view_origins = get_view_origins ln2;
      h_formula_view_label = pid;           (*TODO: the other alternative is to use none*)
      h_formula_view_remaining_branches = r_rem_brs;
      h_formula_view_pruning_conditions = r_p_cond;
      h_formula_view_pos = pos2}) in
  (*instantiation before the fold operation,
    for existential vars:
    rho = [b->b1]
    forall b1. D[a] & b1=a+1
    |- \rho x::lseg<b,..> & P & b=a+1
    ----------------------------------------------------
    D[a] |- ex b: x::lseg<b,..> & P & b=a+1
    for implicits:
    D[a] & b=a+1 |- x::lseg<b,..> & P
    ---------------------------------------
    D[a] |- exI b: x::lseg<b,..> & P & b=a+1

    inst_before_fold returns the new entail state with the instantiation already moved
    the remaining rhs pure, and a set of substitutions to be applied to the view node and the remaining conseq
    posib_inst is the list of view args that are case vars
  *)
  (*let view_to_fold = CF.h_subst rho view_to_fold in*)
  (*add rhs_p in case we need to propagate some pure constraints into folded view*)
  let () = rhs_rest_emp := resth2=HEmp in
  let () = x_tinfo_hp (add_str "do_fold_w: rhs_p 2 " (Cprinter.string_of_mix_formula)) rhs_p pos in
  let () = x_tinfo_hp (add_str "is_folding " (string_of_bool)) is_folding pos in
  let () = x_tinfo_hp (add_str "folding_conseq_pure" (pr_option Cprinter.string_of_mix_formula)) folding_conseq_pure pos in
  let () = x_tinfo_hp (add_str "estate.es_folding_conseq_pure " (pr_option Cprinter.string_of_mix_formula)) estate.es_folding_conseq_pure pos in
  let estate =  {estate with es_folding_conseq_pure = folding_conseq_pure} in
  let () = x_tinfo_zp (lazy ("before fold_op_init: es.es_pure: " ^(Cprinter.string_of_mix_formula estate.es_pure))) pos in
  let fold_rs, fold_prf = x_add (fold_op_init ~root_inst:root_inst)  prog (Ctx estate) view_to_fold vd rhs_p (* false *) case_inst pos in
  let () = Debug.ninfo_hprint (add_str "do_fold_w: rhs_p 3 " (Cprinter.string_of_mix_formula)) rhs_p pos in
  let () = rhs_rest_emp := true in
  if not (CF.isFailCtx fold_rs) then
    let b = { formula_base_heap = resth2;
              formula_base_pure = rhs_p;
              formula_base_vperm = rhs_vp;
              formula_base_type = rhs_t;
              formula_base_and = rhs_a; (*TO CHECK: ???*)
              formula_base_flow = rhs_fl;
              formula_base_label = None;
              formula_base_pos = pos } in

    let perms =
      if (Perm.allow_perm ()) then
        get_cperm_var perm
      else []
    in
    let () = x_tinfo_hp (add_str "do_fold_w_ctx lc:" (Cprinter.string_of_list_context)) fold_rs pos in
    (*add permission vars if applicable*)
    let tmp, tmp_prf = process_fold_result (ivars,ivars_rel) prog is_folding estate fold_rs p2 (perms@v2) b pos in
    let prf = mkFold ctx0 conseq p2 fold_prf tmp_prf in
    (tmp, prf)
  else begin
    unable_to_fold_rhs_heap := true;
    x_dinfo_zp (lazy ("heap_entail_non_empty_rhs_heap: unable to fold:\n" ^ (Cprinter.string_of_context ctx0) ^ "\n to:ln2: "^ (Cprinter.string_of_h_formula ln2)
                      ^ "\nrhs_p: "^ (Cprinter.string_of_mix_formula rhs_p) ^"..end")) pos;
    (fold_rs, fold_prf)
  end

(*let (mix_lf,bl,lsvl,mem_lf) = x_add xpure_heap _symbolic prog lhs_b.formula_base_heap 0 in*)
and combine_results_x ((res_es1,prf1): list_context * Prooftracer.proof)
    ((res_es2,prf2): list_context * Prooftracer.proof) : list_context * Prooftracer.proof =
  let prf = Search [prf1; prf2] in
  let res = (fold_context_left 13 [res_es1;res_es2]) in
  (* this is a union *)
  (*let () = print_string ("\nmatch "^(string_of_bool(isFailCtx res_es1))^
    "\n coerc: "^(string_of_bool(isFailCtx res_es2))^"\n result :"^
    (string_of_bool(isFailCtx res_es1))^"\n") in*)
  let prf = match isFailCtx res_es1, isFailCtx res_es2 with
    | true,true -> prf
    | true,false -> prf2
    | false ,true -> prf1
    | false , false -> prf in
  (res,prf)

and combine_results ((res_es1,prf1): list_context * Prooftracer.proof)
    ((res_es2,prf2): list_context * Prooftracer.proof) : list_context * Prooftracer.proof =
  let length_ctx ctx = match ctx with
    | CF.FailCtx _ -> 0
    | CF.SuccCtx ctx0 -> List.length ctx0 in
  let pr x = "\nctx length:" ^ (string_of_int (length_ctx (fst x))) ^ " \n Context:"^ Cprinter.string_of_list_context_short (fst x) (* ^ "\n Proof: " ^ (Prooftracer.string_of_proof (snd x)) *) in
  (*let pr3 = Cprinter.string_of_spec_var_list in*)
  Debug.no_2 "combine_results" pr pr pr (fun _ _ -> combine_results_x (res_es1,prf1) (res_es2,prf2)) (res_es1,prf1) (res_es2,prf2)

and do_fold ?(root_inst=None) prog vd estate conseq rhs_node rhs_rest rhs_b is_folding pos =
  let pr1 = pr_option (pr_triple  !CP.print_svl !CP.print_svl Cprinter.string_of_view_decl_short) in
  let pr2 (cl,_) = Cprinter.string_of_list_context cl in
  let pr3 = add_str "conseq" !CF.print_formula in
  let pr4 = (add_str "rhs_b" Cprinter.string_of_formula_base) in
  let pr_es = Cprinter.string_of_entail_state(* _short *) in
  Debug.no_4 "do_fold0" pr_es pr1 pr3 pr4 pr2
    (fun _ _ _ _ -> do_fold_x ~root_inst:root_inst prog vd estate conseq rhs_node rhs_rest rhs_b is_folding pos) estate vd conseq rhs_b

and do_fold_x ?(root_inst=None) prog vd estate conseq rhs_node rhs_rest rhs_b is_folding pos =
  let fold_ctx = Ctx { estate with
                       (* without unsat_flag reset:
                          error at: imm/kara-tight.ss karatsuba_mult
                       *)
                       es_unsat_flag  = false;
                       es_ivars  = []; (* WN : Why do we disallow inference inside fole? *)
                       es_pp_subst = [];
                       es_arith_subst = [];
                       es_cont = [];
                       es_crt_holes = [];
                       es_hole_stk = [];
                       es_aux_xpure_1 = MCP.mkMTrue pos;
                       es_subst = ([], []);
                       es_aux_conseq = CP.mkTrue pos;
                       es_must_error = None;
                     } in
  let () = Debug.ninfo_hprint (add_str "do_fold: rhs_b " (Cprinter.string_of_formula_base)) rhs_b pos in
  x_add (do_fold_w_ctx ~root_inst:root_inst) fold_ctx prog estate conseq rhs_node vd rhs_rest rhs_b is_folding pos

(* assumes coer is a right lemma *)
and vdef_fold_right_lemma coer  =
  if coer.coercion_case == Simple then coer.coercion_fold_def # get
  else None

(* WN/Trung : to revise this into a right lemma with fold operation *)
and do_right_lemma_w_fold coer prog estate conseq rhs_node rhs_rest rhs_b is_folding pos =
  let (_ ,iv,ivr) = Infer.remove_infer_vars_all estate (* rt *)in
  let vd = (vdef_fold_right_lemma coer) in
  let (cl,prf) =
    match vd with
    (* CF.mk_failure_must "99" Globals.sl_error)), NoAlias) *)
    | None ->
      let err_msg = " 99 WARNING : no fold_def for right lemma" in
      (CF.mkFailCtx_in
         (Basic_Reason (mkFailContext err_msg estate (CF.formula_of_heap HFalse pos) None pos,
                        CF.mk_failure_must err_msg Globals.sl_error,
                        estate.es_trace)) ((convert_to_must_es estate), err_msg,
                                           Failure_Must err_msg) (mk_cex true),
       NoAlias)
    | Some vd ->
      do_fold prog (Some (iv,ivr,vd)) estate conseq rhs_node rhs_rest rhs_b is_folding pos
  in  ((* Infer.restore_infer_vars iv  *)cl,prf)

and do_base_fold_hp_rel_x prog estate pos hp vs
    conseq rhs_node rhs_rest rhs_b is_folding iv ivr=
  let ivs = estate.es_infer_vars_hp_rel in
  if not (CP.mem_svl hp ivs) || List.length vs <= 1 then
    let msg = "do_base_fold_hp_rel"^((pr_pair !CP.print_sv !CP.print_svl) (hp,vs)) in
    (Errctx.mkFailCtx_may x_loc msg estate pos,Unknown)
  else
    let knd = CP.RelAssume [hp] in
    let es_cond_path = CF.get_es_cond_path estate in
    let matched_svl = [] in
    let grd = None in
    let lhs_p = CP.gen_cl_eqs pos (CP.remove_dups_svl vs) (CP.mkTrue pos) in
    let lhs = CF.formula_of_pure_formula lhs_p pos in
    let rhs = CF.formula_of_heap (CF.HRel (hp,List.map (fun sv -> CP.Var (sv, pos)) vs,pos)) pos in
    let hp_rel = CF.mkHprel ~fold_type:true knd [] [] matched_svl lhs grd rhs es_cond_path in
    if !Globals.old_infer_hp_collect then
      begin
        x_winfo_hp (add_str "HPRelInferred"
                      (pr_list_ln Cprinter.string_of_hprel_short)) [hp_rel]
          no_pos;
        let () = Infer.rel_ass_stk # push_list ([hp_rel]) in
        let () = Log.current_hprel_ass_stk # push_list ([hp_rel]) in
        ()
      end;
    let () = estate.CF.es_infer_hp_rel # push_list_loc x_loc [hp_rel] in
    let vdecl = Cast.mk_view_decl_for_hp_rel (CP.name_of_spec_var hp)
        (List.map (fun sv -> (sv, NI)) (List.tl vs)) false pos in
    let vdecl_w_def = {vdecl
                       with Cast.view_formula = CF.struc_formula_of_formula lhs pos;
                            Cast.view_un_struc_formula = [(lhs, (fresh_int (),""))];
                      } in
    let rhs_node1 = CF.mkViewNode (List.hd vs) (CP.name_of_spec_var hp) (List.tl vs) pos in
    x_add do_fold prog (Some (iv,ivr,vdecl_w_def)) estate conseq rhs_node1
      rhs_rest rhs_b is_folding pos

and do_base_fold_hp_rel prog estate pos hp vs conseq rhs_node rhs_rest rhs_b
  is_folding iv ivr =
  let pr1 x = Cprinter.string_of_list_context_short (fst x) in
  Debug.no_3 "do_base_fold_hp_rel"
    Cprinter.string_of_entail_state !CP.print_sv !CP.print_svl pr1
    (fun _ _ _ -> do_base_fold_hp_rel_x prog estate pos hp vs
        conseq rhs_node rhs_rest rhs_b is_folding iv ivr) estate hp vs

(* incr/ex17i5.slk failed if ivr removed from estate *)
and do_base_fold_x prog estate conseq rhs_node rhs_rest rhs_b is_folding pos=
  let (_,iv,ivr) = Infer.remove_infer_vars_all estate (* rt *)in
  match rhs_node with
  | HRel (hp,args,_) ->
    (* hp in ivr *)
    if CF.is_exists_hp_rel hp estate then
      let vs = List.map CP.exp_to_sv args in
      do_base_fold_hp_rel prog estate pos hp vs conseq rhs_node rhs_rest rhs_b is_folding iv ivr
    else
      let msg = "BaseCaseFold on Unknown Pred (not on inferred list)" in
      (Errctx.mkFailCtx_may x_loc msg estate pos,Unknown)
  | _ ->
    let vd = (vdef_fold_use_bc prog rhs_node) in
    let (cl,prf) =
      match vd with
      | None ->
        let err_msg =  "No base-case for folding"  in
        (Errctx.mkFailCtx_must x_loc err_msg estate pos,NoAlias)
      | Some vd ->
        (* WN->Loc : this caused failure for cll-d.slk *)
        let r = x_add do_fold prog (Some (iv,ivr,vd)) estate conseq rhs_node
            rhs_rest rhs_b is_folding pos in
        r
    in  (cl,prf)

and do_base_fold prog estate conseq rhs_node rhs_rest rhs_b is_folding pos=
  let pr2 x = Cprinter.string_of_list_context_short (fst x) in
  Debug.no_2 "do_base_fold"
    Cprinter.string_of_entail_state Cprinter.string_of_formula pr2
    (fun _ _ -> do_base_fold_x prog estate conseq rhs_node rhs_rest rhs_b
        is_folding pos) estate conseq

and do_full_fold_x ?(root_inst=None) prog estate conseq rhs_node rhs_rest rhs_b
  is_folding pos =
  do_fold ~root_inst:root_inst prog None estate conseq rhs_node rhs_rest rhs_b is_folding pos

and do_full_fold ?(root_inst=None) prog estate conseq rhs_node rhs_rest rhs_b
  is_folding pos =
  let pr1 = Cprinter.string_of_h_formula in
  let pr2 x = Cprinter.string_of_list_context (fst x) in
  Debug.no_2 "do_full_fold" Cprinter.string_of_entail_state pr1 pr2
    (fun _ _ -> do_full_fold_x ~root_inst:root_inst prog estate conseq rhs_node
        rhs_rest rhs_b is_folding pos) estate rhs_node

and vdef_of_acc_fold_x (vd: view_decl) (base_f: CF.formula)
    (induct_f: CF.formula) (fold_seq : Acc_fold.fold_type list)
  : view_decl =
  let rec apply_fold_seq f vd base_f induct_f fold_seq : CF.formula = (
    match fold_seq with
    | [] -> f
    | hd::tl ->
      let new_f = (
        if (hd = Acc_fold.Fold_base_case) then
          Acc_fold.try_fold_once f vd base_f
        else Acc_fold.try_fold_once f vd induct_f
      ) in
      apply_fold_seq new_f vd base_f induct_f tl
  ) in
  let root_f, fold_seq = (match fold_seq with
      | [] -> report_error no_pos "vdef_of_acc_fold: fold_seq is empty"
      | hd::tl ->
        let f = if (hd = Acc_fold.Fold_base_case) then base_f
          else induct_f in
        (f, tl)
    ) in
  let fold_f = apply_fold_seq root_f vd base_f induct_f fold_seq in
  let view_form = CF.formula_to_struc_formula fold_f in
  { vd with view_formula = view_form;
            view_un_struc_formula = [];
            view_kind = View_DERV }

and vdef_of_acc_fold (vd: view_decl) (base_f: CF.formula)
    (induct_f: CF.formula) (fold_seq : Acc_fold.fold_type list)
  : view_decl =
  let pr_vd = !print_view_decl in
  let pr_fold_seq = pr_list Acc_fold.print_fold_type in
  let pr_out = pr_vd in
  Debug.no_2 "vdef_of_acc_fold" pr_vd pr_fold_seq pr_out
    (fun _ _ -> vdef_of_acc_fold_x vd base_f induct_f fold_seq)
    vd fold_seq

and do_acc_fold_x prog estate conseq rhs_node rhs_rest rhs_b fold_seq is_folding pos
  : (CF.list_context * Prooftracer.proof) =
  Debug.ninfo_hprint (add_str "rhs_node" !CF.print_h_formula) rhs_node pos;
  Debug.ninfo_hprint (add_str "rhs_rest" !CF.print_h_formula) rhs_rest pos;
  Debug.ninfo_hprint (add_str "rhs_b" !CF.print_formula_base) rhs_b pos;
  let vname = (match rhs_node with
      | CF.ViewNode vn -> vn.CF.h_formula_view_name
      | _ ->
        let msg = "do_acc_fold: expect rhs_node is a view node but found: "
                  ^ (!CF.print_h_formula rhs_node) ^ "\n" in
        report_error no_pos msg
    ) in
  let vd = (
    try look_up_view_def_raw x_loc prog.Cast.prog_view_decls vname
    with Not_found ->
      let msg = "do_acc_fold: view def not found: " ^ vname ^"\n" in
      report_error no_pos msg
  ) in
  (* create a new view to do fold *)
  let induct_cases, base_cases = List.partition(fun (f, _) ->
      let hviews = CF.get_views f in
      List.exists (fun hv ->
          String.compare hv.CF.h_formula_view_name vname = 0
        ) hviews
    ) vd.C.view_un_struc_formula in
  if (List.length base_cases != 1) || (List.length induct_cases != 1) then
    let msg = "do_acc_fold: expect view has 1 base case and 1 inductive case"
              ^ " but found: " ^ (!C.print_view_decl vd) ^ "\n" in
    report_error no_pos msg
  else (
    let base_f = fst (List.hd base_cases) in
    let induct_f = fst (List.hd induct_cases) in
    let new_vd = vdef_of_acc_fold vd base_f induct_f fold_seq in
    let vd = Some ([],[],new_vd) in
    let rhs_p = MCP.pure_of_mix (rhs_b.CF.formula_base_pure) in
    Debug.ninfo_hprint (add_str "rhs_p" !CF.print_pure_f) rhs_p no_pos;
    let fold_ctx = Ctx { estate with
                         (* without unsat_flag reset:
                            error at: imm/kara-tight.ss karatsuba_mult
                         *)
                         es_unsat_flag  = false;
                         es_ivars  = [];
                         es_pp_subst = [];
                         es_arith_subst = [];
                         es_cont = [];
                         es_crt_holes = [];
                         es_hole_stk = [];
                         es_aux_xpure_1 = MCP.mkMTrue pos;
                         es_subst = ([], []);
                         es_aux_conseq = rhs_p;
                         es_must_error = None;
                       } in
    x_add do_fold_w_ctx fold_ctx prog estate conseq rhs_node vd rhs_rest rhs_b is_folding pos
  )

and do_acc_fold prog estate conseq rhs_node rhs_rest rhs_b fold_seq is_folding pos
  : (CF.list_context * Prooftracer.proof) =
  let pr_es = Cprinter.string_of_entail_state in
  let pr_hf = Cprinter.string_of_h_formula in
  let pr_base = Cprinter.string_of_formula_base in
  let pr_fold_seq = pr_list Acc_fold.print_fold_type in
  let pr_out x = Cprinter.string_of_list_context (fst x) in
  Debug.no_4 "do_acc_fold" pr_es pr_hf pr_base pr_fold_seq pr_out
    (fun _ _ _ _ -> do_acc_fold_x prog estate conseq rhs_node rhs_rest rhs_b
        fold_seq is_folding pos) estate rhs_node rhs_b fold_seq

and do_seg_fold_x prog estate ante conseq lhs_node rhs_node rhs_rest
    lhs_b rhs_b fold_seg_type is_folding rhs_h_matched_set pos
  : (CF.list_context * Prooftracer.proof) =
  let construct_unknown_res () =
    let s = "seg_fold: not handle yet" in
    let res = (CF.mkFailCtx_in
                 (Basic_Reason (mkFailContext s estate (Base rhs_b) None pos,
                                CF.mk_failure_may ("Nothing_to_do? "^s)
                                  Globals.sl_error, estate.es_trace))
                 ((convert_to_may_es estate), s, Failure_May s) (mk_cex true),
               Unknown) in
    res
  in
  let () = assert (fold_seg_type >= 0) in
  let is_ok, n_conseq, n_rhs_b, n_rhs_eqset = match fold_seg_type with
    | 0 -> begin
        match lhs_node,rhs_node with
        | ViewNode lvn, ViewNode rvn ->
          (* unfold rhs *)
          let is_ok,n_conseq, n_lhs_b = x_add Cfutil.seg_fold_view2 prog lvn rvn conseq rhs_b in
          let res_ok = if is_ok then 1 else -1 in
          (res_ok,n_conseq, n_lhs_b,[])
        | _ -> (-1, conseq, rhs_b,[])
      end
    | 1 -> begin
        match lhs_node,rhs_node with
        | DataNode ldn, ViewNode rvn ->
          (* unfold rhs *)
          Cfutil.seg_fold_view_br prog ldn rvn ante conseq rhs_b
        | _ -> (-1, conseq, rhs_b,[])
      end
    | _ -> (-1, conseq, rhs_b,[])
  in
  match is_ok with
  | 0  -> construct_unknown_res ()
  | 1 ->
    let es0 = {estate with es_rhs_eqset = estate.es_rhs_eqset@n_rhs_eqset;
                           es_evars = estate.es_evars@(List.map fst n_rhs_eqset)
              } in
    let ctx0 = Ctx es0 in
    let rest_rs, prf = x_add heap_entail_one_context 1 prog is_folding ctx0
        n_conseq None None None pos in
    rest_rs, prf
  | _ ->  construct_unknown_res ()

and do_seg_fold prog estate ante conseq lhs_node rhs_node rhs_rest lhs_b rhs_b
  fold_seg_type is_folding rhs_h_matched_set pos
  : (CF.list_context * Prooftracer.proof) =
  let pr_es = Cprinter.string_of_entail_state in
  let pr_hf = Cprinter.string_of_h_formula in
  let pr_base = Cprinter.string_of_formula_base in
  let pr_fold_seq = string_of_int in
  let pr_out (lc,_) = Cprinter.string_of_list_context lc in
  Debug.no_5 "do_seg_fold" pr_es pr_hf pr_hf pr_base pr_fold_seq pr_out
    (fun _ _ _ _ _ -> do_seg_fold_x prog estate ante conseq lhs_node rhs_node
        rhs_rest lhs_b rhs_b fold_seg_type is_folding rhs_h_matched_set pos)
    estate lhs_node rhs_node rhs_b fold_seg_type

and push_hole_action_x a1 r1=
  match Context.action_get_holes a1 with
  | None -> (Debug.ninfo_pprint "NoHoles" no_pos; r1)
  | Some h ->
    (Debug.ninfo_pprint "YesHoles" no_pos;
     push_crt_holes_list_ctx r1 h)

and push_hole_action a1 r1 =
  Debug.no_1 "push_hole_action" pr_no pr_no
    (fun _ -> push_hole_action_x a1 r1) a1

and advance_unfold_struc prog (ctx:context) (conseq:struc_formula) :
  (Context.action_wt) list =
  let rec get_disj_struc f = match f with
    | EBase e -> CF.split_conjuncts e.formula_struc_base
    | EList b -> fold_l_snd get_disj_struc b
    | _ -> [] in
  advance_unfold prog ctx (get_disj_struc conseq)

and advance_unfold prog (ctx:context) (conseq:formula list) : (Context.action_wt) list =
  let pr1 = Cprinter.string_of_context_short in
  let pr2 = pr_list (Context.string_of_action_wt_res)  in
  let p0 fl = (string_of_int (List.length fl)) ^ (pr_list Cprinter.string_of_formula fl) in
  Debug.no_2 "advance_unfold" pr1 p0 pr2 (fun _ _ ->
      advance_unfold_x prog ctx conseq) ctx conseq

and advance_unfold_x prog (ctx:context) (conseq:formula list) :
  (Context.action_wt) list =
  let r = conseq in
  if (List.length r)<=1 then []
  else
    match ctx with
    | OCtx _ ->  Error.report_error { Error.error_loc = no_pos;
                                      Error.error_text = "advance_unfold : OCtx unexpected" }
    | Ctx es ->
      let a = List.map (comp_act prog es) r in
      let a = List.map Context.pick_unfold_only a in
      (* WN:BUG FIX? : change from _ to a *)
      List.concat a

and comp_act prog (estate:entail_state) (rhs:formula) : (Context.action_wt) =
  let pr1 es = Cprinter.string_of_formula es.es_formula in
  let pr2 = Cprinter.string_of_formula in
  let pr3 = Context.string_of_action_wt_res in
  Debug.no_2 "comp_act" pr1 pr2 pr3 (fun _ _ -> comp_act_x prog estate rhs) estate rhs

and comp_act_x prog (estate:entail_state) (rhs:formula) : (Context.action_wt) =
  let rhs_b = extr_rhs_b rhs in
  let lhs_b = extr_lhs_b estate in
  let lhs_h,lhs_p,_,_,_,_ = extr_formula_base lhs_b in
  let rhs_h,rhs_p,_,_,_,_ = extr_formula_base rhs_b in
  let rhs_lst = split_linear_node_guided (CP.remove_dups_svl (h_fv lhs_h @ MCP.mfv lhs_p)) rhs_h in
  let rhs_lst = List.map (fun (h1,h2) -> (h1,h2,rhs_p)) rhs_lst in
  let posib_r_alias = (estate.es_evars @ estate.es_gen_impl_vars @ estate.es_gen_expl_vars) in
  let rhs_eqset = estate.es_rhs_eqset in
  let () = x_tinfo_hp (add_str " xxxxxxxxxxxxxx2" pr_id) "START"  no_pos in
  let actions = x_add Context.compute_actions prog estate rhs_eqset lhs_h lhs_p rhs_p
      posib_r_alias rhs_lst  estate.es_is_normalizing rhs no_pos in
  let () = x_tinfo_hp (add_str " xxxxxxxxxxxxxx2" pr_id) "END"  no_pos in
  (0, actions)

and process_unfold_x prog estate conseq a is_folding pos has_post pid =
  match a with
  | Context.M_unfold ({Context.match_res_lhs_node=lhs_node},unfold_num) ->
    let lhs_var = get_node_var lhs_node in
    let delta1,_ = unfold_nth 1 (prog,None) estate.es_formula lhs_var true
        unfold_num pos in
    (* update unfold_num *)
    let ctx1 = build_context (Ctx estate) delta1 pos in
    let ctx1 = set_unsat_flag ctx1 true in
    let res_rs, prf1 = x_add heap_entail_one_context_struc_x prog is_folding
        has_post ctx1 conseq None None None pos pid in
    let prf = mkUnfold_no_conseq (Ctx estate) lhs_node prf1 in
    (res_rs, prf)
  | _ -> report_error no_pos ("process_unfold - expecting just unfold operation")

(*
  TO CHECK: what is this supposed to do?
  What if there is permission?
*)
and do_infer_heap rhs rhs_rest caller prog estate conseq lhs_b rhs_b a
  (rhs_h_matched_set:CP.spec_var list) is_folding pos =
  let pr1 = Cprinter.string_of_h_formula in
  let pr2 = Cprinter.string_of_formula in
  let pr3 = (fun (c,_) -> Cprinter.string_of_list_context c) in
  Debug.no_5 "do_infer_heap"
    (add_str "rhs" pr1)  (add_str "rhs_rest" pr1) (add_str "conseq" pr2)
    (add_str "lhs_b" pr2) (add_str "rhs_b" pr2) pr3
    (fun _ _ _ _ _-> do_infer_heap_x rhs rhs_rest caller prog estate conseq
        lhs_b rhs_b a rhs_h_matched_set is_folding pos) rhs rhs_rest conseq
    (Base lhs_b) (Base rhs_b)

and do_infer_heap_x rhs rhs_rest caller prog estate conseq lhs_b rhs_b a
    (rhs_h_matched_set:CP.spec_var list) is_folding pos =
  (* no longer used this function *)
  let () = y_tinfo_hp (add_str "do_infer_heap:entry:rhs" !CF.print_h_formula) rhs in
  if not !Globals.fo_iheap ||  no_infer_pure estate then
    let err_msg = "infer_heap_node" in
    (CF.mkFailCtx_in
       (Basic_Reason (mkFailContext err_msg estate (Base rhs_b) None pos,
                      CF.mk_failure_may ("Disabled Infer heap and pure 2")
                        sl_error, estate.es_trace))
       ((convert_to_may_es estate), err_msg, Failure_May err_msg) (mk_cex false)
    , NoAlias)
  else
    (* TODO : this part is repeated in no_rhs_match; should optimize *)
    let lhs_xpure,_,_ = x_add xpure 6 prog estate.es_formula in
    let rhs_xpure,_,_ = x_add xpure 7 prog (formula_of_heap rhs no_pos) in
    let fml = MCP.merge_mems lhs_xpure rhs_xpure true in
    let check_sat = TP.is_sat_raw fml in
    let () = x_tinfo_hp (add_str "check_sat" string_of_bool) check_sat no_pos in
    (* check if there is a contraction with the RHS heap *)
    let r =
      if check_sat then Infer.infer_heap_nodes estate rhs rhs_rest conseq pos
      else None in
    begin
      match r with
      | Some (new_iv,new_rn,dead_iv,done_iv) ->
        let new_estate =
          let () = x_tinfo_hp (add_str "new_rn" Cprinter.string_of_h_formula) new_rn no_pos in
          {estate with
           es_infer_vars = new_iv;
           es_infer_vars_dead = dead_iv@estate.es_infer_vars_dead;
           es_infer_heap = new_rn::estate.es_infer_heap;
           es_formula = CF.normalize_combine_heap estate.es_formula new_rn;
          }
        in
        let mf,_,_ = x_add xpure_heap_symbolic 7 prog new_rn (MCP.mkMTrue no_pos) 0 in
        let inv_f = MCP.pure_of_mix mf in
        let new_estate = add_infer_pure_thus_estate inv_f new_estate in
        let ctx1 = (Ctx new_estate) in
        let ctx1 = set_unsat_flag ctx1 true in
        let r1, prf = x_add heap_entail_one_context 7 prog is_folding ctx1
            conseq None None None pos in
        let r1 = add_infer_heap_to_list_context [new_rn] r1 in
        (r1,prf)
      | None ->
        let err_msg = "infer_heap_node" in
        (CF.mkFailCtx_in
           (Basic_Reason (mkFailContext err_msg estate (Base rhs_b) None pos,
                          CF.mk_failure_may ("Cannot infer heap and pure 2")
                            sl_error, estate.es_trace))
           ((convert_to_may_es estate), err_msg, Failure_May err_msg)
           (mk_cex false), NoAlias)
    end

and do_unmatched_rhs_x rhs rhs_rest caller prog estate conseq lhs_b rhs_b a
  (rhs_h_matched_set:CP.spec_var list) is_folding pos =
  (* Thai: change back to Infer.infer_pure *)
  begin
    let (mix_rf,rsvl,mem_rf) = x_add xpure_heap_symbolic 8 prog
        rhs_b.formula_base_heap rhs_b.formula_base_pure 0 in
    let filter_redundant a c = CP.simplify_filter_ante TP.simplify_always a c in
    (*get list of pointers which equal NULL*)
    let lhs_eqs = MCP.ptr_equations_with_null lhs_b.CF.formula_base_pure in
    let lhs_p = List.fold_left
        (fun a (b,c) -> CP.mkAnd a (CP.mkPtrEqn b c no_pos) no_pos)
        (CP.mkTrue no_pos) lhs_eqs in
    let is_rel,rhs_ptr = CF.get_ptr_from_data_w_hrel rhs in
    let rhs_p = CP.mkNull rhs_ptr no_pos in
    (*all LHS = null |- RHS != null*)
    if (not is_rel) && (simple_imply lhs_p rhs_p) then
      let new_lhs_p = filter_redundant lhs_p rhs_p in
      let new_rhs_p = CP.mkNeqNull (CF.get_ptr_from_data rhs) no_pos in
      let s = "15.1" ^ (Cprinter.string_of_pure_formula new_lhs_p) ^ " |- " ^
              (Cprinter.string_of_pure_formula new_rhs_p) ^ " (must-bug)." in
      (*change to must flow*)
      let new_estate = {estate  with CF.es_formula = CF.substitute_flow_into_f
                                         !error_flow_int estate.CF.es_formula} in
      (Basic_Reason (mkFailContext s new_estate (Base rhs_b) None pos,
                     CF.mk_failure_must s Globals.logical_error, estate.es_trace), NoAlias)
    else
      begin
        (*check disj memset*)
        let r = ref (-9999) in
        (*
          example 19 of err2.slk should be handled here.
          checkentail x::node<_,null> & x=y |- x::node<_,_>*y::node<_,_>
          - add disjoint pointers into LHS pure formula
          - for example if RHS contains {x,y}, the constraint x!=y will be added
            to LHS pure formula
        *)
        let rhs_disj_set_p = CP.mklsPtrNeqEqn
            (rsvl @ (Gen.BList.remove_dups_eq (CP.eq_spec_var) rhs_h_matched_set)) no_pos in
        (*use global information here*)
        let rhs_disj_set_p =
          match rhs_disj_set_p with
          | Some p1 -> p1
          | _ -> CP.mkTrue no_pos
        in
        let rhs_neq_nulls = CP.mkNeqNull rhs_ptr no_pos in
        let rhs_mix_p = MCP.memoise_add_pure_N rhs_b.formula_base_pure rhs_disj_set_p in
        let rhs_mix_p_withlsNull = MCP.memoise_add_pure_N rhs_mix_p rhs_neq_nulls in
        let rhs_p = MCP.pure_of_mix rhs_mix_p_withlsNull in
        (*contradiction on RHS?*)
        if (not is_rel) && not(x_add TP.is_sat_sub_no 7 rhs_p r) then
          (*contradiction on RHS*)
          let msg = "contradiction in RHS:" ^ (Cprinter.string_of_pure_formula rhs_p) in
          let new_estate = {estate  with CF.es_formula = CF.substitute_flow_into_f
                                             !error_flow_int estate.CF.es_formula} in
          (Basic_Reason
             (mkFailContext msg new_estate (Base rhs_b) None pos,
              mk_failure_must ("15.2 " ^ msg ^ " (must-bug).") logical_error,
              new_estate.es_trace), NoAlias)
        else
          let lhs_p = MCP.pure_of_mix lhs_b.formula_base_pure in
          (* rhs_disj_set != null has been checked above. Separately check for
              better error classifying. *)
          let cex = (mk_cex true) in
          if (not is_rel) && not(simple_imply lhs_p rhs_p) then
            (*should check may-must here*)
            let (fc, (contra_list, must_list, may_list)) =
              x_add Musterr.check_maymust_failure lhs_p rhs_p in
            let new_estate = {
              estate with
              es_formula = match fc with
                | CF.Failure_Must _ -> CF.substitute_flow_into_f !error_flow_int estate.es_formula
                | CF.Failure_May _ -> CF.substitute_flow_into_f !mayerror_flow_int estate.es_formula
                            (* this denotes a maybe error *)
                | CF.Failure_Bot _
                | CF.Failure_Valid -> estate.es_formula
            } in
            let fc_template = mkFailContext "" new_estate (Base rhs_b) None pos in
            let olc = x_add Musterr.build_and_failures 3 "15.3 no match for rhs data node: " fc
                Globals.logical_error (contra_list, must_list, may_list)
                fc_template cex new_estate.es_trace in
            let lc =
              ( match olc with
                | FailCtx (ft,_,_) -> ft
                | SuccCtx _ -> report_error no_pos "solver.ml:M_unmatched_rhs_data_node"
              )
            in (lc,Failure)
          else
            let s = "15.4 no match for rhs data node: " ^ (CP.string_of_spec_var rhs_ptr)
                    ^ " (may-bug)971."in
            let new_estate = {estate  with CF.es_formula = CF.substitute_flow_into_f
                                               !top_flow_int estate.CF.es_formula} in
            (Basic_Reason (mkFailContext s new_estate (Base rhs_b) None pos,
                           CF.mk_failure_must s logical_error, new_estate.es_trace), NoAlias)
      end
  end

and do_unmatched_rhs rhs rhs_rest caller prog estate conseq lhs_b rhs_b a
  (rhs_h_matched_set:CP.spec_var list) is_folding pos =
  let pr1 =  Cprinter.string_of_entail_state in
  let pr2 (x,_) = Cprinter.string_of_fail_type x in
  Debug.no_2 "do_unmatched_rhs" Cprinter.string_of_h_formula pr1 pr2
    (fun _ _ ->
       do_unmatched_rhs_x rhs rhs_rest caller prog estate conseq lhs_b rhs_b a
         (rhs_h_matched_set:CP.spec_var list)
         is_folding pos) rhs estate

and process_unfold prog estate conseq a is_folding pos has_post pid =
  let pr1 = Context.string_of_action_res_simpl in
  let pr2 x = Cprinter.string_of_list_context_short (fst x) in
  Debug.no_2 "process_unfold" pr1 Cprinter.string_of_entail_state pr2
    (fun __ _ ->
       let r = process_unfold_x prog estate conseq a is_folding pos has_post pid in
       r)
    a estate

and init_para lhs_h rhs_h lhs_aset prog pos = match (lhs_h, rhs_h) with
  | DataNode dl, DataNode dr ->
    let alias = dl.h_formula_data_node::(CP.EMapSV.find_equiv_all
                                           dl.h_formula_data_node lhs_aset) in
    if List.mem dr.h_formula_data_node alias then
      try List.map2 (fun v1 v2 -> CP.mkEqVar v1 v2 pos)
            dl.h_formula_data_arguments dr.h_formula_data_arguments
      with Invalid_argument _ -> []
    else []
  | ViewNode vl, ViewNode vr ->
    let alias = vl.h_formula_view_node::(CP.EMapSV.find_equiv_all
                                           vl.h_formula_view_node lhs_aset) in
    if List.mem vr.h_formula_view_node alias then
      try List.map2 (fun v1 v2 -> CP.mkEqVar v1 v2 pos)
            vl.h_formula_view_arguments vr.h_formula_view_arguments
      with Invalid_argument _ -> []
    else []
  | _ -> []

and solver_detect_lhs_rhs_contra_all_x prog estate conseq pos msg =
  (* TODO: classic reasoning requires hf,HEmp case to be considered *)
  let detect_heap_contra lhs rhs =
    let (lhs_h,_,_,_,_,_) = CF.split_components lhs in
    let (rhs_h,_,_,_,_,_) = CF.split_components rhs in

    let flag = match lhs_h,rhs_h with
      | HEmp,hf (* | hf,HEmp *) -> not(CF.is_non_emp hf)
      | hf,HEmp -> not(check_is_classic_local estate.CF.es_infer_obj) || not(CF.is_non_emp hf)
      | _ -> true
    in
    let () = y_tinfo_pp "detect_heap_contra" in
    let () = y_tinfo_hp (add_str "lhs" !CF.print_formula) lhs in
    let () = y_tinfo_hp (add_str "conseq: "!CF.print_formula) rhs in
    let () = y_tinfo_hp (add_str "contra_if_false" string_of_bool) flag in
    flag
  in
  (* ======================================================= *)
  let (qvars, new_f) = match estate.es_formula with
    | Exists f ->  split_quantifiers estate.es_formula
    | _ ->  ([], estate.es_formula) in
  let temp_estate = {estate with es_formula = new_f } in
  let lhs_xpure,_,_ = x_add xpure 8 prog temp_estate.es_formula in
  (* ======================================================= *)
  (* call infer_lhs_contra *)
  let lhs_rhs_contra_flag =
    let p_lhs_xpure = MCP.pure_of_mix lhs_xpure in
    let old_imm_flag = !Globals.allow_imm in
    let () = Globals.allow_imm := true in
    let rhs_xpure,_,_ = x_add xpure 9 prog conseq in
    let () = Debug.ninfo_hprint
        (add_str "[solver_detect_lhs_rhs_contra_all]::  p_rhs_xpure 0: "
           Cprinter.string_of_mix_formula) rhs_xpure no_pos in
    let () = Globals.allow_imm := old_imm_flag in
    let p_rhs_xpure = MCP.pure_of_mix rhs_xpure in
    let p_lhs_xpure= p_lhs_xpure in
    let contr, _ = x_add Infer.detect_lhs_rhs_contra p_lhs_xpure p_rhs_xpure pos in
    let () = y_tinfo_hp (add_str "detect_lhs_rhs_contr" string_of_bool) contr in
    let heap_contra_false = if contr && !Globals.new_heap_contra
      then detect_heap_contra new_f conseq else true in
    contr && heap_contra_false  in
  let r_inf_contr,relass =
    if lhs_rhs_contra_flag then
      ([],[])
    else
      begin
        (* lhs_rhs contradiction detected *)
        (* try to first infer contra on lhs only with direct vars *)
        (*sa/norm/zip-1e.slk: lhs_rhs_contra: xpure lhs should consider the rhs (pairwaisecheck + neg produces imprecise result) *)
        let lhs_xpure0,_,_ = xpure_sym prog temp_estate.es_formula in
        let lhs_xpure = if (estate.CF.es_infer_vars_rel!=[]
                            || estate.CF.es_infer_vars_hp_rel !=[])
          then
            MCP.mix_of_pure (CP.prune_relative_unsat_disj (MCP.pure_of_mix lhs_xpure0) (CF.xpure_for_hnodes_f conseq))
          else lhs_xpure0
        in
        let () = Debug.ninfo_hprint
            (add_str "conseq" Cprinter.prtt_string_of_formula) conseq no_pos in
        let () = Debug.ninfo_hprint (add_str "lhs_xpure0"
                                       Cprinter.string_of_mix_formula)
            lhs_xpure0 no_pos in
        let () = Debug.ninfo_hprint (add_str "lhs_xpure"
                                       Cprinter.string_of_mix_formula) lhs_xpure
            no_pos in
        let r_inf_contr,relass = x_add Infer.infer_lhs_contra_estate 4 estate lhs_xpure pos msg  in
        let contra, c,r =
          match r_inf_contr with
          | Some r ->  (true, [r], relass)
          | None ->
            begin
              match relass with
              | h::t0 -> (true, [], relass)
              | []   ->  (false, [], [])
            end
        in
        if (contra) then (c,r)
        else
          (* contra with  HP args *)
          let contr_lst, rel = solver_infer_lhs_contra_list prog estate lhs_xpure pos msg in
          (contr_lst, rel)
      end
  in
  ((r_inf_contr,lhs_rhs_contra_flag),relass)

and solver_detect_lhs_rhs_contra_all i prog estate conseq pos msg =
  let pr_estate = Cprinter.string_of_entail_state_short in
  let pr_f = Cprinter.string_of_formula in
  let pr_es (es,e) =  pr_pair pr_estate Cprinter.string_of_pure_formula (es,e) in
  let pr = CP.print_lhs_rhs in
  let pr_3 (_,lr,b) =  pr_pair (pr_list pr) string_of_bool (lr,b) in
  Debug.no_3_num i "solver_detect_lhs_rhs_contra_all"
    pr_estate pr_f pr_id  (pr_pair (pr_pair (pr_list (pr_es))
                                      (add_str "real_contra" string_of_bool))
                             (pr_list pr_3)) (fun _ _ _ ->
        solver_detect_lhs_rhs_contra_all_x prog estate conseq pos msg) estate conseq msg

and solver_detect_lhs_rhs_contra_x i prog estate conseq pos msg =
  let (contr_lst,real_c), rel = solver_detect_lhs_rhs_contra_all 1 prog estate conseq pos msg in
  match contr_lst with
  | h::t ->
    let h = choose_best_candidate contr_lst in
    ((h,real_c), rel)
  | []   -> ((None,real_c),rel)

(* (Infer.CF.entail_state * Cprinter.P.formula) option * *)
(* (Infer.CF.entail_state * Cformula.CP.infer_rel_type list * bool) list *)
and solver_detect_lhs_rhs_contra i prog estate conseq pos msg =
  let pr_estate = Cprinter.string_of_entail_state_short in
  let pr_f = Cprinter.string_of_formula in
  let pr_es (es,e) =  pr_pair pr_estate Cprinter.string_of_pure_formula (es,e) in
  let pr = CP.print_lhs_rhs in
  let pr_3 (_,lr,b) =  pr_pair (pr_list pr) (add_str "real_c" string_of_bool) (lr,b) in
  Debug.no_3_num i "solver_detect_lhs_rhs_contra"
    pr_estate pr_f pr_id  (pr_pair (pr_pair (pr_option pr_es) string_of_bool)
                             (pr_list pr_3)) (fun _ _ _ ->
        solver_detect_lhs_rhs_contra_x i prog estate conseq pos msg) estate conseq msg

(*
type: (Infer.CF.entail_state * CP.formula) list ->
  (Infer.CF.entail_state * CP.formula) option
*)

and rank_cand_list_x ls =
  let rank_formula f =
    if CP.is_False f then 0
    else if CP.contains_neq f then 1
    else if not(CP.is_Prim f) then 2
    else 3 (* assuming equality *) in
  let rl = List.map (fun ((es,f) as x) -> (rank_formula f,x)) ls in
  List.sort (fun (a,_) (b,_) ->if a>b then -1 else if a<b then 1 else 0) rl

and rank_cand_list ls =
  let pr0 (_,f) = Cprinter.string_of_pure_formula f in
  let pr = pr_list (pr_pair string_of_int pr0) in
  Debug.no_1 "rank_cand_list" pr_none pr rank_cand_list_x ls

and choose_best_candidate contr_lst =
  let pr1 = pr_list (pr_pair Cprinter.string_of_entail_state_short
                       Cprinter.string_of_pure_formula) in
  let pr2 = pr_option (fun (_,x) -> Cprinter.string_of_pure_formula x) in
  Debug.no_1 "choose_best_candidate " pr1 pr2 choose_best_candidate_x contr_lst

and choose_best_candidate_x contr_lst =
  match (rank_cand_list contr_lst) with
  | (_,a)::_ -> Some a
  | _ -> None

(* trying to infer a contradiction with given spec vars *)
and solver_infer_lhs_contra estate lhs_xpure h_inf_args pos msg =
  let h_inf_args_add = Gen.BList.difference_eq CP.eq_spec_var h_inf_args estate.es_infer_vars in
  let new_estate = {estate with es_infer_vars = h_inf_args_add } in
  let () = x_tinfo_hp (add_str "h_inf_args" Cprinter.string_of_spec_var_list) h_inf_args no_pos in
  let () = x_tinfo_hp (add_str "es_infer_vars" Cprinter.string_of_spec_var_list)
      new_estate.es_infer_vars no_pos in
  let r_inf_contr,relass = x_add Infer.infer_lhs_contra_estate 4 new_estate
      lhs_xpure pos msg in
  r_inf_contr,relass

and sort_infer_vars_hp_rel prog infer_vars_hp_rel =
  List.fast_sort (fun hp1 hp2 ->
      let hpdecl1 = x_add_1 Cast.look_up_hp_def_raw prog.Cast.prog_hp_decls
          (CP.name_of_spec_var hp1) in
      let hpdecl2 = x_add_1 Cast.look_up_hp_def_raw prog.Cast.prog_hp_decls
          (CP.name_of_spec_var hp2) in
      let h1,h2 = (hpdecl1.hp_is_pre,  hpdecl2.hp_is_pre) in
      if (h1 = h2) then 0
      else if (h1 && (not h2)) then (-1)
      else 1
    ) infer_vars_hp_rel

and solver_infer_lhs_contra_first_sat_x prog estate lhs_xpure pos msg =
  let infer_vars_hp_rel = estate.es_infer_vars_hp_rel in
  let () = x_tinfo_hp (add_str "infer_vars_hp_rel"
                         Cprinter.string_of_spec_var_list) infer_vars_hp_rel pos
  in
  (* sort hp_rel vars such that Pre Pred comes bef Post Pred*)
  let infer_vars_hp_rel =  sort_infer_vars_hp_rel prog infer_vars_hp_rel in
  let () = x_tinfo_hp (add_str "infer_vars_hp_rel"
                         Cprinter.string_of_spec_var_list) infer_vars_hp_rel
      no_pos in

  (* search for the first unknown predicate that has a satisfiable entry (can
  form a contradiction)  *)
  let rec infer_lhs_contra_helper infer_vars_hp_rel =
    match infer_vars_hp_rel with
    | hp_rel0 :: t ->
      let h_inf_args, _ = get_heap_inf_args_hp_rel estate [hp_rel0] in
      let rcontr,rel =  solver_infer_lhs_contra estate lhs_xpure h_inf_args pos msg in
      begin
        match rcontr with
        | Some _ -> (rcontr,rel)
        | None ->
          begin
            match rel with
            | h::t0 -> rcontr,rel
            | []   -> infer_lhs_contra_helper t
          end
      end
    | [] -> (None, []) in
  let (c,r)  = infer_lhs_contra_helper infer_vars_hp_rel  in
  (c,r)

and solver_infer_lhs_contra_first_sat prog estate lhs_xpure pos msg =
  let pr_estate = Cprinter.string_of_entail_state_short in
  let pr_es (es,e) =  pr_pair pr_estate Cprinter.string_of_pure_formula (es,e) in
  let pr = CP.print_lhs_rhs in
  let pr_3 (_,lr,b) =  pr_pair (pr_list pr) string_of_bool (lr,b) in
  Debug.no_2 "solver_infer_lhs_contra_first_sat" pr_estate Cprinter.string_of_mix_formula
    (pr_pair (pr_option pr_es) (pr_list pr_3)) (fun _ _ ->
        solver_infer_lhs_contra_first_sat_x prog estate lhs_xpure pos msg )
    estate lhs_xpure

and solver_infer_lhs_contra_list_x prog estate lhs_xpure pos msg =
  let infer_vars_hp_rel = estate.es_infer_vars_hp_rel in
  let () = x_tinfo_hp (add_str "infer_vars_hp_rel"
                         Cprinter.string_of_spec_var_list) infer_vars_hp_rel pos
  in
  (* sort hp_rel vars such that Pre Pred comes bef Post Pred*)
  let infer_vars_hp_rel =  sort_infer_vars_hp_rel prog infer_vars_hp_rel in
  let () = x_tinfo_hp (add_str "infer_vars_hp_rel"
                         Cprinter.string_of_spec_var_list) infer_vars_hp_rel
      no_pos in

  let h_inf_args, h_arg_map = get_heap_inf_args_hp_rel estate infer_vars_hp_rel in
  let rcontr,rel =  solver_infer_lhs_contra estate lhs_xpure h_inf_args pos msg in
  let eqs0 = (MCP.ptr_equations_without_null lhs_xpure) in
  let helper args ps=
    List.exists (fun p ->
        CP.is_eq_exp p
      ) ps
  in
  let r_contr_lst = match rcontr with
    | Some (es,f) ->
      let fv = CP.fv f in
      let rcontr_lst = List.fold_left (fun x hp_rel0 ->
          let h_inf_args0, _ = get_heap_inf_args_hp_rel estate [hp_rel0] in
          let eqs1 = List.fold_left (fun acc (sv1, sv2) ->
              let b1 = CP.mem_svl sv1 h_inf_args0 in
              let b2 = CP.mem_svl sv2 h_inf_args0 in
              match b1,b2 with
              | true, false -> acc@[(sv2,sv1)]
              | true, true -> acc
              | _ -> acc@[(sv1,sv2)]
            ) [] eqs0 in
          let f = CP.subst eqs1 f in
          let h_inf_args1 = (CF.find_close h_inf_args0 eqs0) in
          let f =
            let ps = CP.list_of_disjs f in
            if List.length ps <=1 || not (helper h_inf_args0 ps) then f
            else
              let ps1=List.filter (fun p->not(CP.is_neq_null_exp p) &&
                                          (CP.intersect_svl (CP.fv p) h_inf_args1 <> [])
                                  ) ps in
              CP.disj_of_list ps1 pos
          in
          let diff = CP.diff_svl fv h_inf_args1 in
          let p = CP.mkForall diff f None pos in
          let () = x_tinfo_hp (add_str "p: " (!CP.print_formula)) p pos in
          let () = x_tinfo_hp (add_str "h_inf_args1: " (!CP.print_svl)) h_inf_args1 pos in
          let () = x_tinfo_hp (add_str "diff: " (!CP.print_svl)) diff pos in
          let () = x_tinfo_hp (add_str "f: " (!CP.print_formula)) f pos in
          if (CP.is_cmp_form f) || TP.is_sat_raw (MCP.mix_of_pure p) then
            let () = x_tinfo_hp (add_str "p1: " (!CP.print_formula)) p pos in
            let np = (x_add_1 TP.simplify (CP.arith_simplify_new p)) in
            let () = x_tinfo_hp (add_str "lhs_xpure" !CP.print_formula)
                (MCP.pure_of_mix lhs_xpure) no_pos in
            let () = x_tinfo_hp (add_str "np" !CP.print_formula) np no_pos in
            let ps1, redun_neqNulls=
              List.partition (fun p->not(CP.is_neq_null_exp p))
                (CP.split_conjunctions np) in
            let detect_contra = CP.join_conjunctions (redun_neqNulls@[MCP.pure_of_mix lhs_xpure]) in
            let np = if TP.is_sat_raw (MCP.mix_of_pure detect_contra) then
                CP.join_conjunctions ps1
              else np
            in
            x@[(es,np)]
          else x
        ) [] infer_vars_hp_rel in
      rcontr_lst
    | None -> [] in
  (r_contr_lst, rel)

and solver_infer_lhs_contra_list prog estate lhs_xpure pos msg =
  let pr_estate = Cprinter.string_of_entail_state(* _short *) in
  let pr_es (es,e) =  pr_pair pr_estate Cprinter.string_of_pure_formula (es,e) in
  let pr = CP.print_lhs_rhs in
  let pr_3 (_,lr,b) =  pr_pair (pr_list pr) string_of_bool (lr,b) in
  Debug.no_2 "solver_infer_lhs_contra_list" pr_estate Cprinter.string_of_mix_formula
    (pr_pair (pr_list pr_es) (pr_list pr_3)) (fun _ _ ->
        solver_infer_lhs_contra_list_x prog estate lhs_xpure pos msg ) estate
    lhs_xpure

and process_before_do_match_x new_p prog estate conseq lhs_b rhs_b
  rhs_h_matched_set is_folding pos lhs_node lhs_rest rhs_node rhs_rest holes =
  let () = x_tinfo_zp (lazy ("before_do_match rhs_b"
                             ^ (Cprinter.string_of_formula_base rhs_b))) pos in
  let subsumes, to_be_proven = prune_branches_subsume prog lhs_node rhs_node in
  if not subsumes then
    let err_msg = "there is a mismatch in branches " in
    (CF.mkFailCtx_in (Basic_Reason (mkFailContext err_msg estate conseq (get_node_label rhs_node) pos, CF.mk_failure_must "mismatch in branches 1" sl_error, estate.es_trace)) ((convert_to_must_es estate), err_msg, Failure_Must err_msg) (mk_cex true), NoAlias)
  else
    let new_es_formula = Base{lhs_b with formula_base_heap = lhs_rest} in
    let new_estate = {estate with es_formula = new_es_formula; es_crt_holes = holes} in
    (*TODO: if prunning fails then try unsat on each of the unprunned branches
    with respect to the context,
      if it succeeds and the flag from to_be_proven is true then make current
    context false*)
    let rhs_p = match to_be_proven with
      | None -> rhs_b.formula_base_pure
      | Some (p,_) -> MCP.memoise_add_pure rhs_b.formula_base_pure p in
    let () = x_tinfo_zp (lazy ("before_do_match rhs_p"
                               ^ (Cprinter.string_of_mix_formula rhs_p))) pos in
    let rhs_p = if new_p==[] then rhs_p
      else MCP.memoise_add_pure rhs_p (CP.join_conjunctions new_p) in
    let n_rhs_b = Base {rhs_b with formula_base_heap = rhs_rest;formula_base_pure = rhs_p} in
    let () = x_tinfo_hp (add_str "new_estate(M_match)"
                           (Cprinter.string_of_entail_state)) new_estate pos in
    let () = y_tinfo_hp (add_str "new_p" !CP.print_formula) (CP.join_conjunctions new_p) in
    let () = y_tinfo_hp (add_str "n_rhs_b" !CF.print_formula) n_rhs_b in
    let res_es0, prf0 = x_add do_match prog new_estate lhs_node rhs_node n_rhs_b
        rhs_h_matched_set is_folding pos in
    (res_es0,prf0)

and process_before_do_match new_p prog estate conseq lhs_b rhs_b
  rhs_h_matched_set is_folding pos lhs_node lhs_rest rhs_node rhs_rest holes =
  let pr (e,_) = Cprinter.string_of_list_context e in
  let pr4 = Cprinter.string_of_entail_state in
  let pr_h = Cprinter.string_of_h_formula in
  Debug.no_4 "process_before_do_match"
    (add_str "lhs node" pr_h)
    (add_str "rhs node" pr_h)
    (add_str "lhs rest" pr_h)
    pr4
    pr (fun _ _ _ _ -> process_before_do_match_x new_p prog estate conseq lhs_b
           rhs_b rhs_h_matched_set is_folding pos lhs_node lhs_rest rhs_node
           rhs_rest holes) lhs_node rhs_node lhs_rest estate

and process_action ?(caller="") i cont_act prog estate conseq lhs_b rhs_b a
  (rhs_h_matched_set:CP.spec_var list) is_folding pos
  : (Cformula.list_context * Prooftracer.proof) =
  let pr1 = Context.string_of_action_res_simpl in
  let length_ctx ctx = match ctx with
    | CF.FailCtx _ -> 0
    | CF.SuccCtx ctx0 -> List.length ctx0 in
  let pr2 x = "\nctx length:" ^ (string_of_int (length_ctx (fst x)))
              ^ " \n Context:"^ Cprinter.string_of_list_context (fst x) in
  let pr3 = Cprinter.string_of_formula in
  let filter _ = match a with
    | Context.M_Nothing_to_do _ -> false
    | _ -> true in
  Debug.no_5_all i "process_action" (Some filter) None [] pr1
    (add_str "estate" Cprinter.string_of_entail_state(* _short *))
    (add_str "conseq" Cprinter.string_of_formula)
    (add_str "lhs_b" pr3)
    (add_str "rhs_b" pr3) pr2
    (fun _ _ _ _ _ -> process_action_x ~caller:caller cont_act prog estate
        conseq lhs_b rhs_b a rhs_h_matched_set is_folding pos)
    a estate conseq (Base lhs_b) (Base rhs_b)

(* this will perform a simple action and return a (estate,conseq) *)
(*  it won't run to completion *)
and process_small_action prog estate act conseq is_folding pos
  : (Cformula.list_context * Prooftracer.proof) =
  failwith "TBI process_small_action"

and process_action_x ?(caller="") cont_act prog estate conseq lhs_b rhs_b a
  (rhs_h_matched_set: CP.spec_var list) is_folding pos
  : (Cformula.list_context * Prooftracer.proof) =
  y_tinfo_hp (add_str "process_action lhs_b" !CF.print_formula_base) lhs_b;
  Debug.ninfo_hprint (add_str "process_action rhs_b" !CF.print_formula_base) rhs_b pos;
  if (Context.is_steps_action a) then
    begin
      if !Debug.devel_debug_on || !Debug.devel_debug_steps then
        begin
          x_info_zp (lazy ("process_action (steps) :"
                           ^ ((add_str "\n ### action " Context.string_of_action_res) a)
                           ^ ((add_str "\n ### estate "
                                 Cprinter.string_of_entail_state_short) estate)
                           ^ ((add_str "\n ### conseq " Cprinter.string_of_formula) conseq)
                           ^ "\n"))  pos
        end
    end;
  (* (*add tracing into the entailment state*)                               *)
  (* let action_name:string = Context.string_of_action_name a in             *)
  (* let estate = { estate with es_trace = action_name::estate.es_trace } in *)
  let () = rhs_rest_emp := Context.get_rhs_rest_emp_flag a !rhs_rest_emp in
  let rec pm_aux_x estate lhs_b a =
    (* Add tracing into the entailment state *)
    let action_name = Context.string_of_action_name a in
    let estate = { estate with es_trace = action_name::estate.es_trace } in
    match a with  (* r1: list_context, r2: proof *)
    | Context.M_match ({
        Context.match_res_lhs_node = lhs_node;
        Context.match_res_lhs_rest = lhs_rest;
        Context.match_res_rhs_node = rhs_node;
        Context.match_res_rhs_rest = rhs_rest;
        Context.match_res_infer = infer_opt;
        Context.match_res_holes = holes;
      } as m_res)->
      x_tinfo_hp (add_str "lhs_node" (Cprinter.string_of_h_formula)) lhs_node pos;
      x_tinfo_hp (add_str "lhs_rest" (Cprinter.string_of_h_formula)) lhs_rest pos;
      x_tinfo_hp (add_str "rhs_node" (Cprinter.string_of_h_formula)) rhs_node pos;
      x_tinfo_hp (add_str "rhs_rest" (Cprinter.string_of_h_formula)) rhs_rest pos;
      x_tinfo_hp (add_str "holes" (pr_list (pr_pair Cprinter.string_of_h_formula
                                              string_of_int))) holes pos;
      let lhs_rest = List.fold_left (fun f (_,h) -> CF.mkStarH f (CF.Hole h) pos) lhs_rest holes
      in
      x_tinfo_hp (add_str "lhs_rest (after adding the nodes)"
                    (Cprinter.string_of_h_formula)) lhs_rest pos;
      let pure_to_add = match infer_opt with
        | Some f ->
          let () = y_binfo_pp "TODO : make lhs_node=rhs_node inference with MATCH" in
          let () = x_binfo_hp (add_str "rhs_to_prove" !CP.print_formula) f pos in
          let () = x_binfo_hp (add_str "conseq" !CF.print_formula) conseq pos in
          [f]
        | _ -> [] in
      (*******SPLIT/COMBINE permissions********>>
              if lhs_p |\- perm(lhs_node) != perm(rhs_node) then MATCH
              else SPLIT followed by MATCH or COMBINE followed by MATCH
       ***************************************>>*)
      let res = if (not (Perm.allow_perm ()))
                || (estate.es_is_normalizing || (CF.is_thread lhs_node))
        then
          (*If not using permissions or is in normalization process --> MATCH ONLY*)
          None
        else
          let exists_vars = estate.es_evars@estate.es_gen_expl_vars@estate.es_ivars in
          let lhs_perm = CF.get_node_perm lhs_node in
          let rhs_perm = CF.get_node_perm rhs_node in
          let lhs_orignal = CF.get_node_original lhs_node in
          let exact_flag,perm_f,vars = match lhs_perm,rhs_perm with
            | None,None -> (true,CP.mkTrue no_pos,[]) (*1.0 = 1.0 => exact match*)
            | Some f, None ->
              (match !Globals.perm with
               | Bperm -> report_error no_pos
                            "[solver.ml] process_action : Context.M_match :
  unexpected for bperm"
               | _ ->
                 let f = Cpure.get_var f in
                 (false, Perm.mkFullPerm_pure () f,[f]))
            | None, Some f ->
              (match !Globals.perm with
               | Bperm -> report_error no_pos
                            "[solver.ml] process_action : Context.M_match :
  unexpected for bperm"
               | _ ->
                 let f = Cpure.get_var f in
                 (false, Perm.mkFullPerm_pure () f,[f]))
            | Some f1,Some f2 ->
              (match !Globals.perm with
               | Bperm ->
                 let ls1 = Perm.get_cperm_var lhs_perm in
                 let ls2 = Perm.get_cperm_var rhs_perm in
                 let ls = List.combine ls1 ls2 in
                 let f = List.fold_left (fun f (lvar,rvar) ->
                     let nf = if (CP.eq_spec_var lvar rvar) then
                         CP.mkTrue no_pos
                       else CP.mkEqVar lvar rvar no_pos
                     in
                     (CP.mkAnd f nf no_pos)
                   ) (CP.mkTrue no_pos) ls
                 in
                 (false, f,ls1@ls2)
               | _ ->
                 let f1 = Cpure.get_var f1 in
                 let f2 = Cpure.get_var f2 in
                 if (CP.eq_spec_var f1 f2) then
                   (true,CP.mkTrue no_pos,[])
                 else
                   (false, CP.mkEqVar f1 f2 no_pos,[f1;f2]))
          in
          (*We already decide this in Context.process_one_match
            Note: this flag may be related to the function filter_norm_lemmas
            in process_one_match
          *)
          let exists_vars = Gen.BList.difference_eq (CP.eq_spec_var) exists_vars vars in
          let rhs_frac = if (vars=[]) then MCP.mkMTrue no_pos
            else MCP.find_rel_constraints (rhs_b.formula_base_pure) vars in
          let xpure_lhs, _, memset = x_add xpure 11 prog (Base lhs_b) in
          let lhs_frac = MCP.memoise_add_pure_N  xpure_lhs perm_f in
          let split_ante,split_conseq =
            x_add heap_entail_build_mix_formula_check 4 exists_vars lhs_frac
              rhs_frac pos in
          let flag_conseq_true = MCP.isConstMTrue split_conseq in
          let imp_subno = ref 0 in
          let res= if flag_conseq_true then
              (*this case occurs when f2 is an instantiation var
                w/o any constraint on the rhs*)
              false
            else
              let res,_,_ = imply_mix_formula_no_memo 2 split_ante split_conseq
                  !imp_no !imp_subno None memset in
              res
          in
          let () = x_dinfo_zp (lazy ("process_action: Context.M_match : deciding MATCH (res=true) or SPLIT (res=false): \n ### lhs_frac = " ^ (Cprinter.string_of_mix_formula lhs_frac) ^ "\n ### rhs_frac = " ^ (Cprinter.string_of_mix_formula rhs_frac) ^ "\n ### exists_vars = " ^ (Cprinter.string_of_spec_var_list exists_vars) ^ "\n ### split_ante = " ^ (Cprinter.string_of_mix_formula split_ante) ^ "\n ### split_conseq = " ^ (Cprinter.string_of_mix_formula split_conseq) ^ "\n ### res = " ^ (string_of_bool res) ^ "\n\n")) no_pos in
          (* the nodes should be splittable,
             both side of permissions should be non-empty (full),
             tmp!=[] : the fractional variables are not instantiation variables, or
             f1=f2 cannot be proven
          *)
          if (res=false) then
            (*if guess that cannot match exactly, apply lemma*)
            (*First, find lemma actions to apply*)
            let new_act = x_add_1 Context.lookup_lemma_action prog m_res in
            let str = "(Match-->try split/combine)" in
            (*convert means ignore previous MATCH and replaced by lemma*)
            let new_trace = str::(List.tl estate.es_trace) in
            let new_estate = {estate with es_trace = new_trace} in
            (*re-process action*)
            let (r,prf) = x_add (process_action ~caller:(x_loc ^ ":" ^ caller))
                5 cont_act prog new_estate conseq lhs_b rhs_b new_act
                rhs_h_matched_set is_folding pos in
            if isFailCtx r then None (*if try SPLIT failed, try MATCH*)
            else Some (r,prf)
          else None
      in
      (match res with
       | Some r ->
         Debug.ninfo_hprint (add_str "Match action, context r" (fun x ->
             Cprinter.string_of_list_context (fst x))) r no_pos;
         r
       | None  -> begin
           (*<<***END SPLIT/COMBINE permissions*******************)
           y_dinfo_pp ("Match action, do process_before_do_match r");
           let r = x_add process_before_do_match pure_to_add prog estate conseq lhs_b
               rhs_b rhs_h_matched_set is_folding pos lhs_node lhs_rest rhs_node
               rhs_rest holes in
           Debug.dinfo_hprint (add_str "Match action, context r" (fun x ->
               Cprinter.string_of_list_context (fst x))) r no_pos;
           r
         end)
    | Context.M_cyclic ({
        Context.match_res_lhs_node = lhs_node;
        Context.match_res_lhs_rest = lhs_rest;
        Context.match_res_rhs_node = rhs_node;
        Context.match_res_rhs_rest = rhs_rest;
        (* Context.match_res_holes = holes; *)
      } as m_res, unfold_num, unfold_or_fold, lem_type, unfold_opt)->
      x_tinfo_hp (add_str "lhs_node" (Cprinter.string_of_h_formula)) lhs_node pos;
      x_tinfo_hp (add_str "lhs_rest" (Cprinter.string_of_h_formula)) lhs_rest pos;
      x_tinfo_hp (add_str "rhs_node" (Cprinter.string_of_h_formula)) rhs_node pos;
      x_tinfo_hp (add_str "rhs_rest" (Cprinter.string_of_h_formula)) rhs_rest pos;
      (*semantic: infer lemma*)
      (*add checkpoint for cyclic proof*)
      let orig_rhs_b = if CP.isConstTrue estate.CF.es_conseq_pure_lemma then rhs_b
        else CF.mkAnd_base_pure rhs_b (MCP.mix_of_pure estate.CF.es_conseq_pure_lemma) no_pos
      in
      let new_view_opt = if !Globals.lemma_syn then
          let nview_opt = if lem_type =2 then
              let nview = x_add Lemsyn.gen_lemma_infer prog Infer.rel_ass_stk
                  CF.rel_def_stk (!rev_trans_formula) (!manage_unsafe_lemmas)
                  (!manage_infer_pred_lemmas) (!trans_hprel_2_cview)
                  (!trans_formula_hp_2_view) (x_add xpure_heap) estate lem_type
                  lhs_node rhs_node
              in
              (Some nview)
            else
              let () = x_add Lemsyn.gen_lemma prog (!rev_trans_formula)
                  (!manage_unsafe_lemmas) estate lem_type lhs_node lhs_b
                  rhs_node orig_rhs_b
              in
              None
          in
          nview_opt
        else None
      in
      (*unfold*)
      let new_m_res = match unfold_opt with
        | None -> m_res
        | Some lv -> {m_res with Context.match_res_lhs_node = lv}
      in
      let n_act =  if lem_type = 2  then
          let left_ls = x_add Cast.look_up_coercion_with_target
              (List.filter (fun c -> c.coercion_case = (Cast.Simple))
                 (Lem_store.all_lemma # get_left_coercion))
              (Cfutil.get_data_view_name lhs_node)
              (match new_view_opt with
               | Some v -> CP.name_of_spec_var v
               | _ -> "")
          in
          let left_acts =
            List.map (fun l -> (1, Context.M_lemma (new_m_res,Some l,0)))
              left_ls in
          (Context.Search_action left_acts)
        else if lem_type = 3 then
          let right_ls = Context.filter_norm_lemmas
              (Cast.look_up_coercion_with_target
                 (Lem_store.all_lemma # get_left_coercion)
                 (Cfutil.get_data_view_name lhs_node)
                 (Cfutil.get_data_view_name rhs_node))  in
          if (right_ls) = [] then Context.M_unfold (new_m_res, unfold_num) else
            let acts = List.map (fun l -> (1, Context.M_lemma (new_m_res,Some l,
                                                               0))) (right_ls)
            in
            (Context.Search_action acts)
        else Context.M_unfold (new_m_res, unfold_num)
      in
      let str = "(M_cyclic)" in
      let new_trace = str::(List.tl estate.es_trace) in
      let new_estate = {estate with CF.es_trace = new_trace;
                                    CF.es_conseq_pure_lemma = CP.mkTrue no_pos;
                       } in
      x_add (process_action ~caller:(x_loc ^ ":" ^ caller)) 6 cont_act prog
        new_estate conseq lhs_b rhs_b n_act rhs_h_matched_set is_folding pos
    | Context.M_split_match {
        Context.match_res_lhs_node = lhs_node;
        Context.match_res_lhs_rest = lhs_rest;
        Context.match_res_rhs_node = rhs_node;
        Context.match_res_rhs_rest = rhs_rest;
      } ->
      let l_perm = get_node_perm lhs_node in
      let r_perm = get_node_perm rhs_node in
      let v_rest, v_consumed =
        let l_var = match l_perm with | None -> Perm.full_perm_var() |
          Some v -> (Cpure.get_var v) in
        Perm.fresh_cperm_var () l_var , Perm.fresh_cperm_var () l_var in
      if not (test_frac_subsume prog estate rhs_b.formula_base_pure l_perm r_perm) then
        let err_msg = "lhs has lower permissions than required or rhs is false" in
        (CF.mkFailCtx_in (Basic_Reason (mkFailContext err_msg estate conseq (get_node_label rhs_node) pos,CF.mk_failure_must "perm subsumption" sl_error, estate.es_trace)) ((convert_to_must_es estate), err_msg, Failure_Must err_msg) (mk_cex true), NoAlias)
      else
        let subsumes, to_be_proven = prune_branches_subsume prog lhs_node rhs_node in
        if not subsumes then
          let err_msg = "there is a mismatch in branches "  in
          (CF.mkFailCtx_in (Basic_Reason (mkFailContext (* "there is a mismatch in branches "  *)err_msg estate conseq (get_node_label rhs_node) pos,CF.mk_failure_must "mismatch in branches 2" sl_error, estate.es_trace)) ((convert_to_must_es estate), err_msg, Failure_Must err_msg) (mk_cex true), NoAlias)
        else
          let n_lhs_h = mkStarH lhs_rest (set_node_perm lhs_node
                                            (Some (Cpure.Var (v_rest,no_pos))))
              pos in
          let n_rhs_pure =
            let l_perm = match l_perm
              with | None -> CP.Tsconst (Tree_shares.Ts.top, no_pos) |
                Some v -> v in
            let npure = CP.BForm
                ((CP.Eq (l_perm, CP.Add (CP.Var (v_rest,no_pos),
                                         CP.Var (v_consumed,no_pos),no_pos),
                         no_pos), None),None) in
            MCP.memoise_add_pure rhs_b.formula_base_pure npure in
          let new_estate = {estate with
                            es_formula = Base{lhs_b with formula_base_heap = n_lhs_h};
                            es_ante_evars = estate.es_ante_evars ;
                            es_ivars = v_rest::(if (List.exists (CP.eq_spec_var v_consumed) estate.es_gen_impl_vars) then estate.es_ivars else v_consumed::estate.es_ivars)} in
          (*TODO: if prunning fails then try unsat on each of the unprunned
          branches with respect to the context,
            if it succeeds and the flag from to_be_proven is true then make
          current context false*)
          let rhs_p = match to_be_proven with
            | None -> n_rhs_pure
            | Some (p,_) -> MCP.memoise_add_pure n_rhs_pure p in
          let n_rhs_b = Base {rhs_b with formula_base_heap = rhs_rest;formula_base_pure = rhs_p} in
          let n_lhs_node = set_node_perm lhs_node (Some (Cpure.Var (v_consumed,no_pos))) in
          x_dinfo_zp (lazy "do_match_split") pos;
          x_tinfo_hp (add_str "new_estate(M_split_match)"
                        (Cprinter.string_of_entail_state)) new_estate pos;
          let res_es0, prf0 = x_add do_match prog new_estate n_lhs_node rhs_node
              n_rhs_b rhs_h_matched_set is_folding pos in
          (res_es0,prf0)
    | Context.M_fold {
        Context.match_res_lhs_node = lhs_node;
        Context.match_res_rhs_node = rhs_node;
        Context.match_res_root_inst = root_inst;
        Context.match_res_rhs_rest = rhs_rest;
        (* match_res_reason is used only in folding *)
        Context.match_res_reason = match_reason;
      } ->
      let () = y_tinfo_hp (add_str "FOLD: match_reason:" (pr_option !CP.print_formula)) match_reason in
      let () = y_tinfo_hp (add_str "xxxM_fold" (Cprinter.string_of_formula_base)) rhs_b in
      let () = y_tinfo_hp (add_str "root_inst" (pr_option !CP.print_sv )) root_inst in
      let () = y_dinfo_hp (add_str "rhs_node" !CF.print_h_formula) rhs_node in
      let wrap_fn = match root_inst with
        | Some id ->
          let () = y_tinfo_hp (add_str "fold_matching_stk (lhs_node)" !CF.print_h_formula) lhs_node in
          Context.wrap_fold_matching (id,lhs_node)
        | None -> fun x -> x in
      let estate =
        if no_infer_rel estate || not(!init_para_flag) then estate
        else
          let () = y_winfo_pp "WARN: fold with init_para, unsound?" in
          let lhs_h, lhs_p, _, _, _, lhs_a  = CF.split_components estate.es_formula in
          let lhs_alias = MCP.ptr_equations_without_null lhs_p in
          let lhs_aset = CP.EMapSV.build_eset lhs_alias in
          let () = y_dinfo_pp ("lhs_aset "^((CP.EMapSV.string_of) lhs_aset)) in
          (* Assumed lhs_h to be star or view_node or data_node *)
          let lhs_h_list = split_star_conjunctions lhs_h in
          let () = y_dinfo_pp ("lhs_h_list"^((pr_list Cprinter.string_of_h_formula) lhs_h_list)) in
          let init_pures = List.concat (List.map (fun l -> init_para l rhs_node
                                                     lhs_aset prog pos)
                                          lhs_h_list) in
          let init_pure = CP.conj_of_list init_pures pos in
          let () = y_dinfo_pp ("init_pure"^(!CP.print_formula init_pure)) in
          {estate with es_formula = CF.normalize 1 estate.es_formula
                           (CF.formula_of_pure_formula init_pure pos) pos} in
      let () = y_tinfo_hp (add_str "M_fold (to make progress)"
                             (Cprinter.string_of_h_formula)) rhs_node in
      let lst = CF.extract_view_nodes_name rhs_node in
      let () = match lst with
        | n::_ -> Cast.lemma_soundness # make_progress n
        | _ -> ()
      in
      let () = x_tinfo_zp (lazy ("before do_full_fold: estate.es_pure: "
                                 ^(Cprinter.string_of_mix_formula estate.es_pure
                                  ))) pos in
      wrap_fn (fun () -> do_full_fold ~root_inst:root_inst prog estate conseq
                  rhs_node rhs_rest rhs_b is_folding pos) ()

    | (Context.M_infer_unfold (r,_,_))->
      let result = x_add InferHP.infer_unfold prog pm_aux r estate lhs_b rhs_b
          (rhs_h_matched_set: CP.spec_var list) pos in
      result
    | Context.M_infer_fold (_,r) ->
      begin
        let result = InferHP.infer_fold prog pm_aux r estate lhs_b rhs_b
            (rhs_h_matched_set: CP.spec_var list) pos in
        result
      end
    | Context.M_unfold ({Context.match_res_lhs_node=lhs_node;
                         Context.match_res_rhs_node=rhs_node;
                        },unfold_num) -> begin
        x_tinfo_hp (add_str "M_unfold" string_of_int) unfold_num pos;
        match lhs_node with
        | HRel (hp,args,_) ->
          let msg = "UnFold on Unknown Pred " in
          (Errctx.mkFailCtx_may x_loc msg estate pos,Unknown)
        | _ ->
          let lhs_var = get_node_var lhs_node in
          (* WN : why is there a need for es_infer_invs *)
          let curr_unfold_num = (get_view_unfold_num lhs_node)+unfold_num in
          if (curr_unfold_num>1) then
            let () = y_tinfo_hp (add_str "curr_unfold_num" string_of_int) curr_unfold_num in
            let err_msg = "ensuring finite unfold" in
            (CF.mkFailCtx_in(Basic_Reason(mkFailContext (* "ensuring finite unfold" *) err_msg estate conseq (get_node_label lhs_node) pos,
                                          CF.mk_failure_must "infinite unfolding" Globals.sl_error, estate.es_trace)) ((convert_to_must_es estate), err_msg, Failure_Must err_msg) (mk_cex true),NoAlias)
          else
            let delta1,_ = unfold_nth 1 (prog,None) estate.es_formula lhs_var
                true unfold_num pos in
            (* update unfold_num *)
            let ctx1 = build_context (Ctx estate) delta1 pos in
            let rec prune_helper c =
              match c with
              | OCtx (c1,c2) -> OCtx(prune_helper c1, prune_helper c2)
              | Ctx es -> Ctx ({es with es_formula = prune_preds prog false es.es_formula})
            in
            (* TODO: prune_helper slows down the spaguetti benchmark *)
            let res_rs, prf1 = x_add heap_entail_one_context 8 prog is_folding
                (prune_helper ctx1) conseq None None None pos in
            let prf = mkUnfold (Ctx estate) conseq lhs_node prf1 in
            (res_rs, prf)
      end
    | Context.M_base_case_unfold {
        Context.match_res_lhs_node = lhs_node;
        Context.match_res_compatible = inst_vs;
        Context.match_res_rhs_node = rhs_node;}->
      let () = y_tinfo_pp "M_base_case_unfold" in
      let () = y_tinfo_hp (add_str "lhs_node" !CF.print_h_formula) lhs_node in
      let () = y_tinfo_hp (add_str "rhs_node" !CF.print_h_formula) rhs_node in
      begin
        match lhs_node with
        | HRel (hp,args,_) ->
          if CF.is_exists_hp_rel hp estate then
            if List.length args <=1 then
              failwith "TBI"
            else
              let vs = List.map CP.exp_to_sv args in
              let () = y_tinfo_hp (add_str "inst_vs"
                                     (pr_list (pr_pair !CP.print_sv !CP.print_sv))) inst_vs in
              x_add do_unfold_hp_rel prog estate lhs_b conseq rhs_node is_folding pos hp vs
          else
            let msg = "Base_Case_UnFold on Unknown Pred (not on inferred list)" in
            (Errctx.mkFailCtx_may x_loc msg estate pos,Unknown)
        | _ ->
          let estate =
            if no_infer_rel estate then estate
            else
              let lhs_h,lhs_p,_,_, _, lhs_a = CF.split_components estate.es_formula in
              let lhs_alias = MCP.ptr_equations_without_null lhs_p in
              let lhs_aset = CP.EMapSV.build_eset lhs_alias in
              (* Assumed lhs_h to be star or view_node or data_node *)
              let lhs_h_list = split_star_conjunctions lhs_h in
              let init_pures =
                List.concat (List.map (fun l -> init_para l rhs_node lhs_aset
                                          prog pos) lhs_h_list) in
              let init_pure = CP.conj_of_list init_pures pos in
              {estate with es_formula = CF.normalize 1 estate.es_formula
                               (CF.formula_of_pure_formula init_pure pos) pos} in
          let ans = do_base_case_unfold_only prog estate.es_formula conseq
              estate lhs_node rhs_node is_folding pos rhs_b in
          (match ans with
           | None ->
             let err_msg = "base_case_unfold failed" in
             (CF.mkFailCtx_in(Basic_Reason(mkFailContext (* "base_case_unfold failed" *) err_msg estate conseq (get_node_label rhs_node) pos
                                          , CF.mk_failure_may "base case unfold failed" Globals.sl_error, estate.es_trace)) ((convert_to_may_es estate), err_msg, Failure_May err_msg) (mk_cex false),NoAlias)
           (*use UNION, so return MUST, final res = latter case*)
           | Some x -> x)
      end
    | Context.M_base_case_fold {
        Context.match_res_rhs_node = rhs_node;
        Context.match_res_rhs_rest = rhs_rest;} ->
      let estate =
        if no_infer_rel estate then estate
        else
          (* WN : what is the purpose of this normalization? *)
          let lhs_h, lhs_p, _, _, _, lhs_a = CF.split_components estate.es_formula in
          let lhs_alias = MCP.ptr_equations_without_null lhs_p in
          let lhs_aset = CP.EMapSV.build_eset lhs_alias in
          (* Assumed lhs_h to be star or view_node or data_node *)
          let lhs_h_list = split_star_conjunctions lhs_h in
          let init_pures = List.concat (List.map (fun l -> init_para l rhs_node
                                                     lhs_aset prog pos)
                                          lhs_h_list) in
          let init_pure = CP.conj_of_list init_pures pos in
          let new_ante = CF.normalize 1 estate.es_formula
              (CF.formula_of_pure_formula init_pure pos) pos in
          {estate with es_formula = new_ante}
      in
      let () = y_tinfo_hp (add_str "estate" Cprinter.string_of_entail_state) estate in
      (* L2: why not do fold? *)
      if (estate.es_cont != []) then
        let err_msg = "try the continuation" in
        (CF.mkFailCtx_in (ContinuationErr
                            (mkFailContext err_msg (estate)
                               (Cformula.formula_of_heap rhs_rest pos)
                               (get_node_label rhs_node) pos,
                             estate.es_trace))
           ((convert_to_may_es estate), err_msg, Failure_May err_msg)
           (mk_cex false), NoAlias)
      else
        (******************)
        (* NO inference for base-case fold *)
        (* Removal of all vars seems to be strong *)
        (* Maybe only the root of view_node *)
        let (cl,prf) = do_base_fold prog estate conseq rhs_node rhs_rest rhs_b is_folding pos
        in (cl,prf)
    | Context.M_seg_fold (m_res, fold_seg_type) ->
      let rhs_node = m_res.Context.match_res_rhs_node in
      let rhs_rest = m_res.Context.match_res_rhs_rest in
      do_seg_fold prog estate estate.es_formula conseq m_res.Context.match_res_lhs_node rhs_node
        rhs_rest lhs_b rhs_b fold_seg_type is_folding rhs_h_matched_set pos
    | Context.M_acc_fold (m_res, fold_seq) ->
      let rhs_node = m_res.Context.match_res_rhs_node in
      let rhs_rest = m_res.Context.match_res_rhs_rest in
      let estate =
        if no_infer_rel estate then estate
        else
          let lhs_h,lhs_p,_,_, _, lhs_a  = CF.split_components estate.es_formula in
          let lhs_alias = MCP.ptr_equations_without_null lhs_p in
          let lhs_aset = CP.EMapSV.build_eset lhs_alias in
          (* Assumed lhs_h to be star or view_node or data_node *)
          let lhs_h_list = split_star_conjunctions lhs_h in
          let init_pures = List.concat (List.map (fun l -> init_para l rhs_node lhs_aset prog pos) lhs_h_list) in
          let init_pure = CP.conj_of_list init_pures pos in
          {estate with es_formula = CF.normalize 1 estate.es_formula (CF.formula_of_pure_formula init_pure pos) pos}
      in
      (* TRUNG TODO IMPORTANT: when ACC_fold success, but the rest can not besure,
         how can check the successful context againt the rest of pure? *)
      let pp_rhs_stk = rhs_pure_stk # get_stk in
      let rhs_p = rhs_b.CF.formula_base_pure in
      let pp_rhs = List.fold_left (fun acc p ->  (CP.mkAnd  acc (MCP.pure_of_mix
                                                                   p) pos))
          (MCP.pure_of_mix rhs_p) pp_rhs_stk in
      let tmp_rhs =  pp_rhs in
      x_tinfo_hp (add_str "fold_op, tmp_rhs" !CP.print_formula) tmp_rhs pos;
      let rhs_p = MCP.mix_of_pure tmp_rhs in
      let rhs_b = { rhs_b with CF.formula_base_pure = rhs_p} in

      do_acc_fold prog estate conseq rhs_node rhs_rest rhs_b fold_seq is_folding pos

    | Context.M_lhs_case {
        Context.match_res_lhs_node = lhs_node;
        Context.match_res_rhs_node = rhs_node;}->
      let ans = do_lhs_case prog estate.es_formula conseq estate lhs_node rhs_node is_folding pos in
      (match ans with
       | None ->
         let err_msg = "lhs_case failed" in
         (CF.mkFailCtx_in
            (Basic_Reason(mkFailContext err_msg estate conseq
                            (get_node_label rhs_node) pos,
                          CF.mk_failure_must "lhs case analysis failed"
                            Globals.sl_error, estate.es_trace))
            ((convert_to_must_es estate), err_msg, Failure_Must err_msg)
            (mk_cex true), NoAlias)
       | Some x -> x)

    | Context.M_rd_lemma {
        Context.match_res_lhs_node = lhs_node;
        Context.match_res_lhs_rest = lhs_rest;
        Context.match_res_rhs_node = rhs_node;
        Context.match_res_rhs_rest = rhs_rest;
      } ->
      let r1,r2 = x_add do_coercion prog None estate conseq lhs_rest rhs_rest
          lhs_node lhs_b rhs_b rhs_node is_folding pos in
      (r1,Search r2)
    | Context.M_ramify_lemma {
        Context.match_res_lhs_node = lhs_node;
        Context.match_res_lhs_rest = lhs_rest;
        Context.match_res_rhs_node = rhs_node;
        Context.match_res_rhs_rest = rhs_rest;
      } ->
      let ctx0 = Ctx estate in
      let helper coer estate =
        try
          let r1,r2 =
            if coer.coercion_kind = RLEM then
              let rest_heap = split_star_conjunctions lhs_rest in
              let filter_starminus = List.filter (fun h -> Mem.contains_starminus h) rest_heap in
              let lhs_wand =
                if not (List.length filter_starminus > 0)
                then failwith "Ramification Lemma has more than one wand"
                else List.hd filter_starminus in
              let lhs_h,lhs_p,lhs_vp,lhs_t,lhs_fl,lhs_a = extr_formula_base lhs_b in
              let filter_sm = List.filter
                  (fun h -> if (Mem.contains_starminus h) then false
                    else if (is_data h) then
                      if List.exists (fun c -> CP.eq_spec_var c (get_node_var h)) (h_fv lhs_wand)
                      then true else false else true) (split_star_conjunctions lhs_h) in
              let rest_heap = List.filter
                  (fun h -> if (Mem.contains_starminus h) then false
                    else
                    if (is_view h) ||
                       ((is_data h) &&
                        List.exists (fun c -> CP.eq_spec_var c (get_node_var h)) (h_fv lhs_wand))
                    then false else true) rest_heap in
              let wand_head = match lhs_wand with
                | StarMinus({h_formula_starminus_h1 = h1;
                             h_formula_starminus_h2 = h2})-> h2
                | _ -> lhs_wand in
              let wand_head_var_lst = h_fv wand_head in
              if (List.length filter_sm >0)
              then
                (*  try *)
                let rhs = List.hd filter_sm in
                let fvl = x_add_1 Cformula.h_fv rhs in
                let check_h,check_p,_,_,_,_ = split_components coer.coercion_head in
                let check_h_len = List.length (List.filter (fun h -> is_data(h))
                                                 (split_all_conjunctions check_h
                                                 )) in
                let lhs_rest_len = List.length (List.filter (fun h -> is_data(h)
                                                            )
                                                  (split_all_conjunctions
                                                     lhs_rest)) in
                let check_p = if true then
                    Mcpure.mix_of_pure (CP.join_conjunctions
                                          (List.filter (fun c ->
                                               CP.is_RelForm c
                                               || CP.contains_exists c)
                                              (CP.split_conjunctions
                                                 (Mcpure.pure_of_mix check_p))))
                  else failwith "Ramification Lemma failed heap guard checking" in
                let h,p,vp,fl,t,a = split_components coer.coercion_body in
                let vl = x_add_1 Cformula.h_fv h in
                let fresh_vl = CP.fresh_spec_vars vl in
                let h = Cformula.h_subst (List.combine vl fresh_vl) h in
                let check_p = Mcpure.memo_subst (List.combine vl fresh_vl) check_p in
                let gvl = x_add_1 Cformula.h_fv lhs_wand in
                let abs_vl = List.filter (fun c -> CP.is_void_typ c) gvl in
                let rl = List.hd (gvl) in
                let rl2 = List.hd (List.tl gvl) in
                let fl2 = List.hd (List.tl fvl) in
                let gvl = fvl@[rl]@[rl2] in
                let abs_vl = abs_vl in
                let check_p_vl = CP.fv (Mcpure.pure_of_mix check_p) in
                let check_p_vl = List.filter (fun c -> not(CP.is_rel_typ c)) check_p_vl in
                let rho2 = if List.length check_p_vl = List.length abs_vl
                  then List.combine check_p_vl abs_vl
                  else if List.length check_p_vl
                          =  List.length ((List.hd abs_vl)::[List.hd gvl]@[fl2])
                  then List.combine check_p_vl ((List.hd abs_vl)::[List.hd gvl]@[fl2])
                  else []  in
                let gvl = if (List.length rho2)=0 then fvl@abs_vl else gvl in
                let gvl_2 = List.filter (fun h -> is_data h) (split_all_conjunctions lhs_wand) in
                let rho = if List.length fresh_vl = List.length gvl then
                    let fresh_vl_1 = List.sort CP.compare_spec_var fresh_vl in
                    let gvl_1 = List.sort CP.compare_spec_var gvl in List.combine fresh_vl_1 gvl_1
                  else
                  if List.length gvl_2 > 0
                  && List.length ((h_fv (List.hd gvl_2))@[fl2]@[fl2])
                     == List.length fresh_vl
                  then
                    List.combine fresh_vl ((h_fv (List.hd gvl_2))@[fl2]@[fl2])
                  else failwith "Ramification Lemma with different variables" in
                let rho2 = if List.length rho2 > 0 then rho2 else
                  if List.length check_p_vl
                     == List.length ((List.hd abs_vl)::wand_head_var_lst) then
                    List.combine check_p_vl ((List.hd abs_vl)::wand_head_var_lst)
                  else try
                      let gvl2_vl =  (h_fv (List.hd gvl_2)) in
                      let v = if(List.length fvl == List.length gvl2_vl)
                        then List.hd (List.tl gvl) else List.hd (List.tl gvl2_vl
                                                                )in
                      let g' = if(List.length fvl == List.length gvl2_vl)
                        then rl2 else List.hd (List.tl gvl) in
                      let g = List.hd abs_vl in
                      let check_p_vl = List.sort CP.compare_spec_var check_p_vl in
                      let fix_lem_vl = g::(List.sort CP.compare_spec_var (v::gvl2_vl@[g']))  in
                      List.combine check_p_vl fix_lem_vl
                    with _ -> failwith "Lemma too complex" in
                let check_p = Mcpure.memo_subst rho2 check_p in
                let lhs_p,_,_ = xpure 111 prog (Cformula.mkBase lhs_h lhs_p
                                                  lhs_vp lhs_t lhs_fl lhs_a
                                                  no_pos) in
                let f = simple_imply (Mcpure.pure_of_mix lhs_p) (Mcpure.pure_of_mix check_p) in
                let new_lhs_h = if (not(f)  (*&& List.length rho2>0*))
                  then failwith "Ramification Lemma failed guard checking"
                  else Cformula.h_subst rho h in
                let new_lhs_p = Mcpure.memo_subst rho lhs_p in
                let new_lhs_h = Cformula.join_star_conjunctions (new_lhs_h::rest_heap) in
                let new_lhs = Cformula.mkBase new_lhs_h new_lhs_p lhs_vp lhs_t
                    lhs_fl lhs_a no_pos in
                let old_trace = estate.es_trace in
                let estate = {estate with es_trace=(("(ramify: " ^ coer.coercion_name ^ ")")::old_trace)} in
                let new_ctx1 = Ctx{estate with es_formula = new_lhs } in
                let new_ctx = SuccCtx[((* set_context_must_match *) new_ctx1)] in
                let res, tmp_prf = heap_entail prog is_folding new_ctx conseq pos in
                let prf = mkCoercionLeft ctx0 conseq coer.coercion_head
                    coer.coercion_body tmp_prf coer.coercion_name
                in
                (res, [prf])
              else
                let err_msg = "no suitable ramify lemma" in
                (CF.mkFailCtx_in( Basic_Reason ( {
                     fc_message = err_msg;
                     fc_current_lhs = estate;
                     fc_current_ents = [];
                     fc_prior_steps = estate.es_prior_steps;
                     fc_orig_conseq = estate.es_orig_conseq;
                     fc_current_conseq = CF.formula_of_heap HFalse pos;
                     fc_failure_pts = match (get_node_label lhs_node) with | Some s-> [s] | _ -> [];},
                     CF.mk_failure_must "112" Globals.sl_error ,estate.es_trace)
                   ) ((convert_to_must_es estate), err_msg, Failure_Must err_msg
                     ) (mk_cex true),
                 [])
            else
              let err_msg = "failed ramify lemma application" in
              (CF.mkFailCtx_in( Basic_Reason ( {
                   fc_message = err_msg;
                   fc_current_ents = [];
                   fc_current_lhs = estate;
                   fc_prior_steps = estate.es_prior_steps;
                   fc_orig_conseq = estate.es_orig_conseq;
                   fc_current_conseq = CF.formula_of_heap HFalse pos;
                   fc_failure_pts = match (get_node_label lhs_node) with | Some s-> [s] | _ -> [];},
                   CF.mk_failure_must "113" Globals.sl_error,estate.es_trace))
                  ((convert_to_must_es estate), err_msg, Failure_Must err_msg)
                  (mk_cex true),
               [])
          in
          (r1,r2)
        with _ -> let err_msg = "failed ramify lemma application continue search" in
          (CF.mkFailCtx_in( Basic_Reason ( {
               fc_message = err_msg;
               fc_current_ents = [];
               fc_current_lhs = estate;
               fc_prior_steps = estate.es_prior_steps;
               fc_orig_conseq = estate.es_orig_conseq;
               fc_current_conseq = CF.formula_of_heap HFalse pos;
               fc_failure_pts = match (get_node_label lhs_node) with | Some s-> [s] | _ -> [];},
               CF.mk_failure_must "115" Globals.sl_error,estate.es_trace))
              ((convert_to_must_es estate), err_msg, Failure_Must err_msg)
              (mk_cex true),
           [])
      in
      let coer_l = Lem_store.all_lemma # get_left_coercion in
      let r1,r2 = if not (List.length coer_l > 0) then failwith "No Ramification Lemma to use"
        else let lc = List.map (fun coer -> helper coer estate) coer_l in
          try List.find (fun (sc,pf) -> match sc with
              | FailCtx _ -> false
              | SuccCtx _ -> true) lc
          with _ -> let err_msg = "failed ramify lemma application" in
            (CF.mkFailCtx_in( Basic_Reason ( {
                 fc_message = err_msg;
                 fc_current_ents = [];
                 fc_current_lhs = estate;
                 fc_prior_steps = estate.es_prior_steps;
                 fc_orig_conseq = estate.es_orig_conseq;
                 fc_current_conseq = CF.formula_of_heap HFalse pos;
                 fc_failure_pts = match (get_node_label lhs_node) with | Some s-> [s] | _ -> [];},
                 CF.mk_failure_must "114" Globals.sl_error,estate.es_trace))
                ((convert_to_must_es estate), err_msg, Failure_Must err_msg)
                (mk_cex true),
             [])
      in (r1,Search r2)
    | Context.M_lemma  ({
        Context.match_res_lhs_node = lhs_node;
        Context.match_res_lhs_rest = lhs_rest;
        Context.match_res_rhs_node = rhs_node;
        Context.match_res_rhs_rest = rhs_rest;
      },coerc_opt,do_infer) ->
      let () = y_dinfo_hp (add_str "M_lemma"
                             (pr_opt Cprinter.string_of_coerc_short)) coerc_opt
      in
      let () = match coerc_opt with
        | Some coer ->
          let vs = coer.coercion_univ_vars in
          if vs!=[] then
            let () = y_tinfo_hp (add_str "M_lemma" (Cprinter.string_of_coerc_short)) coer in
            y_tinfo_hp (add_str "to add univ_vars" !CP.print_svl) vs
        | None -> () in
      let (estate,conseq,rhs_rest,rhs_node,rhs_b) =
        if do_infer==0 then
          (estate,conseq,rhs_rest,rhs_node,rhs_b)
        else if do_infer==1 then
          let n_estate = InferHP.infer_collect_hp_rel_unfold_lemma_guided prog
              do_infer estate lhs_node rhs_node rhs_rest rhs_h_matched_set lhs_b
              rhs_b conseq coerc_opt pos in
          (n_estate,conseq,rhs_rest,rhs_node, rhs_b)
        else
          let () = x_tinfo_hp (add_str  "conseq (before)" Cprinter.string_of_formula) conseq pos in
          let () = x_tinfo_hp (add_str  "estate.CF.es_formula"
                                 Cprinter.string_of_formula)
              estate.CF.es_formula  pos in
          let () = x_tinfo_hp (add_str  "rhs_b" Cprinter.string_of_formula_base ) rhs_b pos in
          let (n_estate,n_conseq,n_rhs_rest,n_rhs_node, rhs_b) =
            InferHP.infer_collect_hp_rel_fold_lemma_guided prog do_infer estate
              lhs_node rhs_node rhs_rest rhs_h_matched_set lhs_b rhs_b conseq
              coerc_opt pos in
          (n_estate,n_conseq,n_rhs_rest,n_rhs_node, rhs_b)
      in
      let () = x_dinfo_hp (add_str  "rhs_node" Cprinter.string_of_h_formula) rhs_node pos in
      let () = x_dinfo_hp (add_str  "rhs_rest" Cprinter.string_of_h_formula) rhs_rest pos in
      let () = x_dinfo_hp (add_str  "rhs_b" Cprinter.string_of_formula_base ) rhs_b pos in
      let () = x_dinfo_hp (add_str  "conseq" Cprinter.string_of_formula) conseq pos in
      let () = x_dinfo_hp (add_str  "es_infer_vars_hp_rel" !CP.print_svl)
          estate.CF.es_infer_vars_hp_rel pos in
      let r1,r2 = x_add do_coercion prog coerc_opt estate conseq lhs_rest
          rhs_rest lhs_node lhs_b rhs_b rhs_node is_folding pos in
      (r1,Search r2)
    | Context.Undefined_action mr ->
      let err_msg = "undefined action" in
      (CF.mkFailCtx_in
         (Basic_Reason (mkFailContext err_msg estate (Base rhs_b) None pos,
                        CF.mk_failure_must "undefined action" Globals.sl_error,
                        estate.es_trace))
         ((convert_to_must_es estate), err_msg, Failure_Must err_msg)
         (mk_cex true), NoAlias)
    | Context.M_Nothing_to_do s ->
      let err_msg = "Nothing_to_do?"^ s in
      let res = (CF.mkFailCtx_in (
          Basic_Reason (mkFailContext s estate (Base rhs_b) None pos,
                        CF.mk_failure_may ("Nothing_to_do?"^s) Globals.sl_error,
                        estate.es_trace))
          ((convert_to_may_es estate), err_msg, Failure_May err_msg)
          (mk_cex false), NoAlias) in
      if (!Globals.delay_proving_sat) then
        let n_ctx = x_add elim_unsat_es_now 13 prog (ref 2) estate in
        if isAnyFalseCtx n_ctx then (SuccCtx [n_ctx], UnsatAnte)
        else res
      else res
    (* to Thai : please move inference code from M_unmatched_rhs here
       and then restore M_unmatched_rhs to previous code without
       any inference *)
    | Context.M_infer_heap (iact, lhs_node,rhs,rhs_rest) ->
      let msg = "M_infer_heap :"^(Cprinter.string_of_h_formula rhs) in
      begin
        let () = y_tinfo_hp (add_str "estate" !CF.print_entail_state) estate in
        let (contra, _, lc, prf ) = early_pure_contra_detection 13 prog estate
            conseq pos msg is_folding in

        let do_match () =
          let (cl,_) as first_heap_r = do_infer_heap rhs rhs_rest caller prog
              estate conseq lhs_b rhs_b a (rhs_h_matched_set:CP.spec_var list)
              is_folding pos in
          let () = y_tinfo_hp (add_str "cl" !CF.print_list_context) cl in
          let res = (CF.isFailCtx) cl in
          if not(res) then first_heap_r
          else
            let (res, new_estate, n_lhs, n_es_heap_opt, oerror_es, rhs_rest_opt) =
              x_add (InferHP.infer_collect_hp_rel ~caller:(x_loc ^ ":" ^ caller)
                    ) 1 prog iact estate lhs_node rhs rhs_rest rhs_h_matched_set
                lhs_b rhs_b pos in
            let () = y_tinfo_hp (add_str "new_estate" !CF.print_entail_state) new_estate in
            if (not res) then (* r *)
              let err_msg = "infer_heap_node" in
              let conseq = Some (Base rhs_b) in
              (Errctx.mkFailCtx_may ~conseq:conseq (x_loc^"infer_collect_hp_rel"
                                                   ) err_msg estate pos,NoAlias)
            else
              let n_rhs_rest = match rhs_rest_opt with
                | None -> rhs_rest
                | Some hf -> CF.mkStarH rhs_rest hf no_pos in
              let n_rhs_b =  (Base {rhs_b with formula_base_heap = n_rhs_rest}) in
              let res_es0, prf0 = match n_es_heap_opt with
                | None ->
                  (* TODO:WN should not schedule a do_match here *)
                  (* problem for bugs/ex55e.slk ex55f.slk without do_match *)
                  (* this match not scheduled by compute *)
                  (* needed since we may generate H(..) --> x::node<..>*H2(..) *)
                  if !Globals.old_do_match_infer_heap || !Globals.warn_do_match_infer_heap then
                    let () = y_tinfo_pp "do_match after infer_heap" in
                    let () = y_tinfo_hp (add_str "rhs_h_matched set" !
                                           CP.print_svl) rhs_h_matched_set  in
                    let () = y_tinfo_hp (add_str "lhs_h" !CF.print_h_formula) n_lhs  in
                    let () = y_tinfo_hp (add_str "rhs_h" !CF.print_h_formula) rhs  in
                    let () = y_tinfo_hp (add_str "rhs_rest" !CF.print_h_formula) n_rhs_rest  in
                    if !Globals.warn_do_match_infer_heap then
                      failwith "do_match during infer_heap"
                    else
                      let new_holes = Gen.BList.difference_eq
                          (fun (_,id1) (_, id2) -> id1 = id2)
                          new_estate.es_crt_holes estate.es_crt_holes in
                      let match_act =
                        Context.M_match (x_add (Context.mk_match_res ~holes:
                                                  new_holes Root) n_lhs
                                           (List.hd (CF.heap_of
                                                       new_estate.CF.es_formula)
                                           ) rhs n_rhs_rest) in
                      (* Below causes a problem with str-inf/ex10a2-str-while.ss *)
                      let () = y_tinfo_pp "call process_act instead call do_match directly" in
                      let n_lhs_b = { lhs_b with CF.formula_base_heap = n_lhs } in
                      let n_rhs_b1 = { rhs_b with formula_base_heap = n_rhs_rest } in
                      x_add (process_action ~caller:(x_loc ^ ":" ^ caller)) 2
                        cont_act prog new_estate conseq n_lhs_b n_rhs_b1
                        match_act rhs_h_matched_set is_folding pos
                  else let new_ctx = Ctx new_estate in
                    x_add heap_entail_conjunct 29 prog is_folding new_ctx
                      n_rhs_b (rhs_h_matched_set) pos
                | Some hf ->
                  let new_es = {new_estate with CF.es_heap = hf} in
                  let new_ctx = Ctx (CF.add_to_estate new_es "infer: rhs: unkown pred") in
                  x_add heap_entail_conjunct 28 prog is_folding new_ctx n_rhs_b
                    (rhs_h_matched_set) pos
              in
              let res_es1=
                match res_es0 with
                | FailCtx _ -> res_es0
                | SuccCtx cl0 -> begin
                    match oerror_es with
                    | None -> res_es0
                    | Some e_es -> SuccCtx (cl0@[(Ctx e_es)])
                  end
              in
              (res_es1,prf0) in
        if (contra) then
          match (lc, prf) with
          | Some lc, Some prf -> (lc,prf)
          | _, _ ->  do_match ()
        else do_match ()
      end
    | Context.M_unmatched_rhs_data_node (rhs, rhs_rest,vp_set) ->
      (******************************************************************)
      begin
        let lhs_xpure,_,_ = x_add xpure 12 prog estate.es_formula in
        (* Thai: change back to Infer.infer_pure *)
        let () = x_tinfo_hp (add_str "unmatched rhs" Cprinter.string_of_h_formula) rhs no_pos in
        let () = x_tinfo_hp (add_str "rhs_rest" Cprinter.string_of_h_formula) rhs_rest no_pos in
        let () = y_tinfo_hp (add_str "lhs formula" Cprinter.string_of_formula) estate.es_formula in
        let lhs_vp_set = CF.get_vperm_set estate.es_formula in
        let () = y_tinfo_hp (add_str "lhs_vp_set" Cprinter.string_of_vperm_sets) lhs_vp_set in
        let () = x_tinfo_hp (add_str "vp_set" Cprinter.string_of_vperm_sets) vp_set no_pos in
        let par_flag = estate.CF.es_infer_obj # is_par_all in
        let ver_post_flag = estate.CF.es_infer_obj # is_ver_post_all in
        let classic_flag = estate.CF.es_infer_obj # is_classic_all in
        let resopt,res_vps = Vperm.vperm_entail_set ~par_flag:par_flag
            ~ver_post_flag:ver_post_flag ~classic_flag:classic_flag lhs_vp_set
            vp_set in
        match resopt with
        | Some msg ->
          let fctx = Vperm.mkFailCtx_vp msg estate conseq pos in
          fctx,NoAlias
        | None ->
          let res_f = Vperm.set_vperm_sets_formula res_vps estate.es_formula in
          let estate = { estate with es_formula = res_f; } in
          let conseq = CF.write_vperm_set conseq CVP.empty_vperm_sets in
          let rhs_node = match rhs with
            | DataNode n -> n.h_formula_data_node
            | ViewNode n -> n.h_formula_view_node
            (* TODO:WN:HVar *)
            | HVar (v,_) -> v
            | HRel (hrel,_,_) -> hrel
            | _ -> report_error pos "Expect a node"
          in
          enulalias := true;
          let lhs_alias = MCP.ptr_equations_with_null lhs_xpure in
          enulalias := false;
          let lhs_aset = CP.EMapSV.build_eset lhs_alias in
          let rhs_als = CP.EMapSV.find_equiv_all rhs_node lhs_aset @ [rhs_node] in
          let msg = "do_unmatched_rhs :"^(Cprinter.string_of_h_formula rhs) in
          let () = x_tinfo_hp (add_str "rhs_als" Cprinter.string_of_spec_var_list) rhs_als no_pos in
          let r, relass =
            if CP.intersect rhs_als estate.es_infer_vars = []
            && List.exists CP.is_node_typ estate.es_infer_vars then None,[]
            else if (!Globals.pa) then None,[]
            else
              let lhs_rhs_contra_flag =
                let rhs_xpure,_,_ = x_add xpure 13 prog conseq in
                let p_lhs_xpure = MCP.pure_of_mix lhs_xpure in
                let p_rhs_xpure = MCP.pure_of_mix rhs_xpure in
                let contr, _ = x_add Infer.detect_lhs_rhs_contra p_lhs_xpure p_rhs_xpure no_pos in
                contr
              in (* Cristian : to detect_lhs_rhs_contra *)
              if lhs_rhs_contra_flag then (None,[])
              else Infer.infer_lhs_contra_estate 5 estate lhs_xpure pos msg
          in
          begin
            let () = y_tinfo_hp (add_str "lhs contra?"
                                   (pr_opt (fun (_,f) -> !CP.print_formula f)))
                r in
            match r with
            | Some (new_estate, pf) ->
              begin
                match relass with
                | [] ->
                  (* explicitly force unsat checking to be done here *)
                  let ctx1 = (x_add elim_unsat_es_now 9 prog (ref 1) new_estate) in
                  let r1, prf = x_add heap_entail_one_context 9 prog is_folding ctx1 conseq None None None pos in
                  let r1 = x_add add_infer_pure_to_list_context [pf] r1 in
                  (r1,prf)
                | [(_,h,_)] ->
                  (* explicitly force unsat checking to be done here *)
                  let ctx1 = (x_add elim_unsat_es_now 10 prog (ref 1) new_estate) in
                  let r1, prf = x_add heap_entail_one_context 9 prog is_folding
                      ctx1 conseq None None None pos in
                  let r1 = x_add add_infer_pure_to_list_context [pf] r1 in
                  let r1 = add_infer_rel_to_list_context h r1 in
                  (r1,prf)
                | _ -> report_error pos "Length of relational assumption list > 1"
              end
            | None ->
              begin
                match relass with
                | [] -> (
                    if no_infer_all_all estate then
                      let l_h, l_p, l_vp, l_fl, l_t, l_a = CF.split_components estate.es_formula in
                      let is_mem = Gen.BList.mem_eq CP.eq_spec_var in
                      let () = y_tinfo_hp (add_str "lhs heap" !CF.print_h_formula) l_h in
                      let hv = match l_h with
                        (* TODO:WN:HVar *)
                        | HVar (v,hvar_vs) ->
                          let gen_impl_vars = estate.es_gen_impl_vars in
                          let () = y_tinfo_hp (add_str "HVar v" !CF.print_sv) v in
                          let () = y_tinfo_hp (add_str "gen_impl_vars" !
                                                 CF.print_svl) gen_impl_vars in
                          if (is_mem v gen_impl_vars) || !Globals.contra_ho_flag
                          then Some v else None
                        | _ -> None
                      in
                      match hv with
                      | None ->
                        begin match rhs with
                          | DataNode _ | ViewNode _ ->
                            (*demo/ex21e2*)
                            let lhs_null_ptrs = Cformula.get_null_svl estate.es_formula in
                            let () =  Debug.ninfo_hprint
                                (add_str "rhs" Cprinter.string_of_h_formula) rhs
                                pos in
                            let root = Cformula.get_ptr_from_data rhs in
                            let () =  Debug.ninfo_hprint
                                (add_str "lhs_null_ptrs" !CP.print_svl)
                                lhs_null_ptrs pos in
                            let flag1 =  (not (CF.is_unknown_f estate.es_formula
                                              )) && (CP.mem_svl root
                                                       (CF.fv estate.es_formula)
                                                    )
                                         && ((Cfutil.is_empty_heap_f
                                                estate.es_formula)
                                             || CP.mem_svl root lhs_null_ptrs)
                            in
                            let flag2 = not ( estate.es_infer_obj # is_err_may_all) in
                            if flag1 && flag2 then
                              let msg = msg ^ "(must)" in
                              let must_estate = {
                                estate
                                with es_formula
                                     = CF.substitute_flow_into_f !error_flow_int estate.es_formula
                              } in
                              let ft = (
                                Basic_Reason
                                  (mkFailContext msg must_estate (Base rhs_b)
                                     None pos,
                                   CF.mk_failure_must (msg) sl_error, estate.es_trace)) in
                              (CF.mkFailCtx_in ft
                                 ((convert_to_must_es must_estate), msg,
                                  Failure_Must msg) (mk_cex true), NoAlias)
                            else
                              (*/sa/error/ex2.slk: unmatch rhs: may failure *)
                            if flag1 && not flag2 then
                              (* fail-must msg but fail-may ctx *)
                              let msg = msg ^ "(must)" in
                              let may_estate
                                = {estate with
                                   es_formula = CF.substitute_flow_into_f !
                                       mayerror_flow_int estate.es_formula} in
                              let ft =
                                (Basic_Reason (mkFailContext msg may_estate
                                                 (Base rhs_b) None pos,
                                               CF.mk_failure_may (msg) sl_error,
                                               estate.es_trace)) in
                              (CF.mkFailCtx_in ft ((convert_to_may_es may_estate
                                                   ), msg, Failure_May msg)
                                 (mk_cex false), NoAlias)
                            else
                              let msg = msg ^ "(may)" in
                              let may_estate
                                = {estate with
                                   es_formula = CF.substitute_flow_into_f !
                                       mayerror_flow_int estate.es_formula} in
                              let ft = (
                                Basic_Reason (mkFailContext msg may_estate
                                                (Base rhs_b) None pos,
                                              CF.mk_failure_may (msg) sl_error,
                                              estate.es_trace)) in
                              (CF.mkFailCtx_in ft ((convert_to_may_es may_estate
                                                   ), msg, Failure_May msg)
                                 (mk_cex false), NoAlias)
                          (* TODO:WN:HVar *)
                          | HVar (v,hvar_vs) ->
                            (* Do the instantiation for the HVar v *)
                            let succ_estate =
                              if (is_mem v estate.CF.es_gen_impl_vars)
                              && (CF.is_emp_heap rhs_rest) then
                                let bind_f = estate.CF.es_formula in
                                match bind_f with
                                | CF.Base base_f ->
                                  let lhs_xpure, _, _ = x_add xpure_symbolic 20
                                      prog estate.es_formula in
                                  let lhs_rest = CF.Base {
                                      base_f with CF.formula_base_heap = CF.HEmp;
                                                  CF.formula_base_pure = lhs_xpure; }
                                  in
                                  let heap_args = CF.collect_all_heap_vars_formula bind_f in
                                  let pure_f = base_f.CF.formula_base_pure in
                                  let rel_pure_f = MCP.get_rel_ctr pure_f heap_args in
                                  let rel_bind_f = CF.Base {
                                      base_f with CF.formula_base_pure = rel_pure_f; } in
                                  let pr = pr_pair Cprinter.string_of_spec_var
                                      Cprinter.string_of_formula in
                                  let () = x_tinfo_hp
                                      (add_str "old ho_vars_map (1)" (pr_list pr
                                                                     ))
                                      estate.es_ho_vars_map no_pos in
                                  let () = x_tinfo_hp
                                      (add_str "new ho_var to added (1)" pr)
                                      (v,rel_bind_f) no_pos in
                                  let succ_es = { estate with
                                                  CF.es_formula = lhs_rest;
                                                  CF.es_ho_vars_map
                                                  = [(v, rel_bind_f)]
                                                    @ estate.es_ho_vars_map; }
                                  in
                                  Some succ_es
                                | _ -> None
                              else None
                            in
                            (match succ_estate with
                             | Some es ->
                               let new_ctx = CF.Ctx (CF.add_to_estate es "binding of ho var") in
                               let new_rhs_base =
                                 CF.Base {
                                   rhs_b with
                                   formula_base_heap = rhs_rest;
                                   formula_base_vperm = CVP.empty_vperm_sets }
                               in
                               heap_entail_conjunct 18 prog is_folding new_ctx
                                 new_rhs_base (rhs_h_matched_set @ [v]) pos
                             | None ->
                               let may_estate
                                 = { estate with
                                     es_formula = CF.substitute_flow_into_f !
                                         mayerror_flow_int estate.es_formula} in
                               (CF.mkFailCtx_in
                                  (Basic_Reason (mkFailContext msg may_estate
                                                   (Base rhs_b) None pos,
                                                 CF.mk_failure_may (msg)
                                                   sl_error, estate.es_trace))
                                  ((convert_to_may_es estate), msg,
                                   Failure_May msg) (mk_cex false), NoAlias))
                          | _ ->
                            let () = y_dinfo_pp "to handle hprel?" in
                            let may_estate = {
                              estate with es_formula = CF.substitute_flow_into_f
                                              !mayerror_flow_int
                                              estate.es_formula} in
                            (CF.mkFailCtx_in
                               (Basic_Reason (mkFailContext msg may_estate
                                                (Base rhs_b) None pos,
                                              CF.mk_failure_may (msg) sl_error,
                                              estate.es_trace))
                               ((convert_to_may_es estate), msg, Failure_May msg
                               ) (mk_cex false), NoAlias)
                        end
                      | Some v ->
                        let r_h, r_p, r_vp, r_fl, r_t, r_a = CF.split_components conseq in
                        let heap_args = CF.collect_all_heap_vars_formula conseq in
                        let rel_r_p, irrel_r_p = MCP.partition_mix_formula r_p
                            (fun m -> Gen.BList.overlap_eq CP.eq_spec_var
                                m.Mcpure_D.memo_group_fv heap_args) in
                        let rel_bind_f = CF.mkBase r_h rel_r_p r_vp r_t r_fl r_a pos in
                        let pr = pr_pair Cprinter.string_of_spec_var Cprinter.string_of_formula in
                        let () = x_dinfo_hp (add_str "old ho_vars_map (2)"
                                               (pr_list pr))
                            estate.es_ho_vars_map no_pos in
                        let () = x_dinfo_hp (add_str "new ho_var to added (2)"
                                               pr) (v, rel_bind_f) no_pos in
                        let succ_estate = {
                          estate with CF.es_formula = CF.mkBase HEmp l_p l_vp l_t l_fl l_a pos;
                                      CF.es_ho_vars_map
                                      = [(v, rel_bind_f)]
                                        @ estate.es_ho_vars_map;
                        } in
                        let new_ctx = CF.Ctx (CF.add_to_estate succ_estate "binding of ho var") in
                        let new_rhs_base = CF.mkBase HEmp irrel_r_p r_vp r_t r_fl r_a pos in
                        x_add heap_entail_conjunct 19 prog is_folding new_ctx
                          new_rhs_base (rhs_h_matched_set @ [v]) pos
                    else
                      let () = y_winfo_pp "TODO: schedule infer_empty_hp_rel?" in
                      let base_lhs = lhs_b in
                      let _, pure_rhs, _, _, _, _ = CF.split_components conseq in

                      let outcome = match rhs,rhs_rest with
                        | HRel (hp,args,_),HEmp ->
                          let add_pr str pr =
                            fun e ->
                              let () = print_endline_quiet ("Start of "^str) in
                              let () = pr e in
                              ("End of "^str)
                          in
                          (* check if hp in infer list *)
                          if Cf_ext.EState.is_infer_hp_rel estate hp then
                            let () = y_dinfo_hp (add_str "HRel" !CP.print_sv) hp in
                            let () = y_dinfo_hp (add_pr "es_infer_vars"
                                                   Cf_ext.EState.show_infer_vars
                                                ) estate in
                            let rel = CP.mkRel hp args no_pos in
                            let pure_rhs = MCP.merge_mix_w_pure pure_rhs rel  in
                            (* add a new unknown relation to RHS *)
                            let estate = Cf_ext.EState.add_infer_rel estate hp in
                            let ctx, proof = x_add heap_entail_empty_rhs_heap 8
                                prog conseq is_folding estate base_lhs pure_rhs
                                rhs_h_matched_set pos in
                            let () = y_winfo_pp "TODO: to convert Rel -> HRel" in
                            let ctx = ctx in
                            (* TODO: transform pure relation to heap relation *)
                            Some (ctx, proof)
                          else None
                        (* failwith x_tbi  *)
                        | _ -> None in
                      match outcome with
                      | Some r -> r
                      | None ->
                        let (lc,_) as first_r = do_infer_heap rhs rhs_rest
                            caller prog estate conseq lhs_b rhs_b a
                            (rhs_h_matched_set:CP.spec_var list) is_folding pos
                        in
                        if not(CF.isFailCtx lc) then first_r
                        else
                          let () =  Debug.ninfo_hprint
                              (add_str "Infer.infer_collect_hp_rel" pr_id)
                              "xxxxx 2" pos in
                          let (res,new_estate,n_lhs, n_es_heap_opt, oerror_es, rhs_rest_opt) =
                            x_add (InferHP.infer_collect_hp_rel ~caller:x_loc) 2
                              prog 0 estate HEmp rhs rhs_rest rhs_h_matched_set
                              lhs_b rhs_b pos in
                          if (not res) then
                            let msg = "infer_heap_node" in
                             (* "infer_heap_node" *)
                            (CF.mkFailCtx_in (Basic_Reason (mkFailContext msg
                                                              estate (Base rhs_b
                                                                     ) None pos,
                                                            CF.mk_failure_may
                                                              ("M_unmatched_rhs
                      (infer_collect_hp_rel 3b)") sl_error, estate.es_trace))
                      ((convert_to_may_es estate), msg, Failure_May msg) (mk_cex
                      false), NoAlias)
                          else
                            (*subt the fresh evars for rhs*)
                            let n_rhs_rest = match rhs_rest_opt with
                              | None -> rhs_rest
                              | Some hf -> CF.mkStarH rhs_rest hf no_pos in
                            let n_rhs_b = (Base {rhs_b with formula_base_heap = n_rhs_rest}) in
                            let () = x_dinfo_hp
                                (add_str "new_estate(M_unmatched_rhs_data_node)"
                                   (Cprinter.string_of_entail_state)) new_estate
                                pos in
                            let res_es0, prf0 = match n_es_heap_opt with
                              | None ->
                                x_add do_match prog new_estate n_lhs rhs n_rhs_b
                                  rhs_h_matched_set is_folding pos
                              | Some hf -> let new_es = {new_estate with CF.es_heap = hf} in
                                let new_ctx = Ctx (CF.add_to_estate new_es
                                                     "infer: rhs: unkown pred")
                                in
                                heap_entail_conjunct 28 prog is_folding new_ctx
                                  n_rhs_b (rhs_h_matched_set) pos
                            in
                            (res_es0,prf0)
                  )
                | [(h1,h2,_)] ->
                  (* explicitly force unsat checking to be done here *)
                  let ctx1 = (x_add elim_unsat_es_now 11 prog (ref 1) h1) in
                  let r1, prf = x_add heap_entail_one_context 9 prog is_folding
                      ctx1 conseq None None None pos in
                  let r1 = add_infer_rel_to_list_context h2 r1 in
                  (r1, prf)
                | _ -> report_error pos "Length of relational assumption list > 1"
              end
          end
      end
    | Context.Seq_action l ->
      let () = y_winfo_pp "Seq_action's continuation not properly implemented" in
      let rec helper l res =
        match l with
        | [] -> res
        | (_,a)::xs ->
          let _ = process_small_action prog estate a conseq is_folding pos in
          failwith "TBI"
      in
      begin
        match l with
        | [] ->
          let msg = "Sequential action - is empty" in
          report_warning no_pos msg;
          (Errctx.mkFailCtx_may x_loc msg estate pos, Unknown)
        | (_,act)::xs ->
          x_add (process_action ~caller:(x_loc ^ ":" ^ caller)) 2 (xs@cont_act)
            prog estate conseq lhs_b rhs_b act rhs_h_matched_set is_folding pos
      end
    | Context.Cond_action l -> begin
        Debug.ninfo_hprint (add_str "Total cond action length: " (fun x ->
            string_of_int (List.length x))) l no_pos;
        let rec helper l =
          Debug.ninfo_hprint (add_str "  processing-cond-actions length: "
                                (fun x -> string_of_int (List.length x))) l
            no_pos;
          match l with
          | [] -> (* fst_failure *)
            let msg = "Cond action - none succeeded" in
            (CF.mkFailCtx_in (Basic_Reason (mkFailContext msg estate (Base rhs_b
                                                                     ) None pos,
                                            CF.mk_failure_must
                                              "Cond action - none succeeded"
                                              Globals.sl_error, estate.es_trace)
                             ) ((convert_to_must_es estate), msg,
                                Failure_Must msg) (mk_cex true), NoAlias)
          | [(_,act)] -> x_add (process_action ~caller:(x_loc ^ ":" ^ caller)) 2
                           cont_act prog estate conseq lhs_b rhs_b act
                           rhs_h_matched_set is_folding pos
          | (_,act)::xs ->
            Debug.ninfo_pprint "    process cond-action" no_pos;
            Debug.ninfo_hprint (add_str " estate" Cprinter.string_of_entail_state) estate no_pos;
            let (r,prf) = x_add (process_action ~caller:(x_loc ^ ":" ^ caller))
                3 cont_act prog estate conseq lhs_b rhs_b act rhs_h_matched_set
                is_folding pos in
            Debug.ninfo_hprint (add_str "Cond_action, context r"
                                  Cprinter.string_of_list_context) r no_pos;
            if isFailCtx r then (
              Debug.ninfo_pprint "-- cond-action failed, proceed next" no_pos;
              helper xs  (* fst_failure *)
            )
            else (
              Debug.ninfo_pprint "++ cond-action succeeded, return" no_pos;
              (r,prf)
            )
        in
        helper l
      end
    | Context.Search_action l ->
      let r = List.map (fun (_,a1) ->
          let dupl_estate = {
            estate with CF.es_infer_hp_rel = estate.es_infer_hp_rel # clone;
                        es_infer_rel = estate.es_infer_rel # clone} in
          x_add (process_action ~caller:(x_loc ^ ":" ^ caller)) 4 cont_act prog
            dupl_estate conseq lhs_b rhs_b a1 rhs_h_matched_set is_folding pos
        ) l in
      Debug.ninfo_hprint (add_str "Search action context list"
                            (pr_list (fun x -> Cprinter.string_of_list_context
                                         (fst x)))) r no_pos;
      if r = [] then
        let s = "Search empty list of actions" in
        let res = (CF.mkFailCtx_in (Basic_Reason (mkFailContext s estate
                                                    (Base rhs_b) None pos,
                                                  CF.mk_failure_may
                                                    ("Nothing_to_do?"^s)
                                                    Globals.sl_error,
                                                  estate.es_trace))
                     ((convert_to_may_es estate), s, Failure_May s)
                     (mk_cex false), Unknown)
        in
        res
      else
        let (ctx_lst, pf) = List.fold_left combine_results (List.hd r) (List.tl r) in
        Debug.ninfo_hprint (add_str "Search action combined context"
                              (Cprinter.string_of_list_context)) ctx_lst no_pos;
        (ctx_lst, pf)

  and pm_aux estate lhs_b a =
    let pr1 = Cprinter.string_of_entail_state in
    let pr2 = (fun (r, _) -> Cprinter.string_of_list_context r) in
    let pr3 = Context.string_of_action_res_simpl in
    Debug.no_3 "pm_aux"
      (add_str "act" pr3) (add_str "estate" pr1)
      (add_str "lhs_b" !CF.print_formula) pr2
      (fun _ _ _ -> pm_aux_x estate lhs_b a) a estate (Base lhs_b)
  in
  let r1a,r2a = pm_aux estate lhs_b a in
  if (Context.is_complex_action a)
  then (Debug.ninfo_pprint ("Detected Iscomplex") no_pos;  (r1a,r2a))
  else begin
    Debug.ninfo_pprint ("pushing_hole_action") no_pos; (push_hole_action a r1a,r2a)
  end

(******************************************************)
(*
  Summary of the coercion helper methods:
  - check the guard in do_universal and rewrite_coercion
  -  rewrite_coercion called in apply_left_coercion and apply_right_coercion
  - apply_left_coercion called in do_coercion
  - apply_right_coercion called in do_coercion
  - do_coercion called in heap_entail_non_empty_rhs_heap --------- the main coercion helper
  - do_universal called in apply_universal
  - apply_universal called in do_coercion

*)

(*
  Applying universally-quantified lemmas. Here are the steps:
  - Compute the set of universal variables. If the set is
  empty, then just do normal rewriting. (this has been done by apply_universal).
  - Split the guard out. Change it to existential to check
  for satisfiability.
  - Do the rewriting.
  - Perform entailment with rewritten formula
  - Filter subformulas from the pure part of the consequent
  that are related to the guard. This provides us with the instantiation.

  Now it only works when applying to the antecedent.
*)
(* new version:
   - forall v*. H /\ G -> B
   - match H and the node/predicate to be coerced and obtain the substitution \rho
*)
(******************************************************)
(* do_universal *)
(******************************************************)
(*
  node - h_formulae?
  f - formula?
  coer - lemma
  anode - LHS node to unfold
  lhs_b - LHS base
  rhs_b - RHS base
  conseq - consequent
  bool - folding?
  pid - formula label?
*)
and do_universal prog estate (node:CF.h_formula) rest_of_lhs coer anode lhs_b
  rhs_b conseq is_folding pos: (list_context * proof) =
  let pr (e,_) = Cprinter.string_of_list_context e in
  Debug.no_3 "do_universal"  Cprinter.string_of_h_formula
    Cprinter.string_of_formula Cprinter.string_of_formula pr
    (fun _ _ _ -> do_universal_x prog estate node rest_of_lhs coer anode lhs_b
        rhs_b conseq is_folding pos) node rest_of_lhs conseq

and do_universal_x prog estate (node:CF.h_formula) rest_of_lhs coer anode lhs_b
  rhs_b conseq is_folding pos: (list_context * proof) =
  begin
    (* rename the bound vars *)
    let f_univ_vars = CP.fresh_spec_vars coer.coercion_univ_vars in
    let tmp_rho = List.combine coer.coercion_univ_vars f_univ_vars in
    let coer_lhs = x_add CF.subst tmp_rho coer.coercion_head in
    let coer_rhs = x_add CF.subst tmp_rho coer.coercion_body in
    let () = y_dinfo_hp (add_str "coer_rhs_0" !CF.print_formula) coer_rhs in
    (************************************************************************)
    (* also rename the free vars from the rhs that do not appear in the lhs *)
    let lhs_fv = (fv_rhs coer_lhs coer_rhs) in
    let fresh_lhs_fv = CP.fresh_spec_vars lhs_fv in
    let tmp_rho = List.combine lhs_fv fresh_lhs_fv in
    let coer_lhs = x_add CF.subst tmp_rho coer_lhs in
    let coer_rhs = x_add CF.subst tmp_rho coer_rhs in
    let () = y_dinfo_hp (add_str "coer_rhs_1" !CF.print_formula) coer_rhs in
    let lhs_heap, lhs_guard, lhs_vperm, lhs_fl, _, lhs_a  = split_components coer_lhs in
    let lhs_guard = MCP.fold_mem_lst (CP.mkTrue no_pos) false false lhs_guard in
    let () = y_dinfo_hp (add_str "lhs_guard_p" !CP.print_formula) lhs_guard in
    let univ_rel v = CP.mkRel_sv v in
    let mk_Univ_rel v = CP.mkRel (univ_rel "Univ") [CP.mk_exp_var v] no_pos in
    let lhs_w_univ_rel = List.fold_left (fun g v ->
        CP.mkAnd g (mk_Univ_rel v) no_pos
      ) lhs_guard f_univ_vars in
    (*node -> current heap node | lhs_heap -> head of the coercion*)
    match node, lhs_heap with
    | ViewNode ({ h_formula_view_node = p1;
                  h_formula_view_name = c1;
                  h_formula_view_origins = origs;
                  h_formula_view_remaining_branches = br1;
                  h_formula_view_perm = perm1; (*LDK*)
                  h_formula_view_arguments = ps1} (* as h1 *)),
      ViewNode ({ h_formula_view_node = p2;
                  h_formula_view_name = c2;
                  h_formula_view_remaining_branches = br2;
                  h_formula_view_perm = perm2; (*LDK*)
                  h_formula_view_arguments = ps2})
    (*lemmas can also be applied to data node*)
    | DataNode ({ h_formula_data_node = p1;
                  h_formula_data_name = c1;
                  h_formula_data_origins = origs;
                  h_formula_data_remaining_branches = br1;
                  h_formula_data_perm = perm1; (*LDK*)
                  h_formula_data_arguments = ps1} (* as h1 *)),
      DataNode ({ h_formula_data_node = p2;
                  h_formula_data_name = c2;
                  h_formula_data_remaining_branches = br2;
                  h_formula_data_perm = perm2; (*LDK*)
                  h_formula_data_arguments = ps2}) when CF.is_eq_node_name c1 c2 ->

      (* the lemma application heuristic:
         - if the flag lemma_heuristic is true then we use both coerce& match -
         each lemma application must be followed by a match  - and history
         - if the flag is false, we only use coerce&distribute&match
      *)
      let apply_coer = (x_add coer_target prog coer anode (CF.formula_of_base rhs_b)
                          (CF.formula_of_base lhs_b) estate.es_rhs_eqset) in
      if (not(apply_coer) || (is_cycle_coer coer origs))
      then
        (x_dinfo_zp (lazy("[do_universal]: Coercion cannot be applied!")) pos;
         let msg = "failed coercion application" in
         (CF.mkFailCtx_in(Basic_Reason( {
              fc_message = msg;
              fc_current_ents = [];
              fc_current_lhs = estate;
              fc_prior_steps = estate.es_prior_steps;
              fc_orig_conseq = estate.es_orig_conseq;
              fc_current_conseq = CF.formula_of_heap HFalse pos;
              fc_failure_pts = match (get_node_label node) with | Some s-> [s] | _ -> [];}
                                      , CF.mk_failure_must "failed coercion"
                                        Globals.sl_error, estate.es_trace))
             ((convert_to_must_es estate), msg, Failure_Must msg) (mk_cex true), Failure))
      else	(* we can apply coercion *)
        begin
          (* the \rho substitution \rho (B) and  \rho(G) is performed *)
          (*subst perm variable when applicable*)
          let perms1,perms2 =
            if (Perm.allow_perm ()) then
              Perm.get_perm_var_lists perm1 perm2
            else
              ([],[])
          in
          let fr_vars = perms2@(p2 :: ps2)in
          let to_vars = perms1@(p1 :: ps1)in
          let lhs_guard_new = CP.subst_avoid_capture fr_vars to_vars lhs_guard in
          let coer_rhs_new1 = subst_avoid_capture fr_vars to_vars coer_rhs in
          let coer_rhs_new1 =
            if !Globals.old_univ_lemma then coer_rhs_new1
            else
              let lhs_w_univ_rel = CP.subst_avoid_capture fr_vars to_vars lhs_w_univ_rel in
              let () = y_dinfo_hp (add_str "lhs_w_univ_rel" !CP.print_formula) lhs_w_univ_rel in
              CF.combine_star_pure coer_rhs_new1 lhs_w_univ_rel in
          let () = y_dinfo_hp (add_str "coer_rhs_new1" !CF.print_formula) coer_rhs_new1 in
          let coer_rhs_new1 =
            if (Perm.allow_perm ()) then
              match perm1,perm2 with
              | Some f1, None ->
                let f1 = Cpure.get_var f1 in
                propagate_perm_formula coer_rhs_new1 f1
              | _ -> coer_rhs_new1
            else
              coer_rhs_new1
          in
          let coer_rhs_new = add_origins coer_rhs_new1 (origs) in
          let () = Gen.reset_int2 () in

          let ho_ps1 = CF.get_node_ho_args node in
          let ho_ps2 = CF.get_node_ho_args lhs_heap in
          let coer_rhs_new =
            if (ho_ps1=[]) then coer_rhs_new else
              let args = List.combine ho_ps1 ho_ps2 in
              let maps = List.map match_one_ho_arg_simple args in
              let maps = List.concat maps in
              let coer_rhs_new = CF.subst_hvar coer_rhs_new maps in
              coer_rhs_new
          in
          (***************************************************)
          (* delay the guard check *)
          (* for now, just add it to the consequent *)
          (**************************************************)
          (* let guard_to_check = CP.mkExists f_univ_vars lhs_guard_new pos in *)
          let new_f = normalize_replace (* 8 *) coer_rhs_new rest_of_lhs pos in
          let () = y_dinfo_hp (add_str "rest_of_lhs" !CF.print_formula) rest_of_lhs in
          let new_f = x_add_1 Cformula.translate_set_comp_rel new_f in
          (* add the guard to the consequent  - however, the guard check is delayed *)
          (* ?? *)
          let () = y_dinfo_hp (add_str "f_univ_vars" !CP.print_svl) f_univ_vars in
          let () = y_dinfo_hp (add_str "lhs_guard_new" !CP.print_formula) lhs_guard_new in
          let guard_conseq = CP.mkExists f_univ_vars lhs_guard_new None no_pos in
          let () = y_dinfo_hp (add_str "guard_conseq" !CP.print_formula) guard_conseq in
          let guard_flag = xpure_imply prog is_folding estate guard_conseq !
              Globals.imply_timeout_limit in
          if not(guard_flag) then
            let msg = "univ guard not satisfied" in
            (CF.mkFailCtx_in(Basic_Reason ( {
                 fc_message = msg;
                 fc_current_ents = [];
                 fc_current_lhs = estate;
                 fc_prior_steps = estate.es_prior_steps;
                 fc_orig_conseq = estate.es_orig_conseq;
                 fc_current_conseq = CF.formula_of_heap HFalse pos; (* guard_conseq *)
                 fc_failure_pts = [];}, CF.mk_failure_may msg Globals.sl_error,
                 estate.es_trace)) ((convert_to_may_es estate), msg,
                                    Failure_May msg) (mk_cex true), Failure)
          else
            let formula_x,to_aux_conseq =
              (formula_of_pure_N lhs_guard_new pos,lhs_guard_new)
              (* TODOIMM andreeac to check if this is enough for imm *)
            in
            let new_conseq = conseq in
            let new_estate = {estate with (* the new universal vars to be instantiated *)
                              es_ivars = f_univ_vars @ estate.es_ivars;
                              es_formula = new_f;} in
            let () = y_dinfo_hp (add_str "LHS" !CF.print_formula) new_f in
            let () = y_dinfo_hp (add_str "conseq" !CF.print_formula) conseq in
            let new_ctx = Ctx new_estate in
            let res, prf = x_add heap_entail prog is_folding (SuccCtx [new_ctx]) new_conseq pos in
            let () = y_dinfo_hp (add_str "new_conseq" !CF.print_formula) new_conseq in
            (res, prf)
        end
    | _ -> let msg = "failed coercion application, found data but expected view" in
      (CF.mkFailCtx_in(Basic_Reason ( {
           fc_message = msg;
           fc_current_lhs = estate;
           fc_current_ents = [];
           fc_prior_steps = estate.es_prior_steps;
           fc_orig_conseq = estate.es_orig_conseq;
           fc_current_conseq = CF.formula_of_heap HFalse pos;
           fc_failure_pts = [];}
                                    , CF.mk_failure_must "11" Globals.sl_error,
                                    estate.es_trace))
          ((convert_to_must_es estate), msg, Failure_Must msg) (mk_cex true),
       Failure)
  end

and is_original_match_a anode ln2 =
  (get_view_original anode) || (get_view_original ln2)

and is_original_match anode ln2 =
  let p = Cprinter.string_of_h_formula in
  Debug.no_2 "is_original_match"
    p p
    string_of_bool
    (fun _ _ -> is_original_match_a anode ln2) anode ln2

(*
  Rewrites f by matching node with coer_lhs to obtain a substitution.
  The substitution is then applied to coer_rhs, which is then *-joined
  with f and then normalized.

  If the first component of the returned value is true, the rewrite
  is successful and the coercion performed. Otherwise, the rewrite is
  not performed (due to the guard).
*)
(****************************************)
(* rewrite_coercion *)
(*****************************************)
and rewrite_coercion prog estate node f coer lhs_b rhs_b target_b weaken pos :
  (int * formula) =
  let p1 = Cprinter.string_of_formula in
  let p2 = pr_pair string_of_int Cprinter.string_of_formula in
  Debug.no_4 "rewrite_coercion" Cprinter.string_of_h_formula  p1
    Cprinter.string_of_coercion Cprinter.string_of_entail_state p2
    (fun _ _ _ _ -> rewrite_coercion_x prog estate node f coer lhs_b rhs_b
        target_b weaken pos) node f coer estate

(*
    the fst of res: int
     0: false
     1: true & __norm
    2: true & __Error
*)
(*LDK: return the a new formula (new_f) after apply coercion into f*)
and rewrite_coercion_x prog estate node f coer lhs_b rhs_b target_b weaken pos :
  (int * formula) =
  (* This function also needs to add the name and the origin list
     of the source view to the origin list of the target view. It
     needs to check if the target view in coer_rhs belongs to the
     list of origins of node. If so, don't apply the coercion *)
  (******************** here it was the test for coerce&match *************************)
  let coer_lhs = coer.coercion_head in
  let coer_rhs = coer.coercion_body in
  let lhs_heap, lhs_guard, lhs_vperm, lhs_flow, _, lhs_a = split_components coer_lhs in
  let coer_lhs,coer_rhs,lhs_heap,(i,f) = if(coer.coercion_case = Cast.Ramify) then
      let lhs_hf,lhs_p,lhs_vp,lhs_fl,lhs_t,lhs_a = split_components f in
      let lhs_h,_,_,_,_,_  = CF.extr_formula_base lhs_b in
      let h2_node = Mem.find_node_starminus lhs_h (CF.get_node_var node) in
      let h2_node,lhs_hf = (match h2_node with
          | Some(v) -> v,Mem.drop_node_h_formula lhs_hf (CF.get_node_var v)
          | None  -> CF.HEmp,lhs_hf) in
      let coer_lhs_starminus_node,lhs_heap = (match lhs_heap with
          | StarMinus({h_formula_starminus_h1 = h1;
                       h_formula_starminus_h2 = h2}) -> h2,h1
          | _ -> lhs_heap,lhs_heap) in
      (match h2_node, coer_lhs_starminus_node with
       | ViewNode ({ h_formula_view_node = p1;
                     h_formula_view_name = c1;
                     h_formula_view_origins = origs;
                     h_formula_view_perm = perm1;
                     h_formula_view_arguments = ps1}),
         ViewNode ({h_formula_view_node = p2;
                    h_formula_view_name = c2;
                    h_formula_view_perm = perm2;
                    h_formula_view_arguments = ps2})
       | DataNode ({ h_formula_data_node = p1;
                     h_formula_data_name = c1;
                     h_formula_data_origins = origs;
                     h_formula_data_perm = perm1;
                     h_formula_data_arguments = ps1}),
         DataNode ({h_formula_data_node = p2;
                    h_formula_data_name = c2;
                    h_formula_data_perm = perm2;
                    h_formula_data_arguments = ps2}) when c1=c2 ->
         (* apply the substitution *)
         let coer_rhs_new = subst_avoid_capture (p2 :: ps2) (p1 :: ps1) coer_rhs in
         let coer_lhs_new = subst_avoid_capture (p2 :: ps2) (p1 :: ps1) coer_lhs in
         let f_new = mkBase lhs_hf lhs_p lhs_vp lhs_t lhs_fl lhs_a pos in
         coer_lhs_new,coer_rhs_new,lhs_heap,(1,f_new)
       | _ ->
         let () = Debug.ninfo_hprint (add_str "xxx (h2_node, coer_lhs_starminus_node) xxx"
                                        (pr_pair Cprinter.string_of_h_formula
                                           Cprinter.string_of_h_formula)
                                     ) (h2_node, coer_lhs_starminus_node) no_pos in
         coer_lhs,coer_rhs,lhs_heap,(0, mkTrue (mkTrueFlow ()) no_pos))
    else coer_lhs,coer_rhs,lhs_heap,(1,f) in
  if i == 0 then (0,f)
  else
    (* node - the node to which we want to apply the coercion rule *)
    (* need to find the substitution *)
    let _, lhs_guard, lhs_vperm, lhs_flow, _, lhs_a = split_components coer_lhs in
    let lhs_guard = MCP.fold_mem_lst (CP.mkTrue no_pos) false false lhs_guard in
    (* TODO : check with_dupl, with_inv *)
    (*SIMPLE lhs*)
    match node, lhs_heap with (*node -> current heap node | lhs_heap -> head of the coercion*)
    | ViewNode ({ h_formula_view_node = p1;
                  h_formula_view_imm = imm1;
                  h_formula_view_name = c1;
                  h_formula_view_origins = origs;
                  h_formula_view_remaining_branches = br1;
                  h_formula_view_perm = perm1; (*LDK*)
                  h_formula_view_arguments = ps1} (* as h1 *)),
      ViewNode ({ h_formula_view_node = p2;
                  h_formula_view_name = c2;
                  h_formula_view_remaining_branches = br2;
                  h_formula_view_perm = perm2; (*LDK*)
                  h_formula_view_arguments = ps2})
    (*lemmas can be applied to data node as well*)
    | DataNode ({ h_formula_data_node = p1;
                  h_formula_data_name = c1;
                  h_formula_data_imm = imm1;
                  h_formula_data_origins = origs;
                  h_formula_data_remaining_branches = br1;
                  h_formula_data_perm = perm1; (*LDK*)
                  h_formula_data_arguments = ps1} (* as h1 *)),
      DataNode ({ h_formula_data_node = p2;
                  h_formula_data_name = c2;
                  h_formula_data_remaining_branches = br2;
                  h_formula_data_perm = perm2; (*LDK*)
                  h_formula_data_arguments = ps2} ) when CF.is_eq_node_name c1 c2 ->

      begin
        (*************************************************************)
        (* replace with the coerce&match mechanism *)
        (*************************************************************)
        let apply_coer = (x_add coer_target prog coer node
                            (CF.formula_of_base target_b)
                            (CF.formula_of_base lhs_b) estate.es_rhs_eqset) in
        (* when disabled --imm failed and vice-versa! *)
        (*Loc: why we set flag to false, always do coer with imm. why not do a check??*)
        let flag = if !allow_imm then false else not (apply_coer) in
        let () = y_dinfo_hp (add_str "flag" string_of_bool) flag in
        let () = y_dinfo_hp (add_str "apply_coer" string_of_bool) apply_coer in
        if (flag || (is_cycle_coer coer origs))
        then
          let () = if not !Globals.web_compile_flag
            then y_winfo_pp ("Rewrite cannot be applied : "^("0")^"\n") in
          (x_dinfo_zp (lazy("[rewrite_coercion]: Rewrite cannot be applied!"))
             pos; (0, mkTrue (mkTrueFlow ()) no_pos))
        else
          (* we can apply coercion *)
          begin
            (* apply \rho (G)	and \rho(B) *)
            let perms1,perms2 =
              if (Perm.allow_perm ()) then
                Perm.get_perm_var_lists perm1 perm2
              else ([],[])
            in
            let fr_vars = perms2@(p2 :: ps2)in
            let to_vars = perms1@(p1 :: ps1)in
            let lhs_guard_new = CP.subst_avoid_capture fr_vars to_vars lhs_guard in
            let coer_rhs_new1 = subst_avoid_capture fr_vars to_vars coer_rhs in
            let coer_rhs_new1 =
              if (Perm.allow_perm ()) then
                match perm1,perm2 with
                | Some f1, None -> (*propagate perm into coercion*)
                  (match !Globals.perm with
                   | Bperm -> report_error no_pos
                                "[solver.ml] normalize_w_coers : unexpected for
        bperm"
                   | _ ->
                     let f1 = Cpure.get_var f1 in
                     propagate_perm_formula coer_rhs_new1 f1)
                | _ -> coer_rhs_new1
              else
                coer_rhs_new1
            in
            let coer_rhs_new = add_origins coer_rhs_new1 (origs) in
            (* propagate the immutability annotation inside the definition *)
            let from_ann = (CF.get_node_annot_args lhs_heap) in
            let to_ann = (CF.get_node_annot_args node) in
            let coer_rhs_new =
              try
                let mpa = List.combine from_ann to_ann in
                propagate_imm_formula coer_rhs_new c1 imm1 mpa
              with _ ->
                coer_rhs_new
            in

            let ho_ps1 = CF.get_node_ho_args node in
            let ho_ps2 = CF.get_node_ho_args lhs_heap in
            let coer_rhs_new =
              if (ho_ps1=[]) then coer_rhs_new else
                let args = List.combine ho_ps1 ho_ps2 in
                let maps = List.map match_one_ho_arg_simple args in
                let maps = List.concat maps in
                let coer_rhs_new = CF.subst_hvar coer_rhs_new maps in
                coer_rhs_new
            in
            (* Currently, I am trying to change in advance at the trans_one_coer *)
            (* Add origins to the body of the coercion which consists of *)
            (*   several star-conjunction nodes. If there are multiple nodes *)
            (*   with a same name (because of fractional permission). We only *)
            (*   add origins to the first node and leave the rest untouched. *)
            (*   This is to make sure that after a coercion, there will be *)
            (*   a MATCH for the first node. *)
            let () = Gen.reset_int2 () in
            let xpure_lhs, _, memset = x_add xpure 14 prog f in
            let xpure_lhs = MCP.fold_mem_lst (CP.mkTrue no_pos) true true xpure_lhs in
            (********************************************)
            (* test the guard again in rewrite_coercion
               - for now we only revise the universal lemmas handled by
            apply_universal
               --> the check stays here as it is *)
            (*********************************************)
            (* is it necessary to xpure (node * f) instead ? *)
            (* ok because of TP.imply*)
            if ((imply_formula_no_memo xpure_lhs lhs_guard_new !imp_no memset)) then
              let new_f = normalize_replace coer_rhs_new f pos in
              let new_f = x_add_1 Cformula.translate_set_comp_rel new_f in
              let f1 = CF.formula_is_eq_flow coer_rhs_new !error_flow_int in
              let fst_res =
                if f1 then 2 else 1
              in
              (fst_res, new_f)
            else if !case_split then begin
              (*LDK:
                - Not yet handle perm in this case
                - case_split is probably for view nodes only
                - similar to lhs_case but only applied after failed to imply lhs_guard
              *)
              match node with
              | ViewNode h1 ->
              (*Doing case splitting based on the guard.*)
                x_dinfo_pp ("rewrite_coercion: guard is not satisfied, " ^ "splitting.\n") pos;
                let neg_guard = CP.mkNot lhs_guard_new None pos in
                let node = ViewNode{h1 with h_formula_view_remaining_branches
                                            =None;
                                            h_formula_view_pruning_conditions=[]
                                          ;} in
                let f0 = normalize 10 f (formula_of_heap node pos) pos in
                let f1 = normalize 11 f0 (formula_of_mix_formula
                                            (MCP.mix_of_pure neg_guard) pos) pos
                in
                (* unfold the case with the negation of the guard. *)
                let f1,_ = unfold_nth 2 (prog,None) f1 p1 true 0 pos in
                let f2 = normalize 12 f0 (formula_of_mix_formula
                                            (MCP.mix_of_pure lhs_guard_new) pos)
                    pos in
                let new_f = mkOr f1 f2 pos in
                let new_f = x_add_1 Cformula.translate_set_comp_rel new_f in
                (1, new_f)
              | _ ->
                let () = print_string
                    ("[Solver.ml] Warning: This case not yet handled properly
                \n") in
                let new_f = normalize_replace f coer_rhs_new pos in
                (1, new_f)
            end else begin
              x_dinfo_pp "rewrite_coercion: guard is not satisfied, no splitting.\n" pos;
              (0, mkTrue (mkTrueFlow ()) no_pos)
            end
          end
      end
    | _ -> (0, mkTrue (mkTrueFlow ()) no_pos)
(*end	*)

and apply_universal prog estate coer resth1 anode lhs_b rhs_b c1 c2 conseq
  is_folding pos =
  let pr (e,_) = Cprinter.string_of_list_context e in
  Debug.no_3 "apply_universal"  Cprinter.string_of_h_formula
    Cprinter.string_of_h_formula (fun x -> x) pr
    (fun _ _ _ -> apply_universal_a prog estate coer resth1 anode lhs_b rhs_b c1
        c2 conseq is_folding pos)
    anode resth1 c2

(* anode - chosen node, resth1 - rest of heap *)
(*******************)
and apply_universal_a prog estate coer resth1 anode lhs_b rhs_b c1 c2 conseq
    is_folding pos =
  let lhs_h,lhs_p,lhs_vp,lhs_t,lhs_fl,lhs_a = CF.extr_formula_base lhs_b in
  flush stdout;
  if Gen.is_empty coer.coercion_univ_vars then
    let msg = "failed apply_universal : not a universal rule" in
    (CF.mkFailCtx_in ( Basic_Reason (  {
         fc_message = msg;
         fc_current_ents = [];
         fc_current_lhs = estate;
         fc_prior_steps = estate.es_prior_steps;
         fc_orig_conseq = estate.es_orig_conseq;
         fc_current_conseq = CF.formula_of_heap HFalse pos;
         fc_failure_pts = match (get_node_label anode) with | Some s-> [s] | _ -> [];}
                                    , CF.mk_failure_must "12" Globals.sl_error,
                                    estate.es_trace))
        ((convert_to_must_es estate), msg, Failure_Must msg) (mk_cex true),
     Failure)
  else begin
    let f = mkBase resth1 lhs_p lhs_vp lhs_t lhs_fl lhs_a pos in
    (* Assume coercions have no branches *)
    let estate = CF.moving_ivars_to_evars estate anode in
    let () = x_dinfo_zp
        (lazy ("heap_entail_non_empty_rhs_heap: apply_universal: "	^ "c1 = "
               ^ c1 ^ ", c2 = " ^ c2 ^ "\n")) pos in
    (*do_universal anode f coer*)
    x_add do_universal prog estate anode f coer anode lhs_b rhs_b conseq is_folding pos
  end

(********************************************************)
(* do_coercion *)
(********************************************************)

and find_coercions_x c1 c2 prog anode ln2 =
  let is_not_norm c = match c.coercion_case with | Normalize _ -> false | _ -> true in
  let origs = try get_view_origins anode with _ ->
    print_string "exception get_view_origins\n"; [] in
  let left_co = Lem_store.all_lemma # get_left_coercion in
  let coers1 = look_up_coercion_def_raw left_co c1 in
  let coers1 = List.filter (fun c -> not(is_cycle_coer c origs) && is_not_norm c) coers1 in
  let origs2 = try get_view_origins ln2 with _ ->
    print_string "exception get_view_origins\n"; [] in
  let right_co = Lem_store.all_lemma # get_right_coercion in
  let coers2 = look_up_coercion_def_raw
      (Lem_store.all_lemma # get_right_coercion) c2 in
  let coers2 = List.filter (fun c -> not(is_cycle_coer c origs2) && is_not_norm c) coers2  in
  let coers1, univ_coers = List.partition (fun c -> Gen.is_empty c.coercion_univ_vars) coers1 in
  ((coers1,coers2),univ_coers)

and find_coercions c1 c2 prog anode ln2 =
  let p1 = Cprinter.string_of_h_formula in
  let p = (fun l -> string_of_int (List.length l)) in
  let p2 (v,_) = pr_pair p p v in
  Debug.no_2 "find_coercions" p1 p1 p2 (fun _ _ ->
      find_coercions_x c1 c2 prog anode ln2 ) anode ln2

and do_coercion prog c_opt estate conseq resth1 resth2 anode lhs_b rhs_b ln2
  is_folding pos : (CF.list_context * proof list) =
  let pr (e,_) = Cprinter.string_of_list_context e in
  let pr_h = Cprinter.string_of_h_formula in
  let pr_es = Cprinter.string_of_entail_state(* _short *) in
  Debug.no_7 "do_coercion" pr_es pr_h pr_h pr_h pr_h
    Cprinter.string_of_formula_base (pr_opt Cprinter.string_of_coercion) pr
    (fun _ _ _ _ _ _ _ -> do_coercion_x prog c_opt estate conseq resth1 resth2
        anode lhs_b rhs_b ln2 is_folding pos) estate anode resth1 ln2 resth2
    rhs_b c_opt

(*
  - c_opt : coercion declaration
*)

and do_coercion_x prog c_opt estate conseq resth1 resth2 anode lhs_b rhs_b ln2
  is_folding pos : (CF.list_context * proof list) =
  let c1 = get_node_name 21 anode in
  let c2 = get_node_name 22 ln2 in
  let ((coers1,coers2),univ_coers) = match c_opt with
    | None -> find_coercions c1 c2 prog anode ln2
    | Some c ->
      match c.coercion_type with
      | Iast.Left ->
        let r = if c.coercion_univ_vars == [] then (([c],[]),[]) else (([],[]),[c]) in
        if !perm=NoPerm || c.coercion_case<>(Normalize false) then
          if c.coercion_case<>(Normalize true)
          then r else (([],[]),[])
        else if ( (!perm=Dperm) && (not (test_frac_subsume prog estate
                                           rhs_b.formula_base_pure
                                           (get_node_perm anode)
                                           (get_node_perm ln2))))
             || !use_split_match
        then (([],[]),[])
        else (r)
      | Iast.Right -> (([],[c]),[])
      | _ -> report_error no_pos ("Iast.Equiv detected - astsimpl should have eliminated it ")
  in
  if ((List.length coers1)=0 && (List.length coers2)=0  && (List.length univ_coers)=0 )
  || not(is_original_match anode ln2)
  then
    let msg = "no lemma found in both LHS and RHS nodes (do coercion)" in
    (CF.mkFailCtx_in(Trivial_Reason (CF.mk_failure_must msg Globals.sl_error,
                                     estate.es_trace))
       ((convert_to_must_es estate), msg, Failure_Must msg) (mk_cex true), [])
  else begin
    x_dinfo_zp (lazy ("do_coercion: estate :"
                      ^ (Cprinter.string_of_entail_state_short estate) ^ "\n"))
      pos;
    x_dinfo_zp (lazy ("do_coercion: " ^ "c1 = " ^ c1 ^ ", c2 = " ^ c2 ^ "\n")) pos;
    (* universal coercions *)
    let univ_r = if (List.length univ_coers)>0 then
        let univ_res_tmp = List.map (fun coer -> x_add apply_universal prog
                                        estate coer resth1 anode lhs_b rhs_b c1
                                        c2 conseq is_folding pos) univ_coers in
        let univ_res, univ_prf = List.split univ_res_tmp in
        Some (univ_res, univ_prf)
      else None in
    (* left coercions *)
    let left_r = if (List.length coers1)>0 then
        let tmp1 = List.map  (fun coer -> x_add apply_left_coercion estate coer
                                 prog conseq resth1 anode lhs_b rhs_b c1
                                 is_folding pos) coers1 in
        let left_res, left_prf = List.split tmp1 in
        let left_prf = List.concat left_prf in
        Some (left_res,left_prf)
      else None in
    (* right coercions *)
    let right_r = if (List.length coers2)>0 then
        let tmp2 = List.map (fun coer -> x_add apply_right_coercion estate coer
                                prog conseq resth2 ln2 lhs_b rhs_b c2 is_folding
                                pos) coers2 in
        let right_res, right_prf = List.split tmp2 in
        let right_prf = List.concat right_prf in
        Some (right_res,right_prf)
      else None in
    let proc lst =
      let r1 = List.map (fun (c,p) -> (fold_context_left 14 c,p)) lst in
      let (r2,p) = List.split r1 in
      let res = fold_context_left 15 r2 in
      let final_res = (isFailCtx res) in
      let prf = List.concat (List.map (fun (c,p) -> if final_res==(isFailCtx c)
                                        then p else []) r1) in
      (res,prf) in
    let m = List.fold_right (fun x r -> match x with None -> r | Some x -> x::r
      ) [univ_r;left_r;right_r] [] in
    if m==[] then let msg =  "cannot find matching node in antecedent (do coercion)" in
      (CF.mkFailCtx_in(Trivial_Reason (CF.mk_failure_must msg Globals.sl_error,
                                       estate.es_trace))
         ((convert_to_must_es estate), msg, Failure_Must msg) (mk_cex true), [])
    else proc m
  end
(*********************************************************************)
(* apply_left_coercion *)
(********************************************************************)
and apply_left_coercion estate coer prog conseq resth1 anode (*lhs_p lhs_t
  lhs_fl lhs_br*) lhs_b rhs_b c1 is_folding pos =
  let pr (e,_) = Cprinter.string_of_list_context e in
  Debug.no_5 "apply_left_coercion"
    (add_str "estate" Cprinter.string_of_entail_state)
    (add_str "anode" Cprinter.string_of_h_formula)
    (add_str "resth1" Cprinter.string_of_h_formula)
    (add_str "coer" Cprinter.string_of_coercion)
    (add_str "conseq" Cprinter.string_of_formula) pr
    (fun _ _ _ _ _-> apply_left_coercion_a estate coer prog conseq resth1 anode
        lhs_b rhs_b c1 is_folding pos)
    estate anode resth1 coer conseq
(* anode - LHS matched node
   resth1 - LHS remainder
   lhs_p - lhs mix pure
   lhs_t - type of formula? (for OO)
   lhs_fl - flow
   lhs_br - lhs branches
   lhs_b - lhs base
   rhs_b - rhs base
   c1 - lhs pred name
   is_folding
   pos
   pid - ?id
*)
and apply_left_coercion_a estate coer prog conseq resth1 anode lhs_b rhs_b c1 is_folding pos=
  if (coer.coercion_case = Cast.Simple || coer.coercion_case = Cast.Ramify
      || coer.coercion_case = (Cast.Normalize false)) then
    (*let () = print_string("resth1 = "^(Cprinter.string_of_h_formula resth1)^"\n") in*)
    (*simple lemmas with simple lhs with single node*)
    let lhs_h,lhs_p,lhs_vp,lhs_t,lhs_fl,lhs_a = CF.extr_formula_base lhs_b in
    let f = mkBase resth1 lhs_p lhs_vp lhs_t lhs_fl lhs_a pos in
    let () = x_dinfo_zp (lazy ("apply_left_coercion: left_coercion:\ n### c1 = " ^ c1
                               ^ "\n ### anode = "
                               ^ (Cprinter.string_of_h_formula anode) ^ "\n"))
        pos in
    let ok, new_lhs = x_add rewrite_coercion prog estate anode f coer lhs_b
        rhs_b rhs_b true pos in
    let () = x_dinfo_zp (lazy ( "apply_left_coercion: after rewrite_coercion"
                                ^ "\n ### ok = "^ (string_of_int ok)
                                ^ "\n ### new_lhs = "^ (Cprinter.string_of_formula new_lhs)
                                ^ "\n\n")) pos in
    if ok>0 then begin
      (* lhs_b -> rhs_b *)
      (* anode |- _ *)
      (* unfold by removing LHS head anode, and replaced with rhs_b into new_lhs to continue *)
      let old_trace = estate.es_trace in
      let () = x_dinfo_hp (add_str "ok" string_of_int) ok no_pos in
      let estate = {estate with
                    es_trace=(("(left: " ^ coer.coercion_name ^ ")")::old_trace)} in
      let () = x_dinfo_hp (add_str "estate.es_formula" !print_formula) estate.es_formula no_pos in
      let ctx0 = Ctx estate in
      (*err.4/E8*)
      let new_ctx1 = build_context ctx0 ( CF.change_flow_w_flag new_lhs (ok==2)
                                            !error_flow_int) pos in
      (* let new_ctx = set_context_formula ctx0 new_lhs in *)
      let new_ctx = SuccCtx[((* set_context_must_match *) new_ctx1)] in
      let res, tmp_prf = x_add heap_entail prog is_folding new_ctx conseq pos in
      let new_res = res
      (*err.4/E8*)
      (* if ok == 1 then res *)
      (* else CF.invert_outcome res *)
      in
      let prf = mkCoercionLeft ctx0 conseq coer.coercion_head
          coer.coercion_body tmp_prf coer.coercion_name
      in
      (new_res, [prf])
    end else
      let msg = "failed left coercion application" in
      (CF.mkFailCtx_in( Basic_Reason ( {
           fc_message = msg;
           fc_current_lhs = estate;
           fc_current_ents = [];
           fc_prior_steps = estate.es_prior_steps;
           fc_orig_conseq = estate.es_orig_conseq;
           fc_current_conseq = CF.formula_of_heap HFalse pos;
           fc_failure_pts = match (get_node_label anode) with | Some s-> [s] | _ -> [];},
           CF.mk_failure_must "12" Globals.sl_error, estate.es_trace))
          ((convert_to_must_es estate), msg, Failure_Must msg) (mk_cex true), []
      )
  else
    (*COMPLEX or NORMALIZING lemmas with multiple nodes in the lhs*)
    (* (\*LDK: ok*\) *)
    let () = x_dinfo_zp (lazy ("heap_entail_non_empty_rhs_heap: "
                               ^ "left_coercion: c1 = "
                               ^ c1 ^ "\n")) pos in
    apply_left_coercion_complex  estate coer prog conseq resth1 anode lhs_b
      rhs_b c1 is_folding pos



(*TOCHECK: use pickup node to pickup the self node*)
(*LDK: COMPLEX lemmas are treated in a different way*)
and apply_left_coercion_complex_x estate coer prog conseq resth1 anode lhs_b
    rhs_b c1 is_folding pos =
  (*simple lemmas with simple lhs with single node*)
  let lhs_h,lhs_p,lhs_vp,lhs_t,lhs_fl, lhs_a = CF.extr_formula_base lhs_b in
  let f = CF.mkBase resth1 lhs_p lhs_vp lhs_t lhs_fl lhs_a pos in
  let coer_lhs = coer.coercion_head in
  let coer_rhs = coer.coercion_body in
  (************************************************************************)
  (* rename the free vars in the lhs and rhs to avoid name collision *)
  (* between lemmas and entailment formulas*)
  let lhs_fv = List.filter (fun sv -> not (CP.is_hp_typ sv)) (CF.fv coer_lhs) in
  let fresh_lhs_fv = CP.fresh_spec_vars lhs_fv in
  let tmp_rho = List.combine lhs_fv fresh_lhs_fv in
  let () = y_dinfo_hp (add_str "coer_lhs" !CF.print_formula) coer_lhs in
  let coer_lhs = x_add CF.subst tmp_rho coer_lhs in
  let () = y_dinfo_hp (add_str "coer_lhs" !CF.print_formula) coer_lhs in
  let coer_rhs = x_add CF.subst tmp_rho coer_rhs in
  (************************************************************************)
  let lhs_heap, lhs_guard, lhs_vperm, lhs_flow, _, lhs_a = split_components coer_lhs in
  let lhs_qvars,_ = CF.split_quantifiers coer_lhs in
  (************************************************************************)
  (* also rename the existential vars in the lhs.
     To ensure that after each application of a specific
     coercion, the exist vars are different *)
  let lhs_qvars_new = CP.fresh_spec_vars lhs_qvars in
  let lhs_heap  =  CF.subst_avoid_capture_h lhs_qvars lhs_qvars_new lhs_heap in
  let lhs_guard = MCP.subst_avoid_capture_memo lhs_qvars lhs_qvars_new lhs_guard in
  let lhs_vperm = CVP.subst_avoid_capture lhs_qvars lhs_qvars_new lhs_vperm in
  let coer_rhs = subst_avoid_capture lhs_qvars lhs_qvars_new coer_rhs in
  (************************************************************************)
  let lhs_guard = MCP.fold_mem_lst (CP.mkTrue no_pos) false false lhs_guard in
  (* TODO : check with_dupl, with_inv *)
  let () = y_dinfo_hp (add_str "lhs_heap" !CF.print_h_formula) lhs_heap in
  let lhs_hs = CF.split_star_conjunctions lhs_heap in (*|lhs_hs|>1*)
  let renamed_self =
    try
      let _, fresh_self = List.find (fun (sv, _) ->
          eq_str Globals.self (CP.name_of_spec_var sv)) tmp_rho in
      fresh_self
    with _ -> failwith (x_loc ^ "Cannot find self in the lemma")
  in
  let () = y_dinfo_hp (add_str "renamed_self" !CP.print_sv) renamed_self in
  let head_node, rest = pick_up_node prog lhs_hs (CP.name_of_spec_var renamed_self) in
  let extra_opt = join_star_conjunctions_opt rest in
  let extra_heap =
    (match (extra_opt) with
     | None ->
       let () = print_string
           "[apply_left_coercion_complex] Warning: List of conjunctions can not
be empty \n" in
       CF.HEmp
     | Some res_f -> res_f)
  in
  let () = y_dinfo_hp (add_str "anode" !CF.print_h_formula) anode in
  let () = y_dinfo_hp (add_str "head_node" !CF.print_h_formula) head_node in

  let extract_info h =
    match h with
    | ViewNode ({
        h_formula_view_node = p;
        h_formula_view_name = c;
        h_formula_view_origins = origs;
        h_formula_view_remaining_branches = br;
        h_formula_view_perm = perm;
        h_formula_view_arguments = ps; })
    | DataNode ({
          h_formula_data_node = p;
          h_formula_data_name = c;
          h_formula_data_origins = origs;
          h_formula_data_remaining_branches = br;
          h_formula_data_perm = perm;
          h_formula_data_arguments = ps; }) ->
      p, c, origs, br, perm, ps
    | HRel _ ->
      let hrel_name, hrel_args = CFU.sig_of_hrel h in
      let c = CP.name_of_spec_var hrel_name in
      let p, ps =
        try C.get_root_args_hp prog c hrel_args
        with _ -> List.hd hrel_args, List.tl hrel_args
      in
      p, c, [], None, None, ps
    | _ -> failwith (x_loc ^ "[extract_info] Unexpected formula")
  in

  let mk_fail_ctx estate anode msg =
    (CF.mkFailCtx_in( Basic_Reason ( {
         fc_message = msg;
         fc_current_ents = [];
         fc_current_lhs = estate;
         fc_prior_steps = estate.es_prior_steps;
         fc_orig_conseq = estate.es_orig_conseq;
         fc_current_conseq = CF.formula_of_heap HFalse pos;
         fc_failure_pts = match (get_node_label anode) with | Some s-> [s] | _ -> [];},
         CF.mk_failure_must "12" Globals.sl_error, estate.es_trace))
        ((convert_to_must_es estate), msg, Failure_Must msg) (mk_cex true), [])
  in

  match anode, head_node with (*node -> current heap node | lhs_heap -> head of the coercion*)
  | ViewNode _, ViewNode _
  | DataNode _, DataNode _
  | HRel _, HRel _ ->
    let p1, c1, origs, br1, perm1, ps1 = extract_info anode in
    let p2, c2, _, br2, perm2, ps2 = extract_info head_node in

    let is_hrel_matching = CF.is_hrel anode in

    if not (C.is_hp_name prog c1) &&
       not (C.is_hp_name prog c2) &&
       not (CF.is_eq_node_name c1 c2)
    then
      let msg = "failed left coercion application, can not match head node" in
      mk_fail_ctx estate anode msg
    else
      (*temporarily skip this step. What is it for???*)
      let ho_ps1  = CF.get_node_ho_args anode in
      let ho_ps2  = CF.get_node_ho_args head_node in
      if (is_cycle_coer coer origs)
      then
        (* let s = (pr_list string_of_bool [f1;(\* f2; *\)f3;f4;f5;f6]) in *)
        let () = x_dinfo_zp
            (lazy
              ("[apply_left_coercion_complex_x]:failed left coercion
       application: in a cycle!")) pos in
        let msg = "failed left coercion application: in a cycle" in
        mk_fail_ctx estate anode msg
      else
        let perms1,perms2 =
          if (Perm.allow_perm ()) then
            match perm1,perm2 with
            | Some f1, Some f2 ->
              let f1 = List.hd (Perm.get_cperm_var perm1) in
              let f2 = List.hd (Perm.get_cperm_var perm2) in
              ([f1],[f2])
            | Some f1, None ->
              let f1 = List.hd (Perm.get_cperm_var perm1) in
              ([f1],[full_perm_var ()])
            | None, Some f2 ->
              let f2 = List.hd (Perm.get_cperm_var perm2) in
              ([full_perm_var  ()],[f2])
            | None, None ->
              ([],[])
          else
            ([],[])
        in

        let () = y_dinfo_hp (add_str "lhs_guard" !CP.print_formula) lhs_guard in
        let () = y_dinfo_hp (add_str "coer_rhs" !CF.print_formula) coer_rhs in
        let () = y_dinfo_hp (add_str "extra_heap" !CF.print_h_formula) extra_heap in

        let fr_vars, to_vars =
          if not is_hrel_matching then
            (p2::ps2), (p1::ps1)
          else
            let complx_lem_sig = CFU.complx_sig_of_formula prog renamed_self coer_lhs in
            let lhs_root = CFU.get_node_var prog anode in
            let complx_lhs_sig = CFU.complx_sig_of_formula prog lhs_root (CF.Base lhs_b) in
            let () = y_dinfo_hp (add_str "complx_lem_sig"
                                   (pr_list !CF.print_h_formula)) complx_lem_sig
            in
            let () = y_dinfo_hp (add_str "complx_lhs_sig"
                                   (pr_list !CF.print_h_formula)) complx_lhs_sig
            in

            let lem_args = CF.get_node_args head_node in
            let matching_nodes = List.combine complx_lem_sig complx_lhs_sig in
            let subst = List.fold_left (fun acc sv ->
                if List.exists (fun (v, _) -> CP.eq_spec_var v sv) acc then acc
                else
                  try
                    let _, matching_lhs_node = List.find (fun (h_lem, _) ->
                        CP.eq_spec_var (CFU.get_node_var prog h_lem) sv) matching_nodes in
                    acc @ [(sv, CFU.get_node_var prog matching_lhs_node)]
                  with _ -> acc
              ) [(renamed_self, lhs_root)] lem_args in
            List.split subst
        in
        let fr_vars, to_vars = perms2@fr_vars, perms1@to_vars in
        let () = y_dinfo_hp (add_str "fr_vars" !CP.print_svl) fr_vars in
        let () = y_dinfo_hp (add_str "to_vars" !CP.print_svl) to_vars in
        let head_node_new = subst_avoid_capture_h fr_vars to_vars head_node in
        let lhs_guard_new = CP.subst_avoid_capture fr_vars to_vars lhs_guard in
        let coer_rhs_new1 = subst_avoid_capture fr_vars to_vars coer_rhs in
        let extra_heap_new = CF.subst_avoid_capture_h fr_vars to_vars extra_heap in
        let coer_rhs_new1,extra_heap_new =
          if (Perm.allow_perm ()) then
            match perm1,perm2 with
            | Some f1, None ->
              (*propagate perm into coercion*)
              let f1 = List.hd (Perm.get_cperm_var perm1) in
              let rhs = propagate_perm_formula coer_rhs_new1 f1 in
              let extra, svl =  propagate_perm_h_formula extra_heap_new f1 in
              (rhs,extra)
            | _ -> (coer_rhs_new1, extra_heap_new)
          else
            (coer_rhs_new1,extra_heap_new)
        in
        let coer_rhs_new = add_origins coer_rhs_new1 (coer.coercion_name ::origs) in
        (*avoid apply a complex lemma twice*)
        let f = add_origins f [coer.coercion_name] in
        let f = add_original f false in
        let new_es_heap = CF.mkStarH anode estate.es_heap no_pos in (*consumed*)

        (* let new_es_heap = CF.mkStarH head_node estate.es_heap no_pos in *)
        let old_trace = estate.es_trace in
        let new_estate = { estate with es_heap = new_es_heap; es_formula = f;
                                       es_trace=(("(Complex: "
                                                  ^ coer.coercion_name ^ ")")
                                                 ::old_trace)} in
        let () =
          if is_hrel_matching then
            let lhs_hrel_name, _ = CFU.sig_of_hrel anode in
            let lem_hrel_name, _ = CFU.sig_of_hrel head_node_new in
            let rel_kind = CP.RelAssume [lhs_hrel_name; lem_hrel_name] in
            let rel_path = CF.get_es_cond_path new_estate in
            let lhs_f = CF.mkBase_simp anode (MCP.mkMTrue no_pos) in
            let rhs_f = CF.mkBase_simp head_node_new (MCP.mkMTrue no_pos) in
            let unk_svl = [lhs_hrel_name; lem_hrel_name] in
            let rel_assume = CF.mkHprel rel_kind unk_svl [] [] lhs_f None rhs_f rel_path in
            new_estate.es_infer_hp_rel # push_list_loc x_loc [rel_assume]
        in
        let new_ctx1 = Ctx new_estate in
        let new_ctx = SuccCtx[((* set_context_must_match *) new_ctx1)] in
        (*prove extra heap + guard*)
        let conseq_extra = mkBase extra_heap_new (MCP.memoise_add_pure_N
                                                    (MCP.mkMTrue no_pos)
                                                    lhs_guard_new) lhs_vperm
            CF.TypeTrue (CF.mkTrueFlow ()) [] pos in
        (*=====================================================*)
        (***********Handle high-order argument: BEGIN**********)
        if (List.length ho_ps1 != List.length ho_ps2) then
          let () = print_endline_quiet
              ("apply_left_coercion_complex: ho_args mismatched between anode
        and head_node") in
          x_dinfo_zp
            (lazy
              ("apply_left_coercion_complex: ho_args mismatched between anode
        and head_node")) no_pos;
          let msg =
            "failed left coercion application, ho_args mismatched between anode
        and head_node" in
          mk_fail_ctx estate anode msg
        else
          let coer_rhs_new =
            if (ho_ps1=[]) then coer_rhs_new else
              let args = List.combine ho_ps1 ho_ps2 in
              let maps = List.map match_one_ho_arg_simple args in
              let maps = List.concat maps in
              let coer_rhs_new = CF.subst_hvar coer_rhs_new maps in
              coer_rhs_new
          in

          x_dinfo_zp (lazy ("apply_left_coercion_complex: check extra heap")) pos;
          x_dinfo_zp (lazy ("apply_left_coercion_complex: new_ctx after folding: "
                            ^ (Cprinter.string_of_spec_var p2) ^ "\n"
                            ^ (Cprinter.string_of_context new_ctx1))) pos;
          x_dinfo_zp (lazy ("apply_left_coercion_complex: conseq_extra:\n"
                            ^ (Cprinter.string_of_formula conseq_extra))) pos;

          let check_res, check_prf = x_add heap_entail prog false new_ctx conseq_extra pos in

          let () = y_dinfo_hp (add_str "new_ctx" !CF.print_list_context) new_ctx in
          let () = y_dinfo_hp (add_str "conseq_extra" !CF.print_formula) conseq_extra in
          let () = y_dinfo_hp (add_str "check_res" !CF.print_list_context) check_res in

          x_dinfo_zp (lazy ("apply_left_coercion_complex: after check extra heap: "
                            ^ (Cprinter.string_of_spec_var p2) ^ "\n"
                            ^ (Cprinter.string_of_list_context check_res))) pos;

          (*PROCCESS RESULT*)
          let rec process_one_x (ss:CF.steps) res = match res with
            | OCtx (c1, c2) ->
              let tmp1, prf1 = process_one_x (add_to_steps ss "left OR 4 in ante") c1 in
              let tmp2, prf2 = process_one_x  (add_to_steps ss "right OR 4 in ante") c2 in
              let tmp3 = or_list_context tmp1 tmp2 in
              let prf3 = Prooftracer.mkOrLeft res f [prf1; prf2] in
              (tmp3, prf3)
            | Ctx es ->
              let es = CF.overwrite_estate_with_steps es ss in
              (* rhs_coerc * es.es_formula /\ lhs.p |-  conseq*)
              let new_ante1 = normalize_combine coer_rhs_new es.es_formula no_pos in
              let new_ante = add_mix_formula_to_formula lhs_p new_ante1 in
              let new_ante = x_add_1 Cformula.translate_set_comp_rel new_ante in
              let new_es = {new_estate with es_formula=new_ante;
                                            es_trace=(("(Complex: "
                                                       ^ coer.coercion_name
                                                       ^ ")")::old_trace);
                                            es_heap = HEmp} in
              let new_ctx = (Ctx new_es) in

              x_dinfo_zp
                (lazy
                  ("apply_left_coercion_complex: process_one: resume entail
                check")) pos;
              x_dinfo_zp
                (lazy
                  ("apply_left_coercion_complex: process_one: resume entail
              check: new_ctx = \n" ^ (Cprinter.string_of_context new_ctx))) pos;
              x_dinfo_zp
                (lazy
                  ("apply_left_coercion_complex: process_one: resume entail
              check: conseq = " ^ (Cprinter.string_of_formula conseq))) pos;


              let rest_rs, prf = x_add heap_entail_one_context 10 prog
                  is_folding new_ctx conseq None None None pos in


              x_dinfo_zp
                (lazy
                  ("apply_left_coercion_complex: process_one: after resume
                entail check: rest_rs =  " ^ (Cprinter.string_of_list_context
                rest_rs))) pos;

              (rest_rs,prf)
          in
          let process_one (ss:CF.steps) res =
            let pr1 = Cprinter.string_of_context  in
            let pr2 (c,_) = Cprinter.string_of_list_context c in
            Debug.no_1 "apply_left_coercion_complex:process_one" pr1 pr2
              (fun _ -> process_one_x (ss:CF.steps) res) res in

          (match check_res with
           | FailCtx _ ->
             let () = x_dinfo_zp
                 (lazy
                   ("apply_left_coercion_complex: extra state of the lhs is not
          satisfied \n")) pos in
             let msg = "failed left coercion application: can not match extra heap" in
             mk_fail_ctx estate anode msg
           | SuccCtx res ->
             let t1,p1 = List.split (List.map (process_one []) res) in
             let t1 = fold_context_left 16 t1 in
             (t1,p1))
  | _ ->
    let msg = "failed left coercion application, can not match head node" in
    mk_fail_ctx estate anode msg

and apply_left_coercion_complex estate coer prog conseq resth1 anode lhs_b rhs_b
  c1 is_folding pos =
  let pr (e,_) = Cprinter.string_of_list_context e in
  Debug.no_5 "apply_left_coercion_complex"
    (add_str "anode" Cprinter.string_of_h_formula)
    (add_str "resth1" Cprinter.string_of_h_formula)
    (add_str "coer" Cprinter.string_of_coercion)
    (add_str "lhs_b" !CF.print_formula)
    (add_str "rhs_b" !CF.print_formula) pr
    (fun _ _ _ _ _ -> apply_left_coercion_complex_x estate coer prog conseq
        resth1 anode lhs_b rhs_b c1 is_folding pos)
    anode resth1 coer (CF.Base lhs_b) (CF.Base rhs_b)

(*pickup a node named "name" from a list of nodes*)
and pick_up_node prog (ls:CF.h_formula list) (name:ident):
  (CF.h_formula * CF.h_formula list) =
  let rec pr xs =
    match xs with
    | [] -> ""
    | x::xs1 -> (!print_h_formula x) ^ "|*|" ^ pr xs1
  in
  let pr2 (a,b) =
    (Cprinter.string_of_h_formula a) ^ "|&&&|"  ^ (pr b)
  in
  Debug.no_2 "pick_up_node"
    pr (fun id -> id) pr2
    (pick_up_node_x prog) ls name

(*pickup a node named "name" from a list of nodes*)
and pick_up_node_x prog (ls:CF.h_formula list) (name:ident):
  (CF.h_formula * CF.h_formula list) =
  let rec helper ls =
    match ls with
    | [] -> CF.HEmp,[]
    | x::xs ->
      match x with
      | ViewNode _
      | DataNode _
      | HRel _ ->
        let c = CFU.get_node_var prog x in
        let c_str = (CP.name_of_spec_var c) in
        if ((String.compare c_str name) == 0)
        then
          (x,xs)
        else
          let res1,res2 = helper xs in
          (res1,x::res2)
      | _ ->
        let res1,res2 = helper xs in
        (res1,x::res2)
  in helper ls

and test_frac_subsume_x prog lhs rhs_p l_perm r_perm =
  (*if false, split permission*)
  if !perm =NoPerm then false
  else
    let r_perm = match r_perm with
      | None -> CP.Tsconst (Tree_shares.Ts.top, no_pos)
      | Some v -> v
    in
    let l_perm = match l_perm with
      | None -> CP.Tsconst (Tree_shares.Ts.top, no_pos)
      | Some v -> v
    in
    let nfv = CP.fresh_perm_var()  in
    let add1 = CP.BForm ((CP.Eq (l_perm, CP.Add (CP.Var (nfv,no_pos),r_perm,
                                                 no_pos), no_pos), None),None)
    in
    let add = add1 (*CP.Or (add1,add2,None,no_pos)*) in
    let rhs_p = MCP.pure_of_mix rhs_p in
    let rhs_p =  CP.And (rhs_p, add, no_pos) in
    let n_pure =  CP.Exists (nfv, rhs_p, None, no_pos) in
    xpure_imply prog false lhs n_pure !Globals.imply_timeout_limit

and test_frac_subsume prog lhs rhs_p l_perm r_perm =
  let pr1 = Cprinter.string_of_estate in
  let pr2 = Cprinter.string_of_mix_formula in
  let pr3 c = match c
    with | None -> "Top" | Some v -> Cprinter.string_of_formula_exp v in
  Debug.no_4(* _loop *) "test_frac_subsume" pr1 pr2 pr3 pr3 string_of_bool
    (test_frac_subsume_x prog) lhs rhs_p l_perm r_perm

and test_frac_eq_x prog lhs rhs_p l_perm r_perm = (*if false, do match *)
  if !perm =NoPerm then true
  else
    let r_perm = match r_perm
      with | None -> CP.Tsconst (Tree_shares.Ts.top, no_pos) |
        Some v -> CP.Var (v,no_pos) in
    let l_perm = match l_perm
      with | None -> CP.Tsconst (Tree_shares.Ts.top, no_pos) |
        Some v -> CP.Var (v,no_pos) in
    let add = CP.BForm ((CP.Eq (r_perm, l_perm, no_pos), None),None) in
    let rhs_p = MCP.pure_of_mix rhs_p in
    let rhs_p =  CP.And (rhs_p, add, no_pos) in
    let n_pure =  rhs_p (*CP.Exists (nfv, rhs_p, None, no_pos)*) in
    xpure_imply prog false lhs n_pure !Globals.imply_timeout_limit

and test_frac_eq prog lhs rhs_p l_perm r_perm =
  let pr1 = Cprinter.string_of_estate in
  let pr2 = Cprinter.string_of_mix_formula in
  let pr3 c = match c with | None -> "Top" | Some v -> Cprinter.string_of_spec_var v in
  Debug.no_4 "test_frac_eq" pr1 pr2 pr3 pr3 string_of_bool (test_frac_eq_x prog)
    lhs rhs_p l_perm r_perm

(* normalize a formula using normalization lemma                   *)
(* normaliztion lemmas are similar to complex lemma                *)
(* However, they reduce the number of nodes after each application *)
(* while complex lemmas can be arbitary                            *)

and normalize_w_coers prog (estate: CF.entail_state) (coers: coercion_decl list)
  (h: h_formula) (p: MCP.mix_formula) (vp: CVP.vperm_sets) (fl:flow_formula)
  pos:
  (CF.entail_state * h_formula * MCP.mix_formula * CVP.vperm_sets * flow_formula
  ) =
  (* let pr_es = Cprinter.string_of_entail_state in *)
  (* let pr_c = Cprinter.string_of_coerc_decl_list in *)
  let pr_h = Cprinter.string_of_h_formula in
  let pr_p = Cprinter.string_of_mix_formula in
  let pr_fl = Cprinter.string_of_flow_formula "" in
  let pr_r (_, a, b, c, d) = pr_triple pr_h pr_p pr_fl (a, b, d) in
  Debug.no_3"normalize_w_coers" pr_h pr_p pr_fl pr_r
    (fun _ _ _ -> normalize_w_coers_x prog estate coers h p vp fl pos) h p fl

and normalize_w_coers_x prog (estate:CF.entail_state) (coers:coercion_decl list)
  (h:h_formula) (p:MCP.mix_formula) (vp: CVP.vperm_sets) (fl:flow_formula) pos:
  (CF.entail_state * h_formula * MCP.mix_formula * CVP.vperm_sets * flow_formula
  ) =
  x_dinfo_pp  ("loop in normalize_w_coers ? 0") no_pos;
  let rec helper (estate:CF.entail_state) (h:h_formula) (p:MCP.mix_formula)
      (vp: CVP.vperm_sets) (fl:flow_formula):
    (CF.entail_state * h_formula * MCP.mix_formula * CVP.vperm_sets
     * flow_formula) =
    (* try to check whether the current estate with h=anode*rest and pure=p *)
    (* can entail the lhs of an coercion *)
    x_dinfo_pp  ("loop in normalize_w_coers ? 1") no_pos;
    let process_one_x estate anode rest coer h p vp fl =
      let f = mkBase rest p vp CF.TypeTrue fl [] no_pos in
      x_dinfo_pp  ("loop in normalize_w_coers ? 2") no_pos;
      let coer_lhs = coer.coercion_head in
      let coer_rhs = coer.coercion_body in
      (* compute free vars in extra heap and guard *)
      let extra_vars =
        let lhs_heap, lhs_guard, lhs_vperm, _, _, lhs_a = split_components coer_lhs in
        (*BE CAREFUL, the first node is not always the self node.
          May consider using the prior implementation in para5
          (i.e. using pick_up_node to identify head_hode)
        *)
        let head_node = List.hd (CF.split_star_conjunctions lhs_heap) in
        let vars = Gen.BList.difference_eq CP.eq_spec_var
            (CF.h_fv lhs_heap @ MCP.mfv lhs_guard) (CF.h_fv head_node) in
        let vars = List.filter (fun (CP.SpecVar (_,id,_)) ->
            not (id= Globals.cyclic_name || id = Globals.acyclic_name
                 || id = Globals.concrete_name || id = Globals.set_comp_name ))
            vars in
        Gen.BList.remove_dups_eq CP.eq_spec_var vars
      in
      (* rename the bound vars *)
      let tmp_rho = List.combine extra_vars (CP.fresh_spec_vars extra_vars) in
      let coer_lhs = x_add CF.subst tmp_rho coer_lhs in
      let coer_rhs = x_add CF.subst tmp_rho coer_rhs in
      (************************************************************************)
      (* also rename the free vars from the rhs that do not appear in the lhs *)
      let lhs_fv = (fv_rhs coer_lhs coer_rhs) in
      let fresh_lhs_fv = CP.fresh_spec_vars lhs_fv in
      let tmp_rho = List.combine lhs_fv fresh_lhs_fv in
      let coer_lhs = x_add CF.subst tmp_rho coer_lhs in
      let coer_rhs = x_add CF.subst tmp_rho coer_rhs in
      (************************************************************************)
      let lhs_heap, lhs_guard, lhs_vperm, lhs_flow, _, lhs_a =
        split_components coer_lhs in
      let lhs_qvars,_ = CF.split_quantifiers coer_lhs in
      (************************************************************************)
      (* also rename the existential vars in the lhs.
         To ensure that after each application of a specific
         coercion, the exist vars are different *)
      let lhs_qvars_new = CP.fresh_spec_vars lhs_qvars in
      let lhs_heap  =  CF.subst_avoid_capture_h lhs_qvars lhs_qvars_new lhs_heap in
      let lhs_guard = MCP.subst_avoid_capture_memo lhs_qvars lhs_qvars_new lhs_guard in
      let lhs_vperm = CVP.subst_avoid_capture lhs_qvars lhs_qvars_new lhs_vperm in
      let coer_rhs = subst_avoid_capture lhs_qvars lhs_qvars_new coer_rhs in
      (**************************************************************)
      let lhs_guard = MCP.fold_mem_lst (CP.mkTrue no_pos) false false lhs_guard
      in
      (* TODO : check with_dupl, with_inv *)
      let lhs_hs = CF.split_star_conjunctions lhs_heap in
      (*BE CAREFUL, the first node is not always the self node.
        May consider using the prior implementation in para5
        (i.e. using pick_up_node to identify head_hode)
      *)
      let head_node = List.hd lhs_hs in
      let extra_heap = join_star_conjunctions (List.tl lhs_hs) in
      let p1,c1,perm1,ps1,ho_ps1,p2,c2,perm2,ps2,ho_ps2 =
        match anode, head_node with
        | ViewNode ({
            h_formula_view_node = p1;
            h_formula_view_name = c1;
            h_formula_view_perm = perm1; (*LDK*)
            h_formula_view_ho_arguments = ho_ps1;
            h_formula_view_arguments = ps1} (* as h1 *)),
          ViewNode ({
              h_formula_view_node = p2;
              h_formula_view_name = c2;
              h_formula_view_perm = perm2; (*LDK*)
              h_formula_view_ho_arguments = ho_ps2;
              h_formula_view_arguments = ps2} (* as h2 *))
          when CF.is_eq_node_name c1 c2 ->
          p1,c1,perm1,ps1,ho_ps1,p2,c2,perm2,ps2,ho_ps2
        | DataNode ({
            h_formula_data_node = p1;
            h_formula_data_name = c1;
            h_formula_data_perm = perm1; (*LDK*)
            h_formula_data_arguments = ps1} (* as h1 *)),
          DataNode ({
              h_formula_data_node = p2;
              h_formula_data_name = c2;
              h_formula_data_perm = perm2; (*LDK*)
              h_formula_data_arguments = ps2} (* as h2 *))
          when CF.is_eq_node_name c1 c2 ->
          p1,c1,perm1,ps1,[],p2,c2,perm2,ps2,[]
        | _ -> report_error no_pos "unexpecte match pattern"
      in
      let perms1, perms2 =
        if (Perm.allow_perm ()) then
          Perm.get_perm_var_lists perm1 perm2
        else ([],[]) in
      let fr_vars = perms2@(p2 :: ps2) in
      let to_vars = perms1@(p1 :: ps1) in
      let lhs_guard_new = CP.subst_avoid_capture fr_vars to_vars lhs_guard in
      let coer_rhs_new1 = subst_avoid_capture fr_vars to_vars coer_rhs in
      let extra_heap_new =  CF.subst_avoid_capture_h fr_vars to_vars extra_heap in
      let coer_rhs_new1, extra_heap_new =
        if (Perm.allow_perm ()) then
          match perm1, perm2 with
          | Some f1, None -> (*propagate perm into coercion*)
            (match !Globals.perm with
             | Bperm -> report_error no_pos "[solver.ml] normalize_w_coers : unexpected for bperm"
             | _ ->
               let f1 = List.hd (Perm.get_cperm_var perm1) in
               let rhs = propagate_perm_formula coer_rhs_new1 f1 in
               let extra, svl = propagate_perm_h_formula extra_heap_new f1 in
               (rhs,extra))
          | _ -> (coer_rhs_new1, extra_heap_new)
        else (coer_rhs_new1, extra_heap_new)
      in
      let coer_rhs_new = coer_rhs_new1 (*add_origins coer_rhs_new1 [coer.coercion_name]*) in
      let new_es_heap = anode in (*consumed*)
      let old_trace = estate.es_trace in
      let new_estate = { estate with
                         es_heap = new_es_heap;
                         es_formula = f;
                         es_trace=(("(normalizing-" ^ coer.coercion_name ^")")::old_trace);
                         es_is_normalizing = true } in
      let new_ctx1 = Ctx new_estate in
      let new_ctx = SuccCtx[((* set_context_must_match *) new_ctx1)] in
      (*prove extra heap + guard*)
      let conseq_extra = mkBase extra_heap_new (MCP.memoise_add_pure_N
                                                  (MCP.mkMTrue no_pos)
                                                  lhs_guard_new) lhs_vperm
          CF.TypeTrue (mkTrueFlow ()) [] no_pos in

      (*=====================================================*)
      (***********Handle high-order argument: BEGIN**********)
      if (List.length ho_ps1 != List.length ho_ps2) then
        let () = print_endline_quiet
            ("normalize_w_coers: ho_args mismatched between lhs node and
      coer_lhs node") in
        x_dinfo_zp
          (lazy
            ("normalize_w_coers: ho_args mismatched between lhs node and
      coer_lhs node")) no_pos ;
        (false, estate, h, p, vp, mkNormalFlow ()) (* false, return dummy h and p *)
      else
        let coer_rhs_new =
          if (ho_ps1=[]) then coer_rhs_new else
            let args = List.combine ho_ps1 ho_ps2 in
            let maps = List.map match_one_ho_arg_simple args in
            let maps = List.concat maps in
            let coer_rhs_new = CF.subst_hvar coer_rhs_new maps in
            coer_rhs_new
        in
        (***********Handle high-order argument: END**********)
        (*=====================================================*)
        let coer_rhs_new = CF.translate_set_comp_rel coer_rhs_new in

        x_dinfo_pp  ("loop in normalize_w_coers ? 3") no_pos;
        x_dinfo_pp  ("normalize_w_coers: process_one: check extra heap") no_pos;
        x_dinfo_zp (lazy ("normalize_w_coers: process_one: new_ctx: "
                          ^ (Cprinter.string_of_spec_var p2) ^ "\n"
                          ^ (Cprinter.string_of_context new_ctx1))) no_pos;
        x_dinfo_zp (lazy ("normalize_w_coers: process_one: conseq_extra:\n"
                          ^ (Cprinter.string_of_formula conseq_extra))) no_pos;

        let check_res, check_prf = x_add heap_entail prog false new_ctx conseq_extra no_pos in

        (* PROCCESS RESULT *)
        (match check_res with
         | FailCtx _ ->
           x_dinfo_zp (lazy ("normalize_w_coers: lemma matching failed")) no_pos;
           (false, estate, h, p, vp, mkNormalFlow ()) (* false, return dummy h and p *)
         | SuccCtx res -> match List.hd res with(*we expect only one result*)
           | OCtx (c1, c2) ->
             let () = print_string
                 ("[solver.+ml] Warning: normalize_w_coers: process_one: expect
        only one context \n") in
             (false, estate, h, p, vp, mkNormalFlow ())
           | Ctx es ->
             let new_ante = normalize_replace es.es_formula coer_rhs_new no_pos in
             (* let new_ante = add_mix_formula_to_formula p new_ante in *)
             let new_ante = CF.remove_dupl_conj_eq_formula new_ante in
             let new_ante = x_add_1 Cformula.translate_set_comp_rel new_ante in
             let h1,p1,vp1,fl1,_,_ = split_components new_ante in
             let new_es = {new_estate with es_formula=new_ante; es_trace=old_trace} in
             let new_es =
               if (CF.formula_is_eq_flow coer_rhs !bfail_flow_int) then
                 { new_es with es_conc_err = new_es.es_conc_err @ [(coer.coercion_name, pos)]; }
               else new_es
             in
             let () = print_endline_quiet ("normalize_w_coers: lemma "
                                           ^ coer.Cast.coercion_name ^" "
                                           ^" matching succeeded") in
             x_dinfo_zp (lazy ("lemma " ^ coer.Cast.coercion_name ^" "
                               ^" matching succeeded")) no_pos;
             x_dinfo_zp (lazy ("normalize_w_coers: new ctx: \n"
                               ^ (Cprinter.string_of_entail_state new_es)))
               no_pos;
             (true,new_es,h1,p1,vp1,fl1))
    in

    let process_one estate anode rest coer h p vp fl =
      let pr (c1,c2,c3,c4,c5,c6) = pr_triple string_of_bool
          Cprinter.string_of_entail_state (Cprinter.string_of_flow_formula "")
          (c1,c2,c6) in
      let pr_h = Cprinter.string_of_h_formula in
      Debug.no_7 "process_one_normalize"
        Cprinter.string_of_entail_state pr_h pr_h
        Cprinter.string_of_coercion pr_h
        Cprinter.string_of_mix_formula (Cprinter.string_of_flow_formula "") pr
        (fun _ _ _ _ _ _ _ -> process_one_x estate anode rest coer h p vp fl)
        estate anode rest coer h p fl
    in

    (*process a list of pairs (anode * rest) *)
    let rec process_one_h h_lst =
      match h_lst with
      | [] ->
        (* so far, could not find any entailment -> can not normalize *)
        estate,h,p,vp,fl
      | (anode,rest)::xs ->
        (*for each pair (anode,rest), find a list of coercions*)
        let c_lst =
          try
            let name = match anode with
              | ViewNode vn -> vn.h_formula_view_name
              | DataNode dn -> dn.h_formula_data_name
              | ThreadNode tn -> tn.h_formula_thread_name
              (* TODO:WN:HVar *)
              | HVar (v,hvar_vs) -> (CP.name_of_spec_var v)
              | HTrue -> "htrue"
              | _ -> raise Not_found
              (* "" *)
            in look_up_coercion_def_raw coers name
          with Not_found -> []
        in
        (* let c_lst = look_up_coercion_def_raw coers name in  *)(*list of coercions*)
        let lst = List.map (fun c -> (c,anode,rest)) c_lst in
        (*process a triple (coer,anode,res)*)
        let rec process_one_coerc lst =
          match lst with
          | [] ->
            (*so far, there is no entailment -> process the rest of pairs of (anode,rest)*)
            process_one_h xs
          | ((coer,anode,res)::xs1) ->
            (*for each triple, try to find a posible entailment*)
            let res,res_es,res_h,res_p,res_vp,res_fl =
              process_one estate anode rest coer h p vp fl in
            if (res) (*we could find a result*)
            then
              (*restart and normalize the new estate*)
              let res_es = CF.clear_entailment_history_es2 (fun x -> None) res_es in
              let res_es,res_h2,res_p2,res_vp2,res_fl2 =
                helper res_es res_h res_p res_vp res_fl in
              res_es,res_h2,res_p2,res_vp2,res_fl2 (*TOCHECK: why res_fl2 != res_fl*)
            else
              (*otherwise, try the rest*)
              process_one_coerc xs1
        in
        process_one_coerc lst
    in
    (*split into pairs of (single node * the rest)  *)
    let h_lst = split_linear_node_guided [] h in
    process_one_h h_lst
  in
  helper estate h p vp fl (*start*)

and normalize_es_formula_w_coers prog estate (f: formula) (coers: coercion_decl
  list) pos: CF.entail_state * formula =
  if not(!Globals.old_norm_w_coerc)
  then (estate, f)
  else
    (* this part goes into a loop with ex61a.slk *)
    let () = x_winfo_pp "into normalization_with_coerc? why?" no_pos in
    if (isAnyConstFalse f ) (* || (!Globals.perm = NoPerm) *) then (estate, f)
    else if !Globals.perm = Dperm then (estate, normalize_formula_perm prog f)
    else if coers==[] then (estate, f)
    else
      let coers = List.filter (fun c ->
          match c.coercion_case with
          | Cast.Simple -> false
          | Cast.Complex -> if (c.coercion_type = Iast.Left) then true else false
          | Cast.Ramify -> false
          | Cast.Normalize false -> false
          | Cast.Normalize true -> true) coers
      in
      let rec helper f =
        match f with
        | Base b ->
          let h = b.formula_base_heap in
          let p = b.formula_base_pure in
          let vp = b.formula_base_vperm in
          (* let t = b.formula_base_type in *)
          let fl = b.formula_base_flow in
          (* let br = b.formula_base_branches in *)
          let es,nh,np,nvp,nfl = normalize_w_coers prog estate coers h p vp (* t
  *) fl (* br *) pos in
          let np = remove_dupl_conj_mix_formula np in
          es,
          (Base { b with
                  formula_base_heap=nh;
                  formula_base_pure=np;
                  formula_base_vperm=nvp;
                  formula_base_flow=nfl })
        | Exists e ->
          let h = e.formula_exists_heap in
          let p = e.formula_exists_pure in
          let vp = e.formula_exists_vperm in
          (* let t = e.formula_exists_type in *)
          let fl = e.formula_exists_flow in
          (* let br = e.formula_exists_branches in *)
          let es,nh,np,nvp,nfl = normalize_w_coers prog estate coers h p vp (* t
  *) fl (* br *) pos in
          let np = remove_dupl_conj_mix_formula np in
          es,
          Exists {e with
                  formula_exists_heap=nh;
                  formula_exists_pure=np;
                  formula_exists_vperm=nvp;
                  formula_exists_flow=nfl }
        | Or o ->
          let es1, f1 = helper o.formula_or_f1 in
          let es2, f2 = helper o.formula_or_f2 in
          let es = estate in
          es, Or {o with formula_or_f1 = f1; formula_or_f2 = f2}
      in
      if coers ==[] then
        begin
          (* let () = print_endline ("No combine lemma in left coercion?") in *)
          Debug.ninfo_zprint (lazy  "No combine lemma in left coercion?") no_pos;
          (estate, f)
        end
      else
        begin
          (* let () = print_endline ("normalize_formula_w_coers: "   *)
          (* ^ " ### coers = " ^ (Cprinter.string_of_coerc_list coers)  *)
          (* ^ "\n\n") in *)
          Debug.ninfo_zprint (lazy ("normalize_formula_w_coers: "
                                    ^ " ### coers = " ^ (Cprinter.string_of_coerc_list coers)
                                    ^ "\n\n")) no_pos;
          helper f
        end

and normalize_estate_w_coers prog estate (coers: coercion_decl list) pos:
  CF.entail_state =
  if !Globals.eager_coercions then
    let es, f = normalize_es_formula_w_coers prog estate estate.CF.es_formula
        coers pos in
    {es with es_formula = f; }
  else
    estate

and normalize_formula_w_coers_x prog estate (f: formula) (coers: coercion_decl
  list): formula =
  if !Globals.eager_coercions then
    snd (normalize_es_formula_w_coers prog estate f coers no_pos)
  else
    f

and normalize_formula_w_coers i prog estate (f:formula) (coers:coercion_decl
  list): formula =
  let fn = wrap_proving_kind  PK_Lemma_Norm (normalize_formula_w_coers_x  prog
                                               estate f) in
  let pr = Cprinter.string_of_formula in
  let pr_c = Cprinter.string_of_coerc_decl_list in
  let pr3 l = string_of_int (List.length l) in
  Debug.no_2_num i "normalize_formula_w_coers" pr pr3 pr
    (fun _ _ -> fn coers) f coers

and normalize_struc_formula_w_coers prog estate (f:struc_formula) coers :
  struc_formula =
  let n_form f = normalize_formula_w_coers 4 prog estate f coers in
  let rec helper f = match f with
    | EList b-> EList (map_l_snd helper b)
    | ECase b-> ECase{
        b with formula_case_branches = map_l_snd helper b.formula_case_branches}
    | EBase b-> EBase {
        b with formula_struc_base = n_form b.formula_struc_base;
               formula_struc_continuation
               = map_opt helper b.formula_struc_continuation}
    | EInfer b-> EInfer{
        b with formula_inf_continuation= helper b.formula_inf_continuation}
    | EAssume b-> EAssume {
        b with formula_assume_simpl = n_form b.formula_assume_simpl;
               formula_assume_struc = helper b.formula_assume_struc;}
  in helper f

(*
  hs1: list of formulas to match
  hs2: list of formula to be matched
  return: matches * remained_hs1
*)
and find_possible_matches_x (hs1: h_formula list) (hs2: h_formula list) :
  ((h_formula * h_formula) list * h_formula list) list =
  if (List.length hs1 < List.length hs2 || List.length hs1 < 1) then []
  else
    let rec find_one_x (h: h_formula) (hs: h_formula list)
      : ((h_formula * h_formula) list * h_formula list) list =
      try
        let h_name = get_node_name 23 h in
        (match hs with
         | [] -> []
         | x::xs ->
           let res = find_one_x h xs in
           let m2 = List.map (fun (ls, rest) -> (ls, x::rest)) res in
           (try
              let x_name = get_node_name 24 x in
              if (h_name = x_name) then
                (* A possible match (h,x) *)
                let m1 = ([(x,h)],xs) in
                m1::m2
              else m2
            with _ -> m2))
      with _ -> []
    in
    let find_one (h: h_formula) (hs: h_formula list)
      : ((h_formula * h_formula) list * h_formula list) list =
      let prh = Cprinter.string_of_h_formula in
      let prhl = pr_list prh in
      let pr_out = pr_list (pr_pair (pr_list (pr_pair prh prh)) prhl) in
      Debug.no_2 "find_one" prh prhl pr_out find_one_x h hs
    in
    let helper (ls: ((h_formula * h_formula) list * h_formula list) list)
        (h: h_formula):
      ((h_formula * h_formula) list * h_formula list) list =
      let res = List.map (fun (m,rest) ->
          let res = find_one h rest in
          let res = List.map (fun (ls,rest) -> (m@ls,rest)) res in
          res) ls
      in List.concat res
    in
    let res = List.fold_left helper (find_one (List.hd hs2) hs1) (List.tl hs2)
    in res

and find_possible_matches (hs1 : h_formula list) (hs2 : h_formula list) :
  ((h_formula * h_formula) list * h_formula list) list =
  let prh = Cprinter.string_of_h_formula in
  let pr1 = pr_list prh in
  let pr2 = pr_list (pr_pair prh prh) in
  let pr_out = pr_list (pr_pair pr2 pr1) in
  Debug.no_2 "find_possible_matches" pr1 pr1 pr_out
    find_possible_matches_x hs1 hs2

(* normalize a formula using propagation lemma *)
and prop_w_coers prog (estate: CF.entail_state) (coers: coercion_decl list)
    (h: h_formula) (p: MCP.mix_formula) (vp: CVP.vperm_sets) (fl: flow_formula) :
  (CP.spec_var list * h_formula * MCP.mix_formula * flow_formula) =
  let pr_h = Cprinter.string_of_h_formula in
  let pr_p = Cprinter.string_of_mix_formula in
  let pr_fl = Cprinter.string_of_flow_formula "" in
  let pr_svl = Cprinter.string_of_spec_var_list in
  let pr_r = (pr_quad pr_svl pr_h pr_p pr_fl) in
  let pr_cl = Cprinter.string_of_coerc_decl_list in
  Debug.no_4 "prop_w_coers" pr_cl pr_h pr_p pr_fl pr_r
    (fun _ _ _ _ -> prop_w_coers_x prog estate coers h p vp fl) coers h p fl

and prop_w_coers_x prog (estate: CF.entail_state) (coers: coercion_decl list)
    (h: h_formula) (p: MCP.mix_formula) (vp: CVP.vperm_sets) (fl: flow_formula):
  (CP.spec_var list * h_formula * MCP.mix_formula * flow_formula) =


  (* pairs: (c1::CNT<>, cx::CNT), (c2::CNT<>, cy::CNT)         *)
  (* to_lhs: c1=cx, c2=cy                                      *)
  (* prove: c1::CNT<> * c2::CNT<> * A & c1=cx, c2=cy |- cx::CNT<> * cy::CNT<> * B --> residue *)
  let rec process_one_prop_w_coer_x pairs (lhs_h: h_formula)
      (lhs_h_rest: h_formula) lhs_p (lhs_fl: flow_formula) (rhs: formula)
      (coer_guard: mix_formula):
    (CP.spec_var list * h_formula * MCP.mix_formula * flow_formula) option =
    let to_lhs = List.fold_left (fun pf (h1, h2) ->
        (* TOCHECK: perm & ho_args *)
        let n1 = (get_node_var h1) in
        let n2 = (get_node_var h2) in
        let args1 = get_node_args h1 in
        let args2 = get_node_args h2 in
        let perm_vars1, perm_vars2 = Perm.get_perm_var_lists (get_node_perm h1)
            (get_node_perm h2) in
        let eqns = List.combine ([n1] @ args1 @ perm_vars1)
            ([n2] @ args2 @ perm_vars2) in
        let eq = List.fold_left (fun pf (v1, v2) ->
            let eq = CP.mkEqVar v1 v2 no_pos in
            CP.mkAnd pf eq no_pos) (CP.mkTrue no_pos) eqns
        in CP.mkAnd pf eq no_pos) (CP.mkTrue no_pos) pairs
    in
    let is_eq mp v1 v2 =
      if CP.eq_spec_var v1 v2 then true
      else
        try
          let mg = List.find (fun m -> Gen.BList.subset_eq CP.eq_spec_var
                                 [v1; v2] m.memo_group_fv) mp in
          let eset = mg.memo_group_aset in
          if (CP.EMapSV.is_equiv eset v1 v2) then true
          else x_add TP.imply_raw_mix (MCP.mix_of_memo [mg])
              (MCP.mix_of_pure (CP.mkEqVar v1 v2 no_pos))
        with _ -> false
    in
    let m_lhs_p = MCP.memo_of_mix lhs_p in
    let rec mkNeq vs =
      match vs with
      | [] -> CP.mkTrue no_pos
      | v::vs ->
        let neq_vs = mkNeq vs in
        let neq = List.fold_left (fun neq_a v1 ->
            if is_eq m_lhs_p v v1 then neq_a
            else
              let neq = CP.mkNeqVar v v1 no_pos in
              CP.mkAnd neq_a neq no_pos) neq_vs vs
        in neq
    in
    let neq = mkNeq (List.map (fun (h1, _) -> get_node_var h1) pairs) in
    let e_lhs_p = CF.add_mix_formula_to_mix_formula lhs_p
        (MCP.mix_of_pure to_lhs) in
    let e_lhs_p = CF.add_mix_formula_to_mix_formula e_lhs_p (MCP.mix_of_pure neq
                                                            ) in
    if not (TP.is_sat_raw e_lhs_p) then None
    else
      let inst_vars = List.concat (List.map (fun (_, h2) ->
          [(get_node_var h2)] @ (get_node_args h2)) pairs) in
      let diff = Gen.BList.difference_eq CP.eq_spec_var in
      let evars = diff (CF.fv rhs) inst_vars in
      let rhs_p = MCP.mix_push_exists evars coer_guard in
      let r = x_add TP.imply_raw_mix e_lhs_p rhs_p in
      if r then Some (inst_vars, lhs_h_rest, e_lhs_p, lhs_fl)
      else None

  and process_one_prop_w_coer pairs (lhs_h: h_formula) (lhs_h_rest: h_formula)
      lhs_p (lhs_fl: flow_formula) (rhs: formula) (coer_guard: mix_formula):
    (CP.spec_var list * h_formula * MCP.mix_formula * flow_formula) option =
    let prf = Cprinter.string_of_formula in
    let prm = Cprinter.string_of_mix_formula in
    let prh = Cprinter.string_of_h_formula in
    let prfl = Cprinter.string_of_flow_formula "" in
    let prsvl = Cprinter.string_of_spec_var_list in
    let pr_out = pr_option (pr_quad prsvl prh prm prfl) in
    let pr1 = pr_list (pr_pair prh prh) in
    Debug.no_7 "process_one_prop_w_coer" pr1 prh prh prm prfl prf prm pr_out
      process_one_prop_w_coer_x pairs lhs_h lhs_h_rest lhs_p lhs_fl rhs
      coer_guard
  in (* process_one_prop_w_coer: END *)

  (* process a list of pairs (anode * rest) *)
  let rec process_coers coers h p vp fl
    : (CP.spec_var list * h_formula * MCP.mix_formula * flow_formula) =
    match coers with
    | [] -> [], h, p, fl
    | coer::xs ->
      let coer_lhs = coer.coercion_head in
      let coer_rhs = coer.coercion_body in
      (* rename coer *)
      (* compute free vars in extra heap and guard *)
      let extra_vars =
        let vars = CF.fv coer_lhs in
        let vars = List.filter (fun (CP.SpecVar (_, id, _)) ->
            not (id = Globals.cyclic_name ||
                 id = Globals.acyclic_name ||
                 id = Globals.concrete_name ||
                 id = Globals.set_comp_name )) vars in (* ignore cyclic & acyclic rels *)
        Gen.BList.remove_dups_eq CP.eq_spec_var vars
      in
      (* rename the bound vars *)
      let tmp_rho = List.combine extra_vars (CP.fresh_spec_vars extra_vars) in
      let coer_lhs = x_add CF.subst tmp_rho coer_lhs in
      let coer_rhs = x_add CF.subst tmp_rho coer_rhs in
      (* rename the free vars from the rhs that do not appear in the lhs *)
      let lhs_fv = (fv_rhs coer_lhs coer_rhs) in
      let fresh_lhs_fv = CP.fresh_spec_vars lhs_fv in
      let tmp_rho = List.combine lhs_fv fresh_lhs_fv in
      let coer_lhs = x_add CF.subst tmp_rho coer_lhs in
      let coer_rhs = x_add CF.subst tmp_rho coer_rhs in
      (************************************************************************)
      let coer_heap, coer_guard, coer_vperm, coer_flow, _, coer_a =
        split_components coer_lhs in
      let lhs_qvars, _ = CF.split_quantifiers coer_lhs in
      (************************************************************************)
      let coer_lhs_hs = CF.split_star_conjunctions coer_heap in (* |lhs_hs|>1 *)
      let hs = CF.split_star_conjunctions h in
      (* Find all possible ways to match with the LHS of coer *)
      let matches = find_possible_matches hs coer_lhs_hs in
      (* Apply all possible matches of this coer, one by one, until find one *)
      let rec iter_coer matches =
        match matches with
        | [] -> None
        | (pairs, rest)::matches_rest ->
          let h_rest = join_star_conjunctions rest in
          let r = process_one_prop_w_coer pairs h h_rest p fl coer_lhs coer_guard in
          match r with
          | None -> iter_coer matches_rest (* not applicable -> move on to next *)
          | Some r -> Some r (* find one -> stop *)
      in
      let res = iter_coer matches in
      (match res with
       | None -> process_coers xs h p vp fl (* Use the next coer *)
       | Some (nvars, nh, np, nfl) ->
         let b = mkBase nh np vp TypeTrue nfl [] no_pos in
         let new_f = normalize_replace b coer_rhs no_pos in
         let new_f = add_quantifiers nvars new_f in
         let new_f = elim_exists new_f in
         let _ , new_f = split_quantifiers new_f in
         let nh, np, nvp, nfl, _, _ = split_components new_f in
         let (nvars2, h2, p2, fl2) = process_coers coers nh np vp nfl in
         (nvars2, h2, p2, fl2))
  in
  let res = process_coers coers h p vp fl in
  res

(* Apply propagation lemmas (lemma_prop) to formula *)
and prop_formula_w_coers i prog estate (f: formula) (coers: coercion_decl list):
  formula =
  let fn = wrap_proving_kind PK_Lemma_Prop (prop_formula_w_coers_x prog estate f
                                           ) in
  let pr_f = Cprinter.string_of_formula in
  let pr_out = pr_f in
  let pr_c = Cprinter.string_of_coerc_decl_list in
  let pr3 l = string_of_int (List.length l) in
  Debug.no_2_num i "prop_formula_w_coers" pr_f pr_c pr_out
    (fun _ _ -> fn coers) f coers

and prop_formula_w_coers_x prog estate (f: formula) (coers: coercion_decl list):
  formula =
  let f = elim_unsat_all prog f in
  if (isAnyConstFalse f) then f
  else if coers == [] then f
  else
    let coers = List.filter (fun c -> c.coercion_kind = LEM_PROP) coers in
    let rec helper f =
      match f with
      | Base b ->
        let h = b.formula_base_heap in
        let p = b.formula_base_pure in
        let vp = b.formula_base_vperm in
        let fl = b.formula_base_flow in
        let (vars, nh, np, nfl) = prop_w_coers prog estate coers h p vp fl in
        let np = remove_dupl_conj_mix_formula np in
        let b = Base { b with
                       formula_base_heap = nh;
                       formula_base_pure = np;
                       formula_base_flow = nfl; }
        in
        let nf = add_quantifiers vars b in
        let nf = elim_exists nf in
        nf
      | Exists e ->
        let qvars,nf = split_quantifiers f in
        let nf = helper nf in
        let nf = add_quantifiers qvars nf in
        let nf = elim_exists nf in
        nf
      | Or o -> Or { o with
                     formula_or_f1 = helper o.formula_or_f1;
                     formula_or_f2 = helper o.formula_or_f2; }
    in
    if coers == [] then
      begin
        Debug.ninfo_zprint (lazy  "No combine lemma in left coercion?") no_pos;
        f
      end
    else
      begin
        Debug.ninfo_zprint (lazy ("prop_formula_w_coers: " ^ " ### coers = " ^
                                  (Cprinter.string_of_coerc_list coers) ^ "\n\n"
                                 )) no_pos;
        helper f
      end

and normalize_perm_prog prog = prog

(************************************************************)
(* apply_right_coercion *)
(************************************************************)
and apply_right_coercion estate coer prog (conseq:CF.formula) resth2 ln2 lhs_b
    rhs_b (c2:ident) is_folding pos =
  let pr (e,_) = Cprinter.string_of_list_context e in
  let pr_es = Cprinter.string_of_entail_state(* _short *) in
  Debug.no_5 "apply_right_coercion" pr_es Cprinter.string_of_h_formula
    Cprinter.string_of_h_formula
    Cprinter.string_of_coercion
    Cprinter.string_of_formula_base
    pr (fun _ _ _ _ _ -> apply_right_coercion_a estate coer prog
           (conseq:CF.formula) resth2 ln2  lhs_b rhs_b (c2:ident) is_folding pos
       ) estate ln2 resth2 coer  rhs_b

(* ln2 - RHS matched node
   resth2 - RHS remainder
   rhs_p - lhs mix pure
   rhs_t - type of formula? (for OO)
   rhs_fl - flow
   ?rhs_br - not present? why?
   lhs_b - lhs base
   rhs_b - rhs base
   c2 - rhs pred name
   is_folding
   pos
   pid - ?id
*)

and apply_right_coercion_a estate coer prog (conseq:CF.formula) resth2 ln2 lhs_b
  rhs_b (c2:ident) is_folding pos =
  let vd = x_add_1 Cast.vdef_lemma_fold prog coer in
  match vd with
  | None ->
    apply_right_coercion_b estate coer prog conseq resth2 ln2 lhs_b rhs_b c2
      is_folding pos
  | Some vd ->
    let view_for_unfold = Norm.norm_formula_for_unfold prog vd in
    let vd = view_for_unfold in
    let can_fold = (
      if (Perm.allow_perm ()) then false else
      if not(!Globals.allow_lemma_fold) then false
      else match ln2 with
        | ViewNode _ -> true
        | _ -> false
    ) in
    if not can_fold then
      (* 11/02/2014: Why allow FOLD when doing right coercion?
         Currently, the vdef_lemma_fold above may be too strong
         in the presence of permissions
      *)
      apply_right_coercion_b estate coer prog conseq resth2 ln2 lhs_b rhs_b c2
        is_folding pos
    else
      let (_ (* estate *),iv,ivr) = Infer.remove_infer_vars_all estate (* rt *)in
      let rhs_node = ln2 in
      let rhs_rest = resth2 in
      let () = x_dinfo_hp (add_str "rhs_node" Cprinter.string_of_h_formula)
          rhs_node no_pos in
      let () = x_dinfo_hp (add_str "conseq" Cprinter.string_of_formula) conseq
          no_pos in
      let () = x_dinfo_hp (add_str "vd(for lemma folding)"
                             Cprinter.string_of_view_decl_short) vd no_pos in
      let () = x_dinfo_hp (add_str "rhs_rest" Cprinter.string_of_h_formula)
          rhs_rest no_pos in
      let (a,b) = x_add do_fold prog (Some (iv,ivr,vd)) estate conseq rhs_node
          rhs_rest rhs_b is_folding pos in
      (a,[b])
(* why do_fold use proof & apply_right_coercion is proof list *)

and apply_right_coercion_b estate coer prog (conseq:CF.formula) resth2 ln2 lhs_b
  rhs_b (c2:ident) is_folding pos =
  let _,rhs_p,rhs_vp,rhs_t,rhs_fl, rhs_a = CF.extr_formula_base rhs_b in
  let f = mkBase resth2 rhs_p rhs_vp rhs_t rhs_fl rhs_a pos in
  let () = x_dinfo_zp (lazy ("do_right_coercion : c2 = "  ^ c2 ^ "\n")) pos in
  (* if is_coercible ln2 then *)
  let ok, new_rhs = x_add rewrite_coercion prog estate ln2 f coer lhs_b rhs_b
      lhs_b false pos in
  if (is_coercible ln2)&& (ok>0)  then begin
    (* lhs_b <- rhs_b *)
    (*  _ |- ln2 *)
    (*  fold by removing a single RHS node ln2, and replaced with lhs_b into new_rhs with explicit instantiations *)
    (* need to make implicit var become explicit *)
    let vl = Gen.BList.intersect_eq CP.eq_spec_var estate.es_gen_impl_vars
        (h_fv ln2) in
    let new_iv = Gen.BList.difference_eq CP.eq_spec_var estate.es_gen_impl_vars
        vl in
    let () = if not(vl==[])
      then x_dinfo_zp (lazy ("do_right_coercion : impl to expl vars  "
                             ^ (Cprinter.string_of_spec_var_list vl) ^ "\n"))
          pos in
    let old_trace = estate.es_trace in
    let estate = {estate with es_trace=(("(right: " ^ coer.coercion_name ^ ")")
                                        ::old_trace)} in
    let ctx0 = Ctx estate in
    let nctx = set_context (fun es -> {es with
                                       es_gen_impl_vars = new_iv;
                                       es_gen_expl_vars =  (es.es_gen_expl_vars
                                                            @vl)}) ctx0 in
    let new_ctx = SuccCtx [nctx] in
    let res, tmp_prf = x_add heap_entail prog is_folding new_ctx new_rhs pos in
    let res = set_list_context (fun es -> {es with es_gen_expl_vars
                                                   =  estate.es_gen_expl_vars})
        res in
    let prf = mkCoercionRight ctx0 conseq coer.coercion_head
        coer.coercion_body tmp_prf  coer.coercion_name
    in
    (res, [prf])
  end else
    let () = x_dinfo_zp (lazy ("do_right_coercion :  " ^ c2 ^ "failed \n")) pos in
    let msg = "failed right coercion application" in
    (CF.mkFailCtx_in(Basic_Reason ( {fc_message = msg;
                                     fc_current_lhs = estate;
                                     fc_current_ents = [];
                                     fc_prior_steps = estate.es_prior_steps;
                                     fc_orig_conseq = estate.es_orig_conseq;
                                     fc_current_conseq = CF.formula_of_heap HFalse pos;
                                     fc_failure_pts = match (get_node_label ln2)
                                       with | Some s-> [s] | _ -> [];},
                                    CF.mk_failure_must "13" Globals.sl_error,
                                    estate.es_trace))
       ((convert_to_must_es estate), msg, Failure_Must msg) (mk_cex true), [])

(******************************************************************************************************************
   10.06.2008
   Utilities for simplifications:
   - whenever the pure part contains some arithmetic formula that can be further simplified --> call the theorem prover to perform the simplification
   Ex. x = 1 + 0 --> simplify to x = 1
 ******************************************************************************************************************)

and combine_struc_base b1 b2 =
  let cont_f = (match b2.formula_struc_continuation with
      | None-> b1.formula_struc_continuation
      | _ -> report_error no_pos "combine_struc_base unexpected continuations") in
  {
    formula_struc_explicit_inst = b1.formula_struc_explicit_inst
                                 @b2.formula_struc_explicit_inst;
    formula_struc_implicit_inst = b1.formula_struc_implicit_inst
                                  @b2.formula_struc_implicit_inst;
    formula_struc_exists = b1.formula_struc_exists @ b2.formula_struc_exists;
    formula_struc_base = normalize_combine b1.formula_struc_base
        b2.formula_struc_base no_pos;
    formula_struc_pos = b1.formula_struc_pos;
    formula_struc_continuation = cont_f;
    formula_struc_is_requires = cont_f!=None;
  }

and combine_struc_x (f1:struc_formula)(f2:struc_formula) :struc_formula =
  match f2 with
  | ECase b -> ECase {b with formula_case_branches
                             = map_l_snd (combine_struc_x f1)
                                 b.formula_case_branches}
  | EBase b ->
    begin
      match b.formula_struc_continuation with
      | Some sf ->
        let comb_sf = combine_struc_x f1 sf in
        EBase {b with formula_struc_continuation = Some comb_sf}
      | None ->
        (match f1 with
         | EBase b1 -> EBase (combine_struc_base b1 b)
         | _ ->
           (match b.formula_struc_continuation with
            | None -> EBase {b with formula_struc_continuation = Some f1}
            | Some l -> EBase {b with formula_struc_continuation = Some
                                          (combine_struc_x f1 l)}))
    end
  | EAssume {
      formula_assume_vars= x1;
      formula_assume_simpl = b;
      formula_assume_lbl = (y1',y2');
      formula_assume_struc = b_str;
      formula_assume_ensures_type = t1;}->
    (match f1 with
     | EAssume {
         formula_assume_vars= x2;
         formula_assume_simpl = d;
         formula_assume_struc = d_str;
         formula_assume_lbl = (y1,y2);
         formula_assume_ensures_type = t2;} ->
       let f = normalize_combine b d (Cformula.pos_of_formula d) in
       let f_str = combine_struc_x b_str d_str in
       mkEAssume (x1@x2) f f_str (y1,(y2^y2')) t1
     | _-> combine_struc_x f2 f1)
  | EInfer e -> (match f1 with
      | EInfer e2 ->
        EInfer {e with formula_inf_vars = e.formula_inf_vars@e2.formula_inf_vars;
                       formula_inf_continuation
                       = combine_struc_x e.formula_inf_continuation
                           e2.formula_inf_continuation}
      | _ -> EInfer {e with formula_inf_continuation
                            = combine_struc_x f1 e.formula_inf_continuation})
  | EList b -> EList (map_l_snd (combine_struc_x f1) b)(*push labels*)

and combine_struc f1 f2 =
  Debug.no_2 "combine_struc" !print_struc_formula !print_struc_formula !
    print_struc_formula combine_struc_x f1 f2

and compose_struc_formula (delta : struc_formula) (phi : struc_formula) (x :
  CP.spec_var list) (pos : loc) =
  let rs = CP.fresh_spec_vars x in
  let rho1 = List.combine (List.map CP.to_unprimed x) rs in
  let rho2 = List.combine (List.map CP.to_primed x) rs in
  let new_delta = subst_struc rho2 delta in
  let new_phi = subst_struc rho1 phi in
  let new_f = combine_struc new_phi new_delta in
  let resform = push_struc_exists rs new_f in
  resform

(* Merging fractional heap nodes when possible using normalization lemmas *)
and normalize_entail_state_w_lemma_x prog (es:CF.entail_state) =
  let es = CF.clear_entailment_vars es in
  (* create a tmp estate for normalizing *)
  let tmp_es = CF.empty_es (CF.mkTrueFlow ()) es.CF.es_group_lbl no_pos in
  let left_co = Lem_store.all_lemma # get_left_coercion in
  CF.Ctx {es with CF.es_formula = normalize_formula_w_coers 5 prog tmp_es
                      es.CF.es_formula left_co}

and normalize_entail_state_w_lemma prog (es:CF.entail_state) =
  Debug.no_1 "normalize_entail_state_w_lemma"
    Cprinter.string_of_estate Cprinter.string_of_context
    (fun _ -> normalize_entail_state_w_lemma_x prog es) es

and prop_entail_state_w_lemma_x prog (es:CF.entail_state) =
  let es = CF.clear_entailment_vars es in
  (* create a tmp estate for propagation *)
  let tmp_es = CF.empty_es (CF.mkTrueFlow ()) es.CF.es_group_lbl no_pos in
  let left_co = Lem_store.all_lemma # get_left_coercion in
  CF.Ctx {es with CF.es_formula = prop_formula_w_coers 5 prog tmp_es
                      es.CF.es_formula left_co}

(* Exhaustively apply propagation lemmas to entail_state *)
and prop_entail_state_w_lemma prog (es:CF.entail_state) =
  Debug.no_1 "prop_entail_state_w_lemma"
    Cprinter.string_of_estate Cprinter.string_of_context
    (fun _ -> prop_entail_state_w_lemma_x prog es) es

and normalize_list_failesc_context_w_lemma_x prog lctx =
  (* TO CHECK merging nodes *)
  if (Lem_store.all_lemma # get_left_coercion) == [] then lctx
  else
    let fct = normalize_entail_state_w_lemma prog in
    let res = CF.transform_list_failesc_context (idf,idf,fct) lctx in
    res

and normalize_list_failesc_context_w_lemma prog lctx =
  let pr = Cprinter.string_of_list_failesc_context in
  Debug.no_1 "normalize_list_failesc_context_w_lemma" pr pr
    (normalize_list_failesc_context_w_lemma_x prog) lctx

and normalize_list_partial_context_w_lemma prog lctx =
  if (Lem_store.all_lemma # get_left_coercion) == [] then lctx
  else
    let fct = normalize_entail_state_w_lemma prog in
    let res = CF.transform_list_partial_context (fct, idf) lctx in
    res

let heap_entail_one_context_new (prog : prog_decl) (is_folding : bool) (b1:bool)
    (ctx : context) (conseq : formula) (tid: CP.spec_var option)
    (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos
    (b2:control_path_id): (list_context * proof) =
  x_add heap_entail_one_context 11 prog is_folding  ctx conseq tid delayed_f join_id pos

let heap_entail_struc_list_partial_context_init (prog : prog_decl)
    (is_folding : bool)  (has_post: bool)(cl : list_partial_context)
    (conseq:struc_formula) (tid: CP.spec_var option)
    (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos
    (pid:control_path_id) : (list_partial_context * proof) =
  let () = set_entail_pos pos in
  x_dinfo_zp (lazy ("heap_entail_init struc_list_partial_context_init:"
                    ^ "\ntid:" ^ (pr_opt Cprinter.string_of_spec_var tid)
                    ^ "\ndelayed_f:" ^ (pr_opt Cprinter.string_of_mix_formula delayed_f)
                    ^ "\nconseq:"^ (Cprinter.string_of_struc_formula conseq)
                    ^ "\nctx:\n" ^ (Cprinter.string_of_list_partial_context cl)
                    ^"\n")) pos;
  Gen.Profiling.push_time "entail_prune";
  let cl = prune_ctx_list prog cl in
  (*  let () = count_br_specialized prog cl in*)
  let conseq = prune_pred_struc prog false conseq in
  Gen.Profiling.pop_time "entail_prune";
  heap_entail_prefix_init prog is_folding  has_post cl conseq tid delayed_f
    join_id pos pid (rename_labels_struc,Cprinter.string_of_struc_formula
                    ,(x_add heap_entail_one_context_struc_nth 111))

(* this isn't called by hip at all *)
let heap_entail_struc_list_partial_context_init (prog : prog_decl)
    (is_folding : bool)  (has_post: bool)(cl : list_partial_context)
    (conseq:struc_formula) (tid: CP.spec_var option)
    (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos
    (pid:control_path_id) : (list_partial_context * proof) =
  let pr1 = Cprinter.string_of_list_partial_context_short in
  let pr2 = Cprinter.string_of_struc_formula in
  let pr3 (l,_)  = pr1 l in
  Debug.no_2 "heap_entail_struc_list_partial_context_init" pr1 pr2 pr3
    (fun _ _ -> wrap_collect_rel_lpc
        (heap_entail_struc_list_partial_context_init prog is_folding has_post cl
           conseq tid delayed_f join_id pos) pid) cl conseq

let heap_entail_struc_list_failesc_context_init (prog : prog_decl)
    (is_folding : bool)  (has_post: bool) (cl : list_failesc_context)
    (conseq:struc_formula) (tid: CP.spec_var option)
    (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos
    (pid:control_path_id) : (list_failesc_context * proof) =
  let () = set_entail_pos pos in
  x_dinfo_zp (lazy ("heap_entail_init struc_list_failesc_context_init:"
                    ^ "\ntid:" ^ (pr_opt Cprinter.string_of_spec_var tid)
                    ^ "\ndelayed_f:" ^ (pr_opt Cprinter.string_of_mix_formula delayed_f)
                    ^ "\nconseq:\n"^ (Cprinter.string_of_struc_formula conseq)
                    ^ "\nctx:\n" ^ (Cprinter.string_of_list_failesc_context cl)
                    ^"\n")) pos;
  let res,prf = x_add heap_entail_failesc_prefix_init 1 prog is_folding
      has_post cl conseq tid delayed_f join_id pos pid
      (rename_labels_struc,Cprinter.string_of_struc_formula
      ,(x_add heap_entail_one_context_struc_nth 2)) in
  (CF.list_failesc_context_simplify res,prf)

let heap_entail_struc_list_failesc_context_init i (prog : prog_decl)
    (is_folding : bool)  (has_post: bool) (cl : list_failesc_context)
    (conseq:struc_formula) (tid: CP.spec_var option)
    (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos
    (pid:control_path_id) : (list_failesc_context * proof) =
  let pr_lfc = Cprinter.string_of_list_failesc_context_short in
  Debug.no_2_num i "heap_entail_struc_list_failesc_context_init"
    pr_lfc
    Cprinter.string_of_struc_formula
    (fun (cl, _) -> pr_lfc cl)
    (fun _ _ -> wrap_collect_rel_lfc
        (heap_entail_struc_list_failesc_context_init prog is_folding has_post cl
           conseq tid delayed_f join_id pos) pid) cl conseq

let heap_entail_list_partial_context_init_x (prog : prog_decl)
    (is_folding : bool)  (cl : list_partial_context) (conseq:formula)
    (tid: CP.spec_var option) (delayed_f: MCP.mix_formula option)
    (join_id: CP.spec_var option) pos (pid:control_path_id)
  : (list_partial_context * proof) =
  let () = set_entail_pos pos in
  x_dinfo_zp (lazy ("heap_entail_init list_partial_context_init:"
                    ^ "\ntid:" ^ (pr_opt Cprinter.string_of_spec_var tid)
                    ^ "\ndelayed_f:" ^ (pr_opt Cprinter.string_of_mix_formula delayed_f)
                    ^ "\nconseq:\n"^ (Cprinter.string_of_formula conseq)
                    ^ "\nctx:\n" ^ (Cprinter.string_of_list_partial_context cl)
                    ^"\n")) pos;
  Gen.Profiling.push_time "entail_prune";
  if cl==[] then ([],UnsatAnte)
  else begin
    let cl = reset_original_list_partial_context cl in
    let cl_after_prune = prune_ctx_list prog cl in
    let conseq = prune_preds prog false conseq in
    Gen.Profiling.pop_time "entail_prune";
    (* RESOURCE: Normalize for combine lemma *)
    let norm_cl = normalize_list_partial_context_w_lemma prog cl_after_prune in
    let entail_fct = (fun c-> heap_entail_prefix_init prog is_folding false c
                         conseq tid delayed_f join_id pos pid
                         (rename_labels_formula ,Cprinter.string_of_formula,
                          heap_entail_one_context_new)) in
    heap_entail_agressive_prunning entail_fct (prune_ctx_list prog) (fun (c,_)->
        isSuccessListPartialCtx_new c) norm_cl
  end

let heap_entail_list_partial_context_init (prog : prog_decl) (is_folding : bool)
    (cl : list_partial_context) (conseq:formula) (tid: CP.spec_var option)
    (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos
    (pid:control_path_id) : (list_partial_context * proof) =
  let pr1 = Cprinter.string_of_list_partial_context in
  let pr2 = Cprinter.string_of_formula in
  let pr3 (a,_)= pr1 a in
  Debug.no_2 "heap_entail_list_partial_context_init" pr1 pr2 pr3
    (fun _ _ -> heap_entail_list_partial_context_init_x prog  is_folding cl
        conseq tid delayed_f join_id pos pid) cl conseq

(*this does not have thread id*)
let heap_entail_list_failesc_context_init_x (prog : prog_decl)
    (is_folding : bool)  (cl : list_failesc_context) (conseq:formula)
    (tid: CP.spec_var option) (delayed_f: MCP.mix_formula option)
    (join_id: CP.spec_var option) pos (pid:control_path_id)
  : (list_failesc_context * proof) =
  let () = set_entail_pos pos in
  x_dinfo_zp (lazy ("heap_entail_init list_failesc_context_init:"
                    ^ "\ntid:" ^ (pr_opt Cprinter.string_of_spec_var tid)
                    ^ "\ndelayed_f:" ^ (pr_opt Cprinter.string_of_mix_formula delayed_f)
                    ^ "\nconseq:\n"^ (Cprinter.string_of_formula conseq)
                    ^ "\nctx:\n" ^ (Cprinter.string_of_list_failesc_context cl)
                    ^"\n")) pos;
  if cl==[] then ([],UnsatAnte)
  else begin
    Gen.Profiling.push_time "entail_prune";
    let cl_after_prune = prune_ctx_failesc_list prog cl in
    let conseq = prune_preds prog false conseq in
    Gen.Profiling.pop_time "entail_prune";
    (* RESOURCE: Normalize for combine lemma *)
    x_dinfo_zp (lazy ("heap_entail_init list_failesc_context_init:"
                      ^ "before normalizing"
                      ^"\n")) pos;
    let norm_cl = normalize_list_failesc_context_w_lemma prog cl_after_prune in
    x_dinfo_zp (lazy ("heap_entail_init list_failesc_context_init:"
                      ^ "after normalizing"
                      ^"\n")) pos;
    let (lfc,prf) = x_add heap_entail_failesc_prefix_init 2 prog is_folding
        false norm_cl conseq tid delayed_f join_id pos pid
        (rename_labels_formula ,Cprinter.string_of_formula,
         heap_entail_one_context_new) in
    (* WN:TODO: need to consider local option in list_failesc? *)
    let lfc1 = if !Globals.enable_error_as_exc ||
                  (infer_const_obj # is_err_must || infer_const_obj # is_err_may) then
        lfc
      else CF.convert_must_failure_4_list_failesc_context "failed proof @ loc" lfc
    in
    (lfc1,prf)
  end

let heap_entail_list_failesc_context_init (prog : prog_decl) (is_folding : bool)
    (cl : list_failesc_context) (conseq:formula) (tid: CP.spec_var option)
    (delayed_f: MCP.mix_formula option) (join_id: CP.spec_var option) pos
    (pid:control_path_id) : (list_failesc_context * proof) =
  let pr2 = Cprinter.string_of_formula in
  let pr1 = Cprinter.string_of_list_failesc_context in
  Debug.no_2 "heap_entail_list_failesc_context_init"
    pr1 pr2 (fun (r,_)->pr1 r)
    (fun _ _ -> heap_entail_list_failesc_context_init_x prog is_folding cl
        conseq tid delayed_f join_id pos pid) cl conseq (*TO CHECK: whether we have tid*)

(* TODO : what is this verify_pre_is_sat verification for? *)
let rec verify_pre_is_sat prog fml = match fml with
  | Or _  (*report_error no_pos "Do not expect disjunction in precondition"*)
  | Base _ ->
    let fml,_,_ = x_add xpure 15 prog fml
    in TP.is_sat_raw fml
  | Exists e ->
    let fml = normalize_combine_heap
        (formula_of_mix_formula e.formula_exists_pure no_pos)
        e.formula_exists_heap in
    verify_pre_is_sat prog fml

let verify_pre_is_sat prog fml =
  let pr = Cprinter.string_of_formula in
  Debug.no_1 "verify_pre_is_sat" pr string_of_bool
    (fun _ -> verify_pre_is_sat prog fml) fml

(* let () = Ti2.unsat_base_nth := unsat_base_nth *)
let () =
  let infer_func prog ante conseq =
    let rs, _ = heap_entail_one_context 20 prog false ante conseq None None None no_pos in
    Some rs
  in
  Ti2.entail_inf := infer_func

let is_unsat_0 f =
  let pg = Cast.get_cprog () in
  let n = 111 in
  unsat_base_nth n pg (ref n) f

let is_unsat_0 f =
  Debug.no_1 "is_xpure_unsat" !print_formula string_of_bool is_unsat_0 f

let () = CF.is_xpure_unsat := is_unsat_0
