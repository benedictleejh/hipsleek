echo "sll-reverse"
../../hip sll-reverse-v.ss  | grep  "verification time"
# echo "sll-last"
# ../../hip sll-last-2.ss  | grep  "verification time"
echo "qsort-2.ss"
../../hip qsort-2-v.ss  | grep  "verification time"
echo "zip_paper_eq"
../../hip zip_paper_eq-v.ss  | grep  "verification time"
echo "sll+head"
../../hip check-sll-head-v.ss   | grep  "verification time"
echo "skip-list.ss"
../../hip skip0-v-v.ss   | grep  "verification time"
echo "check-sorted"
../../hip check-sorted-v.ss    | grep  "verification time"
echo "CSll"
../../hip cll-v.ss  | grep  "verification time"
echo "check-CSll"
../../hip check-cll-v.ss  | grep  "verification time"
echo " 0/1 SLLs"
../../hip sll-01-slls-v.ss   | grep  "verification time"
echo "sll2dll"
../../hip sll-dll-v.ss  | grep  "verification time"
echo "check-dll"
../../hip check-dll-v.ss   | grep  "verification time"
echo "dll-app"
../../hip dll-append_paper-v.ss   | grep  "verification time"
# echo "dll-del"
# ../../hip dll-del.ss  | grep  "verification time"
echo "bt-search-2.ss"
../../hip bt-search-2-v.ss  | grep  "verification time"
echo "bt-go-left.ss"
../../hip bt-left2-v.ss  | grep  "verification time"
echo "tll"
../../hip tll-v.ss   | grep  "verification time"
echo "rose-tree"
../../hip rose-sll-1-v.ss   | grep  "verification time"
# echo "check tree+multi"
# ../../hip check-multi-tree-v.ss   | grep  "verification time"
echo "check mcf"
../../hip check-mcf-v.ss   | grep  "verification time"
echo "check tll"
../../hip check-tll-v.ss   | grep  "verification time"
