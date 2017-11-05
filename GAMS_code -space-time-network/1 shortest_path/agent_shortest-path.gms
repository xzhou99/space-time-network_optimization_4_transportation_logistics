$ title TDSP
*LIMROW = 0, LIMCOL = 0
*OPTIONS  MINLP = BARON;
*OPTIONS  MIP = CPLEX;

set i nodes /1*6/;
set a nodes /1*1/;
alias (i, j);
parameter arcs(a,i,j);
parameter origin(a,i);
parameter destination(a,i);
parameter travel_cost(a,i,j);


* build network
arcs('1','1','3') = 1;
arcs('1','1','2') = 1;
arcs('1','2','3') = 1;

travel_cost('1','1','3') = 4;
travel_cost('1','1','2') = 1;
travel_cost('1','2','3') = 2;

* OD
origin('1','1') =1;
destination('1','3') =1;

parameter intermediate(a,i);
intermediate(a,i)= (1- origin(a,i))* (1- destination(a,i));
* intermediat notes are not origin or destination

variable z;
binary variables
x(a,i,j )  selection of agent a between i and j;

equations
so_obj
comm_flow_on_node_origin(a,i)         origin node flow of agent a on node i at time t
comm_flow_on_node_intermediate(a,i)   intermediate node flow of agent a on node i at time t
comm_flow_on_node_destination(a,i)      destination node flow of agent a on node i at time t
;

so_obj.. z =e= sum (a,sum((i,j)$(arcs(a,i,j)>0.1), x(a,i,j)*travel_cost(a,i,j)));

comm_flow_on_node_origin(a,i)$(origin(a,i)=1) .. sum((j)$(arcs(a,i,j)>0.1), x(a,i,j)) =e= origin(a,i);
comm_flow_on_node_destination(a,i)$(destination(a,i)=1) ..  sum((j)$(arcs(a,j,i)>0.1), x(a,j,i))=e= destination(a,i);
comm_flow_on_node_intermediate(a,i)$(intermediate(a,i)=1).. sum((j)$(arcs(a,i,j)>0.1), x(a,i,j))-sum((j)$(arcs(a,j,i)>0.1), x(a,j,i))=e= 0;


Model SP /ALL/ ;
solve SP using MIP minimizing z;
display x.l;
display z.l;

*$ontext
File output_x/agent_trajectory.txt/;
put output_x;
loop((a,i,j)$( arcs(a,i,j) and(x.l(a,i,j) = 1)),put @5, a.tl, @10, i.tl, @20, j.tl/);
*$offtext
