* no fixed sensors, can't stop at intermediate nodes, no budget constraints

opCOINOS;

set k vehicle /1/;
set p passenger /1*3/;
set t time stamp /1*20/;
set i nodes /1*8/;
set i_source(i) source node /7/;
set i_sink(i) sink node /8/;

alias (i, j);
alias (t, s);

set w
/
0,
1,
2,
3,
1_2,
1_3,
2_3
/;


alias (w,wp);

parameter w_trans(w,wp) TRANSITION MATRIX/
0. 1 1
0. 2 2
0. 3 3
1. 0 -1
1. 1_2 2
1. 1_3 3
2. 0 -2
2. 1_2 1
2. 2_3 3
3. 0 -3
3. 1_3 1
3. 2_3 2
1_2. 1 -2
1_2. 2 -1
1_3. 1 -3
1_3. 3 -1
2_3. 2 -3
2_3. 3 -2
/;

w_trans(w,w) = 1;

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
/;

parameter arcs(i,j,t,s) link travel time ;
*traveling arcs from/to super source and sink
arcs(i_source,i,t,t)=1;
arcs(i,i_sink,t,t)=1;

*traveling arcs
arcs('1','2',t,t+2)=1;
arcs('2','1',t,t+2)=1;
arcs('1','3',t,t+2)=1;
arcs('3','1',t,t+2)=1;
arcs('3','4',t,t+2)=1;
arcs('4','3',t,t+2)=1;
arcs('2','4',t,t+2)=1;
arcs('4','2',t,t+2)=1;
arcs('1','5',t,t+1)=1;
arcs('2','5',t,t+1)=1;
arcs('5','6',t,t+1)=1;
arcs('6','3',t,t+1)=1;
arcs('6','4',t,t+1)=1;

* add ground holding arcs
arcs(i,i, t,t+1) = 1;

parameter trans_arc(i,j,t,s)  transportation link flag ;

trans_arc(i,j,t,s) =arcs(i,j,t,s)  ;

parameter travel_cost(k,i,j,t,s);
travel_cost(k,i,j,t,s)= 0.01;

parameter origin_node(k,i,t,w)  origin nodes and departure time;
origin_node(k,i_source,'1','0') = 1;

parameter destination_node(k,i,t,w);
destination_node(k,i_sink,'20','0') = 1;

parameter intermediate_node(k,i,t,w);
intermediate_node(k,i,t,w) = (1- origin_node(k,i,t,w))*(1- destination_node(k,i,t,w));

parameter p_origin(i,t)
/
1.5 1
1.10 2
1.15 3
/;

parameter p_destination(i,t)
/
4.17 -1
4.19 -2
4.18 -3
/;



parameter arcs_w(i,j,t,s,w,wp) link w transition ;

arcs_w(i,j,t,s,w,w) = arcs(i,j,t,s)*trans_arc(i,j,t,s);


*w_trans(w,wp) =e= (p_origin(p,i,t)or p_destination(p,i,t))

arcs_w(i,j,t,s,w,wp) $ ( arcs(i,j,t,s) and ( w_trans(w,wp) eq p_origin(i,t))) = w_trans(w,wp);

arcs_w(i,j,t,s,w,wp) $ ( arcs(i,j,t,s) and ( w_trans(w,wp) eq p_destination(j,s))) = w_trans(w,wp);


variable z;
binary variable y(k,i,j,t,s,w,wp)  vehicle k travels between i and j from time t to time s from w to wp;

equations
obj                                   define objective function

flow_on_node_origin(k,i,t,w)         origin node flow on node i at time t
flow_on_node_intermediate(k,i,t,w)   intermediate node flow on node i at time t
flow_on_node_destination(k,i,t,w)      destination node flow on node i at time t
;

obj.. z =e= sum((k,i,j,t,s,w,wp)$arcs_w(i,j,t,s,w,wp), travel_cost(k,i,j,t,s)* y(k,i,j,t,s,w,wp));
flow_on_node_origin(k,i,t,w)$(origin_node(k,i,t,w)).. sum((j,s,wp)$(arcs_w(i,j,t,s,w,wp)), y(k,i,j, t,s,w,wp)) =e= 1;
flow_on_node_destination(k,i,t,w)$(destination_node(k,i,t,w))..  sum((j,s,wp)$(arcs_w(j,i,s,t,w,wp)), y(k,j,i,s,t,w,wp))=e= 1;
flow_on_node_intermediate(k,i,t,w)$(intermediate_node(k,i,t,w)).. sum((j,s,wp)$(arcs_w(i,j,t,s,w,wp)), y(k,i,j,t,s,w,wp))-sum((j,s,wp)$(arcs_w(j,i,s,t,w,wp)), y(k,j,i,s,t,w,wp)) =e= 0;


Model customized_bueses_optimization /ALL/;


