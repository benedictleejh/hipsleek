(*
  Created 19-Feb-2006

  Input pure constraints, including arithmetic and pure pointer
*)

open Globals
open Gen.Basic
open Label_only
open Label

type formula = 
  | BForm of (b_formula*(formula_label option))
  | And of (formula * formula * loc)
  | AndList of (spec_label * formula) list
  | Or of (formula * formula *(formula_label option) * loc)
  | Not of (formula *(formula_label option)* loc)
  | Forall of ((ident * primed) * formula *(formula_label option)* loc)
  | Exists of ((ident * primed) * formula *(formula_label option)* loc)

(* Boolean constraints *)
and b_formula = p_formula * ((bool * int * (exp list)) option)
(* (is_linking, label, list of linking expressions in b_formula) *)


and p_formula = 
  | BConst of (bool * loc)
  | BVar of ((ident * primed) * loc)
    (* Ann Subtyping v1 <: v2 *)
  | SubAnn of (exp * exp * loc) 
  | Lt of (exp * exp * loc)
  | Lte of (exp * exp * loc)
  | Gt of (exp * exp * loc)
  | Gte of (exp * exp * loc)
  | Eq of (exp * exp * loc) (* these two could be arithmetic or pointer or bags or lists *)
  | Neq of (exp * exp * loc)
  | EqMax of (exp * exp * exp * loc) (* first is max of second and third *)
  | EqMin of (exp * exp * exp * loc) (* first is min of second and third *)
	  (* bags and bag formulae *)
  | LexVar of (term_ann * (exp list) * (exp list) * loc)
  | BagIn of ((ident * primed) * exp * loc)
  | BagNotIn of ((ident * primed) * exp * loc)
  | BagSub of (exp * exp * loc)
  | BagMin of ((ident * primed) * (ident * primed) * loc)
  | BagMax of ((ident * primed) * (ident * primed) * loc)	
	  (* lists and list formulae *)
  | VarPerm of (vp_ann * ((ident * primed) list) * loc)
  | ListIn of (exp * exp * loc)
  | ListNotIn of (exp * exp * loc)
  | ListAllN of (exp * exp * loc)  (* allN 0 list *)
  | ListPerm of (exp * exp * loc)  (* perm L2 L2 *)
  | RelForm of (ident * (exp list) * loc)           (* An Hoa: Relational formula to capture relations, for instance, s(a,b,c) or t(x+1,y+2,z+3), etc. *)

(* Expression *)
and exp = 
  | Ann_Exp of (exp * typ)
  | Null of loc
  | Level of ((ident * primed) * loc)
  | Var of ((ident * primed) * loc)
	  (* variables could be of type pointer, int, bags, lists etc *)
  | IConst of (int * loc)
  | FConst of (float * loc)
  | AConst of (heap_ann * loc)
  (*| Tuple of (exp list * loc)*)
  | Add of (exp * exp * loc)
  | Subtract of (exp * exp * loc)
  | Mult of (exp * exp * loc)
  | Div of (exp * exp * loc)
  | Max of (exp * exp * loc)
  | Min of (exp * exp * loc)
	  (* bag expressions *)
  | Bag of (exp list * loc)
  | BagUnion of (exp list * loc)
  | BagIntersect of (exp list * loc)
  | BagDiff of (exp * exp * loc)
 	  (* list expressions *)
  | List of (exp list * loc)
  | ListCons of (exp * exp * loc)
  | ListHead of (exp * loc)
  | ListTail of (exp * loc)
  | ListLength of (exp * loc)
  | ListAppend of (exp list * loc)
  | ListReverse of (exp * loc)
  | ArrayAt of ((ident * primed) * (exp list) * loc)      (* An Hoa : array access, extend the index to a list of indices for multi-dimensional array *)
  | Func of (ident * (exp list) * loc)

and relation = (* for obtaining back results from Omega Calculator. Will see if it should be here*)
  | ConstRel of bool
  |	BaseRel of (exp list * formula)
  | UnionRel of (relation * relation)

let print_formula = ref (fun (c:formula) -> "cpure printer has not been initialized")
let print_id = ref (fun (c:(ident*primed)) -> "cpure printer has not been initialized")

module Exp_Pure =
struct 
  type e = formula
  let comb x y = And (x,y,no_pos)
  let string_of = !print_formula
end;;

module Label_Pure = LabelExpr(Lab_List)(Exp_Pure);; 

let linking_exp_list = ref (Hashtbl.create 100)
let _ = let zero = IConst (0, no_pos)
		in Hashtbl.add !linking_exp_list zero 0


(* free variables *)

let rec fv (f : formula) : (ident * primed) list = match f with 
  | BForm (b,_) -> bfv b
  | And (p1, p2, _) -> combine_pvars p1 p2
  | AndList b -> Gen.BList.remove_dups_eq (=) (Gen.fold_l_snd fv b)
  | Or (p1, p2, _,_) -> combine_pvars p1 p2
  | Not (nf, _,_) -> fv nf
  | Forall (qid, qf, _,_) -> remove_qvar qid qf
  | Exists (qid, qf, _,_) -> remove_qvar qid qf

and combine_pvars p1 p2 = 
  let fv1 = fv p1 in
  let fv2 = fv p2 in
    Gen.BList.remove_dups_eq (=) (fv1 @ fv2)
	
and remove_qvar qid qf =
  let qfv = fv qf in
    Gen.BList.remove_elem_eq (=) qid qfv

and bfv (bf : b_formula) =
  let (pf,_) = bf in
  match pf with
  | BConst _ -> []
  | BVar (bv, _) -> [bv]
  | Lt (a1, a2, _) | Lte (a1, a2, _) 
  | Gt (a1, a2, _) | Gte (a1, a2, _) 
  | SubAnn (a1, a2, _) 
  | Eq (a1, a2, _) 
  | Neq (a1, a2, _) -> combine_avars a1 a2
  | EqMax (a1, a2, a3, _) -> 
	  let fv1 = afv a1 in
	  let fv2 = afv a2 in
	  let fv3 = afv a3 in
		Gen.BList.remove_dups_eq (=) (fv1 @ fv2 @ fv3)
  | EqMin (a1, a2, a3, _) ->
	  let fv1 = afv a1 in
	  let fv2 = afv a2 in
	  let fv3 = afv a3 in
		Gen.BList.remove_dups_eq (=) (fv1 @ fv2 @ fv3)
  | BagIn (v, a, _) -> 
		let fv = afv a in
		Gen.BList.remove_dups_eq (=) ([v] @ fv)
  | BagNotIn (v, a, _) -> 
		let fv = afv a in
		Gen.BList.remove_dups_eq (=) ([v] @ fv)	
  | BagSub (a1, a2, _) -> combine_avars a1 a2
  | BagMax (sv1, sv2, _) -> Gen.BList.remove_dups_eq (=) ([sv1] @ [sv2])
  | BagMin (sv1, sv2, _) -> Gen.BList.remove_dups_eq (=) ([sv1] @ [sv2])
  | VarPerm (ct,ls,_) -> 
      ls
      (* let ls1 = List.map (fun v -> (v,Unprimed)) ls in *)
      (* ls1 *)
  | ListIn (a1, a2, _) -> 
	  let fv1 = afv a1 in
	  let fv2 = afv a2 in
		Gen.BList.remove_dups_eq (=) (fv1 @ fv2)
  | ListNotIn (a1, a2, _) -> 
	  let fv1 = afv a1 in
	  let fv2 = afv a2 in
		Gen.BList.remove_dups_eq (=) (fv1 @ fv2)
  | ListAllN (a1, a2, _) ->
	  let fv1 = afv a1 in
	  let fv2 = afv a2 in
		Gen.BList.remove_dups_eq (=) (fv1 @ fv2)
  | ListPerm (a1, a2, _) ->
	  let fv1 = afv a1 in
	  let fv2 = afv a2 in
		Gen.BList.remove_dups_eq (=) (fv1 @ fv2)
  | RelForm (_,args,_) -> (* An Hoa *)
		let args_fv = List.concat (List.map afv args) in
		Gen.BList.remove_dups_eq (=) args_fv
  | LexVar (_, args1, args2, _) ->
		let args_fv = List.concat (List.map afv (args1@args2)) in
		Gen.BList.remove_dups_eq (=) args_fv
 
and combine_avars (a1 : exp) (a2 : exp) : (ident * primed) list = 
  let fv1 = afv a1 in
  let fv2 = afv a2 in
    Gen.BList.remove_dups_eq (=) (fv1 @ fv2)

and afv (af : exp) : (ident * primed) list = match af with
  | Level (sv, _) -> [sv]
  | Var (sv, _) -> let id = fst sv in
						if (id.[0] = '#') then [] else [sv]
  | Null _ 
  | AConst _ 
  | IConst _ 
  | FConst _ -> []
  | Ann_Exp (e,_) -> afv e
  | Add (a1, a2, _) -> combine_avars a1 a2
  | Subtract (a1, a2, _) -> combine_avars a1 a2
  | Mult (a1, a2, _) | Div (a1, a2, _) -> combine_avars a1 a2
  | Max (a1, a2, _) -> combine_avars a1 a2
  | Min (a1, a2, _) -> combine_avars a1 a2
  | BagDiff (a1,a2,_) ->  combine_avars a1 a2
  | Bag(d,_)
  | BagIntersect (d,_)
  | BagUnion (d,_) ->  Gen.BList.remove_dups_eq (=) (List.fold_left (fun a c-> a@(afv c)) [] d)
  (*| BagDiff _|BagIntersect _|BagUnion _|Bag _ -> failwith ("afv: bag constraints are not expected")*)
  | List (d, _)
  | ListAppend (d, _) -> Gen.BList.remove_dups_eq (=) (List.fold_left (fun a c -> a@(afv c)) [] d)
  | ListCons (a1, a2, _) ->
	  let fv1 = afv a1 in
	  let fv2 = afv a2 in
		Gen.BList.remove_dups_eq (=) (fv1 @ fv2)  
  | ListHead (a, _)
  | ListTail (a, _)
  | ListLength (a, _)
  | ListReverse (a, _) -> afv a
  | Func (a, i, _) -> 
    let ifv = List.flatten (List.map afv i) in
    Gen.BList.remove_dups_eq (=) ((a,Unprimed) :: ifv)
  | ArrayAt (a, i, _) -> 
	let ifv = List.flatten (List.map afv i) in
	Gen.BList.remove_dups_eq (=) (a :: ifv) (* An Hoa *)

and is_max_min a = match a with
  | Max _ | Min _ -> true
  | _ -> false

and is_null (e : exp) : bool = match e with
  | Null _ -> true
  | _ -> false

and is_var (e : exp) : bool = match e with
  | Var _ -> true
  | _ -> false

and is_bag (e : exp) : bool = match e with
  | Bag _
  | BagUnion _
  | BagIntersect _
  | BagDiff _ -> true
  | _ -> false
  
and is_integer e =
  match e with
  | IConst _ -> true
  | Add (e1, e2, _) | Subtract (e1, e2, _) | Mult (e1, e2, _)
  | Max (e1, e2, _) | Min (e1, e2, _) ->
      is_integer e1 && is_integer e2
  | _ -> false

and is_list (e : exp) : bool = match e with
  | List _
  | ListCons _
  | ListTail _
  | ListAppend _
  | ListReverse _ -> true
  | _ -> false

and name_of_var (e : exp) : ident = match e with
  | Var ((v, p), pos) -> v
  | _ -> failwith ("parameter to name_of_var is not a variable")
 
and isConstTrue p = match p with
  | BForm ((BConst (true, pos), _), _) -> true
  | _ -> false

and isConstFalse p = match p with
  | BForm ((BConst (false, pos), _), _) -> true
  | _ -> false

(* smart constructor *)

and mkAdd a1 a2 pos = Add (a1, a2, pos)

and mkSubtract a1 a2 pos = Subtract (a1, a2, pos)

and mkMult a1 a2 pos = Mult (a1, a2, pos)

and mkAnnExp a1 t pos = Ann_Exp (a1, t)

and mkDiv a1 a2 pos = Div (a1, a2, pos)

and mkMax a1 a2 pos = Max (a1, a2, pos)

and mkMin a1 a2 pos = Min (a1, a2, pos)

and mkBVar (v, p) pos = BVar ((v, p), pos)

and mkLt a1 a2 pos = 
  if is_max_min a1 || is_max_min a2 then 
	failwith ("max/min can only be used in equality")  
  else 
	Lt (a1, a2, pos)

and mkLte a1 a2 pos = 
  if is_max_min a1 || is_max_min a2 then 
	failwith ("max/min can only be used in equality")  
  else 
	Lte (a1, a2, pos)

and mkGt a1 a2 pos = 
  if is_max_min a1 || is_max_min a2 then 
	failwith ("max/min can only be used in equality")  
  else 
	Gt (a1, a2, pos)

and mkGte a1 a2 pos = 
  if is_max_min a1 || is_max_min a2 then 
	failwith ("max/min can only be used in equality")  
  else 
	Gte (a1, a2, pos)

and mkSubAnn a1 a2 pos = 
  if is_max_min a1 || is_max_min a2 then 
	failwith ("max/min can only be used in equality")  
  else 
	SubAnn (a1, a2, pos)

and mkNeq a1 a2 pos = 
  if is_max_min a1 || is_max_min a2 then 
	failwith ("max/min can only be used in equality")  
  else 
	Neq (a1, a2, pos)

and mkEq a1 a2 pos = 
  if is_max_min a1 && is_max_min a2 then
	failwith ("max/min can only appear in one side of an equation")
  else if is_max_min a1 then
	match a1 with
	  | Min (a11, a12, _) -> EqMin (a2, a11, a12, pos)
	  | Max (a11, a12, _) -> EqMax (a2, a11, a12, pos)
	  | _ -> failwith ("Presburger.mkAEq: something really bad has happened")
  else if is_max_min a2 then 
	match a2 with
	  | Min (a21, a22, _) -> EqMin (a1, a21, a22, pos)
	  | Max (a21, a22, _) -> EqMax (a1, a21, a22, pos)
	  | _ -> failwith ("Presburger.mkAEq: something really bad has happened")
  else 
	Eq (a1, a2, pos)

and mkAnd f1 f2 pos = match f1 with
  | BForm ((BConst (false, _), _), _) -> f1
  | BForm ((BConst (true, _), _), _) -> f2
  | _ -> match f2 with
      | BForm ((BConst (false, _), _), _) -> f2
      | BForm ((BConst (true, _), _), _) -> f1
      | _ -> match f1,f2 with 
		| AndList b1, AndList b2 ->  mkAndList (Label_Pure.merge b1 b2)
		| AndList b, f 
		| f, AndList b -> mkAndList (Label_Pure.merge b [(Lab_List.unlabelled,f)])
		| _ -> And (f1, f2, pos)

and mkAndList b = (*print_string "ipure_list_gen\n";*) AndList b
		
and mkOr f1 f2 lbl pos = match f1 with
  | BForm ((BConst (false, _), _), _) -> f2
  | BForm ((BConst (true, _), _), _) -> f1
  | _ -> match f2 with
      | BForm ((BConst (false, _), _), _) -> f1
      | BForm ((BConst (true, _), _), _) -> f2
      | _ -> Or (f1, f2, lbl, pos)

and mkEqVarExp (v1 : (ident * primed)) (v2 : (ident * primed)) pos =
  let e1 = Var (v1,pos) in
  let e2 = Var (v2,pos) in
  mkEqExp e1 e2 pos

and mkEqExp (ae1 : exp) (ae2 : exp) pos = match (ae1, ae2) with
  | (Var v1, Var v2) ->
	  if v1 = v2 then
		mkTrue pos
	  else
		BForm ((Eq (ae1, ae2, pos), None), None)
  | _ ->  BForm ((Eq (ae1, ae2, pos), None), None)

and mkNeqExp (ae1 : exp) (ae2 : exp) pos = match (ae1, ae2) with
  | (Var v1, Var v2) ->
	  if v1 = v2 then
		mkFalse pos
	  else
		BForm ((Neq (ae1, ae2, pos), None), None)
  | _ ->  BForm ((Neq (ae1, ae2, pos), None), None)

and mkNot f lbl pos = Not (f, lbl, pos)

(*
and mkEqualVar (sv1 : spec_var) (sv2 : spec_var) =
  if sv1 = sv2 then
	mkTrue
  else 
	BForm (Eq (Var (force_to_svar sv1), AVar (force_to_svar sv2)))

and mkEqualAExp (ae1 : exp) (ae2 : exp) = match (ae1, ae2) with
  | (AVar (SVar sv1), AVar (SVar sv2)) ->
	  if sv1 = sv2 then
		mkTrue
	  else
		BForm (AEq (ae1, ae2))
  | _ ->  BForm (AEq (ae1, ae2))

and mkNEqualAExp (ae1 : exp) (ae2 : exp) = match (ae1, ae2) with
  | (AVar (SVar sv1), AVar (SVar sv2)) ->
	  if sv1 = sv2 then
		mkTrue
	  else
		BForm (ANeq (ae1, ae2))
  | _ ->  BForm (ANeq (ae1, ae2))
	  
and mkNEqualVar (sv1 : spec_var) (sv2 : spec_var) = 
  if sv1 = sv2 then
	mkFalse
  else
	BForm (ANeq (AVar (force_to_svar sv1), AVar (force_to_svar sv2)))

and mkEqualVarInt (sv : spec_var) (i : int) =
  BForm (AEq (AVar (force_to_svar sv), IConst i))

and mkNEqualVarInt (sv : spec_var) (i : int) = 
  BForm (ANeq (AVar (force_to_svar sv), IConst i))
*)

and mkTrue pos = BForm ((BConst (true, pos), None), None)

and mkFalse pos = BForm ((BConst (false, pos), None) , None)

and mkExists (vs : (ident * primed) list) (f : formula) lbl pos = match vs with
  | [] -> f
  | v :: rest -> 
      let ef = mkExists rest f lbl pos in
		if List.mem v (fv ef) then
		  Exists (v, ef,lbl,  pos)
		else
		  ef

and mkForall (vs : (ident * primed) list) (f : formula) lbl pos = match vs with
  | [] -> f
  | v :: rest -> 
      let ef = mkForall rest f lbl pos in
		if List.mem v (fv ef) then
		  Forall (v, ef, lbl, pos)
		else
		  ef

(* build relation from list of expressions, for example a,b,c < d,e, f *)
and build_relation relop alist10 alist20 pos = 
  let rec helper1 ae alist = 
	let a = List.hd alist in
	let rest = List.tl alist in
	let tmp = BForm ((relop ae a pos),None) in
	  if Gen.is_empty rest then
		tmp
	  else
		let tmp1 = helper1 ae rest in
		let tmp2 = mkAnd tmp tmp1 pos in
		  tmp2 in
  let rec helper2 alist1 alist2 =
	let a = List.hd alist1 in
	let rest = List.tl alist1 in
	let tmp = helper1 a alist2 in
	  if Gen.is_empty rest then
		tmp
	  else
		let tmp1 = helper2 rest alist2 in
		let tmp2 = mkAnd tmp tmp1 pos in
		  tmp2 in
	if List.length alist10 = 0 || List.length alist20 = 0 then
	  failwith ("build_relation: zero-length list")
	else begin
	  helper2 alist10 alist20
	end

 (* An Hoa *)
and pos_of_formula (f : formula) = match f with 
	| BForm ((pf,_),_) -> begin match pf with
		  | BConst (_,p) | BVar (_,p)
		  | Lt (_,_,p) | Lte (_,_,p) | Gt (_,_,p) | Gte (_,_,p) | SubAnn (_,_,p) | Eq (_,_,p) | Neq (_,_,p)
		  | EqMax (_,_,_,p) | EqMin (_,_,_,p) 
			| BagIn (_,_,p) | BagNotIn (_,_,p) | BagSub (_,_,p) | BagMin (_,_,p) | BagMax (_,_,p)	
		  | ListIn (_,_,p) | ListNotIn (_,_,p) | ListAllN (_,_,p) | ListPerm (_,_,p)
		  | RelForm (_,_,p)  | LexVar (_,_,_,p) -> p
		  | VarPerm (_,_,p) -> p
	end
  | And (_,_,p) | Or (_,_,_,p) | Not (_,_,p)
  | Forall (_,_,_,p) -> p | Exists (_,_,_,p) -> p
  | AndList l -> match l with | x::_ -> pos_of_formula (snd x) | _-> no_pos

and pos_of_exp (e : exp) = match e with
  | Null p 
  | Var (_, p) 
  | Level (_, p) 
  | IConst (_, p) 
  | FConst (_, p) 
  | AConst (_, p) -> p
  | Ann_Exp (e,_) -> pos_of_exp e
  | Add (_, _, p) -> p
  | Subtract (_, _, p) -> p
  | Mult (_, _, p) -> p
  | Div (_, _, p) -> p
  | Max (_, _, p) -> p
  | Min (_, _, p) -> p
  | Bag (_, p) -> p
  | BagUnion (_, p) -> p
  | BagIntersect (_, p) -> p
  | BagDiff (_, _, p) -> p
  | List (_, p) -> p
  | ListAppend (_, p) -> p
  | ListCons (_, _, p) -> p
  | ListHead (_, p) -> p
  | ListTail (_, p) -> p
  | ListLength (_, p) -> p
  | ListReverse (_, p) -> p
  | Func (_, _, p) -> p
  | ArrayAt (_ ,_ , p) -> p (* An Hoa *)
  
	
	
and fresh_old_name (s: string):string = 
	let ri = try  (String.rindex s '_') with  _ -> (String.length s) in
	let n = ((String.sub s 0 ri) ^ (fresh_trailer ())) in
	n
	

and fresh_var (sv : (ident*primed)):(ident*primed) =
	let old_name = fst sv in
  let name = fresh_old_name old_name in
	(name, Unprimed) (* fresh names are unprimed *)

and fresh_vars (svs : (ident*primed) list):(ident*primed) list = List.map fresh_var svs


and eq_var (f: (ident*primed))(t:(ident*primed)):bool = ((String.compare (fst f) (fst t))==0) &&(snd f)==(snd t) 

and subst sst (f : formula) = match sst with
  | s :: rest -> subst rest (apply_one s f)
  | [] -> f 

and apply_one (fr, t) f = match f with
  | BForm (bf,lbl) -> BForm (b_apply_one (fr, t) bf, lbl)
  | AndList b -> AndList (Gen.map_l_snd (apply_one (fr,t)) b)
  | And (p1, p2, pos) -> And (apply_one (fr, t) p1,
							  apply_one (fr, t) p2, pos)
  | Or (p1, p2, lbl, pos) -> Or (apply_one (fr, t) p1,
							apply_one (fr, t) p2, lbl, pos)
  | Not (p, lbl, pos) -> Not (apply_one (fr, t) p, lbl, pos)
  | Forall (v, qf, lbl, pos) ->
	  if eq_var v fr then f
      else if eq_var v t then
        let fresh_v = fresh_var v in
        Forall (fresh_v, apply_one (fr, t) (apply_one (v, fresh_v) qf), lbl, pos)
	  else Forall (v, apply_one (fr, t) qf, lbl, pos)
  | Exists (v, qf, lbl, pos) ->
	  if eq_var v fr then f
      else if eq_var v t then
        let fresh_v = fresh_var v in
        Exists (fresh_v, apply_one (fr, t) (apply_one (v, fresh_v) qf), lbl, pos)
	  else Exists (v, apply_one (fr, t) qf, lbl, pos)
  
and b_apply_one (fr, t) bf =
  let (pf,il) = bf in
  let npf = match pf with
  | BConst _ -> pf
  | BVar (bv, pos) -> BVar ((if eq_var bv fr then t else bv), pos)
  | Lt (a1, a2, pos) -> Lt (e_apply_one (fr, t) a1,
							e_apply_one (fr, t) a2, pos)
  | Lte (a1, a2, pos) -> Lte (e_apply_one (fr, t) a1,
							  e_apply_one (fr, t) a2, pos)
  | Gt (a1, a2, pos) -> Gt (e_apply_one (fr, t) a1,
							e_apply_one (fr, t) a2, pos)
  | Gte (a1, a2, pos) -> Gte (e_apply_one (fr, t) a1,
							  e_apply_one (fr, t) a2, pos)
  | SubAnn (a1, a2, pos) -> SubAnn (e_apply_one (fr, t) a1,
							  e_apply_one (fr, t) a2, pos)
  | Eq (a1, a2, pos) -> Eq (e_apply_one (fr, t) a1,
							e_apply_one (fr, t) a2, pos)
  | Neq (a1, a2, pos) -> Neq (e_apply_one (fr, t) a1,
							  e_apply_one (fr, t) a2, pos)
  | EqMax (a1, a2, a3, pos) -> EqMax (e_apply_one (fr, t) a1,
									  e_apply_one (fr, t) a2,
									  e_apply_one (fr, t) a3, pos)
  | EqMin (a1, a2, a3, pos) -> EqMin (e_apply_one (fr, t) a1,
									  e_apply_one (fr, t) a2,
									  e_apply_one (fr, t) a3, pos)
  | BagIn (v, a1, pos) -> BagIn ((if eq_var v fr then t else v), e_apply_one (fr, t) a1, pos)
  | BagNotIn (v, a1, pos) -> BagNotIn ((if eq_var v fr then t else v), e_apply_one (fr, t) a1, pos)
	(* is it ok?... can i have a set of boolean values?... don't think so... *)
  | BagSub (a1, a2, pos) -> BagSub (e_apply_one (fr, t) a1, e_apply_one (fr, t) a2, pos)
  | BagMax (v1, v2, pos) -> BagMax ((if eq_var v1 fr then t else v1), (if eq_var v2 fr then t else v2), pos)
  | BagMin (v1, v2, pos) -> BagMin ((if eq_var v1 fr then t else v1), (if eq_var v2 fr then t else v2), pos)
  | VarPerm (ct,ls,pos) -> (*TO CHECK*)
      let func v =
        (if eq_var v fr then t else v)
      in
      let ls1 = List.map func ls in
      VarPerm (ct,ls1,pos)
  | ListIn (a1, a2, pos) -> ListIn (e_apply_one (fr, t) a1, e_apply_one (fr, t) a2, pos)
  | ListNotIn (a1, a2, pos) -> ListNotIn (e_apply_one (fr, t) a1, e_apply_one (fr, t) a2, pos)
  | ListAllN (a1, a2, pos) -> ListAllN (e_apply_one (fr, t) a1, e_apply_one (fr, t) a2, pos)
  | ListPerm (a1, a2, pos) -> ListPerm (e_apply_one (fr, t) a1, e_apply_one (fr, t) a2, pos)
  | RelForm (r, args, pos) -> 
          (* An Hoa : apply to every arguments, alternatively, use e_apply_one_list *)
          RelForm (r, (List.map (fun x -> e_apply_one (fr, t) x) args), pos)
  | LexVar (t_ann, args1, args2, pos) -> 
        let args1 = List.map (fun x -> e_apply_one (fr, t) x) args1 in
        let args2 = List.map (fun x -> e_apply_one (fr, t) x) args2 in
          LexVar (t_ann, args1,args2,pos)
  in (npf,il)

and e_apply_one ((fr, t) as p) e = match e with
  | Null _ | IConst _ 
  | FConst _ 
  | AConst _ -> e
  | Ann_Exp (e,ty) -> Ann_Exp ((e_apply_one p e), ty)
  | Var (sv, pos) -> Var ((if eq_var sv fr then t else sv), pos)
  | Level (sv, pos) -> Level ((if eq_var sv fr then t else sv), pos)
  | Add (a1, a2, pos) -> Add (e_apply_one p a1,
							  e_apply_one p a2, pos)
  | Subtract (a1, a2, pos) -> Subtract (e_apply_one p a1,
										e_apply_one p a2, pos)
  | Mult (a1, a2, pos) ->
      Mult (e_apply_one p a1, e_apply_one p a2, pos)
  | Div (a1, a2, pos) ->
      Div (e_apply_one p a1, e_apply_one p a2, pos)
  | Max (a1, a2, pos) -> Max (e_apply_one p a1,
							  e_apply_one p a2, pos)
  | Min (a1, a2, pos) -> Min (e_apply_one p a1,
							  e_apply_one p a2, pos)
	(*| BagEmpty (pos) -> BagEmpty (pos)*)
  | Bag (alist, pos) -> Bag ((e_apply_one_list p alist), pos)
  | BagUnion (alist, pos) -> BagUnion ((e_apply_one_list p alist), pos)
  | BagIntersect (alist, pos) -> BagIntersect ((e_apply_one_list p alist), pos)
  | BagDiff (a1, a2, pos) -> BagDiff (e_apply_one p a1,
							  e_apply_one p a2, pos)
  | List (alist, pos) -> List ((e_apply_one_list p alist), pos)
  | ListAppend (alist, pos) -> ListAppend ((e_apply_one_list p alist), pos)
  | ListCons (a1, a2, pos) -> ListCons (e_apply_one p a1, e_apply_one p a2, pos)
  | ListHead (a1, pos) -> ListHead (e_apply_one p a1, pos)
  | ListTail (a1, pos) -> ListTail (e_apply_one p a1, pos)
  | ListLength (a1, pos) -> ListLength (e_apply_one p a1, pos)
  | ListReverse (a1, pos) -> ListReverse (e_apply_one p a1, pos)
  | Func (a, ind, pos) -> Func (a, (e_apply_one_list p ind), pos)
  | ArrayAt (a, ind, pos) -> ArrayAt (a, (e_apply_one_list p ind), pos) (* An Hoa *)

and e_apply_one_list ((fr, t) as p) alist = match alist with
  |[] -> []
  |a :: rest -> (e_apply_one p a) :: (e_apply_one_list p rest)

(* apply_one function for the formula_ext_measures of ext_variance_formula *)
and e_apply_one_list_of_pair ((fr, t) as p) list_of_pair = match list_of_pair with
  | [] -> []
  | (expr, bound)::rest -> match bound with
							| None -> ((e_apply_one p expr), None)::(e_apply_one_list_of_pair p rest)
							| Some b_expr ->  ((e_apply_one p expr), Some (e_apply_one p b_expr))::(e_apply_one_list_of_pair p rest)

and subst_list_of_pair sst ls = match sst with
  | [] -> ls
  | s::rest -> subst_list_of_pair rest (e_apply_one_list_of_pair s ls)
			 						
and subst_list_of_exp sst ls = match sst with
	| [] -> ls
	| s::rest -> subst_list_of_exp rest (e_apply_one_list s ls)

and look_for_anonymous_exp_list (args : exp list) :
  (ident * primed) list =
  match args with
  | h :: rest ->
      List.append (look_for_anonymous_exp h)
        (look_for_anonymous_exp_list rest)
  | _ -> []

and anon_var (id, p) = 
      if ((String.length id) > 5) &&
          ((String.compare (String.sub id 0 5) "Anon_") == 0)
      then [ (id, p) ]
      else []

and look_for_anonymous_exp (arg : exp) : (ident * primed) list = match arg with
  | Var (b1, _) -> anon_var b1
  | Add (e1, e2, _) | Subtract (e1, e2, _) | Max (e1, e2, _) |
      Min (e1, e2, _) | BagDiff (e1, e2, _) ->
      List.append (look_for_anonymous_exp e1) (look_for_anonymous_exp e2)

  | Mult (e1, e2, _) | Div (e1, e2, _) ->
      List.append (look_for_anonymous_exp e1) (look_for_anonymous_exp e2)
  | Bag (e1, _) | BagUnion (e1, _) | BagIntersect (e1, _) ->  look_for_anonymous_exp_list e1

  | ListHead (e1, _) | ListTail (e1, _) | ListLength (e1, _) | ListReverse (e1, _) -> look_for_anonymous_exp e1
  | List (e1, _) | ListAppend (e1, _) -> look_for_anonymous_exp_list e1
  | ListCons (e1, e2, _) -> (look_for_anonymous_exp e1) @ (look_for_anonymous_exp e2)
  | _ -> []

and look_for_anonymous_pure_formula (f : formula) : (ident * primed) list = match f with
  | BForm (b,_) -> look_for_anonymous_b_formula b
  | And (b1,b2,_) -> (look_for_anonymous_pure_formula b1)@ (look_for_anonymous_pure_formula b1)
  | AndList b -> Gen.fold_l_snd look_for_anonymous_pure_formula b 
  | Or  (b1,b2,_,_) -> (look_for_anonymous_pure_formula b1)@ (look_for_anonymous_pure_formula b1)
  | Not (b1,_,_) -> (look_for_anonymous_pure_formula b1)
  | Forall (_,b1,_,_)-> (look_for_anonymous_pure_formula b1)
  | Exists (_,b1,_,_)-> (look_for_anonymous_pure_formula b1)

	
and look_for_anonymous_b_formula (f : b_formula) : (ident * primed) list =
  let (pf,_) = f in
  match pf with
  | BConst _ -> []
  | BVar (b1, _) -> anon_var b1
  | Lt (b1, b2, _) -> (look_for_anonymous_exp b1) @ (look_for_anonymous_exp b2)
  | Lte (b1, b2, _) -> (look_for_anonymous_exp b1) @ (look_for_anonymous_exp b2)
  | Gt (b1, b2, _) -> (look_for_anonymous_exp b1) @ (look_for_anonymous_exp b2)
  | Gte (b1, b2, _) -> (look_for_anonymous_exp b1) @ (look_for_anonymous_exp b2)
  | SubAnn (b1, b2, _) -> (look_for_anonymous_exp b1) @ (look_for_anonymous_exp b2)
  | Eq (b1, b2, _) -> (look_for_anonymous_exp b1) @ (look_for_anonymous_exp b2)
  | Neq (b1, b2, _) -> (look_for_anonymous_exp b1) @ (look_for_anonymous_exp b2)
  | EqMax (b1, b2, b3, _) -> (look_for_anonymous_exp b1) @ (look_for_anonymous_exp b2) @ (look_for_anonymous_exp b3)
  | EqMin(b1, b2, b3, _) -> (look_for_anonymous_exp b1) @ (look_for_anonymous_exp b2) @ (look_for_anonymous_exp b3)
  | BagIn (b1, b2, _) -> (anon_var b1) @ (look_for_anonymous_exp b2)
  | BagNotIn (b1, b2, _) -> (anon_var b1) @ (look_for_anonymous_exp b2)
  | BagSub (b1, b2, _) -> (look_for_anonymous_exp b1) @ (look_for_anonymous_exp b2)
  | BagMin (b1, b2, _) -> (anon_var b1) @ (anon_var b2)
  | BagMax (b1, b2, _) -> (anon_var b1) @ (anon_var b2)	
  | VarPerm _ -> [] (*can not have anon_var*)
  | ListIn (b1, b2,  _) -> (look_for_anonymous_exp b1) @ (look_for_anonymous_exp b2)
  | ListNotIn (b1, b2, _) -> (look_for_anonymous_exp b1) @ (look_for_anonymous_exp b2)
  | ListAllN (b1, b2, _) -> (look_for_anonymous_exp b1) @ (look_for_anonymous_exp b2)
  | ListPerm (b1, b2, _) -> (look_for_anonymous_exp b1) @ (look_for_anonymous_exp b2)
  | LexVar (_,args1, args2, _) -> 
        let vs = List.concat (List.map look_for_anonymous_exp (args1@args2)) in
        vs
  | RelForm (_,args,_) -> 
        let vs = List.concat (List.map look_for_anonymous_exp (args)) in
        vs

  
let merge_branches l1 l2 =
  let branches = Gen.BList.remove_dups_eq (=) (fst (List.split l1) @ (fst (List.split l2))) in
  let map_fun branch =
    try 
      let l1 = List.assoc branch l1 in
      try
        let l2 = List.assoc branch l2 in
        (branch, mkAnd l1 l2 no_pos)
      with Not_found -> (branch, l1)
    with Not_found -> (branch, List.assoc branch l2)
  in
  List.map map_fun branches

let rec find_lexp_formula (f: formula) ls =
  match f with
	| BForm (bf, _) -> find_lexp_b_formula bf ls
	| _ -> []
	
and find_lexp_b_formula (bf: b_formula) ls =
  let (pf, _) = bf in
  match pf with
	| BConst _
	| BVar _ -> []
	| Lt (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| Lte (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| Gt (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| Gte (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| SubAnn (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| Eq (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| Neq (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| EqMax (e1, e2, e3, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls @ find_lexp_exp e3 ls
	| EqMin (e1, e2, e3, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls @ find_lexp_exp e3 ls
	| BagIn (_, e, _) -> find_lexp_exp e ls
	| BagNotIn (_, e, _) -> find_lexp_exp e ls
	| BagSub (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| BagMin _ | BagMax _ -> []
	| VarPerm _ -> []
	| ListIn (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| ListNotIn (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| ListAllN (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| ListPerm (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| RelForm (_, el, _) -> List.fold_left (fun acc e -> acc @ find_lexp_exp e ls) [] el
	| LexVar (_,e1, e2, _) -> List.fold_left (fun acc e -> acc @ find_lexp_exp e ls) [] (e1@e2)

(* WN : what does this method do? *)
and find_lexp_exp (e: exp) ls =
  if Hashtbl.mem ls e then [e] else
  match e with
	| Null _
	| Var _
	| Level _
	| IConst _
	| AConst _
	| FConst _ -> []
    | Ann_Exp(e,_) -> find_lexp_exp e ls
	| Add (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| Subtract (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| Mult (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| Div (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| Min (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| Max (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| Bag (el, _) -> List.fold_left (fun acc e -> acc @ find_lexp_exp e ls) [] el
	| BagUnion (el, _) -> List.fold_left (fun acc e -> acc @ find_lexp_exp e ls) [] el
	| BagIntersect (el, _) -> List.fold_left (fun acc e -> acc @ find_lexp_exp e ls) [] el
	| BagDiff (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| List (el, _) -> List.fold_left (fun acc e -> acc @ find_lexp_exp e ls) [] el
	| ListCons (e1, e2, _) -> find_lexp_exp e1 ls @ find_lexp_exp e2 ls
	| ListHead (e, _) -> find_lexp_exp e ls
	| ListTail (e, _) -> find_lexp_exp e ls
	| ListLength (e, _) -> find_lexp_exp e ls
	| ListAppend (el, _) -> List.fold_left (fun acc e -> acc @ find_lexp_exp e ls) [] el
	| ListReverse (e, _) -> find_lexp_exp e ls
  | Func (_, el, _) -> List.fold_left (fun acc e -> acc @ find_lexp_exp e ls) [] el
	| ArrayAt (_, el, _) -> List.fold_left (fun acc e -> acc @ find_lexp_exp e ls) [] el
;;

let rec break_pure_formula (f: formula) : b_formula list =
  match f with
	| BForm (bf, _) -> [bf]
	| And (f1, f2, _) -> (break_pure_formula f1) @ (break_pure_formula f2)
	| AndList b -> Gen.fold_l_snd break_pure_formula b
	| Or (f1, f2, _, _) -> (break_pure_formula f1) @ (break_pure_formula f2)
	| Not (f, _, _) -> break_pure_formula f
	| Forall (_, f, _, _) -> break_pure_formula f
	| Exists (_, f, _, _) -> break_pure_formula f

let rec list_of_conjs (f: formula) : formula list =
  match f with
	| And (f1, f2, _) -> (list_of_conjs f1) @ (list_of_conjs f2)
    | _ -> [f]

let rec conj_of_list (fs:formula list) : formula =
  match fs with
    | [] -> mkTrue no_pos
    | x::xs -> List.fold_left (fun a c-> mkAnd a c no_pos) x xs

let rec contain_vars_exp (expr : exp) : bool =
  match expr with
  | Null _ 
  | Var _ 
  | Level _ 
  | IConst _ 
  | AConst _ 
  | FConst _ -> false
  | Ann_Exp (exp,_) -> (contain_vars_exp exp)
  | Add (exp1, exp2, _) -> (contain_vars_exp exp1) || (contain_vars_exp exp2)
  | Subtract (exp1, exp2, _) -> (contain_vars_exp exp1) || (contain_vars_exp exp2)
  | Mult (exp1, exp2, _) -> (contain_vars_exp exp1) || (contain_vars_exp exp2)
  | Div (exp1, exp2, _) -> (contain_vars_exp exp1) || (contain_vars_exp exp2)
  | Max (exp1, exp2, _) -> (contain_vars_exp exp1) || (contain_vars_exp exp2)
  | Min (exp1, exp2, _) -> (contain_vars_exp exp1) || (contain_vars_exp exp2)
  | Bag (expl, _) -> List.exists (fun e -> contain_vars_exp e) expl
  | BagUnion (expl, _) -> List.exists (fun e -> contain_vars_exp e) expl
  | BagIntersect (expl, _) -> List.exists (fun e -> contain_vars_exp e) expl
  | BagDiff (exp1, exp2, _) -> (contain_vars_exp exp1) || (contain_vars_exp exp2)
  | List (expl, _) -> List.exists (fun e -> contain_vars_exp e) expl
  | ListCons (exp1, exp2, _) -> (contain_vars_exp exp1) || (contain_vars_exp exp2)
  | ListHead (exp, _) -> contain_vars_exp exp
  | ListTail (exp, _) -> contain_vars_exp exp
  | ListLength (exp, _) -> contain_vars_exp exp
  | ListAppend (expl, _) -> List.exists (fun e -> contain_vars_exp e) expl
  | ListReverse (exp, _) -> contain_vars_exp exp
  | Func _ -> true
  | ArrayAt _ -> true 
and float_out_exp_min_max (e: exp): (exp * (formula * (string list) ) option) = match e with 
  | Null _ 
  | Var _ 
  | Level _ 
  | IConst _ 
  | AConst _ 
  | FConst _ -> (e, None)
  | Ann_Exp (e,_) -> float_out_exp_min_max e
  | Add (e1, e2, l) ->
		let ne1, np1 = float_out_exp_min_max e1 in
		let ne2, np2 = float_out_exp_min_max e2 in
		let r = match (np1, np2) with
		  | None, None -> None
		  | Some p, None -> Some p
		  | None, Some p -> Some p
		  | Some (p1, l1), Some (p2, l2) -> Some ((And (p1, p2, l)), (List.rev_append l1 l2))in
		(Add (ne1, ne2, l), r) 
  | Subtract (e1, e2, l) ->
		let ne1, np1 = float_out_exp_min_max e1 in
		let ne2, np2 = float_out_exp_min_max e2 in
		let r = match (np1, np2) with
		  | None, None -> None
		  | Some p, None -> Some p
		  | None, Some p -> Some p
		  | Some (p1, l1), Some (p2, l2) -> Some ((And (p1, p2, l)), (List.rev_append l1 l2))in
		(Subtract (ne1, ne2, l), r) 
  | Mult (e1, e2, l) ->
        let ne1, np1 = float_out_exp_min_max e1 in
        let ne2, np2 = float_out_exp_min_max e2 in
        let r = match np1, np2 with
          | None, None -> None
          | Some p, None -> Some p
          | None, Some p -> Some p
          | Some (p1, l1), Some (p2, l2) -> Some ((And (p1, p2, l)), (List.rev_append l1 l2))
        in (Mult (ne1, ne2, l), r)
  | Div (e1, e2, l) ->
        let ne1, np1 = float_out_exp_min_max e1 in
        let ne2, np2 = float_out_exp_min_max e2 in
        let r = match np1, np2 with
          | None, None -> None
          | Some p, None -> Some p
          | None, Some p -> Some p
          | Some (p1, l1), Some (p2, l2) -> Some ((And (p1, p2, l)), (List.rev_append l1 l2))
        in (Div (ne1, ne2, l), r)						 
  | Max (e1, e2, l) ->
		let ne1, np1 = float_out_exp_min_max e1 in
		let ne2, np2 = float_out_exp_min_max e2 in
		let new_name = ("max"^(fresh_trailer())) in
		let nv = Var((new_name, Unprimed), l) in
		let lexp = find_lexp_exp e !linking_exp_list in (* find the linking exp inside Max *)
		let t = BForm ((EqMax(nv, ne1, ne2, l), Some(false, Globals.fresh_int(), lexp)), None) in
		(* $ h = 1 + max(h1, h2) -> <$,_> h = 1 + max_1 & <_,_> max_1 = max(h1, h2) ==> h is still separated from h1, h2 *)
		let r = match (np1, np2) with
		  | None, None -> Some (t,[new_name])
		  | Some (p1, l1), None -> Some ((And(p1, t, l)), (new_name:: l1))
		  | None, Some (p1, l1) -> Some ((And(p1, t, l)), (new_name:: l1))
		  | Some (p1, l1), Some (p2, l2) -> Some ((And ((And (p1, t, l)), p2, l)), new_name:: (List.rev_append l1 l2)) in
		(nv, r) 
			
			
  | Min (e1, e2, l) ->
		let ne1, np1 = float_out_exp_min_max e1 in
		let ne2, np2 = float_out_exp_min_max e2 in
		let new_name = ("min"^(fresh_trailer())) in
		let nv = Var((new_name, Unprimed), l) in
		let lexp = find_lexp_exp e !linking_exp_list in (* find the linking exp inside Min *)
		let t = BForm ((EqMin(nv, ne1, ne2, l), Some(false, Globals.fresh_int(), lexp)), None) in 
		let r = match (np1, np2) with
		  | None, None -> Some (t,[new_name])
		  | Some (p1, l1), None -> Some ((And(p1, t, l)), (new_name:: l1))
		  | None, Some (p2, l2) -> Some ((And(p2, t, l)), (new_name:: l2))
		  | Some (p1, l1), Some (p2, l2) -> Some ((And ((And (p1, t, l)), p2, l)), new_name:: (List.rev_append l1 l2)) in
		(nv, r) 
	        
  (* bag expressions *)
  | Bag (le, l) ->
		let ne1, np1 = List.split (List.map float_out_exp_min_max le) in
		let r = List.fold_left (fun a c -> match (a, c)with
		  | None, None -> None
		  | Some p, None -> Some p
		  | None, Some p -> Some p
		  | Some (p1, l1), Some (p2, l2) -> Some ((And (p1, p2, l)), (List.rev_append l1 l2))) None np1 in
		(Bag (ne1, l), r)
  | BagUnion (le, l) ->
		let ne1, np1 = List.split (List.map float_out_exp_min_max le) in
		let r = List.fold_left (fun a c -> match (a, c)with
		  | None, None -> None
		  | Some p, None -> Some p
		  | None, Some p -> Some p
		  | Some (p1, l1), Some (p2, l2) -> Some ((And (p1, p2, l)), (List.rev_append l1 l2))) None np1 in
		(BagUnion (ne1, l), r)
  | BagIntersect (le, l) ->
		let ne1, np1 = List.split (List.map float_out_exp_min_max le) in
		let r = List.fold_left (fun a c -> match (a, c)with
		  | None, None -> None
		  | Some p, None -> Some p
		  | None, Some p -> Some p
		  | Some (p1, l1), Some (p2, l2) -> Some ((And (p1, p2, l)), List.rev_append l1 l2)) None np1 in
		(BagIntersect (ne1, l), r)
  | BagDiff (e1, e2, l) ->
		let ne1, np1 = float_out_exp_min_max e1 in
		let ne2, np2 = float_out_exp_min_max e2 in
		let r = match (np1, np2) with
		  | None, None -> None
		  | Some p, None -> Some p
		  | None, Some p -> Some p
		  | Some (p1, l1), Some (p2, l2) -> Some ((And (p1, p2, l)), (List.rev_append l1 l2)) in
		(BagDiff (ne1, ne2, l), r) 
		    (* list expressions *)
  | List (le, l) ->
		let ne1, np1 = List.split (List.map float_out_exp_min_max le) in
		let r = List.fold_left (fun a c -> match (a, c) with
		  | None, None -> None
		  | Some p, None -> Some p
		  | None, Some p -> Some p
		  | Some (p1, l1), Some (p2, l2) -> Some ((And (p1, p2, l)), (List.rev_append l1 l2))) None np1 in
		(List (ne1, l), r)
  | ListAppend (le, l) ->
		let ne1, np1 = List.split (List.map float_out_exp_min_max le) in
		let r = List.fold_left (fun a c -> match (a, c) with
		  | None, None -> None
		  | Some p, None -> Some p
		  | None, Some p -> Some p
		  | Some (p1, l1), Some (p2, l2) -> Some ((And (p1, p2, l)), (List.rev_append l1 l2))) None np1 in
		(ListAppend (ne1, l), r)
  | ListCons (e1, e2, l) -> 
		let ne1, np1 = float_out_exp_min_max e1 in
		let ne2, np2 = float_out_exp_min_max e2 in
		let r = match (np1, np2) with
		  | None, None -> None
		  | Some p, None -> Some p
		  | None, Some p -> Some p
		  | Some (p1, l1), Some (p2, l2) -> Some ((And (p1, p2, l)), (List.rev_append l1 l2)) in
		(ListCons (ne1, ne2, l), r) 
  | ListHead (e, l) -> 
		let ne1, np1 = float_out_exp_min_max e in
		(ListHead (ne1, l), np1)
  | ListTail (e, l) -> 
		let ne1, np1 = float_out_exp_min_max e in
		(ListTail (ne1, l), np1)
  | ListLength (e, l) -> 
		let ne1, np1 = float_out_exp_min_max e in
		(ListLength (ne1, l), np1)
  | ListReverse (e, l) -> 
		let ne1, np1 = float_out_exp_min_max e in
		(ListReverse (ne1, l), np1)
  | Func (a, i, l) ->
    let ne1, np1 = List.split (List.map float_out_exp_min_max i) in
    let r = List.fold_left (fun a c -> match (a, c) with
      | None, None -> None
      | Some p, None -> Some p
      | None, Some p -> Some p
      | Some (p1, l1), Some (p2, l2) -> Some ((And (p1, p2, l)), (List.rev_append l1 l2))) None np1 in
    (Func (a, ne1, l), r)
	        (* An Hoa : get rid of min/max in a[i] *)
  | ArrayAt (a, i, l) ->
  		let ne1, np1 = List.split (List.map float_out_exp_min_max i) in
		let r = List.fold_left (fun a c -> match (a, c) with
		  | None, None -> None
		  | Some p, None -> Some p
		  | None, Some p -> Some p
		  | Some (p1, l1), Some (p2, l2) -> Some ((And (p1, p2, l)), (List.rev_append l1 l2))) None np1 in
		(ArrayAt (a, ne1, l), r)

and float_out_pure_min_max (p : formula) : formula =
  
  let add_exists (t: formula)(np1: (formula * (string list))option)(np2: (formula * (string list))option) l: formula = 
	let r, ev = match np1 with
	  | None -> (t,[])
	  | Some (p1, ev1) -> (And (t, p1, l), ev1) in
	let r, ev2 = match np2 with 
	  | None -> (r, ev)
	  | Some (p1, ev1) -> (And(r, p1, l), (List.rev_append ev1 ev)) in 
	List.fold_left (fun a c -> (Exists ((c, Unprimed), a, None,l))) r ev2 in
    
  let rec float_out_b_formula_min_max (b: b_formula) lbl: formula =
	let (pf,il) = b in
	match pf with
	  | BConst _ | BVar _ 
	  | LexVar _ -> BForm (b,lbl)
	  | Lt (e1, e2, l) ->
			let ne1, np1 = float_out_exp_min_max e1 in
			let ne2, np2 = float_out_exp_min_max e2 in
			let t = BForm ((Lt (ne1, ne2, l), il), lbl) in
			add_exists t np1 np2 l
	  | Lte (e1, e2, l) ->
			let ne1, np1 = float_out_exp_min_max e1 in
			let ne2, np2 = float_out_exp_min_max e2 in
			let t = BForm ((Lte (ne1, ne2, l), il),lbl) in
			add_exists t np1 np2 l
	  | Gt (e1, e2, l) ->
			let ne1, np1 = float_out_exp_min_max e1 in
			let ne2, np2 = float_out_exp_min_max e2 in
			let t = BForm ((Gt (ne1, ne2, l), il), lbl) in
			add_exists t np1 np2 l
	  | Gte (e1, e2, l) ->
			let ne1, np1 = float_out_exp_min_max e1 in
			let ne2, np2 = float_out_exp_min_max e2 in
			let t = BForm ((Gte (ne1, ne2, l), il), lbl) in
			add_exists t np1 np2 l
	  | Eq (e1, e2, l) ->
            (* WN : why not change below to a method? *)
			let r = match e1 with
			  | Min(v1, v2, v3) -> let r2 = match e2 with
				  | Null _
				  | IConst _
                  | FConst _
                  | AConst _
				  | Var _ ->
						let ne1 , np1 = float_out_exp_min_max v1 in
						let ne2 , np2 = float_out_exp_min_max v2 in
						let t = BForm((EqMin(e2, ne1, ne2, l), il), lbl) in
						add_exists t np1 np2 l
				  | _ -> 
						let ne1, np1 = float_out_exp_min_max e1 in
						let ne2, np2 = float_out_exp_min_max e2 in
						let t = BForm ((Eq (ne1, ne2, l), il), lbl) in
						add_exists t np1 np2 l  in r2
			  | Max(v1, v2, v3) -> let r2 = match e2 with
				  | Null _
				  | IConst _
                  | AConst _
				  | Var _ ->
						let ne1 , np1 = float_out_exp_min_max v1 in
						let ne2 , np2 = float_out_exp_min_max v2 in
						let t = BForm ((EqMax(e2, ne1, ne2, l), il), lbl) in
						add_exists t np1 np2 l
				  | _ -> 
						let ne1, np1 = float_out_exp_min_max e1 in
						let ne2, np2 = float_out_exp_min_max e2 in
						let t = BForm ((Eq (ne1, ne2, l), il), lbl) in
						add_exists t np1 np2 l 
				in r2
			  | Null _
			  | IConst _
              | FConst _
              | AConst _
			  | Var _ -> let r2 = match e2 with
				  | Min (v1, v2, v3) ->
						let ne1 , np1 = float_out_exp_min_max v1 in
						let ne2 , np2 = float_out_exp_min_max v2 in
						let t = BForm ((EqMin(e1, ne1, ne2, l), il), lbl) in
						add_exists t np1 np2 l
				  | Max (v1, v2, v3) ->
						let ne1 , np1 = float_out_exp_min_max v1 in
						let ne2 , np2 = float_out_exp_min_max v2 in
						let t = BForm ((EqMax(e1, ne1, ne2, l), il), lbl) in
						add_exists t np1 np2 l
				  | _ -> 
						let ne1, np1 = float_out_exp_min_max e1 in
						let ne2, np2 = float_out_exp_min_max e2 in
						let t = BForm ((Eq (ne1, ne2, l), il), lbl) in
						add_exists t np1 np2 l 
				in r2
			  | _ ->
					let ne1, np1 = float_out_exp_min_max e1 in
					let ne2, np2 = float_out_exp_min_max e2 in
					let t = BForm ((Eq (ne1, ne2, l), il), lbl) in
					add_exists t np1 np2 l 
			in r
	  | Neq (e1, e2, l) ->
			let ne1, np1 = float_out_exp_min_max e1 in
			let ne2, np2 = float_out_exp_min_max e2 in
			let t = BForm ((Neq (ne1, ne2, l), il), lbl) in
			add_exists t np1 np2 l
	  | EqMax (e1, e2, e3, l) ->
			let ne1, np1 = float_out_exp_min_max e1 in
			let ne2, np2 = float_out_exp_min_max e2 in
			let ne3, np3 = float_out_exp_min_max e3 in
			let t = BForm ((EqMax (ne1, ne2, ne3, l), il), lbl) in
			let t = add_exists t np1 np2 l in
			let r = match np3 with 
			  | None -> t
			  | Some (p1, l1) -> List.fold_left (fun a c -> (Exists ((c, Unprimed), a, lbl, l))) (And(t, p1, l)) l1 in r
	  | EqMin (e1, e2, e3, l) ->
			let ne1, np1 = float_out_exp_min_max e1 in
			let ne2, np2 = float_out_exp_min_max e2 in
			let ne3, np3 = float_out_exp_min_max e3 in
			let t = BForm ((EqMin (ne1, ne2, ne3, l), il), lbl) in
			let t = add_exists t np1 np2 l in
			let r = match np3 with 
			  | None -> t
			  | Some (p1, l1) -> List.fold_left (fun a c -> Exists ((c, Unprimed), a, lbl, l)) (And(t, p1, l)) l1 in r
	  | BagIn (v, e, l) -> 
			let ne1, np1 = float_out_exp_min_max e in
			let r = match np1 with
			  | None -> BForm ((BagIn(v, ne1, l), il), lbl)
			  | Some (r, l1) -> List.fold_left (fun a c -> Exists ((c, Unprimed), a, lbl, l)) (And (BForm ((BagIn(v, ne1, l), il), lbl), r, l)) l1 in r 
	  | BagNotIn (v, e, l) -> 
			let ne1, np1 = float_out_exp_min_max e in
			let r = match np1 with
			  | None -> BForm ((BagNotIn(v, ne1, l), il), lbl)
			  | Some (r, l1) -> List.fold_left (fun a c -> Exists ((c, Unprimed), a, lbl,  l)) (And (BForm ((BagIn(v, ne1, l), il), lbl), r, l)) l1 in r
	  | BagSub (e1, e2, l) ->
			let ne1, np1 = float_out_exp_min_max e1 in
			let ne2, np2 = float_out_exp_min_max e2 in
			let t = BForm ((BagSub (ne1, ne2, l), il), lbl) in
			add_exists t np1 np2 l
	  | SubAnn _
      | VarPerm _
	  | BagMin _ 
	  | BagMax _ -> BForm (b,lbl)	
	  | ListIn (e1, e2, l) -> 
			let ne1, np1 = float_out_exp_min_max e1 in
			let ne2, np2 = float_out_exp_min_max e2 in
			let t = BForm ((ListIn (ne1, ne2, l), il), lbl) in
			add_exists t np1 np2 l
	  | ListNotIn (e1, e2, l) -> 
			let ne1, np1 = float_out_exp_min_max e1 in
			let ne2, np2 = float_out_exp_min_max e2 in
			let t = BForm ((ListNotIn (ne1, ne2, l), il), lbl) in
			add_exists t np1 np2 l
	  | ListAllN (e1, e2, l) ->
			let ne1, np1 = float_out_exp_min_max e1 in
			let ne2, np2 = float_out_exp_min_max e2 in
			let t = BForm ((ListAllN (ne1, ne2, l), il), lbl) in
			add_exists t np1 np2 l
	  | ListPerm (e1, e2, l) ->
			let ne1, np1 = float_out_exp_min_max e1 in
			let ne2, np2 = float_out_exp_min_max e2 in
			let t = BForm ((ListPerm (ne1, ne2, l), il), lbl) in
			add_exists t np1 np2 l
			    (* An Hoa : handle relation *)
			    (* TODO Have to add the existential before the formula! Add a add_exists with a list instead *)
	  | RelForm (r, args, l) ->
			let nargs = List.map float_out_exp_min_max args in
			let nargse = List.map fst nargs in
			let t = BForm ((RelForm (r, nargse, l), il), lbl) in
			t
  in		 
  match p with
	| BForm (b,lbl) -> (float_out_b_formula_min_max b lbl)
  	| And (f1, f2, l) -> And((float_out_pure_min_max f1), (float_out_pure_min_max f2), l)
	| AndList b -> AndList (Gen.map_l_snd float_out_pure_min_max b)
  	| Or (f1, f2, lbl, l) -> Or((float_out_pure_min_max f1), (float_out_pure_min_max f2), lbl,l)
  	| Not (f1,lbl, l) -> Not((float_out_pure_min_max f1), lbl, l)
  	| Forall (v, f1, lbl, l) -> Forall (v, (float_out_pure_min_max f1), lbl, l)
  	| Exists (v, f1, lbl, l) -> Exists (v, (float_out_pure_min_max f1), lbl, l)

let find_equal_var (p:formula) : ((ident*primed) * (ident*primed)) list =
  (match p with
    | BForm ((p_f,_),_) ->
        (match p_f with
          | Eq (e1,e2,pos) ->
              (match e1,e2 with
                | Var (v1,_), Var (v2,_) ->
                    [(v1,v2)]
                | _ -> []
              )
          | _ -> []
        )
    | _ -> []
  )

let find_closure (v:(ident*primed)) (vv:((ident*primed) * (ident*primed)) list) : (ident*primed) list = 
  let rec helper (vs: (ident*primed) list) (vv:((ident*primed) * (ident*primed)) list) =
    match vv with
      | (v1,v2)::xs -> 
          let v3 = if (List.exists (fun v -> eq_var v v1) vs) then Some v2
              else if (List.exists (fun v -> eq_var v v2) vs) then Some v1
              else 
                None 
          in
          (match v3 with
            | None -> helper vs xs
            | Some x -> helper (x::vs) xs)
      | [] -> vs
  in
  helper [v] vv

let find_closure_pure_x (v:(ident*primed)) (f:formula) : (ident*primed) list =
  let ps = list_of_conjs f in
  let eqvars = List.map find_equal_var ps in
  let eqvars = List.concat eqvars in
  find_closure v eqvars

(*find all variables that are equal to variable v*)
let find_closure_pure (v:(ident*primed)) (f:formula) : (ident*primed) list =
  let pr = pr_list !print_id in
  Debug.no_2 "find_closure_pure"
      !print_id !print_formula pr
      find_closure_pure_x v f

(*parition a formula f into those of vs and the rest*)
let partition_pointer (vs:(ident*primed) list) (f:formula) : (formula list)* (formula list) =
  let ps = list_of_conjs f in
  let rec helper ps =
    match ps with
      | [] -> [],[]
      | (e::es) ->
          let ls1,ls2 = helper es in
          let vars = find_equal_var e in
          let vars = List.map (fun (v1,v2) -> [v1;v2]) vars in
          let vars = List.concat vars in
          if (vars!=[] & List.for_all (fun v -> Gen.BList.mem_eq eq_var v vs) vars) then
            (*YES: belong to vs*)
            (e::ls1),ls2
          else
            ls1,e::ls2
  in
  let ls1,ls2 = helper ps in
  (ls1,ls2)

and subst_var (fr, t) (o : (ident*primed)) = if (eq_var fr o) then t else o

(*x'=x ==> x_new = x_old*)
let trans_special_formula s (p:formula) vars =
  (match p with
    | BForm ((p_f,sth1),sth2) ->
        (match p_f with
          | Eq (e1,e2,pos) ->
              (match e1,e2 with
                | Var ((id1,p1),pos1), Var ((id2,p2),pos2) ->
                    (*x'=x*)
                    if (id1=id2) & (p1!=p2) then
                      if (Gen.BList.mem_eq eq_var (id1,p1) vars) || (Gen.BList.mem_eq eq_var (id2,p2) vars) then
                        let unprimed_param = (id1,Unprimed) in
                        let primed_param = (id1,Primed) in
                        let old_param = (id1^"_old",Unprimed) in
                        let new_param = (id1^"_new",Unprimed) in
                        let s1 = (unprimed_param,old_param) in
                        let s2 = (primed_param,new_param) in
                        (*??? QUICK TRICK*)
                        (* let _ = print_endline ("v1 = " ^ (!print_id (id1,p1))) in *)
                        (* let _ = print_endline ("v2 = " ^ (!print_id (id2,p2))) in *)
                        let new_v1 = subst_var s1 (id1,p1) in
                        let new_v1 = subst_var s2 new_v1 in
                        let new_v2 = subst_var s1 (id2,p2) in
                        let new_v2 = subst_var s2 new_v2 in
                        let e1 = Var (new_v1,pos1) in
                        let e2 = Var (new_v2,pos2) in
                        let ee = Eq (e1,e2,pos) in
                        BForm ((ee,sth1),sth2)
                      else p
                    else p
                | _ -> p
              )
          | _ -> p
        )
    | _ -> p
  )
