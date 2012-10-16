open Globals
open Gen

module DD = Debug
module Err = Error
module CA = Cast
module CP = Cpure
module CF = Cformula
module MCP = Mcpure
module CEQ = Checkeq
module TP = Tpdispatcher
module SAU = Sautility

(*temporal: name * hrel * definition body*)
type hp_rel_def = CP.rel_cat * CF.h_formula * CF.formula

(*hp_name * args * condition * lhs * rhs *)
type par_def_w_name =  CP.spec_var * CP.spec_var list * CF.formula * (CF.formula option) *
      (CF.formula option)

let string_of_par_def_w_name pd=
  let pr1 = !CP.print_sv in
  let pr4 = !CP.print_svl in
  let pr2 = Cprinter.prtt_string_of_formula in
  let pr3 = fun x -> match x with
    | None -> "None"
    | Some f -> pr2 f
  in
  let pr = pr_penta pr1 pr4 pr2 pr3 pr3 in
  pr pd

let string_of_par_def_w_name_short pd=
  let pr1 = !CP.print_sv in
  let pr2 = !CP.print_svl in
  let pr3 = Cprinter.prtt_string_of_formula in
  let pr = pr_triple pr1 pr2 pr3 in
  pr pd

let rel_def_stk : CF.hprel_def Gen.stack_pr = new Gen.stack_pr 
  Cprinter.string_of_hprel_def_lib (==)
(**=================================**)

let rec elim_redundant_paras_lst_constr_x prog constrs =
  let drop_cands = List.concat (List.map (fun c -> check_dropable_paras_constr prog c) constrs) in
  let rec partition_cands_by_hp_name drops parts=
    match drops with
      | [] -> parts
      | (hp_name,ids)::xs ->
          let part,remains= List.partition (fun (hp_name1,_) -> CP.eq_spec_var hp_name1 hp_name) xs in
          partition_cands_by_hp_name remains (parts@[[(hp_name,ids)]@part])
  in
  let intersect_cand_one_hp ls=
    let hp_names,cands = List.split ls in
    (* let _ = Debug.ninfo_pprint ("   hprel: " ^ (!CP.print_svl hp_names)) no_pos in *)
    (* let _ = Debug.ninfo_pprint ("     cands: " ^ (let pr = pr_list Cprinter.string_of_list_int in pr cands)) no_pos in *)
    let locs = List.fold_left (fun ls1 ls2 -> Gen.BList.intersect_eq (=) ls1 ls2) (List.hd cands) (List.tl cands) in
    if locs = [] then []
    else [(List.hd hp_names, locs)]
  in
  let rec drop_invalid_group ls res=
    match ls with
      | [] -> res
      | (hp,locs)::ss -> if locs = [-1] then drop_invalid_group ss res
          else drop_invalid_group ss (res@[(hp,locs)])
  in
  (*group cands into each hp*)
  let groups = partition_cands_by_hp_name drop_cands [] in
  (*each hp, intersect all candidate drops*)
  let drop_hp_args = List.concat (List.map intersect_cand_one_hp groups) in
  let drop_hp_args = drop_invalid_group drop_hp_args [] in
  let _ = Debug.ninfo_pprint ("  drops: " ^ (let pr = pr_list (pr_pair !CP.print_sv (pr_list string_of_int))
                                                         in pr drop_hp_args)) no_pos in
  let new_constrs = drop_process constrs drop_hp_args in
  (*find candidates in all assumes, if a case appears in all assmses => apply it*)
  new_constrs

and elim_redundant_paras_lst_constr prog hp_constrs =
  let pr = pr_list_ln Cprinter.string_of_hprel in
  Debug.no_1 "elim_redundant_paras_lst_constr" pr pr
      (fun _ ->  elim_redundant_paras_lst_constr_x prog hp_constrs) hp_constrs

(*each constraint, pick candidate args which can be droped in each hprel*)
and check_dropable_paras_constr prog constr:((CP.spec_var*int list) list) =
  Debug.ninfo_hprint (add_str "  assumption: " (Cprinter.string_of_hprel)) constr no_pos;
  let(lhs,rhs) = constr.CF.hprel_lhs,constr.CF.hprel_rhs in
  let _ = Debug.ninfo_pprint ("    RHS") no_pos in
  let l1 = check_dropable_paras_RHS prog rhs in
  let _ = Debug.ninfo_pprint ("    LHS") no_pos in
  let l2 = check_dropable_paras_LHS prog lhs rhs constr.CF.predef_svl in
  (l1@l2)

(*each hprel: check which arg is raw defined*)
and check_dropable_paras_RHS prog f:((CP.spec_var*int list) list)=
  (*RHS: dropable if para have just partial defined or more*)
  let def_vs_wo_args, _, _, hrs, _ = SAU.find_defined_pointers_raw prog f in
  let rec helper args res index=
    match args with
      | [] -> res
      | a::ass -> if (CP.mem_svl a def_vs_wo_args) then
            helper ass (res@[index]) (index+1)
          else helper ass res (index+1)
  in
  let check_dropable_each_pred hr =
    let (svar, exps,_) = hr in
    let _ = Debug.ninfo_pprint ("      hprel:  " ^ (CP.name_of_spec_var svar)) no_pos in
    let res = helper (List.concat (List.map CP.afv exps)) [] 0 in
    let _ = Debug.ninfo_pprint ("      cands: " ^ (Cprinter.string_of_list_int res)) no_pos in
    if res = [] then [(svar,[-1])] (*renturn -1 to indicate that none is allowed to drop*)
    else [(svar,res)]
  in
  List.concat (List.map check_dropable_each_pred hrs)

(*each hprel: check which arg is either defined or not-in-used*)
and check_dropable_paras_LHS prog f1 f2 predef :((CP.spec_var*int list) list)=
  let def_vs, hp_paras, _, _, _ = SAU.find_defined_pointers prog f1 predef in
  let rec helper args res index=
    match args with
      | [] -> res
      | a::ass -> if ((CP.mem_svl a (def_vs@predef)) || (is_not_used a (f1,f2))) then
            helper ass (res@[index]) (index+1)
          else helper ass res (index+1)
  in
  let check_dropable_each_hp (svar, args) =
    let _ = Debug.ninfo_pprint ("      hprel:  " ^ (CP.name_of_spec_var svar) ^ (!CP.print_svl args)) no_pos in
    let res = helper args [] 0 in
    let _ = Debug.ninfo_pprint ("      cands: " ^ (Cprinter.string_of_list_int res)) no_pos in
    if res = [] then [(svar,[-1])] (*renturn -1 to indicate that none is allowed to drop*)
    else [(svar, res)]
  in
  List.concat (List.map check_dropable_each_hp hp_paras)


and drop_process (constrs: CF.hprel list) (drlocs: (CP.spec_var* int list) list): ( CF.hprel list) =
  List.map (fun c -> drop_process_one_constr c drlocs) constrs

and drop_process_one_constr (constr: CF.hprel) drlocs: CF.hprel =
  {constr with
      CF.hprel_lhs = (filter_hp_rel_args_f constr.CF.hprel_lhs drlocs);
      CF.hprel_rhs = (filter_hp_rel_args_f constr.CF.hprel_rhs drlocs)}


and filter_hp_rel_args_f (f: CF.formula) (drlocs: (CP.spec_var* int list) list)=
  (* let rels, _ = List.split drlocs in *)
  let rec helper f drlocs = match f with
    | CF.Base fb -> CF.Base {fb with CF.formula_base_heap = filter_hp_rel_args fb.CF.formula_base_heap drlocs;}
    | CF.Or orf -> CF.Or {orf with CF.formula_or_f1 = helper orf.CF.formula_or_f1 drlocs;
                CF.formula_or_f2 = helper orf.CF.formula_or_f2 drlocs;}
    | CF.Exists fe -> CF.Exists {fe with CF.formula_exists_heap =  filter_hp_rel_args fe.CF.formula_exists_heap drlocs;}
  in 
  helper f drlocs

and filter_hp_rel_args (hf: CF.h_formula) (drlocs: (CP.spec_var* int list) list): CF.h_formula=
  (* let rels, _ = List.split drlocs in *)
  let rec look_up_drop_hp hp drops=
    match drops with
      | [] -> []
      | (hp1, locs)::ss -> if CP.eq_spec_var hp hp1 then locs
          else look_up_drop_hp hp ss
  in
  let rec helper hf0=
    match hf0 with
      | CF.Star {CF.h_formula_star_h1 = hf1;
                 CF.h_formula_star_h2 = hf2;
                 CF.h_formula_star_pos = pos} ->
          let n_hf1 = helper hf1 in
          let n_hf2 = helper hf2 in
          (match n_hf1,n_hf2 with
            | (CF.HEmp,CF.HEmp) -> CF.HEmp
            | (CF.HEmp,_) -> n_hf2
            | (_,CF.HEmp) -> n_hf1
            | _ -> CF.Star {CF.h_formula_star_h1 = n_hf1;
			                CF.h_formula_star_h2 = n_hf2;
			                CF.h_formula_star_pos = pos}
          )
      | CF.Conj { CF.h_formula_conj_h1 = hf1;
		          CF.h_formula_conj_h2 = hf2;
		          CF.h_formula_conj_pos = pos} ->
          let n_hf1 = helper hf1 in
          let n_hf2 = helper hf2 in
          CF.Conj { CF.h_formula_conj_h1 = n_hf1;
		            CF.h_formula_conj_h2 = n_hf2;
		            CF.h_formula_conj_pos = pos}
      | CF.Phase { CF.h_formula_phase_rd = hf1;
		           CF.h_formula_phase_rw = hf2;
		           CF.h_formula_phase_pos = pos} ->
          let n_hf1 = helper hf1 in
          let n_hf2 = helper hf2 in
          CF.Phase { CF.h_formula_phase_rd = n_hf1;
		             CF.h_formula_phase_rw = n_hf2;
		             CF.h_formula_phase_pos = pos}
      | CF.DataNode hd -> hf0
      | CF.ViewNode hv -> hf0
      | CF.HRel (sv, args, l) ->
	            let locs =  look_up_drop_hp sv drlocs in
                if locs = [] then hf0
                else
                  begin
                    let rec filter_args args new_args index=
                      match args with
                        | [] -> new_args
                        | a::ss -> if List.exists (fun id -> id = index) locs then
                              filter_args ss new_args (index+1)
                            else filter_args ss (new_args@[a]) (index+1)
                    in
	                let new_args = filter_args args [] 0 in
	                if((List.length new_args) == 0) then CF.HEmp
	                else (CF.HRel (sv, new_args, l))
	              end
      | CF.Hole _
      | CF.HTrue
      | CF.HFalse
      | CF.HEmp -> hf0
  in
  helper hf

and is_not_used sv constr=
  let lhs, rhs = constr in
  (is_not_used_RHS sv rhs) && (is_not_connect_LHS sv rhs lhs)

and is_not_used_RHS (v: CP.spec_var)(f: CF.formula): bool = 
  let hds, hvs, hrs = CF.get_hp_rel_formula f in
  let eqNulls = match f with
    |CF.Base  ({CF.formula_base_pure = p1})
    |CF.Exists ({ CF.formula_exists_pure = p1}) -> (
      let eqNull1, eqNull2 =  List.split (MCP.ptr_equations_with_null p1) in
      CP.remove_dups_svl (eqNull1@eqNull2)
    )
    |CF.Or f  -> report_error no_pos "not handle yet"
  in
  let rhs_vs = (eqNulls) @ (List.map (fun hd -> hd.CF.h_formula_data_node) hds) @ (List.map (fun hv -> hv.CF.h_formula_view_node) hvs)  in
  let get_svars el = List.concat (List.map (fun c -> [CP.exp_to_spec_var c] ) el) in
  let rel_args =List.concat ( List.map (fun (_,el,_) -> get_svars el) hrs) in
  let rhs_vs = rhs_vs@rel_args in
  let str = List.fold_left (fun a b ->  (CP.name_of_spec_var b ^ "," ^ a )) "" rhs_vs in
  let _ = Debug.ninfo_pprint ("RHS vars " ^ str) no_pos in
  let b = List.exists (fun c-> if(CP.eq_spec_var v c) then true else false) rhs_vs in
  if(b) then false 
  else true

and is_not_connect_LHS (v: CP.spec_var)(f: CF.formula)(f2:CF.formula): bool = 
  let hds, hvs, hrs = CF.get_hp_rel_formula f in
  let hds = List.filter (fun c -> not(is_not_used_RHS c.CF.h_formula_data_node f2)) hds in
  let hvs = List.filter (fun c -> not(is_not_used_RHS c.CF.h_formula_view_node f2)) hvs in
  let node_args = (List.concat (List.map (fun hd -> hd.CF.h_formula_data_arguments) hds)) @ (List.concat(List.map (fun hv -> hv.CF.h_formula_view_arguments) hvs)) in
  let node_args = List.filter (fun c -> CP.is_node_typ c) node_args in
  let b = List.exists (fun c-> if(CP.eq_spec_var v c) then true else false) node_args in
  if(b) then false
  else true

(**************************)
(*===========SPLIT===========*)
let get_only_hrel f = match f with 
  |CF.Base {CF.formula_base_heap = hf} -> (match hf with
      | CF.HRel hr -> hr
      | _ -> raise Not_found
  )
  |CF.Exists {CF.formula_exists_heap = hf} -> (match hf with
      | CF.HRel hr -> hr
      | _ -> raise Not_found
  )
  | CF.Or f  -> report_error no_pos "not handle yet"

(*todo: rhs is only hp with more than 1 param*)
let get_hp_split_cands_x constrs =
  let helper (lhs,rhs)=
    (*try(
        let sv,el,l = get_only_hrel rhs in
        if(List.length el >= 2) then [(CF.HRel (sv,el,l))]
        else []
    )
    with _ -> []*)
(*split all*)
    let hn, hv, hr = CF.get_hp_rel_formula lhs in
    let hn1, hv1, hr1 = CF.get_hp_rel_formula rhs in
    let cands = hr1 @ hr in
    let cands =  Gen.BList.remove_dups_eq (fun (hp1,_,_)  (hp2,_,_) ->
      CP.eq_spec_var hp1 hp2) cands in
    let cands = List.filter (fun (sv,el,l) ->  (List.length el) >= 2) cands in
    let cands = List.map (fun (sv,el,l) -> (CF.HRel (sv,el,l))) cands in
    cands 
  in
  (*remove duplicate*)
  let cands = (List.concat (List.map helper constrs)) in
  Gen.BList.remove_dups_eq (fun (CF.HRel (hp1,_,_)) (CF.HRel (hp2,_,_)) ->
      CP.eq_spec_var hp1 hp2) cands

let get_hp_split_cands constrs =
  let pr1 = pr_list_ln (pr_pair Cprinter.prtt_string_of_formula Cprinter.prtt_string_of_formula) in
  let pr2 = pr_list_ln (Cprinter.string_of_hrel_formula) in
  Debug.no_1 "get_hp_split_cands" pr1 pr2
  (fun _ -> get_hp_split_cands_x constrs) constrs

(*split one hp -> mutiple hp and produce corresponding heap formulas for substitution*)
let hp_split_x hps =
  (*each arg, create new hp and its corresponding HRel formula*)
  let helper1 l arg =
    let new_hp_name = Globals.hp_default_prefix_name ^ (string_of_int (Globals.fresh_int())) in
    let new_hp_sv = CP.SpecVar (HpT,new_hp_name, Unprimed) in
    (*should refresh arg*)
    (new_hp_sv, CF.HRel (new_hp_sv, [arg], l))
  in
  (*rhs is only hp with more than 1 parameter*)
  (*for each hp*)
  let helper hf =
    match hf with
      | (CF.HRel (sv,el,l)) ->
          let hps = List.map (helper1 l) el in
          let new_hp_names,new_hrel_fs = List.split hps in
          let new_hrels_comb = List.fold_left (fun hf1 hf2 -> CF.mkStarH hf1 hf2 l) (List.hd new_hrel_fs) (List.tl new_hrel_fs) in
          ((sv,new_hp_names),(sv, CF.HRel (sv,el,l), new_hrels_comb))
      | _ -> report_error no_pos "sa.hp_split_x: can not happen"
  in
  let res = List.map helper hps in
  List.split res

let hp_split hps =
  let pr1 = !CP.print_sv in
  let pr2 = !CP.print_svl in
  let pr3 = (pr_list (pr_pair pr1 pr2)) in
  let pr4 = Cprinter.string_of_h_formula in
  let pr5 = pr_list pr4 in
  let pr6 = pr_list (pr_triple pr1 pr4 pr4) in
   Debug.no_1 "hp_split" pr5 (pr_pair pr3 pr6)
       (fun _ -> hp_split_x hps) hps

let subst_constr_with_new_hps_x hp_constrs hprel_subst=
  let elim_first_arg (a1,a2,a3)= (a2,a3) in
  let new_hprel_subst = List.map elim_first_arg hprel_subst in
  let helper (l_constr, r_constr)=
    (CF.subst_hrel_f l_constr new_hprel_subst, CF.subst_hrel_f r_constr new_hprel_subst)
  in
  List.map helper hp_constrs

let subst_constr_with_new_hps hp_constrs hprel_subst=
  let pr1= pr_list_ln (pr_pair Cprinter.prtt_string_of_formula Cprinter.prtt_string_of_formula) in
  let pr2 = Cprinter.string_of_h_formula in
  let pr3 = fun (a1,a2,a3) -> let pr =pr_pair pr2 pr2 in pr (a2,a3) in
  let pr4 = pr_list_ln pr3 in
  Debug.no_2 "subst_constr_with_new_hps" pr1 pr4 pr1
      (fun _ _ -> subst_constr_with_new_hps_x hp_constrs hprel_subst) hp_constrs hprel_subst

(*return new contraints and hp split map *)
let split_hp_x (hp_constrs: (CF.formula * CF.formula) list): ((CF.formula * CF.formula) list *
          (CP.spec_var*CP.spec_var list) list * (CP.spec_var * CF.h_formula*CF.h_formula) list) =
  (*get hp candidates*)
  let split_cands = get_hp_split_cands hp_constrs in
  (*split  and get map*)
  let split_map,hprel_subst =  hp_split split_cands in
  (*subs old hrel by new hrels*)
  let new_constrs = subst_constr_with_new_hps hp_constrs hprel_subst in
  (new_constrs, split_map, hprel_subst)

let split_hp (hp_constrs: (CF.formula * CF.formula) list):((CF.formula * CF.formula) list *
 (CP.spec_var*CP.spec_var list) list * (CP.spec_var *CF.h_formula*CF.h_formula) list) =
  let pr1 =  pr_list_ln (pr_pair Cprinter.prtt_string_of_formula Cprinter.prtt_string_of_formula) in
  let pr2 = !CP.print_sv in
  let pr3 = !CP.print_svl in
  let pr4 = fun (a1,a2,_) -> (*ignore a3*)
      let pr = pr_pair pr1 (pr_list (pr_pair pr2 pr3)) in
      pr (a1, a2)
  in
  Debug.no_1 "split_hp" pr1 pr4
      (fun _ -> split_hp_x hp_constrs) hp_constrs
(*===========END SPLIT===========*)
(*=============UNKOWN================*)
(*find diff for each hrel*)
let build_hp_unk_locs known_svl fn_cmp (hp_name, args)=
   let rec helper args res index all=
    match args with
      | [] -> res
      | a::ass -> if (fn_cmp a all) then
            helper ass res (index+1) all
          else helper ass (res@[index]) (index+1) all
  in
  let get_unk_ptr all_ptrs (hp_name, args)=
    (* if all_ptrs = [] then [(hp_name,[-1])] (\*[] mean dont have any information*\) *)
    (* else *)
      begin
          let res = helper args [] 0 all_ptrs in
          if res = [] then [(hp_name,[-1])] (*renturn -1 to indicate that none is allowed to drop*)
          else [(hp_name, res)]
      end
  in
  get_unk_ptr known_svl (hp_name, args)

(*analysis unknown information*)
let rec analize_unk_one prog constr =
  let _ = Debug.ninfo_pprint ("   hrel: " ^ (Cprinter.string_of_hprel constr)) no_pos in
 (*remove hrel and returns hprel_args*)
  (*lhs*)
  let lhs1,lhrels = SAU.drop_get_hrel constr.CF.hprel_lhs in
  (*rhs*)
  let rhs1,rhrels = SAU.drop_get_hrel constr.CF.hprel_rhs in
(*find fv of lhs + rhs wo hrels*)
  let lsvl = SAU.get_raw_defined_w_pure prog lhs1 in
  let rsvl = SAU.get_raw_defined_w_pure prog rhs1 in
  (*return*)
  List.concat (List.map (build_hp_unk_locs (lsvl@rsvl) CP.mem_svl) (lhrels@rhrels))

and double_check_unk unk_hp_locs constr=
  let lhprels = CF. get_HRels_f constr.CF.hprel_lhs in
  let rhprels = CF. get_HRels_f constr.CF.hprel_rhs in
  (*return: unk_args*)
  let rec retrieve_args_one_hp ls (hp,args)=
    match ls with
      | [] -> ([])
      | (hp1,locs)::ss -> if CP.eq_spec_var hp hp1 then
            begin
                (*find unknown hprel*)
                if (List.length args) = (List.length locs) then
                  (args)
                else
                  ((SAU.retrieve_args_from_locs args locs 0 []))
            end
          else retrieve_args_one_hp ss (hp,args)
  in
  (* let get_unk_hp unk_svl (hp, args)= *)
  (*   let diff = Gen.BList.difference_eq CP.eq_spec_var args unk_svl in *)
  (*   if diff = [] then [(hp,args)] *)
  (*   else [] *)
  (* in *)
  (* let unk_svl_hps = List.map (retrieve_args_one_hp unk_hp_locs) (lhprels@rhprels) in *)
  let unk_hp_names = List.map (fun (hp, _) -> hp) unk_hp_locs in
  let cs_hp_args = Gen.BList.remove_dups_eq SAU.check_hp_arg_eq (lhprels@rhprels) in
  let cs_unk_hps,cs_non_unk_hps = List.partition
    (fun (hp,_) -> CP.mem_svl hp unk_hp_names) cs_hp_args in
  (*non unk*)
  let cs_non_unk_svl = List.concat (List.map (fun (_, args) -> args) cs_non_unk_hps) in
  let cs_non_unk_svl = CP.remove_dups_svl cs_non_unk_svl in
  (*possible unk*)
  let unk_svl_hps = List.concat (List.map (retrieve_args_one_hp unk_hp_locs) cs_unk_hps) in
  let poss_unk_svl_hps = CP.remove_dups_svl unk_svl_hps in
  (*actually unk = poss unk - non-unk*)
  let real_unk_svl_hps = Gen.BList.difference_eq CP.eq_spec_var poss_unk_svl_hps
    cs_non_unk_svl in
  List.concat (List.map (build_hp_unk_locs real_unk_svl_hps
                    (fun a ls -> not( CP.mem_svl a ls))) (cs_unk_hps))

(*this method has the same structure with elim_redundant_paras_lst_constr_x,
should use higher-order when stab.*)
and analize_unk prog constrs =
  let rec partition_cands_by_hp_name unks parts=
    match unks with
      | [] -> parts
      | (hp_name,ids)::xs ->
          let part,remains= List.partition (fun (hp_name1,_) -> CP.eq_spec_var hp_name1 hp_name) xs in
          partition_cands_by_hp_name remains (parts@[[(hp_name,ids)]@part])
  in
  let intersect_cand_one_hp ls=
    let hp_names,cands = List.split ls in
    (* let _ = Debug.ninfo_pprint ("   hprel: " ^ (!CP.print_svl hp_names)) no_pos in *)
    (* let _ = Debug.ninfo_pprint ("     cands: " ^ (let pr = pr_list Cprinter.string_of_list_int in pr cands)) no_pos in *)
    let locs = List.fold_left (fun ls1 ls2 -> Gen.BList.intersect_eq (=) ls1 ls2) (List.hd cands) (List.tl cands) in
    if locs = [] then []
    else [(List.hd hp_names, locs)]
  in
  let rec drop_invalid_group ls res=
    match ls with
      | [] -> res
      | (hp,locs)::ss -> if locs = [-1] then drop_invalid_group ss res
          else drop_invalid_group ss (res@[(hp,locs)])
  in
  let helper fn=
    let unk_cands = List.concat (List.map fn constrs) in
  (*group cands into each hp*)
    let groups = partition_cands_by_hp_name unk_cands [] in
  (*each hp, intersect all candidate unks*)
    let unk_hp_args1 = List.concat (List.map intersect_cand_one_hp groups) in
    let unk_hp_args2 = drop_invalid_group unk_hp_args1 [] in
    unk_hp_args2
  in
  (* let unk_cands = List.concat (List.map (analize_unk_one prog) constrs) in *)
  (* (\*group cands into each hp*\) *)
  (* let groups = partition_cands_by_hp_name unk_cands [] in *)
  (* (\*each hp, intersect all candidate unks*\) *)
  (* let unk_hp_args1 = List.concat (List.map intersect_cand_one_hp groups) in *)
  (* let unk_hp_args2 = drop_invalid_group unk_hp_args1 [] in *)
  let unk_hp_args01 = helper (analize_unk_one prog) in
  (*for debugging*)
  let _ = Debug.ninfo_pprint ("  unks 1: " ^ (let pr = pr_list (pr_pair !CP.print_sv (pr_list string_of_int))
                                             in pr unk_hp_args01)) no_pos
  in
  (*END for debugging*)
  (*double check across one cs*)
   let unk_hp_args02 = helper (double_check_unk unk_hp_args01) in
  (*for debugging*)
   let _ = Debug.ninfo_pprint ("  unks 2: " ^ (let pr = pr_list (pr_pair !CP.print_sv (pr_list string_of_int))
                                              in pr unk_hp_args02)) no_pos
   in
  (*END for debugging*)
  (*END double check*)
   let rec update_helper cs res_cs res_unk_hps res_equivs=
     match cs with
       | [] ->  (res_cs, res_unk_hps, res_equivs)
       | c::ss ->
           let new_c, new_unk_hps, new_equivs= update_unk_one_constr prog unk_hp_args02 res_equivs c in
            update_helper ss (res_cs@[new_c]) (res_unk_hps@new_unk_hps) new_equivs
   in
  (* let cs_unk_hps = List.map (update_unk_one_constr prog unk_hp_args02) constrs in *)
  (* let new_cs, unk_hps,equivs = split3 cs_unk_hps in *)
  (* (new_cs, Gen.BList.remove_dups_eq SAU.check_simp_hp_eq (List.concat unk_hps), *)
  (* List.concat equivs) *)
   let new_cs, unk_hps,equivs = update_helper constrs [] [] [] in
   (new_cs, Gen.BList.remove_dups_eq SAU.check_simp_hp_eq unk_hps, equivs)

and update_unk_one_constr prog unk_hp_locs equivs0 constr=
  (*return: unk_args*)
  let rec retrieve_args_one_hp ls (hp,args)=
    match ls with
      | [] -> ([])
      | (hp1,locs)::ss -> if CP.eq_spec_var hp hp1 then
            begin
                (*find unknown hprel*)
                if (List.length args) = (List.length locs) then
                  (args)
                else
                  ((SAU.retrieve_args_from_locs args locs 0 []))
            end
          else retrieve_args_one_hp ss (hp,args)
  in
  let rec look_up_equiv hp equivs=
    (* let _ = DD.ninfo_pprint ("       hp:" ^ (!CP.print_sv hp)) no_pos in *)
    match equivs with
      | [] -> []
      | ((hp1,a),ls)::eqs ->
          (* let _ = DD.ninfo_pprint ("       hp1:" ^ (!CP.print_sv hp1)) no_pos in *)
          (*should cmp rem_args unk_args also*)
          if CP.eq_spec_var hp1 hp then [((hp1,a),ls)]
          else look_up_equiv hp eqs
  in
  (*split args into 2 groups: unk_hp and remains*)
  let get_unk_hp unk_svl equivs (hp, args)=
    let unk_args,rem_args = List.partition (fun sv -> CP.mem_svl sv unk_svl) args in
    if unk_args = [] then ([],[],equivs) (*no args is unk*)
    else if rem_args = [] then (*all args are unk*)
      ([(hp,args)],[], equivs)
    else
      ([],[], equivs)
      (*now, we omit dynamically spliting*)
      (*
     begin
      (*split into groups*)
      (*look up in equiv first*)
      let eqv = look_up_equiv hp equivs in
      match eqv with
        | [] ->
      (*generate two new hps: one for unk and one for remain*)
            let unk_hf, unk_hp = SAU.add_raw_hp_rel prog unk_args no_pos in
            let rem_hf, rem_hp = SAU.add_raw_hp_rel prog rem_args no_pos in
            let sunk_hp = match unk_hp with
              | [a] -> a
              | _ -> report_error no_pos "sa.get_unk_hp 1"
            in
            let srem_hp = match rem_hp with
              | [a] -> a
              | _ -> report_error no_pos "sa.get_unk_hp 2"
            in
            ([(sunk_hp, unk_args)],[rem_hf;unk_hf],equivs@[(hp,args),[(srem_hp,rem_args);
                                                        (sunk_hp,unk_args)]])
        | [((hp1,args),ls)] ->
            begin
                match ls with
                  | [(srem_hp,rem_args1);(sunk_hp,unk_args1)] ->
                      (*should subst args before use*)
                      if ((List.length unk_args) = (List.length unk_args1) &&
                      (List.length rem_args) = (List.length rem_args1)) then
                        let rem_hf = SAU.mkHRel srem_hp rem_args no_pos in
                        let unk_hf = SAU.mkHRel sunk_hp unk_args no_pos in
                        ([(sunk_hp,unk_args1)],[rem_hf;unk_hf], equivs)
                      else report_error no_pos "sa.get_unk_hp 5"
                  | _ -> report_error no_pos "sa.get_unk_hp 3"
            end
        | _ -> report_error no_pos "sa.get_unk_hp 4"
     end
      *)
  in
  let rec helper1 unk_svl cs_unk_hps res_unks res_hfs res_equivs=
    match cs_unk_hps with
      | [] -> (res_unks, res_hfs, res_equivs)
      | unk_hps::ss ->
          let unks, new_hfs,new_equivs = get_unk_hp unk_svl res_equivs unk_hps in
          helper1 unk_svl ss (res_unks@unks) (res_hfs@new_hfs) new_equivs
  in
  let helper f equivs unk_hp_names=
    let lhprels = CF.get_HRels_f f in
    (*hps have unk slv*)
     let cs_unk_hps,cs_non_unk_hps = List.partition
    (fun (hp,_) -> CP.mem_svl hp unk_hp_names) lhprels in
  (*unk*)
     let unk_svl = List.concat ((List.map (retrieve_args_one_hp unk_hp_locs) cs_unk_hps)) in
     let unk_svl = CP.remove_dups_svl unk_svl in
     (* let unks, new_hfs,new_equivs = split3 (List.map (get_unk_hp unk_svl equivs) cs_unk_hps) in *)
     (*dynamic splitting: unk and non-unk*)
     let unks, new_hfs,new_equivs = helper1 unk_svl cs_unk_hps [] [] equivs in
     let unk_hps, _  = List.split unks in
  (*subst hp with equivalent hps*)
     (* let new_hfs = List.concat new_hfs in *)
     match new_hfs with
      | [] -> (f, unks, unk_svl,new_equivs)
      | _ ->
          let l = CF.pos_of_formula f in
          let new_hfs_comb = List.fold_left (fun hf1 hf2 -> CF.mkStarH hf1 hf2 l) (List.hd new_hfs) (List.tl new_hfs) in
          let split_hps,_ = List.split new_equivs in
             (*remove old hps*)
          let f1,_ = CF.drop_hrel_f f (fst (List.split split_hps)) in
          let f2 = CF.mkAnd_f_hf f1 new_hfs_comb (CF.pos_of_formula f1) in
          (f2, unks, unk_svl, new_equivs)
  in
  let unk_hp_names = List.map (fun (hp, _) -> hp) unk_hp_locs in
  let lhs,lunk_hps,lunk_svl, lequv = helper constr.CF.hprel_lhs equivs0 unk_hp_names in
  let rhs,runk_hps,runk_svl, requv = helper constr.CF.hprel_rhs (lequv) unk_hp_names in
  let new_constr = {constr with
      CF.unk_svl = CP.remove_dups_svl (constr.CF.unk_svl@lunk_svl@runk_svl);
      CF.unk_hps = Gen.BList.remove_dups_eq SAU.check_hp_arg_eq (constr.CF.unk_hps@lunk_hps@runk_hps);
      CF.hprel_lhs = lhs;
      CF.hprel_rhs = rhs;
  }
  in
  let _ = Debug.ninfo_pprint ("   new hrel: " ^
              (Cprinter.string_of_hprel new_constr)) no_pos in
  (new_constr,lunk_hps@runk_hps, requv)
(*=============END UNKOWN================*)
(*END first step*)
(*=======================*)
(*should we mkAnd f1 f2*)
let rec find_defined_pointers_two_formulas_x prog f1 f2 predef_ptrs=
  let (def_vs1, hds1, hvs1, hrs1, eqs1) = SAU.find_defined_pointers_raw prog f1 in
  let (def_vs2, hds2, hvs2, hrs2, eqs2) = SAU.find_defined_pointers_raw prog f2 in
  SAU.find_defined_pointers_after_preprocess prog (def_vs1@def_vs2) (hds1@hds2) (hvs1@hvs2)
      (hrs2) (eqs1@eqs2) predef_ptrs

and find_defined_pointers_two_formulas prog f1 f2 predef_ptrs=
  let pr1 = !CP.print_svl in
  let pr2 = pr_list_ln (pr_pair !CP.print_sv pr1) in
  (* let pr3 = fun x -> Cprinter.string_of_h_formula (CF.HRel x) in *)
  let pr4 = fun (a1, a2, _, _, _) ->
      let pr = pr_pair pr1 pr2 in pr (a1,a2)
  in
  Debug.no_3 "find_defined_pointers_two_formulas" Cprinter.prtt_string_of_formula Cprinter.prtt_string_of_formula pr1 pr4
      (fun _ _ _ -> find_defined_pointers_two_formulas_x prog f1 f2 predef_ptrs) f1 f2 predef_ptrs

(*unilities for computing partial def*)
let rec lookup_undef_args args undef_args def_ptrs=
  match args with
    | [] -> undef_args
    | a::ax -> if CP.mem_svl a def_ptrs then (*defined: omit*)
          lookup_undef_args ax undef_args def_ptrs
        else (*undefined *)
          lookup_undef_args ax (undef_args@[a]) def_ptrs

(*END unilities for computing partial def*)

(*check_partial_def_eq: to remove duplicate and identify terminating condition*)
let check_partial_def_eq_x (hp1, args1, cond1, olhs1, orhs1) (hp2, args2, cond2, olhs2, orhs2)=
  if (CP.eq_spec_var hp1 hp2) then (*if not the same hp, fast return*)
  (*form a subst*)
    let subst = List.combine args1 args2 in
    let checkeq_w_option of1 of2=
      match of1, of2 with
        | None,None -> true
        | Some _, None -> false
        | None, Some _ -> false
        | Some f1, Some f2 ->
          (*subs*)
            let f1_subst = CF.subst subst f1 in
	    let hvars = List.map (fun c -> CP.full_name_of_spec_var c) (CF.get_hp_rel_name_formula f1_subst @ CF.get_hp_rel_name_formula f2) in
            let r,_ (*map*) =  CEQ.checkeq_formulas hvars f1_subst f2 in
            r
    in
    ((checkeq_w_option olhs1 olhs2) && (checkeq_w_option orhs1 orhs2))(*  || *)
        (* ((checkeq_w_option olhs1 orhs2) && (checkeq_w_option orhs1 olhs2)) *)
  else false

let check_partial_def_eq par_def1 par_def2=
  let pr1 = string_of_par_def_w_name in
  Debug.no_2 "check_partial_def_eq" pr1 pr1 string_of_bool
      (fun _ _ -> check_partial_def_eq_x par_def1 par_def2) par_def1 par_def2

(*collect partial def ---> hp*)
let rec collect_par_defs_one_side_one_hp_x prog lhs rhs (hrel, args) def_ptrs
      rhrels eq hd_nodes hv_nodes unk_hps predef=
  begin
      (*old code*)
      let undef_args = lookup_undef_args args [] def_ptrs in
      let test1= (List.length undef_args) = 0 in
        (*case 1*)
        (*this hp is well defined, synthesize partial def*)
      let keep_ptrs = SAU.loop_up_closed_ptr_args prog hd_nodes hv_nodes args in
      let keep_unk_hps = List.concat (List.map (SAU.get_intersect_unk_hps keep_ptrs) unk_hps) in
      let r = CF.drop_data_view_hrel_nodes lhs SAU.check_nbelongsto_dnode SAU.check_nbelongsto_vnode SAU.check_neq_hrelnode keep_ptrs keep_ptrs keep_unk_hps
      in
      let test2 = (not (SAU.is_empty_f r)) && test1 in
      if test2 then
        let r = (hrel, args, r, Some r, None) in
        let _ =  DD.ninfo_pprint ("  partial defs - one side: \n" ^
          (let pr =  string_of_par_def_w_name in pr r) ) no_pos in
        [r]
        (* let closed_args = loop_up_ptr_args prog hd_nodes hv_nodes args in *)
      (* (\*for debugging*\) *)
      (* Debug.ninfo_hprint (add_str "closed args: " (!CP.print_svl)) closed_args no_pos; *)
      (* (\*END*\) *)
      (* let diff = Gen.BList.difference_eq CP.eq_spec_var closed_args (def_ptrs@args) in *)
      (*   if (List.length diff) = 0 then *)
      (*     let r = CF.drop_data_view_hrel_nodes lhs check_nbelongsto_dnode check_nbelongsto_vnode *)
      (*       check_neq_hrelnode closed_args closed_args [] *)
      (*     in *)
      (*     [(hrel, args, r, Some r, None)] *)
      else
    (*CASE2: hp1(x1,x2,x3) --> h2(x1,x2,x3)* formula: hp such that have the same set of args in both sides*)
          collect_par_defs_two_side_one_hp prog lhs rhs (hrel, args) predef rhrels hd_nodes hv_nodes unk_hps
end

and collect_par_defs_one_side_one_hp prog lhs rhs (hrel, args) def_ptrs
      rhrels eq hd_nodes hv_nodes unk_hps predef=
  let pr1 = pr_pair !CP.print_sv !CP.print_svl in
  let pr2 = Cprinter.prtt_string_of_formula in
  let pr3 = pr_list_ln string_of_par_def_w_name in
   Debug.no_2 "collect_par_defs_one_side_one_hp" pr1 pr2 pr3
       (fun _ _ -> collect_par_defs_one_side_one_hp_x prog lhs rhs (hrel, args) def_ptrs
       rhrels eq hd_nodes hv_nodes unk_hps) (hrel, args) lhs predef

(*collect hp1(x1,x2,x3) ---> hp2(x1,x2,x3) * F  partial def *)
(*todo: more general form: collect hp1(x1,x2,x3) ---> hp2(x1,x2) * F:
 x3 is defined/unknown/predef  partial def *)
and collect_par_defs_two_side_one_hp_x prog lhs rhs (hrel, args) predef rhs_hrels hd_nodes hv_nodes unk_hps=
  let args0 = CP.remove_dups_svl args in
  let args01 = SAU.loop_up_closed_ptr_args prog hd_nodes hv_nodes args0 in
  (* let _ =  DD.ninfo_pprint ("    args0:" ^ (!CP.print_svl args0) ) no_pos in *)
  (* let _ =  DD.ninfo_pprint ("    args01:" ^ (!CP.print_svl args01) ) no_pos in *)
  (* let _ =  DD.ninfo_pprint ("    predef:" ^ (!CP.print_svl predef) ) no_pos in *)
  let rec find_hrel_w_same_args ls r=
    match ls with
      | [] -> r
      | (hp, args1)::ss ->
          (*recompute def_ptrs *)
          let _ =  DD.ninfo_pprint ("    hrel:" ^ (!CP.print_sv hp) ) no_pos in
          if CP.intersect args01 args1 = [] || Gen.BList.difference_eq CP.eq_spec_var args1 predef = [] then
            find_hrel_w_same_args ss r
          else begin
          (*find all defined pointer (null, nodes) and recursive defined parameters (HP, arg)*)
              let n_predef = CP.remove_dups_svl predef@args1 in
              let _ =  DD.ninfo_pprint ("    n_predef:" ^ (!CP.print_svl n_predef) ) no_pos in
              let l_def_ptrs, _,_, _,_ = SAU.find_defined_pointers prog lhs n_predef in
              let r_def_ptrs, _, _, _, _ = find_defined_pointers_two_formulas prog lhs rhs n_predef in
              (* let _ =  DD.ninfo_pprint ("    defs:" ^ (!CP.print_svl (l_def_ptrs@r_def_ptrs)) ) no_pos in *)
              let undef_args = lookup_undef_args args0 [] (l_def_ptrs@r_def_ptrs@n_predef) in
              let _ =  DD.ninfo_pprint ("    undef_args:" ^ (!CP.print_svl undef_args) ) no_pos in
          (* let args11 = CP.remove_dups_svl args1 in *)
          (* let diff = Gen.BList.difference_eq CP.eq_spec_var args11 args0 in *)
          (* if diff = [] then *)
              if undef_args = [] then
           (* find condition. for implication*)
            (*currently just check there exists conditions contain args1*)
                (
              (*  let _, mf, _, _, _ = CF.split_components lhs in *)
            (*    let svl = CP.fv (MCP.pure_of_mix mf) in *)
            (*    if(List.exists (fun v ->  CP.mem_svl v svl) args1) then *)
            (* (\*exist*\) find_hrel_w_same_args ss r *)
            (*    else *)
                    find_hrel_w_same_args ss (r@[(hp, CP.remove_dups_svl (args0@args1) )]) (*collect it*)
           )
                 else find_hrel_w_same_args ss r
          end
  in
    (*find all hrel in rhs such that cover the same set of args*)
  let r_selected_hrels = find_hrel_w_same_args rhs_hrels [] in
  let build_par_def (hp,args0)=
    let keep_ptrs = SAU.loop_up_closed_ptr_args prog hd_nodes hv_nodes args0 in
    let keep_unk_hps = List.concat (List.map (SAU.get_intersect_unk_hps keep_ptrs) unk_hps) in
    let pdef_rhs = CF.drop_data_view_hrel_nodes rhs SAU.check_nbelongsto_dnode SAU.check_nbelongsto_vnode SAU.check_neq_hrelnode keep_ptrs keep_ptrs ([hp]@keep_unk_hps) in
    let pdef_cond = CF.drop_data_view_hrel_nodes lhs SAU.check_nbelongsto_dnode SAU.check_nbelongsto_vnode SAU.check_neq_hrelnode keep_ptrs keep_ptrs ([hp]@keep_unk_hps) in
    (hrel, args,pdef_cond , None, Some pdef_rhs)
  in
  let r = List.map build_par_def r_selected_hrels in
  let _ =  DD.ninfo_pprint ("  partial defs - two side: \n" ^
          (let pr = pr_list_ln string_of_par_def_w_name in pr r) ) no_pos in
  r

and collect_par_defs_two_side_one_hp prog lhs rhs (hrel, args) predef rhs_hrels hd_nodes hv_nodes unk_hps=
  let pr1 = pr_pair !CP.print_sv !CP.print_svl in
  let pr2 =  pr_list_ln pr1 in
  let pr3 = pr_list_ln string_of_par_def_w_name in
  Debug.no_2 "collect_par_defs_two_side_one_hp" pr1 pr2 pr3
      (fun _ _ -> collect_par_defs_two_side_one_hp_x prog lhs rhs (hrel, args) predef rhs_hrels hd_nodes hv_nodes unk_hps)
      (hrel, args) rhs_hrels

let collect_par_defs_recursive_hp_x prog lhs rhs (hrel, args) rec_args def_ptrs hrel_vars eq hd_nodes hv_nodes dir unk_hps=
  let build_partial_def ()=
    let keep_ptrs = SAU.loop_up_closed_ptr_args prog hd_nodes hv_nodes
      (CP.remove_dups_svl (args@rec_args)) in
    let keep_unk_hps = List.concat (List.map (SAU.get_intersect_unk_hps keep_ptrs) unk_hps) in
    let plhs = CF.drop_data_view_hrel_nodes lhs SAU.check_nbelongsto_dnode SAU.check_nbelongsto_vnode SAU.check_neq_hrelnode keep_ptrs keep_ptrs ([hrel]@keep_unk_hps) in
     let prhs = CF.drop_data_view_hrel_nodes rhs SAU.check_nbelongsto_dnode SAU.check_nbelongsto_vnode SAU.check_neq_hrelnode keep_ptrs keep_ptrs ([hrel]@keep_unk_hps) in
     (*find which formula contains root args*)
     let _ = Debug.ninfo_pprint ("lpdef: " ^ (Cprinter.prtt_string_of_formula plhs)) no_pos in
     let _ = Debug.ninfo_pprint ("rpdef: " ^ (Cprinter.prtt_string_of_formula prhs)) no_pos in
     let _ = Debug.ninfo_pprint ("args: " ^ (!CP.print_svl args)) no_pos in
     let _ = Debug.ninfo_pprint ("rec_args: " ^ (!CP.print_svl rec_args)) no_pos in
     if dir then (*args in lhs*)
         begin
         let ptrs1, _,_, _,_ = SAU.find_defined_pointers_raw prog plhs in
         if CP.mem_svl (List.hd args) ptrs1 then
           [(hrel , args ,plhs, Some prhs, Some plhs) ]
         else
           [(hrel , rec_args ,plhs, Some plhs, Some prhs) ]
         end
     else
       let ptrs1, _,_, _,_ = SAU.find_defined_pointers_raw prog prhs in
        if CP.mem_svl (List.hd args) ptrs1 then
           [(hrel , args ,plhs, Some plhs, Some prhs) ]
         else
           [(hrel , rec_args ,plhs, Some prhs, Some plhs) ]
  in
  let undef_args = lookup_undef_args args [] (def_ptrs) in
  if undef_args = [] then (build_partial_def())
  else []

let collect_par_defs_recursive_hp prog lhs rhs (hrel, args) args2 def_ptrs hrel_vars eq hd_nodes hv_nodes dir unk_hps=
  let pr1 = !CP.print_svl in
  let pr2 = (pr_pair !CP.print_sv pr1) in
  let pr3 = pr_list_ln string_of_par_def_w_name in
  Debug.no_2 "collect_par_defs_recursive_hp" pr2 pr1 pr3
      (fun  _ _ -> collect_par_defs_recursive_hp_x prog lhs rhs (hrel, args)
        args2 def_ptrs hrel_vars eq hd_nodes hv_nodes dir unk_hps) (hrel, args) def_ptrs

let rec collect_par_defs_one_constr_new_x prog constr =
  let lhs, rhs = constr.CF.hprel_lhs, constr.CF.hprel_rhs in
  DD.ninfo_pprint ">>>>>> collect partial def for hp_rel <<<<<<" no_pos;
  DD.ninfo_pprint (" hp_rel: " ^ (Cprinter.prtt_string_of_formula lhs) ^ " ==> " ^
  (Cprinter.prtt_string_of_formula rhs)) no_pos;
  let rec get_rec_pair_hps ls (hrel1, arg1)=
    match ls with
      | [] -> []
      | (hrel2, arg2)::ss -> if CP.eq_spec_var hrel1 hrel2 then [((hrel1, arg1), (hrel2, arg2))]
          else get_rec_pair_hps ss (hrel1, arg1)
  in
  let cs_predef_ptrs = constr.CF.predef_svl@constr.CF.unk_svl in
  (*find all defined pointer (null, nodes) and recursive defined parameters (HP, arg)*)
  let l_def_ptrs, l_hp_args_name,l_dnodes, l_vnodes,leqs = SAU.find_defined_pointers prog lhs cs_predef_ptrs in
  (*should mkAnd lhs*rhs?*)
  let r_def_ptrs, r_hp_args_name, r_dnodes, r_vnodes, reqs = find_defined_pointers_two_formulas prog lhs rhs cs_predef_ptrs in
  (*CASE 1: formula --> hp*)
  (*remove dup hp needs to be process*)
  let lhps = (Gen.BList.remove_dups_eq SAU.check_hp_arg_eq (l_hp_args_name)) in
  let lnon_unk_hps= Gen.BList.difference_eq SAU.check_simp_hp_eq lhps constr.CF.unk_hps in
  let rhps = (Gen.BList.remove_dups_eq SAU.check_hp_arg_eq (r_hp_args_name)) in
  let rnon_unk_hps= Gen.BList.difference_eq SAU.check_simp_hp_eq rhps constr.CF.unk_hps in
  let total_hps = (Gen.BList.remove_dups_eq SAU.check_hp_arg_eq (lhps@rhps)) in
  let lpdefs = List.concat (List.map (fun hrel ->
     collect_par_defs_one_side_one_hp prog lhs rhs hrel (l_def_ptrs@cs_predef_ptrs) rnon_unk_hps leqs (l_dnodes@r_dnodes) (l_vnodes@r_vnodes) constr.CF.unk_hps cs_predef_ptrs) lnon_unk_hps) in
  let rpdefs = List.concat (List.map (fun hrel ->
      collect_par_defs_one_side_one_hp prog lhs rhs hrel
          (l_def_ptrs@cs_predef_ptrs) [] (*pass [] to not exam case 2*)
          leqs (l_dnodes@r_dnodes) (l_vnodes@r_vnodes) constr.CF.unk_hps cs_predef_ptrs)
                                rnon_unk_hps) in
  (*CASE2: hp1(x1,x2,x3) --> h2(x1,x2,x3)* formula: hp such that have the same set of args in both sides - call in side lhs*)
  (*CASE 3: recursive contraints*)
  let rec_pair_hps = List.concat (List.map (get_rec_pair_hps l_hp_args_name) r_hp_args_name) in
  let unk_hp_names = List.map (fun (hp_name,_) -> hp_name) constr.CF.unk_hps in
  let rec_pair_hps = List.filter (fun ((hp,_),_) -> not (CP.mem_svl hp unk_hp_names)) rec_pair_hps in
   (*for debugging*)
  (* let pr1 = (pr_pair !CP.print_sv !CP.print_svl) in *)
  (* let pr2 = pr_list_ln (pr_pair pr1 pr1) in *)
  (* Debug.ninfo_hprint (add_str "  recursive pair: " (pr2)) rec_pair_hps no_pos; *)
  (*END for debugging*)
  let new_constrs, rec_pdefs =
    if rec_pair_hps = [] then
     (*drop constraints that have one hp after collect partial def*)
      let new_constrs=
        if (List.length total_hps) <= 1 then []
        else [constr]
      in (new_constrs, [])
    else
      let helper ((hp1,args1),(hp2,args2))=
        (*recompute defined ptrs*)
         let l_def_ptrs, _,_, _,_ = SAU.find_defined_pointers prog lhs (args2@cs_predef_ptrs) in
         (*should mkAnd lhs*rhs?*)
         let r_def_ptrs, _, _, _, _ = find_defined_pointers_two_formulas prog lhs rhs (args2@cs_predef_ptrs) in
        let r1 = collect_par_defs_recursive_hp prog lhs rhs (hp1,args1) args2
          (l_def_ptrs@r_def_ptrs@args2@cs_predef_ptrs) (l_hp_args_name@r_hp_args_name) (leqs@reqs)
          (l_dnodes@r_dnodes) (l_vnodes@r_vnodes) true constr.CF.unk_hps in
        if r1 = [] then
          (*recompute defined ptrs*)
          let l_def_ptrs, _,_, _,_ = SAU.find_defined_pointers prog lhs (args1@cs_predef_ptrs) in
         (*should mkAnd lhs*rhs?*)
          let r_def_ptrs, _, _, _, _ = find_defined_pointers_two_formulas prog lhs rhs (args1@cs_predef_ptrs) in
          collect_par_defs_recursive_hp prog lhs rhs (hp2,args2) args1
              (l_def_ptrs@r_def_ptrs@args1@cs_predef_ptrs) (l_hp_args_name@r_hp_args_name) (leqs@reqs)
              (l_dnodes@r_dnodes) (l_vnodes@r_vnodes) false constr.CF.unk_hps
        else r1
      in
      let rec_pdefs = List.concat (List.map helper rec_pair_hps) in
      (*drop constraints that have one hp after collect partial def*)
      let new_constrs=
        let num_hp = (List.length total_hps) in
        let num_pair_rec_hp = (List.length rec_pair_hps) in
        if (num_hp - num_pair_rec_hp) <= 1 then []
        else [constr]
      in (new_constrs, rec_pdefs)
  in
  (* DD.ninfo_pprint ("  partial defs: \n" ^ *)
  (* (let pr = pr_list_ln string_of_par_def_w_name in pr (lpdefs @ rpdefs)) ) no_pos; *)
  DD.ninfo_pprint ("  rec partial defs: \n" ^
  (let pr = pr_list_ln string_of_par_def_w_name in pr (rec_pdefs)) ) no_pos;
  (new_constrs,(lpdefs @ rpdefs @ rec_pdefs))

and collect_par_defs_one_constr_new prog constr =
  let pr1 = Cprinter.string_of_hprel in
  let pr2 = pr_list_ln string_of_par_def_w_name in
  let pr4 = pr_list_ln pr1 in
  let pr3 = (pr_pair pr4 pr2) in
  Debug.no_1 "collect_par_defs_one_constr_new" pr1 pr3
      (fun _ -> collect_par_defs_one_constr_new_x prog constr) constr

(* - collect partial def
  - simplify: remove constaints which have <= 1 hp
*)
let rec collect_partial_definitions_x prog constrs: (CF.hprel list * par_def_w_name list) =
  let simpl_constrs, par_defs = List.split (List.map (collect_par_defs_one_constr_new prog) constrs) in
  (List.concat simpl_constrs, List.concat par_defs)

and collect_partial_definitions prog constrs: (CF.hprel list * par_def_w_name list) =
  let pr1 = pr_list_ln Cprinter.string_of_hprel in
  let pr2 =  pr_list_ln string_of_par_def_w_name in
   Debug.no_1 "collect_partial_definitions" pr1 (pr_pair pr1 pr2)
 (fun _ -> collect_partial_definitions_x prog constrs) constrs


(*========SIMPLIFICATION============*)
let rec simplify_one_constr prog constr=
  begin
      let (lhs, rhs) = constr.CF.hprel_lhs,constr.CF.hprel_rhs in
      match lhs,rhs with
        | CF.Base lhs_b, CF.Base rhs_b ->
            begin
                let l,r,matched = simplify_one_constr_b prog lhs_b rhs_b in
                 (* if l.CF.formula_base_heap = CF.HEmp && *)
                 (*   (MCP.isConstMTrue l.CF.formula_base_pure) then *)
                if SAU.is_unk_f (CF.Base l) || SAU.is_unk_f (CF.Base r) then
                  let _ = DD.ninfo_pprint (" input: " ^(Cprinter.prtt_string_of_formula_base lhs_b) ^ " ==> " ^
                                                  (Cprinter.prtt_string_of_formula_base rhs_b)) no_pos in
                  let _ =  DD.ninfo_pprint (" output: drop") no_pos in
                   []
                 else
                   [{constr with CF.predef_svl = constr.CF.predef_svl@matched;
                       CF.hprel_lhs = CF.Base l;
                       CF.hprel_rhs = CF.Base r;
                    }]
              end
        | _ -> report_error no_pos "sa.simplify_one_constr"
  end

and simplify_one_constr_b_x prog lhs_b rhs_b=
  (*return subst of args and add in lhs*)
  let check_eq_data_node dn1 dn2=
    CP.eq_spec_var dn1.CF.h_formula_data_node dn2.CF.h_formula_data_node
  in
  let check_eq_view_node vn1 vn2=
    (*return subst of args and add in lhs*)
    CP.eq_spec_var vn1.CF.h_formula_view_node vn2.CF.h_formula_view_node
  in
  let l_hds, l_hvs, l_hrs = CF.get_hp_rel_bformula lhs_b in
  let r_hds, r_hvs, r_hrs = CF.get_hp_rel_bformula rhs_b in
  DD.ninfo_pprint (" input: " ^(Cprinter.prtt_string_of_formula_base lhs_b) ^ " ==> " ^
  (Cprinter.prtt_string_of_formula_base rhs_b)) no_pos;
  (*drop unused pointers in LHS*)
  DD.ninfo_pprint "  drop not-in-used pointers" no_pos;
  let keep_hrels,keep_ptrs = List.split (List.map
    (fun (hrel, eargs, _) -> (hrel, List.concat (List.map CP.afv eargs)))
    (l_hrs@r_hrs) )
  in
  let lhs_b1 = SAU.keep_data_view_hrel_nodes_fb prog lhs_b (l_hds@r_hds) (l_hvs@r_hvs)
    (List.concat keep_ptrs) keep_hrels in
  (*pointers/hps matching LHS-RHS*)
  (*data nodes, view nodes, rel*)
  DD.ninfo_pprint "  matching LHS-RHS" no_pos;
  let matched_data_nodes = Gen.BList.intersect_eq check_eq_data_node l_hds r_hds in
  let matched_view_nodes = Gen.BList.intersect_eq check_eq_view_node l_hvs r_hvs in
  let matched_hrel_nodes = Gen.BList.intersect_eq CF.check_eq_hrel_node l_hrs r_hrs in
  let hrels = List.map (fun (id,_,_) -> id) matched_hrel_nodes in
  let dnode_names = List.map (fun hd -> hd.CF.h_formula_data_node) matched_data_nodes in
  let vnode_names = List.map (fun hv -> hv.CF.h_formula_view_node) matched_view_nodes in
  Debug.ninfo_pprint ("    Matching found: " ^ (!CP.print_svl (dnode_names@vnode_names@hrels))) no_pos;
  let lhs_nhf2,rhs_nhf2=
    if (dnode_names@vnode_names@hrels)=[] then lhs_b1.CF.formula_base_heap,rhs_b.CF.formula_base_heap
    else
      let lhs_nhf = CF.drop_data_view_hrel_nodes_hf lhs_b1.CF.formula_base_heap
        SAU.select_dnode SAU.select_vnode SAU.select_hrel dnode_names vnode_names hrels in
      let rhs_nhf = CF.drop_data_view_hrel_nodes_hf rhs_b.CF.formula_base_heap
        SAU.select_dnode SAU.select_vnode SAU.select_hrel dnode_names vnode_names hrels in
      (lhs_nhf,rhs_nhf)
  in
  (*remove duplicate pure formulas and remove x!= null if x::node*)
  let lhs_nmf2 = CF.remove_neqNull_redundant_hnodes l_hds (MCP.pure_of_mix lhs_b1.CF.formula_base_pure) in
  let rhs_nmf2 = CF.remove_neqNull_redundant_hnodes (l_hds@r_hds) (MCP.pure_of_mix rhs_b.CF.formula_base_pure) in
  (* Debug.info_pprint ("    lmf: " ^ (!CP.print_formula lhs_nmf2)) no_pos; *)
  let lhs_b2 = {lhs_b1 with CF.formula_base_heap = lhs_nhf2;
      CF.formula_base_pure = MCP.mix_of_pure lhs_nmf2
               } in
  let rhs_b2 = {rhs_b with CF.formula_base_heap = rhs_nhf2;
               CF.formula_base_pure = MCP.mix_of_pure rhs_nmf2} in
 (*pure subformulas matching LHS-RHS: drop RHS*)
  DD.ninfo_pprint (" output: " ^(Cprinter.prtt_string_of_formula_base lhs_b2) ^ " ==> " ^
  (Cprinter.prtt_string_of_formula_base rhs_b2)) no_pos;
(lhs_b2, rhs_b2, dnode_names@vnode_names@hrels)

and simplify_one_constr_b prog lhs_b rhs_b=
  let pr = Cprinter.prtt_string_of_formula_base in
  Debug.no_2 "simplify_one_constr_b" pr pr (pr_triple pr pr !CP.print_svl)
      (fun _ _ -> simplify_one_constr_b_x prog lhs_b rhs_b) lhs_b rhs_b

let simplify_constrs_x prog constrs=
  List.concat (List.map (simplify_one_constr prog) constrs)

let simplify_constrs prog constrs=
   let pr = pr_list_ln (Cprinter.string_of_hprel) in
  Debug.no_1 "simplify_constrs" pr pr
      (fun _ -> simplify_constrs_x prog constrs) constrs
(*===========END SIMPLIFICATION===========*)

(*========subst==============*)
let rec check_unsat_x f=
  match f with
    | CF.Base fb -> check_inconsistency fb.CF.formula_base_heap fb.CF.formula_base_pure
    | CF.Or orf -> (check_unsat orf.CF.formula_or_f1) || (check_unsat orf.CF.formula_or_f2)
    | CF.Exists fe ->
        (*may not correct*)
        check_inconsistency fe.CF.formula_exists_heap fe.CF.formula_exists_pure

and check_unsat f=
  let pr1 = Cprinter.prtt_string_of_formula in
  let pr2 = string_of_bool in
  Debug.no_1 "check_unsat" pr1 pr2
      (fun _ -> check_unsat_x f) f

and check_inconsistency hf mixf=
  let new_mf = CF.xpure_for_hnodes hf in
  let cmb_mf = MCP.merge_mems mixf new_mf true in
  not (TP.is_sat_raw cmb_mf)

let subst_one_cs_w_one_partial_def f (hp_name, args, def_f)=
(*drop hrel and get current args*)
  let newf, argsl = CF.drop_hrel_f f [hp_name] in
  match argsl with
    | [] -> f
    | [eargs] ->
        begin
            (*to subst*)
        (*generate a susbst*)
        let args2= (List.fold_left List.append [] (List.map CP.afv eargs)) in
        DD.ninfo_pprint ("   subst " ^ (Cprinter.prtt_string_of_formula def_f) ^ " ==> " ^ (!CP.print_sv hp_name)
                        ^ (!CP.print_svl args)) no_pos;
        (* DD.ninfo_pprint ("   into " ^ (Cprinter.prtt_string_of_formula f)) no_pos; *)
        let subst = (List.combine args args2) in
        let def_f_subst = CF.subst subst def_f in
        (* DD.ninfo_pprint ("   body after subst " ^ (Cprinter.prtt_string_of_formula def_f_subst)) no_pos; *)
        (*should remove duplicate*)
        let svl1 = CF.fv newf in
        let svl2 = CF.fv def_f_subst in
        let intersect = CP.intersect svl1 svl2 in
        (* DD.ninfo_pprint ("   intersect: " ^ (!CP.print_svl intersect)) no_pos; *)
        let def_f1 =
          if intersect = [] then def_f_subst else
            (* let diff = Gen.BList.difference_eq CP.eq_spec_var svl2 svl1 in *)
            match def_f_subst with
              | CF.Base fb ->
                  CF.Base {fb with CF.formula_base_heap = CF.drop_data_view_hrel_nodes_hf fb.CF.formula_base_heap
                          SAU.select_dnode SAU.select_vnode
                          SAU.select_hrel intersect intersect intersect}
              | _ -> report_error no_pos "sa.subst_one_cs_w_one_partial_def"
        in
        (*combi def_f_subst into newf*)
        let newf1 = CF.mkStar newf def_f1 CF.Flow_combine (CF.pos_of_formula newf) in
        (*check contradiction*)
        let susbt_f=
          if check_unsat newf1 then
            let _ = DD.ninfo_pprint ("     contradiction found after subst.") no_pos in
            f
          else newf1
        in
        (* DD.ninfo_pprint ("   subst out: " ^ (Cprinter.prtt_string_of_formula susbt_f)) no_pos; *)
        susbt_f
      end
    | _ -> report_error no_pos "sa.subst_one_cs_w_one_partial_def: should be a singleton"

(*
each constraints, apply lhs and rhs. each partial def in one side ==> generate new constraint

 ldef --> hp: subst all hp in lhs with ldef
 hp --> rdef: subst all hp in rhs with rdef
*)
let subst_one_cs_w_partial_defs ldefs rdefs constr=
  let lhs,rhs = constr.CF.hprel_lhs,constr.CF.hprel_rhs in
  DD.ninfo_pprint ("    input: " ^(Cprinter.prtt_string_of_formula lhs) ^ " ==> " ^
  (Cprinter.prtt_string_of_formula rhs)) no_pos;
  (*subst lhs*)
  DD.ninfo_pprint "  subst lhs" no_pos;
  let lhs1 = List.fold_left subst_one_cs_w_one_partial_def lhs ldefs in
  (*subst rhs*)
  DD.ninfo_pprint "  subst rhs" no_pos;
  let rhs1 = List.fold_left subst_one_cs_w_one_partial_def rhs rdefs in
  (*rhs contradict with lhs?*)
  let cmbf = CF.mkStar lhs1 rhs1 CF.Flow_combine no_pos in
  let lhs2,rhs2 =
    if check_unsat cmbf then
      let _ = DD.ninfo_pprint ("      contradiction found between lhs and rhs") no_pos in
      (lhs,rhs)
    else (lhs1,rhs1)
  in
  let _ = DD.ninfo_pprint ("    out: " ^(Cprinter.prtt_string_of_formula lhs2) ^ " ==> " ^
                                 (Cprinter.prtt_string_of_formula rhs2)) no_pos in
  {constr with CF.hprel_lhs = lhs2;
      CF.hprel_rhs = rhs2}

let subst_cs_w_partial_defs_x hp_constrs par_defs=
  (*partition non-recursive partial defs: lhs set and rhs set*)
  let rec partition_par_defs pdefs lpdefs rpdefs=
    match pdefs with
      | [] -> (lpdefs, rpdefs)
      | (hp_name, hp_args, _, oldef, ordef)::ps ->
          (
              match oldef, ordef with
                | Some _ ,Some _ -> (*recursive par def -->currently omit*)
                    partition_par_defs ps lpdefs rpdefs
                | Some f1, None -> (*lhs case*)
                    partition_par_defs ps (lpdefs@[(hp_name, hp_args, f1)]) rpdefs
                | None, Some f2 -> (*rhs case*)
                    partition_par_defs ps lpdefs (rpdefs@[(hp_name, hp_args, f2)])
                | None, None -> (*can not happen*)
                    report_error no_pos "sa.partition_par_defs: can not happen"
          )
  in
  let (ldefs, rdefs) = partition_par_defs par_defs [] [] in
  List.map (subst_one_cs_w_partial_defs ldefs rdefs) hp_constrs

let subst_cs_w_partial_defs hp_constrs par_defs=
  let pr1 = pr_list_ln Cprinter.string_of_hprel in
  let pr2 = pr_list_ln string_of_par_def_w_name in
  Debug.no_2 "subst_cs_w_partial_defs" pr1 pr2 pr1
      (fun _ _ -> subst_cs_w_partial_defs_x hp_constrs par_defs) hp_constrs par_defs

(*
sth ====> A*HP1*HPn
substituted by HP1*HPn ====> b
(currently we only support HP1*HPn, we can enhance with
more general formula and use imply )
result is sth ====> A*b
*)
let subst_cs_w_other_cs_x constrs=
  (* find all constraints which have lhs is a HP1*HPn ====> b *)
  let check_lhs_hps_only constr=
    let lhs = constr.CF.hprel_lhs in
    let rhs = constr.CF.hprel_rhs in
    DD.ninfo_pprint ("      LHS: " ^ (Cprinter.prtt_string_of_formula lhs)) no_pos;
    match lhs with
      | CF.Base fb -> if (CP.isConstTrue (MCP.pure_of_mix fb.CF.formula_base_pure)) then
            let r = (CF.get_HRel fb.CF.formula_base_heap) in
            (match r with
              | None -> []
              | Some (hp, args) -> [(hp, args, rhs)]
            )
          else []
      | _ -> report_error no_pos "sa.subst_cs_w_other_cs: not handle yet"
  in
  let cs_substs = List.concat (List.map check_lhs_hps_only constrs) in
  (* let _ = if cs_substs = [] then DD.ninfo_pprint ("      EMPTY") no_pos else *)
  (*       DD.ninfo_pprint ("      NOT EMPTY") no_pos *)
  (* in *)
  List.map (subst_one_cs_w_partial_defs [] cs_substs) constrs

let rec subst_cs_w_other_cs constrs=
  let pr1 = pr_list_ln Cprinter.string_of_hprel in
   Debug.no_1 "subst_cs_w_other_cs" pr1 pr1
       (fun _ -> subst_cs_w_other_cs_x constrs) constrs

(* looking for constrs with the form
 sth ====> A*HP1*HPn *)
(* and subst_one_cs_w_hps subst_hps constr= *)
(*   let lhs,rhs = constr.CF.hprel_lhs,constr.CF.hprel_rhs in *)
(*   let get_rhs_hps f= *)
(*     match f with *)
(*       | CF.Base fb -> if (CP.isConstTrue (MCP.pure_of_mix fb.CF.formula_base_pure)) then *)
(*             let r = (CF.get_HRels fb.CF.formula_base_heap) in *)
(*             r *)
(*           else [] *)
(*       | _ -> report_error no_pos "sa.subst_cs_w_other_cs: not handle yet" *)
(*   in *)
(*   let sort_hps hps = List.sort (fun (CP.SpecVar (_, id1,_),_) *)
(*       (CP.SpecVar (_, id2, _),_)-> String.compare id1 id2) hps *)
(*   in *)
(*   (\*precondition: ls1 and ls2 are sorted*\) *)
(*   let rec checkeq ls1 ls2 subst= *)
(*     match ls1,ls2 with *)
(*       | [],[] -> (true,subst) *)
(*       | (id1, args1)::ss1,(id2, args2)::ss2 -> *)
(*           if CP.eq_spec_var id1 id2 then checkeq ss1 ss2 *)
(*             (subst@(List.combine args1 args2)) *)
(*           else (false,[]) *)
(*       | _ -> (false,[]) *)
(*   in *)
(*   let rhs_hps =  get_rhs_hps rhs in *)
(*   let sorted_rhs_hps = sort_hps rhs_hps in *)
(*   let find_and_susbt (hps, f)= *)
(*     let sorted_subst_hps = sort_hps hps in *)
(*     let res,subst = checkeq sorted_subst_hps sorted_rhs_hps [] in *)
(*     let l,r= *)
(*       if res then *)
(*         let hps,_ = List.split hps in *)
(*       (\*drop hrels and ignore args*\) *)
(*         let new_rhs, _ = CF.drop_hrel_f rhs hps in *)
(*         let subst_f = CF.subst subst f in *)
(*       (\*combi subst_f into new_rhs*\) *)
(*         let rhs2 = CF.mkStar new_rhs subst_f CF.Flow_combine (CF.pos_of_formula new_rhs) in *)
(*         (lhs,rhs2) *)
(*       else (lhs,rhs) *)
(*     in {constr with CF.hprel_lhs = l; *)
(*         CF.hprel_rhs = r;} *)
(*   in *)
(*   (List.map find_and_susbt subst_hps) *)

(*======================*)
(*
each lhs1, check rhs2 of other cs:
 - remove irrelevant svl of rhs2 (wrt. lhs1)
 - checkeq lhs1,rhs2: if yes
  - get susbt
  - form new cs (after subst): lhs2 -> rhs1
*)

(*input in fb
 output: true,susbs: can subst
*)

(*
dn is current node, it is one node of ldns
ss: subst from ldns -> ldns
*)
and get_closed_ptrs_one rdn ldns rdns rcur_match ss=
  (* let _ =  DD.ninfo_pprint ("    rdn: " ^ (!CP.print_sv rdn) ) no_pos in *)
  let rec find_args_subst largs rargs lm rm=
    match largs, rargs with
      | [],[] -> (lm,rm)
      | la::ls,ra::rs -> if CP.mem_svl ra rcur_match then
            (*find all matched previously. one lhs can match many rhs*)
            let l_ss = fst (List.split (List.filter (fun (_,r) -> CP.eq_spec_var r ra) ss)) in
            if CP.mem_svl la l_ss then
              find_args_subst ls rs lm rm (*matched already*)
            else find_args_subst ls rs (lm@[la]) (rm@[ra])
          else find_args_subst ls rs (lm@[la]) (rm@[ra])
      | _ -> report_error no_pos "sa.get_closed_ptrs: 1"
  in
  (* let _ =  DD.info_pprint ("    rdn: " ^ (!CP.print_sv rdn) ) no_pos in *)
  (*first node or args of a node intesect with rd*)
  (* let ldn_match = List.filter (fun (_,vs1, largs1) -> *)
  (*     let _ =  DD.info_pprint ("    ldn: " ^ (!CP.print_sv vs1) ) no_pos in *)
  (*     let vs2 = (CP.subs_one ss vs1) in *)
  (*     let largs2 = List.map (CP.subs_one ss) largs1 in *)
  (*     let _ =  DD.info_pprint ("    ldn2: " ^ (!CP.print_sv vs2) ) no_pos in *)
  (*     let _ =  DD.info_pprint ("    largs2: " ^ (!CP.print_svl largs2) ) no_pos in *)
  (*     (CP.eq_spec_var vs2 rdn) || (CP.mem_svl rdn largs2) *)
  (* ) ldns in *)
  (* let rdn_match = List.filter (fun (_,vs1, rargs1) -> *)
  (*     let _ =  DD.info_pprint ("    rargs1: " ^ (!CP.print_svl rargs1) ) no_pos in *)
  (*     (CP.eq_spec_var vs1 rdn) || (CP.mem_svl rdn rargs1)) rdns in *)
  if ldns = [] || rdns = [] then
    ([],[]) (*either lhs1 or rhs2 does not have any node*)
  else
    begin
        (* let (ld_name, lsv, largs) = List.hd ldn_match in *)
        (* let (rd_name, rsv, rargs) = List.hd rdn_match in *)
        let rec helper1 (ld_name, lsv, largs) rdn_m =
          match rdn_m with
            | [] -> []
            | (rd_name, rsv, rargs)::rs ->
                if ld_name = rd_name && (lsv = rsv || CP.intersect rargs largs <> [])then
                  rsv::rargs
                else helper1 (ld_name, lsv, largs) rs
        in
        let rec helper2 ldn_m=
          match ldn_m with
            | [] -> ([],[]) (*all node intersected are diff in type*)
            | (ld_name, lsv, largs):: ls ->
                let lsv1 = CP.subs_one ss lsv in
                (* if CP.mem_svl lsv1 rcur_match then helper2 ls *)
                (* else *)
                  begin
                      let largs1 = List.map (CP.subs_one ss) largs in
                      let rargs = helper1 (ld_name, lsv1, largs1) rdns in
                      if rargs = [] then helper2 ls
                      else
                        (* let _ =  DD.info_pprint ("    largs: " ^ (!CP.print_svl (lsv::largs))) no_pos in *)
                        (* let _ =  DD.info_pprint ("    rargs: " ^ (!CP.print_svl (rargs))) no_pos in *)
                        find_args_subst (lsv::largs) rargs [] []
                  end
        in
        let lm,rm = helper2 ldns in
        (* let _ =  DD.info_pprint ("    lm " ^ (!CP.print_svl (lm))) no_pos in *)
        (* let _ =  DD.info_pprint ("    rm " ^ (!CP.print_svl (rm))) no_pos in *)
        if lm = [] then ([],[]) (*all node intersected are diff in type*)
        else (rm, List.combine lm rm)
    end

and get_closed_matched_ptrs ldns rdns rcur_match ss=
  let rec helper old_m old_ss inc_m=
    (*find matching ldns and rdns*)
    let r = List.map (fun m -> get_closed_ptrs_one m ldns rdns old_m old_ss) inc_m in
    let incr_match, incr_ss = List.split r in
    if incr_match = [] then
      old_m, old_ss
    else
      let n_incr_m = (List.concat incr_match) in
      helper (old_m@n_incr_m) (old_ss@(List.concat incr_ss)) n_incr_m
  in
  helper rcur_match ss rcur_match

(*
 lhs1 ==> rhs1
find all constraints lhs2 ==> rhs2 such that
 rhs2 |- lhs1 --> l,r.
Note
- rhs2 may have more hps + hnode than lhs1
- should return a subst from lhs1 to rhs2 since at the end
we have to combine rhs1 into r to form a new cs:
      lhs2*l ===> r*subst(rhs1)
*)
and find_imply lhs1 rhs1 lhs2 rhs2=
  let sort_hps_x hps = List.sort (fun (CP.SpecVar (_, id1,_),_)
      (CP.SpecVar (_, id2, _),_)-> String.compare id1 id2) hps
  in
  let sort_hps hps=
    let pr1 = pr_list_ln (pr_pair !CP.print_sv !CP.print_svl) in
    Debug.no_1 "sort_hps" pr1 pr1
        (fun _ ->  sort_hps_x hps) hps
  in
  (*precondition: ls1 and ls2 are sorted*)
  (*we may enhance here, ls1, ls2 are not necessary the same: ls2 >= ls1*)
  let rec check_hrels_imply ls1 ls2 subst matched args=
    match ls1,ls2 with
      | [],[] -> (subst,matched,args)
      | (id1, args1)::ss1,(id2, args2)::ss2 ->
          if CP.eq_spec_var id1 id2 then
            check_hrels_imply ss1 ss2
            (subst@(List.combine args1 args2)) (matched@[id2]) (args@args2)
          else check_hrels_imply ls1 ss2 subst matched args
      | [], _ -> (subst,matched,args)
      | _ -> ([],[],[])
  in
  let transform_hrel (hp,eargs,_)= (hp, List.concat (List.map CP.afv eargs)) in
  let transform_dn dn= (dn.CF.h_formula_data_name, dn.CF.h_formula_data_node,
                        List.filter (fun (CP.SpecVar (t,_,_)) -> is_pointer t ) dn.CF. h_formula_data_arguments) in
  (*matching hprels and return subst*)
  let ldns,_,lhrels = CF.get_hp_rel_bformula lhs1 in
  let rdns,_,rhrels = CF.get_hp_rel_bformula rhs2 in
  let l_rhrels = sort_hps (List.map transform_hrel lhrels) in
  let r_rhrels = sort_hps (List.map transform_hrel rhrels) in
  (*m_args2: matched slv of rhs2*)
  let subst,matched_hps, m_args2 = check_hrels_imply l_rhrels r_rhrels [] [] [] in
  let r=
    if matched_hps = [] then None
    else
      begin
          (*for debugging*)
          (* let _ = Debug.info_pprint ("     m_args2: " ^ (!CP.print_svl  m_args2)) no_pos in *)
          (* let pr_ss = pr_list (pr_pair !CP.print_sv !CP.print_sv) in *)
          (* let _ =  Debug.info_pprint ("     subst: " ^ (pr_ss subst)) no_pos in *)
          (*END for debugging*)
      (*matching hnodes (in matched_hps) and return subst*)
          let lhns1 = List.map transform_dn ldns in
          let rhns1 = List.map transform_dn rdns in
          (*all_matched_svl2: all matched slv of rhs2*)
          let all_matched_svl2,subst1 =  get_closed_matched_ptrs lhns1 rhns1 m_args2 subst in
          (* let _ = Debug.info_pprint ("    all matched: " ^ (!CP.print_svl all_matched_svl2)) no_pos in *)
          (* let _ =  Debug.info_pprint ("     subst: " ^ (pr_ss subst1)) no_pos in *)
      (*subst in lhs1*)
          let n_lhs1 = CF.subst_b subst1 lhs1 in
      (*check pure implication*)
          let lmf = CP.filter_var_new (MCP.pure_of_mix n_lhs1.CF.formula_base_pure)  all_matched_svl2 in
          let rmf = (MCP.pure_of_mix rhs2.CF.formula_base_pure) in
          (* let _ = Debug.info_pprint ("    n_lhs1: " ^ (Cprinter.string_of_formula_base n_lhs1)) no_pos in *)
          (* let _ = Debug.info_pprint ("    lmf: " ^ (!CP.print_formula lmf)) no_pos in *)
          (* let _ = Debug.info_pprint ("    rmf: " ^ (!CP.print_formula rmf)) no_pos in *)
          let b,_,_ = TP.imply rmf lmf "sa:check_hrels_imply" true None in
          let lpos = (CF.pos_of_formula lhs2) in
          if b then
            let l_res = {n_lhs1 with
              CF.formula_base_heap = CF.drop_data_view_hrel_nodes_hf
                  n_lhs1.CF.formula_base_heap SAU.select_dnode
                  SAU.select_vnode SAU.select_hrel  all_matched_svl2  all_matched_svl2 matched_hps}
            in
            (*drop hps and matched svl in n_rhs2*)
            let r_res = {rhs2 with
                CF.formula_base_heap = CF.drop_data_view_hrel_nodes_hf
                    rhs2.CF.formula_base_heap SAU.select_dnode
                    SAU.select_vnode SAU.select_hrel all_matched_svl2 all_matched_svl2 matched_hps;
                CF.formula_base_pure = MCP.mix_of_pure
                    (CP.filter_var_new
                         (MCP.pure_of_mix rhs2.CF.formula_base_pure) all_matched_svl2)}
            in
            (*avoid clashing --> should refresh remain slv of lhs2*)
            let slv2 = CP.remove_dups_svl ((CF.fv lhs2)@
                                                  (CF.fv (CF.Base rhs2))) in
            (*do not rename HP names*)
            let hp_names = CP.remove_dups_svl ((CF.get_hp_rel_name_formula lhs2)@(CF.get_hp_rel_name_bformula rhs2)) in
            (*remove hp name*)
            let diff1 = Gen.BList.difference_eq CP.eq_spec_var slv2 hp_names in
            let _ = Debug.ninfo_pprint ("    diff1: " ^ (!CP.print_svl diff1)) no_pos in
            (*elim matched svl*)
            let diff2 = Gen.BList.difference_eq CP.eq_spec_var diff1 all_matched_svl2 in
            let _ = Debug.ninfo_pprint ("    diff2: " ^ (!CP.print_svl diff2)) no_pos in
            (*refresh it*)
            let fresh_diff2 = CP.fresh_spec_vars diff2 in
            let ss2 = List.combine diff2 fresh_diff2 in
            let n_lhs2 = CF.subst ss2 lhs2 in
            (*end refresh*)
        (*combine l_res into lhs2*)
            let l =  CF.mkStar n_lhs2 (CF.Base l_res) CF.Flow_combine lpos in
            let n_rhs1 = CF.subst subst1 rhs1 in
            (*avoid clashing --> should refresh remain slv of r_res*)
            let r_res1 = CF.subst ss2 (CF.Base r_res) in
            (*elim duplicate hprel in r_res1 and n_rhs1*)
            let nr_hprel = CF.get_HRels_f n_rhs1 in
            let nrest_hprel = CF.get_HRels_f r_res1 in
            let diff3 = Gen.BList.intersect_eq SAU.check_hp_arg_eq nr_hprel nrest_hprel in
            let r_res2,_ = CF.drop_hrel_f r_res1 (List.map (fun (hp,_) -> hp) diff3) in
            let r = CF.mkStar n_rhs1 r_res2 CF.Flow_combine (CF.pos_of_formula n_rhs1) in
            (Some (l, r,subst1, ss2))
          else None
      end
  in
  r

and find_imply_subst_x constrs=
  let rec check_constr_duplicate (lhs,rhs) constrs=
    match constrs with
      | [] -> false
      | cs::ss -> if SAU.checkeq_pair_formula (lhs,rhs)
            (cs.CF.hprel_lhs,cs.CF.hprel_rhs) then
            true
          else check_constr_duplicate (lhs,rhs) ss
  in
  let find_imply_one cs1 cs2=
    let _ = Debug.ninfo_pprint ("    cs2: " ^ (Cprinter.string_of_hprel cs2)) no_pos in
    match cs1.CF.hprel_lhs,cs2.CF.hprel_rhs with
      | CF.Base lhs1, CF.Base rhs2 ->
          let r = find_imply lhs1 cs1.CF.hprel_rhs cs2.CF.hprel_lhs rhs2 in
          begin
              match r with
                | Some (l,r,lhs_ss, rhs_ss) ->
                    (*check duplicate*)
                    if check_constr_duplicate (l,r) constrs then []
                    else
                      begin
                          let new_cs = {cs2 with
                              CF.predef_svl = CP.remove_dups_svl
                                  ((CP.subst_var_list lhs_ss cs1.CF.predef_svl)@
                                          (CP.subst_var_list rhs_ss cs2.CF.predef_svl));
                              CF.unk_svl = CP.remove_dups_svl
                                  ((CP.subst_var_list lhs_ss cs1.CF.unk_svl)@
                                          (CP.subst_var_list rhs_ss cs2.CF.unk_svl));
                              CF.hprel_lhs = l;
                              CF.hprel_rhs = r;
                          }
                          in
                          let _ = Debug.ninfo_pprint ("    new cs: " ^ (Cprinter.string_of_hprel new_cs)) no_pos in
                          [new_cs]
                      end
                | None -> []
          end
      | _ -> report_error no_pos "sa.find_imply_one"
  in
  let rec helper don rest res=
    match rest with
      | [] -> res
      | cs::ss ->  (* let _ = Debug.ninfo_pprint ("    ss size1: " ^ (string_of_int (List.length ss))) no_pos in *)
          let _ = Debug.ninfo_pprint ("    cs1: " ^ (Cprinter.string_of_hprel cs)) no_pos in
          let r = List.concat (List.map (find_imply_one cs) (don@ss)) in
          (helper (don@[cs]) ss (res@r))
  in
  helper [] constrs []

and find_imply_subst constrs=
  let pr1 = pr_list_ln Cprinter.string_of_hprel in
  Debug.no_1 "find_imply_subst" pr1 pr1
      (fun _ -> find_imply_subst_x constrs) constrs

and subst_cs_w_other_cs_new_x constrs=
  let is_non_recursive_cs constr=
    let lhrel_svl = CF.get_hp_rel_name_formula constr.CF.hprel_lhs in
    let rhrel_svl = CF.get_hp_rel_name_formula constr.CF.hprel_rhs in
    ((CP.intersect lhrel_svl rhrel_svl) = [])
  in
  (*remove recursive cs*)
  let constrs1 = List.filter is_non_recursive_cs constrs in
  (* let cs_susbsts = List.concat (List.map check_lhs_hps_only constrs) in *)
  (* List.concat (List.map (subst_one_cs_w_hps cs_susbsts) constrs) *)
  find_imply_subst constrs1
(*=========END============*)

let rec subst_cs_w_other_cs_new constrs=
  let pr1 = pr_list_ln Cprinter.string_of_hprel in
   Debug.no_1 "subst_cs_w_other_cs_new" pr1 pr1
       (fun _ -> subst_cs_w_other_cs_new_x constrs) constrs

let subst_cs_x hp_constrs par_defs=
  (*subst by constrs*)
  DD.ninfo_pprint "\n subst with other assumptions" no_pos;
  let new_cs =
    if (List.length hp_constrs) > 1 then
      subst_cs_w_other_cs_new hp_constrs
    else []
  in
(*subst by partial defs*)
  DD.ninfo_pprint "\n subst with partial defs" no_pos;
  let constrs1 = subst_cs_w_partial_defs (hp_constrs@new_cs) par_defs in
  (constrs1)

let subst_cs hp_constrs par_defs=
  let pr1 = pr_list_ln Cprinter.string_of_hprel in
  let pr2 = pr_list_ln string_of_par_def_w_name in
  Debug.no_2 "subst_cs" pr1 pr2 pr1
      (fun _ _ -> subst_cs_x hp_constrs par_defs) hp_constrs par_defs

(*===========end subst============*)
(*========generalization==========*)
(*for par_defs*)
let generalize_one_hp prog par_defs=
  (*collect definition for each partial definition*)
  let obtain_and_norm_def args0 (a1,args,f)=
    (*normalize args*)
    let subst = List.combine args args0 in
    (CF.subst subst f)
  in
  DD.ninfo_pprint ">>>>>> generalize_one_hp: <<<<<<" no_pos;
  let hp, args, _ = (List.hd par_defs) in
  (* DD.ninfo_pprint ((!CP.print_sv hp)^"(" ^(!CP.print_svl args) ^ ")") no_pos; *)
  let defs = List.map (obtain_and_norm_def args) par_defs in
    (*remove duplicate*)
  let defs1 = Gen.BList.remove_dups_eq (fun f1 f2 -> SAU.check_relaxeq_formula f1 f2) defs in
  (*find longest hnodes common for more than 2 formulas*)
  (*each hds of hdss is def of a next_root*)
  let defs = SAU.get_longest_common_hnodes_list prog hp args defs1 in
  defs

let get_def_body (a1,args,a3,olf,orf)=
  match olf,orf with
    | Some f, None -> (a1,args,f)
    | None, Some f -> (a1,args,f)
    | Some f1, Some f2 -> (a1,args,f2)
    | None, None -> report_error no_pos "sa.obtain_def: can't happen 2"


(*=========SUBST DEF and PARDEF FIX==========*)
(*
  divide hp into three groups:
  - independent - ready for genalizing
  - dependent:
      - depend on non-recursive groups: susbst
      - depend on recusive groups: wait
*)
let pardef_subst_fix_x unk_hps groups=
  let is_rec_pardef (hp,_,f)=
    let hps = CF.get_hp_rel_name_formula f in
    (CP.mem_svl hp hps)
  in
  let is_independ_pardef (hp,_,f) =
    let hps = CF.get_hp_rel_name_formula f in
    let hps = CP.remove_dups_svl hps in
    (* DD.ninfo_pprint ("       rec hp: " ^ (!CP.print_sv hp)) no_pos; *)
    let _,rems = List.partition (fun hp1 -> CP.eq_spec_var hp hp1) hps in
    (* DD.ninfo_pprint ("       rec rems: " ^ (!CP.print_svl rems)) no_pos; *)
    (rems = [])
  in
  let is_rec_group grp=
    List.exists is_rec_pardef grp
  in
  let is_independ_group grp =
    List.for_all is_independ_pardef grp
  in
  let get_succ_hps_pardef (_,_,f)=
    (CF.get_HRels_f f)
  in
  let process_dep_group grp rec_hps nrec_grps=
    let (hp,_,_) = List.hd grp in
    (* DD.ninfo_pprint ("       process_dep_group hp: " ^ (!CP.print_sv hp)) no_pos; *)
    let succ_hp_args = List.concat (List.map get_succ_hps_pardef grp) in
    (*remove dups*)
    let succ_hp_args = Gen.BList.remove_dups_eq SAU.check_simp_hp_eq succ_hp_args in
    (*get succ hp names only*)
    let succ_hps = fst (List.split succ_hp_args) in
    (* DD.ninfo_pprint ("       process_dep_group succ_hps: " ^ (!CP.print_svl succ_hps)) no_pos; *)
    (*remove itself hp and unk_hps*)
    let succ_hps1 = List.filter (fun hp1 -> not (CP.eq_spec_var hp1 hp) &&
        not (CP.mem_svl hp1 unk_hps)) succ_hps in
    (* DD.ninfo_pprint ("       process_dep_group succ_hps1: " ^ (!CP.print_svl succ_hps1)) no_pos; *)
    if (CP.intersect succ_hps1 rec_hps) = [] then
      (*not depends on any recursive hps, susbt it*)
      let ters,new_grp_ls = List.split (List.map (SAU.succ_susbt nrec_grps) grp) in
      (*check all is false*)
      (* let pr = pr_list string_of_bool in *)
      (* DD.ninfo_pprint ("       bool: " ^ (pr ters)) no_pos; *)
      let ter = List.for_all (fun b -> not b) ters in
      (not ter,List.concat new_grp_ls)
    else
      (*return*)
      (false,grp)
  in
  let subst_first_dep_group deps rec_hps nrec_grps=
    let rec local_helper deps res=
      match deps with
        | [] -> (false,res)
        | grp::gs -> let r,grp1 = process_dep_group grp rec_hps nrec_grps in
                     if r then (true,(res@[grp1]@gs))
                     else local_helper gs (res@[grp])
    in
    (* if nrec_grps = [] then (false, deps) else *)
      local_helper deps []
  in
  let helper_x grps rec_inds nrec_inds=
    let indeps,deps = List.partition is_independ_group grps in
    (*classify indeps into rec and non_rec*)
    let lrec_inds,lnrec_inds = List.partition is_rec_group indeps in
    (*for return*)
    let res_rec_inds = rec_inds@lrec_inds in
    let res_nrec_inds = nrec_inds@lnrec_inds in
    let lrec_deps,l_nrec_deps = List.partition is_rec_group deps in
    (*find deps on non_recs*)
    let rec_hps = List.map
      (fun grp -> let (hp,_,_) = List.hd grp in hp)
      (res_rec_inds@lrec_deps) in
    (*find the first depend grp in deps to subst,
    if can not find, return false for terminating*)
    let r, deps1 = subst_first_dep_group deps rec_hps (res_nrec_inds@l_nrec_deps) in
    ((List.length indeps>0 || r), deps1, res_rec_inds,res_nrec_inds)
  in
  (*for debugging*)
   let helper grps rec_inds nrec_inds=
     let pr1 = pr_list_ln (pr_list_ln string_of_par_def_w_name_short) in
     let pr2= pr_quad string_of_bool pr1 pr1 pr1 in
     Debug.no_3 "pardef_subst_fix:helper" pr1 pr1 pr1 pr2
         (fun _ _ _ -> helper_x grps rec_inds nrec_inds) grps rec_inds nrec_inds
   in
  (*END for debugging*)
  let rec helper_fix cur rec_indps nrec_indps=
    let r,new_cur,new_rec_indps,new_nrec_indps = helper cur rec_indps nrec_indps in
    if r then helper_fix new_cur new_rec_indps new_nrec_indps
    else (new_cur@new_rec_indps@new_nrec_indps)
  in
  helper_fix groups [] []

(*this subst is for a nice matching between inferred HP
and lib based predicates*)
let pardef_subst_fix unk_hps groups=
  let pr1 = pr_list_ln (pr_list_ln string_of_par_def_w_name_short) in
  Debug.no_1 "pardef_subst_fix" pr1 pr1
      (fun _ -> pardef_subst_fix_x unk_hps groups) groups

(*=========SUBST DEF FIX==========*)
(*
  divide hp into three groups:
  - independent - ready for genalizing
  - dependent:
      - depend on non-recursive groups: susbst
      - depend on recusive groups: wait
*)
let def_subst_fix_x unk_hps hpdefs=
  (*remove dups*)
  (* let unk_hps = CP.remove_dups_svl unk_hps in *)
  let is_rec_hpdef (CP.HPRelDefn hp,_,f)=
    let hps = CF.get_hp_rel_name_formula f in
    (CP.mem_svl hp hps)
  in
  let is_independ_hpdef (CP.HPRelDefn hp,_,f)=
    let hps = CF.get_hp_rel_name_formula f in
    let hps = CP.remove_dups_svl hps in
    (* DD.ninfo_pprint ("       rec hp: " ^ (!CP.print_sv hp)) no_pos; *)
    let _,rems = List.partition (fun hp1 -> CP.eq_spec_var hp hp1) hps in
    (* DD.ninfo_pprint ("       rec rems: " ^ (!CP.print_svl rems)) no_pos; *)
    (rems = [])
  in
  let process_dep_hpdef hpdef rec_hps nrec_hpdefs=
    let (CP.HPRelDefn hp,hprel,f) = hpdef in
    let fs = CF.list_of_disjs f in
    (* DD.ninfo_pprint ("       process_dep_group hp: " ^ (!CP.print_sv hp)) no_pos; *)
    let succ_hp_args =  List.concat (List.map CF.get_HRels_f fs) in
    (*remove dups*)
    let succ_hp_args = Gen.BList.remove_dups_eq SAU.check_simp_hp_eq succ_hp_args in
    (*get succ hp names only*)
    let succ_hps = fst (List.split succ_hp_args) in
    (* DD.ninfo_pprint ("       process_dep_group succ_hps: " ^ (!CP.print_svl succ_hps)) no_pos; *)
    (*remove itself hp and unk_hps*)
    let succ_hps1 = List.filter (fun hp1 -> not (CP.eq_spec_var hp1 hp) &&
        not (CP.mem_svl hp1 unk_hps)) succ_hps in
    (* DD.info_pprint ("       process_dep_group succ_hps1: " ^ (!CP.print_svl succ_hps1)) no_pos; *)
    if (CP.intersect succ_hps1 rec_hps) = [] then
      (*not depends on any recursive hps, susbt it*)
      let args = SAU.get_ptrs hprel in
      let ters,new_fs = List.split (List.map (fun f1 -> SAU.succ_susbt_hpdef nrec_hpdefs succ_hps1 (hp,args,f1)) fs) in
      (*check all is false*)
      (* let pr = pr_list string_of_bool in *)
      (* DD.ninfo_pprint ("       bool: " ^ (pr ters)) no_pos; *)
      let ter = List.for_all (fun b -> not b) ters in
      let new_f1  = SAU.remove_longer_common_prefix_w_unk unk_hps (List.concat new_fs) in
      (not ter, (CP.HPRelDefn hp,hprel,CF.disj_of_list new_f1 no_pos ))
    else
      (*return*)
      (false,hpdef)
  in
  let subst_first_dep_hpdef deps rec_hps nrec_hpdefs=
    let rec local_helper deps res=
      match deps with
        | [] -> (false,res)
        | hpdef::gs -> let r,hpdef1 = process_dep_hpdef hpdef rec_hps nrec_hpdefs in
                     if r then (true,(res@[hpdef1]@gs))
                     else local_helper gs (res@[hpdef])
    in
    (* if nrec_grps = [] then (false, deps) else *)
      local_helper deps []
  in
  let helper_x hpdefs rec_inds nrec_inds=
    let indeps,deps = List.partition is_independ_hpdef hpdefs in
    (*classify indeps into rec and non_rec*)
    let lrec_inds,lnrec_inds = List.partition is_rec_hpdef indeps in
    (*for return*)
    let res_rec_inds = rec_inds@lrec_inds in
    let res_nrec_inds = nrec_inds@lnrec_inds in
    let lrec_deps,l_nrec_deps = List.partition is_rec_hpdef deps in
    (*find deps on non_recs*)
    let rec_hps = List.map
      (fun (CP.HPRelDefn hp,_,_) ->  hp)
      (res_rec_inds@lrec_deps) in
    (*find the first depend grp in deps to subst,
    if can not find, return false for terminating*)
    let r, deps1 = subst_first_dep_hpdef deps rec_hps (res_nrec_inds@l_nrec_deps) in
    ((List.length indeps>0 || r), deps1, res_rec_inds,res_nrec_inds)
  in
  (*for debugging*)
   let helper hpdefs rec_inds nrec_inds=
     let pr1 = pr_list_ln (pr_list_ln Cprinter.string_of_hprel_def) in
     let pr2= pr_quad string_of_bool pr1 pr1 pr1 in
     Debug.no_3 "def_subst_fix:helper" pr1 pr1 pr1 pr2
         (fun _ _ _ -> helper_x hpdefs rec_inds nrec_inds) hpdefs rec_inds nrec_inds
   in
  (*END for debugging*)
  let rec helper_fix cur rec_indps nrec_indps=
    let r,new_cur,new_rec_indps,new_nrec_indps = helper cur rec_indps nrec_indps in
    if r then helper_fix new_cur new_rec_indps new_nrec_indps
    else (new_cur@new_rec_indps@new_nrec_indps)
  in
  helper_fix hpdefs [] []

(*this subst is to elim intermediate hps in final inferred hprel def
 *)
let def_subst_fix unk_hps hpdefs=
  let pr1 = pr_list_ln Cprinter.string_of_hp_rel_def in
  Debug.no_1 "def_subst_fix" pr1 pr1
      (fun _ -> def_subst_fix_x unk_hps hpdefs) hpdefs

  (*=========END SUBST FIX==========*)

let remove_dups_pardefs_x grp=
  let eq_pardefs (_,args1,f1) (_,args2,f2)=
    let ss = List.combine args1 args2 in
    let nf1 = CF.subst ss f1 in
    SAU.check_relaxeq_formula nf1 f2
  in
  Gen.BList.remove_dups_eq eq_pardefs grp

let remove_dups_pardefs grp=
  let pr1 = (pr_list_ln string_of_par_def_w_name_short) in
  Debug.no_1 "remove_dups_pardefs" pr1 pr1
      (fun _ -> remove_dups_pardefs_x grp) grp

let generalize_hps_par_def prog unk_hps par_defs=
  (*partition the set by hp_name*)
  let rec partition_pdefs_by_hp_name pdefs parts=
    match pdefs with
      | [] -> parts
      | (a1,a2,a3)::xs ->
          let part,remains= List.partition (fun (hp_name,_,_) -> CP.eq_spec_var a1 hp_name) xs in
          partition_pdefs_by_hp_name remains (parts@[[(a1,a2,a3)]@part])
  in
  let par_defs1 = List.map get_def_body par_defs in
  let groups = partition_pdefs_by_hp_name par_defs1 [] in
  (*remove dups in each group*)
  let groups1 = List.map remove_dups_pardefs groups in
  (*
    subst such that each partial def does not contain other hps
    dont subst recursively
    search_largest_matching between two formulas
  *)
  let groups2 = pardef_subst_fix (List.map (fun (hp,_) -> hp) unk_hps) groups1 in
  (*each group, do union partial definition*)
  List.concat ((List.map (generalize_one_hp prog) groups2))

let drop_unk_hps unk_hp_args cs=
  let unk_hps,_ = List.split unk_hp_args in
  (*get all cs hp_args*)
  let cs_hp_args = (CF.get_HRels_f cs.CF.hprel_lhs)@(CF.get_HRels_f cs.CF.hprel_rhs) in
  let cs_unk_hps = List.concat (List.map (fun (hp,_) -> if (CP.mem_svl hp unk_hps) then [hp] else []) cs_hp_args) in
  let cs_unk_hps =  CP.remove_dups_svl cs_unk_hps in
  (*drop them*)
  if cs_unk_hps = [] then
        cs
  else
    let n_lhs,_ = CF.drop_hrel_f cs.CF.hprel_lhs  cs_unk_hps in
    let n_rhs,_ = CF.drop_hrel_f cs.CF.hprel_rhs  cs_unk_hps in
    {cs with CF.hprel_lhs = n_lhs;
        CF.hprel_rhs = n_rhs;
    }

let generalize_hps_cs hp_names cs=
  let rec look_up_hrel id ls=
    match ls with
      | [] -> report_error no_pos "sa.generalize_hps_cs: can not happen"
      | (id1, vars, p)::cs -> if CP.eq_spec_var id id1 then (id1, vars, p)
          else look_up_hrel id cs
  in
  let check_formula_hp_only f=
    match f with
      | CF.Base fb -> if (CP.isConstTrue (MCP.pure_of_mix fb.CF.formula_base_pure)) then
            let r = (CF.get_HRel fb.CF.formula_base_heap) in
            (match r with
              | None -> None
              | Some (hp, args) -> Some (hp, args)
            )
          else None
      | _ -> report_error no_pos "sa.subst_cs_w_other_cs: not handle yet"
  in
  let generalize_hps_one_cs hpdefs constr=
    let lhs,rhs = constr.CF.hprel_lhs,constr.CF.hprel_rhs in
    let _,_,l_hp = CF.get_hp_rel_formula lhs in
    let _,_,r_hp = CF.get_hp_rel_formula rhs in
    let hps = List.map (fun (id, _, _) -> id) (l_hp@r_hp) in
    (*filer def hp out*)
    let diff = Gen.BList.difference_eq CP.eq_spec_var hps hpdefs in
    match diff with
      | [] -> ([],[]) (*drop constraint, no new definition*)
      | [id] -> let (hp, args, p) = look_up_hrel id (l_hp@r_hp) in
                let ohp = check_formula_hp_only lhs in
                (match ohp with
                  | None ->
                       let ohp = check_formula_hp_only rhs in
                       ( match ohp with
                         | None -> ([constr],[]) (*keep constraint, no new definition*)
                         |  Some (hp, args) ->
                             if CP.mem_svl hp hpdefs then (*defined already drop constraint, no new definition*)
                               let _ = DD.ninfo_pprint ">>>>>> generalize_one_cs_hp: <<<<<<" no_pos in
                               let _ = DD.ninfo_pprint ("         " ^ (!CP.print_sv hp) ^ " is defined already: drop the constraint") no_pos in
                               ([],[])
                             else
                               ([],[(CP.HPRelDefn hp,(* CF.formula_of_heap*)
                                     (CF.HRel (hp, List.map (fun x -> CP.mkVar x no_pos) args, p)) (*p*), lhs)])
                       )
                  | Some (hp, args) ->
                      if CP.mem_svl hp hpdefs then (*defined already drop constraint, no new definition*)
                        let _ = DD.ninfo_pprint ">>>>>> generalize_one_cs_hp: <<<<<<" no_pos in
                        let _ = DD.ninfo_pprint ("         " ^ (!CP.print_sv hp) ^ " is defined already: drop the constraint") no_pos in
                        ([],[])
                      else begin
                          DD.ninfo_pprint ">>>>>> generalize_one_cs_hp: <<<<<<" no_pos;
                          DD.ninfo_pprint ((!CP.print_sv hp)^"(" ^(!CP.print_svl args) ^ ")=" ^
                                             (Cprinter.prtt_string_of_formula rhs) ) no_pos;
                          ([],[(CP.HPRelDefn hp, (*CF.formula_of_heap*)
                                (CF.HRel (hp, List.map (fun x -> CP.mkVar x no_pos) args, p)) , rhs)])
                          end
                )
      | _ -> ([constr],[]) (*keep constraint, no new definition*)
  in
  let r = List.map (generalize_hps_one_cs hp_names) cs in
  let cs1, hp_defs = List.split r in
  (List.concat cs1, List.concat hp_defs)

let get_unk_hps_relation_x prog hpdefs cs=
  let lhns, lhvs, lhrels = CF.get_hp_rel_formula cs.CF.hprel_lhs in
  let rhns, rhvs, rhrels = CF.get_hp_rel_formula cs.CF.hprel_rhs in
  let lhp_args = List.map (fun (hp,eargs, _) -> (hp, List.concat (List.map CP.afv eargs))) lhrels in
  let rhp_args = List.map (fun (hp,eargs, _) -> (hp, List.concat (List.map CP.afv eargs))) rhrels in
  let hp_args = Gen.BList.remove_dups_eq SAU.check_simp_hp_eq (lhp_args@rhp_args) in
  let helper (_, hf,_)= fst (List.split (CF.get_HRels hf)) in
  (*lookup all unk_hp of current cs*)
  let cs_unk_hps = (List.map (fun (hp,_) -> hp) cs.CF.unk_hps) in
  let cs_def_hps = List.concat (List.map helper hpdefs) in
  let def_hps, remains = List.partition (fun (hp,_) -> CP.mem_svl hp cs_def_hps) hp_args in
  let unk_hps, undef = List.partition (fun (hp,_) -> CP.mem_svl hp cs_unk_hps) remains in
  (* (\*for debugging*\) *)
  (* let pr = pr_list_ln (pr_pair !CP.print_sv !CP.print_svl) in *)
  (* let _ = Debug.ninfo_pprint ("     lhps: " ^ (pr lhp_args)) no_pos in *)
  (* let _ = Debug.ninfo_pprint ("     rhps: " ^ (pr rhp_args)) no_pos in *)
  (* let _ = Debug.ninfo_pprint ("     all hps: " ^ (pr hp_args)) no_pos in *)
  (* let _ = Debug.ninfo_pprint ("     defs: " ^ (pr def_hps)) no_pos in *)
  (* let _ = Debug.ninfo_pprint ("     unks1: " ^ (pr unk_hps)) no_pos in *)
  (* let _ = Debug.ninfo_pprint ("     unks2: " ^ (pr cs.CF.unk_hps)) no_pos in *)
  (* let _ = Debug.ninfo_pprint ("     undef: " ^ (pr undef)) no_pos in *)
  (* (\*end for debugging*\) *)
  let new_defs1,rem_cs1=
    match undef with
      | [] -> [],[]
      | [(hp,args)] ->
          let keep_unk_hps = List.concat (List.map (SAU.get_intersect_unk_hps args) unk_hps) in
          let lhs = SAU.keep_data_view_hrel_nodes prog cs.CF.hprel_lhs (lhns@rhns) (lhvs@rhvs) args (keep_unk_hps@[hp]) in
          let rhs = SAU.keep_data_view_hrel_nodes prog cs.CF.hprel_rhs (lhns@rhns) (lhvs@rhvs) args (keep_unk_hps@[hp]) in
          let ltest = SAU.is_empty_f lhs in
          let rtest = SAU.is_empty_f rhs in
          if ltest && rtest then [], [cs]
          else
            let def_body =
              if List.exists (fun (hp1,_) -> CP.eq_spec_var hp hp1) lhp_args then
                begin
                    if rtest then [] else [rhs]
                end
              else if List.exists (fun (hp1,_) -> CP.eq_spec_var hp hp1) rhp_args then
                begin
                    if ltest then [] else [lhs]
                end
              else []
            in
            (match def_body with
              | [] -> [], [cs]
              | [f] ->
                   begin
                      DD.ninfo_pprint ">>>>>> from assumption to def: <<<<<<" no_pos;
                      DD.ninfo_pprint ((!CP.print_sv hp)^"(" ^(!CP.print_svl args) ^ ")=" ^
                                             (Cprinter.prtt_string_of_formula f) ) no_pos;
                      ([(CP.HPRelDefn hp, CF.HRel (hp, List.map (fun x -> CP.mkVar x no_pos) args, no_pos), f) ],[])
                   end
              | _ -> report_error no_pos "sa.get_unk_hps_relation"
            )
      | _ -> [],[cs]
  in
  (*should lunk_hps ---> runk_hps *)
  let lunk_hps, _ = List.partition (fun (hp,_) -> CP.mem_svl hp cs_unk_hps) lhp_args in
  let runk_hps, _ = List.partition (fun (hp,_) -> CP.mem_svl hp cs_unk_hps) rhp_args in
  (* (\*for debugging*\) *)
  (* let pr = pr_list_ln (pr_pair !CP.print_sv !CP.print_svl) in *)
  (* let _ = Debug.ninfo_pprint ("     l unk_hps: " ^ (pr lunk_hps)) no_pos in *)
  (* let _ = Debug.ninfo_pprint ("     r unk hps: " ^ (pr runk_hps)) no_pos in *)
  (* (\*end for debugging*\) *)
  (*local helper*)
  let generate_unkhps_relation (hp1,args1) (hp2,args2) =
          (* let _ = Debug.ninfo_pprint ("     unks: " ^ (!CP.print_svl [hp1;hp2])) no_pos in *)
    if CP.eq_spec_var hp1 hp2 then [] else
      begin
          let args = CP.remove_dups_svl (args1@args2) in
          (* let keep_unk_hps = List.concat (List.map (SAU.get_intersect_unk_hps args) unk_hps) in *)
    (* let lhs = SAU.keep_data_view_hrel_nodes prog cs.CF.hprel_lhs (lhns@rhns) (lhvs@rhvs) args (keep_unk_hps@[hp1;hp2]) in *)
          let rhs = SAU.keep_data_view_hrel_nodes prog cs.CF.hprel_rhs (lhns@rhns) (lhvs@rhvs) args ([hp1;hp2]) in
          (* let _ = Debug.ninfo_pprint ("      rhs: " ^ (Cprinter.prtt_string_of_formula rhs)) no_pos in *)
          if (* SAU.is_empty_f lhs && *) SAU.is_empty_f rhs then []
          else
            begin
                DD.ninfo_pprint ((!CP.print_sv hp1)^"(" ^(!CP.print_svl args) ^ ")=" ^
                                       (Cprinter.prtt_string_of_formula rhs) ) no_pos;
                [(CP.HPRelDefn hp1, CF.HRel (hp1, List.map (fun x -> CP.mkVar x no_pos) args1, no_pos), rhs) ]
            end
      end
  in
  let new_defs2,rem_cs2=
    if lunk_hps = [] || runk_hps = [] then ([],[cs])
    else
      let _ = DD.ninfo_pprint ">>>>>> unk hps equivalent: <<<<<<" no_pos in
      let rels = List.concat (List.map
             (fun lhp -> List.concat (List.map
                     (fun rhp -> generate_unkhps_relation lhp rhp) runk_hps)) lunk_hps) in
      (rels,[])
  in
  let cs3=
    if (rem_cs1@rem_cs2) = [] then []
    else [(List.hd (rem_cs1@rem_cs2))]
  in
  (cs3, new_defs1@new_defs2)

let get_unk_hps_relation prog hpdefs cs=
  let pr1 = Cprinter.string_of_hprel in
  let pr3 = pr_list Cprinter.string_of_hp_rel_def in
  Debug.no_2 "get_unk_hps_relation" pr1 pr3 (pr_pair (pr_list_ln pr1) pr3)
      (fun _ _ -> get_unk_hps_relation_x prog hpdefs cs) cs hpdefs


let generalize_hps_x prog unk_hps cs par_defs=
  DD.ninfo_pprint ">>>>>> step 6: generalization <<<<<<" no_pos;
(*general par_defs*)
  let pair_names_defs = generalize_hps_par_def prog unk_hps par_defs in
  let hp_names,hp_defs = List.split pair_names_defs in
(*for each constraints, we may pick more definitions*)
  (* let cs1 = List.map (drop_unk_hps unk_hps) cs in *)
  let remain_constr, hp_def1 = generalize_hps_cs hp_names cs in
  let remain_constr0,hp_def2 = List.split (List.map (get_unk_hps_relation prog (hp_defs@hp_def1)) remain_constr) in
(List.concat remain_constr0, (hp_defs@hp_def1)@(List.concat hp_def2))

let generalize_hps prog unk_hps cs par_defs=
  let pr1 = pr_list_ln Cprinter.string_of_hprel in
  let pr2 = pr_list_ln string_of_par_def_w_name in
  let pr3 = pr_list Cprinter.string_of_hp_rel_def in
  Debug.no_2 "generalize_hp" pr1 pr2 (pr_pair pr1 pr3)
      (fun _ _ -> generalize_hps_x prog unk_hps cs par_defs) cs par_defs

(*========END generalization==========*)
(*===========fix point==============*)
let infer_hps_fix prog (constrs: CF.hprel list) =
  let rec helper_x (constrs: CF.hprel list) par_defs =
    DD.ninfo_pprint ">>>>>> step 3: simplification <<<<<<" no_pos;
    let constrs1 = simplify_constrs prog constrs in
     Debug.ninfo_hprint (add_str "constr each LOOP: " (pr_list_ln Cprinter.string_of_hprel)) constrs1 no_pos;
  (*step 3: pick partial definition*)
    DD.ninfo_pprint ">>>>>> step 4: pick partial definitions <<<<<<" no_pos;
    let constrs2, new_par_defs = collect_partial_definitions prog constrs1 in
    (*remove duplicate*)
    let new_par_defs = Gen.BList.remove_dups_eq check_partial_def_eq new_par_defs in
    let par_defs_diff = Gen.BList.difference_eq
      check_partial_def_eq new_par_defs par_defs in
    if par_defs_diff = [] then
 (*teminating condition*)
      (constrs2, par_defs)
    else
      begin
          (*step 4: pick complete def*)
          let constrs3 = constrs2 in
          DD.ninfo_pprint ">>>>>> step 5: subst new partial def into constrs <<<<<<" no_pos;
          (*step 5: subst new partial def into constrs*)
          let constrs4 = subst_cs constrs3 (par_defs@par_defs_diff) in
          (*for debugging*)
          let helper (constrs: CF.hprel list) par_defs =
            let pr = pr_list_ln string_of_par_def_w_name in
            Debug.no_1 "infer_hps_fix" pr (fun (_,pdefs) -> pr pdefs)
                (fun _ -> helper_x constrs par_defs) par_defs
          in
          (*END for debugging*)
          let norm_constrs, par_defs = helper constrs4 (par_defs@par_defs_diff) in
          ((* simplify_constrs prog *) norm_constrs,  par_defs)
      end
  in
  helper_x constrs []

let generate_hp_def_from_split hp_defs_split hpdefs unk_hpargs=
  let generate_hp_sef hp args f pos=
    (CP.HPRelDefn hp, CF.HRel (hp, List.map (fun x -> CP.mkVar x pos) args, pos), f)
  in
  let rec look_up_hp_def ss hp hpdefs=
    match hpdefs with
      | [] -> []
      | (CP.HPRelDefn hp1,_,f)::defss -> if CP.eq_spec_var hp1 hp then
            let nf = CF.subst ss f in
            CF.list_of_disjs nf
          else look_up_hp_def ss hp defss
  in
  let rec combine_def lls pos res=
    match lls with
      | [] -> res
      | fs::ss ->
          (*mkAnd each f1 of fs with each f2 of res*)
          let f_cmbs = List.concat (List.map (fun f1 -> List.map (fun f2 -> CF.mkStar f1 f2 CF.Flow_combine pos) res) fs) in
          combine_def ss pos f_cmbs
  in
  let unk_hps = List.map (fun (hp,_) -> hp) unk_hpargs in
  let generate_def ((hp0,args0), hp_args)=
    (*compute ss =combine args0 concat (args)*)
    let all_args = List.fold_left (fun args1 (_,args2)-> args1@args2) (snd (List.hd hp_args)) (List.tl hp_args) in
    let ss = List.combine all_args args0 in
    (*process hp_args*)
    (*remove unks*)
    let hp_args1 = List.filter (fun (hp1,_) -> not(CP.mem_svl hp1 unk_hps)) hp_args in
    (*create subst for hprel names also*)
    (*let ss1 = List.map (fun (hp, _) -> (hp,hp0)) hp_args1 in *)
    (*let ss = ss@ss1 in *)
    match hp_args1 with
      | [] ->
          (*create unk def*)
          generate_hp_sef hp0 args0 (CF.formula_of_heap CF.HTrue no_pos) no_pos
      | [(hp1, args1)] ->
          (*look up hp1 def*)
          let fs = look_up_hp_def ss hp1 hpdefs in
          let hprel0 = SAU.mkHRel hp0 args0 no_pos in
          let hprel1 = SAU.mkHRel hp1 args1 no_pos in
          let fs1 = List.map (fun f -> CF.subst_hrel_f f [(hprel1,hprel0)]) fs in
          generate_hp_sef hp0 args0 (CF.disj_of_list fs1 no_pos) no_pos
      | _ -> (*currently split is omitted, this case can't happen*)
         (*look up defs*)
          let fss = List.map (fun (hp1, _) ->look_up_hp_def ss hp1 hpdefs) hp_args1  in
          let nfs = combine_def fss no_pos [] in
    (*if length = 1, return else cmb*)
          generate_hp_sef hp0 args0 (CF.disj_of_list nfs no_pos) no_pos
  in
  let helper ((hp0,args0), hp_args)=
    let pr1 (hp, args)= (!CP.print_sv hp) ^ (!CP.print_svl args) in
    let pr2 = pr_list pr1 in
    let _ = DD.ninfo_pprint ((pr1 (hp0,args0)) ^ ":::" ^ (pr2 hp_args)) no_pos in
    ()
  in
   let helper2 hpdefs =
    let pr1 =  pr_list_ln Cprinter.string_of_hp_rel_def in
    let _ = DD.ninfo_pprint (pr1 hpdefs) no_pos in
    ()
  in
  let _ = DD.ninfo_pprint ">>>>>> equivalent hps: <<<<<<" no_pos in
  let _ = List.map helper hp_defs_split in
  let new_hpdefs = List.map generate_def hp_defs_split in
  let _ = helper2 new_hpdefs in
  new_hpdefs


let generate_hp_def_from_unk_hps unk_hps=
  let helper (hp_name, args)=
    let h_def = CF.HTrue in
    DD.ninfo_pprint ((!CP.print_sv hp_name)^"(" ^
        (!CP.print_svl args) ^ ")=" ^
        (Cprinter.prtt_string_of_formula (CF.formula_of_heap h_def no_pos))) no_pos;
    (CP.HPRelDefn hp_name,
     (CF.HRel (hp_name, List.map (fun x -> CP.mkVar x no_pos) args,no_pos)),
     CF.formula_of_heap h_def no_pos)
  in
   DD.ninfo_pprint ">>>>>> unknown hps: <<<<<<" no_pos;
  List.map helper unk_hps

(*========= matching=========*)
let match_one_hp_one_view_x hp hp_name args def_fs (vdcl: CA.view_decl): bool=
  let v_fl,_ = List.split vdcl.CA.view_un_struc_formula in
  if (List.length def_fs) = (List.length v_fl) then
  (*get root*)
    let (CP.SpecVar (t,_,_)) = List.hd args in
    (*assume self is always unprimed*)
    let ss = List.combine (args) ([CP.SpecVar (t,self,Unprimed)]@vdcl.CA.view_vars) in
    let def_fs1 = List.map (CF.subst ss) def_fs in
    let v_fl1 =
      if vdcl.CA.view_is_rec then
        List.map (SAU.subst_view_hp_formula vdcl.CA.view_name hp) v_fl
      else v_fl
    in
    let v_fl2 = List.map CF.elim_exists v_fl1 in
     (*for debugging*)
    (* let pr = pr_list_ln Cprinter.prtt_string_of_formula in *)
    (* let _ = Debug.ninfo_pprint ("     def_fs: " ^ (pr def_fs)) no_pos in *)
    (* let _ = Debug.ninfo_pprint ("     def_fs1: " ^ (pr def_fs1)) no_pos in *)
    (* let _ = Debug.ninfo_pprint ("     v_fl1: " ^ (pr v_fl1)) no_pos in *)
    (*END for debugging*)
    SAU.checkeq_formula_list def_fs1 v_fl2
  else
    false

let match_one_hp_one_view hp hp_name args def_fs (vdcl: CA.view_decl):bool=
  let pr1 = pr_list_ln Cprinter.prtt_string_of_formula in
  let pr2 = Cprinter.string_of_view_decl in
  Debug.no_2 "match_one_hp_one_view" pr1 pr2 string_of_bool
      (fun _ _ -> match_one_hp_one_view_x hp hp_name args def_fs vdcl) def_fs vdcl

let match_one_hp_views (vdcls: CA.view_decl list) (_, hf, orf):(CP.spec_var* CF.h_formula list)=
  match hf with
    | CF.HRel (hp, eargs, p) ->
        let def_fl = CF.list_of_disjs orf in
        let args = List.concat (List.map CP.afv eargs) in
        let helper vdcl=
          if (List.length args) = ((List.length vdcl.CA.view_vars) + 1) then
            if (match_one_hp_one_view (hp, eargs, p) hp args def_fl vdcl) then
              let vnode = CF.mkViewNode (List.hd args) vdcl.CA.view_name
                (List.tl args) no_pos in
              [vnode]
            else []
          else []
        in
        let eq_views = List.concat (List.map helper vdcls) in
        (hp,eq_views)
    | _ -> report_error no_pos "sa. match_one_hp_views: should be a hp"

let match_hps_views_x (hp_defs:hp_rel_def list) (vdcls: CA.view_decl list):
(CP.spec_var* CF.h_formula list) list=
  let m = List.map (match_one_hp_views vdcls) hp_defs in
    (List.filter (fun (_,l) -> l<>[]) m)

let match_hps_views (hp_defs:hp_rel_def list) (vdcls: CA.view_decl list):
(CP.spec_var* CF.h_formula list) list=
  let pr1 = pr_list_ln Cprinter.string_of_hp_rel_def in
  let pr2 = pr_list_ln  Cprinter.prtt_string_of_h_formula  in
  let pr3a = fun (hp,vns) -> (!CP.print_sv hp) ^ " === " ^
      (* ( String.concat " OR " view_names) *) (pr2 vns) in
  let pr3 = pr_list_ln pr3a in
  Debug.no_1 "match_hps_views" pr1 pr3
      (fun _ -> match_hps_views_x hp_defs vdcls) hp_defs

(*END matching*)

let collect_sel_hp_def_x defs sel_hps unk_hps m=
  (*currently, use the first lib matched*)
  let m = List.map (fun (hp, l) -> (hp, List.hd l)) m in
  let mlib = List.map (fun (hp, _) -> hp) m in
  let rec look_up_lib hp ms=
    match ms with
      | [] -> None
      | (hp1,hf1)::ss -> if CP.eq_spec_var hp hp1 then
            Some (CF.formula_of_heap hf1 no_pos)
          else look_up_lib hp ss
  in
  let mk_hprel_def kind hprel f flib=
    {
        CF.hprel_def_kind = kind;
        CF.hprel_def_hrel = hprel;
        CF.hprel_def_body = f;
        CF.hprel_def_body_lib = flib;
    }
  in
  let compute_def_w_lib (hp,(a,hprel,f))=
    let olib = look_up_lib hp m in
    let f1 =
      match olib with
        | None ->
            (*subs lib form inside f if applicable*)
            let f_subst = CF.subst_hrel_hview_f f m in
            f_subst
        | Some lib_f -> lib_f
    in
    (mk_hprel_def a hprel f f1)
  in
  let look_up_depend cur_hp_sel f=
    let hps = CF.get_hp_rel_name_formula f in
    let dep_hp = Gen.BList.difference_eq CP.eq_spec_var hps (cur_hp_sel(* @unk_hps *)) in
    (CP.remove_dups_svl dep_hp)
  in
  let look_up_hp_def new_sel_hps non_sel_hp_def=
    List.partition (fun (hp,_) -> CP.mem_svl hp new_sel_hps) non_sel_hp_def
  in
  let rec find_closed_sel cur_sel cur_sel_hpdef non_sel_hp_def incr=
    let rec helper1 ls res=
      match ls with
        | [] -> res
        | (hp,(a,hf,f))::lss ->
            let incr =
              if CP.mem_svl hp (cur_sel(* @unk_hps *)) then
                []
              else
                [hp]
            in
            let new_hp_dep = look_up_depend cur_sel f in
            helper1 lss (CP.remove_dups_svl (res@incr@new_hp_dep))
    in
    let incr_sel_hps = helper1 incr [] in
    (*nothing new*)
    if incr_sel_hps = [] then cur_sel_hpdef else
      let incr_sel_hp_def,remain_hp_defs = look_up_hp_def incr_sel_hps non_sel_hp_def in
      find_closed_sel (cur_sel@incr_sel_hps) (cur_sel_hpdef@incr_sel_hp_def) remain_hp_defs incr_sel_hp_def
  in
  let defsw = List.map (fun (a,hf,f) ->
      (List.hd (CF.get_hp_rel_name_h_formula hf), (a,hf,f))) defs in
  let sel_defw,remain_hp_defs = List.partition (fun (hp,_) -> CP.mem_svl hp sel_hps) defsw in
  (* let sel_defw1 = Gen.BList.remove_dups_eq (fun (hp1,_) (hp2,_) -> CP.eq_spec_var hp1 hp2) sel_defw in *)
  let closed_sel_defw = find_closed_sel sel_hps sel_defw remain_hp_defs sel_defw in
  let all_sel_defw = List.map compute_def_w_lib closed_sel_defw in
  (*remove hp not in orig but == lib*)
  let inter_lib = Gen.BList.difference_eq CP.eq_spec_var mlib sel_hps in
  List.filter (fun hdef ->
      let (CP.HPRelDefn hp) = hdef.CF.hprel_def_kind in not (CP.mem_svl hp inter_lib))
      all_sel_defw

let collect_sel_hp_def defs sel_hps unk_hps m=
  let pr1 = pr_list_ln Cprinter.string_of_hp_rel_def in
  let pr2 = !CP.print_svl in
  let pr3b = pr_list_ln Cprinter.prtt_string_of_h_formula in
  let pr3a = fun (hp,vns) -> (!CP.print_sv hp) ^ " === " ^
      (* ( String.concat " OR " view_names) *) (pr3b vns) in
  let pr3 = pr_list_ln pr3a in
  let pr4 = (pr_list_ln Cprinter.string_of_hprel_def) in
  Debug.no_3 "collect_sel_hp_def" pr1 pr2 pr3 pr4
      (fun _ _ _ -> collect_sel_hp_def_x defs sel_hps unk_hps m) defs sel_hps m
(*
  input: constrs: (formula * formula) list
  output: definitions: (formula * formula) list
*)
let infer_hps_x prog (hp_constrs: CF.hprel list) sel_hp_rels:(CF.hprel list * hp_rel_def list) =
  DD.ninfo_pprint "\n\n>>>>>> norm_hp_rel <<<<<<" no_pos;
  DD.ninfo_pprint ">>>>>> step 1a: drop arguments<<<<<<" no_pos;
  (* step 1: drop irr parameters *)
  let constrs = elim_redundant_paras_lst_constr prog hp_constrs in
  Debug.ninfo_hprint (add_str "   AFTER DROP: " (pr_list_ln Cprinter.string_of_hprel)) constrs no_pos;
  DD.ninfo_pprint ">>>>>> step 1b: find unknown ptrs<<<<<<" no_pos;
  let constrs1,unk_hps,hp_defs_split = analize_unk prog constrs in
   (* step 1': split HP *)
  DD.ninfo_pprint ">>>>>> step 2: split arguments: currently omitted <<<<<<" no_pos;
  (* let constrs1, split_tb,hp_defs_split = split_hp constrs in *)
  (*for temporal*)
  let constrs2 = constrs1 in
  (* let hp_defs_split = [] in *)
  (*END for temporal*)
  let cs, par_defs = infer_hps_fix prog constrs2 in
  (*step 6: over-approximate to generate hp def*)
  let constr3, hp_defs = generalize_hps prog unk_hps cs par_defs in
  let unk_hp_def = generate_hp_def_from_unk_hps unk_hps in
   (*now just print it*)
  let hp_def_from_split = generate_hp_def_from_split hp_defs_split hp_defs unk_hps in
  DD.ninfo_pprint (" remains: " ^
     (let pr1 = pr_list_ln Cprinter.string_of_hprel in pr1 constr3) ) no_pos;
  let hp_defs1 =  (Gen.BList.remove_dups_eq (fun (CP.HPRelDefn hp1,_,_) (CP.HPRelDefn hp2,_,_) -> CP.eq_spec_var hp1 hp2) (hp_defs@hp_def_from_split)) in
   DD.ninfo_pprint ">>>>>> step 7: mathching with predefined predicates <<<<<<" no_pos;
  let unk_hp_svl = (List.map (fun (hp,_) -> hp) unk_hps) in
  let hp_defs2 = (def_subst_fix unk_hp_svl hp_defs1) in
  let hp_defs3 = hp_defs2 @ unk_hp_def in
  let m = match_hps_views hp_defs3 prog.CA.prog_view_decls in
  let _ = DD.ninfo_pprint ("        sel_hp_rel:" ^ (!CP.print_svl sel_hp_rels)) no_pos in
  (* let _ =  DD.info_pprint (" matching: " ^ *)
  (*   (let pr = pr_list_ln (fun (hp,view_names) -> (!CP.print_sv hp) ^ " === " ^ *)
  (*     ( String.concat " OR " view_names)) in pr m)) no_pos in *)
  let sel_hp_defs = collect_sel_hp_def hp_defs3 sel_hp_rels unk_hp_svl m in
  let _ = List.iter (fun hp_def -> rel_def_stk # push hp_def) sel_hp_defs in
  (constr3, hp_defs3)
  (* loop 1 *)
  (*simplify constrs*)
  (* let constrs12 = simplify_constrs constrs1 in *)
  (* (\*step 3: pick partial definition*\) *)
  (* let constrs13, par_defs1 = collect_partial_definitions prog constrs12 in *)
  (* (\*step 4: pick complete def*\) *)
  (* (\*step 5: subst new partial def into constrs*\) *)
  (* let constrs14 = subst_cs constrs13 par_defs1 in *)
  (* (\*loop 2*\) *)
  (* (\*simplify constrs*\) *)
  (* let constrs22 = simplify_constrs constrs14 in *)
  (* (\*step 3: pick partial definition*\) *)
  (* let constrs23, par_defs2 = collect_partial_definitions prog constrs22 in *)
  (* let par_defs_diff = Gen.BList.difference_eq check_partial_def_eq par_defs2 par_defs1 in *)

(*(pr_pair Cprinter.prtt_string_of_formula Cprinter.prtt_string_of_formula)*)
let infer_hps prog (hp_constrs: CF.hprel list) sel_hp_rels:
 (CF.hprel list * hp_rel_def list) =
  let pr1 = pr_list_ln Cprinter.string_of_hprel in
  let pr2 = pr_list_ln Cprinter.string_of_hp_rel_def in
  Debug.no_1 "infer_hp" pr1 (pr_pair pr1 pr2)
      (fun _ -> infer_hps_x prog hp_constrs sel_hp_rels) hp_constrs
