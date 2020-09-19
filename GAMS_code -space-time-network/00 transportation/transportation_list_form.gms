$Title  A Transportation Problem (TRNSPORT,SEQ=1)
  Sets
       i   supply   /1/
       j   demand   /1*2/ ;

 Parameters a(i);
a('1') = 10;
 Parameters b(j)
/
1 7
2 3
/;


Parameter c(i,j);


  Variables
       x(i,j)  shipment quantities in cases
       z       total transportation costs in thousands of dollars ;

  Positive Variable x ;

  Equations
       cost
       supply
       demand_1
       demand_2;

  cost ..        z  =e=  c('1','1')*x('1','1') + c('1','2')*x('1','2')  ;
  supply..       x('1','1')+ x('1','2')  =e=  a('1') ;
  demand_1..     x('1','1') =e= b('1');
  demand_2..     x('1','2') =e= b('2');

  Model transport /all/ ;

  Solve transport using lp minimizing z ;

  Display x.l z.l c.l;
