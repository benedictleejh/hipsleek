function two 
{
 cp tests/slk/$1.out ref/slk/$1.out
}
mkdir -p ref/slk
two lab1.slk --dump-proof
two lab2.slk --dump-proof
two lab3.slk --dump-proof
two lab4.slk --dump-proof


