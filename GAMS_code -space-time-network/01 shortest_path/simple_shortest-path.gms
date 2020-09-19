$ title TDSP
*LIMROW = 0, LIMCOL = 0
*OPTIONS  MINLP = BARON;
*OPTIONS  MIP = CPLEX;

set i nodes /1*6/;
alias (i, j);
parameter arcs(i,j);
parameter origin(i);
parameter destination(i);
parameter travel_cost(i,j);


* build network
arcs('1','3') = 1;
arcs('1','2') = 1;
arcs('2','3') = 1;

travel_cost('1','3') = 4;
travel_cost('1','2') = 1;
travel_cost('2','3') = 2;

* OD
origin('1') =1;
destination('3') =1;

parameter intermediate(i);
intermediate(i)= (1- origin(i))* (1- destination(i));
* intermediat notes are not origin or destination

variable z;
binary variables
x(i,j )  selection of agent a between i and j;

equations
so_obj
comm_flow_on_node_origin(i)         origin node flow of agent a on node i at time t
comm_flow_on_node_intermediate(i)   intermediate node flow of agent a on node i at time t
comm_flow_on_node_destination(i)      destination node flow of agent a on node i at time t
;

so_obj.. z =e= sum((i,j)$(arcs(i,j)>0.1), x(i,j)*travel_cost(i,j));

comm_flow_on_node_origin(i)$(origin(i)=1) .. sum((j)$(arcs(i,j)>0.1), x(i,j)) =e= origin(i);
comm_flow_on_node_destination(i)$(destination(i)=1) ..  sum((j)$(arcs(j,i)>0.1), x(j,i))=e= destination(i);
comm_flow_on_node_intermediate(i)$(intermediate(i)=1).. sum((j)$(arcs(i,j)>0.1), x(i,j))-sum((j)$(arcs(j,i)>0.1), x(j,i))=e= 0;


Model SP /ALL/ ;
solve SP using MIP minimizing z;
display x.l;
display z.l;

*$ontext
File output_x/agent_trajectory.txt/;
put output_x;
loop((i,j)$( arcs(i,j) and(x.l(i,j) = 1)),put @10, i.tl, @20, j.tl/);
*$offtext
