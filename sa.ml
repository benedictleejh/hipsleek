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

let rel_def_stk : CF.hprel_def Gen.stack_pr = new Gen.stack_pr
  Cprinter.string_of_hprel_def_lib (==)

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
  let new_constrs,ms = drop_process constrs drop_hp_args in
  (*find candidates in all assumes, if a case appears in all assmses => apply it*)
  (ms,new_constrs)

and elim_redundant_paras_lst_constr prog hp_constrs =
  let pr0 = pr_list !CP.print_exp in
  let pr = pr_list_ln Cprinter.string_of_hprel in
  let pr1 = pr_list (pr_triple !CP.print_sv pr0 pr0) in
  Debug.no_1 "elim_redundant_paras_lst_constr" pr (pr_pair pr1 pr)
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
  let def_vs_wo_args, _, _, hrs, _,eqNulls = SAU.find_defined_pointers_raw prog f in
  let def_vsl_wo_args = def_vs_wo_args@eqNulls in
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


and drop_process (constrs: CF.hprel list) (drlocs: (CP.spec_var* int list) list):
      ( CF.hprel list* (CP.spec_var*CP.exp list*CP.exp list) list) =
  let new_constrs, m = List.split(List.map (fun c -> drop_process_one_constr c drlocs) constrs) in
  (new_constrs, Gen.BList.remove_dups_eq (fun (hp1,_,_) (hp2,_,_) -> CP.eq_spec_var hp1 hp2) (List.concat m))

and drop_process_one_constr (constr: CF.hprel) drlocs: CF.hprel * ((CP.spec_var*CP.exp list*CP.exp list) list) =
  let nlhs,m1 = filter_hp_rel_args_f constr.CF.hprel_lhs drlocs in
  let nrhs,m2 = (filter_hp_rel_args_f constr.CF.hprel_rhs drlocs) in
  let m = Gen.BList.remove_dups_eq (fun (hp1,_,_) (hp2,_,_) -> CP.eq_spec_var hp1 hp2) (m1@m2) in
  ({constr with
      CF.hprel_lhs = nlhs;
      CF.hprel_rhs = nrhs},m)


and filter_hp_rel_args_f (f: CF.formula) (drlocs: (CP.spec_var* int list) list)=
  (* let rels, _ = List.split drlocs in *)
  let rec helper f drlocs = match f with
    | CF.Base fb -> let nh,m= filter_hp_rel_args fb.CF.formula_base_heap drlocs in
                      (CF.Base {fb with CF.formula_base_heap = nh;}),m
    | CF.Or orf ->
        let n_orf1,m1 = helper orf.CF.formula_or_f1 drlocs in
        let n_orf2,m2 = helper orf.CF.formula_or_f2 drlocs in
        (CF.Or {orf with CF.formula_or_f1 = n_orf1;
                CF.formula_or_f2 = n_orf2;}),m1@m2
    | CF.Exists fe ->
        let nh,m=filter_hp_rel_args fe.CF.formula_exists_heap drlocs  in
        (CF.Exists {fe with CF.formula_exists_heap =  nh;}),m
  in 
  helper f drlocs

and filter_hp_rel_args (hf: CF.h_formula) (drlocs: (CP.spec_var* int list) list): CF.h_formula *
 ((CP.spec_var*CP.exp list*CP.exp list) list)=
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
          let n_hf1,m1 = helper hf1 in
          let n_hf2,m2 = helper hf2 in
          let hf1=
            (match n_hf1,n_hf2 with
              | (CF.HEmp,CF.HEmp) -> CF.HEmp
              | (CF.HEmp,_) -> n_hf2
              | (_,CF.HEmp) -> n_hf1
              | _ -> CF.Star {CF.h_formula_star_h1 = n_hf1;
			                  CF.h_formula_star_h2 = n_hf2;
			                  CF.h_formula_star_pos = pos}
            )
          in hf1,m1@m2
      | CF.Conj { CF.h_formula_conj_h1 = hf1;
		          CF.h_formula_conj_h2 = hf2;
		          CF.h_formula_conj_pos = pos} ->
          let n_hf1,m1 = helper hf1 in
          let n_hf2,m2 = helper hf2 in
          let hf1 = CF.Conj { CF.h_formula_conj_h1 = n_hf1;
		                      CF.h_formula_conj_h2 = n_hf2;
		                      CF.h_formula_conj_pos = pos}
          in hf1,m1@m2
      | CF.Phase { CF.h_formula_phase_rd = hf1;
		           CF.h_formula_phase_rw = hf2;
		           CF.h_formula_phase_pos = pos} ->
          let n_hf1,m1 = helper hf1 in
          let n_hf2,m2 = helper hf2 in
          (CF.Phase { CF.h_formula_phase_rd = n_hf1;
		             CF.h_formula_phase_rw = n_hf2;
		             CF.h_formula_phase_pos = pos}),m1@m2
      | CF.DataNode hd -> hf0,[]
      | CF.ViewNode hv -> hf0,[]
      | CF.HRel (sv, args, l) ->
	            let locs =  look_up_drop_hp sv drlocs in
                if locs = [] then hf0,[]
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
	                if((List.length new_args) == 0) then CF.HEmp,[(sv,args,[])]
	                else (CF.HRel (sv, new_args, l)),[(sv,args,new_args)]
	              end
      | CF.Hole _
      | CF.HTrue
      | CF.HFalse
      | CF.HEmp -> hf0,[]
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
let get_hp_split_cands_one_cs prog unk_hps lhs rhs=
  let do_partition hns hvs eqs args=
    let rec intersect_with_pre_parts parts svl r_parts r_svl=
      match parts with
        | [] -> (r_parts,r_svl)
        | svl1::tl->
            if CP.intersect_svl (r_svl@svl) svl1 = [] then
              intersect_with_pre_parts tl svl (r_parts@[svl1]) r_svl
            else intersect_with_pre_parts tl svl r_parts (CP.remove_dups_svl (r_svl@svl1))
    in
    let rec part_helper args0 parts=
      match args0 with
        | [] -> parts
        | [a] -> (parts@[[a]])
        | a::tl ->
            let part1 = SAU.find_close [a] eqs in
            let part2 = SAU.loop_up_closed_ptr_args prog hns hvs (CP.remove_dups_svl part1) in
            let part2a = (SAU.find_close part2 eqs) in
            let new_parts,part2b = intersect_with_pre_parts parts part2a [] [] in
            let part3 = CP.remove_dups_svl (a::(CP.intersect_svl part2a tl)) in
            part_helper (CP.diff_svl tl part3) (new_parts@[part2b@part3])
    in
    let parts = part_helper args [] in
    (*if all args is partitioned in one group, do not split*)
    match parts with
      | [args0] -> if List.length args0 = List.length args then []
          else parts
      | _ -> parts
  in
  let lhns, lhvs, lhrs = CF.get_hp_rel_formula lhs in
  let rhns, rhvs, rhrs = CF.get_hp_rel_formula rhs in
  let ( _,lmix_f,_,_,_) = CF.split_components lhs in
  let leqs = (MCP.ptr_equations_without_null lmix_f) in
  let ( _,rmix_f,_,_,_) = CF.split_components rhs in
  let reqs = (MCP.ptr_equations_without_null rmix_f) in
  let cands = lhrs @ rhrs in
  let cands1 = List.filter (fun (hp,el,l) -> not (CP.mem_svl hp unk_hps) && (List.length el) >= 2) cands in
  let cands2 = List.map (fun (hp,el,l) ->
      let args = List.concat (List.map CP.afv el) in
      let parts = do_partition (lhns@rhns) (lhvs@rhvs) (leqs@reqs) args in
     (hp,args, parts,l)
  ) cands1
  in
  (cands2)

let get_hp_split_cands_x prog constrs=
 List.concat (List.map (fun cs -> get_hp_split_cands_one_cs prog (List.map fst cs.CF.unk_hps)
     cs.CF.hprel_lhs cs.CF.hprel_rhs) constrs)

let get_hp_split_cands prog constrs =
  let pr1 = pr_list_ln Cprinter.string_of_hprel in
  let pr2 = pr_list_ln (pr_quad !CP.print_sv !CP.print_svl (pr_list !CP.print_svl) string_of_full_loc) in
  Debug.no_1 "get_hp_split_cands" pr1 pr2
  (fun _ -> get_hp_split_cands_x prog constrs) constrs

(*split one hp -> mutiple hp and produce corresponding heap formulas for substitution
 - one cand: (hp,args, parts,p)
*)
let check_split_global_x prog cands =
   let rec partition_cands_by_hp_name cands0 parts=
    match cands0 with
      | [] -> parts
      | (hp_name,args, ls_args,p)::xs ->
          let part,remains= List.partition (fun (hp_name1,_,_,_) -> CP.eq_spec_var hp_name1 hp_name) xs in
          partition_cands_by_hp_name remains (parts@[[(hp_name,args,ls_args,p)]@part])
  in
  (*each partition, create new hp and its corresponding HRel formula*)
  let helper1 pos args =
    let hf,new_hp_sv = SAU.add_raw_hp_rel prog args pos in
    ((new_hp_sv,args), hf)
  in
  (*for each grp*)
  let intersect_cand_one_hp grp=
    let rec parts_norm args0 grp0 res=
      match grp0 with
        | [] -> res
        | (_,args1,parts1,_)::tl ->
            let ss = List.combine args1 args0 in
            let parts11 = List.map (fun largs -> List.map (CP.subs_one ss) largs) parts1 in
            parts_norm args0 tl (res@[parts11])
    in
    let rec cmp_two_list_args ls_args1 ls_args2=
      match ls_args1,ls_args2 with
        | [],[] -> true
        | args1::tl1,args2::tl2 ->
            if SAU.eq_spec_var_order_list args1 args2 then
              cmp_two_list_args tl1 tl2
            else false
        | _ -> false
    in
    let (hp,args0,parts0,p0)=
      match grp with
        | [] -> report_error no_pos "sa.intersect_cand_one_hp"
        | hd::_ -> hd
    in
    let size = List.length parts0 in
    if size = 0 || List.exists (fun (_,args1,parts1,_) -> (List.length parts1)!=size) (List.tl grp) then
      []
    else
      let tl_parts = parts_norm args0 (List.tl grp) [] in
      if List.for_all (fun part -> cmp_two_list_args parts0 part) tl_parts then
        [(hp,args0,parts0,p0)]
      else []
  in
  let generate_split (hp,args0,parts0,p0) =
    let hps = List.map (helper1 p0) parts0 in
    let new_hp_args,new_hrel_fs = List.split hps in
    let new_hrels_comb = List.fold_left (fun hf1 hf2 -> CF.mkStarH hf1 hf2 p0) (List.hd new_hrel_fs) (List.tl new_hrel_fs) in
    let hrel0 = SAU.mkHRel hp args0 p0 in
    (hp, args0, new_hp_args, hrel0,new_hrels_comb)
  in
  let grps = partition_cands_by_hp_name cands [] in
  (*each group, the partition should be similar*)
  let to_split = List.concat (List.map intersect_cand_one_hp grps) in
  let res = List.map generate_split to_split in
  res

let check_split_global prog cands =
  let pr1 = pr_list_ln (pr_quad !CP.print_sv !CP.print_svl (pr_list !CP.print_svl) string_of_full_loc) in
  let pr2 = Cprinter.string_of_h_formula in
  let pr4 = pr_list (pr_pair !CP.print_sv !CP.print_svl) in
  let pr3 = pr_list (pr_penta !CP.print_sv !CP.print_svl pr4 pr2 pr2) in
  Debug.no_1 "check_split_global" pr1 pr3
       (fun _ -> check_split_global_x prog cands) cands

let subst_constr_with_new_hps_x hp_constrs hprel_subst=
  let elim_two_first_arg (_,_,_,a4,a5)= (a4,a5) in
  let new_hprel_subst = List.map elim_two_first_arg hprel_subst in
  let helper cs=
    {cs with
        CF.hprel_lhs= CF.subst_hrel_f cs.CF.hprel_lhs new_hprel_subst;
        CF.hprel_rhs= CF.subst_hrel_f cs.CF.hprel_rhs new_hprel_subst;
    }
  in
  List.map helper hp_constrs

let subst_constr_with_new_hps hp_constrs hprel_subst=
  let pr1= pr_list_ln Cprinter.string_of_hprel in
  let pr2 = Cprinter.string_of_h_formula in
  let pr4 = pr_list (pr_pair !CP.print_sv !CP.print_svl) in
  let pr3 = pr_list_ln (pr_penta !CP.print_sv !CP.print_svl pr4 pr2 pr2) in
  Debug.no_2 "subst_constr_with_new_hps" pr1 pr3 pr1
      (fun _ _ -> subst_constr_with_new_hps_x hp_constrs hprel_subst) hp_constrs hprel_subst

(*return new contraints and hp split map *)
let split_hp_x prog (hp_constrs: CF.hprel list): (CF.hprel list *
          (CP.spec_var*CP.spec_var list * (CP.spec_var*CP.spec_var list) list
           * CF.h_formula) list) =
  (*get hp candidates*)
  let split_cands = get_hp_split_cands prog hp_constrs in
  (*split  and get map*)
  let split_map_hprel_subst = check_split_global prog split_cands in
  (*subs old hrel by new hrels*)
  let new_constrs = subst_constr_with_new_hps hp_constrs split_map_hprel_subst in
  (new_constrs,List.map (fun (a1,a2,a3,a4,_) -> (a1,a2,a3,a4)) split_map_hprel_subst)

let split_hp prog hp_constrs:(CF.hprel list *
 (CP.spec_var*CP.spec_var list * (CP.spec_var*CP.spec_var list) list
  *CF.h_formula) list) =
  let pr1 = pr_list_ln Cprinter.string_of_hprel in
  let pr2 = !CP.print_sv in
  let pr3 = Cprinter.string_of_h_formula in
  let pr5 = pr_list (pr_pair !CP.print_sv !CP.print_svl) in
  let pr4 = fun (a1,a2) -> (*ignore a3*)
      let pr = pr_pair pr1 (pr_list (pr_quad pr2 !CP.print_svl pr5 pr3)) in
      pr (a1, a2)
  in
  Debug.no_1 "split_hp" pr1 pr4
      (fun _ -> split_hp_x prog hp_constrs) hp_constrs
(*===========END SPLIT===========*)
(*=============UNKOWN================*)
(*find diff for each hrel*)
(*return unk_hp_locs * full_unk_args_locs*)
let build_hp_unk_locs known_svl unk_hps fn_cmp (hp_name, args)=
   let rec helper args res index all=
    match args with
      | [] -> res
      | a::ass -> if (fn_cmp a all) (* || not(CP.is_node_typ a) *) then
            helper ass res (index+1) all
          else helper ass (res@[index]) (index+1) all
   in
   let rec helper1 args res index=
    match args with
      | [] -> res
      | a::ass -> helper1 ass (res@[index]) (index+1)
  in
  let get_unk_ptr all_ptrs (hp_name, largs)=
    (* if all_ptrs = [] then [(hp_name,[-1])] (\*[] mean dont have any information*\) *)
    (* else *)
      begin
          let res =
            if CP.mem_svl hp_name unk_hps then
              helper1 largs [] 0 (*this is a dangling predicate*)
            else
              helper largs [] 0 all_ptrs
          in
          if res = [] then ([(hp_name,[-1])],[]) (*renturn -1 to indicate that none is allowed to drop*)
          else
            (*check full unk hp*)
            (* let pr1 = pr_list string_of_int in *)
            (* let _ = Debug.info_pprint ("   hp: " ^ (!CP.print_sv hp_name)) no_pos in *)
            (* let _ = Debug.info_pprint ("     res: " ^ (pr1 res)) no_pos in *)
            (* let _ = Debug.info_pprint ("     largs: " ^ (!CP.print_svl largs)) no_pos in *)
            if (List.length res) = (List.length largs) then
              ([(hp_name, res)],[(hp_name, largs,res)])
            else ([(hp_name, res)],[])
      end
  in
  get_unk_ptr known_svl (hp_name, args)

(*analysis unknown information*)
let rec analize_unk_one prog unk_hps constr =
  let _ = Debug.ninfo_pprint ("   hrel: " ^ (Cprinter.string_of_hprel constr)) no_pos in
 (*remove hrel and returns hprel_args*)
  (*lhs*)
  let lhs1,lhrels = SAU.drop_get_hrel constr.CF.hprel_lhs in
  (*rhs*)
  let rhs1,rhrels = SAU.drop_get_hrel constr.CF.hprel_rhs in
(*find fv of lhs + rhs wo hrels*)
  (* let lsvl = SAU.get_raw_defined_w_pure prog lhs1 in *)
  (* let rsvl = SAU.get_raw_defined_w_pure prog rhs1 in *)
  let svl = SAU.get_raw_defined_w_pure prog constr.CF.predef_svl lhs1 rhs1 in
  (*return*)
  let unk_hp_locs,unk_hp_args_locs = List.split (List.map (build_hp_unk_locs (svl) unk_hps CP.mem_svl) (lhrels@rhrels)) in
  (List.concat  unk_hp_locs, List.concat unk_hp_args_locs)


and double_check_unk unk_hp_locs unk_hps cs_hprels=
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
                  ((SAU.retrieve_args_from_locs args locs))
            end
          else retrieve_args_one_hp ss (hp,args)
  in
  let double_check_one_constr unk_hp_locs cs_hprels=
    let unk_hp_names = List.map (fun (hp, _) -> hp) unk_hp_locs in
    let cs_hp_args = Gen.BList.remove_dups_eq SAU.check_hp_arg_eq (cs_hprels) in
    let cs_unk_hps,cs_non_unk_hps = List.partition
      (fun (hp,_) -> CP.mem_svl hp unk_hp_names) cs_hp_args in
      (* definitely non unk*)
    let cs_non_unk_svl = List.concat (List.map (fun (_, args) -> args) cs_non_unk_hps) in
    let cs_non_unk_svl = CP.remove_dups_svl cs_non_unk_svl in
      (*possible unk*)
    let unk_svl_hps = List.concat (List.map (retrieve_args_one_hp unk_hp_locs) cs_unk_hps) in
    let poss_unk_svl_hps = CP.remove_dups_svl unk_svl_hps in
      (*actually unk = poss unk - non-unk*)
    let real_unk_svl_hps = Gen.BList.difference_eq CP.eq_spec_var poss_unk_svl_hps
      cs_non_unk_svl in
    let ls_unk_hps_locs, ls_unk_hps_args_locs = List.split (List.map (build_hp_unk_locs real_unk_svl_hps unk_hps
                                                                          (fun a ls -> not( CP.mem_svl a ls))) (cs_unk_hps))
    in
    (List.concat ls_unk_hps_locs, List.concat ls_unk_hps_args_locs)
  in
  double_check_one_constr unk_hp_locs (cs_hprels)

(*this method has the same structure with elim_redundant_paras_lst_constr_x,
should use higher-order when stab.*)
and analize_unk prog hp_rel_unkmap constrs =
  let rec partition_cands_by_hp_name unks parts=
    match unks with
      | [] -> parts
      | (hp_name,ids)::xs ->
          let part,remains= List.partition (fun (hp_name1,_) -> CP.eq_spec_var hp_name1 hp_name) xs in
          partition_cands_by_hp_name remains (parts@[[(hp_name,ids)]@part])
  in
  let intersect_cand_one_hp ls=
    let hp_names,cands = List.split ls in
    let _ = Debug.ninfo_pprint ("   hprel: " ^ (!CP.print_svl hp_names)) no_pos in
    let _ = Debug.ninfo_pprint ("     cands: " ^ (let pr = pr_list Cprinter.string_of_list_int in pr cands)) no_pos in
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
  let helper (ls_unk_cands,ls_full_unk_cands_w_args)=
    (* let ls_unk_cands,ls_full_unk_cands_w_args = List.split (List.map fn constrs) in *)
    let unk_cands = List.concat ls_unk_cands in
  (*group cands into each hp*)
    let groups = partition_cands_by_hp_name unk_cands [] in
  (*each hp, intersect all candidate unks*)
    let unk_hp_locs1 = List.concat (List.map intersect_cand_one_hp groups) in
    let unk_hp_locs2 = drop_invalid_group unk_hp_locs1 [] in
    let unk_hps = List.map fst unk_hp_locs2 in
    let full_unk_hp_args2_locs = List.filter (fun (hp,_,_) -> CP.mem_svl hp unk_hps )
      (List.concat ls_full_unk_cands_w_args) in
    (Gen.BList.remove_dups_eq (fun (hp1,_) (hp2,_) -> CP.eq_spec_var hp1 hp2) unk_hp_locs2,
     Gen.BList.remove_dups_eq (fun (hp1,_,_) (hp2,_,_) -> CP.eq_spec_var hp1 hp2) full_unk_hp_args2_locs)
  in
  let unk_hps = List.map fst hp_rel_unkmap in
  let ls_unk_cands,ls_full_unk_cands_w_args = List.split (List.map (analize_unk_one prog  unk_hps) constrs) in
  let unk_hp_args01,_ = helper (ls_unk_cands,ls_full_unk_cands_w_args) in
  (*for debugging*)
  let _ = Debug.ninfo_pprint ("  unks 1: " ^ (let pr = pr_list (pr_pair !CP.print_sv (pr_list string_of_int))
                                             in pr unk_hp_args01)) no_pos
  in
  (*END for debugging*)
  (*double check across one cs*)
  let ls_cs_hprels = List.map (fun cs -> (CF.get_HRels_f cs.CF.hprel_lhs)@(CF.get_HRels_f cs.CF.hprel_rhs)) constrs in
  let rec loop_helper unk_hp_locs0=
    let ls_unk_cands,ls_full_unk_cands_w_args = List.split (List.map (double_check_unk unk_hp_locs0 unk_hps) ls_cs_hprels) in
    let unk_hp_args02,full_unk_hp_args2_locs = helper (ls_unk_cands,ls_full_unk_cands_w_args) in
    let ls_unk_cands1 = Gen.BList.remove_dups_eq SAU.check_hp_locs_eq unk_hp_args02 in
    let _ = Debug.ninfo_pprint ("  ls_unk_cands1: " ^ (let pr = pr_list (pr_pair !CP.print_sv (pr_list string_of_int))
                                             in pr ls_unk_cands1)) no_pos
    in
    if ls_unk_cands1 = [] then [],[] else
      let diff = Gen.BList.difference_eq SAU.check_hp_locs_eq unk_hp_locs0 ls_unk_cands1 in
      if diff =[] then (ls_unk_cands1, full_unk_hp_args2_locs) else
        loop_helper ls_unk_cands1
  in
  let unk_hp_args02,full_unk_hp_args2_locs = loop_helper unk_hp_args01 in
   (* let ls_unk_cands,ls_full_unk_cands_w_args = List.split (List.map (double_check_unk unk_hp_args01) constrs) in *)
   (* let ls_unk_cands,ls_full_unk_cands_w_args = double_check_unk_all unk_hp_args01 constrs in *)
   (* let unk_hp_args02,full_unk_hp_args2_locs = helper (ls_unk_cands,ls_full_unk_cands_w_args) in *)
   (*********END double check ****************)
   let full_unk_hp_args2_locs = SAU.refine_full_unk unk_hp_args02 full_unk_hp_args2_locs in
   (*generate equivs mapping for all full unk hps*)
   let gen_equivs_from_full_unk_hps (hp,args,locs)=
     ((hp,locs), [(hp, args)])
   in
   let equivs0 = List.map gen_equivs_from_full_unk_hps full_unk_hp_args2_locs in
  (*for debugging*)
   let _ = Debug.ninfo_pprint ("  unks 2: " ^ (let pr = pr_list (pr_pair !CP.print_sv (pr_list string_of_int))
                                              in pr unk_hp_args02)) no_pos
   in
   (* let pr1 =  pr_list_ln (pr_pair (pr_pair !CP.print_sv (pr_list string_of_int)) *)
   (*                            (pr_list (pr_pair !CP.print_sv !CP.print_svl))) in *)
   (* let _ = Debug.info_pprint ("  equivs0: " ^ (pr1 equivs0) ) no_pos in *)
  (*END for debugging*)
  (*END double check*)
   let rec update_helper cs cur_full_unk_hps res_cs res_unk_hps res_equivs=
     match cs with
       | [] ->  (res_cs, res_unk_hps, res_equivs)
       | c::ss ->
           let new_c, new_unk_hps,new_full_unk_hps, new_equivs= update_unk_one_constr prog unk_hp_args02
             cur_full_unk_hps res_equivs c in
           update_helper ss new_full_unk_hps (res_cs@[new_c]) (res_unk_hps@new_unk_hps) new_equivs
   in
  (* let cs_unk_hps = List.map (update_unk_one_constr prog unk_hp_args02) constrs in *)
  (* let new_cs, unk_hps,equivs = split3 cs_unk_hps in *)
  (* (new_cs, Gen.BList.remove_dups_eq SAU.check_simp_hp_eq (List.concat unk_hps), *)
  (* List.concat equivs) *)
   let new_cs, unk_hps,equivs = update_helper constrs
     (List.map (fun (hp,_,_) -> hp ) full_unk_hp_args2_locs) [] [] equivs0
   in
   (new_cs, SAU.elim_eq_shorter_hpargs unk_hps, equivs)

and update_unk_one_constr_x prog unk_hp_locs cur_full_unk_hps equivs0 constr=
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
                  ((SAU.retrieve_args_from_locs args locs))
            end
          else retrieve_args_one_hp ss (hp,args)
  in
  let look_up_equiv_x (hp,lunk_args, allargs) equivs=
    let _ = DD.ninfo_pprint ("       look up hp:" ^ (!CP.print_sv hp)) no_pos in
    let rec helper eqs done_svl res=
      match eqs with
        | [] -> res
        | ((hp1,locs1),ls)::eqss ->
            if CP.eq_spec_var hp1 hp then
              (*retrieve unk_args0*)
              let unk_args0 = SAU.retrieve_args_from_locs allargs locs1 in
              if CP.diff_svl unk_args0 done_svl = [] then
                helper eqss done_svl res
              else
                let inter = CP.intersect_svl unk_args0 lunk_args in
                (* let _ = DD.info_pprint ("       inter:" ^ (!CP.print_svl inter)) no_pos in *)
                if inter <> [] then
                  let new_ls =
                    match ls with
                      | [(a,_)] -> [(a,inter,inter)]
                      | _ -> report_error no_pos "sa.look_up_equiv"
                  in
                  let new_done_svl = done_svl@inter in
                  if CP.diff_svl lunk_args new_done_svl = [] then
                    res@[(new_ls,inter)]
                  else helper eqss new_done_svl res@[(new_ls,inter)]
                else
                  helper eqss done_svl res
            else helper eqss done_svl res
    in
    helper equivs [] []
  in
  let look_up_equiv (hp,lunk_args, allargs) equivs=
    let pr1 =  pr_list_ln (pr_pair (pr_pair !CP.print_sv (pr_list string_of_int))
                              (pr_list (pr_pair !CP.print_sv !CP.print_svl))) in
    let pr2 = pr_triple !CP.print_sv !CP.print_svl !CP.print_svl in
    let pr3 = pr_list_ln (pr_pair (pr_list (pr_triple !CP.print_sv !CP.print_svl !CP.print_svl)) !CP.print_svl) in
    Debug.no_2 "look_up_equiv" pr2 pr1 pr3
        (fun _ _ -> look_up_equiv_x (hp,lunk_args, allargs) equivs) (hp,lunk_args, allargs) equivs
  in

  let gen_eqv_x cur_equivs lohp_name lunk_args_locs lunk_svl unk_hp unk_hps=
    let lunk_args,lunk_locs = List.split lunk_args_locs in
    let rec filter_fn keep_svl svl res index=
      match svl with
        | [] -> res
        | sv::ss ->
            if CP.mem_svl sv keep_svl then
              filter_fn keep_svl ss (res@[(sv,index)]) (index+1)
            else filter_fn keep_svl ss res (index+1)
    in
    let rec helper ll res=
      match ll with
        | [] -> res
        | (hp0,args0)::hpss ->
            (*check hp0,lunk_locs is mapped or not*)
             (* let pr1 = (pr_pair !CP.print_sv !CP.print_svl) in *)
             (* let _ = Debug.info_pprint ("  hp0:args0: " ^ (pr1 (hp0,args0))) no_pos in *)
            if (List.exists (fun ((hp1,locs1),_) ->
                (* let pr = (pr_pair !CP.print_sv (pr_list string_of_int)) in *)
                (* let _ = Debug.info_pprint ("  hp1:locs1: " ^ (pr (hp1,locs1))) no_pos in *)
                CP.eq_spec_var hp1 hp0 &&
                    List.length lunk_locs = List.length locs1 &&
                    Gen.BList.difference_eq (=) lunk_locs locs1 = [])
                    cur_equivs) then
              helper hpss res
            else
              let unk_args0, unk_locs0 = List.split (filter_fn lunk_args args0 [] 0) in
              if CP.diff_svl unk_args0 lunk_args = [] &&
                List.length unk_args0 = List.length lunk_args then
                helper hpss (res@[((hp0, unk_locs0), unk_hp)])
              else helper hpss res
    in
    helper unk_hps []
  in
  let gen_eqv cur_equivs lohp_name lunk_args_locs lunk_svl unk_hp unk_hps=
    let pr1 =  pr_list_ln (pr_pair (pr_pair !CP.print_sv (pr_list string_of_int))
                              (pr_list (pr_pair !CP.print_sv !CP.print_svl))) in
    let pr2 = pr_list (pr_pair !CP.print_sv string_of_int) in
    let pr3 = !CP.print_svl in
    let pr4 = pr_list (pr_pair !CP.print_sv !CP.print_svl) in
    Debug.no_6 "gen_eqv" pr1 !CP.print_sv pr2 pr3 pr4 pr4 pr1
        (fun _ _ _ _ _ _ -> gen_eqv_x cur_equivs lohp_name lunk_args_locs lunk_svl unk_hp unk_hps)
        cur_equivs lohp_name lunk_args_locs lunk_svl unk_hp unk_hps
  in
  (*split args into 2 groups: unk_hp and remains*)
  let get_par_unk_hp cs_unk_svl cs_unk_hps cs_full_unk_hps full_unk_hps equivs (hp, args)=
    let _ = DD.ninfo_pprint ("     *******partial hp *********") no_pos in
    let _ = DD.ninfo_pprint ("       partial hp:" ^ (!CP.print_sv hp)) no_pos in
    (* let pr1 = pr_list_ln (pr_pair (pr_pair !CP.print_sv (pr_list string_of_int)) *)
    (*                           (pr_list (pr_pair !CP.print_sv !CP.print_svl))) in *)
    (* let _ = DD.info_pprint ("   equiv:" ^ (pr1 equivs)) no_pos in *)
    (* let _ = DD.info_pprint ("       full unkhps:" ^ (!CP.print_svl full_unk_hps)) no_pos in *)
    (*********LOCAL FUNCTION***********)
    let look_up_unk_svl_one_hp hp args=
      let rec look_up_svl lunk_hp_locs =
      match lunk_hp_locs with
        | [] -> report_error no_pos "sa.look_up_un_svl_one_hp"
        | (hp1,locs1)::ls ->
            if CP.eq_spec_var hp1 hp then
              let args2 = SAU.retrieve_args_from_locs args locs1 in
              List.combine args2 locs1
            else
              look_up_svl ls
      in
      look_up_svl unk_hp_locs
    in
    let rec loop_eqv_hps unk_hps lunk_args cs_unk_svl res=
      match unk_hps with
        | [] -> res
        | (hp0,args0)::hpss ->
            (*skip hp because we thave tried (look-up) it previously*)
            if CP.eq_spec_var hp hp0 then loop_eqv_hps hpss lunk_args cs_unk_svl res
            else
            (*look ip all hps (including itself) have the inter unk svs*)
              let unk_args0 = List.filter (fun sv -> CP.mem_svl sv cs_unk_svl) args0 in
            (* let _ = DD.info_pprint ("       hp0:" ^ (!CP.print_sv hp0)) no_pos in *)
            (* let _ = DD.info_pprint ("       unk_args0:" ^ (!CP.print_svl unk_args0)) no_pos in *)
              let inter = CP.intersect_svl lunk_args unk_args0 in
              if inter <> [] then
                if List.length inter = List.length lunk_args then
                  (res@[(hp0,inter,args0)])
                else
                  loop_eqv_hps hpss lunk_args cs_unk_svl (res@[(hp0,inter,args0)])
              else loop_eqv_hps hpss lunk_args cs_unk_svl res
    in
    let rec look_up_equiv_from_hps ls_hpargs res=
      match ls_hpargs with
        | [] -> res
        | hpargs::hpss ->
            let equivs = look_up_equiv hpargs equivs in
            if equivs = [] then
              look_up_equiv_from_hps hpss res
            else equivs
    in
    (*generate new unk annotation and create corr. equivs*)
    let gen_unk_hp hp_unk_svl_locs=
      let hp_unk_svl = fst (List.split hp_unk_svl_locs) in
      let unk_hf, sunk_hp = SAU.add_raw_hp_rel prog hp_unk_svl no_pos in
      (*generate all matching: hp with similar unk_svl*)
      let new_equivs = gen_eqv equivs hp hp_unk_svl_locs cs_unk_svl [(sunk_hp, hp_unk_svl)] cs_unk_hps in
      (* let pr3 =  pr_list_ln (pr_pair (pr_pair !CP.print_sv (pr_list string_of_int)) *)
      (*                         (pr_list (pr_pair !CP.print_sv !CP.print_svl))) in *)
      (* let _ = Debug.info_pprint ("  gen_unk_h:new_equivs: " ^ (pr3 new_equivs)) no_pos in *)
      ([(sunk_hp, hp_unk_svl)],[unk_hf], new_equivs)
    in
    (*unk has been annotated already, just add it*)
    let process_one_match_eqv (sunk_hp,unk_args1,lunk_args)=
      let _ = DD.ninfo_pprint ("       process_one_match_eqv:" ^
                  (let pr = (pr_pair !CP.print_sv !CP.print_svl) in
                   pr (sunk_hp, lunk_args)))  no_pos
      in
      let unk_hfs =
        (*check whether there exists a local unk hp with the same set of unk svl?*)
        if (CP.mem_svl sunk_hp full_unk_hps) &&
          List.exists (fun (hp1,args,_) ->
              CP.eq_spec_var sunk_hp hp1 ||
              (CP.diff_svl args lunk_args = [] && List.length args = List.length lunk_args)
          ) cs_full_unk_hps
        then
          []
        else
          [SAU.mkHRel sunk_hp lunk_args no_pos]
      in
      ((sunk_hp,unk_args1), unk_hfs)
    in
    let recover_locs hp_unk_svl unk_svl_locs=
      let rec find_loc lsvl_locs sv=
        match lsvl_locs with
          | [] -> report_error no_pos "sa.recover_locs"
          | (sv1,loc1)::ss -> if CP.eq_spec_var sv sv1 then ((sv1,loc1))
              else find_loc ss sv
      in
      List.map (find_loc unk_svl_locs) hp_unk_svl
    in
    (****END LOCAL FUNC*********)
    begin
        let unk_args_locs = look_up_unk_svl_one_hp hp args in
        (* let _ = DD.info_pprint ("       unk_args_locs:" ^ *)
        (*                                (let pr = pr_list (pr_pair !CP.print_sv string_of_int) in *)
        (*                                 pr unk_args_locs)) *)
        (*   no_pos *)
        (* in *)
         (*look up in equiv first*)
        let unk_args,unk_locs = List.split unk_args_locs in
        let eqvs,matched_svls,new_equivs =
          let own_eqvs,own_matched_svls = List.split (look_up_equiv_from_hps
         (*equiv_hpargs*) [(hp, unk_args,args)] []) in
          (*retry with neighbor hp*)
          if own_eqvs = [] then
            let equiv_hpargs = loop_eqv_hps cs_unk_hps unk_args cs_unk_svl [] in
            (* let pr = pr_list_ln (pr_triple !CP.print_sv !CP.print_svl !CP.print_svl) in *)
            (* let _ = DD.info_pprint ("   equiv_hpargs:" ^ (pr equiv_hpargs)) no_pos in *)
            let ls = (look_up_equiv_from_hps equiv_hpargs []) in
            (*generate new mapping*)
            let new_equivs = List.map (fun (m,hp_unk_svl) ->
                let hp_unk_svl_locs = recover_locs hp_unk_svl unk_args_locs in
                (*remove third args in mapping*)
                 let ls =
                    match m with
                      | [(a,b,_)] -> [(a,b)]
                      | _ -> report_error no_pos "sa.look_up_equiv"
                  in
                gen_eqv equivs hp hp_unk_svl_locs cs_unk_svl ls cs_unk_hps) ls
            in
            let ms,matched = List.split ls in
            (ms,matched,List.concat new_equivs)
          else (own_eqvs,own_matched_svls,[])
        in
        (*let pr = pr_list_ln (pr_triple !CP.print_sv !CP.print_svl !CP.print_svl) in *)
        (* let _ = DD.ninfo_pprint ("   equiv_hps:" ^ (pr equiv_hpargs)) no_pos in *)
        (*add new unk hp and eqv mapping*)
        let matched_svl = CP.remove_dups_svl (List.concat matched_svls) in
        (* let _ = DD.info_pprint ("    matched_svl:" ^ (!CP.print_svl matched_svl)) *)
        (*   no_pos in *)
        let rem_unk_args_locs = List.filter(fun (arg,_) -> not(CP.mem_svl arg matched_svl)) unk_args_locs in
        let r11,r12,r13 = if rem_unk_args_locs = [] then [],[],[]
            else gen_unk_hp rem_unk_args_locs
        in
        (*matched eqv*)
        let ls = List.concat eqvs in
        let unk_hpargs,unk_hfss = List.split (List.map (process_one_match_eqv) ls) in
        ((unk_hpargs@r11), (List.concat unk_hfss)@(r12), (equivs@new_equivs@r13))
     end
  in
  let get_full_unk_hps unk_svl (hp, args)=
    (* let _ = DD.info_pprint ("       hp:" ^ (!CP.print_sv hp)) no_pos in *)
    let rec look_up_full_unk unk_hp_locs =
      match unk_hp_locs with
        | [] -> [],[]
        | (hp1,locs1)::ls ->
            if CP.eq_spec_var hp1 hp then
              if (List.length locs1) = (List.length args) then
                ([(hp,args,locs1)],[])
              else
                 ([],[(hp,args)])
            else
              look_up_full_unk ls
    in
    look_up_full_unk unk_hp_locs
  in
  (*===========================*)
  let rec helper1 unk_svl oneside_unk_hps cs_unk_hps cs_full_unk_hps full_unk_hps res_unks res_hfs res_equivs=
    let rec loop_helper unk_svl rem_unk_hps res_unks res_hfs lres_equivs=
      match rem_unk_hps with
        | [] -> (res_unks, res_hfs, lres_equivs)
        | unk_hps::ss ->
            let unks, new_hfs,new_equivs = get_par_unk_hp unk_svl cs_unk_hps
              cs_full_unk_hps full_unk_hps lres_equivs unk_hps
            in
            loop_helper unk_svl ss (res_unks@unks) (res_hfs@new_hfs) new_equivs
    in
    loop_helper unk_svl oneside_unk_hps res_unks res_hfs res_equivs
  in
  (*===========================*)
  let helper lhs rhs equivs unk_hp_names=
    (*lhs*)
    let lhprels = CF.get_HRels_f lhs in
    (*hps have unk slv*)
     let l_cs_unk_hps,l_cs_non_unk_hps = List.partition
    (fun (hp,_) -> CP.mem_svl hp unk_hp_names) lhprels in
  (*unk*)
     let l_unk_svl = List.concat ((List.map (retrieve_args_one_hp unk_hp_locs) l_cs_unk_hps)) in
     let l_unk_svl = CP.remove_dups_svl l_unk_svl in
     (*rhs*)
    let rhprels = CF.get_HRels_f rhs in
    (*hps have unk slv*)
     let r_cs_unk_hps,r_cs_non_unk_hps = List.partition
    (fun (hp,_) -> CP.mem_svl hp unk_hp_names) rhprels in
  (*unk*)
     let r_unk_svl = List.concat ((List.map (retrieve_args_one_hp unk_hp_locs) r_cs_unk_hps)) in
     let unk_svl = CP.remove_dups_svl (l_unk_svl@r_unk_svl) in
     (* let unks, new_hfs,new_equivs = split3 (List.map (get_unk_hp unk_svl equivs) cs_unk_hps) in *)
     (*dynamic splitting: unk and non-unk*)
     (*filter all full unk_hps and non_unk_hps first*)
     let lres1,lres2 = List.split(List.map (get_full_unk_hps unk_svl) l_cs_unk_hps) in
     let l_full_unks = List.concat lres1 in
     let l_rems = List.concat lres2 in
     (*rhs*)
     let rres1,rres2 = List.split(List.map (get_full_unk_hps unk_svl) r_cs_unk_hps) in
     let r_full_unks = List.concat rres1 in
     let r_rems = List.concat rres2 in
     (*generate eqv for new full unk hps*)
     let new_equivs = List.concat (List.map (fun (hp,args,locs) ->
         gen_eqv equivs hp (List.combine args locs) unk_svl [(hp,args)] (l_cs_unk_hps@r_cs_unk_hps)
         ) (l_full_unks@r_full_unks)) in
     (*update*)
     let cs_full_unk_hps = List.map (fun (hp,_,_) -> hp) (l_full_unks@r_full_unks) in
     let new_total_full_unks = CP.remove_dups_svl (cur_full_unk_hps @ cs_full_unk_hps) in

     let l_unks, l_hfs, lequivs = helper1 unk_svl l_rems (l_cs_unk_hps@r_cs_unk_hps)
       (l_full_unks@r_full_unks) new_total_full_unks [] [] (equivs@new_equivs)
     in
     let r_unks, r_hfs,new_equivs = helper1 unk_svl r_rems (l_cs_unk_hps@r_cs_unk_hps)
       (l_full_unks@r_full_unks) new_total_full_unks [] [] lequivs
     in
     let unks = (List.map (fun (a,b,c) -> (a,b)) (l_full_unks@r_full_unks))@
       l_unks@r_unks in
     (******************************START******************************)
      (*currently, we do not add extract dangling hps into ass*)
     (*
     let n_lhs =
        match l_hfs with
          | [] -> lhs
          | _ ->
          let l = CF.pos_of_formula lhs in
          let new_hfs_comb = List.fold_left (fun hf1 hf2 -> CF.mkStarH hf1 hf2 l) (List.hd l_hfs) (List.tl l_hfs) in
          (* let split_hps,_ = List.split new_equivs in *)
             (*remove old hps*)
          (* let f1,_ = CF.drop_hrel_f f (fst (List.split split_hps)) in *)
          let f1 = lhs in
          let f2 = CF.mkAnd_f_hf f1 new_hfs_comb (CF.pos_of_formula f1) in
          f2
     in
     (*remove dups from rhs*)
     let new_r_hfs = Gen.BList.difference_eq (fun hf1 hf2 ->
         let hp1,_ = CF.extract_HRel hf1 in
         let hp2,_ = CF.extract_HRel hf2 in
         CP.eq_spec_var hp1 hp2
     )
       r_hfs l_hfs in
     let n_rhs =
        match new_r_hfs with
          | [] -> rhs
          | _ ->
          let l = CF.pos_of_formula rhs in
          let new_hfs_comb = List.fold_left (fun hf1 hf2 -> CF.mkStarH hf1 hf2 l) (List.hd new_r_hfs) (List.tl new_r_hfs) in
          (* let split_hps,_ = List.split new_equivs in *)
             (*remove old hps*)
          (* let f1,_ = CF.drop_hrel_f f (fst (List.split split_hps)) in *)
          let f1 = rhs in
          let f2 = CF.mkAnd_f_hf f1 new_hfs_comb (CF.pos_of_formula f1) in
          f2
     in
     *)
      (*************************END***********************************)
     let n_lhs = lhs in
     let n_rhs = rhs in
     (n_lhs, n_rhs, unks, new_total_full_unks, unk_svl, new_equivs)
  in
  (*============BODY===============*)
  let unk_hp_names =  (List.map (fun (hp, _) -> hp) unk_hp_locs) in
  (* let lhs,lunk_hps,lunk_svl, lequv = helper constr.CF.hprel_lhs equivs0 unk_hp_names in *)
  (* let rhs,runk_hps,runk_svl, requv = helper constr.CF.hprel_rhs (lequv) unk_hp_names in *)
  let lhs,rhs,new_unk_hps, new_full_unk_hps ,new_unk_svl, new_equv = helper constr.CF.hprel_lhs constr.CF.hprel_rhs equivs0 unk_hp_names in
  let new_constr = {constr with
      CF.unk_svl = CP.remove_dups_svl (constr.CF.unk_svl@new_unk_svl);
      CF.unk_hps = SAU.elim_eq_shorter_hpargs (constr.CF.unk_hps@new_unk_hps);
      CF.hprel_lhs = lhs;
      CF.hprel_rhs = rhs;
  }
  in
  let _ = Debug.ninfo_pprint ("   new hrel: " ^
              (Cprinter.string_of_hprel new_constr)) no_pos in
  (new_constr,new_unk_hps, new_full_unk_hps, new_equv)

and update_unk_one_constr prog unk_hp_locs cur_full_unk_hps equivs0 constr=
  let pr1 = pr_list (pr_pair !CP.print_sv (pr_list string_of_int)) in
  let pr2 =  pr_list_ln (pr_pair (pr_pair !CP.print_sv (pr_list string_of_int))
                              (pr_list (pr_pair !CP.print_sv !CP.print_svl))) in
  let pr3 = Cprinter.string_of_hprel in
  let pr4 = !CP.print_svl in
  let pr5 = fun (a,_,_,d) -> (pr3 a) ^ " \n eqvs:" ^ (pr2 d) in
  Debug.no_4 "update_unk_one_constr" pr1 pr4 pr2 pr3 pr5
      (fun _ _ _ _ -> update_unk_one_constr_x prog unk_hp_locs cur_full_unk_hps
          equivs0 constr) unk_hp_locs cur_full_unk_hps equivs0 constr

(*=============END UNKOWN================*)
(*END first step*)
(*=======================*)
(*check_partial_def_eq: to remove duplicate and identify terminating condition*)
let check_partial_def_eq_x (hp1, args1,_, cond1, olhs1, orhs1) (hp2, args2,_, cond2, olhs2, orhs2)=
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
  let pr1 = SAU.string_of_par_def_w_name in
  Debug.no_2 "check_partial_def_eq" pr1 pr1 string_of_bool
      (fun _ _ -> check_partial_def_eq_x par_def1 par_def2) par_def1 par_def2

(*should we mkAnd f1 f2*)
let rec find_defined_pointers_two_formulas_x prog f1 f2 predef_ptrs=
  let (def_vs1, hds1, hvs1, hrs1, eqs1,eqNulls1) = SAU.find_defined_pointers_raw prog f1 in
  let (def_vs2, hds2, hvs2, hrs2, eqs2,eqNulls2) = SAU.find_defined_pointers_raw prog f2 in
  SAU.find_defined_pointers_after_preprocess prog (def_vs1@def_vs2) (hds1@hds2) (hvs1@hvs2)
      (hrs2) (eqs1@eqs2) (eqNulls1@eqNulls2) predef_ptrs

and find_defined_pointers_two_formulas prog f1 f2 predef_ptrs=
  let pr1 = !CP.print_svl in
  let pr2 = pr_list_ln (pr_pair !CP.print_sv pr1) in
  (* let pr3 = fun x -> Cprinter.string_of_h_formula (CF.HRel x) in *)
  let pr4 = fun (a1, a2, _, _, _) ->
      let pr = pr_pair pr1 pr2 in pr (a1,a2)
  in
  Debug.no_3 "find_defined_pointers_two_formulas" Cprinter.prtt_string_of_formula Cprinter.prtt_string_of_formula pr1 pr4
      (fun _ _ _ -> find_defined_pointers_two_formulas_x prog f1 f2 predef_ptrs) f1 f2 predef_ptrs

(**********************************************************)
     (*********aux functions for pardef collect********)
(**********************************************************)
(*if root + next ptr is inside args: ll_all_13a: G***)
let elim_direct_root_pto_x undef_args args prog hd_nodes hv_nodes=
  let root =
    if args = [] then report_error no_pos "sa.elim_direct_root_pto: hp should have at least one arguments"
    else List.hd args
  in
  if CP.mem_svl root undef_args then
    let next_ptrs_from_root = SAU.loop_up_closed_ptr_args prog hd_nodes hv_nodes [root] in
    let next_ptrs_from_root1 = (CP.remove_dups_svl next_ptrs_from_root) in
    let next_ptrs_from_root2 = CP.diff_svl next_ptrs_from_root1 [root] in
    (* let _ = Debug.info_pprint ("    next_ptrs_from_root2:" ^ (!CP.print_svl next_ptrs_from_root2)) no_pos in *)
    let add_defs =
      if (next_ptrs_from_root2 <> []) && CP.diff_svl next_ptrs_from_root2 args = [] then
        ([root]@next_ptrs_from_root1)
      else []
    in
    let undef_args1 = CP.diff_svl undef_args add_defs in
    undef_args1
  else
    undef_args

let elim_direct_root_pto undef_args args prog hd_nodes hv_nodes=
  let pr1 = !CP.print_svl in
  Debug.no_2 "elim_direct_root_pto" pr1 pr1 pr1
      (fun _ _ -> elim_direct_root_pto_x undef_args args prog hd_nodes hv_nodes) undef_args args

let rec collect_par_defs_one_side_one_hp_aux_x prog f (hrel, args) def_ptrs
      eqs hd_nodes hv_nodes unk_hps unk_svl predef=
  begin
      Debug.ninfo_pprint (" hp: "^ (!CP.print_sv hrel)) no_pos;
      let _ = DD.ninfo_pprint ("   def " ^(!CP.print_svl (def_ptrs@predef@unk_svl))) no_pos in
      let def_ptrs1 = (List.fold_left SAU.close_def (def_ptrs@predef@unk_svl) eqs) in
      let _ = DD.ninfo_pprint ("   def1 " ^(!CP.print_svl def_ptrs1)) no_pos in
      (*find definition in both lhs and rhs*)
      let undef_args = SAU.lookup_undef_args args [] def_ptrs1 in
      (* let _ = DD.ninfo_pprint ("   undef_args " ^(!CP.print_svl undef_args)) no_pos in *)
      (*if root + next ptr is inside args: ll_all_13a: G***)
      let undef_args1 =  elim_direct_root_pto undef_args args prog hd_nodes hv_nodes in
      (* let _ = DD.ninfo_pprint ("   undef_args1 " ^(!CP.print_svl undef_args1)) no_pos in *)
      let test1= (List.length undef_args1) = 0 in
        (*case 1*)
        (*this hp is well defined, synthesize partial def*)
      if test1 then
        let keep_ptrs = SAU.loop_up_closed_ptr_args prog hd_nodes hv_nodes args in
        let keep_ptrs1 = (List.fold_left SAU.close_def keep_ptrs eqs) in
        let keep_unk_hps = List.concat (List.map (SAU.get_intersect_hps keep_ptrs1) unk_hps) in
        let l = CF.drop_data_view_hrel_nodes f SAU.check_nbelongsto_dnode SAU.check_nbelongsto_vnode SAU.check_neq_hrelnode keep_ptrs1 keep_ptrs1 keep_unk_hps in
        let test2 = (not (SAU.is_empty_f l)) && (not (CF.is_only_neqNull args keep_unk_hps l)) in
        if test2 then
          let l_r = (hrel, args, (* CP.intersect_svl args *) unk_svl, l, Some l, None) in
          let _ =  DD.ninfo_pprint ("  partial defs: \n" ^
                                          (let pr =  SAU.string_of_par_def_w_name in pr l_r) ) no_pos in
          [l_r]
        else []
      else []
  end

and collect_par_defs_one_side_one_hp_aux prog f (hrel, args) def_ptrs
      eqs hd_nodes hv_nodes unk_hps unk_svl predef=
  let pr1 = pr_pair !CP.print_sv !CP.print_svl in
  let pr2 = Cprinter.prtt_string_of_formula in
  let pr3 = pr_list_ln SAU.string_of_par_def_w_name in
   Debug.no_2 "collect_par_defs_one_side_one_hp_rhs" pr1 pr2 pr3
       (fun _ _ -> collect_par_defs_one_side_one_hp_aux_x prog f (hrel, args) def_ptrs
           eqs hd_nodes hv_nodes unk_hps unk_svl predef) (hrel, args) f

(**********************************************************)
  (********END aux functions for pardef collect*******)
(**********************************************************)
(********************SHOULD BE REMOVED*************************************)
(*collect partial def for rhs hrels. diff from lhs, rhs includes rhs formula also*)
let rec collect_par_defs_one_side_one_hp_rhs_x_old prog lhs rhs (hrel, args) def_ptrs
      eqs hd_nodes hv_nodes unk_hps unk_svl predef=
  begin
      Debug.ninfo_pprint (" rhs hp: "^ (!CP.print_sv hrel)) no_pos;
      let def_ptrs1 = (List.fold_left SAU.close_def def_ptrs eqs) in
      (*find definition in both lhs and rhs*)
      let undef_args = SAU.lookup_undef_args args [] def_ptrs1 in
      (*if root + next ptr is inside args: ll_all_13a: G***)
      let undef_args1 =  elim_direct_root_pto undef_args args prog hd_nodes hv_nodes in
      let test1= (List.length undef_args1) = 0 in
        (*case 1*)
        (*this hp is well defined, synthesize partial def*)
      if test1 then
        let keep_ptrs = SAU.loop_up_closed_ptr_args prog hd_nodes hv_nodes args in
        let keep_ptrs1 = (List.fold_left SAU.close_def keep_ptrs eqs) in
      (* let _ = Debug.info_pprint ("    undef_args1:" ^ (!CP.print_svl undef_args1)) no_pos in *)
      (* let _ = Debug.info_pprint ("    keep_ptrs1:" ^ (!CP.print_svl keep_ptrs1)) no_pos in *)
        let keep_unk_hps = List.concat (List.map (SAU.get_intersect_hps keep_ptrs1) unk_hps) in
      (* let pr= pr_list (pr_pair !CP.print_sv !CP.print_svl) in *)
      (* let _ = Debug.info_pprint ("   unk_hps:" ^(pr unk_hps)) no_pos in *)
      (* let _ = Debug.info_pprint ("    keep_unk_hps:" ^(!CP.print_svl  keep_unk_hps)) no_pos in *)
      (* let _ = Debug.info_pprint ("   rhs:" ^(Cprinter.prtt_string_of_formula rhs)) no_pos in *)
      (*extract relevant pure of rhs and combine with lhs*)
      (* let rhsp = match rhs with *)
      (*   | CF.Base fb -> fb.CF.formula_base_pure *)
      (*   | CF.Exists fe -> fe.CF.formula_exists_pure *)
      (*   | _ -> report_error no_pos "sa.collect_par_defs_one_side_one_hp_rhs_x: not handle yet" *)
      (* in *)
      (* let rhsp1 = CP.filter_var_new (MCP.pure_of_mix rhsp) keep_ptrs1 in *)
      (* let nlhs = CF.mkAnd_pure lhs (MCP.mix_of_pure rhsp1) no_pos in *)
        let nlhs = CF.mkStar lhs rhs CF.Flow_combine (CF.pos_of_formula lhs) in
        let l = CF.drop_data_view_hrel_nodes nlhs SAU.check_nbelongsto_dnode SAU.check_nbelongsto_vnode SAU.check_neq_hrelnode keep_ptrs1 keep_ptrs1 keep_unk_hps in
      (* let r = CF.drop_data_view_hrel_nodes rhs SAU.check_nbelongsto_dnode SAU.check_nbelongsto_vnode SAU.check_neq_hrelnode keep_ptrs1 keep_ptrs1 keep_unk_hps in *)
      (* let r = if SAU.is_empty_f r then None else Some r in *)
      (* let _ = Debug.info_pprint ("   l:" ^(Cprinter.prtt_string_of_formula l)) no_pos in *)
        let test2 = (not (SAU.is_empty_f l)) && (not (CF.is_only_neqNull args keep_unk_hps l)) in
        if test2 then
          let l_r = (hrel, args, CP.intersect_svl args unk_svl, l, Some l, None) in
          let _ =  DD.ninfo_pprint ("  partial defs - rhs: \n" ^
                                          (let pr =  SAU.string_of_par_def_w_name in pr l_r) ) no_pos in
          [l_r]
        else []
      else []
  end

(*collect partial def ---> hp*)
let rec collect_par_defs_one_side_one_hp_x_old prog lhs rhs (hrel, args) ldef_ptrs rdef_ptrs
      rhrels eqs hd_nodes hv_nodes unk_hps unk_svl predef=
  begin
      let _ = Debug.ninfo_pprint (" lhs hp: "^ (!CP.print_sv hrel)) no_pos in
      let _ = Debug.ninfo_pprint (" lhs args: "^ (!CP.print_svl args)) no_pos in
      let lprocess_helper def_ptrs=
      (*find definition in lhs*)
        let undef_args = SAU.lookup_undef_args args [] def_ptrs in
        (*if root + next ptr is inside args: ll_all_13a: G***)
        let undef_args1 =  elim_direct_root_pto undef_args args prog hd_nodes hv_nodes in
        let test1= (List.length undef_args1) = 0 in
      (*case 1*)
        if test1 then
          (*this hp is well defined, synthesize partial def*)
          let keep_ptrs = SAU.loop_up_closed_ptr_args prog hd_nodes hv_nodes args in
          let keep_unk_hps = List.concat (List.map (SAU.get_intersect_hps keep_ptrs) unk_hps) in
        (* let pr = pr_list (pr_pair !CP.print_sv !CP.print_svl) in *)
        (* Debug.info_pprint (" undef_args1: "^ (!CP.print_svl undef_args1)) no_pos; *)
        (* Debug.info_pprint (" unk_hps: "^ (pr unk_hps)) no_pos; *)
        (* Debug.info_pprint (" keep_unk_hps: "^ (!CP.print_svl keep_unk_hps)) no_pos; *)
          let r = CF.drop_data_view_hrel_nodes lhs SAU.check_nbelongsto_dnode SAU.check_nbelongsto_vnode SAU.check_neq_hrelnode keep_ptrs keep_ptrs keep_unk_hps in
          let test2 = (not (SAU.is_empty_f r)) && (not (CF.is_only_neqNull args keep_unk_hps r)) in
          if test2 then
          (*collect partial def ---> hp*)
            let l_r = (hrel, args, CP.intersect_svl args unk_svl, r, Some r, None) in
            let _ =  DD.ninfo_pprint ("  partial defs - one side def ---> hp: \n" ^
                                             (let pr =  SAU.string_of_par_def_w_name in pr l_r) ) no_pos in
            [l_r]
          else
            []
        else []
      in
      let rprocess_helper def_ptrs=
      (*find definition in lhs*)
        let def_ptrs1 = (List.fold_left SAU.close_def (def_ptrs@predef) eqs) in
        let undef_args = SAU.lookup_undef_args args [] def_ptrs1 in
        (*if root + next ptr is inside args: ll_all_13a: G***)
        let undef_args1 =  elim_direct_root_pto undef_args args prog hd_nodes hv_nodes in
        let test1= (List.length undef_args1) = 0 in
        if test1 then
        (*case 1*)
        (*this hp is well defined, synthesize partial def*)
          let keep_ptrs = SAU.loop_up_closed_ptr_args prog hd_nodes hv_nodes args in
          let keep_unk_hps = List.concat (List.map (SAU.get_intersect_hps keep_ptrs) unk_hps) in
        (* let pr = pr_list (pr_pair !CP.print_sv !CP.print_svl) in *)
        (* Debug.info_pprint (" keep_ptrs: "^ (!CP.print_svl keep_ptrs)) no_pos; *)
        (* Debug.info_pprint (" unk_hps: "^ (pr unk_hps)) no_pos; *)
        (* Debug.info_pprint (" keep_unk_hps: "^ (!CP.print_svl keep_unk_hps)) no_pos; *)
          let r = CF.drop_data_view_hrel_nodes rhs
            SAU.check_nbelongsto_dnode SAU.check_nbelongsto_vnode
            SAU.check_neq_hrelnode keep_ptrs keep_ptrs keep_unk_hps
          in
          let test2 = (not (SAU.is_empty_f r)) && (not (CF.is_only_neqNull args keep_unk_hps r)) in
          if test2 then
          (*collect partial def ---> hp*)
            let l1 =
              let l=CF.drop_data_view_hrel_nodes lhs SAU.check_nbelongsto_dnode
                SAU.check_nbelongsto_vnode SAU.check_neq_hrelnode keep_ptrs
                keep_ptrs keep_unk_hps
              in
              if (SAU.is_empty_f l) || (CF.is_only_neqNull args keep_unk_hps l)  then None else Some l
            in
            let l_r = (hrel, args, CP.intersect_svl args unk_svl, r, l1 , Some r) in
            let _ =  DD.ninfo_pprint ("  partial defs - one side hp ---> def: \n" ^
                                             (let pr =  SAU.string_of_par_def_w_name in pr l_r) ) no_pos in
            [l_r]
          else
            []
        else []
      in
      let pdefs1 = lprocess_helper ldef_ptrs in
      let pdefs2 = rprocess_helper (ldef_ptrs@rdef_ptrs) in
      let pdefs = pdefs1@pdefs2 in
       if pdefs = [] then
          (*CASE2: hp1(x1,x2,x3) --> h2(x1,x2,x3)* formula: hp such that have the same set of args in both sides*)
        (*matching lhs-rhs- first*)
        let r_r,_ = collect_par_defs_two_side_one_hp prog lhs rhs (hrel, args) (unk_svl@predef) rhrels hd_nodes hv_nodes unk_hps in
        r_r
      else pdefs
  end
(********************END SHOULD BE REMOVED*************************************)
(********************END SHOULD BE REMOVED*************************************)
(********************END SHOULD BE REMOVED*************************************)
(*collect partial def for rhs hrels. diff from lhs, rhs includes rhs formula also*)
and collect_par_defs_one_side_one_hp_rhs_x prog lhs rhs (hrel, args) def_ptrs lhrels
      eqs hd_nodes hv_nodes unk_hps unk_svl predef=
  begin
      Debug.ninfo_pprint (" collect pardef for rhs hps: ") no_pos;
      let nlhs = CF.mkStar lhs rhs CF.Flow_combine (CF.pos_of_formula lhs) in
      let pdefs = collect_par_defs_one_side_one_hp_aux_x prog nlhs (hrel, args) def_ptrs
          eqs hd_nodes hv_nodes unk_hps unk_svl predef
      in pdefs
      (* if pdefs = [] then *)
      (*     (\*CASE2: hp1(x1,x2,x3) --> h2(x1,x2,x3)* formula: hp such that have the same set of args in both sides*\) *)
      (*   (\*matching lhs-rhs- first*\) *)
      (*   let r_ls,_ = collect_par_defs_two_side_one_hp prog lhs rhs (hrel, args) *)
      (*     (unk_svl@predef) lhrels hd_nodes hv_nodes unk_hps false in *)
      (*   r_ls *)
      (* else pdefs *)
  end

and collect_par_defs_one_side_one_hp_rhs prog lhs rhs (hrel, args) def_ptrs lhrels
      eqs hd_nodes hv_nodes unk_hps unk_svl predef=
  let pr1 = pr_pair !CP.print_sv !CP.print_svl in
  let pr2 = Cprinter.prtt_string_of_formula in
  let pr3 = pr_list_ln SAU.string_of_par_def_w_name in
   Debug.no_2 "collect_par_defs_one_side_one_hp_rhs" pr1 pr2 pr3
       (fun _ _ -> collect_par_defs_one_side_one_hp_rhs_x prog lhs rhs (hrel, args) def_ptrs lhrels
           eqs hd_nodes hv_nodes unk_hps unk_svl predef) (hrel, args) rhs

(*collect partial def ---> hp*)
and collect_par_defs_one_side_one_hp_x prog lhs rhs (hrel, args) ldef_ptrs rdef_ptrs
      rhrels eqs hd_nodes hv_nodes unk_hps unk_svl predef=
  begin
      let _ = Debug.ninfo_pprint ("   collect pardef for lhs hps: ") no_pos in
      let lprocess_helper def_ptrs=
        let _ =  DD.ninfo_pprint ("       def ---> hp: \n" ) no_pos in
        collect_par_defs_one_side_one_hp_aux_x prog lhs (hrel, args) ldef_ptrs
            eqs hd_nodes hv_nodes unk_hps unk_svl predef
      in
      let rprocess_helper def_ptrs=
      (*find definition in lhs*)
        let undef_args = SAU.lookup_undef_args args [] def_ptrs in
        (*if root + next ptr is inside args: ll_all_13a: G***)
        let undef_args1 =  elim_direct_root_pto undef_args args prog hd_nodes hv_nodes in
        let test1= (List.length undef_args1) = 0 in
        if test1 then
        (*case 1*)
        (*this hp is well defined, synthesize partial def*)
          let keep_ptrs = SAU.loop_up_closed_ptr_args prog hd_nodes hv_nodes args in
          let keep_unk_hps = List.concat (List.map (SAU.get_intersect_hps keep_ptrs) unk_hps) in
        (* let pr = pr_list (pr_pair !CP.print_sv !CP.print_svl) in *)
        (* Debug.info_pprint (" keep_ptrs: "^ (!CP.print_svl keep_ptrs)) no_pos; *)
        (* Debug.info_pprint (" unk_hps: "^ (pr unk_hps)) no_pos; *)
        (* Debug.info_pprint (" keep_unk_hps: "^ (!CP.print_svl keep_unk_hps)) no_pos; *)
          let r = CF.drop_data_view_hrel_nodes rhs
            SAU.check_nbelongsto_dnode SAU.check_nbelongsto_vnode
            SAU.check_neq_hrelnode keep_ptrs keep_ptrs keep_unk_hps
          in
          let test2 = (not (SAU.is_empty_f r)) && (not (CF.is_only_neqNull args keep_unk_hps r)) in
          if test2 then
          (*collect partial def ---> hp*)
            let l1 =
              let l=CF.drop_data_view_hrel_nodes lhs SAU.check_nbelongsto_dnode
                SAU.check_nbelongsto_vnode SAU.check_neq_hrelnode keep_ptrs
                keep_ptrs keep_unk_hps
              in
              if (SAU.is_empty_f l) || (CF.is_only_neqNull args keep_unk_hps l)  then None else Some l
            in
            let l_r = (hrel, args, (* CP.intersect_svl args *) unk_svl, r, l1 , Some r) in
            let _ =  DD.ninfo_pprint ("       hp ---> def: \n" ^
                                             (let pr =  SAU.string_of_par_def_w_name in pr l_r) ) no_pos in
            [l_r]
          else
            []
        else []
      in
      let pdefs1 = lprocess_helper ldef_ptrs in
      let pdefs2 = rprocess_helper (ldef_ptrs@rdef_ptrs) in
      let pdefs = pdefs1@pdefs2 in
      if pdefs = [] then
          (*CASE2: hp1(x1,x2,x3) --> h2(x1,x2,x3)* formula: hp such that have the same set of args in both sides*)
        (*matching lhs-rhs- first*)
        let r_r,_ = collect_par_defs_two_side_one_hp prog lhs rhs (hrel, args) (unk_svl@predef)
          rhrels hd_nodes hv_nodes unk_hps in
        r_r
      else pdefs
  end

(*matching hps between lhs and rhs, if there exists, drop them*)
and collect_par_defs_one_side_one_hp prog lhs rhs (hrel, args) ldef_ptrs rdef_ptrs
      rhrels eq hd_nodes hv_nodes unk_hps unk_svl predef=
  let pr1 = pr_pair !CP.print_sv !CP.print_svl in
  let pr2 = Cprinter.prtt_string_of_formula in
  let pr3 = pr_list_ln SAU.string_of_par_def_w_name in
   Debug.no_2 "collect_par_defs_one_side_one_hp" pr1 pr2 pr3
       (fun _ _ -> collect_par_defs_one_side_one_hp_x prog lhs rhs (hrel, args) ldef_ptrs rdef_ptrs
       rhrels eq hd_nodes hv_nodes unk_hps unk_svl predef) (hrel, args) lhs

(*collect hp1(x1,x2,x3) ---> hp2(x1,x2,x3) * F  partial def : drop after matching*)
(*: more general form: collect hp1(x1,x2,x3) ---> hp2(x1,x2) * F:
 x3 is defined/unknown/predef  partial def
 *)

and collect_par_defs_two_side_one_hp_x prog lhs rhs (hrel, args)
      predef other_side_hrels hd_nodes hv_nodes unk_hps (*is_lhs*)=
  let _ =  DD.ninfo_pprint ("    lhs hrel:" ^ (!CP.print_sv hrel) ) no_pos in
  let args0 = CP.remove_dups_svl args in
  let args01 = SAU.loop_up_closed_ptr_args prog hd_nodes hv_nodes args0 in
  (* let _ =  DD.ninfo_pprint ("    args0:" ^ (!CP.print_svl args0) ) no_pos in *)
  let _ =  DD.ninfo_pprint ("    args01:" ^ (!CP.print_svl args01) ) no_pos in
  let _ =  DD.ninfo_pprint ("    predef:" ^ (!CP.print_svl predef) ) no_pos in
  let unk_svl = List.fold_left (fun svl (_,svl2) -> svl@svl2) [] unk_hps in
  let rec find_hrel_w_same_set_args_one_hpargs (hp, args1) r res=
    match r with
      | [] -> [],res
      | (hps, keep_args, rem_args1)::ss ->
          let args0 = CP.remove_dups_svl rem_args1 in
          let args01 = SAU.loop_up_closed_ptr_args prog hd_nodes hv_nodes args0 in
          (* let _ =  DD.info_pprint ("    args01:" ^ (!CP.print_svl args01) ) no_pos in *)
          (*recompute def_ptrs *)
          (* let _ =  DD.info_pprint ("    rhs hrel:" ^ (!CP.print_sv hp) ) no_pos in *)
          (*elim recursive cases*)
          if CP.eq_spec_var hrel hp || CP.intersect args01 args1 = [] ||
            Gen.BList.difference_eq CP.eq_spec_var args1 predef = [] then
            find_hrel_w_same_set_args_one_hpargs (hp, args1) ss (res@[(hps, keep_args, rem_args1)])
          else begin
          (*find all defined pointer (null, nodes) and recursive defined parameters (HP, arg)*)
              let n_predef = CP.remove_dups_svl (predef@keep_args@args1) in
              let _ =  DD.ninfo_pprint ("    n_predef:" ^ (!CP.print_svl n_predef) ) no_pos in
              let l_def_ptrs, _,_, _,_ = SAU.find_defined_pointers prog lhs n_predef in
              let r_def_ptrs, _, _, _, _ = find_defined_pointers_two_formulas prog lhs rhs n_predef in
              (* let _ =  DD.ninfo_pprint ("    defs:" ^ (!CP.print_svl (l_def_ptrs@r_def_ptrs)) ) no_pos in *)
              let undef_args = SAU.lookup_undef_args args01 [] (l_def_ptrs@r_def_ptrs@n_predef) in
              (* let _ =  DD.info_pprint ("    undef_args:" ^ (!CP.print_svl undef_args) ) no_pos in *)
              if undef_args = [] then
                    [(hps@[hp], CP.remove_dups_svl (keep_args@args1@rem_args1) )],[] (*collect it*)
              else
                let keep_args_in_rem = CP.diff_svl rem_args1 undef_args in
                find_hrel_w_same_set_args_one_hpargs (hp, args1) ss (r@[(hps@[hp], CP.remove_dups_svl (keep_args@args1@keep_args_in_rem), undef_args)])
          end
  in
  let rec find_hrels_w_same_set_args ls cur_par_list r=
    match ls with
      | [] -> r
      | hpargs1::ss ->
          let res,new_par_list = find_hrel_w_same_set_args_one_hpargs hpargs1 cur_par_list [] in
          if res = [] then
            find_hrels_w_same_set_args ss new_par_list r
          else res
  in
    (*find all hrel in rhs such that cover the same set of args*)
  let r_selected_hrels = find_hrels_w_same_set_args other_side_hrels [([hrel],[],args0)] [] in
  let build_par_def lhs0 (hps,args0)=
    let keep_ptrs = SAU.loop_up_closed_ptr_args prog hd_nodes hv_nodes args0 in
    let keep_unk_hps = List.concat (List.map (SAU.get_intersect_hps keep_ptrs) unk_hps) in
    (* if is_lhs then *)
      let pdef_rhs = CF.drop_data_view_hrel_nodes rhs SAU.check_nbelongsto_dnode SAU.check_nbelongsto_vnode SAU.check_neq_hrelnode keep_ptrs keep_ptrs (hps@keep_unk_hps) in
      let pdef_cond = CF.drop_data_view_hrel_nodes lhs0 SAU.check_nbelongsto_dnode SAU.check_nbelongsto_vnode SAU.check_neq_hrelnode keep_ptrs keep_ptrs (keep_unk_hps) in
      let lhprel = CF.get_hprel pdef_cond in
      let bf =
        if lhprel = [] then pdef_rhs else
          let lhfs = List.map (fun hprel -> CF.HRel hprel) lhprel in
          let lhf = List.fold_left (fun hf1 hf2 -> CF.mkStarH hf1 hf2 no_pos) (List.hd lhfs) (List.tl lhfs) in
          let pos = (CF.pos_of_formula pdef_rhs) in
          (* SAU.compose_subs pdef_rhs (CF.formula_of_heap lhf pos) pos *)
          CF.mkAnd_f_hf pdef_rhs lhf pos
      in
      let pdefs = if SAU.is_trivial bf (hrel, args) then [] else
            if not (SAU.is_empty_f pdef_cond || CF.is_only_neqNull args keep_unk_hps pdef_cond) && CF.is_HRel_f bf then
              let r_hp,r_args = CF.extract_HRel_f bf in
              let pdef = CF.drop_data_view_hrel_nodes lhs0 SAU.check_nbelongsto_dnode SAU.check_nbelongsto_vnode SAU.check_neq_hrelnode keep_ptrs keep_ptrs (keep_unk_hps@[hrel]) in
              [(r_hp, r_args, unk_svl,  pdef_cond , Some pdef, None)]
            else
              [(hrel, args, unk_svl, pdef_cond , None, Some bf)]
      in
      (pdefs,lhs)
  in
  let rec loop_helper lhs1 ls res=
    match ls with
      | [] -> res,lhs1
      | r_sel_hp::ss -> let r,nlhs =  build_par_def lhs1 r_sel_hp in
                        loop_helper nlhs ss (res@r)
  in
  let rs,lhs_n = loop_helper lhs r_selected_hrels [] in
  let _ =  DD.ninfo_pprint ("  partial defs - two side: \n" ^
          (let pr = pr_list_ln SAU.string_of_par_def_w_name in pr rs) ) no_pos in
  rs,lhs_n

and collect_par_defs_two_side_one_hp prog lhs rhs (hrel, args) predef rhs_hrels hd_nodes hv_nodes unk_hps=
  let pr1 = pr_pair !CP.print_sv !CP.print_svl in
  let pr2 =  pr_list_ln pr1 in
  let pr3 = pr_list_ln SAU.string_of_par_def_w_name in
  let pr4 = pr_pair pr3 Cprinter.prtt_string_of_formula in
  Debug.no_2 "collect_par_defs_two_side_one_hp" pr1 pr2 pr4
      (fun _ _ -> collect_par_defs_two_side_one_hp_x prog lhs rhs (hrel, args) predef
          rhs_hrels hd_nodes hv_nodes unk_hps)
      (hrel, args) rhs_hrels

let collect_par_defs_recursive_hp_x prog lhs rhs (hrel, args) rec_args other_side_hrels def_ptrs hrel_vars eqs hd_nodes hv_nodes dir unk_hps unk_svl predef=
  let _ =  DD.ninfo_pprint ("    rec hrel:" ^ (!CP.print_sv hrel) ) no_pos in
  (* let _ =  DD.info_pprint ("    args:" ^ (!CP.print_svl args) ) no_pos in *)
  (* let _ =  DD.info_pprint ("    rec args:" ^ (!CP.print_svl rec_args) ) no_pos in *)
  let def_ptrs = CP.remove_dups_svl (List.fold_left SAU.close_def (def_ptrs@predef@unk_svl) eqs) in
  let rec find_hrel_w_same_set_args_one_hpargs (hp, args1) r res=
    match r with
      | [] -> [],res
      | (hps, keep_args, rem_args1)::ss ->
          let args0 = CP.remove_dups_svl rem_args1 in
          let args01 = SAU.loop_up_closed_ptr_args prog hd_nodes hv_nodes args0 in
          let _ =  DD.ninfo_pprint ("    args01:" ^ (!CP.print_svl args01) ) no_pos in
          (*recompute def_ptrs *)
          let _ =  DD.ninfo_pprint ("    lhs hrel:" ^ (!CP.print_sv hp) ) no_pos in
          (*elim recursive cases*)
          if (* CP.eq_spec_var hrel hp || *) CP.intersect args01 args1 = [] || Gen.BList.difference_eq CP.eq_spec_var args1 predef = [] then
            find_hrel_w_same_set_args_one_hpargs (hp, args1) ss (res@[(hps, keep_args, rem_args1)])
          else begin
          (*find all defined pointer (null, nodes) and recursive defined parameters (HP, arg)*)
              let n_predef = CP.remove_dups_svl (predef@keep_args@args1) in
              let _ =  DD.ninfo_pprint ("    n_predef:" ^ (!CP.print_svl n_predef) ) no_pos in
              let l_def_ptrs, _,_, _,_ = SAU.find_defined_pointers prog lhs n_predef in
              let r_def_ptrs, _, _, _, _ = find_defined_pointers_two_formulas prog lhs rhs n_predef in
              (* let _ =  DD.ninfo_pprint ("    defs:" ^ (!CP.print_svl (l_def_ptrs@r_def_ptrs)) ) no_pos in *)
              let undef_args = SAU.lookup_undef_args args01 [] (l_def_ptrs@r_def_ptrs@n_predef) in
              let _ =  DD.ninfo_pprint ("    undef_args:" ^ (!CP.print_svl undef_args) ) no_pos in
              if undef_args = [] then
                    [(hps@[hp], CP.remove_dups_svl (keep_args@args1@rem_args1) )],[] (*collect it*)
              else
                let keep_args_in_rem = CP.diff_svl rem_args1 undef_args in
                find_hrel_w_same_set_args_one_hpargs (hp, args1) ss (r@[(hps@[hp], CP.remove_dups_svl (keep_args@args1@keep_args_in_rem), undef_args)])
          end
  in
  let rec find_hrels_w_same_set_args ls cur_par_list r=
    match ls with
      | [] -> r
      | hpargs1::ss ->
          let res,new_par_list = find_hrel_w_same_set_args_one_hpargs hpargs1 cur_par_list [] in
          if res = [] then
            find_hrels_w_same_set_args ss new_par_list r
          else res
  in
  let build_partial_def (hps,args0)=
    let keep_ptrs = SAU.loop_up_closed_ptr_args prog hd_nodes hv_nodes
      (CP.remove_dups_svl (args0@args@rec_args@unk_svl)) in
    let keep_unk_hps = List.concat (List.map (SAU.get_intersect_hps keep_ptrs) unk_hps) in
    let plhs = CF.drop_data_view_hrel_nodes lhs SAU.check_nbelongsto_dnode SAU.check_nbelongsto_vnode SAU.check_neq_hrelnode keep_ptrs keep_ptrs (hps@keep_unk_hps) in
     let prhs = CF.drop_data_view_hrel_nodes rhs SAU.check_nbelongsto_dnode SAU.check_nbelongsto_vnode SAU.check_neq_hrelnode keep_ptrs keep_ptrs (hps@keep_unk_hps) in
     (*find which formula contains root args*)
     let _ = Debug.ninfo_pprint ("lpdef: " ^ (Cprinter.prtt_string_of_formula plhs)) no_pos in
     let _ = Debug.ninfo_pprint ("rpdef: " ^ (Cprinter.prtt_string_of_formula prhs)) no_pos in
     let _ = Debug.ninfo_pprint ("args: " ^ (!CP.print_svl args)) no_pos in
     let _ = Debug.ninfo_pprint ("rec_args: " ^ (!CP.print_svl rec_args)) no_pos in
     if dir then (*args in lhs*)
       begin
           let ptrs1 = CF.get_ptrs_f plhs in
           let ptrs2 = SAU.find_close ptrs1 eqs in
           let _ = Debug.ninfo_pprint ("ptrs2: " ^ (!CP.print_svl ptrs2)) no_pos in
           if CP.mem_svl (List.hd args) ptrs2 then
             [(hrel , args, (* CP.intersect_svl args *) unk_svl ,plhs, Some plhs, Some prhs)]
             (* (hrel , args, CP.intersect_svl args unk_svl ,plhs, Some prhs, Some plhs) *)
           else if CP.mem_svl (List.hd rec_args) ptrs1 then
             [(hrel , rec_args, (* CP.intersect_svl rec_args *) unk_svl ,plhs, Some plhs, Some prhs)]
           else []
       end
     else
       let ptrs1 = CF.get_ptrs_f prhs in
        let ptrs2 = SAU.find_close ptrs1 eqs in
       let _ = Debug.ninfo_pprint ("ptrs2: " ^ (!CP.print_svl ptrs2)) no_pos in
       if CP.mem_svl (List.hd args) ptrs2 then
         [(hrel , args, (* CP.intersect_svl args *) unk_svl ,plhs, Some plhs, Some prhs)]
       else if CP.mem_svl (List.hd rec_args) ptrs1 then
         [(hrel , rec_args, (* CP.intersect_svl args *) unk_svl ,plhs, Some plhs, Some prhs)]
         (* (hrel , rec_args, CP.intersect_svl rec_args unk_svl ,plhs, Some prhs, Some plhs) *)
       else []
  in
  (* let _ = Debug.info_pprint ("def_ptrs: " ^ (!CP.print_svl def_ptrs)) no_pos in *)
  let rec_pdefs =
    let undef_args = SAU.lookup_undef_args args [] (def_ptrs) in
    if undef_args = [] then
      let local_rec_defs = (build_partial_def ([hrel],args@rec_args)) in
      local_rec_defs
    else
      let keep_args_in_rem = CP.diff_svl (args@rec_args) undef_args in
      let ls_par_match =  [([hrel], CP.remove_dups_svl (keep_args_in_rem), undef_args)] in
        (*find all hrel in rhs such that cover the same set of args*)
      let r_selected_hrels = find_hrels_w_same_set_args other_side_hrels ls_par_match [] in
      let local_rec_pdefs = List.concat (List.map build_partial_def r_selected_hrels) in
      local_rec_pdefs
  in
  let _ = DD.ninfo_pprint ("  rec partial defs: \n" ^
              (let pr = pr_list_ln SAU.string_of_par_def_w_name in pr (rec_pdefs)) ) no_pos in
  rec_pdefs

let collect_par_defs_recursive_hp prog lhs rhs (hrel, args) args2  other_side_hrels def_ptrs hrel_vars
      eq hd_nodes hv_nodes dir unk_hps unk_svl predef=
  let pr1 = !CP.print_svl in
  let pr2 = (pr_pair !CP.print_sv pr1) in
  let pr3 = pr_list_ln SAU.string_of_par_def_w_name in
  Debug.no_2 "collect_par_defs_recursive_hp" pr2 pr1 pr3
      (fun  _ _ -> collect_par_defs_recursive_hp_x prog lhs rhs (hrel, args)
        args2 other_side_hrels def_ptrs hrel_vars eq hd_nodes hv_nodes dir unk_hps unk_svl predef) (hrel, args) def_ptrs

let collect_par_defs_unk_hps_x lhs rhs lunk_hp_arg runk_hp_arg=
  let rec lhelper (hp1, args1) rls=
    match rls with
      | [] -> []
      | (hp2, args2)::ss -> if SAU.eq_spec_var_order_list args1 args2 then
            [(hp1, args1),(hp2, args2)]
          else lhelper (hp1, args1) ss
  in
  let ls_matched = List.concat (List.map (fun lhp_args -> lhelper lhp_args runk_hp_arg) lunk_hp_arg) in
  if ls_matched = [] then ([],lhs,rhs)
  else
    begin
        let build_par_def ((lhp,largs),(rhp,rargs))=
          let plhs = CF.formula_of_heap (SAU.mkHRel lhp largs no_pos) no_pos in
          let prhs = CF.formula_of_heap (SAU.mkHRel rhp rargs no_pos) no_pos in
          ([(lhp,largs,largs ,plhs, None, Some prhs)],lhp,rhp)
        in
        let tr3 = List.map build_par_def ls_matched in
        let pdefs,lhps,rhps = split3 tr3 in
        let nlhs,_ = CF.drop_hrel_f lhs lhps in
        let nrhs,_ = CF.drop_hrel_f rhs rhps in
        (*for recursive, we keep exactly unkhps*)
        (* let inter = CP.intersect_svl lhps rhps in *)
        (* let rec_lhps = CP.diff_svl lhps inter in *)
        (* let rec_rhps = CP.diff_svl rhps inter in *)
        (* let rec_lhs,_ = CF.drop_hrel_f lhs rec_lhps in *)
        (* let rec_rhs,_ = CF.drop_hrel_f rhs rec_rhps in *)
        (List.concat pdefs, nlhs, nrhs)
    end

let collect_par_defs_unk_hps lhs rhs lunk_hp_arg runk_hp_arg=
  let pr1 = !CP.print_svl in
  let pr2 = pr_list (pr_pair !CP.print_sv pr1) in
  let pr3 = pr_list_ln SAU.string_of_par_def_w_name in
  let pr4 = Cprinter.prtt_string_of_formula in
  Debug.no_2 "collect_par_defs_unk_hps" pr2 pr2 (pr_triple pr3 pr4 pr4)
      (fun  _ _ -> collect_par_defs_unk_hps_x lhs rhs lunk_hp_arg runk_hp_arg) lunk_hp_arg runk_hp_arg

let rec collect_par_defs_one_constr_new_x prog constr =
  let lhs, rhs = constr.CF.hprel_lhs, constr.CF.hprel_rhs in
  DD.ninfo_pprint ">>>>>> collect partial def for hp_rel <<<<<<" no_pos;
  DD.ninfo_pprint (" hp_rel: " ^ (Cprinter.string_of_hprel constr)) no_pos;
  let rec get_rec_pair_hps ls (hrel1, arg1)=
    match ls with
      | [] -> []
      | (hrel2, arg2)::ss -> if CP.eq_spec_var hrel1 hrel2 then [((hrel1, arg1), (hrel2, arg2))]
          else get_rec_pair_hps ss (hrel1, arg1)
  in
  let cs_predef_ptrs = constr.CF.predef_svl@constr.CF.unk_svl in
  (*find all defined pointer (null, nodes) and recursive defined parameters (HP, arg)*)
  let l_def_ptrs, l_hp_args_name,l_dnodes, l_vnodes,leqs = SAU.find_defined_pointers prog lhs cs_predef_ptrs in
  (* let _ = DD.info_pprint ("   l_def_ptrs " ^(!CP.print_svl l_def_ptrs)) no_pos in *)
  (*should mkAnd lhs*rhs?*)
  let r_def_ptrs, r_hp_args_name, r_dnodes, r_vnodes, reqs = find_defined_pointers_two_formulas prog lhs rhs cs_predef_ptrs in
  (*remove dup hp needs to be processed*)
  let filter_unk_hps unk_hpargs unk_svl (hp,args)=
    let rec helper unk_ls=
      match unk_ls with
        | [] -> true
        | (hp1,_)::hps ->
            if CP.eq_spec_var hp hp1 then false
            else
              if CP.diff_svl args unk_svl = [] then false
              else
                helper hps
    in
    helper unk_hpargs
  in
  let lhps = (Gen.BList.remove_dups_eq SAU.check_hp_arg_eq (l_hp_args_name)) in
  (* let lnon_unk_hps= Gen.BList.difference_eq SAU.check_simp_hp_eq lhps constr.CF.unk_hps in *)
  let lnon_unk_hps= List.filter (filter_unk_hps constr.CF.unk_hps constr.CF.unk_svl) lhps in
  let rhps = (Gen.BList.remove_dups_eq SAU.check_hp_arg_eq (r_hp_args_name)) in
  (* let rnon_unk_hps= Gen.BList.difference_eq SAU.check_simp_hp_eq rhps constr.CF.unk_hps in *)
  let rnon_unk_hps= List.filter (filter_unk_hps constr.CF.unk_hps constr.CF.unk_svl) rhps in
  let total_hps = (Gen.BList.remove_dups_eq SAU.check_simp_hp_eq (lhps@rhps)) in
  (*CASE 0: matching lhs-rhs: now unkown hps only*)
  let lunk_hps = Gen.BList.intersect_eq SAU.check_hp_arg_eq lhps constr.CF.unk_hps in
  let runk_hps = Gen.BList.intersect_eq SAU.check_hp_arg_eq rhps constr.CF.unk_hps in
  let unk_pdefs,nlhs,nrhs = collect_par_defs_unk_hps lhs rhs lunk_hps runk_hps in
  (*CASE 1: formula --> hp*)
  let lpredef = SAU.find_close (l_def_ptrs@cs_predef_ptrs) leqs in
  let rpredef = SAU.find_close (r_def_ptrs) (leqs@reqs) in
  let lpdefs = List.concat (List.map (fun hrel ->
     collect_par_defs_one_side_one_hp prog nlhs nrhs hrel lpredef rpredef rnon_unk_hps leqs (l_dnodes@r_dnodes) (l_vnodes@r_vnodes) constr.CF.unk_hps constr.CF.unk_svl constr.CF.predef_svl) lnon_unk_hps) in
  let rpdefs = List.concat (List.map (fun hrel ->
      collect_par_defs_one_side_one_hp_rhs prog nlhs nrhs hrel lpredef lnon_unk_hps
          (leqs@reqs) (l_dnodes@r_dnodes) (l_vnodes@r_vnodes) constr.CF.unk_hps constr.CF.unk_svl constr.CF.predef_svl)
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
      (*DONT DROP!! ll-next3.drop constraints that have one hp after collect partial def*)
      (* let new_constrs= *)
      (*   (\* let unk_hps = List.map (fun (hp,_) -> hp) (lnon_unk_hps@rnon_unk_hps) in *\) *)
      (*   if (List.length total_hps <=1) && (List.length (lnon_unk_hps@rnon_unk_hps)) = 0 then [] *)
      (*   else [constr] *)
      (* in *)
      ([constr], [])
    else
      let helper ((hp1,args1),(hp2,args2))=
        (*recompute defined ptrs*)
         let l_def_ptrs, _,_, _,_ = SAU.find_defined_pointers prog lhs (args2@cs_predef_ptrs) in
         (*should mkAnd lhs*rhs?*)
         let r_def_ptrs, _, _, _, _ = find_defined_pointers_two_formulas prog lhs rhs (args2@cs_predef_ptrs) in
        let r1 = collect_par_defs_recursive_hp prog nlhs nrhs (hp1,args1) args2 lnon_unk_hps
          (l_def_ptrs@r_def_ptrs@args2@cs_predef_ptrs) (l_hp_args_name@r_hp_args_name) (leqs@reqs)
          (l_dnodes@r_dnodes) (l_vnodes@r_vnodes) true constr.CF.unk_hps
          constr.CF.unk_svl constr.CF.predef_svl
        in
        if r1 = [] then
          (*recompute defined ptrs*)
          let l_def_ptrs, _,_, _,_ = SAU.find_defined_pointers prog lhs (args1@cs_predef_ptrs) in
         (*should mkAnd lhs*rhs?*)
          let r_def_ptrs, _, _, _, _ = find_defined_pointers_two_formulas prog lhs rhs (args1@cs_predef_ptrs) in
          collect_par_defs_recursive_hp prog nlhs nrhs (hp2,args2) args1 lnon_unk_hps
              (l_def_ptrs@r_def_ptrs@args1@cs_predef_ptrs) (l_hp_args_name@r_hp_args_name) (leqs@reqs)
              (l_dnodes@r_dnodes) (l_vnodes@r_vnodes) false constr.CF.unk_hps
              constr.CF.unk_svl constr.CF.predef_svl
        else r1
      in
      let rec_pdefs = List.concat (List.map helper rec_pair_hps) in
      (*if constr contains only one rec hp -drop it*)
      let new_constrs=
        let num_hp = (List.length (* (Gen.BList.remove_dups_eq SAU.check_simp_hp_eq (lnon_unk_hps@rnon_unk_hps)) *) total_hps) in
        let num_pair_rec_hp = (List.length rec_pair_hps) in
        if (num_hp - num_pair_rec_hp) < 1 then []
        else [constr]
      in
      (new_constrs, rec_pdefs)
  in
  let hppdefs = lpdefs @ rpdefs @ rec_pdefs @ unk_pdefs in
  (* let unk_hps = List.map (fun (hp,_) -> hp) constr.CF.unk_hps in *)
  (* let hppdefs1 = List.filter (fun (_,_,_,l,r)-> (SAU.is_empty_wop l) || (SAU.is_empty_wop r)) hppdefs in *)
  (new_constrs,hppdefs)

and collect_par_defs_one_constr_new prog constr =
  let pr1 = Cprinter.string_of_hprel in
  let pr2 = pr_list_ln SAU.string_of_par_def_w_name in
  let pr4 = pr_list_ln pr1 in
  let pr3 = (pr_pair pr4 pr2) in
  Debug.no_1 "collect_par_defs_one_constr_new" pr1 pr3
      (fun _ -> collect_par_defs_one_constr_new_x prog constr) constr

(* - collect partial def
  - simplify: remove constaints which have <= 1 hp
*)
let rec collect_partial_definitions_x prog constrs: (CF.hprel list * SAU.par_def_w_name list) =
  let simpl_constrs, par_defs = List.split (List.map (collect_par_defs_one_constr_new prog) constrs) in
  (List.concat simpl_constrs, List.concat par_defs)

and collect_partial_definitions prog constrs: (CF.hprel list * SAU.par_def_w_name list) =
  let pr1 = pr_list_ln Cprinter.string_of_hprel in
  let pr2 =  pr_list_ln SAU.string_of_par_def_w_name in
   Debug.no_1 "collect_partial_definitions" pr1 (pr_pair pr1 pr2)
 (fun _ -> collect_partial_definitions_x prog constrs) constrs


(*========SIMPLIFICATION============*)
let rec simplify_one_constr prog unk_hps constr=
  begin
      let (lhs, rhs) = constr.CF.hprel_lhs,constr.CF.hprel_rhs in
      match lhs,rhs with
        | CF.Base lhs_b, CF.Base rhs_b ->
            begin
                let l,r,matched = simplify_one_constr_b prog unk_hps lhs_b rhs_b in
                 (* if l.CF.formula_base_heap = CF.HEmp && *)
                 (*   (MCP.isConstMTrue l.CF.formula_base_pure) then *)
                if SAU.is_unk_f (CF.Base l) || SAU.is_unk_f (CF.Base r) ||
                (SAU.is_empty_f (CF.Base l) && SAU.is_empty_f (CF.Base r)) then
                  let _ = DD.ninfo_pprint (" input: " ^(Cprinter.prtt_string_of_formula_base lhs_b) ^ " ==> " ^
                                                  (Cprinter.prtt_string_of_formula_base rhs_b)) no_pos in
                  let _ =  DD.ninfo_pprint (" output: drop") no_pos in
                   []
                else
                  (*it may subst into some unk_hps, should detect it*)
                  let hp_args = (CF.get_HRels l.CF.formula_base_heap)@
                    (CF.get_HRels r.CF.formula_base_heap) in
                  let hp_args1 = Gen.BList.remove_dups_eq SAU.check_simp_hp_eq
                    hp_args in
                  (*get hp that all args are unk*)
                  let unk_hp_args = List.filter (fun (hp,args) ->
                  (Gen.BList.difference_eq CP.eq_spec_var args constr.CF.unk_svl) = []) hp_args1 in
                  let new_constr = {constr with CF.predef_svl = constr.CF.predef_svl@matched;
                      CF.unk_hps = Gen.BList.remove_dups_eq SAU.check_simp_hp_eq
                          (constr.CF.unk_hps@unk_hp_args);
                       CF.hprel_lhs = CF.Base l;
                       CF.hprel_rhs = CF.Base r;
                                   }
                  in
                  let _ =  DD.ninfo_pprint (" simplify: new cs:" ^ ( Cprinter.string_of_hprel new_constr)) no_pos in
                  [new_constr]
              end
        | _ -> report_error no_pos "sa.simplify_one_constr"
  end

and simplify_one_constr_b_x prog unk_hps lhs_b rhs_b=
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
      (*omit: not remove unk_hps in lhs*)
      (* let hrels1 = (List.filter (fun hp -> not(CP.mem_svl hp unk_hps)) hrels) in *)
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

and simplify_one_constr_b prog unk_hps lhs_b rhs_b=
  let pr = Cprinter.prtt_string_of_formula_base in
  Debug.no_2 "simplify_one_constr_b" pr pr (pr_triple pr pr !CP.print_svl)
      (fun _ _ -> simplify_one_constr_b_x prog unk_hps lhs_b rhs_b) lhs_b rhs_b

let simplify_constrs_x prog unk_hps constrs=
  List.concat (List.map (simplify_one_constr prog unk_hps) constrs)

let simplify_constrs prog unk_hps constrs=
   let pr = pr_list_ln (Cprinter.string_of_hprel) in
  Debug.no_1 "simplify_constrs" pr pr
      (fun _ -> simplify_constrs_x prog unk_hps constrs) constrs
(*===========END SIMPLIFICATION===========*)

(*========subst==============*)
(*****************)
let rec check_unsat_x f0=
  let rec helper f=
    match f with
      | CF.Base fb -> check_inconsistency fb.CF.formula_base_heap fb.CF.formula_base_pure
      | CF.Or orf -> (helper orf.CF.formula_or_f1) || (helper orf.CF.formula_or_f2)
      | CF.Exists fe ->
        (*may not correct*)
          check_inconsistency fe.CF.formula_exists_heap fe.CF.formula_exists_pure
  in
  helper f0

and check_unsat f=
  let pr1 = Cprinter.prtt_string_of_formula in
  let pr2 = string_of_bool in
  Debug.no_1 "check_unsat" pr1 pr2
      (fun _ -> check_unsat_x f) f

and check_inconsistency hf mixf=
  let new_mf = CF.xpure_for_hnodes hf in
  let cmb_mf = MCP.merge_mems mixf new_mf true in
  not (TP.is_sat_raw cmb_mf)

let check_heap_inconsistency unk_hpargs f0=
  let do_check hf=
    let hpargs = CF.get_HRels hf in
    (*remove dangling*)
    let hpargs1 = List.filter
      (fun (hp0,args0) ->
          not(Gen.BList.mem_eq SAU.check_hp_arg_eq (hp0,args0) unk_hpargs))
      hpargs
    in
    Gen.BList.check_dups_eq SAU.eq_spec_var_order_list (List.map snd hpargs1)
  in
  let rec helper f=
    match f with
      | CF.Base fb -> do_check fb.CF.formula_base_heap
      | CF.Or orf -> (helper orf.CF.formula_or_f1) || (helper orf.CF.formula_or_f2)
      | CF.Exists fe ->
        (*may not correct*)
          do_check fe.CF.formula_exists_heap
  in
  helper f0

(* let get_dups_hprel f0 f1= *)
(*   let hpargs0 =CF.get_HRels_f f0 in *)
(*   let hpargs1 =CF.get_HRels_f f1 in *)
(*   let ls_args0 = List.map snd hpargs0 in *)
(*   let dups_hps = List.concat (List.map (fun (hp,args) -> *)
(*       if Gen.BList.mem_eq SAU.eq_spec_var_order_list  args ls_args0 then [hp] else []) *)
(*                                   hpargs1) *)
(*   in *)
(*   dups_hps *)

(*****************)

let subst_one_cs_w_one_partial_def cs_unk_hps f (hp_name, args, def_f)=
(*drop hrel and get current args*)
  let new_f, argsl = CF.drop_hrel_f f [hp_name] in
  let do_subst newf eargs=
    (*generate a susbst*)
    let args2= (List.fold_left List.append [] (List.map CP.afv eargs)) in
    DD.ninfo_pprint ("   subst " ^ (Cprinter.prtt_string_of_formula def_f) ^ " ==> " ^ (!CP.print_sv hp_name)
                     ^ (!CP.print_svl args)) no_pos;
    (* DD.ninfo_pprint ("   into " ^ (Cprinter.prtt_string_of_formula f)) no_pos; *)
    let subst = (List.combine args args2) in
    let def_f_subst = CF.subst subst def_f in
        (* DD.ninfo_pprint ("   body after subst " ^ (Cprinter.prtt_string_of_formula def_f_subst)) no_pos; *)
        (*should remove duplicate*)
    let svl1 = CF.get_all_sv_f newf in
    let svl2 = CF.get_all_sv_f def_f_subst in
    let intersect = CP.intersect svl1 svl2 in
        (* DD.ninfo_pprint ("   intersect: " ^ (!CP.print_svl intersect)) no_pos; *)
    let def_f1 =
      if intersect = [] then def_f_subst else
            (* let diff = Gen.BList.difference_eq CP.eq_spec_var svl2 svl1 in *)
        match def_f_subst with
          | CF.Base fb ->
              CF.Base {fb with CF.formula_base_heap = CF.drop_data_view_hrel_nodes_hf fb.CF.formula_base_heap
                      SAU.select_dnode SAU.select_vnode
                      SAU.select_hrel intersect intersect (intersect(* @(get_dups_hprel newf def_f_subst) *) )}
          | _ -> report_error no_pos "sa.subst_one_cs_w_one_partial_def"
    in
        (*combi def_f_subst into newf*)
    let newf1 = CF.mkStar newf def_f1 CF.Flow_combine (CF.pos_of_formula newf) in
    (*check contradiction*)
    let susbt_f=
      if check_unsat newf1 || check_heap_inconsistency cs_unk_hps newf1 then
        let _ = DD.ninfo_pprint ("     contradiction found after subst.") no_pos in
        f
      else newf1
    in
        (* DD.ninfo_pprint ("   subst out: " ^ (Cprinter.prtt_string_of_formula susbt_f)) no_pos; *)
    susbt_f
  in
  match argsl with
    | [] -> f
    | (*[eargs]*) ls_eargs -> List.fold_left do_subst new_f ls_eargs
       (*  begin *)
      (*       (\*to subst*\) *)
      (*   (\*generate a susbst*\) *)
      (*   let args2= (List.fold_left List.append [] (List.map CP.afv eargs)) in *)
      (*   DD.ninfo_pprint ("   subst " ^ (Cprinter.prtt_string_of_formula def_f) ^ " ==> " ^ (!CP.print_sv hp_name) *)
      (*                   ^ (!CP.print_svl args)) no_pos; *)
      (*   (\* DD.ninfo_pprint ("   into " ^ (Cprinter.prtt_string_of_formula f)) no_pos; *\) *)
      (*   let subst = (List.combine args args2) in *)
      (*   let def_f_subst = CF.subst subst def_f in *)
      (*   (\* DD.ninfo_pprint ("   body after subst " ^ (Cprinter.prtt_string_of_formula def_f_subst)) no_pos; *\) *)
      (*   (\*should remove duplicate*\) *)
      (*   let svl1 = CF.fv newf in *)
      (*   let svl2 = CF.fv def_f_subst in *)
      (*   let intersect = CP.intersect svl1 svl2 in *)
      (*   (\* DD.ninfo_pprint ("   intersect: " ^ (!CP.print_svl intersect)) no_pos; *\) *)
      (*   let def_f1 = *)
      (*     if intersect = [] then def_f_subst else *)
      (*       (\* let diff = Gen.BList.difference_eq CP.eq_spec_var svl2 svl1 in *\) *)
      (*       match def_f_subst with *)
      (*         | CF.Base fb -> *)
      (*             CF.Base {fb with CF.formula_base_heap = CF.drop_data_view_hrel_nodes_hf fb.CF.formula_base_heap *)
      (*                     SAU.select_dnode SAU.select_vnode *)
      (*                     SAU.select_hrel intersect intersect intersect} *)
      (*         | _ -> report_error no_pos "sa.subst_one_cs_w_one_partial_def" *)
      (*   in *)
      (*   (\*combi def_f_subst into newf*\) *)
      (*   let newf1 = CF.mkStar newf def_f1 CF.Flow_combine (CF.pos_of_formula newf) in *)
      (*   (\*check contradiction*\) *)
      (*   let susbt_f= *)
      (*     if check_unsat newf1 then *)
      (*       let _ = DD.ninfo_pprint ("     contradiction found after subst.") no_pos in *)
      (*       f *)
      (*     else newf1 *)
      (*   in *)
      (*   (\* DD.ninfo_pprint ("   subst out: " ^ (Cprinter.prtt_string_of_formula susbt_f)) no_pos; *\) *)
      (*   susbt_f *)
      (* end *)
    (* | _ -> report_error no_pos "sa.subst_one_cs_w_one_partial_def: should be a singleton" *)

(*
each constraints, apply lhs and rhs. each partial def in one side ==> generate new constraint

 ldef --> hp: subst all hp in lhs with ldef
 hp --> rdef: subst all hp in rhs with rdef
*)

let elim_irr_rhs_hps lhs rhs=
  let l_svl = CF.fv lhs in
  let r_hpargs = CF.get_HRels_f rhs in
  let r_hps = List.map fst r_hpargs in
  let rhs1,_ =  CF.drop_hrel_f rhs r_hps in
  let r_svl = CF.fv rhs1 in
  let used_svl = (l_svl@r_svl) in
  let keep_hps = List.concat (List.map (SAU.get_intersect_hps used_svl) r_hpargs) in
  let rhs2,_ =  CF.drop_hrel_f rhs (CP.diff_svl (CP.remove_dups_svl r_hps) (CP.remove_dups_svl keep_hps)) in
  rhs2

let subst_one_cs_w_partial_defs ldefs rdefs constr=
  let lhs,rhs = constr.CF.hprel_lhs,constr.CF.hprel_rhs in
  DD.ninfo_pprint ("    input: " ^ (Cprinter.string_of_hprel constr)) no_pos;
  let l_one_hps = CF.check_and_get_one_hpargs lhs in
  let r_one_hps = CF.check_and_get_one_hpargs rhs in
  match l_one_hps,r_one_hps with
    | [_],[_] -> constr
    | _ ->
  (*subst lhs*)
        DD.ninfo_pprint "  subst lhs" no_pos;
        let lhs1 = List.fold_left (subst_one_cs_w_one_partial_def constr.CF.unk_hps) lhs ldefs in
  (*subst rhs*)
        DD.ninfo_pprint "  subst rhs" no_pos;
        let rhs1 = List.fold_left (subst_one_cs_w_one_partial_def constr.CF.unk_hps) rhs rdefs in
  (*rhs contradict with lhs?*)
        let cmbf = CF.mkStar lhs1 rhs1 CF.Flow_combine no_pos in
        let lhs2,rhs2 =
          if check_unsat cmbf then
            let _ = DD.ninfo_pprint ("      contradiction found between lhs and rhs") no_pos in
            (lhs,rhs)
          else
            (*remove redudant*)
            (lhs1,elim_irr_rhs_hps lhs1 rhs1)
        in
  (* let _ = DD.info_pprint ("    out: " ^(Cprinter.prtt_string_of_formula lhs2) ^ " ==> " ^ *)
  (*                                (Cprinter.prtt_string_of_formula rhs2)) no_pos in *)
        let new_cs ={constr with CF.hprel_lhs = lhs2;
            CF.hprel_rhs = rhs2} in
        let _ = DD.ninfo_pprint ("    output: " ^ (Cprinter.string_of_hprel new_cs)) no_pos in
        new_cs

let subst_cs_w_partial_defs_x hp_constrs par_defs=
  (*partition non-recursive partial defs: lhs set and rhs set*)
  let rec partition_par_defs pdefs lpdefs rpdefs=
    match pdefs with
      | [] -> (lpdefs, rpdefs)
      | (hp_name, hp_args,_, _, oldef, ordef)::ps ->
          (
              match oldef, ordef with
                | Some _ ,Some _ -> (*recursive par def -->currently omit*)
                    partition_par_defs ps lpdefs rpdefs
                | Some f1, None -> (*lhs case*)
                    let new_lpdef = if SAU.is_empty_heap_f f1 then [] else
                      [(hp_name, hp_args, f1)] in
                    partition_par_defs ps (lpdefs@new_lpdef) rpdefs
                | None, Some f2 -> (*rhs case*)
                    let new_rpdef = if SAU.is_empty_heap_f f2 then [] else
                          [(hp_name, hp_args, f2)] in
                    partition_par_defs ps lpdefs (rpdefs@new_rpdef)
                | None, None -> (*can not happen*)
                    report_error no_pos "sa.partition_par_defs: can not happen"
          )
  in
  let (ldefs, rdefs) = partition_par_defs par_defs [] [] in
  List.map (subst_one_cs_w_partial_defs ldefs rdefs) hp_constrs

let subst_cs_w_partial_defs hp_constrs par_defs=
  let pr1 = pr_list_ln Cprinter.string_of_hprel in
  let pr2 = pr_list_ln SAU.string_of_par_def_w_name in
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
                              CF.unk_hps = Gen.BList.remove_dups_eq SAU.check_hp_arg_eq
                                  ((List.map (fun (hp,args) -> (hp,CP.subst_var_list lhs_ss args)) cs1.CF.unk_hps)@
                                          (List.map (fun (hp,args) -> (hp,CP.subst_var_list rhs_ss args)) cs2.CF.unk_hps));
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
  let pr2 = pr_list_ln SAU.string_of_par_def_w_name in
  Debug.no_2 "subst_cs" pr1 pr2 pr1
      (fun _ _ -> subst_cs_x hp_constrs par_defs) hp_constrs par_defs

(*===========end subst============*)
(*========generalization==========*)
(*for par_defs*)
let generalize_one_hp_x prog non_ptr_unk_hps unk_hps par_defs=
  (*collect definition for each partial definition*)
  let obtain_and_norm_def args0 (a1,args,f,unk_args)=
    (*normalize args*)
    let subst = List.combine args args0 in
    let f1 = (CF.subst subst f) in
    let unk_args1 = List.map (CP.subs_one subst) unk_args in
    (* (\*root = p && p:: node<_,_> ==> root = p& root::node<_,_> & *\) *)
    (* (\*make explicit root*\) *)
    (* let r = *)
    (*   if args0 = [] then report_error no_pos "sa.obtain_and_norm_def: hp has at least one arg" *)
    (*   else (List.hd args0) *)
    (* in *)
    (* let f2 = SAU.mk_expl_root r f1 in *)
    (f1,unk_args1)
  in
  DD.ninfo_pprint ">>>>>> generalize_one_hp: <<<<<<" no_pos;
  if par_defs = [] then [] else
    begin
        let hp, args, _,_ = (List.hd par_defs) in
        (*find the root: ins2,ins3: root is the second, not the first*)
        let args0 = List.map (CP.fresh_spec_var) args in
    (* DD.ninfo_pprint ((!CP.print_sv hp)^"(" ^(!CP.print_svl args) ^ ")") no_pos; *)
        let defs,ls_unk_args = List.split (List.map (obtain_and_norm_def args0) par_defs) in
        let r,non_r_args = SAU.find_root args0 defs in
        (*make explicit root*)
        let defs0 = List.map (SAU.mk_expl_root r) defs in
        let unk_svl = CP.remove_dups_svl (List.concat (ls_unk_args)) in
  (*normalize linked ptrs*)
        let defs1 = SAU.norm_hnodes args0 defs0 in
        (*remove unkhp of non-node*)
        let defs2 = (* List.map remove_non_ptr_unk_hp *) defs1 in
  (*remove duplicate*)
        let defs3 = Gen.BList.remove_dups_eq (fun f1 f2 -> SAU.check_relaxeq_formula f1 f2) defs2 in
        if CP.mem_svl hp unk_hps then
          SAU.mk_unk_hprel_def hp args0 defs3 no_pos
        else
          let defs4 = SAU.remove_equiv_wo_unkhps hp unk_hps defs3 in
   (*remove duplicate with self-recursive*)
        (* let base_case_exist,defs4 = SAU.remove_dups_recursive hp args0 unk_hps defs3 in *)
  (*find longest hnodes common for more than 2 formulas*)
  (*each hds of hdss is def of a next_root*)
          let defs = SAU.get_longest_common_hnodes_list prog unk_hps unk_svl hp r non_r_args args0 defs4 in
          defs
    end

let generalize_one_hp prog non_ptr_unk_hps unk_hps par_defs=
  let pr1 = pr_list_ln SAU.string_of_par_def_w_name_short in
  let pr2 = pr_list_ln (pr_pair !CP.print_sv Cprinter.string_of_hp_rel_def) in
  Debug.no_1 "generalize_one_hp" pr1 pr2
      (fun _ -> generalize_one_hp_x prog non_ptr_unk_hps unk_hps par_defs) par_defs

let get_pdef_body_x unk_hps post_hps (a1,args,unk_args,a3,olf,orf)=
  let exchane_unk_post hp1 args f unk_args=
    let hpargs2 = CF.get_HRels_f f in
    match hpargs2 with
      | [(hp2,args2)] ->
          if CP.mem_svl hp2 unk_hps && (CP.mem_svl hp2 post_hps) &&
            SAU.eq_spec_var_order_list args args2 then
            let new_f = SAU.mkHRel_f hp1 args (CF.pos_of_formula f) in
            [(hp2,args,new_f,unk_args)]
          else [(hp1,args,f,unk_args)]
      | _ -> [(hp1,args,f,unk_args)]
  in
  match olf,orf with
    | Some f, None -> [(a1,args,f,unk_args)]
    | None, Some f -> if CP.mem_svl a1 unk_hps && not (CP.mem_svl a1 post_hps) then
          exchane_unk_post a1 args f unk_args
        else
          [(a1,args,f,unk_args)]
    | Some f1, Some f2 ->
        let f_body=
          let hps1 = CF.get_hp_rel_name_formula f1 in
          let hps2 = CF.get_hp_rel_name_formula f2 in
          if CP.intersect_svl hps1 hps2 <> [] then
            (*recurive case*)
            if CF.is_HRel_f f1 then f2 else f1
          else SAU.compose_subs f2 f1 (CF.pos_of_formula f2)
        in
        if SAU.is_trivial f_body (a1,args) then [] else
          [(a1,args,f_body,unk_args)]
    | None, None -> report_error no_pos "sa.obtain_def: can't happen 2"

let get_pdef_body unk_hps post_hps (a1,args,unk_args,a3,olf,orf)=
  let pr1 = SAU.string_of_par_def_w_name in
  let pr2 = pr_list (pr_quad !CP.print_sv !CP.print_svl Cprinter.prtt_string_of_formula !CP.print_svl) in
  Debug.no_1 "get_pdef_body" pr1 pr2
      (fun _ -> get_pdef_body_x unk_hps post_hps (a1,args,unk_args,a3,olf,orf) )(a1,args,unk_args,a3,olf,orf)

(*=========SUBST DEF and PARDEF FIX==========*)
(*
  divide hp into three groups:
  - independent - ready for genalizing
  - dependent:
      - depend on non-recursive groups: susbst
      - depend on recusive groups: wait
*)
let pardef_subst_fix_x prog unk_hps groups=
  let get_hp_from_grp grp=
    match grp with
      | (hp,_,_,_)::_ -> hp
      | [] -> report_error no_pos "sa.pardef_subst_fix_x: 1"
  in
  let is_rec_pardef (hp,_,f,_)=
    let hps = CF.get_hp_rel_name_formula f in
    (CP.mem_svl hp hps)
  in
  let is_independ_pardef (hp,_,f,_) =
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
  let get_succ_hps_pardef (_,_,f,_)=
    (CF.get_HRels_f f)
  in
  let comp_rec_grps_fix_x rec_ind_grps grps=
    let g_rec_hps = List.map get_hp_from_grp rec_ind_grps in
    let check_rec_grp_ext grp total_rec_hps=
      if is_rec_group grp then
        let hp = get_hp_from_grp grp in
        [hp]
      else
        (*if it depends on a rec, it is also a rec*)
        let succ_hp_args = List.concat (List.map get_succ_hps_pardef grp) in
        if CP.intersect_svl (List.map fst succ_hp_args) total_rec_hps = [] then
          []
        else [get_hp_from_grp grp]
    in
    let rec process_one_loop_helper rem_grps l_rec_grps l_rec_hps nrec_grps=
      match rem_grps with
        | [] -> (l_rec_grps,l_rec_hps,nrec_grps)
        | grp::tl ->
            let rec_hp = check_rec_grp_ext grp l_rec_hps in
            if rec_hp = [] then
              process_one_loop_helper tl l_rec_grps l_rec_hps (nrec_grps@[grp])
            else
              process_one_loop_helper tl (l_rec_grps@[grp]) (l_rec_hps@rec_hp) nrec_grps
    in
    let rec loop_helper grps rec_grps rec_hps=
      let new_rec_grps, new_rec_hps,new_poss_nrec_grps = process_one_loop_helper grps rec_grps rec_hps [] in
      if CP.diff_svl new_rec_hps rec_hps = [] then
        (*nothing new*)
        (new_rec_grps, new_poss_nrec_grps)
      else
        loop_helper new_poss_nrec_grps new_rec_grps new_rec_hps
    in
    loop_helper grps [] []
  in
  let comp_rec_grps_fix rec_ind_grps grps=
    let pr1 = pr_list_ln (pr_list_ln SAU.string_of_par_def_w_name_short) in
    Debug.no_1 "comp_rec_grps_fix" pr1 (pr_pair pr1 pr1)
        (fun _ -> comp_rec_grps_fix_x rec_ind_grps grps) grps
  in
  let process_dep_group grp rec_hps nrec_grps=
    (* let (hp,args,_) = List.hd grp in *)
    (* DD.ninfo_pprint ("       process_dep_group hp: " ^ (!CP.print_sv hp)) no_pos; *)
    (* let succ_hp_args = List.concat (List.map get_succ_hps_pardef grp) in *)
    (*remove dups*)
    (* let succ_hp_args = Gen.BList.remove_dups_eq SAU.check_simp_hp_eq succ_hp_args in *)
    (*get succ hp names only*)
    (* let succ_hps = fst (List.split succ_hp_args) in *)
    (* DD.ninfo_pprint ("       process_dep_group succ_hps: " ^ (!CP.print_svl succ_hps)) no_pos; *)
    (*remove itself hp and unk_hps*)

    (* let succ_hps1 = List.filter (fun hp1 -> not (CP.eq_spec_var hp1 hp) && *)
    (*     not (CP.mem_svl hp1 unk_hps)) succ_hps in *)

    (* DD.info_pprint ("       process_dep_group succ_hps1: " ^ (!CP.print_svl succ_hps1)) no_pos; *)
    (* if (CP.intersect succ_hps1 rec_hps) = [] then *)
      (*not depends on any recursive hps, susbt it*)
      let ters,fss = List.split (List.map (SAU.succ_susbt prog nrec_grps unk_hps false) grp) in
      (*check all is false*)
      (* let pr = pr_list string_of_bool in *)
      (* DD.ninfo_pprint ("       bool: " ^ (pr ters)) no_pos; *)
      let new_grp_ls = List.concat fss in
      let ter = List.for_all (fun b -> not b) ters in
      (not ter, new_grp_ls)
    (* else *)
    (*   (\*return*\) *)
    (*   (false,grp) *)
  in
  let subst_dep_groups_x deps rec_hps nrec_grps=
    (* let rec local_helper deps res= *)
    (*   match deps with *)
    (*     | [] -> (false,res) *)
    (*     | grp::gs -> let r,grp1 = process_dep_group grp rec_hps nrec_grps in *)
    (*                  if r then (true,(res@[grp1]@gs)) *)
    (*                  else local_helper gs (res@[grp]) *)
    (* in *)

    (*local_helper deps []*)
    let bs, new_deps = List.split (List.map (fun grp -> process_dep_group grp rec_hps nrec_grps) deps) in
    let new_deps1 = List.filter (fun l -> List.length l > 0) new_deps in
    (List.fold_left (fun b1 b2 -> b1 || b2) false bs, new_deps1)
  in
  (*for debugging*)
  let subst_dep_groups deps rec_hps nrec_grps=
    let pr0 = (pr_list_ln SAU.string_of_par_def_w_name_short) in
    let pr1 =  pr_list_ln pr0 in
    let pr2 = pr_pair string_of_bool pr1 in
    Debug.no_2 "subst_dep_groups" pr1 pr1 pr2
        (fun _ _ -> subst_dep_groups_x deps rec_hps nrec_grps) deps nrec_grps
  in
  (*END for debugging*)
  (*sort order of nrec_grps to subst*)
  let topo_sort_x dep_grps nrec_grps=
    (*get name of n_rec_hps, intial its number with 0*)
    let ini_order_from_grp grp=
      let (hp,_,_,_) = List.hd grp in
      (grp,hp,0) (*called one topo*)
    in
    let update_order_from_grp updated_hps incr (grp,hp, old_n)=
      if CP.mem_svl hp updated_hps then
        (grp,hp,old_n+incr)
      else (grp,hp,old_n)
    in
  (*each grp, find succ_hp, add number of each succ hp + 1*)
    let process_one_dep_grp topo dep_grp=
      let (hp,_,_,_) = List.hd dep_grp in
      let succ_hps = List.concat (List.map (fun (_,_,f,_) -> CF.get_hp_rel_name_formula f) dep_grp) in
    (*remove dups*)
      let succ_hps1 = Gen.BList.remove_dups_eq CP.eq_spec_var succ_hps in
    (* DD.ninfo_pprint ("       process_dep_group succ_hps: " ^ (!CP.print_svl succ_hps)) no_pos; *)
    (*remove itself hp and unk_hps*)
      let succ_hps2 = List.filter (fun hp1 -> not (CP.eq_spec_var hp1 hp) &&
          not (CP.mem_svl hp1 unk_hps)) succ_hps1
      in
      List.map (update_order_from_grp succ_hps2 1) topo
    in
    let topo0 = List.map ini_order_from_grp nrec_grps in
    let dep_grps = List.filter (fun grp -> List.length grp > 0) dep_grps in
    let topo1 = List.fold_left process_one_dep_grp topo0 dep_grps in
    (*sort decreasing and return the topo list*)
    let topo2 = List.sort (fun (_,_,n1) (_,_,n2) -> n2-n1) topo1 in
    topo2
  in
  (*for debugging*)
  let topo_sort dep_grps nrec_grps=
    let pr0 = (pr_list_ln SAU.string_of_par_def_w_name_short) in
    let pr1 =  pr_list_ln pr0 in
    let pr2 =  pr_list_ln (pr_triple pr0 !CP.print_sv string_of_int) in
    Debug.no_2 "topo_sort" pr1 pr1 pr2
        (fun _ _ -> topo_sort_x dep_grps nrec_grps) dep_grps nrec_grps
  in
  (*END for debugging*)
  let helper_x grps rec_inds nrec_inds=
    let indeps,deps = List.partition is_independ_group grps in
    (*classify indeps into rec and non_rec*)
    let lrec_inds,lnrec_inds = List.partition is_rec_group indeps in
    (*for return*)
    let res_rec_inds = rec_inds@lrec_inds in
    let res_nrec_inds = nrec_inds@lnrec_inds in
    (* let lrec_deps,l_nrec_deps = comp_rec_grps_fix res_rec_inds  deps in *)
    let lrec_deps,l_nrec_deps = List.partition is_rec_group deps in
    (*find deps on non_recs*)
    let rec_hps = List.map
      (fun grp -> let (hp,_,_,_) = List.hd grp in hp)
      (res_rec_inds@lrec_deps)
    in
    (*deps may have mutual rec*)
    let mutrec_term_grps,mutrec_nonterm_grps, deps_0,mutrec_hps = SAU.succ_subst_with_mutrec prog deps unk_hps in
    (*add rec grp*)
    let l_nrec_deps1 = List.filter
      (fun grp -> let (hp,_,_,_) = List.hd grp in not(CP.mem_svl hp mutrec_hps))
      l_nrec_deps
    in
    (*topo deps*)
    let deps_1 = mutrec_term_grps@mutrec_nonterm_grps @ deps_0 in
    let topo_nrec_grps = topo_sort deps_1 (res_nrec_inds@l_nrec_deps1) in
    (*remove order number*)
    let topo_nrec_grps1 = List.map (fun (grp,hp,_) -> (grp,hp)) topo_nrec_grps in
    let rec loop_helper deps0 nrec_grps=
      let rec look_up_newer_nrec ls (cur_grp,hp)=
        match ls with
          | [] -> cur_grp
          | dep_grp::gss ->
              begin
                  match dep_grp with
                    | [] ->  look_up_newer_nrec gss (cur_grp,hp)
                    | _ ->
                        let hp1,_,_,_ = List.hd dep_grp in
                        if CP.eq_spec_var hp1 hp then dep_grp
                        else look_up_newer_nrec gss (cur_grp,hp)
              end
      in
      match nrec_grps with
        | [] -> deps0
        | (nrec_grp,nrec_hp)::ss ->
            (*find the latest in deps0, if applicable*)
            let nrec_grp1 = look_up_newer_nrec deps0 (nrec_grp,nrec_hp) in
            let _, deps1 = subst_dep_groups deps0 rec_hps [nrec_grp1] in
            loop_helper deps1 ss
    in
    let deps1 = loop_helper deps_1 topo_nrec_grps1
    in
    (* let r, deps1 = subst_dep_groups deps rec_hps (res_nrec_inds@l_nrec_deps) in *)
    (* ((List.length indeps>0 || r), deps1, res_rec_inds,res_nrec_inds) *)
    (*re-classify rec_ndep*)
    let indeps2,deps2 = List.partition is_independ_group deps1 in
    (*classify indeps into rec and non_rec*)
    let rec_inds2, nrec_indeps2 = List.partition is_rec_group indeps2 in
    (false, deps2, res_rec_inds@rec_inds2,res_nrec_inds@nrec_indeps2)
  in
  (*for debugging*)
   let helper grps rec_inds nrec_inds=
     let pr1 = pr_list_ln (pr_list_ln SAU.string_of_par_def_w_name_short) in
     let pr2= pr_quad string_of_bool pr1 pr1 pr1 in
     Debug.no_3 "pardef_subst_fix:helper" pr1 pr1 pr1 pr2
         (fun _ _ _ -> helper_x grps rec_inds nrec_inds) grps rec_inds nrec_inds
   in
  (*END for debugging*)
  let rec helper_fix cur rec_indps nrec_indps=
    let r,new_cur,new_rec_indps,new_nrec_indps = helper cur rec_indps nrec_indps in
    if r then helper_fix new_cur new_rec_indps new_nrec_indps
    else
      (*subs new_cur with new_rec_indps (new_nrec_indps is substed already)*)
      let new_cur1 = List.map SAU.remove_dups_pardefs new_cur in
      let new_cur2 = SAU.succ_subst_with_rec_indp prog new_rec_indps unk_hps new_cur1 in
      (new_cur2@new_rec_indps@new_nrec_indps)
  in
  helper_fix groups [] []

(*this subst is for a nice matching between inferred HP
and lib based predicates*)
let pardef_subst_fix prog unk_hps groups=
  let pr1 = pr_list_ln (pr_list_ln SAU.string_of_par_def_w_name_short) in
  Debug.no_1 "pardef_subst_fix" pr1 pr1
      (fun _ -> pardef_subst_fix_x prog unk_hps groups) groups

(*=========SUBST DEF FIX==========*)
(*
  divide hp into three groups:
  - independent - ready for genalizing
  - dependent:
      - depend on non-recursive groups: susbst
      - depend on recusive groups: wait
*)
let def_subst_fix_x prog unk_hps hpdefs=
  (*remove dups*)
  (* let unk_hps = CP.remove_dups_svl unk_hps in *)
  let is_rec_hpdef (a1,_,f)=
    let hp = SAU.get_hpdef_name a1 in
    let hps = CF.get_hp_rel_name_formula f in
    (CP.mem_svl hp hps)
  in
  let is_independ_hpdef (a1,_,f)=
    let hp = SAU.get_hpdef_name a1 in
    let hps = CF.get_hp_rel_name_formula f in
    let hps = CP.remove_dups_svl hps in
    (* DD.ninfo_pprint ("       rec hp: " ^ (!CP.print_sv hp)) no_pos; *)
    let _,rems = List.partition (fun hp1 -> CP.eq_spec_var hp hp1) hps in
    (* DD.ninfo_pprint ("       rec rems: " ^ (!CP.print_svl rems)) no_pos; *)
    (rems = [])
  in
  let process_dep_hpdef hpdef rec_hps nrec_hpdefs=
    let (a1,hprel,f) = hpdef in
    let hp = SAU.get_hpdef_name a1 in
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
        not (CP.mem_svl hp1 unk_hps) && not (CP.mem_svl hp1 rec_hps) ) succ_hps in
    (* DD.info_pprint ("       process_dep_group succ_hps1: " ^ (!CP.print_svl succ_hps1)) no_pos; *)
    if (CP.diff_svl succ_hps1 rec_hps) <> [] then
      (*not depends on any recursive hps, susbt it*)
      let args = SAU.get_ptrs hprel in
      let ters,new_fs = List.split (List.map (fun f1 -> SAU.succ_susbt_hpdef prog nrec_hpdefs succ_hps1 (hp,args,f1)) fs) in
      (*check all is false*)
      (* let pr = pr_list string_of_bool in *)
      (* DD.ninfo_pprint ("       bool: " ^ (pr ters)) no_pos; *)
      let ter = List.for_all (fun b -> not b) ters in
      let fs1  = SAU.remove_longer_common_prefix_w_unk unk_hps (List.concat new_fs) in
      (* let pr1 = pr_list_ln Cprinter.prtt_string_of_formula in *)
      (* let _ = DD.info_pprint ("       fs1: " ^ (pr1 fs1)) no_pos in *)
      let b =
        if not ter then
        not (SAU.checkeq_formula_list fs fs1)
        else false
      in
      (* let fs2 = SAU.remove_subset new_fs1 in *)
      (b , (CP.HPRelDefn hp,hprel,CF.disj_of_list fs1 no_pos ))
    else
      (*return*)
      (false,hpdef)
  in
  let subst_first_dep_hpdef deps rec_hps nrec_hpdefs=
    let rec local_helper deps res r=
      match deps with
        | [] -> (r,res)
        | hpdef::gs -> let r1,hpdef1 = process_dep_hpdef hpdef rec_hps nrec_hpdefs in
                     (* if r then (true,(res@[hpdef1]@gs)) *)
                     (* else local_helper gs (res@[hpdef]) *)
                       local_helper gs (res@[hpdef1]) (r1||r)
    in
    (* if nrec_grps = [] then (false, deps) else *)
      local_helper deps [] false
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
      (fun (a1,_,_) -> SAU.get_hpdef_name a1)
      (res_rec_inds@lrec_deps) in
    (*find the first depend grp in deps to subst,
    if can not find, return false for terminating*)
    let r, deps1 = subst_first_dep_hpdef deps rec_hps (res_nrec_inds@l_nrec_deps) in
    (( (*List.length indeps>0 || *) r), deps1, res_rec_inds,res_nrec_inds)
  in
  (*for debugging*)
   let helper hpdefs rec_inds nrec_inds=
     let pr1 = (pr_list_ln SAU.string_of_hp_rel_def) in
     let pr2= pr_quad string_of_bool pr1 pr1 pr1 in
     Debug.no_3 "def_subst_fix:helper" pr1 pr1 pr1 pr2
         (fun _ _ _ -> helper_x hpdefs rec_inds nrec_inds) hpdefs rec_inds nrec_inds
   in
  (*END for debugging*)
  let rec helper_fix cur rec_indps nrec_indps=
    let r,new_cur,new_rec_indps,new_nrec_indps = helper cur rec_indps nrec_indps in
    if r then
      (*rearrange cur for terminating*)
      (* let new_cur1 = (List.tl new_cur)@[List.hd new_cur] in *)
      helper_fix new_cur new_rec_indps new_nrec_indps
    else (new_cur@new_rec_indps@new_nrec_indps)
  in
  helper_fix hpdefs [] []

(*this subst is to elim intermediate hps in final inferred hprel def
 *)
let def_subst_fix prog unk_hps hpdefs=
  let pr1 = pr_list_ln Cprinter.string_of_hp_rel_def in
  Debug.no_1 "def_subst_fix" pr1 pr1
      (fun _ -> def_subst_fix_x prog unk_hps hpdefs) hpdefs

  (*=========END SUBST FIX==========*)

let subst_lhs_pdefs_w_impl_x hppdefs=
  let classify (hp1,args1,unk_args,a3,olf,orf)=
    match olf,orf with
        | Some f, None ->
            (*currently we just subst for recursive cases*)
            ([(hp1,args1,unk_args,a3,olf,orf)],[],[])
        | None, Some f ->
            if CF.is_HRel_f f then
              let hp2,args2 = CF.extract_HRel_f f in
              if SAU.eq_spec_var_order_list args1 args2 then
                ([], [], [(hp2,hp1,(hp1,args1,unk_args,a3,olf,orf))])
              else ([(hp1,args1,unk_args,a3,olf,orf)], [], [])
            else ([(hp1,args1,unk_args,a3,olf,orf)], [], [])
        | Some f1, Some f2 -> ([],[(hp1,args1,unk_args,a3,f1,f2)],[])
        | None, None -> report_error no_pos "sa.add_hpdef_equiv_form: can't happen 2"
  in
   (* let rec partition_subst_by_to_hp subst parts= *)
   (*  match subst with *)
   (*    | [] -> parts *)
   (*    | (from_hp,to_hp)::xs -> *)
   (*        let part,remains= List.partition (fun (_,to_hp1) -> CP.eq_spec_var to_hp1 to_hp) xs in *)
   (*        partition_subst_by_to_hp remains (parts@[[(from_hp,to_hp)]@part]) *)
   (* in *)
   let subst_impl subst (hp1,args1,unk_args,a3,f1,f2)=
     let rec subst_helper ls to_hp0=
       match ls with
         | [] -> f1,[]
         | (from_hp,to_hp,_)::tl -> if CP.eq_spec_var to_hp to_hp0 then
               (CF.subst_hprel f1 [from_hp] to_hp,[(from_hp,to_hp)])
             else subst_helper tl to_hp0
     in
     let new_f1,matched=
       if CF.is_HRel_f f2 then
          let to_hp,_ = CF.extract_HRel_f f2 in
          subst_helper subst to_hp
        else (f1,[])
     in
     ((hp1,args1,unk_args,a3,Some new_f1, Some f2),matched)
  in
  let get_remain_from_subst subst subst_matched =
    let ls_pdefs = List.map
      (
          fun (fr_hp0,to_hp0,pdef) ->
              if List.exists (fun
                  (fr_hp1,to_hp1) ->
                      CP.eq_spec_var fr_hp0 fr_hp1 &&
                          CP.eq_spec_var to_hp0 to_hp1) subst_matched
              then [] else [pdef]
      )
      subst
    in
    List.concat ls_pdefs
  in
  let ls_pdefs0,ls_to_be_substed,ls_subst = split3 (List.map classify hppdefs) in
  let to_be_substed = List.concat ls_to_be_substed in
  let subst = List.concat ls_subst in
  (*START debugging*)
  (* let pr1 = pr_list (pr_pair !CP.print_sv !CP.print_sv) in *)
  (* let pr2 = pr_list_ln SAU.string_of_par_def_w_name in *)
  (* let tmp1 = List.map (fun (a1,a2,_) -> (a1,a2)) subst in *)
  (* let _ = DD.info_pprint ("       subst: " ^ (pr1 tmp1)) no_pos in *)
  (* let tmp = List.map (fun (a1,a2,a3,a4,a5,a6) -> (a1,a2,a3,a4,Some a5,Some a6)) to_be_substed in *)
  (* let _ = DD.info_pprint ("       to_be_substed: " ^ (pr2 tmp)) no_pos in *)
  (*END debugging*)
  (* let subst_grp = partition_subst_by_to_hp subst [] in *)
  let new_to_be_substed,ls_matched = List.split (List.map (subst_impl subst) to_be_substed) in
  let not_subst = get_remain_from_subst subst (List.concat ls_matched) in
  ((List.concat ls_pdefs0)@( new_to_be_substed)@not_subst)

let subst_lhs_pdefs_w_impl hppdefs=
  let pr1 = pr_list_ln SAU.string_of_par_def_w_name in
  Debug.no_1 "subst_lhs_pdefs_w_impl" pr1 pr1
      (fun _ -> subst_lhs_pdefs_w_impl_x hppdefs) hppdefs

let is_valid_pardef (_,args,f,_)=
  let ls_succ_args = snd (List.split (CF.get_HRels_f f)) in
  let succ_args = List.concat ls_succ_args in
  let ptrs = CF.get_ptrs_f f in
  let dups = (CP.intersect_svl ptrs succ_args) in
  let root_arg=
    match args with
      | [] -> report_error no_pos "sa.is_valid_pardef: hp must have at least one arguments"
      | a::_ -> a
  in
  let b1 = not (CP.mem_svl root_arg dups) in
  (b1 (* && (not (check_unsat f)) *))

let generalize_hps_par_def_x prog non_ptr_unk_hps unk_hpargs post_hps par_defs=
  (*partition the set by hp_name*)
  let rec partition_pdefs_by_hp_name pdefs parts=
    match pdefs with
      | [] -> parts
      | (a1,a2,a3,a4)::xs ->
          let part,remains= List.partition (fun (hp_name,_,_,_) -> CP.eq_spec_var a1 hp_name) xs in
          partition_pdefs_by_hp_name remains (parts@[[(a1,a2,a3,a4)]@part])
  in
  (*remove neqNUll redundant*)
  let remove_neqNull_helper (hp,args,f,unk_svl)=
    let f1 = CF.remove_neqNulls_f f in
    if SAU.is_empty_f f1 then [] else [(hp,args,f1,unk_svl)]
  in
  let unk_hps = (List.map fst unk_hpargs) in
  let par_defs0 = subst_lhs_pdefs_w_impl par_defs in
  let par_defs1 = List.concat (List.map (get_pdef_body unk_hps post_hps) par_defs0) in
  let par_defs2 = List.filter is_valid_pardef par_defs1 in
  (*remove neqNull*)
  let par_defs3 = List.concat (List.map remove_neqNull_helper par_defs2) in
  let groups = partition_pdefs_by_hp_name par_defs3 [] in
  (*remove dups in each group*)
  let groups1 = List.map SAU.remove_dups_pardefs groups in
  (*
    subst such that each partial def does not contain other hps
    dont subst recursively
    search_largest_matching between two formulas
  *)
  let groups1a = SAU. generate_equiv_pdefs unk_hps groups1 in
  let groups2 = pardef_subst_fix prog unk_hps groups1a in
  (* let _ = Debug.info_pprint ("     END: " ) no_pos in *)
  (*remove empty*)
  let groups3 = List.filter (fun grp -> grp <> []) groups2 in
  (*each group, do union partial definition*)
  List.concat ((List.map (generalize_one_hp prog non_ptr_unk_hps unk_hps) groups3))

let generalize_hps_par_def prog non_ptr_unk_hps unk_hpargs post_hps par_defs=
  let pr1 = pr_list_ln SAU.string_of_par_def_w_name in
  let pr2 = Cprinter.string_of_hp_rel_def in
  let pr3 = fun (_,a)-> pr2 a in
  Debug.no_2 "generalize_hps_par_def" !CP.print_svl pr1 (pr_list pr3)
      (fun _ _ -> generalize_hps_par_def_x prog non_ptr_unk_hps unk_hpargs post_hps par_defs) post_hps par_defs

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

let generalize_hps_cs prog hpdefs unk_hps cs=
  let generalize_hps_one_cs constr=
    (* let _ = DD.info_pprint ("         cs:" ^ (Cprinter.string_of_hprel constr)) no_pos in *)
    (* let _ = DD.info_pprint ("         hpdefs:" ^ (!CP.print_svl hpdefs)) no_pos in *)
    let lhs,rhs = constr.CF.hprel_lhs,constr.CF.hprel_rhs in
    let lhds, lhvs,l_hp = CF.get_hp_rel_formula lhs in
    let rhds, rhvs,r_hp = CF.get_hp_rel_formula rhs in
    let hp_args = List.map (fun (id, eargs, _) -> (id, List.concat (List.map CP.afv eargs))) (l_hp@r_hp) in
    (*filer def hp out*)
    let diff = List.filter (fun (hp1,_) -> not(CP.mem_svl hp1 hpdefs)) hp_args in
    match diff with
      | [] -> ([],[]) (*drop constraint, no new definition*)
      | [(hp,args)] ->
          begin
              if CP.mem_svl hp hpdefs then (*defined already drop constraint, no new definition*)
                let _ = DD.ninfo_pprint ">>>>>> generalize_one_cs_hp: <<<<<<" no_pos in
                let _ = DD.ninfo_pprint ("         " ^ (!CP.print_sv hp) ^ " is defined already: drop the constraint") no_pos in
                ([constr],[])
              else if CP.mem_svl hp unk_hps then
                let _ = DD.ninfo_pprint ">>>>>> generalize_one_cs_hp: <<<<<<" no_pos in
                let _ = DD.ninfo_pprint ("         " ^ (!CP.print_sv hp) ^ " is unknown. pass to next step") no_pos in
                ([constr],[])
              else
                let keep_ptrs = SAU.loop_up_closed_ptr_args prog (lhds@rhds) (lhvs@rhvs) args in
                let p = CF.pos_of_formula lhs in
                (* let rhsp = match rhs with *)
                (*   | CF.Base fb -> fb.CF.formula_base_pure *)
                (*   | CF.Exists fe -> fe.CF.formula_exists_pure *)
                (*   | _ -> report_error no_pos "sa.collect_par_defs_one_side_one_hp_rhs_x: not handle yet" *)
                (* in *)
                let nlhs = CF.mkStar lhs rhs  CF.Flow_combine p in
                let hpargs = CF.get_HRels_f nlhs in
                let hpdefs1 =
                  let lhps = CF.get_hp_rel_name_formula lhs in
                  let rhps = CF.get_hp_rel_name_formula rhs in
                  if (CP.intersect_svl lhps rhps) = [] then hpdefs else hpdefs@[hp]
                in
                let hpargs1 = List.filter (fun (hp1,_) -> CP.mem_svl hp1 hpdefs1) hpargs in
                let keep_def_hps = List.concat (List.map (SAU.get_intersect_hps keep_ptrs) hpargs1) in
                let r = CF.drop_data_view_hrel_nodes nlhs SAU.check_nbelongsto_dnode SAU.check_nbelongsto_vnode SAU.check_neq_hrelnode keep_ptrs keep_ptrs keep_def_hps in
                if (not (SAU.is_empty_f r)) then
                  let _ = DD.ninfo_pprint ">>>>>> generalize_one_cs_hp: <<<<<<" no_pos in
                  let _ = DD.ninfo_pprint ((!CP.print_sv hp)^"(" ^(!CP.print_svl args) ^ ")=" ^
                                                  (Cprinter.prtt_string_of_formula r) ) no_pos in
                  ([],[(CP.HPRelDefn hp, (*CF.formula_of_heap*)
                        (CF.HRel (hp, List.map (fun x -> CP.mkVar x no_pos) args, p)) , r)])
                else
                  ([constr],[])
          end
      | _ -> ([constr],[]) (*keep constraint, no new definition*)
  in
  let r = List.map generalize_hps_one_cs cs in
  let cs1, hp_defs = List.split r in
  (*combine hp_defs*)
  let hpdefs = SAU.combine_hpdefs (List.concat hp_defs) in
  (List.concat cs1, hpdefs)

let get_unk_hps_relation_x prog defined_hps post_hps hpdefs cs=
  let _ = DD.ninfo_pprint ("         cs:" ^ (Cprinter.string_of_hprel cs)) no_pos in
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
  (* let _ = Debug.info_pprint ("     unks1: " ^ (pr unk_hps)) no_pos in *)
  (* let _ = Debug.info_pprint ("     unks2: " ^ (pr cs.CF.unk_hps)) no_pos in *)
  (* let _ = Debug.info_pprint ("     undef: " ^ (pr undef)) no_pos in *)
  (* (\*end for debugging*\) *)
  let new_defs1,rem_cs1=
    match undef with
      | [] -> [],[]
      | [(hp,args)] ->
          let hds = (lhns@rhns) in
          let hvs = (lhvs@rhvs) in
          let keep_ptrs = SAU.loop_up_closed_ptr_args prog hds hvs args in
          let keep_unk_hps = List.concat (List.map (SAU.get_intersect_hps keep_ptrs) unk_hps) in
          let lhs = SAU.keep_data_view_hrel_nodes prog cs.CF.hprel_lhs hds hvs keep_ptrs (keep_unk_hps) in
          let rhs = SAU.keep_data_view_hrel_nodes prog cs.CF.hprel_rhs hds hvs keep_ptrs (keep_unk_hps) in
          let ltest = SAU.is_empty_f lhs in
          let rtest = SAU.is_empty_f rhs in
          if ltest && rtest then [], [cs]
          else
            let def_body =  CF.mkStar lhs rhs  CF.Flow_combine (CF.pos_of_formula lhs)
              (* if List.exists (fun (hp1,_) -> CP.eq_spec_var hp hp1) lhp_args then *)
              (*   begin *)
              (*       if rtest then [] else [rhs] *)
              (*   end *)
              (* else if List.exists (fun (hp1,_) -> CP.eq_spec_var hp hp1) rhp_args then *)
              (*   begin *)
              (*       if ltest then [] else [lhs] *)
              (*   end *)
              (* else [] *)
            in
            (
               (*  match def_body with *)
              (* | [] -> [], [cs] *)
              (* | [f] -> *)
                let f = def_body in
                   begin
                      DD.ninfo_pprint ">>>>>> from assumption to def: <<<<<<" no_pos;
                      DD.ninfo_pprint ((!CP.print_sv hp)^"(" ^(!CP.print_svl args) ^ ")=" ^
                                             (Cprinter.prtt_string_of_formula f) ) no_pos;
                      ([(CP.HPRelDefn hp, CF.HRel (hp, List.map (fun x -> CP.mkVar x no_pos) args, no_pos), f) ],[])
                   end
              (* | _ -> report_error no_pos "sa.get_unk_hps_relation" *)
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
  let new_defs2,rem_cs2=
    if lunk_hps = [] || runk_hps = [] then ([],[cs])
    else
      let rels = List.concat (List.map
                       (fun (hp1,args1) -> List.map (fun (hp2,args2) ->
                           if CP.intersect_svl args1 args2 = [] then []
                           else
                             if not(CP.mem_svl hp1 post_hps) && (CP.mem_svl hp2 post_hps) then
                               (*hp2 is defined?*)
                               if (CP.mem_svl hp2 defined_hps) then []
                               else [((hp2,args2),(hp1,args1))]
                             else
                             [((hp1,args1),(hp2,args2))]) runk_hps)
                       lunk_hps)
      in
      (List.concat rels,[cs])
  in
  let cs3=
    if (rem_cs1@rem_cs2) = [] then []
    else [(List.hd (rem_cs1@rem_cs2))]
  in
  (cs3, new_defs1,new_defs2)

let get_unk_hps_relation prog defined_hps post_hps hpdefs cs=
  let pr1 = Cprinter.string_of_hprel in
  let pr3 = pr_list Cprinter.string_of_hp_rel_def in
  Debug.no_2 "get_unk_hps_relation" pr1 pr3 (pr_pair (pr_list_ln pr1) pr3)
      (fun _ _ -> get_unk_hps_relation_x prog defined_hps post_hps hpdefs cs) cs hpdefs

let generate_defs_from_unk_rels prog unk_rels=
  let _ = DD.ninfo_pprint ">>>>>> unk hps equivalent: <<<<<<" no_pos in
  let generate_unkhps_relation (hp1,args1) (hp2,args2) =
          let _ = Debug.ninfo_pprint ("     candidate unks: " ^ (!CP.print_svl [hp1;hp2])) no_pos in
          (* let pr = (pr_pair !CP.print_sv !CP.print_svl) in *)
          (* let _ = Debug.info_pprint ("     l unk_hp: " ^ (pr (hp1,args1))) no_pos in *)
          (* let _ = Debug.info_pprint ("     r unk_hp: " ^ (pr (hp2,args2))) no_pos in *)
    if CP.eq_spec_var hp1 hp2 || (List.length args1) <> (List.length args2) ||
      (CP.diff_svl args2 args1) <> []
    then []
    else
      begin
          let _ = Debug.ninfo_pprint ("     unks: " ^ (!CP.print_svl [hp1;hp2])) no_pos in
          let args = CP.remove_dups_svl (args1@args2) in
          (* let keep_unk_hps = List.concat (List.map (SAU.get_intersect_unk_hps args) unk_hps) in *)
          let rhs = CF.formula_of_heap (CF.HRel (hp2, List.map (fun x -> CP.mkVar x no_pos) args2, no_pos)) no_pos in
          (* let _ = Debug.ninfo_pprint ("      rhs: " ^ (Cprinter.prtt_string_of_formula rhs)) no_pos in *)
          begin
              DD.ninfo_pprint ((!CP.print_sv hp1)^"(" ^(!CP.print_svl args) ^ ")=" ^
                                     (Cprinter.prtt_string_of_formula rhs) ) no_pos;
              [(CP.HPRelDefn hp1, CF.HRel (hp1, List.map (fun x -> CP.mkVar x no_pos) args1, no_pos), rhs) ]
          end
      end
  in
  let helper ((hp11,args11),(hp12,args12)) ((hp21,args21),(hp22,args22))=
    let b = SAU.check_hp_arg_eq (hp11,args11) (hp21,args21) &&
      SAU.check_hp_arg_eq (hp12,args12) (hp22,args22) in
    if b then true
    else
       SAU.check_hp_arg_eq (hp11,args11) (hp22,args22) &&
           SAU.check_hp_arg_eq (hp12,args12) (hp21,args21)
  in
  let unk_rels = Gen.BList.remove_dups_eq helper unk_rels in
  let lunk_hps,runk_hps = List.split unk_rels in
  let new_defs=
    if lunk_hps = [] || runk_hps = [] then []
    else
      let rels = List.concat (List.map
             (fun lhp -> List.concat (List.map
                     (fun rhp -> generate_unkhps_relation lhp rhp) runk_hps)) lunk_hps) in
      rels
  in
  new_defs

let generalize_pure_def_from_hpunk_x prog hp_def_names cs=
  let mk_pure_def p pos (hp,args)=
    if CP.mem_svl hp hp_def_names then [] else
      let def1 = CP.filter_var_new p args in
      let def2,_ = SAU.remove_irr_eqs args def1 in
      if not (CP.isConstTrue def2) then
        let d = SAU.mk_hprel_def prog [hp] args hp args [(CF.formula_of_pure_formula def2 pos)]
          pos
        in d
      else []
  in
  let _, mxlhs, _,_,_ = (CF.split_components cs.CF.hprel_lhs) in
  let _, prhs, _,_,_ = (CF.split_components cs.CF.hprel_rhs) in
  let plhs = (MCP.pure_of_mix mxlhs) in
  let pos = (CP.pos_of_formula plhs) in
  let p = CP.mkAnd  plhs (MCP.pure_of_mix prhs) pos in
  List.concat (List.map (mk_pure_def p pos) cs.CF.unk_hps)

let generalize_pure_def_from_hpunk prog hp_def_names cs=
  let pr1 = Cprinter.string_of_hprel in
  let pr2 =  pr_list (pr_pair !CP.print_sv Cprinter.string_of_hp_rel_def) in
  Debug.no_1 "generalize_pure_def_from_hpunk" pr1 pr2
      (fun _ -> generalize_pure_def_from_hpunk_x prog hp_def_names cs) cs

let generalize_hps_x prog unk_hps sel_post_hps cs par_defs=
  DD.ninfo_pprint ">>>>>> step 6: generalization <<<<<<" no_pos;
  (*for consistency, we should handle partially unk_hp first*)
  (* let new_unk_hps, new_par_defs = SAU.ann_unk_svl prog par_defs in *)
  (* let total_unk_hps = unk_hps @ new_unk_hps in *)
(*general par_defs*)
  let non_ptr_unk_hps = List.concat (List.map (fun (hp,args) -> if List.exists (fun a -> not ( CP.is_node_typ a)) args
      then [hp] else []) unk_hps) in
  let pair_names_defs = generalize_hps_par_def prog non_ptr_unk_hps unk_hps sel_post_hps par_defs in
  let hp_names,hp_defs = List.split pair_names_defs in
(*for each constraints, we may pick more definitions*)
  (* let cs1 = List.map (drop_unk_hps unk_hps) cs in *)
  let remain_constr, hp_def1 = generalize_hps_cs prog hp_names (List.map (fun (hp,_) -> hp) unk_hps) cs in
  let remain_constr0,hp_def2,ls_unk_rels = split3 (List.map (get_unk_hps_relation prog hp_names sel_post_hps
                                                                 (hp_defs@hp_def1)) remain_constr) in
  let hpdef21 = (List.concat hp_def2) in
  let unk_rels = (List.concat ls_unk_rels) in
  let hpdefs3 = generate_defs_from_unk_rels prog unk_rels in
  let hpdef22 = SAU.combine_hpdefs (hpdef21@hpdefs3) in
  let get_unk_rel r ((hp1,args1),(hp2,args2))=
    if List.length args1 = List.length args2 then r@[(hp1,hp2)] else r
  in
  (List.concat remain_constr0, (hp_defs@hp_def1)@hpdef22,unk_hps,
   List.fold_left get_unk_rel [] unk_rels)

let generalize_hps prog unk_hps sel_post_hps cs par_defs=
  let pr1 = pr_list_ln Cprinter.string_of_hprel in
  let pr2 = pr_list_ln SAU.string_of_par_def_w_name in
  let pr3 = pr_list Cprinter.string_of_hp_rel_def in
  let pr4 = pr_list(pr_pair Cprinter.string_of_spec_var Cprinter.string_of_spec_var_list) in
  let pr5 = pr_list (pr_pair Cprinter.string_of_spec_var Cprinter.string_of_spec_var) in
  Debug.no_2 "generalize_hp" pr1 pr2 (pr_quad pr1 pr3 pr4 pr5)
      (fun _ _ -> generalize_hps_x prog unk_hps sel_post_hps cs par_defs) cs par_defs

(*========END generalization==========*)
(*===========fix point==============*)
let infer_hps_fix prog unk_hps (constrs: CF.hprel list) =
  let rec helper_x (constrs: CF.hprel list) par_defs =
    DD.ninfo_pprint ">>>>>> step 3: simplification <<<<<<" no_pos;
    let constrs1 = simplify_constrs prog unk_hps constrs in
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
            let pr = pr_list_ln SAU.string_of_par_def_w_name in
            Debug.no_1 "infer_hps_fix" pr (fun (_,pdefs) -> pr pdefs)
                (fun _ -> helper_x constrs par_defs) par_defs
          in
          (*END for debugging*)
          let norm_constrs, par_defs = helper constrs4 (par_defs@par_defs_diff) in
          ((* simplify_constrs prog *) norm_constrs,  par_defs)
      end
  in
  helper_x constrs []

let generate_hp_def_from_split_x prog hpdefs hp_defs_split unk_hpargs=
  let is_rec_hpdef hp f=
    let hps = CF.get_hp_rel_name_formula f in
    (CP.mem_svl hp hps)
  in
  let rec look_up_hp_def hp args0 hpdefs=
    match hpdefs with
      | [] -> (false,[SAU.mkHRel_f hp args0 no_pos])
      | (_,hrel1,f)::defss ->
          let hp1,args1 = CF.extract_HRel hrel1 in
          if CP.eq_spec_var hp1 hp then
            if is_rec_hpdef hp f then (true,[]) else
              let ss = List.combine args1 args0 in
              let nf = CF.subst ss f in
              (false,CF.list_of_disjs nf)
          else look_up_hp_def hp args0 defss
  in
  let rec look_up_hp_defs hp_args hpdefs res=
    match hp_args with
      | [] -> false,res
      | (hp1, args1)::tl ->
          let is_rec,fs = look_up_hp_def hp1 args1 hpdefs in
          if is_rec then (true,res)
          else look_up_hp_defs tl hpdefs (res@[fs])
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
  let unk_svl = List.fold_left (fun svl (_,svl1) -> svl@svl1) [] unk_hpargs in
  let generate_def (hp0,args0, hp_args,hrel0)=
    let exists_rec,fss = look_up_hp_defs hp_args hpdefs []  in
    let fs=
      if exists_rec then
        (* let _ = DD.info_pprint ">>>>>> a <<<<<<" no_pos in *)
        let hrels = List.map (fun (hp,args) -> SAU.mkHRel hp args no_pos) hp_args in
        let hf = List.fold_left (fun hf0 hf1 -> CF.mkStarH hf0 hf1 no_pos)
          (List.hd hrels) (List.tl hrels) in
        let _ = DD.info_pprint ("hf: " ^ (Cprinter.string_of_h_formula hf) )no_pos in
        [CF.formula_of_heap hf no_pos]
      else
        (* let _ = DD.info_pprint ">>>>>> b <<<<<<" no_pos in *)
        let nfs =
          if fss = [] then
          report_error no_pos "sa.generate_def"
          else combine_def (List.tl fss) no_pos (List.hd fss)
        in nfs
    in
      SAU.mk_hprel_def prog unk_hps unk_svl hp0 args0 fs no_pos
  in
  let _ = DD.ninfo_pprint ">>>>>> equivalent hps: <<<<<<" no_pos in
  let new_hpdefs = snd (List.split (List.concat (List.map generate_def hp_defs_split))) in
  new_hpdefs

let generate_hp_def_from_split prog hpdefs hp_defs_split unk_hpargs=
  let pr1 =  pr_list_ln Cprinter.string_of_hp_rel_def in
  let pr3 = pr_list (pr_pair !CP.print_sv !CP.print_svl) in
  let pr2 =  pr_list_ln (pr_quad !CP.print_sv !CP.print_svl pr3 Cprinter.string_of_h_formula) in
  Debug.no_2 "generate_hp_def_from_split" pr1 pr2 pr1
      (fun _ _ -> generate_hp_def_from_split_x prog hpdefs hp_defs_split unk_hpargs) hpdefs hp_defs_split

let rel_helper post_hps unk_rels unk_map=
    (*exchange post hps into the first position*)
  let rec ex_post_hps rem_unk_rel res=
    match rem_unk_rel with
      | [] -> res
      | (hp1,hp2,args)::tl ->
          let b1 = CP.mem_svl hp1 post_hps in
          let b2 = CP.mem_svl hp2 post_hps in
          begin
              match b1,b2 with
                | false,true -> ex_post_hps tl (res@[(hp2,hp1,args)])
                | _ -> ex_post_hps tl (res@[(hp1,hp2,args)])
          end
  in
  let generate_p_formual args pos fr_args=
    let ss = List.combine args fr_args in
    let ps = List.map (fun (sv1,sv2) -> CP.mkPtrEqn sv1 sv2 pos) ss in
    CF.formula_of_pure_formula (CP.conj_of_list ps pos) pos
  in
  let mk_def (hp,args,ls_fr_args)=
    let fs = List.map (generate_p_formual args no_pos) ls_fr_args in
    let def = CF.disj_of_list fs no_pos in
    ((CP.HPRelDefn hp, (CF.HRel (hp, List.map (fun x -> CP.mkVar x no_pos) args,no_pos)), def))
  in
  let rec list_lookup_map hp0 ls=
    match ls with
      | [] -> []
      | (hp1,ls_frargs)::tl -> if CP.eq_spec_var hp0 hp1 then ls_frargs
          else list_lookup_map hp0 tl
  in
  let rec list_lookup hp0 ls=
    match ls with
      | [] -> []
      | (hp1,_,ls_frargs)::tl -> if CP.eq_spec_var hp0 hp1 then ls_frargs
          else list_lookup hp0 tl
  in
  let rec list_update hp0 args0 ls_frargs ls ls_done=
    match ls with
      | [] -> ls_done@[(hp0,args0,ls_frargs)]
      | (hp1,args1,ls_frargs1)::tl ->
          if CP.eq_spec_var hp0 hp1 then
            let diff = Gen.BList.difference_eq SAU.eq_spec_var_order_list ls_frargs ls_frargs1 in
            ls_done@[(hp1,args1,ls_frargs1@diff)]@tl
          else
            list_update hp0 args0 ls_frargs tl (ls_done@[(hp1,args1,ls_frargs1)])
  in
  let rec subst_helper unk_rels unk_tmp_hpdefs=
    match unk_rels with
      | [] -> unk_tmp_hpdefs
      | (hp1,hp2,args)::tl ->
          let fr_args =
            let fr_args = list_lookup_map hp2 unk_map in
            if fr_args <> [] then [fr_args]
            else list_lookup hp2 unk_tmp_hpdefs
          in
          let new_unk_tmp_hpdefs = list_update hp1 args fr_args unk_tmp_hpdefs [] in
          subst_helper tl new_unk_tmp_hpdefs
  in
  (* let new_unk_rels = ex_post_hps unk_rels [] in *)
  let unk_tmp_hpdefs =  subst_helper unk_rels [] in
  (List.map mk_def unk_tmp_hpdefs)

let generate_hp_def_from_unk_hps_new_x unk_hpargs hp_defs post_hps gunk_rels=
  let mk_unkdef pos (hp,args)=
    let hp_name = dang_hp_default_prefix_name ^ CP.name_of_spec_var hp in
    let ps,fr_args =
      List.split (List.map (fun sv ->
          let fr_sv = CP.fresh_spec_var_prefix hp_name sv in
          (CP.mkPtrEqn sv fr_sv pos, fr_sv)
      ) args)
    in
    let p = CP.conj_of_list ps pos in
    let def = CF.formula_of_pure_formula p pos in
    let _ = DD.ninfo_pprint ((!CP.print_sv hp)^"(" ^
                                    (!CP.print_svl args) ^ ")=" ^
                                    (Cprinter.prtt_string_of_formula (* (CF.formula_of_heap h_def no_pos) *) def)) pos
    in
    let new_hpdef,new_unkmap = ((CP.HPRelDefn hp,
                                 (CF.HRel (hp, List.map (fun x -> CP.mkVar x no_pos) args,pos)),
     (* CF.formula_of_heap h_def no_pos *) def),(hp,fr_args))
    in
    (new_hpdef,new_unkmap)
  in
  let generate_unk_hps_pre_post unk_hps_done unk_hpargs_all=
    let hps_done = (CP.remove_dups_svl unk_hps_done) in
    let rem = List.filter (fun (hp1,_) -> not (CP.mem_svl hp1 hps_done)) unk_hpargs_all  in
    List.split (List.map (mk_unkdef no_pos) rem)
  in
  let helper (hpdefs,unk_map) (hp, args)=
    let new_hpdefs,ls_new_unkmap =
      if (CP.mem_svl hp post_hps)then
        [],[]
      else
        let new_hpdef,new_unkmap = mk_unkdef no_pos (hp, args) in
        [new_hpdef],[new_unkmap]
    in
    (hpdefs@new_hpdefs,unk_map@ls_new_unkmap)
  in
  DD.ninfo_pprint ">>>>>> unknown hps: <<<<<<" no_pos;
  let unk_hps = List.map fst unk_hpargs in
  (*classify unk_hpdefs and non-unk ones*)
  let ls_unk_rels,ls_rem_hpdefs,ls_unk_rel_hpdefs = split3 (List.map (fun (a, hrel, f) ->
      let (hp,args) = CF.extract_HRel hrel in
      if CP.mem_svl hp unk_hps then
        let eq_hps = CF.extract_unk_hprel f in
        (List.map (fun hp1 -> (hp,hp1,args)) eq_hps,[],[(a, hrel, f)])
      else ([],[(a, hrel, f)],[])
  ) hp_defs)
  in
  let unk_rels3 = List.concat ls_unk_rels in
  let unk_rels2 = List.map (fun (a,b,c) -> (a,b)) unk_rels3 in
  let unk_hps1 = SAU.find_close_hpargs unk_hpargs unk_rels2 in
  (*generate def for unk in precondition*)
  let unk_hpdefs, unk_map = List.fold_left helper ([],[]) unk_hps1 in
  (* let unk_hps_done1,unk_hpdefs_from_rel = rel_helper unk_rels3 unk_map in *)
  let unk_hps_done1 = List.map fst unk_rels2 in
  let unk_hps_done2 = List.map fst unk_map in
  let rem_unkdefs,rem_map = generate_unk_hps_pre_post (unk_hps_done1@unk_hps_done2) unk_hpargs in
  (* let all_unk_hpdefs = SAU.combine_hpdefs (unk_hpdefs_from_rel@unk_hpdefs@rem_unkdefs) in *)
  let all_unk_hpdefs = SAU.combine_hpdefs (unk_hpdefs@rem_unkdefs) in
  let rem_hpdefs = List.concat ls_rem_hpdefs in
  (rem_hpdefs,List.concat ls_unk_rel_hpdefs,all_unk_hpdefs,unk_map@rem_map,unk_rels3)

let generate_hp_def_from_unk_hps_x unk_hpargs hp_defs post_hps gunk_rels=
  let rec lookup_eqv_all rem_unk_rels hp res=
    match rem_unk_rels with
      | [] -> res
      | (hp1,hp2)::tl ->
          let eqs=
            if CP.eq_spec_var hp2 hp then
            [hp1]
            (* else if CP.eq_spec_var hp2 hp then *)
            (*   [hp1] *) else []
          in
          lookup_eqv_all tl hp (res@eqs)
  in
  let rec assoc_list hps unk_map=
    match unk_map with
      | [] -> raise Not_found
      | (hp,fr_args)::tl -> if CP.mem_svl hp hps then fr_args
          else assoc_list hps tl
  in
  let transform_hp_unk unk_rels unk_map pos (hp,args)=
    let ps,fr_svl =
      try
          let fr_args =
            (*precond: HP(x) = x = DLING*)
            if unk_rels = [] (*not (CP.mem_svl hp post_hps)*)then
              List.assoc hp unk_map
            else
              (*post: find eq pre hps: (eq_hps,hp)*)
              let eq_hps = lookup_eqv_all unk_rels hp [hp] in
              assoc_list eq_hps unk_map
          in
          let ss = List.combine args fr_args in
          let ps = List.map (fun (sv,fr_sv) -> CP.mkPtrEqn sv fr_sv pos) ss in
          (ps, fr_args)
      with Not_found ->
          let hp_name = dang_hp_default_prefix_name ^ CP.name_of_spec_var hp in
          List.split (List.map (fun sv ->
              let fr_sv = CP.fresh_spec_var_prefix hp_name sv in
              (CP.mkPtrEqn sv fr_sv pos, fr_sv)
          ) args)
    in
    let p = CP.conj_of_list ps pos in
    (CF.formula_of_pure_formula p pos,fr_svl)
  in
  let helper unk_rels (hpdefs,unk_map) (hp_name, args)=
    (* let h_def = CF.HTrue in *)
    let def,fr_args =  transform_hp_unk unk_rels unk_map no_pos (hp_name, args) in
    let _ = DD.ninfo_pprint ((!CP.print_sv hp_name)^"(" ^
        (!CP.print_svl args) ^ ")=" ^
        (Cprinter.prtt_string_of_formula (* (CF.formula_of_heap h_def no_pos) *) def)) no_pos
    in
    let new_hpdef, new_unkmap = ((CP.HPRelDefn hp_name,
     (CF.HRel (hp_name, List.map (fun x -> CP.mkVar x no_pos) args,no_pos)),
     (* CF.formula_of_heap h_def no_pos *) def),
     (hp_name,fr_args)
    )
    in
    (hpdefs@[new_hpdef], unk_map@[new_unkmap])
  in
  DD.ninfo_pprint ">>>>>> unknown hps: <<<<<<" no_pos;
  let unk_hps = List.map fst unk_hpargs in
  let unk_rels = List.concat (List.map (fun (_, hrel, f) ->
      let (hp,_,_) = CF.extract_HRel_orig hrel in
      if CP.mem_svl hp unk_hps then
        let eq_hps = CF.extract_unk_hprel f in
        List.map (fun hp1 -> (hp,hp1)) eq_hps
      else []
  ) hp_defs)
  in
  let unk_hps1 = SAU.find_close_hpargs unk_hpargs unk_rels in
  List.fold_left (helper unk_rels) ([],[]) unk_hps1

let generate_hp_def_from_unk_hps unk_hps hp_defs post_hps unk_rels=
  let pr1 = pr_list_ln Cprinter.string_of_hp_rel_def in
  let pr2 = pr_list (pr_pair !CP.print_sv !CP.print_svl) in
  let pr4 = pr_list (pr_pair !CP.print_sv !CP.print_sv) in
  let pr3 (a,b,c,d,_) = let pr = pr_quad pr1 pr1 pr1 pr2 in pr (a,b,c,d) in
  let pr5 = pr_list CP.string_of_xpure_view in
  Debug.no_3 "generate_hp_def_from_unk_hps" pr2 pr1 pr4 pr3
      (fun _ _ _ -> generate_hp_def_from_unk_hps_new_x unk_hps hp_defs post_hps unk_rels) unk_hps hp_defs unk_rels


let unify_branches_hpdef_x unk_hps hp_defs =
  (*move unk hps into the first position*)
  let rec swap_map ss r=
    match ss with
      | [] -> r
      | (sv1,sv2)::tl -> begin
          let b1 = CP.mem_svl sv1 unk_hps in
          let b2 = CP.mem_svl sv2 unk_hps in
          let new_ss =
            match b1,b2 with
              | true,false -> [(sv1,sv2)]
              | false,true -> [(sv2,sv1)]
              | _ -> []
          in
          swap_map tl (r@new_ss)
      end
  in
  let rec list_partition ss r=
    match ss with
      | [] -> r
      | (sv1,sv2)::tl ->
          let part,rem = List.partition (fun (_, sv4) -> CP.eq_spec_var sv2 sv4) tl in
          let part_svl = fst (List.split part) in
          list_partition rem r@[(sv1::part_svl, sv2)]
  in
  let rec check_eq_one args fs f done_fs=
    match fs with
      | [] -> done_fs,[f]
      | f1::tl ->
          let b,m = CEQ.checkeq_formulas args f f1 in
          if b then
            let ss = swap_map (List.hd m) [] in
            let parts = list_partition ss [] in
            (* let pr = pr_list (pr_pair !CP.print_svl !CP.print_sv) in *)
            (* let _ = DD.info_pprint ("  parts: " ^ (pr parts)) no_pos in *)
            let new_f = List.fold_left (fun f0 (from_hps, to_hp) -> CF.subst_hprel f0 from_hps to_hp) f parts in
            (* let new_f1 = List.fold_left (fun f0 (from_hps, to_hp) -> CF.subst_hprel f0 from_hps to_hp) f1 parts in *)
            (tl@done_fs,[new_f(* ;new_f1 *)])
          else
            check_eq_one args tl f (done_fs@[f1])
  in
  let rec check_eq args fs res_fs=
    match fs with
      | [] -> res_fs
      | f::tl ->
          let rem,done_fs = check_eq_one args tl f [] in
          check_eq args rem (res_fs@done_fs)
  in
  let process_one_hpdef (a,hrel,f)=
    let hp,args = CF.extract_HRel hrel in
    if CP.mem_svl hp unk_hps then
      (a,hrel,f)
    else
      let fs = CF.list_of_disjs f in
      let fs1 = check_eq [] fs [] in
      let p = CF.pos_of_formula f in
      let new_f = List.fold_left (fun f1 f2 -> CF.mkOr f1 f2 p)
                      (List.hd fs1) (List.tl fs1) in
      (a,hrel,new_f)
  in
  DD.ninfo_pprint ">>>>>> unify: <<<<<<" no_pos;
  let r = List.map process_one_hpdef hp_defs in
  r

let unify_branches_hpdef unk_hps hp_defs =
  let pr1 = pr_list_ln Cprinter.string_of_hp_rel_def in
  Debug.no_2 "unify_branches_hpdef" !CP.print_svl pr1 pr1
      (fun _ _ -> unify_branches_hpdef_x unk_hps hp_defs) unk_hps hp_defs

let check_eq_hpdef_x unk_hpargs post_hps hp_defs =
  let unk_hps = List.map fst unk_hpargs in
  let rec lookup_equiv_hpdef hpdefs hp args f=
    match hpdefs with
      | [] -> f
      | (a1,hrel1,f1)::tl ->
          let hp1,eargs1,p1 = CF.extract_HRel_orig hrel1 in
          let args1 = List.concat (List.map CP.afv eargs1) in
          if CP.eq_spec_var hp hp1 || CP.mem_svl hp1 unk_hps ||
            (List.length args <> List.length args1) then
            lookup_equiv_hpdef tl hp args f
          else
            let ss = List.combine args1 args in
            let f10 = CF.subst ss f1 in
            let f11 = CF.subst_hprel f10 [hp1] hp in
            if SAU.checkeq_formula_list (CF.list_of_disjs f) (CF.list_of_disjs f11) then
              let new_f = SAU.mkHRel_f hp1 args p1 in
              new_f
            else lookup_equiv_hpdef tl hp args f
  in
  let process_one_hpdef all_hpdefs (a,hrel,f)=
    let hp,args = CF.extract_HRel hrel in
    if not (CP.mem_svl hp post_hps) || CP.mem_svl hp unk_hps then
      (a,hrel,f)
    else
      let new_f = lookup_equiv_hpdef all_hpdefs hp args f in
      (a,hrel,new_f)
  in
  List.map (process_one_hpdef hp_defs) hp_defs

let check_eq_hpdef unk_hpargs post_hps hp_defs =
  let pr1 = pr_list_ln Cprinter.string_of_hp_rel_def in
  Debug.no_2 "check_eq_hpdef" !CP.print_svl pr1 pr1
      (fun _ _ -> check_eq_hpdef_x unk_hpargs post_hps hp_defs) post_hps hp_defs

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
    (* let _ = Debug.info_pprint ("     def_fs: " ^ (pr def_fs)) no_pos in *)
    (* let _ = Debug.info_pprint ("     def_fs1: " ^ (pr def_fs1)) no_pos in *)
    (* let _ = Debug.info_pprint ("     v_fl1: " ^ (pr v_fl1)) no_pos in *)
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

let match_hps_views_x (hp_defs: SAU.hp_rel_def list) (vdcls: CA.view_decl list):
(CP.spec_var* CF.h_formula list) list=
  let m = List.map (match_one_hp_views vdcls) hp_defs in
    (List.filter (fun (_,l) -> l<>[]) m)

let match_hps_views (hp_defs: SAU.hp_rel_def list) (vdcls: CA.view_decl list):
(CP.spec_var* CF.h_formula list) list=
  let pr1 = pr_list_ln Cprinter.string_of_hp_rel_def in
  let pr2 = pr_list_ln  Cprinter.prtt_string_of_h_formula  in
  let pr3a = fun (hp,vns) -> (!CP.print_sv hp) ^ " === " ^
      (* ( String.concat " OR " view_names) *) (pr2 vns) in
  let pr3 = pr_list_ln pr3a in
  let pr4 = pr_list_ln (Cprinter.string_of_view_decl) in
  Debug.no_2 "match_hps_views" pr1 pr4 pr3
      (fun _ _ -> match_hps_views_x hp_defs vdcls) hp_defs vdcls

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
  let mk_hprel_def kind hprel opf opflib=
    {
        CF.hprel_def_kind = kind;
        CF.hprel_def_hrel = hprel;
        CF.hprel_def_body = opf;
        CF.hprel_def_body_lib = opflib;
    }
  in
  let compute_def_w_lib (hp,(a,hprel,f))=
    let olib = look_up_lib hp m in
    (* if CP.mem_svl hp unk_hps then *)
    (*   (mk_hprel_def a hprel None None) *)
    (* else *)
    begin
        let f1 =
          match olib with
            | None ->
            (*subs lib form inside f if applicable*)
                let f_subst = CF.subst_hrel_hview_f f m in
                f_subst
            | Some lib_f -> lib_f
        in
        (mk_hprel_def a hprel (Some f) (Some f1))
    end
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
      let a1 = hdef.CF.hprel_def_kind in
      let hp = SAU.get_hpdef_name a1 in
      not (CP.mem_svl hp inter_lib))
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

let prtt_string_of_par_def_w_name (a1,args,unk_args,a3,olf,orf)=
  let str_hrel= (!CP.print_sv a1) ^ "(" ^ (String.concat "," (List.map !CP.print_sv args)) ^ ")" in
  match olf,orf with
    | Some f, None ->
        let str_f = Cprinter.prtt_string_of_formula f in
        (str_f ^ " --> " ^ str_hrel)
    | None, Some f ->
         let str_f = Cprinter.prtt_string_of_formula f in
         ( str_hrel ^ " --> " ^ str_f )
    | Some f1, Some f2 ->
        let f_body=
          let hps1 = CF.get_hp_rel_name_formula f1 in
          let hps2 = CF.get_hp_rel_name_formula f2 in
          if CP.intersect_svl hps1 hps2 <> [] then
            (*recurive case*)
            if CF.is_HRel_f f1 then f2 else f1
          else SAU.compose_subs f2 f1 (CF.pos_of_formula f2)
        in
        let str_f = Cprinter.prtt_string_of_formula f_body in
         ( str_hrel ^ " --> " ^ str_f )
    | None, None -> report_error no_pos "sa.obtain_def: can't happen 2"

(*
  input: constrs: (formula * formula) list
  output: definitions: (formula * formula) list
*)
let infer_hps_x prog (hp_constrs: CF.hprel list) sel_hp_rels sel_post_hps hp_rel_unkmap :(CF.hprel list * SAU.hp_rel_def list* (CP.spec_var*CP.exp list * CP.exp list) list) =
  DD.ninfo_pprint "\n\n>>>>>> norm_hp_rel <<<<<<" no_pos;
  DD.ninfo_pprint ">>>>>> step 1a: drop arguments<<<<<<" no_pos;
  let _ =
    if !Globals.sa_print_inter then
      let _ =  print_endline "" in
      let _ = print_endline "*********************************************************************" in
      let _ = print_endline "*******pre-process (split/unknown analyze) hprel assumptions ********" in
      let _ = print_endline "**********************************************************************" in
      ()
    else ()
  in
  (* step 1: drop irr parameters *)
  (* let drop_hp_args,constrs = elim_redundant_paras_lst_constr prog hp_constrs in *)
  (* Debug.ninfo_hprint (add_str "   AFTER DROP: " (pr_list_ln Cprinter.string_of_hprel)) constrs no_pos; *)
  DD.ninfo_pprint ">>>>>> step 1b: split arguments: currently omitted <<<<<<" no_pos;
   (* step 1': split HP *)
  let constrs1b, split_tb_hp_defs_split =
    if !Globals.sa_en_split then
      split_hp prog hp_constrs
    else (hp_constrs,[])
  in
  DD.ninfo_pprint ">>>>>> step 1c: find unknown ptrs<<<<<<" no_pos;
  let constrs1c,unk_hps,hp_defs_split = analize_unk prog hp_rel_unkmap constrs1b in
  (*rhs should be <= 1 hp*)
  (*for temporal*)
  let constrs1d = List.concat (List.map (SAU.split_rhs prog) constrs1c)  in
  let constrs2 = constrs1d in
  let _ =
    if !Globals.sa_print_inter then
      let _ = print_string "\n\n*******relational assumptions ********" in
      let _ = DD.info_pprint
        ((let pr = pr_list_ln Cprinter.string_of_hprel in pr constrs2) ) no_pos in
      ()
    else ()
  in
  (* let split_tb_hp_defs_split = [] in *)
  (*END for temporal*)
   let _ =
    if !Globals.sa_print_inter then
      let _ =  print_endline "" in
      let _ = print_endline "**************************************************************************" in
      let _ = print_endline "*******loop: collect partial defs, substition, simplification ********" in
      let _ = print_endline "**************************************************************************" in
      ()
    else ()
  in
  let cs, par_defs = infer_hps_fix prog (List.map fst unk_hps) constrs2 in
  let _ =
    if !Globals.sa_print_inter then
      let _ = print_string "\n\n*******relational assumptions ********\n" in
      let _ = DD.info_pprint
        ((let pr = pr_list_ln Cprinter.string_of_hprel_short in pr cs) ) no_pos in
      let _ = print_endline "\n\n*******partial definitions ********" in
      let pdef_sort_fn (hp1,_,_,_,_,_) (hp2,_,_,_,_,_)=
        let n1 = CP.name_of_spec_var hp1 in
        let n2 = CP.name_of_spec_var hp2 in
        String.compare n1 n2
      in
      let par_defs1 = List.sort pdef_sort_fn par_defs in
      let _ = print_endline
        ((let pr = pr_list_ln prtt_string_of_par_def_w_name in pr par_defs1) )  in
      ()
    else ()
  in
  (*step 6: over-approximate to generate hp def*)
  let _ =
    if !Globals.sa_print_inter then
      let _ =  print_endline "" in
      let _ = print_endline "*********************************************************************" in
      let _ = print_endline "*******subst, join, combine split, transfrom unknown ********" in
      let _ = print_endline "**********************************************************************" in
      ()
    else ()
  in
  let constr3, hp_defs, new_unk_hps,unk_rels = generalize_hps prog unk_hps sel_post_hps cs par_defs in
  let hp_def_names =  List.map (fun (a1,_,_) -> SAU.get_hpdef_name a1) hp_defs in
  let unk_hps1 = (* List.filter (fun (hp,_) -> not (CP.mem_svl hp hp_def_names)) *) new_unk_hps in
  let unk_hp_svl = (List.map (fun (hp,_) -> hp) unk_hps1) in
  let unk_hp_pures, unk_hp_pure_def = List.split (List.concat
    (List.map (generalize_pure_def_from_hpunk prog hp_def_names) constr3))
  in
  let unk_hps2 = List.filter (fun (hp,_) -> not(CP.mem_svl hp unk_hp_pures)) unk_hps1 in
  let unk_hp_svl1 = List.filter (fun hp -> not(CP.mem_svl hp unk_hp_pures)) unk_hp_svl in
  DD.ninfo_pprint (" remains: " ^
     (let pr1 = pr_list_ln Cprinter.string_of_hprel in pr1 constr3) ) no_pos;
  let hp_defs1 =  (Gen.BList.remove_dups_eq (fun (a1,_,_) (b1,_,_) ->
      let hp1 = SAU.get_hpdef_name a1 in
      let hp2 = SAU.get_hpdef_name b1 in
      CP.eq_spec_var hp1 hp2) (hp_defs))
  in
  let hp_defs2 = (def_subst_fix prog unk_hp_svl (hp_defs1)) in
  let hp_defs22 = SAU.combine_hpdefs (hp_defs2@unk_hp_pure_def) in
  let hp_def_from_split =
    if !Globals.sa_en_split then
      generate_hp_def_from_split prog hp_defs22 split_tb_hp_defs_split unk_hps
    else []
  in
  let hp_defs3 = hp_defs22@hp_def_from_split in
   (*currently, we discard all non-node unk hp*)
  (* unk_hps3: all non-node unk hps *)
  (* let non_node_unk_hps = List.filter (fun (_,args) -> *)
  (*     List.for_all (fun a -> not (CP.is_node_typ a)) args) unk_hps2 *)
  (* in *)
  (* let hp_defs21 = SAU.drop_non_node_unk_hps hp_defs2 non_node_unk_hps in *)
  let hp_defs4=
     if !Globals.sa_elim_dangling then
       let _ = print_endline "\n*******relational definitions (wo elim-dangling) ********" in
       let _ = print_endline
         ((let pr = pr_list_ln  Cprinter.string_of_hp_rel_def_short in pr hp_defs3) )
       in
       let hp_defs3a,unk_rel_hpdefs, unk_hp_defs,unk_hp_frargs,unk_rels3 = generate_hp_def_from_unk_hps unk_hps2 hp_defs3 sel_post_hps [](* unk_rels *) in
       if !Globals.sa_inlining then
         let unk_hpdefs_from_rel = rel_helper sel_post_hps unk_rels3 unk_hp_frargs in
         let all_unk_hpdefs = SAU.combine_hpdefs (unk_hp_defs@unk_hpdefs_from_rel) in
         let hp_defs3b = hp_defs3a@all_unk_hpdefs in
         SAU.transform_unk_hps_to_pure (hp_defs3b) unk_hp_frargs
        else (hp_defs3a@unk_hp_defs@unk_rel_hpdefs)
     else (hp_defs3)
  in
  (*unify inside on hp*)
  let unk_hps0 = List.map fst unk_hps in
  let hp_defs4a = check_eq_hpdef unk_hps sel_post_hps hp_defs4 in
  let hp_defs5 =
    if !Globals.sa_unify_dangling then
    unify_branches_hpdef unk_hps0 hp_defs4a
    else hp_defs4a
  in
  (****************************************************)
   let _ =
    if !Globals.sa_print_inter then
      let _ = print_endline "\n*******relational definitions ********" in
      let _ = print_endline
        ((let pr = pr_list_ln Cprinter.string_of_hp_rel_def_short in pr hp_defs4) )  in
      ()
    else ()
  in
  DD.ninfo_pprint ">>>>>> step 7: mathching with predefined predicates <<<<<<" no_pos;
  let _ =
    if !Globals.sa_print_inter then
      let _ =  print_endline "" in
      let _ = print_endline "*********************************************************************" in
      let _ = print_endline "*******post-process: predefined predicates matching  ********" in
      let _ = print_endline "**********************************************************************" in
      ()
    else ()
  in
   let m = match_hps_views hp_defs5 prog.CA.prog_view_decls in
  let _ = DD.ninfo_pprint ("        sel_hp_rel:" ^ (!CP.print_svl sel_hp_rels)) no_pos in
  (* let _ =  DD.info_pprint (" matching: " ^ *)
  (*   (let pr = pr_list_ln (fun (hp,view_names) -> (!CP.print_sv hp) ^ " === " ^ *)
  (*     ( String.concat " OR " view_names)) in pr m)) no_pos in *)
  let sel_hpdefs, rems = List.partition
    (fun (hprc, _, _) ->
        let hp = SAU.get_hpdef_name hprc in
        CP.mem_svl hp sel_hp_rels
    ) hp_defs5 in
  let sel_hpdefs1 = (* SAU.recover_dropped_args drop_hp_args *) sel_hpdefs in
  let hp_defs6 = rems@sel_hpdefs1 in
  let sel_hp_defs = collect_sel_hp_def hp_defs6 sel_hp_rels unk_hp_svl1 m in
  let _ = List.iter (fun hp_def -> rel_def_stk # push hp_def) sel_hp_defs in
  (*for cp*)
  let dropped_hps = (* List.filter (fun (hp,_,_) -> not(CP.mem_svl hp sel_hp_rels)) drop_hp_args *)[] in
  (constr3, hp_defs6, dropped_hps) (*return for cp*)

(*(pr_pair Cprinter.prtt_string_of_formula Cprinter.prtt_string_of_formula)*)
let infer_hps prog (hp_constrs: CF.hprel list) sel_hp_rels sel_post_hp_rels hp_rel_unkmap:
 (CF.hprel list * SAU.hp_rel_def list*(CP.spec_var*CP.exp list * CP.exp list) list) =
  let pr0 = pr_list !CP.print_exp in
  let pr1 = pr_list_ln Cprinter.string_of_hprel in
  let pr2 = pr_list_ln Cprinter.string_of_hp_rel_def in
  let pr3 = pr_list (pr_triple !CP.print_sv pr0 pr0) in
  let pr4 = pr_list (pr_pair !CP.print_sv CP.string_of_xpure_view) in
  Debug.no_3 "infer_hps" pr1 !CP.print_svl pr4 (pr_triple pr1 pr2 pr3)
      (fun _ _ _ -> infer_hps_x prog hp_constrs sel_hp_rels sel_post_hp_rels hp_rel_unkmap) hp_constrs sel_post_hp_rels hp_rel_unkmap

(**===============**********************==============**)
 (******************END of NORMALIZATION**************)
(**===============**********************==============**)

let check_horm_data_decl_x tmpl_data_decl data_decl=
  (*subs type s= temp t, t into tmpl ptr fiels*)
  let get_ptr ((t,id),_,b,_)=
    if is_pointer t then
      [(id,b)]
    else []
  in
  let get_ptr_and_susbt (id1,id2) ((t,id),_,b,_)=
    if is_pointer t then
      if id = id1 then
      [(id2,b)]
      else [(id,b)]
    else []
  in
  let rec eq_ordered_ids tmpl_idbs idbs=
    match tmpl_idbs,idbs with
      | [], [] -> true
      | (id1,b1)::ids1,(id2,b2)::ids2 ->
          if id1=id2 && b1=b2 then eq_ordered_ids ids1 ids2
          else false
      | _ -> false
  in
  let tmpl_idbs = List.concat (List.map (get_ptr_and_susbt
                  (tmpl_data_decl.Iast.data_name, data_decl.Iast.data_name))
                   tmpl_data_decl.Iast.data_fields) in
  let idbs = List.concat (List.map get_ptr data_decl.Iast.data_fields) in
  eq_ordered_ids tmpl_idbs idbs

let check_horm_data_decl tmpl_data_decl data_decl=
  let pr1 = Iprinter.string_of_data_decl in
  Debug.no_2 "check_horm_data_decl" pr1 pr1 string_of_bool
      (fun _ _ -> check_horm_data_decl_x tmpl_data_decl data_decl)
      tmpl_data_decl data_decl

let build_horm_view_x templ_view_decls horm_dd=
  let look_up_views data_name vds=
    let rec helper lvds res=
    match lvds with
      | [] -> res
      | vd::ss ->
          if vd.Iast.view_data_name = data_name then
            helper ss (res@[vd])
          else helper ss res
    in
    helper vds []
  in
  let generate_view ((tmp_data_name,tmp_data_fields),(data_name,data_fields))
        view=
    (*assume they have the same number of fields*)
    let n_view_name = view.Iast.view_name ^ "_" ^ data_name in
    let ss =
            List.fold_left(fun a (c1,c2)-> ((c1,Unprimed),(c2,Unprimed))::((c1,Primed),(c2,Primed))::a) [] [(tmp_data_name,data_name);(view.Iast.view_name,n_view_name)] in
    let n_view_invariant = Ipure.subst ss view.Iast.view_invariant in
    let n_view_formula = Iformula.subst_w_data_name_struc ss view.Iast.view_formula in
    let n_view_inv_lock =
      match view.Iast.view_inv_lock with
        | None -> None
        | Some f -> Some (Iformula.subst ss f)
    in
    { Iast.view_name = n_view_name;
	  Iast.view_data_name = data_name;
      Iast.view_vars = view.Iast.view_vars;
	  Iast.view_labels = view.Iast.view_labels;
	  Iast.view_modes = view.Iast.view_modes;
	  Iast.view_kind = view.Iast.view_kind;
      Iast.view_parents = view.Iast.view_parents;
      Iast.view_derv = view.Iast.view_derv;
      Iast.view_derv_info = view.Iast.view_derv_info ;
      Iast.view_prop_extns = view.Iast.view_prop_extns;
	  Iast.view_typed_vars = view.Iast.view_typed_vars;
	  Iast.view_invariant = n_view_invariant;
	  Iast.view_formula = n_view_formula;
      Iast.view_inv_lock = n_view_inv_lock;
	  Iast.view_pt_by_self = view.Iast.view_pt_by_self;
	  Iast.try_case_inference = view.Iast.try_case_inference
    }
  in
  let (tmp_data_name,tmp_data_fields),(data_name,data_fields) = horm_dd in
  let cand_views = look_up_views tmp_data_name templ_view_decls in
  List.map (generate_view horm_dd) cand_views

let build_horm_view templ_view_decls horm_dd=
  let pr1 = fun ((templ_data_name,_),(data_name,_)) -> (templ_data_name ^ ":" ^ data_name) in
  let pr2 = pr_list_ln Iprinter.string_of_view_decl in
  Debug.no_2 "build_horm_view" pr2 pr1 pr2
      (fun _ _ ->  build_horm_view_x templ_view_decls horm_dd) templ_view_decls horm_dd

let compute_view_data_name templ_ddefs templ_vdefs vdef=
  let data_name =
    if (String.length vdef.Iast.view_data_name) = 0 then
      let dl = List.map (fun v -> v.Iast.data_name) templ_ddefs in
      let (cands,_)= Iast.find_data_view dl vdef.Iast.view_formula no_pos in
      (* let _ = print_endline ("Feasible self type: " ^ (String.concat "," cands)) in *)
      List.hd cands
    else vdef.Iast.view_data_name
  in
  {vdef with Iast.view_data_name = data_name}

(*generate horm view*)
let generate_horm_view_x templ_data_decls templ_view_decls data_decls=
  (*find horm*)
  let find_horm_data_decl ldata_decls tmpl_data_decl=
    let helper templ_data_decl data_decl=
      if check_horm_data_decl tmpl_data_decl data_decl then
        [((templ_data_decl.Iast.data_name,templ_data_decl.Iast.data_fields),
        (data_decl.Iast.data_name,data_decl.Iast.data_fields))]
      else []
    in
    List.concat (List.map (helper tmpl_data_decl) ldata_decls)
  in
  let horm_dds = List.concat (List.map (find_horm_data_decl data_decls) templ_data_decls) in
  let new_templ_vdefs = List.map (compute_view_data_name templ_data_decls templ_view_decls) templ_view_decls in
  List.concat (List.map (build_horm_view new_templ_vdefs) horm_dds)

let generate_horm_view templ_data_decls templ_view_decls data_decls=
  let pr1 = pr_list_ln Iprinter.string_of_data_decl in
  let pr2 = pr_list_ln Iprinter.string_of_view_decl in
  Debug.no_3 "generate_horm_view" pr1 pr2 pr1 pr2
      (fun _ _ _ -> generate_horm_view_x templ_data_decls templ_view_decls data_decls) templ_data_decls templ_view_decls data_decls
