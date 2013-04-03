#create a list of expected results
#================SLEEK==========================
#================SLEEK==========================
echo "======= bperm1.slk ======"
../../sleek bperm1.slk | grep Entail > test-cases/bperm1.res
echo "======= bperm-split.slk ======"
../../sleek bperm-split.slk | grep Entail > test-cases/bperm-split.res
echo "======= bperm-combine.slk ======"
../../sleek bperm-combine.slk | grep Entail > test-cases/bperm-combine.res
echo "======= bperm-split-combine.slk ======"
../../sleek bperm-split-combine.slk | grep Entail > test-cases/bperm-split-combine.res
echo "======= barrier1.slk ======"
../../sleek barrier1.slk | grep Entail > test-cases/barrier1.res
echo "======= barrier-split.slk ======"
../../sleek barrier-split.slk | grep Entail > test-cases/barrier-split.res
echo "======= barrier-combine.slk ======"
../../sleek barrier-combine.slk | grep Entail > test-cases/barrier-combine.res
echo "======= barrier-sep.slk ======"
../../sleek barrier-sep.slk | grep Entail > test-cases/barrier-sep.res
echo "======= barrier-static.slk ======"
../../sleek barrier-static.slk | grep Entail > test-cases/barrier-static.res
echo "======= barrier-dynamic.slk ======"
../../sleek barrier-dynamic.slk | grep Entail > test-cases/barrier-dynamic.res
#================HIP==========================
#================HIP==========================
echo "======= hip-bperm1.ss ======"
../../hip hip-bperm1.ss | grep -E 'Proc|assert:' > test-cases/hip-bperm1.res
echo "======= bperm-exp.ss ======"
../../hip bperm-exp.ss | grep -E 'Proc|assert:' > test-cases/bperm-exp.res
echo "======= barrier-static-primitives.ss ======"
../../hip barrier-static-primitives.ss | grep -E 'Proc|assert:' > test-cases/barrier-static-primitives.res
echo "======= barrier-static-exp1.ss ======"
../../hip barrier-static-exp1.ss | grep -E 'Proc|assert:' > test-cases/barrier-static-exp1.res
echo "======= barrier-static-exp2.ss ======"
../../hip barrier-static-exp2.ss | grep -E 'Proc|assert:' > test-cases/barrier-static-exp2.res
echo "======= barrier-static-exp3.ss ======"
../../hip barrier-static-exp3.ss | grep -E 'Proc|assert:' > test-cases/barrier-static-exp3.res
echo "======= barrier-static-complex.ss ======"
../../hip barrier-static-complex.ss | grep -E 'Proc|assert:' > test-cases/barrier-static-complex.res
echo "======= barrier-dynamic-exp1.ss ======"
../../hip barrier-dynamic-exp1.ss | grep -E 'Proc|assert:' > test-cases/barrier-dynamic-exp1.res
