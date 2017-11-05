$title Customzed shuttle services
OPTIONS mip = CPLEX;
$ontext
By
    Lu Tong,
    Xuesong Zhou,
    Jiangtao Liu
                              9/20,2016
$offtext

set k bus /1*2/;
set k_h(k) physical bus /1/;
set k_r(k) virtual bus /2/;
set i nodes /1*25/;
set depot(i) destination depots /7,8,18/;
set t time stamp /1*60/;
set p passenger /1*9/;
set p_h(p) physical passenger /1*8/;
set p_r(p) virtual passenger /9/;

alias (i, j);
alias (t, s);

parameter phi_o(p_h,i,t) passenger pick-up region /
1. 3. 11   1,        1. 3. 12   1,        1. 3. 13   1,        1. 3. 14   1,        1. 3. 15   1
2. 12. 7   1,        2. 12. 8   1,        2. 12. 9   1,        2. 12. 10   1,        2. 12. 11   1
3. 4. 15   1,        3. 4. 16   1,        3. 4. 17   1,        3. 4. 18   1,        3. 4. 19   1
4. 4. 20   1,        4. 4. 21   1,        4. 4. 22   1,        4. 4. 23   1,        4. 4. 24   1
4. 5. 20   1,        4. 5. 21   1,        4. 5. 22   1,        4. 5. 23   1,        4. 5. 24   1
5. 5. 15   1,        5. 5. 16   1,        5. 5. 17   1,        5. 5. 18   1,        5. 5. 19   1
6. 11. 12   1,        6. 11. 13   1,        6. 11. 14   1,        6. 11. 15   1,        6. 11. 16   1
7. 12. 7   1,        7. 12. 8   1,        7. 12. 9   1,        7. 12. 10   1,        7. 12. 11   1
8. 12. 10   1,        8. 12. 11   1,        8. 12. 12   1,        8. 12. 13   1,        8. 12. 14   1
/;

parameter value_t(t)/
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
21        21
22        22
23        23
24        24
25        25
26        26
27        27
28        28
29        29
30        30
31        31
32        32
33        33
34        34
35        35
36        36
37        37
38        38
39        39
40        40
41        41
42        42
43        43
44        44
45        45
46        46
47        47
48        48
49        49
50        50
51        51
52        52
53        53
54        54
55        55
56        56
57        57
58        58
59        59
60        60
/;

parameter value_i(i)/
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
21        21
22        22
23        23
24        24
25        25
/;

parameter arcs(i,j,t,s) link travel time ;
*traveling arcs
arcs('1','2',t,t+6)=1;
arcs('1','3',t,t+4)=1;
arcs('2','1',t,t+6)=1;
arcs('2','6',t,t+5)=1;
arcs('3','1',t,t+4)=1;
arcs('3','4',t,t+4)=1;
arcs('3','12',t,t+4)=1;
arcs('4','3',t,t+4)=1;
arcs('4','5',t,t+2)=1;
arcs('4','11',t,t+6)=1;
arcs('5','4',t,t+2)=1;
arcs('5','6',t,t+4)=1;
arcs('5','9',t,t+5)=1;
arcs('6','2',t,t+5)=1;
arcs('6','5',t,t+4)=1;
arcs('6','8',t,t+2)=1;
arcs('7','8',t,t+3)=1;
arcs('7','18',t,t+2)=1;
arcs('8','7',t,t+3)=1;
arcs('9','5',t,t+5)=1;
arcs('9','8',t,t+10)=1;
arcs('9','10',t,t+3)=1;
arcs('10','9',t,t+3)=1;
arcs('10','11',t,t+5)=1;
arcs('10','15',t,t+6)=1;
arcs('10','16',t,t+4)=1;
arcs('10','17',t,t+8)=1;
arcs('11','4',t,t+6)=1;
arcs('11','10',t,t+5)=1;
arcs('11','12',t,t+6)=1;
arcs('11','14',t,t+4)=1;
arcs('12','3',t,t+4)=1;
arcs('12','11',t,t+6)=1;
arcs('12','13',t,t+3)=1;
arcs('13','12',t,t+3)=1;
arcs('13','24',t,t+4)=1;
arcs('14','11',t,t+4)=1;
arcs('14','15',t,t+5)=1;
arcs('14','23',t,t+4)=1;
arcs('15','10',t,t+6)=1;
arcs('15','14',t,t+5)=1;
arcs('15','19',t,t+3)=1;
arcs('15','22',t,t+3)=1;
arcs('16','8',t,t+5)=1;
arcs('16','10',t,t+4)=1;
arcs('16','17',t,t+2)=1;
arcs('16','18',t,t+3)=1;
arcs('17','10',t,t+8)=1;
arcs('17','16',t,t+2)=1;
arcs('17','19',t,t+2)=1;
arcs('18','7',t,t+2)=1;
arcs('19','15',t,t+3)=1;
arcs('19','17',t,t+2)=1;
arcs('19','20',t,t+4)=1;
arcs('20','18',t,t+4)=1;
arcs('20','19',t,t+4)=1;
arcs('20','21',t,t+6)=1;
arcs('20','22',t,t+5)=1;
arcs('21','20',t,t+6)=1;
arcs('21','22',t,t+2)=1;
arcs('21','24',t,t+3)=1;
arcs('22','15',t,t+3)=1;
arcs('22','20',t,t+5)=1;
arcs('22','21',t,t+2)=1;
arcs('22','23',t,t+4)=1;
arcs('23','14',t,t+4)=1;
arcs('23','22',t,t+4)=1;
arcs('23','24',t,t+2)=1;
arcs('24','13',t,t+4)=1;
arcs('24','21',t,t+3)=1;
arcs('24','23',t,t+2)=1;

* add ground holding arcs at source and sink
arcs('1','1', t,t+1) = 1;
arcs('2','2', t,t+1) = 1;
arcs('13','13', t,t+1) = 1;
arcs('25','25', t,t+1) = 1;

*depot
arcs(depot,'25',t,t)=1;

parameter travel_cost(k_h,i,j,t,s);
travel_cost(k_h,i,j,t,s)= 0.01;
travel_cost('1','1','1',t,t+1)= 0;
travel_cost(k_h,'25','25',t,t+1)= 0;


parameter origin_node(k_h,i,t)  origin nodes and departure time;
origin_node('1','1','1') = 1;

parameter destination_node(k_h,i,t);
destination_node('1','25','30') = 1;

parameter intermediate_node(k_h,i,t);
intermediate_node(k_h,i,t) = (1- origin_node(k_h,i,t))*(1- destination_node(k_h,i,t));

parameter cost(p,k);
cost(p,k_r) = 1;

parameter capacity(k_h);
capacity(k_h) = 10;

parameter load_factor(k_h);
load_factor(k_h) = 6;

parameter ass_cap(p,k_h) assigment capacity of passenger;
ass_cap(p_r,k_h) =  capacity(k_h);
ass_cap(p_h,k_h) =  1;

parameter pie(p_h,k_h);
pie(p_h,k_h) = 0.0;

variable z, z_GAP, z_routing;
binary variable x(p,k)    passenger p is delivered by bus k;
binary variable y(k_h,i,j,t,s)  bus k travels between i and j from time t to time s;


equations
obj_GAP                                   define objective function
obj_routing                                   define objective function
passenger_assignment(p)               passenger p assigned to bus k
pick_up_condition(p,k)              passenger pick-up region
low_capacity_constraint(k_h)            min load factor
high_capacity_constraint(k_h)           max load factor
flow_on_node_origin(k,i,t)         origin node flow on node i at time t
flow_on_node_intermediate(k,i,t)   intermediate node flow on node i at time t
flow_on_node_destination(k,i,t)      destination node flow on node i at time t
;

obj_GAP.. z_GAP =e= sum((p,k),cost(p,k) * x(p,k)) +  sum((p_h,k_h),pie(p_h,k_h) * x(p_h,k_h));
obj_routing.. z_routing =e= sum((k_h,i,j,t,s)$arcs(i,j,t,s), (travel_cost(k_h,i,j,t,s)- sum(p_h$phi_o(p_h,i,t),pie(p_h,k_h))) * y(k_h,i,j,t,s));
passenger_assignment(p_h).. sum(k, x(p_h,k)) =e= 1;
pick_up_condition(p_h,k_h).. x(p_h,k_h) =l= sum((i,j,t,s)$ (phi_o(p_h,i,t) and arcs(i,j,t,s)), y(k_h,i,j,t,s));
low_capacity_constraint(k_h).. load_factor(k_h) =l= sum(p, ass_cap(p,k_h) * x(p,k_h));
high_capacity_constraint(k_h).. sum(p,ass_cap(p,k_h) * x(p,k_h)) =l= capacity(k_h);
flow_on_node_origin(k_h,i,t)$(origin_node(k_h,i,t)).. sum((j,s)$(arcs(i,j,t,s)), y(k_h,i,j, t,s)) =e= 1;
flow_on_node_destination(k_h,i,t)$(destination_node(k_h,i,t))..  sum((j,s)$(arcs(j,i,s,t)), y(k_h,j,i,s,t))=e= 1;
flow_on_node_intermediate(k_h,i,t)$(intermediate_node(k_h,i,t)).. sum((j,s)$(arcs(i,j,t,s)), y(k_h,i,j,t,s))-sum((j,s)$(arcs(j,i,s,t)), y(k_h,j,i,s,t)) =e= 0;

Model customized_bueses_GAP /obj_GAP, passenger_assignment,low_capacity_constraint,high_capacity_constraint/;
Model customized_bueses_routing /obj_routing,flow_on_node_origin,flow_on_node_destination,flow_on_node_intermediate/;

parameter z_x, z_y;

parameter subgradient_pie(p,k);

parameter z_lb;
parameter step;
step = 1;
parameter i_value;
i_value = 1;
parameter zlbest;
zlbest=0;
parameter n;
n=0;

File output_y; put output_y;

sets iter  subgradient iteration index / iter1 * iter20 /;

File output_obj_lb/result_LR.txt/;
put output_obj_lb;


parameter   y_pickup(p,k);
parameter   y_delivery(p,k);

put @3,'n',@5,'z_x',@10,'z_y',@15,'z_GAP',@30,'z_routing',@45,'z_lb',@60,'zlbest' /

Loop (iter,

         solve customized_bueses_GAP using MIP minimizing z_GAP;
         solve customized_bueses_routing using MIP minimizing z_routing;

         y_pickup(p_h,k_h) =  sum((i,j,t,s)$ (phi_o(p_h,i,t) and arcs(i,j,t,s)), y.l(k_h,i,j,t,s));


         subgradient_pie(p_h,k_h)= x.l(p_h,k_h) -  y_pickup(p_h,k_h);

         pie(p_h,k_h)=max(0,pie(p_h,k_h)+step*subgradient_pie(p_h,k_h));

         i_value = i_value +1;
         step = 1/i_value;

         z_lb = z_GAP.l + z_routing.l;
         zlbest = max(zlbest,z_lb);
         n = i_value-1;

         z_x = sum((p,k),cost(p,k) * x.l(p,k));
         z_y=  sum((k_h,i,j,t,s)$arcs(i,j,t,s), travel_cost(k_h,i,j,t,s)* y.l(k_h,i,j,t,s));


         display z_x;
         display z_y;
         display x.l;
         display y_pickup;

         display subgradient_pie;
         display y.l
         display pie;

       put @3,n,@5,z_x,@10,z_y,@15,z_GAP.l,@30,z_routing.l,@45,z_lb,@60,zlbest /
);


         put /@1, 'N', @5, 'k', @10, 'i', @20, 'j',  @30, 't', @40, 's'/
         loop((K_H,T,S,I,J)$((y.l(k_h,i, j, t,s) gt 0)),put @1, n, @5, k_h.tl, @10, i.tl, @20, j.tl,  @30, t.tl, @40, s.tl/);

display y.l;


