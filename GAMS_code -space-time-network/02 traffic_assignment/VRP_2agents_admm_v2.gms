* link based VRP_admm_demo
set i node/1*4/;
alias(i,j,iter_i,iter_j);
set v vehicle/1*2/;
alias (v,iter_v)

parameter c(i,j) cost of link ij;
c('1','2') = 1;
c('1','3') = 4;
c('2','4') = 2;
c('3','4') = 4;

parameter link(i,j) existing link
/
1.2 1
1.3 1
3.4 1
2.4 1
/;

parameter agent_link(i,j)
/
3.4 1
2.4 1
/;
parameter cap(i,j)
/
1.2 2
1.3 2
2.4 2
3.4 2
/;
parameter origin(v,i)
/
1.1 1
2.1 1
/;
parameter destination(v,i)
/
1.4 1
2.4 1
/;
parameter intermediate(v,i);
intermediate(v,i) = (1- origin(v,i))* (1- destination(v,i));

parameter current(v);
current(v) = 0;
parameter Upper_bound;
Upper_bound = 0;
parameter subgradient_capacity(i,j);
parameter step;
step = 1;
parameter i_value;
i_value = 1;
parameter zlbest;
zlbest=0;
parameter n;
n=0;
parameter rho;
rho=2;
parameter mu(i,j) summation of all the other vehicles;
mu(i,j) = 0;
parameter lambda(i,j) LR multiplier;
lambda(i,j) = 0;
set k  subgradient iteration index / 1 * 100 /;
parameter value_v(v)
/
1 1
2 2
/;
parameter value_iter_v(iter_v)
/
1 1
2 2
/;
parameter value(k)
/
1 1
/;
binary variable
x(v,i,j) if vehicle v is on link ij equals one
x_lb(v,i,j)
x_ub(v,i,j)
;

variable
z obj
z_sub each v's cost
z_lb  lower bound
z_ub
;

equation
obj obj
comm_flow_on_node_origin(v,i)         origin node flow
comm_flow_on_node_intermediate(v,i)   intermediate node flow
comm_flow_on_node_destination(v,i)      destination node flow
demand_cons(i,j) demand constraint
sub_x(v) subproblem of vehicle v
LB lower bound the problem
UB_flow_on_node_origin
UB_flow_on_node_destination
UB_flow_on_node_intermediate
LB_flow_on_node_origin
LB_flow_on_node_destination
LB_flow_on_node_intermediate
*UB(v)
;

obj..z =e= sum((v,i,j)$(link(i,j)>0.1),x(v,i,j)*c(i,j));
comm_flow_on_node_origin(v,i)$(origin(v,i)=1) .. sum((j)$(cap(i,j)>0.1), x(v,i,j)) =e= origin(v,i);
comm_flow_on_node_destination(v,i)$(destination(v,i)=1) ..  sum((j)$(cap(j,i)>0.1), x(v,j,i))=e= destination(v,i);
comm_flow_on_node_intermediate(v,i)$(intermediate(v,i)=1).. sum((j)$(cap(i,j)>0.1), x(v,i,j))-sum((j)$(cap(j,i)>0.1), x(v,j,i))=e= 0;
demand_cons(i,j)$(agent_link(i,j)>0.1)..sum(v,x(v,i,j)) =e= 1;

model VRP_demo /obj,comm_flow_on_node_origin,comm_flow_on_node_destination,comm_flow_on_node_intermediate,demand_cons/;
solve VRP_demo using MIP minimizing z;
display z.l;
display x.l;

sub_x(v)$(current(v)=1).. z_sub =e= sum((i,j)$(link(i,j)>0.1),x_ub(v,i,j)*(c(i,j)+lambda(i,j)+rho/2+rho*(mu(i,j)-1)));
LB..z_lb =e= sum((v,i,j)$(link(i,j)>0.1),x_lb(v,i,j)*(c(i,j)+lambda(i,j)))-sum((i,j)$(link(i,j)>0.1),lambda(i,j));
*UB(v)$(current(v)=1)..z_ub =e= sum((i,j)$(link(i,j)>0.1),x_ub(v,i,j)*c(i,j));

UB_flow_on_node_origin(v,i)$(origin(v,i)=1 and current(v)=1) .. sum((j)$(cap(i,j)>0.1), x_ub(v,i,j)) =e= origin(v,i);
UB_flow_on_node_destination(v,i)$(destination(v,i)=1 and current(v)=1) ..  sum((j)$(cap(j,i)>0.1), x_ub(v,j,i))=e= destination(v,i);
UB_flow_on_node_intermediate(v,i)$(intermediate(v,i)=1 and current(v)=1).. sum((j)$(cap(i,j)>0.1), x_ub(v,i,j))-sum((j)$(cap(j,i)>0.1), x_ub(v,j,i))=e= 0;

LB_flow_on_node_origin(v,i)$(origin(v,i)=1) .. sum((j)$(cap(i,j)>0.1), x_lb(v,i,j)) =e= origin(v,i);
LB_flow_on_node_destination(v,i)$(destination(v,i)=1) ..  sum((j)$(cap(j,i)>0.1), x_lb(v,j,i))=e= destination(v,i);
LB_flow_on_node_intermediate(v,i)$(intermediate(v,i)=1).. sum((j)$(cap(i,j)>0.1), x_lb(v,i,j))-sum((j)$(cap(j,i)>0.1), x_lb(v,j,i))=e= 0;

model admm_model/sub_x,UB_flow_on_node_origin,UB_flow_on_node_destination,UB_flow_on_node_intermediate/;
model calculate_lower_bound /LB,LB_flow_on_node_origin,LB_flow_on_node_destination,LB_flow_on_node_intermediate/;
*model calculate_upper_bound /UB,UB_flow_on_node_origin,UB_flow_on_node_destination,UB_flow_on_node_intermediate/

Loop (k,
*miu = 0.1 initial
*if k=1, use x.l to define mu(i,j)
if(value(k)=1,
         loop(iter_v,

*define all the other..
*mu(i,j) indicate no. of all the other agents on link(i,j),
         mu(i,j)$(link(i,j)>0.1) = sum(v$(value_v(v)<>value_iter_v(iter_v)),x.l(v,i,j));
         current(iter_v) = 1;
         solve admm_model using MIP minimizing z_sub;
         current(iter_v) = 0;
         );
         upper_bound = sum((v,i,j)$(link(i,j)>0.1),x_ub.l(v,i,j)*c(i,j));
         solve calculate_lower_bound using MIP minimizing z_lb;
         display z_lb.l;
         display Upper_bound;
         display x_lb.l;
         display x_ub.l;
         subgradient_capacity(i,j)$(agent_link(i,j)> 0)= sum(v,x_lb.l(v,i,j))-1;
         lambda(i,j)$(agent_link(i,j)>0) = max(0,lambda(i,j)+step*subgradient_capacity(i,j));
         i_value = i_value +1;
         step = 1/i_value;
         zlbest = max(zlbest,z_lb.l);
         n = i_value-1;
         display lambda;
         display subgradient_capacity;

else
*if k>1, use x_ub to define mu(i,j)
         loop(iter_v,
                 loop(iter_i,
                 loop(iter_j,
*define all the other..
*mu(i,j) indicate no. of all the other agents on link(i,j)
                 if(
                  link(iter_i,iter_j)>0.1,
                  mu(i,j)$(link(iter_i,iter_j)>0.1) = sum(v$(value_v(v)<>value_iter_v(iter_v)),x_ub.l(v,i,j));
                 )
                 );
                 );
         current(iter_v) =1;
         solve admm_model using MIP minimizing z_sub;
*         display z_sub.l;
         current(iter_v) = 0;
         );
         upper_bound = sum((v,i,j)$(link(i,j)>0.1),x_ub.l(v,i,j)*c(i,j));
         solve calculate_lower_bound using MIP minimizing z_lb;
         display z_lb.l;
         display Upper_bound;
         display x_lb.l;
         display x_ub.l;
         display lambda;
         display subgradient_capacity;
         Upper_bound = 0;
         subgradient_capacity(i,j)$(agent_link(i,j)> 0)= sum(v,x_lb.l(v,i,j))-1;
         lambda(i,j)$(agent_link(i,j)>0) = max(0,lambda(i,j)+rho*subgradient_capacity(i,j));
         i_value = i_value +1;
         step = 3/i_value;
         zlbest = max(zlbest,z_lb.l);
         n = i_value-1;

);
);

display zlbest;
display z.l;
display x.l;
