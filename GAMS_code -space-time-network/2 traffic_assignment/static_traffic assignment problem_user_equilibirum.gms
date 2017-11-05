$title Traffic assignment problem user equilibrium
*LIMROW = 0, LIMCOL = 0
*OPTIONS  ITERLIM=100000, RESLIM = 1000000, SYSOUT = OFF, SOLPRINT = OFF, lp = COINGLPK, mip = COINGLPK, OPTCR= 0.1;

set i nodes /1*4/;

alias (i, j);

parameter c_a(i,j) link travel time /
1. 2   60
1. 3   10
2. 4   10
3. 4   60
3. 2   10
/;

parameter c_b(i,j) link cost parameter /
1. 2   1
1. 3   10
2. 4   10
3. 4   1
3. 2   1
/;

parameter demand_vehicle;
demand_vehicle = 6;

parameter origin_node(i);
origin_node('1') = 1;

parameter destination_node(i);
destination_node('4') = 1;

parameter intermediate_node(i);
intermediate_node(i) = (1-origin_node(i))* (1-destination_node(i));

variable z;

positive variables
x(i,j)  selection of flow between i and j;

equations
ue_obj
flow_on_node_origin(i)
flow_on_node_intermediate(i)
flow_on_node_destination(i)
;

ue_obj.. z =e= sum((i,j)$(c_a(i,j)>0.1), x(i,j)*c_a(i,j) + c_b(i,j)*x(i,j) *x(i,j)*0.5);
flow_on_node_origin(i)$(origin_node(i)).. sum((j)$(c_a(i,j)>0.1), x(i,j)) =e= demand_vehicle;
flow_on_node_destination(i)$(destination_node(i))..  sum((j)$(c_a(j,i)>0.1), x(j,i))=e= demand_vehicle;
flow_on_node_intermediate(i)$(intermediate_node(i)).. sum((j)$(c_a(i,j)>0.1), x(i,j))-sum((j)$(c_a(j,i)>0.1),x(j,i))=e= 0;

Model traffic_ue/all/ ;

solve traffic_ue using NLP minimizing z;

display x.l;
display z.l;


parameter total_cost;
total_cost =  sum((i,j)$(c_a(i,j)>0.1) , x.l(i,j)*( c_a(i,j) + c_b(i,j)*x.l(i,j)) );
display total_cost;














