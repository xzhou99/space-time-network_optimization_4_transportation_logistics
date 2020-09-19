$title household scheduling problem
OPTIONS mip = CPLEX;
*option reslim = 3000;

set i nodes /1*31/;
set t time stamp /1*40/;
set a agent /1*2/;
set w state /1*3/;

alias (i, j);
alias (t, s);

$include "C:\Users\jliu215\Desktop\Part_B_submission\Self-driving cars\6_New experiments\GAMS_TEST\output_arcs_phi.txt"

*------------------arc travel cost defined by the author-------------------
parameter arc_cost(i,j,t,s);
arc_cost(i,j,t,s)=arcs(i,j,t,s);
arc_cost('30','31',t,'40')=0;

*------------origin, destination, and intermidiate nodes of each household memeber----------------
parameter origin(a,i,t);
origin('1','1','1')=1;
origin('2','1','3')=1;



parameter destination(a,i,t);
destination('1','31','40')=1;
destination('2','31','40')=1;



parameter intermediate(a,i,t);
intermediate(a,i,t) = (1- origin(a,i,t))* (1- destination(a,i,t));

variable z;
variable tag(i,t,a);

binary variables
x(a,i,j,t,s );


equations
obj                                 objective function
agent_on_node_origin(a,i,t)         origin node agent a on node i at time t
agent_on_node_intermediate(a,i,t)   intermediate node agent a on node i at time t
agent_on_node_destination(a,i,t)    destination node agent a on node i at time t
tag_def(i,t,a)
safety_constraint_1(w,j,s)
;

obj.. z =e= sum (a,(sum((i,j,t,s)$(arcs(i,j,t,s)>0.1), x(a,i,j,t,s)*arc_cost(i,j,t,s))));
agent_on_node_origin(a,i,t)$(origin(a,i,t)=1) .. sum((j,s)$(arcs(i,j,t,s)>0.1), x(a,i,j,t,s)) =e= origin(a,i,t);
agent_on_node_destination(a,i,t)$(destination(a,i,t)=1) ..  sum((j,s)$(arcs(j,i,s,t)>0.1), x(a,j,i,s,t))=e= destination(a,i,t);
agent_on_node_intermediate(a,i,t)$(intermediate(a,i,t)=1).. sum((j,s)$(arcs(i,j,t,s)>0.1), x(a,i, j, t,s))-sum((j,s)$(arcs(j,i,s,t)>0.1), x(a,j,i,s,t))=e= 0;
tag_def(i,t,a).. tag(i,t,a)=e= sum((j,s)$(arcs(i,j,t,s)>0.1),x(a,i,j,t,s));
safety_constraint_1(w,j,s)$(phi_location(j,w)>0.1).. sum((i,t)$(phi(w,i,j,t,s)>0.1),phi(w,i,j,t,s)*tag(i,t,'1'))+ tag(j,s,'2') =l=1;


Model SFD_MODEL /all/ ;
solve SFD_MODEL using MIP minimizing z;
display x.l;
display z.l;

File output_x;
put output_x;
loop((a,i,j,t,s)$((x.l(a,i,j,t,s) = 1)),put @5, a.tl, @10, i.tl, @20, j.tl,  @30, t.tl, @40, s.tl/);


