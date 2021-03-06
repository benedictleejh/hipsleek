/**
 Left-leaning Red Black Tree
 Modified from RedBlackBST.java
 @author: Vu An Hoa
 */

data node {
	int val;
	int color; /* 0 for red, 1 for black */
	node left;
	node right;
}


/* view for red-black trees */
rb<n, cl, bh> == self = null & n = 0 & bh = 1 & cl = 1
	// self is red, both child must be black
	or self::node<v, 0, l, r> * l::rb<ln, 1, lbh> * r::rb<rn, 1, rbh>
	   & cl = 0 & n = 1 + ln + rn & lbh = bh & rbh = bh
	// if left is black, right must be black due to left-leaning!
	or self::node<v, 1, l, r> * l::rb<ln, 1, lbh> * r::rb<rn, 1, rbh>
       & cl = 1 & n = 1 + ln + rn & lbh = rbh & bh = 1 + lbh
	or self::node<v, 1, l, r> * l::rb<ln, 0, lbh> * r::rb<rn, _, rbh>
       & cl = 1 & n = 1 + ln + rn & lbh = rbh & bh = 1 + lbh
	inv n >= 0 & bh >= 1 & 0 <= cl <= 1;


/* Red black tree with case analysis */
// Remark: color information is known in the case
rbc<n, cl, bh, c> == self = null & n = 0 & bh = 1 & cl = 1 & c = 0
	or self::node<v, 1, l, r> * l::rbc<ln, 1, bh - 1, _> * r::rbc<rn, 1, bh - 1, _> & cl = 1 & n = 1 + ln + rn & c = 1    // BBB
    or self::node<v, 1, l, r> * l::rbc<ln, 0, bh - 1, _> * r::rbc<rn, 1, bh - 1, _> & cl = 1 & n = 1 + ln + rn & c = 2    // BRB
    or self::node<v, 1, l, r> * l::rbc<ln, 0, bh - 1, _> * r::rbc<rn, 0, bh - 1, _> & cl = 1 & n = 1 + ln + rn & c = 3    // BRR
	or self::node<v, 0, l, r> * l::rbc<ln, 1, bh, _> * r::rbc<rn, 1, bh, _> & cl = 0 & n = 1 + ln + rn & c = 4            // RBB 
	inv n >= 0 & bh >= 1 & 0 <= cl <= 1 & 0 <= c <= 4;

// Special case         R
//                    R   B
// that usually occurs.
rbs<n, bh> == self::node<_,0,l,r> * l::rbc<ln,0,bh,4> * r::rbc<rn,1,bh,_> & ln + rn + 1 = n
	inv n >= 1 & bh >= 1 & self!=null;

//////////////////////////////////////////
//          HELPER FUNCTIONS I          //
//////////////////////////////////////////
// Specification node naming convention:
// h : main node
// lt : left tree; rt : right tree
// llt : lt's left tree; rlt : rt's left tree; ...


bool is_red(node h)
	case{
		h  = null -> requires true 
		             ensures !res;
		h != null -> requires h::node<v,c,l,r>
		             ensures h::node<v,c,l,r> & c != 0 & !res 
		                     or h::node<v,c,l,r> & c = 0 & res;
	}
{
	if (h==null)
		return false;
	else
		return (h.color==0);
}

void color_flip(node h)
	requires h::node<v,c,l,r> * l::node<lv,lc,ll,lr> * r::node<rv,rc,rl,rr>
	ensures h::node<v,1-c,l,r> * l::node<lv,1-lc,ll,lr> * r::node<rv,1-rc,rl,rr>;
{
	h.color        = 1 - h.color;
	h.left.color   = 1 - h.left.color;
	h.right.color  = 1 - h.right.color;
}

// Make a right-leaning 3-node lean to the left.
// PROBLEM DETECTED: SPECIFICATION FAILURE
node rotate_left(node h)
	requires h::node<v,c,l,r> * r::node<rv,0,rl,rr>
	ensures res::node<rv,c,h,rr> * h::node<v,0,l,rl> & res = r;
{
	node x = h.right;
	h.right = x.left;
	x.left = h;
	x.color = x.left.color;
	x.left.color = 0;
	return x;
}

// Make a left-leaning 3-node lean to the right.
// PROBLEM DETECTED: SPECIFICATION FAILURE
node rotate_right(node h)
	requires h::node<v,c,l,r> * l::node<lv,0,ll,lr>
	ensures res::node<lv,c,ll,h> * h::node<v,0,lr,r> & res = l;
{
	node x = h.left;
	h.left = x.right;
	x.right = h;
	x.color = x.right.color;
	x.right.color = 0;
	return x;
}

// compute the black height of a red black tree
int black_height(node h)
	requires h::rb<_,_,bh>
	ensures res = bh;
{
	if (h == null)
		return 1;
	
	if (is_red(h))
		return black_height(h.left);
	else
		return 1 + black_height(h.left);
}

//////////////////////////////////////////
//              INSERTION               //
//////////////////////////////////////////

// Insert a value v to the ROOT node of a red-black tree
// Remark: POSSIBLE to have height increment.
node insert(node h, int v)
	//requires h::rb<n,_,bh>
	//ensures res::rb<n+1,1,bh> or res::rb<n+1,1,bh+1>;
	requires h::rbc<n,_,bh,_>
	ensures res::rbc<n+1,1,bh,_> or res::rbc<n+1,1,bh+1,_>;
{
	node r = insert_internal(h,v);
	
	//assert r != null;	
	assert     r::node<_,0,null,null>
	        or r::rbc<n+1,_,bh,_>
	        //or r::rbc<n+1,0,bh,4>
			or r::node<_,0,l1,r1> * l1::rbc<ln,0,bh,4> * r1::rbc<rn,1,bh,_> & n = ln + rn;
	
//	assert r::rbc<n+1,_,bh,_> & r != null
//	       or r::node<_,0,l1,r1> * l1::rbc<ln,0,bh,4> * r1::rbc<rn,1,bh,_> & ln + rn = n;
	
	r.color = 1;
	return r;
}

node testcm(node h)
	requires h::node<_,0,null,null> ensures res::rbc<1,1,2,1>;
	requires h::node<_,0,l,r> * l::rbc<ln,0,bh,4> * r::rbc<rn,1,bh,_> ensures res::rbc<ln+rn+1,1,bh+1,2>;
	requires h::rbc<n,0,bh,4> ensures res::rbc<n,1,bh+1,1>;
	requires h::rbc<n,1,bh,c> ensures res::rbc<n,1,bh,c>;
{
	if (h != null) {
		h.color = 1;
	}
	return h;
}

// Insert a value v to an INTERNAL node of a red-black tree.
// Remark: NO height increment.
node insert_internal(node h, int v)
	//the following is not strong enough
	//requires h::rb<n,c,bh> ensures res::rb<n+1,0,bh> or res::node<_,0,l,r> * l::rb<ln,0,bh> * r::rb<rn,1,bh> & ln + rn = n;
	requires h::rbc<n,_,bh,c>
	case {
		c = 0 -> ensures res::node<v,0,null,null>;
		c = 1 -> ensures res::rbc<n+1,1,bh,1> or res::rbc<n+1,1,bh,2>;
		c = 2 -> ensures res::rbc<n+1,1,bh,2> or res::rbc<n+1,1,bh,3>;
		(c = 3 | c = 4) -> ensures res::rbc<n+1,0,bh,4> or res::rbs<n+1,bh>;
		(c < 0 | c > 4) -> ensures false;
	}
{
	if (h == null)
		return new node(v, 0, null, null); // RED node
	
	//node l = h.left;
	//node r = h.right;
	
	// split this node if it is a 4 node
	if (is_red(h.left) && is_red(h.right)) {
		assert l'::rb<_,0,bh-1> * r'::rb<_,0,bh-1> & l' != null & r' != null;
		h.color        = 0;
		h.left.color   = 1;
		h.right.color  = 1;
		//assert h'::rbc<n,0,bh,4>;
		//assert h'::rb<n,0,bh>;
		//assert l'::rb<_,1,bh> * r'::rb<_,1,bh>;
	}	
	
	// REMARK: THE COLOR OF THE RESULTING NODE IS DETERMINED HERE BECAUSE ROTATION DOES NOT CHANGE COLOR OF THE RESULTING NODE! THUS, h IS RED OR h IS BLACK WITH 2 RED CHILDREN ==> res IS RED. OTHERWISE, res IS A BLACK NODE

	// after splitting 4 nodes, the right branch is ALWAYS BLACK!
	//assert h'::node<_,_,l',r'>;
	//assert l'::rb<_,_,_> * r'::rb<_,1,_>;
	//assert h'::node<_,_,l',r'> * l'::rbc<_,_,_,_> * r'::rbc<_,1,_,_>;
	
	if (v <= h.val) {// accept duplicates!
		h.left = insert_internal(h.left, v);
		if (is_red(h.left)) {
			if (is_red(h.left.left)) {
				//h = rotate_right(h);
				node x = h.left;
				h.left = x.right;
				x.right = h;
				x.color = x.right.color;
				x.right.color = 0;
				h = x;
			}
		}
	}
	else {
		h.right = insert_internal(h.right, v);
		if (is_red(h.right) && !is_red(h.left)) {
			//h = rotate_left(h);
			node x = h.right;
			h.right = x.left;
			x.left = h;
			x.color = x.left.color;
			x.left.color = 0;
			h = x;
		}
	}
	
	return h;
}

//////////////////////////////////////////
//         HELPER FUNCTIONS II          //
//////////////////////////////////////////

// Fix the invariant
node fix_up(node h)
	requires h::node<v,c,l,r> * l::rb<ln,lc,lh> * rt::rb<rn,rc,rh> & 0 <= c <= 1
	ensures res::rb<1+ln+rn,c1,lh> & 0 <= c1 <= 1;
{
	// ensure left-leaning property
	if (h != null) {
	
		if (is_red(h.right))
			h = rotate_left(h);
		
		// eliminate two reds in a row
		if (h.left != null) {
			if (is_red(h.left) && is_red(h.left.left))
				h = rotate_right(h);
		}
	
		// push the red upward
		if (is_red(h.left) && is_red(h.right))
			color_flip(h);
	}		
	return h;
}

// Assuming that h is red and both h.left and h.left.left
// are black, make h.left or one of its children red.
void move_red_left(node h)	
	requires h::node<v,0,lt,rt> * lt::node<lv,1,llt,lrt> 
	  * rt::node<rv,rc,rlt,rrt> * llt::node<llv,1,lllt,llrt> 
	  * rlt::node<rlv,rlc,rllt,rlrt> * rlrt::node<rlrv,rlrc,rlrlt,rlrrt>
	case {
		rlc = 0
		-> ensures h::node<v,0,lt,rlrt> * lt::node<lv,1,llt,lrt> 
			* llt::node<llv,1,lllt,llrt> * rt::node<rv,1-rlrc,rlrt,rrt> 
			* rlt::node<rlv,0,rllt,rlrt> * rlrt::node<rlrv,0,rlrlt,rlrrt>;
	    rlc != 0
	    -> ensures h::node<v,1,lt,rt> * lt::node<lv,0,llt,lrt> 
	       * rt::node<rv,1-rc,rlt,rrt> * llt::node<llv,1,lllt,llrt> 
	       * rlt::node<rlv,rlc,rllt,rlrt> * rlrt::node<rlrv,rlrc,rlrlt,rlrrt>; //after color_flip
	}
{
	color_flip(h);
	if (is_red(h.right.left)) {		
		h.right = rotate_right(h.right);
		h = rotate_left(h);		
		color_flip(h);
	}
}

//////////////////////////////////////////
//           DELETE MINIMUM             //
//////////////////////////////////////////

// Delete the node with minimum value under h
// and return that minimum value.
// TRICK: Maintain the input h as RED node
// NOTE: NO CHANGE IN HEIGHT
node delete_min_internal(node h, ref int min_value)
	requires h::rbc<n,0,bh,_>
	ensures res::rbc<n-1,_,bh,_>;
{
	if (h.left == null)
	{
		min_value = h.val;
		return null;
	}
	
	// DELETE MIN ==> ALWAYS RECURSE TO THE LEFT! BUT WE NEED TO MAINTAIN THE INVARIANT, NAMELY THE INPUT h.left IS A RED NODE.
	if (!is_red(h.left) && !is_red(h.left.left))
		move_red_left(h);

	h.left = delete_min_internal(h.left, min_value);
	
	fix_up(h);
	
	return h;
}

node delete_min(node h)
{
	// NOTE: height change occurs here!
	// BECAUSE THE COLOR OF THE ROOT IS NOT IMPORTANT, H IS STILL A RED NODE!
	if (h != null) h.color = 0;
	delete_min_internal(h);
	if (h != null) h.color = 1;
	return h;
}

/*
//////////////////////////////////////////
//              DELETION                //
//////////////////////////////////////////

// Assuming that h is red and both h.right and h.right.left
// are black, make h.right or one of its children red.
void move_red_right(node h)
{
	color_flip(h);
	if (is_red(h.left.left)) { 
		rotate_right(h);
		color_flip(h);
	}
}

void delete(node h, int v)
	requires h::rb<n, cl, bh> & 0 <= cl <= 1
	ensures  h::rb<n-1, cl2, bh> & cl = 1 & 0 <= cl2 <= 1
		     or h::rb<n-1, 0, bh2> & bh-1 <= bh2 <= h & cl = 0 
		     or h::rb<n, cl, bh>;
{
	if (v < h.val) {
		if (!is_red(h.left) && !is_red(h.left.left))
			move_red_left(h);
		delete(h.left, v);
	} else {
		if (is_red(h.left))
			rotate_right(h);
			
		if (v == h.val && (h.right == null))
			h = null;
		if (!is_red(h.right) && !is_red(h.right.left))
			move_red_right(h); 
		
		if (v == h.val)
			h.val = delete_min(h.right);
		else 
			delete(h.right, v);
	}
	
	fix_up(h);
}*/