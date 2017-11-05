$ title dynamic transit service network design Problem
*LIMROW = 0, LIMCOL = 0
*OPTIONS  MINLP = BARON;
OPTIONS  MINLP = SCIP;

set i nodes /1*3/;
set t time stamp /0*5/;
set a agent /1*3/;
set k nodes /1*2/;
alias (i, j);
alias (t, s);

parameter c(i,j,t,s) link travel cost /
1. 2. 0. 1 1
1. 2. 2. 3 1
1. 1. 0. 1 1
1. 1. 1. 2 1
2. 3. 1. 3 2
2. 3. 3. 5 2
2. 2. 1. 2 1
2. 2. 2. 3 1
3. 3. 3. 4 0
3. 3. 4. 5 0
1. 3. 1. 4 3
/;

parameter net(i,j,t,s) link travel cost /
1. 2. 0. 1 1
1. 2. 2. 3 1
1. 1. 0. 1 1
1. 1. 1. 2 1
2. 3. 1. 3 1
2. 3. 3. 5 1
2. 2. 1. 2 1
2. 2. 2. 3 1
3. 3. 3. 4 1
3. 3. 4. 5 1
1. 3. 1. 4 1
/;

parameter Cap(i,j,t,s) link capacity /
1. 2. 0. 1 1
1. 2. 2. 3 2
1. 1. 0. 1 2
1. 1. 1. 2 2
2. 3. 1. 3 1
2. 3. 3. 5 2
2. 2. 1. 2 2
2. 2. 2. 3 2
3. 3. 3. 4 2
3. 3. 4. 5 2
1. 3. 1. 4 1
/;


parameter ccost(i,j) construction cost /
1. 2   0
2. 3   0
1. 3   10
/;

parameter Budget;
Budget =15;

parameter original_least_path_time;
original_least_path_time = 3;

parameter M;
M = 10;

parameter epsilon(a)/
1 0
2 2
3 2
/;

parameter r(i,j) existing link factor /
1. 1   1
2. 2   1
3. 3   1
1. 2   1
2. 3   1
1. 3   0
/;

parameter origin(a,i,t) /
1. 1  .  0    1
2. 1  .  0    1
3. 1  .  0    1
/;

parameter destination(a,i,t) /
1. 3  .  5    1
2. 3  .  5    1
3. 3  .  5    1
/;


parameter node_index(i,t) /
1. 1    1
1. 2    1
2. 1    1
2. 2    1
2. 3    1
3. 3    1
3. 4    1
/
parameter intermediate(a,i,t);
intermediate(a,i,t)$(node_index(i,t)>0.1) = (1- origin(a,i,t))* (1- destination(a,i,t));

parameter miu(i,j,t,s);
miu(i,j,t,s)$(net(i,j,t,s)>0.1)=0.1;

parameter lamda(a,k);
lamda(a,k)=0.1;

variable z;
variable z_1;
variable z_2;
variable f(i,j,t,s);

positive variables
x(a,i,j,t,s )  selection of  comm p between i and j;

binary variables y(i,j);
y.fx(i,j)$(r(i,j)>0.1)=1;

equations
so_obj
obj_x
obj_y
comm_flow_on_node_origin(a,i,t)         origin node flow pv on node i at time t
comm_flow_on_node_intermediate(a,i,t)   intermediate node flow k on node i at time t
comm_flow_on_node_destination(a,i,t)      destination node flow k on node i at time t
flow_def(i,j,t,s)
budget_constraint
cap_constraint(i,j,t,s)
BRUE_1(a)
BRUE_2(a);

so_obj.. z =e= sum((i,j,t,s)$(net(i,j,t,s)>0.1), f(i,j,t,s)*c(i,j,t,s));
obj_x.. z_1 =e= sum((a,i,j,t,s)$(net(i,j,t,s)>0.1),x(a,i,j,t,s)*(c(i,j,t,s)+miu(i,j,t,s)))+sum((a,k),lamda(a,k)*sum((i,j,t,s)$(net(i,j,t,s)>0.1),x(a,i,j,t,s)*c(i,j,t,s)));
obj_y.. z_2 =e= sum((i,j,t,s)$(net(i,j,t,s)>0.1),miu(i,j,t,s)*cap(i,j,t,s)*y(i,j))+sum(a,lamda(a,'1')*(original_least_path_time+epsilon(a))+lamda(a,'2')*(4+(1-y('1','3'))*M+epsilon(a)));
comm_flow_on_node_origin(a,i,t)$(origin(a,i,t)=1) .. sum((j,s)$(net(i,j,t,s)>0.1), x(a,i,j,t,s)) =e= origin(a,i,t);
comm_flow_on_node_destination(a,i,t)$(destination(a,i,t)=1) ..  sum((j,s)$(net(j,i,s,t)>0.1), x(a,j,i,s,t))=e= destination(a,i,t);
comm_flow_on_node_intermediate(a,i,t)$(intermediate(a,i,t)=1).. sum((j,s)$(net(i,j,t,s)>0.1), x(a,i, j, t,s))-sum((j,s)$(net(j,i,s,t)>0.1), x(a,j,i,s,t))=e= 0;
flow_def(i,j,t,s)..f(i,j,t,s) =e= sum(a,x(a,i,j,t,s));
budget_constraint..  sum((i,j), ccost(i,j)*y(i,j)) =l= Budget;
cap_constraint(i,j,t,s)$(net(i,j,t,s)>0.1).. Cap(i,j,t,s)*y(i,j)-f(i,j,t,s) =g=0;
BRUE_1(a).. sum((i,j,t,s)$(net(i,j,t,s)>0.1), x(a,i,j,t,s)*c(i,j,t,s))=l= original_least_path_time + epsilon(a);
BRUE_2(a).. sum((i,j,t,s)$(net(i,j,t,s)>0.1), x(a,i,j,t,s)*c(i,j,t,s))=l= 4+(1-y('1','3'))*M+epsilon(a);

Model Dynamic_Discrete_Network_Design /so_obj,flow_def,budget_constraint,comm_flow_on_node_origin, comm_flow_on_node_destination, comm_flow_on_node_intermediate,cap_constraint,BRUE_1,BRUE_2/ ;
Model Dynamic_Discrete_Network_Design_x /obj_x,comm_flow_on_node_origin,comm_flow_on_node_destination,comm_flow_on_node_intermediate/;
Model Dynamic_Discrete_Network_Design_y /obj_y,budget_constraint/;

solve Dynamic_Discrete_Network_Design using MIP minimizing z;
display x.l;
display f.l;
display z.l;
display y.l;

parameter subgradient_capacity(i,j,t,s);
parameter subgradient_path_1(a,k);
parameter subgradient_path_2(a,k);
parameter z_lb;
parameter step;
step = 1;
parameter i_value;
i_value = 1;
parameter zlbest;
zlbest=0;
parameter n;
n=0;

sets iter  subgradient iteration index / iter1 * iter40 /;
File output_obj_lb/dynamic_network_design_lb_1.txt/;
put output_obj_lb;

Loop (iter,

         solve Dynamic_Discrete_Network_Design_x using MIP minimizing z_1;
         solve Dynamic_Discrete_Network_Design_y using MIP maximizing z_2;

         subgradient_capacity(i,j,t,s)$(net(i,j,t,s)> 0)= sum(a,x.l(a,i,j,t,s))-y.l(i,j)*Cap(i,j,t,s);
         miu(i,j,t,s)$(net(i,j,t,s)>0)= max(0,miu(i,j,t,s) + step*subgradient_capacity(i,j,t,s));

         subgradient_path_1(a,'1')= sum((i,j,t,s),x.l(a,i,j,t,s)*c(i,j,t,s))-original_least_path_time-epsilon(a);
         subgradient_path_2(a,'2')= sum((i,j,t,s),x.l(a,i,j,t,s)*c(i,j,t,s))-4-(1-y.l('1','3'))*M-epsilon(a);
         lamda(a,'1')=max(0,lamda(a,'1')+step*subgradient_path_1(a,'1'));
         lamda(a,'2')=max(0,lamda(a,'2')+step*subgradient_path_2(a,'2'));

         i_value = i_value +1;
         step = 1/i_value;

         z_lb = z_1.l - z_2.l;
         zlbest = max(zlbest,z_lb);
         n = i_value-1;

         put @3,n,@15,z_1.l,@30,z_2.l,@45,z_lb,@60,zlbest /
);

display x.l;
display y.l;






