// see ../hip/global2.ss

int k;
int n;

void increase()
/*@
  requires true
  ensures k'=k+n;
*/
// writes k; read n
{
	k = k+n;
  //@ dprint;
}
