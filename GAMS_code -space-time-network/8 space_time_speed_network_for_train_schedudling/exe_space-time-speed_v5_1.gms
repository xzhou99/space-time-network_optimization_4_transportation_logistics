
$ontext
     title Train energy and schedule optimization Problem
    xuesong zhou
    junhua Chen.   cjh@bjtu.edu.cn
    8/18,2016

$offtext
*LIMROW = 0, LIMCOL = 0 v
OPTIONS LIMROW = 100, LIMCOL = 100, ITERLIM=100000, RESLIM = 1000000, SYSOUT = OFF, SOLPRINT = OFF, OPTCR= 0.1;

set k vehicle;
set i nodes;

set u speed;
set t time stamp;

alias (i, j);
alias (t, s, t_e, t_l);
alias (u, v);
alias (t,tp);

parameter arcs_cost(k,i,j,t,s,u,v);

parameter origin(k,i,t,u);
parameter destination(k,i,t,u);
parameter intermediate(k,i,t,u);


scalar h;
parameter h_range(t,s);

parameter p_supply(i);

parameter node_map(i);
parameter time_map(t);

variable z;
binary variables
    x(k,i, j, t, s,u,v)  selection of train k between i and j from time t to time s with speed u to v;

equations
         obj                              define objective function
         node_origin(k,i,t,u)             origin node flow k on node i at time t with speed u
         node_intermediate(k,i,t,u)       intermediate node flow k on node i at time t  with speed u
         node_destination(k,i,t,u)        destination node flow k on node i at time t  with speed u
         headway_capacity_departure(i,t)
         headway_capacity_arrive(j,t)
         power_supply_constraint(i,t)
;


obj.. z =e=
         sum((k,i,j, t,s,u,v)$(arcs_cost(k,i,j,t,s,u,v)), arcs_cost(k,i,j,t,s,u,v)*x(k,i, j, t, s,u,v));

node_origin(k,i,t,u)$(origin(k,i,t,u))..
         sum((j,s,v)$(arcs_cost(k,i,j,t,s,u,v)), x(k,i,j,t,s,u,v)) =e= 1;
node_destination(k,i,t,u)$(destination(k,i,t,u))..
         sum((j,s,v)$(arcs_cost(k,j,i,s,t,v,u)), x(k,j,i,s,t,v,u))=e= 1;
node_intermediate(k,i,t,u)$(intermediate(k,i,t,u))..
         sum((j,s,v)$(arcs_cost(k,i,j,t,s,u,v)), x(k,i,j,t,s,u,v))-sum((j,s,v)$(arcs_cost(k,j,i,s,t,v,u)), x(k,j,i,s,t,v,u))=e= 0;

headway_capacity_departure(i,t)..
         sum(tp$h_range(t,tp),
             sum((k,j,s,u,v)$(arcs_cost(k,i,j,tp,s,u,v) and i.val<>j.val), x(k,i,j,tp,s,u,v))
             )=l= 1;
headway_capacity_arrive(j,t)..
         sum(tp$h_range(t,tp),
             sum((k,i,s,u,v)$(arcs_cost(k,i,j,tp,s,u,v) and i.val<>j.val), x(k,i,j,tp,s,u,v))
             )=l= 1;

power_supply_constraint(i,t)..
         sum(tp$(t.val<tp.val),
              sum((k,j,s,u,v)$(arcs_cost(k,i,j,tp,s,u,v) and i.val<>j.val and p_supply(i)=p_supply(j) and tp.val<s.val)
                   ,arcs_cost(k,i,j,tp,s,u,v)*x(k,i,j,tp,s,u,v)/(time_map(s)-time_map(t))
                 )
            )=l= 1000;

Model vehicle_routing_optimization /obj,
                                   node_origin,
                                 node_intermediate,
                                 headway_capacity_departure,
                                 headway_capacity_arrive,
                                 power_supply_constraint
/ ;

************** input data
$include "C:\Work\GAMS\STS\input_data_for_gams.txt";
$include "C:\Work\GAMS\STS\input_data_for_gams_arcs.txt";
intermediate(k,i,t,u) = (1- origin(k,i,t,u))* (1- destination(k,i,t,u));
*******************************

solve vehicle_routing_optimization using MIP minimizing z;

display x.l,z.l;


****************output data
File output_x  /'output_x.txt'/;

put output_x
loop((K,T,S,I,J,U,V)$((x.l(k,i,j,t,s,u,v) )),put @5, k.tl, @10, node_map(i), @20, node_map(j),  @40, time_map(t), @50, time_map(s), @70, u.tl, @75, v.tl, @80, x.l(k,i,j,t,s,u,v)/);

******************
















