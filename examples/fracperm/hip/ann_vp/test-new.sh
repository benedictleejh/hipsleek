#create a list of new results
echo "======= vperm2.ss ======"
../../../../hip vperm2.ss > vperm2.n
echo "======= vperm3.ss ======"
../../../../hip vperm3.ss > vperm3.n
echo "======= vperm4.ss ======"
../../../../hip vperm4.ss > vperm4.n
echo "======= parallelCount.ss ======"
../../../../hip vperm_check.ss > vperm_check.n
echo "======= parallel_merge_sort.ss ======"
../../../../hip parallelCount.ss > parallelCount.n
echo "======= parallel_merge_sort.ss ======"
../../../../hip parallel_merge_sort.ss > parallel_merge_sort.n
echo "======= parallel_quick_sort.ss ======"
../../../../hip parallel_quick_sort.ss > parallel_quick_sort.n
echo "======= alt_threading.ss ======"
../../../../hip alt_threading.ss > alt_threading.n
