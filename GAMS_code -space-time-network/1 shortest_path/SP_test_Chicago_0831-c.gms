$ title TDSP
*LIMROW = 0, LIMCOL = 0
*OPTIONS  MINLP = BARON;
OPTIONS  MIP = CPLEX;

set i nodes /1*933/;
set t time stamp /1*120/;
set a agent /1*2/;
alias (i, j);
alias (t, s);

parameter arcs(a,i,j,t,s);
parameter vertex(a,i,t);
parameter origin(a,i,t);
parameter destination(a,i,t);


$include "C:\Work\AgentPlus_VRP\PHX_test_network\STPrism.txt"

parameter travel_cost(a,i,j,t,s);
travel_cost(a,i,j,t,s)$arcs(a,i,j,t,s)= arcs(a,i,j,t,s);


parameter intermediate(a,i,t);
intermediate(a,i,t)$vertex(a,i,t)= (1- origin(a,i,t))* (1- destination(a,i,t));

variable z;
binary variables
x(a,i,j,t,s )  selection of  comm p between i and j;

equations
so_obj
comm_flow_on_node_origin(a,i,t)         origin node flow pv on node i at time t
comm_flow_on_node_intermediate(a,i,t)   intermediate node flow k on node i at time t
comm_flow_on_node_destination(a,i,t)      destination node flow k on node i at time t
;

so_obj.. z =e= sum (a,sum((i,j,t,s)$(arcs(a,i,j,t,s)>0.1), x(a,i,j,t,s)*travel_cost(a,i,j,t,s)));
comm_flow_on_node_origin(a,i,t)$(origin(a,i,t)=1) .. sum((j,s)$(arcs(a,i,j,t,s)>0.1), x(a,i,j,t,s)) =e= origin(a,i,t);
comm_flow_on_node_destination(a,i,t)$(destination(a,i,t)=1) ..  sum((j,s)$(arcs(a,j,i,s,t)>0.1), x(a,j,i,s,t))=e= destination(a,i,t);
comm_flow_on_node_intermediate(a,i,t)$(intermediate(a,i,t)=1).. sum((j,s)$(arcs(a,i,j,t,s)>0.1), x(a,i, j, t,s))-sum((j,s)$(arcs(a,j,i,s,t)>0.1), x(a,j,i,s,t))=e= 0;


Model TDSP /ALL/ ;
solve TDSP using MIP minimizing z;
display x.l;
display z.l;

*$ontext
File output_x/agent_trajectory.txt/;
put output_x;
loop((a,t,s,i,j)$( arcs(a,i,j,t,s) and(x.l(a,i,j,t,s) = 1)),put @5, a.tl, @10, i.tl, @20, j.tl,  @30, t.tl, @40, s.tl/);
*$offtext
