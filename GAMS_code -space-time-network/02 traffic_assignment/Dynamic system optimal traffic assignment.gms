$ title dynamic transit service network design Problem

$inlinecom /* */
$offlisting
$offsymxref offsymlist
option limrow = 0, limcol = 0, solprint = off, sysout = off;

set i nodes /1*8/;
set t time stamp /0*9/;
set a agent /1*9/;
alias (i, j);
alias (t, s);

parameter c(i,j,t,s) travel time /
1.2.0.1 1
1.2.1.2 1
1.2.2.3 1
2.5.1.2 1
2.5.2.3 1
2.5.3.4 1
5.8.2.3 1
5.8.3.4 1
5.8.4.5 1
8.3.3.4 1
8.3.4.5 1
8.3.5.6 1
1.7.0.4 4
1.7.1.5 4
1.7.2.6 4
7.3.4.5 1
7.3.5.6 1
7.3.6.7 1
3.4.4.5 1
3.4.5.6 1
3.4.6.7 1
3.4.7.8 1
2.6.1.2 1
2.6.2.3 1
2.6.3.4 1
6.4.2.7 5
6.4.3.8 5
6.4.4.9 5
5.5.2.3 1
5.5.3.4 1
6.6.2.3 1
6.6.3.4 1
8.8.3.4 1
8.8.4.5 1
7.7.4.5 1
7.7.5.6 1
4.4.5.6 0
4.4.6.7 0
4.4.7.8 0
4.4.8.9 0
/;

parameter cap(i,j,t,s) link capacity /
1.2.0.1 3
1.2.1.2 3
1.2.2.3 3
2.5.1.2 3
2.5.2.3 3
2.5.3.4 3
5.8.2.3 2
5.8.3.4 2
5.8.4.5 2
8.3.3.4 1
8.3.4.5 1
8.3.5.6 1
1.7.0.4 2
1.7.1.5 2
1.7.2.6 2
7.3.4.5 1
7.3.5.6 1
7.3.6.7 1
3.4.4.5 2
3.4.5.6 2
3.4.6.7 2
3.4.7.8 2
2.6.1.2 3
2.6.2.3 3
2.6.3.4 3
6.4.2.7 1
6.4.3.8 1
6.4.4.9 1
5.5.2.3 100
5.5.3.4 100
6.6.2.3 100
6.6.3.4 100
8.8.3.4 100
8.8.4.5 100
7.7.4.5 100
7.7.5.6 100
4.4.5.6 100
4.4.6.7 100
4.4.7.8 100
4.4.8.9 100
/;

parameter r(i,j,t,s) existing link factor /
1.2.0.1 1
1.2.1.2 1
1.2.2.3 1
2.5.1.2 1
2.5.2.3 1
2.5.3.4 1
5.8.2.3 1
5.8.3.4 1
5.8.4.5 1
8.3.3.4 1
8.3.4.5 1
8.3.5.6 1
1.7.0.4 1
1.7.1.5 1
1.7.2.6 1
7.3.4.5 1
7.3.5.6 1
7.3.6.7 1
3.4.4.5 1
3.4.5.6 1
3.4.6.7 1
3.4.7.8 1
2.6.1.2 1
2.6.2.3 1
2.6.3.4 1
6.4.2.7 1
6.4.3.8 1
6.4.4.9 1
5.5.2.3 1
5.5.3.4 1
6.6.2.3 1
6.6.3.4 1
8.8.3.4 1
8.8.4.5 1
7.7.4.5 1
7.7.5.6 1
4.4.5.6 1
4.4.6.7 1
4.4.7.8 1
4.4.8.9 1
/;

parameter origin(a,i,t) /
1.1.0 1
2.1.0 1
3.1.0 1
4.1.0 1
5.1.0 1
6.1.1 1
7.1.1 1
8.1.1 1
9.1.1 1
/;

parameter destination(a,i,t) /
1.4.9 1
2.4.9 1
3.4.9 1
4.4.9 1
5.4.9 1
6.4.9 1
7.4.9 1
8.4.9 1
9.4.9 1
/;

parameter node_index(i,t) /
1.1 1
1.2 1
1.3 1
2.1 1
2.2 1
2.3 1
5.2 1
5.3 1
5.4 1
6.2 1
6.3 1
6.4 1
8.3 1
8.4 1
8.5 1
7.4 1
7.5 1
7.6 1
3.4 1
3.5 1
3.6 1
3.7 1
4.5 1
4.6 1
4.7 1
4.8 1
4.9 1
/;

parameter intermediate(a,i,t);
intermediate(a,i,t)$(node_index(i,t)>0.1) = (1- origin(a,i,t))* (1- destination(a,i,t));

variable z;

variable f(i,j,t,s);

binary variables
x(a,i,j,t,s )  selection of  comm p between i and j;


equations
so_obj
comm_flow_on_node_origin(a,i,t)         origin node flow pv on node i at time t
comm_flow_on_node_intermediate(a,i,t)   intermediate node flow k on node i at time t
comm_flow_on_node_destination(a,i,t)      destination node flow k on node i at time t
flow_def(i,j,t,s)
cap_constraint(i,j,t,s)
;

so_obj.. z =e= sum((i,j,t,s)$(r(i,j,t,s)>0.1), f(i,j,t,s)*c(i,j,t,s));
comm_flow_on_node_origin(a,i,t)$(origin(a,i,t)=1) .. sum((j,s)$(cap(i,j,t,s)>0.1), x(a,i,j,t,s)) =e= origin(a,i,t);
comm_flow_on_node_destination(a,i,t)$(destination(a,i,t)=1) ..  sum((j,s)$(cap(j,i,s,t)>0.1), x(a,j,i,s,t))=e= destination(a,i,t);
comm_flow_on_node_intermediate(a,i,t)$(intermediate(a,i,t)=1).. sum((j,s)$(cap(i,j,t,s)>0.1), x(a,i, j, t,s))-sum((j,s)$(cap(j,i,s,t)>0.1), x(a,j,i,s,t))=e= 0;
flow_def(i,j,t,s)$(r(i,j,t,s)>0.1)..f(i,j,t,s) =e= sum(a,x(a,i,j,t,s));
cap_constraint(i,j,t,s)$(r(i,j,t,s)>0.1).. cap(i,j,t,s)-f(i,j,t,s) =g=0;

Model oz_1 /so_obj,comm_flow_on_node_origin,comm_flow_on_node_destination,comm_flow_on_node_intermediate,flow_def,cap_constraint/;
solve oz_1 using MIP minimizing z;
display z.l;
display f.l;
