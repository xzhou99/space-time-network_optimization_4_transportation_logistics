$title traffic rerouting Problem
OPTIONS  ITERLIM=100000, RESLIM = 1000000, SYSOUT = OFF, SOLPRINT = OFF,NLP=MINOS, OPTCR= 0.1, LIMROW = 0, LIMCOL = 0;

sets
    a  arcs or links /1*9/
    o  od index /1*4/
    k  path index /1*3/
    t  time index /1*20/
    i  link sequence no /1*3/
;
alias (o,d);

parameter obs_outflow(a,t)  observed out flow rate /
1.   4       10
/;

parameter obs_density(a,t)  observed density * length /
1.   4       100
/;

parameter trip(o,d)  positive flow trip flag /
1.       4    1
/;

parameter val_t(t)  /
1        1
2        2
3        3
4        4
5        5
6        6
7        7
8        8
9        9
10        10
11        11
12        12
13        13
14        14
15        15
16        16
17        17
18        18
19        19
20        20

/;

parameter val_i(i)  /
1  1
2  2
3  3
/;

* number of links in each path (o,d,k)
parameter link_size_path_matrix(o,d,k) /
1. 4. 1  2
1. 4. 2  3
1. 4. 3  2
/;

parameter cap(a,t);
cap(a,t) = 1;


* link index to link number mapping matrix from path (o,d,k)'th link to link a
parameter path_link_matrix(o,d,k,i,a)/
1.       4.      1.      1.      1      1
1.       4.      1.      2.      2       1
1.       4.      2.      1.      3      1
1.       4.      2.      2.      4       1
1.       4.      2.      2.      5       1
1.       4.      3.      1.      7      1
1.       4.      3.      2.      8       1
/;

parameter network_Avg_TT;



positive variables
CA(o,d,k,i,t)  cumulative arrival flow o d tau k ith link at time t
CV(o,d,k,i,t)  cumulative downstream arrival flow o d tau k ith link at time t
CD(o,d,k,i,t)  cumulative departure flow o d tau k ith link at time t
X(o,d,k)       path flow o d tau k
TD(a,t)            total flow on link a time t
TV(a,t)
TA(a,t)
TotalTT(o,d,k)

variable
           z   objective for nlp formulation
;
equations
           link_flow_transfer  flow transfer constraints  from A to V
           vertical_queue(o,d,k,t,i)  flow transfer constraints from V to D
           link2link_flow_transfer  flow transfer constraints

           total_departure(a,t)  total departure constraints
           total_arrival(a,t)  total arrival constraints     
           total_vertical_queue(a,t)  total vertical queue constraints
           capacity_out_flow_1(a,t)  capacity out flow constraint 1
           capacity_out_flow_2(a,t)  capacity out flow constraint 2
           non_neg_A(o,d,k,i,t) non negativity constraint A
           non_neg_D(o,d,k,i,t) non negativity constraint D
           non_neg_V(o,d,k,i,t) non negativity constraint V
           TotalTravelTime_def                   travel time definition
           SystemEst_def                  system-wide estimation objective function definition constraint
;

link_flow_transfer(o,d,k,t,i)$( trip(o,d)).. CA(o,d,k,i,t-1)=e= CV(o,d,k,i,t);
vertical_queue(o,d,k,t,i)$( trip(o,d)).. CD(o,d,k,i,t)=l= CV(o,d,k,i,t);
link2link_flow_transfer(o,d,k,i,t)$( trip(o,d)$(val_i(i)< link_size_path_matrix(o,d,k))).. CD(o,d,k,i,t)=e= CA(o,d,k,i+1,t);

total_departure(a,t).. TD(a,t) =e= sum((o,d,k,i)$path_link_matrix(o,d,k,i,a),CD(o,d,k,i,t));
total_arrival(a,t).. TA(a,t) =e= sum((o,d,k,i)$path_link_matrix(o,d,k,i,a),CA(o,d,k,i,t));
total_vertical_queue(a,t).. TV(a,t) =e= sum((o,d,k,i)$path_link_matrix(o,d,k,i,a),CV(o,d,k,i,t));
capacity_out_flow_1(a,t).. TD(a,t)-TD(a,t-1) =l= TV(a,t-1)-TD(a,t-1);
capacity_out_flow_2(a,t).. TD(a,t)-TD(a,t-1) =l= cap(a,t);

non_neg_A(o,d,k,i,t)$( trip(o,d)).. CA(o,d,k,i,t) =g= CA(o,d,k,i,t-1);
non_neg_D(o,d,k,i,t)$( trip(o,d)).. CD(o,d,k,i,t) =g= CD(o,d,k,i,t-1);
non_neg_V(o,d,k,i,t)$( trip(o,d)).. CV(o,d,k,i,t) =g= CV(o,d,k,i,t-1);
TotalTravelTime_def(o,d,k)$(trip(o,d)) .. TotalTT(o,d,k) =e= sum((i,t)$(val_i(i)=link_size_path_matrix(o,d,k)), val_t(t)*(CD(o,d,k,i,t)-CD(o,d,k,i,t-1)));
SystemEst_def..  z =e= sum((a,t), ( TD(a,t)-TD(a,t-1) - obs_outflow(a,t))*( TD(a,t)-TD(a,t-1) - obs_outflow(a,t)))
+  sum((a,t), ( TA(a,t)-TD(a,t) - obs_density(a,t))*( TA(a,t)-TD(a,t) - obs_density(a,t)));  ;

MODEL state_estimation /link_flow_transfer,vertical_queue,link2link_flow_transfer,
total_departure,total_vertical_queue,capacity_out_flow_1,capacity_out_flow_2,
non_neg_A,non_neg_D,non_neg_V,
TotalTravelTime_def,SystemEst_def/ ;

SOLVE state_estimation USING NLP MINIMIZING z;
display TotalTT.L, CA.l, CV.l,CD.l,z.l;


