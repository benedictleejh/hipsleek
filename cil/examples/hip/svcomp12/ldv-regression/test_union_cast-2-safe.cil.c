/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

#line 19 "test_union_cast-2-safe.c"
struct l_struct_2E_X {
   double field0 ;
};
#line 71 "/usr/include/assert.h"
extern  __attribute__((__nothrow__, __noreturn__)) void __assert_fail(char const   *__assertion ,
                                                                      char const   *__file ,
                                                                      unsigned int __line ,
                                                                      char const   *__function ) ;
#line 7 "test_union_cast-2-safe.c"

#line 8 "test_union_cast-2-safe.c"
int CURRENTLY_UNKNOWN  ;
#line 24 "test_union_cast-2-safe.c"
int main(void) 
{ struct l_struct_2E_X llvm_cbe_var ;
  struct l_struct_2E_X *__cil_tmp2 ;
  struct l_struct_2E_X *__cil_tmp3 ;
  double *__cil_tmp4 ;
  unsigned int *__cil_tmp5 ;
  struct l_struct_2E_X *__cil_tmp6 ;
  double *__cil_tmp7 ;
  unsigned int *__cil_tmp8 ;
  unsigned int __cil_tmp9 ;

  {
#line 32
  __cil_tmp2 = & llvm_cbe_var;
#line 32
  *((double *)__cil_tmp2) = 0x1.4p+4;
#line 33
  __cil_tmp3 = & llvm_cbe_var;
#line 33
  __cil_tmp4 = (double *)__cil_tmp3;
#line 33
  __cil_tmp5 = (unsigned int *)__cil_tmp4;
#line 33
  *__cil_tmp5 = 10U;
  {
#line 34
  __cil_tmp6 = & llvm_cbe_var;
#line 34
  __cil_tmp7 = (double *)__cil_tmp6;
#line 34
  __cil_tmp8 = (unsigned int *)__cil_tmp7;
#line 34
  __cil_tmp9 = *__cil_tmp8;
#line 34
  if (__cil_tmp9 == 10U) {

  } else {
    {
#line 34
    //__assert_fail("*(((unsigned int *)((&llvm_cbe_var.field0)))) == 10u", "test_union_cast-2-safe.c",
    //              34U, "main");
    ERROR: goto ERROR;
    }
  }
  }
#line 36
  return (0);
}
}
