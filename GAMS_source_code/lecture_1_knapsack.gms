$Title Multi knapsack problem using BCH Facility (BCHMKNAP,SEQ=289)
$ontext

This multiknapsack problem illustrates the use of user supplied cutting planes
in the GAMS BCH (branch-and-cut-and-heuristic) facility. Please note, that cover
cuts used in this example, are already implemented in modern MIP solvers.

Example taken from the OR-Library
http://people.brunel.ac.uk/~mastjjb/jeb/orlib/mknapinfo.html
first example in mknap1.


Beasley, J E, OR-Library: Distributing Test Problems by Electronic
Mail. Journal of the Operational Research Society 41 (11) (1990),
1069-1072.

Petersen, C C, Computational experience with variants of the Balas
algorithm applied to the selection of R&D projects. Management Science
13 (9) (1967), 736-750.

Linderoth, J, IE418 - Integer Programming Lecture Notes - Lecture #15, 2005.
University of Wisconsin-Madison,
http://homepages.cae.wisc.edu/~linderot/classes/ie418/lecture15.pdf

$offtext

set j columns /c1*c6/
    i rows    /r1*r10/

Parameters c(j) / c1  100, c2  600, c3 1200, c4 2400, c5  500, c6 2000 /
           b(i) / r1   80, r2   96, r3   20, r4   36, r5   44, r6   48,
                    r7   10, r8   18, r9   22, r10  24 /;

Table a(i,j)
      c1   c2   c3   c4   c5   c6
 r1    8   12   13   64   22   41
 r2    8   12   13   75   22   41
 r3    3    6    4   18    6    4
 r4    5   10    8   32    6   12
 r5    5   13    8   42    6   20
 r6    5   13    8   48    6   20
 r7                        8
 r8    3         4         8
 r9    3    2    4         8    4
 r10   3    2    4    8    8    4

variables x(j)
Variable  z;


Equations mk(i), defobj, lower_bound(j), upper_bound(j);

defobj.. z =e= sum(j, c(j)*x(j));

mk(i).. sum(j, a(i,j)*x(j)) =l= b(i);

lower_bound(j).. x(j)=g=0;
upper_bound(j).. x(j)=l=10;

model m /all/;

solve m max z using lp;
display x.l;
display z.l;
parameter used_b(i);
used_b(i) = sum(j, a(i,j)*x.l(j));

display used_b;



