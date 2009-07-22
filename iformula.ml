(*
  Created 19-Feb-2006

  Input formulae
*)

open Globals
module P = Ipure


type struc_formula = ext_formula list

and ext_formula = 
	| ECase of ext_case_formula
	| EBase of ext_base_formula
	| EAssume of formula


and ext_case_formula =
	{
		formula_case_branches : (P.formula * struc_formula ) list;
		formula_case_pos : loc 		
	}

and ext_base_formula =
	{
		 formula_ext_explicit_inst : (ident * primed) list;
		 formula_ext_implicit_inst : (ident * primed) list;
		 formula_ext_exists :  (ident * primed) list;
		 formula_ext_base : formula;
		 formula_ext_continuation : struc_formula;
		 formula_ext_pos : loc
	}
  

and formula =
  | Base of formula_base
  | Exists of formula_exists
  | Or of formula_or

and formula_base = { formula_base_heap : h_formula;
					 formula_base_pure : P.formula;
                     formula_base_branches : (branch_label * P.formula) list;
					 formula_base_pos : loc }

and formula_exists = { formula_exists_qvars : (ident * primed) list;
					   formula_exists_heap : h_formula;
					   formula_exists_pure : P.formula;
                       formula_exists_branches : (branch_label * P.formula) list;
					   formula_exists_pos : loc }

and formula_or = { formula_or_f1 : formula;
				   formula_or_f2 : formula;
				   formula_or_pos : loc }

and h_formula = (* heap formula *)
  | Star of h_formula_star
  | HeapNode of h_formula_heap
  | HeapNode2 of h_formula_heap2
	  (* Don't distinguish between view and data node for now, as that requires look up *)
	  (*  | ArrayNode of ((ident * primed) * ident * P.exp list * loc) *)
	  (* pointer * base type * list of dimensions *)
  | HTrue 
  | HFalse
	  
and h_formula_star = { h_formula_star_h1 : h_formula;
					   h_formula_star_h2 : h_formula;
					   h_formula_star_pos : loc }

and h_formula_heap = { h_formula_heap_node : (ident * primed);
					   h_formula_heap_name : ident;
					   h_formula_heap_full : bool;
					   h_formula_heap_with_inv : bool;
					   h_formula_heap_arguments : P.exp list;
					   h_formula_heap_pseudo_data : bool;
					   h_formula_heap_pos : loc }

and h_formula_heap2 = { h_formula_heap2_node : (ident * primed);
						h_formula_heap2_name : ident;
						h_formula_heap2_full : bool;
						h_formula_heap2_with_inv : bool;
						h_formula_heap2_arguments : (ident * P.exp) list;
						h_formula_heap2_pseudo_data : bool;
						h_formula_heap2_pos : loc }

(* constructors *)

let rec formula_of_heap h pos = mkBase h (P.mkTrue pos) [] pos

and formula_of_pure p pos = mkBase HTrue p [] pos

and isConstFalse f0 = match f0 with
  | Base f -> begin
	  let h, p = f.formula_base_heap, f.formula_base_pure in
		match h with
		  | HFalse -> true
		  | _ -> match p with
			  | P.BForm (P.BConst (false, _)) -> true
			  | _ -> false
	end
  | _ -> false

and isConstTrue f0 = match f0 with
  | Base f -> begin
	  let h, p = f.formula_base_heap, f.formula_base_pure in
		match h with
		  | HTrue -> begin
			  match p with
				| P.BForm (P.BConst (true, _)) -> true
				| _ -> false
			end
		  | _ -> false
	end
  | _ -> false

and isEConstFalse f0 = match f0 with
  | [EBase b] -> isConstFalse b.formula_ext_base
  | _ -> false

and isEConstTrue f0 = match f0 with
 	| [EBase b] -> isConstTrue b.formula_ext_base
  | _ -> false

and mkTrue pos = Base { formula_base_heap = HTrue;
						formula_base_pure = P.mkTrue pos;
                        formula_base_branches = [];
						formula_base_pos = pos }

and mkFalse pos = Base { formula_base_heap = HFalse;
						 formula_base_pure = P.mkFalse pos;
                         formula_base_branches = [];
						 formula_base_pos = pos }

and mkETrue pos = [EBase {
		 formula_ext_explicit_inst = [];
		 formula_ext_implicit_inst = [];
		 formula_ext_exists = [];
		 formula_ext_base = mkTrue pos;
		 formula_ext_continuation = [];
		 formula_ext_pos = pos	}]

and mkEFalse pos =[EBase {
		 formula_ext_explicit_inst = [];
		 formula_ext_implicit_inst = [];
		 formula_ext_exists = [];
		 formula_ext_base = mkFalse pos;
		 formula_ext_continuation = [];
		 formula_ext_pos = pos	}]
																				
and mkEOr f1 f2 pos = 
	if isEConstTrue f1 || isEConstTrue f2 then
	mkETrue pos
  else if isEConstFalse f1 then f2
  else if isEConstFalse f2 then f1
  else List.rev_append f1 f2

and mkOr f1 f2 pos =
  if isConstTrue f1 || isConstTrue f2 then
	mkTrue pos
  else if isConstFalse f1 then f2
  else if isConstFalse f2 then f1
  else Or { formula_or_f1 = f1;
			formula_or_f2 = f2;
			formula_or_pos = pos }

and mkBase (h : h_formula) (p : P.formula) br pos = match h with
  | HFalse -> mkFalse pos
  | _ -> 
	  if P.isConstFalse p then 
		mkFalse pos 
	  else 
		Base { formula_base_heap = h;
			   formula_base_pure = p;
               formula_base_branches = br;
			   formula_base_pos = pos }

and mkExists (qvars : (ident * primed) list) (h : h_formula) (p : P.formula) br pos = match h with
  | HFalse -> mkFalse pos
  | _ ->
	  if P.isConstFalse p then
		mkFalse pos
	  else
		Exists { formula_exists_qvars = qvars;
				 formula_exists_heap = h;
				 formula_exists_pure = p;
                 formula_exists_branches = br;
				 formula_exists_pos = pos }

and mkStar f1 f2 pos = match f1 with
  | HFalse -> HFalse
  | HTrue -> f2
  | _ -> match f2 with
	  | HFalse -> HFalse
	  | HTrue -> f1
	  | _ -> Star { h_formula_star_h1 = f1;
					h_formula_star_h2 = f2;
					h_formula_star_pos = pos }

and pos_of_formula f0 = match f0 with
  | Base f -> f.formula_base_pos
  | Or f -> f.formula_or_pos
  | Exists f -> f.formula_exists_pos
	
and pos_of_struc_formula f0  = 
if (List.length f0)==0 then no_pos
	else match (List.hd f0) with 
	| ECase b -> b.formula_case_pos
	| EBase b -> b.formula_ext_pos
	| EAssume b -> pos_of_formula b

let replace_branches b = function
  | Or f -> failwith "replace_branches doesn't expect an Or"
  | Base f -> Base {f with formula_base_branches = b;}
  | Exists f -> Exists {f with formula_exists_branches = b;}
;;

let flatten_branches p br =
  List.fold_left (fun p (l, f) -> P.And (p, f,no_pos)) p br
;;

let rec h_fv (f:h_formula):(ident*primed) list = match f with   
  | Star ({h_formula_star_h1 = h1; 
		   h_formula_star_h2 = h2; 
		   h_formula_star_pos = pos}) ->  Util.remove_dups ((h_fv h1)@(h_fv h2))
  | HeapNode {h_formula_heap_node = name ; 
				h_formula_heap_arguments = b} -> Util.remove_dups (name:: (List.concat (List.map Ipure.afv b)))
  | HeapNode2 { h_formula_heap2_node = name ;
				h_formula_heap2_arguments = b}-> Util.remove_dups (name:: (List.concat (List.map (fun c-> (Ipure.afv (snd c))) b) ))
  | HTrue -> [] 
  | HFalse -> [] 
;;


(*
let rec h_arg_fv (f:h_formula):(ident*primed) list = 
	let rec helper (f:h_formula):((ident*primed) list) (**( (ident*primed) list)*) =	match f with   
  | Star b -> 
		let r11,r12 =  helper b.h_formula_star_h1 in
		let r21,r22 =  helper b.h_formula_star_h2 in
		((r11@r21),(r12@r22))
  | HeapNode {h_formula_heap_node = name ; 
							h_formula_heap_arguments = b}->
		((List.map (fun c->match c with
			|Ipure.Var d -> (fst d) 
			| _ -> 	Error.report_error	{Error.error_loc = no_pos; Error.error_text = ("exp float out malfunction")} ) b) ,[name])
  | HeapNode2 { h_formula_heap2_node = name ;
								h_formula_heap2_arguments = b}->		
		((List.map (fun c->match (snd c) with
			|Ipure.Var d -> (fst d) 
			| _ -> 	Error.report_error	{Error.error_loc = no_pos; Error.error_text = "exp float out malfunction"} ) b) ,[name])
  | HTrue -> ([],[]) 
  | HFalse -> ([],[]) in
	let r1,r2 = helper f in
	Util.remove_dups r1 (*(Util.difference r1 r2)*)
;;*)



let rec struc_hp_fv (f:struc_formula): (ident*primed) list = 
						let rec helper (f:ext_formula):(ident*primed) list = Util.remove_dups ( match f with
							| EBase b-> Util.difference 
													((struc_hp_fv b.formula_ext_continuation)@(heap_fv b.formula_ext_base)) 
													(b.formula_ext_explicit_inst@b.formula_ext_implicit_inst)
							| ECase b-> List.fold_left (fun a (c1,c2)->
											a@ (struc_hp_fv c2)) [] b.formula_case_branches
							| EAssume b-> heap_fv b) in
						List.concat (List.map helper f)

and heap_fv (f:formula):(ident*primed) list = match f with
	| Base b-> h_fv b.formula_base_heap
	| Exists b-> Util.difference (Util.remove_dups ( h_fv b.formula_exists_heap)) b.formula_exists_qvars 
	| Or b-> Util.remove_dups ((heap_fv b.formula_or_f1)@(heap_fv b.formula_or_f2))
	
	
and unbound_heap_fv (f:formula):(ident*primed) list = match f with
	| Base b-> h_fv b.formula_base_heap
	| Exists b-> 
		Util.difference (h_fv b.formula_exists_heap) b.formula_exists_qvars
	| Or b-> Util.remove_dups ((unbound_heap_fv b.formula_or_f1)@(unbound_heap_fv b.formula_or_f2))

and struc_free_vars (f0:struc_formula):(ident*primed) list= 
	let helper f = match f with
		| EBase b -> 
					let fvb = all_fv b.formula_ext_base in
					let fvc = struc_free_vars b.formula_ext_continuation in
					Util.remove_dups (Util.difference (fvb@fvc) (b.formula_ext_explicit_inst@ b.formula_ext_implicit_inst @ b.formula_ext_exists))
		| ECase b -> 
				let fvc = List.fold_left (fun a (c1,c2)-> 
				a@(struc_free_vars c2)@(Ipure.fv c1)) [] b.formula_case_branches in
				Util.remove_dups fvc		
		| EAssume b-> all_fv b in
	Util.remove_dups (List.concat (List.map helper f0))
and all_fv (f:formula):(ident*primed) list = match f with
	| Base b-> Util.remove_dups 
			(List.fold_left ( fun a (c1,c2)-> a@ (Ipure.fv c2)) ((h_fv b.formula_base_heap)@(Ipure.fv b.formula_base_pure))
							b.formula_base_branches )
	| Exists b-> 
		let r = List.fold_left ( fun a (c1,c2)-> a@ (Ipure.fv c2)) ((h_fv b.formula_exists_heap)@(Ipure.fv b.formula_exists_pure))
							b.formula_exists_branches in
		Util.difference (Util.remove_dups r) b.formula_exists_qvars 
	| Or b-> Util.remove_dups ((all_fv b.formula_or_f1)@(all_fv b.formula_or_f2))
	
and add_quantifiers (qvars : (ident*primed) list) (f : formula) : formula = match f with
  | Base ({formula_base_heap = h; 
		   formula_base_pure = p; 
           formula_base_branches = b;
		   formula_base_pos = pos}) -> mkExists qvars h p b pos
  | Exists ({formula_exists_qvars = qvs; 
			 formula_exists_heap = h; 
			 formula_exists_pure = p; 
             formula_exists_branches = b;
			 formula_exists_pos = pos}) -> 
	  let new_qvars = Util.remove_dups (qvs @ qvars) in
		mkExists new_qvars h p b pos
  | _ -> failwith ("add_quantifiers: invalid argument")
	
and push_exists (qvars : (ident*primed) list) (f : formula) = match f with
  | Or ({formula_or_f1 = f1; formula_or_f2 = f2; formula_or_pos = pos}) -> 
	  let new_f1 = push_exists qvars f1 in
	  let new_f2 = push_exists qvars f2 in
	  let resform = mkOr new_f1 new_f2 pos in
		resform
  | _ -> add_quantifiers qvars f ;;


let formula_to_struc_formula (f:formula):struc_formula =
	let rec helper (f:formula):struc_formula = match f with
		| Base b-> [EBase ({
			 		formula_ext_explicit_inst =[];
		 			formula_ext_implicit_inst = [];
					formula_ext_exists = [];
		 			formula_ext_base = f;
					formula_ext_continuation = [];
		 			formula_ext_pos = b.formula_base_pos})]
		| Exists b-> [EBase ({
			 		formula_ext_explicit_inst =[];
		 			formula_ext_implicit_inst = [];
					formula_ext_exists = [];
		 			formula_ext_base = f;
					formula_ext_continuation = [];
		 			formula_ext_pos = b.formula_exists_pos})]
		| Or b->  (helper b.formula_or_f1)@(helper b.formula_or_f2) in			
	(helper f);;


let split_quantifiers (f : formula) : ( (ident * primed) list * formula) = match f with
  | Exists ({formula_exists_qvars = qvars; 
			 formula_exists_heap =  h; 
			 formula_exists_pure = p; 
			 formula_exists_branches = br; 
			 formula_exists_pos = pos}) -> 
      (qvars, mkBase h p br pos)
  | Base _ -> ([], f)
  | _ -> failwith ("split_quantifiers: invalid argument")

(*var substitution*)

let rec subst sst (f : formula) = match sst with
  | s :: rest -> subst rest (apply_one s f)
  | [] -> f 
      
and subst_var (fr, t) (o : (ident*primed)) = if (Ipure.eq_var fr o) then t else o
and subst_var_list ft (o : (ident*primed)) = let r = List.filter (fun (c1,c2)-> (Ipure.eq_var c1 o) ) ft in
	if (List.length r)==0 then o else snd (List.hd r)

and apply_one ((fr, t) as s : ((ident*primed) * (ident*primed))) (f : formula) = match f with
  | Or ({formula_or_f1 = f1; formula_or_f2 = f2; formula_or_pos = pos}) -> 
      Or ({formula_or_f1 = apply_one s f1; formula_or_f2 =  apply_one s f2; formula_or_pos = pos})
  | Base ({formula_base_heap = h;
					 formula_base_pure = p;
					 formula_base_branches = br;
					 formula_base_pos = pos }) -> 
      Base ({formula_base_heap = h_apply_one s h; 
			 formula_base_pure = Ipure.apply_one s p;
			 formula_base_branches = List.map (fun (c1,c2)-> (c1,(Ipure.apply_one s c2))) br;
			 formula_base_pos = pos})
  | Exists ({formula_exists_qvars = qsv; 
			 formula_exists_heap = qh; 
			 formula_exists_pure = qp; 
			 formula_exists_branches = br;
			 formula_exists_pos = pos}) -> 
	  if List.mem (fst fr) (List.map fst qsv) then f 
	  else Exists ({formula_exists_qvars = qsv; 
					formula_exists_heap =  h_apply_one s qh; 
					formula_exists_pure = Ipure.apply_one s qp; 
					formula_exists_branches = List.map (fun (c1,c2)-> (c1,(Ipure.apply_one s c2))) br;
					formula_exists_pos = pos})		

and h_apply_one ((fr, t) as s : ((ident*primed) * (ident*primed))) (f : h_formula) = match f with
  | Star ({h_formula_star_h1 = f1; 
		   h_formula_star_h2 = f2; 
		   h_formula_star_pos = pos}) -> 
      Star ({h_formula_star_h1 = h_apply_one s f1; 
			 h_formula_star_h2 = h_apply_one s f2; 
			 h_formula_star_pos = pos})
  | HeapNode ({h_formula_heap_node = x; 
			   h_formula_heap_name = c; 
			   h_formula_heap_full = full; 
			   h_formula_heap_with_inv = winv;
			   h_formula_heap_arguments = args;
			   h_formula_heap_pseudo_data = ps_data;
			   h_formula_heap_pos = pos}) -> 
      HeapNode ({h_formula_heap_node = subst_var s x; 
				 h_formula_heap_name = c; 
				 h_formula_heap_full = full;
				 h_formula_heap_with_inv = winv;
				 h_formula_heap_arguments = List.map (Ipure.e_apply_one s) args;
				 h_formula_heap_pseudo_data = ps_data;
				 h_formula_heap_pos = pos})
  | HeapNode2 ({
		 				h_formula_heap2_node = x;
						h_formula_heap2_name = c;
						h_formula_heap2_full = full;
						h_formula_heap2_with_inv = winv;
						h_formula_heap2_arguments = args;
						h_formula_heap2_pseudo_data = ps_data;
						h_formula_heap2_pos= pos}) -> 
      HeapNode2 ({
				 		h_formula_heap2_node = subst_var s x;
						h_formula_heap2_name =c;
						h_formula_heap2_full =full;
						h_formula_heap2_with_inv = winv;
						h_formula_heap2_arguments = List.map (fun (c1,c2)-> (c1,(Ipure.e_apply_one s c2))) args;
						h_formula_heap2_pseudo_data =ps_data;
						h_formula_heap2_pos = pos})
  | HTrue -> f
  | HFalse -> f
	  



and rename_bound_vars (f : formula) = 
	let add_quantifiers (qvars : (ident*primed) list) (f : formula) : formula = match f with
  | Base ({formula_base_heap = h; 
		   formula_base_pure = p;
			 formula_base_branches = br;  
		   formula_base_pos = pos}) -> mkExists qvars h p br pos
  | Exists ({formula_exists_qvars = qvs; 
			 formula_exists_heap = h; 
			 formula_exists_pure = p;
			 formula_exists_branches = br;  
			 formula_exists_pos = pos}) -> 
	  let new_qvars = Util.remove_dups (qvs @ qvars) in
		mkExists new_qvars h p br pos
  | _ -> failwith ("add_quantifiers: invalid argument") in		
	match f with
  | Or ({formula_or_f1 = f1; formula_or_f2 = f2; formula_or_pos = pos}) ->
	  let rf1 = rename_bound_vars f1 in
	  let rf2 = rename_bound_vars f2 in
	  let resform = mkOr rf1 rf2 pos in
		resform
  | Base _ -> f
  | Exists _ ->
	  let qvars, base_f = split_quantifiers f in
	  let new_qvars = Ipure.fresh_vars qvars in
	  let rho = List.combine qvars new_qvars in
	  let new_base_f = subst rho base_f in
	  let resform = add_quantifiers new_qvars new_base_f in
		resform 


	
and subst_struc (sst:((ident * primed)*(ident * primed)) list) (f:struc_formula):struc_formula = 
	
	let rec helper (f:ext_formula):ext_formula = match f with
		| EAssume b -> EAssume (subst sst b)
		| ECase b ->
			let r = List.map (fun (c1,c2)-> ((Ipure.subst sst c1),(subst_struc sst c2))) b.formula_case_branches in
			ECase ({formula_case_branches = r; formula_case_pos = b.formula_case_pos})
		| EBase b->
			let sb = subst sst b.formula_ext_base in
			let sc = subst_struc sst b.formula_ext_continuation in
			let se = List.map (subst_var_list sst) b.formula_ext_explicit_inst in
			let si = List.map (subst_var_list sst) b.formula_ext_implicit_inst in
			let s_exist = List.map (subst_var_list sst) b.formula_ext_exists in
			EBase ({
					formula_ext_implicit_inst = si;
					formula_ext_explicit_inst = se;
					formula_ext_exists = s_exist;
					formula_ext_base = sb;
					formula_ext_continuation = sc;
					formula_ext_pos = b.formula_ext_pos	})	in	
	List.map helper f


let rec rename_bound_var_struc_formula (f:struc_formula):struc_formula =
	let rec helper (f:ext_formula):ext_formula = match f with
		| EAssume b -> EAssume (rename_bound_vars b)
		| ECase b-> ECase ({b with formula_case_branches = List.map (fun (c1,c2)-> (c1,(rename_bound_var_struc_formula c2))) b.formula_case_branches})
		| EBase b-> 
			(*let sst1 = List.map (fun (c1,c2)-> ((c1,c2),((Ipure.fresh_old_name c1),c2)))b.formula_ext_explicit_inst in*)
			let sst2 = List.map (fun (c1,c2)-> ((c1,c2),((Ipure.fresh_old_name c1),c2)))b.formula_ext_implicit_inst in
			let sst = (*sst1@*)sst2 in
			let nb = subst sst b.formula_ext_base in
			let nc = subst_struc sst b.formula_ext_continuation in		
			let new_base_f = rename_bound_vars nb in
			let new_cont_f = rename_bound_var_struc_formula nc in
			EBase ({b with 
				formula_ext_explicit_inst = (*snd (List.split sst1)*) b.formula_ext_explicit_inst;
		 		formula_ext_implicit_inst = snd (List.split sst2);
				formula_ext_base=new_base_f; formula_ext_continuation=new_cont_f})			
			in
	List.map helper f



and float_out_exps_from_heap (f:formula ):formula = 
	
	let rec float_out_exps (f:h_formula):(h_formula * (((ident*primed)*Ipure.formula)list)) = match f with
		 | Star b-> 
				let r11,r12 = float_out_exps b.h_formula_star_h1 in
				let r21,r22 = float_out_exps b.h_formula_star_h2 in
				(Star ({h_formula_star_h1  =r11; h_formula_star_h2=r21;h_formula_star_pos = b.h_formula_star_pos}), 
				(r12@r22))
 		 | HeapNode b-> 
				let na,ls = List.split (List.map (fun c->
								match c with
									| Ipure.Var _ -> (c,[])
									| _ -> 
										let nn = (("flted_"^(string_of_int b.h_formula_heap_pos.start_pos.Lexing.pos_lnum)^(fresh_trailer ())),Unprimed) in
										let nv = Ipure.Var (nn,b.h_formula_heap_pos) in
										let npf = Ipure.BForm (Ipure.Eq (nv,c,b.h_formula_heap_pos)) in																
										(nv,[(nn,npf)])) b.h_formula_heap_arguments) in
				(HeapNode ({b with h_formula_heap_arguments = na}),(List.concat ls))
  	 | HeapNode2 b ->	 
				let na,ls = List.split (List.map (fun c->
								match (snd c) with
									| Ipure.Var _ -> (c,[])
									| _ -> 
										let nn = (("flted_"^(string_of_int b.h_formula_heap2_pos.start_pos.Lexing.pos_lnum)^(fresh_trailer ())),Unprimed) in
										let nv = Ipure.Var (nn,b.h_formula_heap2_pos) in
										let npf = Ipure.BForm (Ipure.Eq (nv,(snd c),b.h_formula_heap2_pos)) in																
										(((fst c),nv),[(nn,npf)])) b.h_formula_heap2_arguments) in
				(HeapNode2 ({b with h_formula_heap2_arguments = na}),(List.concat ls))
  	 | HTrue -> (f,[])
     | HFalse -> (f,[]) in
	
	let rec helper (f:formula):formula =	match f with
	| Base b-> let rh,rl = float_out_exps b.formula_base_heap in
						 if (List.length rl)== 0 then f
							else 
								let r1,r2 = List.hd rl in
								let r1,r2 = List.fold_left (fun (a1,a2)(c1,c2)-> ((c1::a1),(Ipure.mkAnd a2 c2 b.formula_base_pos)) ) ([r1],r2) (List.tl rl) in
								Exists ({
							   formula_exists_qvars = r1;
							   formula_exists_heap = rh;
							   formula_exists_pure = Ipure.mkAnd r2 b.formula_base_pure b.formula_base_pos;
							   formula_exists_branches = List.map (fun (c1,c2)-> (c1,(Ipure.mkAnd r2 c2 b.formula_base_pos)))b.formula_base_branches;
							   formula_exists_pos = b.formula_base_pos
								})			
	| Exists b->
			let rh,rl = float_out_exps b.formula_exists_heap in
		 	if (List.length rl)== 0 then f
							else 
								let r1,r2 = List.hd rl in
								let r1,r2 = List.fold_left (fun (a1,a2)(c1,c2)-> ((c1::a1),(Ipure.mkAnd a2 c2 b.formula_exists_pos)) ) ([r1],r2) (List.tl rl) in
							Exists ({
								 formula_exists_qvars = r1@b.formula_exists_qvars;
							   formula_exists_heap = rh;
							   formula_exists_pure = Ipure.mkAnd r2 b.formula_exists_pure b.formula_exists_pos;
							   formula_exists_branches = List.map (fun (c1,c2)-> (c1,(Ipure.mkAnd r2 c2 b.formula_exists_pos)))b.formula_exists_branches;
							   formula_exists_pos = b.formula_exists_pos
								})	
	| Or b-> Or ({
					 formula_or_f1 = float_out_exps_from_heap b.formula_or_f1;
				   formula_or_f2 = float_out_exps_from_heap b.formula_or_f2;
				   formula_or_pos = b.formula_or_pos
		})		
	in helper f

	
and float_out_exps_from_heap_struc (f:struc_formula):struc_formula = 
	let rec helper (f:ext_formula):ext_formula = match f with
		| EAssume b -> EAssume (float_out_exps_from_heap b)
		| ECase b -> ECase ({formula_case_branches = List.map (fun (c1,c2)-> (c1,(float_out_exps_from_heap_struc c2))) b.formula_case_branches ; formula_case_pos=b.formula_case_pos})
		| EBase b-> 	EBase ({
					formula_ext_explicit_inst = b.formula_ext_explicit_inst;
					formula_ext_implicit_inst = b.formula_ext_implicit_inst;
					formula_ext_exists = b.formula_ext_exists ;
					formula_ext_base = float_out_exps_from_heap b.formula_ext_base;
					formula_ext_continuation = float_out_exps_from_heap_struc b.formula_ext_continuation;
					formula_ext_pos = b.formula_ext_pos			
				})in	
	List.map helper f
	
	
and float_out_min_max (f :  formula) :  formula =
  match f with
  |  Base
      {
         formula_base_pos = l;
         formula_base_heap = h0;
         formula_base_branches = br;
         formula_base_pure = p0
      } ->
      let (nh, nhpf) = float_out_heap_min_max h0 in
      let np = float_out_pure_min_max p0 in
         Base
          {
             formula_base_pos = l;
             formula_base_heap = nh;
             formula_base_branches = (List.map (fun (l, f) -> (l, float_out_pure_min_max f)) br);
             formula_base_pure =
              (match nhpf with
               | None -> np
               | Some e1 -> Ipure.And (np, e1, l));
          }
  |  Exists
      {
         formula_exists_qvars = qv;
         formula_exists_heap = h0;
         formula_exists_pure = p0;
         formula_exists_branches = br;
         formula_exists_pos = l
      } ->
      let (nh, nhpf) = float_out_heap_min_max h0 in
      let np = float_out_pure_min_max p0 in
         Exists
          {
             formula_exists_qvars = qv;
             formula_exists_heap = nh;
             formula_exists_pure =
              (match nhpf with
               | None -> np
               | Some e1 -> (Ipure.And (np, e1, l)));
             formula_exists_branches = (List.map (fun (l, f) -> (l, float_out_pure_min_max f)) br);
             formula_exists_pos = l;
          }
  |  Or
      {
         formula_or_f1 = f1;
         formula_or_f2 = f2;
         formula_or_pos = l
      } ->
       Or
        {
           formula_or_f1 = float_out_min_max f1;
           formula_or_f2 = float_out_min_max f2;
           formula_or_pos = l;
        }

and float_out_exp_min_max (e: Ipure.exp): (Ipure.exp * (Ipure.formula * (string list) ) option) = match e with 
	| Ipure.Null _ -> (e, None)
  | Ipure.Var _ -> (e, None)
  | Ipure.IConst _ -> (e, None)
  | Ipure.Add (e1, e2, l) ->
			let ne1, np1 = float_out_exp_min_max e1 in
			let ne2, np2 = float_out_exp_min_max e2 in
			let r = match (np1, np2) with
					| None, None -> None
					| Some p, None -> Some p
					| None, Some p -> Some p
					| Some (p1, l1), Some (p2, l2) -> Some ((Ipure.And (p1, p2, l)), (List.rev_append l1 l2))in
			(Ipure.Add (ne1, ne2, l), r) 
  | Ipure.Subtract (e1, e2, l) ->
			let ne1, np1 = float_out_exp_min_max e1 in
			let ne2, np2 = float_out_exp_min_max e2 in
			let r = match (np1, np2) with
					| None, None -> None
					| Some p, None -> Some p
					| None, Some p -> Some p
					| Some (p1, l1), Some (p2, l2) -> Some ((Ipure.And (p1, p2, l)), (List.rev_append l1 l2))in
			(Ipure.Subtract (ne1, ne2, l), r) 
  | Ipure.Mult (c, e1, l) ->
			let ne1, np1 = float_out_exp_min_max e1 in
			(Ipure.Mult (c, ne1, l), np1)
						 
  | Ipure.Max (e1, e2, l) ->
			let ne1, np1 = float_out_exp_min_max e1 in
			let ne2, np2 = float_out_exp_min_max e2 in
			let new_name = ("max"^(fresh_trailer())) in
			let nv = Ipure.Var((new_name, Unprimed), l) in
			let t = Ipure.BForm (Ipure.EqMax(nv, ne1, ne2, l)) in 
			let r = match (np1, np2) with
					| None, None -> Some (t,[new_name])
					| Some (p1, l1), None -> Some ((Ipure.And(p1, t, l)), (new_name:: l1))
					| None, Some (p1, l1) -> Some ((Ipure.And(p1, t, l)), (new_name:: l1))
					| Some (p1, l1), Some (p2, l2) -> Some ((Ipure.And ((Ipure.And (p1, t, l)), p2, l)), new_name:: (List.rev_append l1 l2)) in
			(nv, r) 
			
			
  | Ipure.Min (e1, e2, l) ->
			let ne1, np1 = float_out_exp_min_max e1 in
			let ne2, np2 = float_out_exp_min_max e2 in
			let new_name = ("min"^(fresh_trailer())) in
			let nv = Ipure.Var((new_name, Unprimed), l) in
			let t = Ipure.BForm (Ipure.EqMin(nv, ne1, ne2, l)) in 
			let r = match (np1, np2) with
					| None, None -> Some (t,[new_name])
					| Some (p1, l1), None -> Some ((Ipure.And(p1, t, l)), (new_name:: l1))
					| None, Some (p2, l2) -> Some ((Ipure.And(p2, t, l)), (new_name:: l2))
					| Some (p1, l1), Some (p2, l2) -> Some ((Ipure.And ((Ipure.And (p1, t, l)), p2, l)), new_name:: (List.rev_append l1 l2)) in
			(nv, r) 
	
		(* bag expressions *)
  | Ipure.Bag (le, l) ->
			let ne1, np1 = List.split (List.map float_out_exp_min_max le) in
			let r = List.fold_left (fun a c -> match (a, c)with
				  | None, None -> None
					| Some p, None -> Some p
					| None, Some p -> Some p
					| Some (p1, l1), Some (p2, l2) -> Some ((Ipure.And (p1, p2, l)), (List.rev_append l1 l2))) None np1 in
			(Ipure.Bag (ne1, l), r)
  | Ipure.BagUnion (le, l) ->
			let ne1, np1 = List.split (List.map float_out_exp_min_max le) in
			let r = List.fold_left (fun a c -> match (a, c)with
				  | None, None -> None
					| Some p, None -> Some p
					| None, Some p -> Some p
					| Some (p1, l1), Some (p2, l2) -> Some ((Ipure.And (p1, p2, l)), (List.rev_append l1 l2))) None np1 in
			(Ipure.BagUnion (ne1, l), r)
  | Ipure.BagIntersect (le, l) ->
			let ne1, np1 = List.split (List.map float_out_exp_min_max le) in
			let r = List.fold_left (fun a c -> match (a, c)with
				  | None, None -> None
					| Some p, None -> Some p
					| None, Some p -> Some p
					| Some (p1, l1), Some (p2, l2) -> Some ((Ipure.And (p1, p2, l)), List.rev_append l1 l2)) None np1 in
			(Ipure.BagIntersect (ne1, l), r)
  | Ipure.BagDiff (e1, e2, l) ->
			let ne1, np1 = float_out_exp_min_max e1 in
			let ne2, np2 = float_out_exp_min_max e2 in
			let r = match (np1, np2) with
					| None, None -> None
					| Some p, None -> Some p
					| None, Some p -> Some p
					| Some (p1, l1), Some (p2, l2) -> Some ((Ipure.And (p1, p2, l)), (List.rev_append l1 l2)) in
			(Ipure.BagDiff (ne1, ne2, l), r) 
		(* list expressions *)
  | Ipure.List (le, l) ->
			let ne1, np1 = List.split (List.map float_out_exp_min_max le) in
			let r = List.fold_left (fun a c -> match (a, c) with
				  | None, None -> None
					| Some p, None -> Some p
					| None, Some p -> Some p
					| Some (p1, l1), Some (p2, l2) -> Some ((Ipure.And (p1, p2, l)), (List.rev_append l1 l2))) None np1 in
			(Ipure.List (ne1, l), r)
  | Ipure.ListAppend (le, l) ->
			let ne1, np1 = List.split (List.map float_out_exp_min_max le) in
			let r = List.fold_left (fun a c -> match (a, c) with
				  | None, None -> None
					| Some p, None -> Some p
					| None, Some p -> Some p
					| Some (p1, l1), Some (p2, l2) -> Some ((Ipure.And (p1, p2, l)), (List.rev_append l1 l2))) None np1 in
			(Ipure.ListAppend (ne1, l), r)
  | Ipure.ListCons (e1, e2, l) -> 
			let ne1, np1 = float_out_exp_min_max e1 in
			let ne2, np2 = float_out_exp_min_max e2 in
			let r = match (np1, np2) with
					| None, None -> None
					| Some p, None -> Some p
					| None, Some p -> Some p
					| Some (p1, l1), Some (p2, l2) -> Some ((Ipure.And (p1, p2, l)), (List.rev_append l1 l2)) in
			(Ipure.ListCons (ne1, ne2, l), r) 
  | Ipure.ListHead (e, l) -> 
			let ne1, np1 = float_out_exp_min_max e in
			(Ipure.ListHead (ne1, l), np1)
  | Ipure.ListTail (e, l) -> 
			let ne1, np1 = float_out_exp_min_max e in
			(Ipure.ListTail (ne1, l), np1)
  | Ipure.ListLength (e, l) -> 
			let ne1, np1 = float_out_exp_min_max e in
			(Ipure.ListLength (ne1, l), np1)
  | Ipure.ListReverse (e, l) -> 
			let ne1, np1 = float_out_exp_min_max e in
			(Ipure.ListReverse (ne1, l), np1)

and float_out_pure_min_max (p : Ipure.formula) : Ipure.formula =
		
		let add_exists (t: Ipure.formula)(np1: (Ipure.formula * (string list))option)(np2: (Ipure.formula * (string list))option) l: Ipure.formula = 
			let r, ev = match np1 with
							| None -> (t,[])
							| Some (p1, ev1) -> (Ipure.And (t, p1, l), ev1) in
			let r, ev2 = match np2 with 
							| None -> (r, ev)
							| Some (p1, ev1) -> (Ipure.And(r, p1, l), (List.rev_append ev1 ev)) in 
		  List.fold_left (fun a c -> (Ipure.Exists ((c, Unprimed), a, l))) r ev2 in
							
				
		let rec float_out_b_formula_min_max (b: Ipure.b_formula): Ipure.formula = match b with
			| Ipure.BConst _ -> Ipure.BForm b
		  | Ipure.BVar _ -> Ipure.BForm b
		  | Ipure.Lt (e1, e2, l) ->
						let ne1, np1 = float_out_exp_min_max e1 in
						let ne2, np2 = float_out_exp_min_max e2 in
						let t = Ipure.BForm (Ipure.Lt (ne1, ne2, l)) in
						add_exists t np1 np2 l
		  | Ipure.Lte (e1, e2, l) ->
						let ne1, np1 = float_out_exp_min_max e1 in
						let ne2, np2 = float_out_exp_min_max e2 in
						let t = Ipure.BForm (Ipure.Lte (ne1, ne2, l)) in
						add_exists t np1 np2 l
		  | Ipure.Gt (e1, e2, l) ->
						let ne1, np1 = float_out_exp_min_max e1 in
						let ne2, np2 = float_out_exp_min_max e2 in
						let t = Ipure.BForm (Ipure.Gt (ne1, ne2, l)) in
						add_exists t np1 np2 l
		  | Ipure.Gte (e1, e2, l) ->
						let ne1, np1 = float_out_exp_min_max e1 in
						let ne2, np2 = float_out_exp_min_max e2 in
						let t = Ipure.BForm (Ipure.Gte (ne1, ne2, l)) in
						add_exists t np1 np2 l
		  | Ipure.Eq (e1, e2, l) ->
						let r = match e1 with
							| Ipure.Min(v1, v2, v3) -> let r2 = match e2 with
																	| Ipure.Null _
																	| Ipure.IConst _
																	| Ipure.Var _ ->
																			 let ne1 , np1 = float_out_exp_min_max v1 in
																			 let ne2 , np2 = float_out_exp_min_max v2 in
																			 let t = Ipure.BForm(Ipure.EqMin(e2, ne1, ne2, l)) in
																			 add_exists t np1 np2 l
																	| _ -> 
																			 let ne1, np1 = float_out_exp_min_max e1 in
																			 let ne2, np2 = float_out_exp_min_max e2 in
																			 let t = Ipure.BForm (Ipure.Eq (ne1, ne2, l)) in
																			 add_exists t np1 np2 l  in r2
							| Ipure.Max(v1, v2, v3) -> let r2 = match e2 with
																						| Ipure.Null _
																						| Ipure.IConst _
																						| Ipure.Var _ ->
																								 let ne1 , np1 = float_out_exp_min_max v1 in
																								 let ne2 , np2 = float_out_exp_min_max v2 in
																								 let t = Ipure.BForm(Ipure.EqMax(e2, ne1, ne2, l)) in
																								 add_exists t np1 np2 l
																						| _ -> 
																							let ne1, np1 = float_out_exp_min_max e1 in
																							let ne2, np2 = float_out_exp_min_max e2 in
																							let t = Ipure.BForm (Ipure.Eq (ne1, ne2, l)) in
																							add_exists t np1 np2 l 
																			in r2
							| Ipure.Null _
							| Ipure.IConst _
							| Ipure.Var _ -> let r2 = match e2 with
																					| Ipure.Min (v1, v2, v3) ->
																						 	 let ne1 , np1 = float_out_exp_min_max v1 in
																							 let ne2 , np2 = float_out_exp_min_max v2 in
																							 let t = Ipure.BForm(Ipure.EqMin(e1, ne1, ne2, l)) in
																							 add_exists t np1 np2 l
																					| Ipure.Max (v1, v2, v3) ->
																							 let ne1 , np1 = float_out_exp_min_max v1 in
																							 let ne2 , np2 = float_out_exp_min_max v2 in
																							 let t = Ipure.BForm(Ipure.EqMax(e1, ne1, ne2, l)) in
																							 add_exists t np1 np2 l
																					| _ -> 
																						let ne1, np1 = float_out_exp_min_max e1 in
																						let ne2, np2 = float_out_exp_min_max e2 in
																						let t = Ipure.BForm (Ipure.Eq (ne1, ne2, l)) in
																						add_exists t np1 np2 l 
																in r2
							| _ ->
									let ne1, np1 = float_out_exp_min_max e1 in
									let ne2, np2 = float_out_exp_min_max e2 in
									let t = Ipure.BForm (Ipure.Eq (ne1, ne2, l)) in
									add_exists t np1 np2 l 
							in r
		  | Ipure.Neq (e1, e2, l) ->
						let ne1, np1 = float_out_exp_min_max e1 in
						let ne2, np2 = float_out_exp_min_max e2 in
						let t = Ipure.BForm (Ipure.Neq (ne1, ne2, l)) in
						add_exists t np1 np2 l
		  | Ipure.EqMax (e1, e2, e3, l) ->
						let ne1, np1 = float_out_exp_min_max e1 in
						let ne2, np2 = float_out_exp_min_max e2 in
						let ne3, np3 = float_out_exp_min_max e3 in
						let t = Ipure.BForm (Ipure.EqMax (ne1, ne2, ne3, l)) in
						let t = add_exists t np1 np2 l in
						let r = match np3 with 
							| None -> t
							| Some (p1, l1) -> List.fold_left (fun a c -> (Ipure.Exists ((c, Unprimed), a, l))) (Ipure.And(t, p1, l)) l1 in r
		  | Ipure.EqMin (e1, e2, e3, l) ->
						let ne1, np1 = float_out_exp_min_max e1 in
						let ne2, np2 = float_out_exp_min_max e2 in
						let ne3, np3 = float_out_exp_min_max e3 in
						let t = Ipure.BForm (Ipure.EqMin (ne1, ne2, ne3, l)) in
						let t = add_exists t np1 np2 l in
						let r = match np3 with 
							| None -> t
							| Some (p1, l1) -> List.fold_left (fun a c -> Ipure.Exists ((c, Unprimed), a, l)) (Ipure.And(t, p1, l)) l1 in r
		  | Ipure.BagIn (v, e, l) -> 
							let ne1, np1 = float_out_exp_min_max e in
							let r = match np1 with
								| None -> Ipure.BForm (Ipure.BagIn(v, ne1, l))
								| Some (r, l1) -> List.fold_left (fun a c -> Ipure.Exists ((c, Unprimed), a, l)) (Ipure.And(Ipure.BForm (Ipure.BagIn(v, ne1, l)), r, l)) l1 in r 
		  | Ipure.BagNotIn (v, e, l) -> 
							let ne1, np1 = float_out_exp_min_max e in
							let r = match np1 with
								| None -> Ipure.BForm (Ipure.BagNotIn(v, ne1, l))
								| Some (r, l1) -> List.fold_left (fun a c -> Ipure.Exists ((c, Unprimed), a, l)) (Ipure.And(Ipure.BForm (Ipure.BagNotIn(v, ne1, l)), r, l)) l1 in r
		  | Ipure.BagSub (e1, e2, l) ->
					let ne1, np1 = float_out_exp_min_max e1 in
					let ne2, np2 = float_out_exp_min_max e2 in
					let t = Ipure.BForm (Ipure.BagSub (ne1, ne2, l)) in
					add_exists t np1 np2 l
		  | Ipure.BagMin _ -> Ipure.BForm b
		  | Ipure.BagMax _ -> Ipure.BForm b	
		  | Ipure.ListIn (e1, e2, l) -> 
					let ne1, np1 = float_out_exp_min_max e1 in
					let ne2, np2 = float_out_exp_min_max e2 in
					let t = Ipure.BForm (Ipure.ListIn (ne1, ne2, l)) in
					add_exists t np1 np2 l
		  | Ipure.ListNotIn (e1, e2, l) -> 
					let ne1, np1 = float_out_exp_min_max e1 in
					let ne2, np2 = float_out_exp_min_max e2 in
					let t = Ipure.BForm (Ipure.ListNotIn (ne1, ne2, l)) in
					add_exists t np1 np2 l
		  | Ipure.ListAllZero (e, l) ->
					let ne1, np1 = float_out_exp_min_max e in
					let r = match np1 with
						| None -> Ipure.BForm (Ipure.ListAllZero(ne1, l))
						| Some (r, l1) -> List.fold_left (fun a c -> Ipure.Exists ((c, Unprimed), a, l)) (Ipure.And(Ipure.BForm (Ipure.ListAllZero(ne1, l)), r, l)) l1 in r
			in		 
		match p with
			| Ipure.BForm b -> (float_out_b_formula_min_max b)
  		| Ipure.And (f1, f2, l) -> Ipure.And((float_out_pure_min_max f1), (float_out_pure_min_max f2), l)
  		| Ipure.Or (f1, f2, l) -> Ipure.Or((float_out_pure_min_max f1), (float_out_pure_min_max f2), l)
  		| Ipure.Not (f1, l) -> Ipure.Not((float_out_pure_min_max f1), l)
  		| Ipure.Forall (v, f1, l) -> Ipure.Forall (v, (float_out_pure_min_max f1), l)
  		| Ipure.Exists (v, f1, l) -> Ipure.Exists (v, (float_out_pure_min_max f1), l)
		

and float_out_heap_min_max (h :  h_formula) :
  ( h_formula * (Ipure.formula option)) =
  match h with
  |  Star
      {
         h_formula_star_h1 = f1;
         h_formula_star_h2 = f2;
         h_formula_star_pos = l
      } ->
      let (nf1, np1) = float_out_heap_min_max f1 in
      let (nf2, np2) = float_out_heap_min_max f2 in
      let np =
        (match (np1, np2) with
         | (None, None) -> None
         | (Some _, None) -> np1
         | (None, Some _) -> np2
         | (Some e1, Some e2) -> Some (Ipure.And (e1, e2, l)))
      in
        (( Star
            {
               h_formula_star_h1 = nf1;
               h_formula_star_h2 = nf2;
               h_formula_star_pos = l;
            }),
         np)
  |  HeapNode h1->
		  let args = h1. h_formula_heap_arguments in
			let l = h1. h_formula_heap_pos in
      let nl, new_p =
				List.fold_left
             (fun (a, c) d -> 
	        match d with
		| Ipure.Null _ 
		| Ipure.IConst _
		| Ipure.Var _ -> (d:: a, c)
		| _ -> 
				let new_name = fresh_var_name "ptr" l.start_pos.Lexing.pos_lnum in 
				let nv = Ipure.Var((new_name, Unprimed), l) in
				(nv:: a, match c with
												| None -> Some (float_out_pure_min_max (Ipure.BForm (Ipure.Eq (nv, d, l))) )
												| Some s -> Some (Ipure.And ((float_out_pure_min_max (Ipure.BForm (Ipure.Eq (nv, d, l)))), s, l)))) ([], None) args in
        (( HeapNode { h1 with  h_formula_heap_arguments = (List.rev nl);}), new_p)
  |  HeapNode2 h1 ->
			let args = h1. h_formula_heap2_arguments in
			let l = h1. h_formula_heap2_pos in
      let nl, new_p =
				List.fold_left
             (fun (a, c) (d1,d2) -> 
	        match d2 with
		| Ipure.Null _ 
		| Ipure.IConst _
		| Ipure.Var _ -> ((d1,d2):: a, c)
		| _ -> 
				let new_name = fresh_var_name "ptr" l.start_pos.Lexing.pos_lnum in 
				let nv = Ipure.Var((new_name, Unprimed), l) in
				((d1,nv):: a, match c with
												| None -> Some (float_out_pure_min_max (Ipure.BForm (Ipure.Eq (nv, d2, l))) )
												| Some s -> Some (Ipure.And ((float_out_pure_min_max (Ipure.BForm (Ipure.Eq (nv, d2, l))) ), s, l)))) ([], None) args in
        (( HeapNode2 { h1 with  h_formula_heap2_arguments = (List.rev nl);}), new_p)
  |  HTrue -> (h, None)
  |  HFalse -> (h, None)
  
  
and float_out_struc_min_max (f0 : struc_formula): struc_formula = 
	let rec helper (f0: ext_formula):ext_formula = match f0 with
		| EAssume b -> EAssume (float_out_min_max b)
		| ECase b-> ECase {
						 formula_case_branches = (List.map (fun (c1,c2)->
								((float_out_pure_min_max c1),(float_out_struc_min_max c2)))
								b.formula_case_branches);
						 formula_case_pos = b.formula_case_pos}
		| EBase b -> EBase {b with 
						 formula_ext_base = float_out_min_max b.formula_ext_base;
						 formula_ext_continuation = float_out_struc_min_max b.formula_ext_continuation}in
	List.map helper f0
		

and view_node_types_struc (f:struc_formula):ident list = 
	let helper (f:ext_formula):ident list = match f with
	| ECase b -> List.concat (List.map (fun (c1,c2)-> view_node_types_struc c2) b.formula_case_branches)
	| EBase b -> (view_node_types b.formula_ext_base)@(view_node_types_struc b.formula_ext_continuation)
	| EAssume b -> view_node_types b
	in
	Util.remove_dups (List.concat (List.map helper f))
		
and view_node_types (f:formula):ident list = 
	let rec helper (f:h_formula):ident list =  match f with
		| Star b -> Util.remove_dups ((helper b.h_formula_star_h1)@(helper b.h_formula_star_h2))
		| HeapNode b -> [b.h_formula_heap_name]
		| HeapNode2 b -> [b.h_formula_heap2_name]
		| _ -> [] in
	match f with
	| Or b-> Util.remove_dups ((view_node_types b.formula_or_f1) @ (view_node_types b.formula_or_f2))
	| Base b -> helper b.formula_base_heap
	| Exists b -> helper b.formula_exists_heap