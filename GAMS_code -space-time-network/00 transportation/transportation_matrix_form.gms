$Title  A Transportation Problem (TRNSPORT,SEQ=1)
  Sets
       i   supply   /1*3/
       j   demand   /1*2/ ;

 Parameters a(i)
/
 1 5
 2 4
 3 1
/;

 Parameters b(j)
/
1 7
2 3
/;


Parameter c(i,j)
/
1.1 2
1.2 3
2.1 5
2.2 2
3.1 100
3.2 100
/;

  Variables
       x(i,j)  shipment quantities in cases
       z       total transportation costs in thousands of dollars ;

  Positive Variable x ;

  Equations
       cost        define objective function
       supply(i)   observe supply limit at plant i
       demand(j)   satisfy demand at market j ;

  cost ..        z  =e=  sum((i,j), c(i,j)*x(i,j)) ;
  supply(i) ..   sum(j, x(i,j))  =l=  a(i) ;
  demand(j) ..   sum(i, x(i,j))  =g=  b(j) ;

  Model transport /all/ ;

  Solve transport using lp minimizing z ;

  Display x.l, z.l,  supply.m, demand.m;
