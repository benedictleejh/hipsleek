# create a list of new results
# ================SLEEK==========================
# ================SLEEK==========================
echo "======= thrd1.slk ======"
../../../sleek --en-para --en-thrd-resource -tp redlog thrd1.slk | grep Entail > test-cases/thrd1.n
echo "======= thrd2.slk ======"
../../../sleek --en-para --en-thrd-resource -tp redlog thrd2.slk | grep Entail > test-cases/thrd2.n
echo "======= thrd-liveness.slk ======"
../../../sleek --en-para --en-thrd-resource -tp parahip thrd-liveness.slk | grep Entail > test-cases/thrd-liveness.slk.n

#================HIP==========================
#================HIP==========================
echo "======= thrd-liveness.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic thrd-liveness.ss | grep -E 'Proc|assert:' > test-cases/thrd-liveness.ss.n
echo "======= multi-join1.ss  ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/multi-join1.ss | grep -E 'Proc|assert:' > test-cases/multi-join1.n

echo "======= multi-join2.ss  ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/multi-join2.ss | grep -E 'Proc|assert:' > test-cases/multi-join2.n

echo "======= multi-join3.ss  ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/multi-join3.ss | grep -E 'Proc|assert:' > test-cases/multi-join3.n

echo "======= no-deadlock-nonlexical2.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/no-deadlock-nonlexical2.ss | grep -E 'Proc|assert:' >  test-cases/no-deadlock-nonlexical2.n

echo "======= point.ss  ======"
../../../hip --en-para --en-thrd-resource --dis-locklevel -tp parahip --classic point.ss | grep -E 'Proc|assert:' >  test-cases/point.n

echo "======= frac-cell-list.ss  ======"
../../../hip --en-para -tp parahip --classic frac-cell-list.ss | grep -E 'Proc|assert:' >  test-cases/frac-cell-list.n

echo "======= threadpool.ss ======"
../../../hip --en-thrd-resource --en-para -tp parahip --en-lsmu-infer --dis-ls  --classic threadhip/threadpool.ss | grep -E 'Proc|assert:' >  test-cases/threadpool.n

echo "======= multicast.ss ======"
../../../hip --en-thrd-resource --en-para -tp parahip --en-lsmu-infer --classic threadhip/multicast.ss | grep -E 'Proc|assert:' >  test-cases/multicast.n

#================PARAHIP==========================
#================PARAHIP==========================
echo "======= threadhip/no-deadlock-nonlexical.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/parahip-benchmark/no-deadlock-nonlexical.ss | grep -E 'Proc|assert:' >  test-cases/threadhip/no-deadlock-nonlexical.n
# echo "======= threadhip/simple.ss ======"
# ##No Fork/Join
# ../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer threadhip/simple.ss | grep -E 'Proc|assert:' > test-cases/threadhip/simple.n
echo "======= threadhip/forkjoin.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/others/forkjoin.ss | grep -E 'Proc|assert:' > test-cases/threadhip/forkjoin.n
# echo "======= threadhip/cell.ss ======"
# ##No Fork/Join
# ../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer threadhip/cell.ss | grep -E 'Proc|assert:' > test-cases/threadhip/cell.n
echo "======= threadhip/cell4.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/others/cell4.ss | grep -E 'Proc|assert:' > test-cases/threadhip/cell4.n
# echo "======= threadhip/cell-lock-vperm.ss ======"
# ##No Fork/Join
# ../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer threadhip/cell-lock-vperm.ss | grep -E 'Proc|assert:' > test-cases/threadhip/cell-lock-vperm.n
echo "======= threadhip/cell-extreme-cases.ss ======"
# ##No Fork/Join
# ../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer threadhip/cell-extreme-cases.ss | grep -E 'Proc|assert:' > test-cases/threadhip/cell-extreme-cases.n
echo "======= threadhip/ls-bind.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/others/ls-bind.ss | grep -E 'Proc|assert:' > test-cases/threadhip/ls-bind.n
# echo "======= threadhip/ls-waitlevel2.ss ======"
# ##No Fork/Join
# ../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer threadhip/ls-waitlevel2.ss | grep -E 'Proc|assert:' > test-cases/threadhip/ls-waitlevel2.n
# echo "======= threadhip/double-acquire.ss ======"
# ##No Fork/Join
# ../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer threadhip/double-acquire.ss | grep -E 'Proc|assert:' > test-cases/threadhip/double-acquire.n
echo "======= threadhip/no-deadlock1.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/parahip-benchmark/no-deadlock1.ss | grep -E 'Proc|assert:' > test-cases/threadhip/no-deadlock1.n
echo "======= threadhip/no-deadlock2.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/parahip-benchmark/no-deadlock2.ss | grep -E 'Proc|assert:' > test-cases/threadhip/no-deadlock2.n
echo "======= threadhip/no-deadlock3.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/parahip-benchmark/no-deadlock3.ss | grep -E 'Proc|assert:' > test-cases/threadhip/no-deadlock3.n
echo "======= threadhip/deadlock1.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/parahip-benchmark/deadlock1.ss | grep -E 'Proc|assert:' > test-cases/threadhip/deadlock1.n
echo "======= threadhip/deadlock2.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/parahip-benchmark/deadlock2.ss | grep -E 'Proc|assert:' > test-cases/threadhip/deadlock2.n
echo "======= threadhip/deadlock3.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/parahip-benchmark/deadlock3.ss | grep -E 'Proc|assert:' > test-cases/threadhip/deadlock3.n
echo "======= threadhip/disj-no-deadlock1.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/parahip-benchmark/disj-no-deadlock1.ss | grep -E 'Proc|assert:' > test-cases/threadhip/disj-no-deadlock1.n
echo "======= threadhip/disj-no-deadlock2.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/parahip-benchmark/disj-no-deadlock2.ss | grep -E 'Proc|assert:' > test-cases/threadhip/disj-no-deadlock2.n
echo "======= threadhip/disj-no-deadlock3.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/parahip-benchmark/disj-no-deadlock3.ss | grep -E 'Proc|assert:' > test-cases/threadhip/disj-no-deadlock3.n
echo "======= threadhip/disj-deadlock.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/parahip-benchmark/disj-deadlock.ss | grep -E 'Proc|assert:' > test-cases/threadhip/disj-deadlock.n
echo "======= threadhip/ordered-locking.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/parahip-benchmark/ordered-locking.ss | grep -E 'Proc|assert:' > test-cases/threadhip/ordered-locking.n
echo "======= threadhip/unordered-locking.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/parahip-benchmark/unordered-locking.ss | grep -E 'Proc|assert:' > test-cases/threadhip/unordered-locking.n
# echo "======= threadhip/multicast.ss ======"
# ##No Fork/Join
# ../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer threadhip/multicast.ss | grep -E 'Proc|assert:' > test-cases/threadhip/multicast.n
echo "======= threadhip/oracle.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/oracle.ss | grep -E 'Proc|assert:' > test-cases/threadhip/oracle.n
echo "======= threadhip/owicki-gries.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/owicki-gries.ss | grep -E 'Proc|assert:' > test-cases/threadhip/owicki-gries.n
echo "======= threadhip/fibonacci.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --en-lsmu-infer --classic threadhip/fibonacci.ss | grep -E 'Proc|assert:' > test-cases/threadhip/fibonacci.n
# echo "======= threadhip/create_and_acquire.ss ======"
# ##No Fork/Join
# ../../../hip --en-para --en-thrd-resource -tp parahip --dis-locklevel threadhip/create_and_acquire.ss | grep -E 'Proc|assert:' > test-cases/threadhip/create_and_acquire.n

echo "======= threadhip/parallel-mergesort.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --dis-ls --dis-locklevel --classic threadhip/parallel-mergesort.ss | grep -E 'Proc|assert:' > test-cases/threadhip/parallel-mergesort.n

echo "======= threadhip/parallel-quicksort.ss ======"
../../../hip --en-para --en-thrd-resource -tp parahip --dis-ls --dis-locklevel --classic threadhip/parallel-quicksort.ss | grep -E 'Proc|assert:' > test-cases/threadhip/parallel-quicksort.n

#================BENCHMARK==========================
#================BENCHMARK==========================

