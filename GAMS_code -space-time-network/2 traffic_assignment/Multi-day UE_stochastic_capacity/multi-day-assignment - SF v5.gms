$ title TDSP
*LIMROW = 0, LIMCOL = 0
*OPTIONS  MINLP = BARON;
OPTIONS  NLP = MINOS;

set i nodes /1*24/;
set k path set /1*15/;
set day day index /1*2/;
scalar day_size;
day_size = card(day);

set param  arc cost table headers / a, b, c /

alias(n,i,j,o,d);
alias(k,k2);
alias(day,day2);

parameters trip(n,n)    trip table;
* build network
parameter ca(i,i) FFTT/
1.2         6
2.6         5
3.12        4
4.11        6
5.9         5
7.8         3
8.9        10
9.10        3
10.15       6
10.17       8
11.14       4
13.24       4
14.23       4
15.22       4
16.18       3
18.20       4
20.21       6
21.22       2
22.23       4
1.3         4
3.4         4
4.5         2
5.6         4
6.8         2
7.18        2
8.16        5
10.11       5
10.16       5
11.12       6
12.13       3
14.15       5
15.19       4
16.17       2
17.19       2
19.20       4
20.22       5
21.24       3
23.24       2
/;
parameter ck(i,i) capacity in kvehperhour/
1.2       25.9002
2.6        4.9582
3.12      23.4035
4.11       4.9088
5.9       10.0000
7.8        7.8418
8.9        5.0502
9.10      13.9158
10.15     13.5120
10.17      4.9935
11.14      4.8765
13.24      5.0913
14.23      4.9248
15.22     10.3150
16.18     19.6799
18.20     23.4035
20.21      5.0599
21.22      5.2299
22.23      5.0000
1.3       23.4035
3.4       17.1105
4.5       17.7828
5.6        4.9480
6.8        4.8986
7.18      23.4035
8.16       5.0458
10.11     10.0000
10.16      5.1335
11.12      4.9088
12.13     25.9002
14.15      5.1275
15.19     15.6508
16.17      5.2299
17.19      4.8240
19.20      5.0026
20.22      5.0757
21.24      4.8854
23.24      5.0785
/;


parameter link_id(i,j) /
1.2        1
2.6        2
3.12        3
4.11        4
5.9        5
7.8        6
8.9        7
9.1        8
10.15        9
10.17        10
11.14        11
13.24        12
14.23        13
15.22        14
16.18        15
18.2        16
20.21        17
21.22        18
22.23        19
1.3        20
3.4        21
4.5        22
5.6        23
6.8        24
7.18        25
8.16        26
10.11        27
10.16        28
11.12        29
12.13        30
14.15        31
15.19        32
16.17        33
17.19        34
19.2        35
20.22        36
21.24        37
23.24        38
/;

ca(i,j) $= ca(j,i);
ck(i,j) $= ck(j,i);


*build OD matrix
table trip(i,j)  symmetric trip matrix from i to j
  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24
1 0  1  1  5  2  3  5  8  5 13  5  2  5  3  5  5  4  1  3  3  1  4  3  1
2    0  1  2  1  4  2  4  2  6  2  1  3  1  1  4  2  0  1  1  0  1  0  0
3       0  2  1  3  1  2  1  3  3  2  1  1  1  2  1  0  0  0  0  1  1  0
4          0  5  4  4  7  7 12 14  6  6  5  5  8  5  1  2  3  2  4  5  2
5             0  2  2  5  8 10  5  2  2  1  2  5  2  0  1  1  1  2  1  0
6                0  4  8  4  8  4  2  2  1  2  9  5  1  2  3  1  2  1  1
7                   0 10  6 19  5  7  4  2  5 14 10  2  4  5  2  5  2  1
8                      0  8 16  8  6  6  4  6 22 14  3  7  9  4  5  3  2
9                         0 28 14  6  6  6  9 14  9  2  4  6  3  7  5  2
10                           0 40 20 19 21 40 44 39  7 18 25 12 26 18  8
11                              0 14 10 16 14 14 10  1  4  6  4 11 13  6
12                                 0 13  7  7  7  6  2  3  4  3  7  7  5
13                                    0  6  7  6  5  1  3  6  6 13  8  8
14                                       0 13  7  7  1  3  5  4 12 11  4
15                                          0 12 15  2  8 11  8 26 10  4
16                                             0 28  5 13 16  6 12  5  3
17                                                0  6 17 17  6 17  6  3
18                                                   0  3  4  1  3  1  0
19                                                      0 12  4 12  3  1
20                                                         0 12 24  7  4
21                                                            0 18  7  5
22                                                               0 21 11
23                                                                  0  7
24                                                                     0 ;

trip(i,j) $= trip(j,i);

trip(i,j) = trip(i,j) *0.1;
* unit: K vehicles

parameter total_trip;

total_trip = sum((i,j),trip(i,j));

display total_trip;


parameter block_flag(i,j,k)/

8.9.1        1
10.17        .        2        1
1.2        .        3        1
4.11        .        4        1
10.15        .        5        1
20.21        .        6        1
11.12        .        7        1
2.6        .        8        1
5.9        .        9        1
8.16        .        10        1
10.11        .        11        1
10.16        .        12        1
14.15        .        13        1
20.22        .        14        1
3.12        .        15        1
/;

parameter val_k(k)/
1 1
2 2
3 3
4 4
5 5
6 6
7 7
8 8
9 9
10 10
11 11
12 12
13 13
14 14
15 15
/;

parameter ca_k(i,j,k);

ca_k(i,j,k) = ca(i,j);

ca_k(i,j,k)$(ca(i,j)>0.1 and block_flag(i,j,k)) = 999 ;

display ca_k;

*trip(i,j) = 0;

parameter path_link_proportion(o,d,k,i,j);

parameter origin(o,d,i);
parameter destination(o,d,i);



origin(o,d,o) =  1;
destination(o,d,d) = 1;

parameter intermediate(o,d,i);
intermediate(o,d,i)= (1- origin(o,d,i))* (1- destination(o,d,i));
* intermediat notes are not origin or destination


parameter cap_day_coef(day,i,j)/
1        .        8.9                0.3
2        .        10.17                0.3
/;

$ontext
3        .        1.2                0.3
4        .        4.11                0.3
5        .        10.15                0.3
6        .        20.21                0.3
7        .        11.12                0.3
8        .        2.6                0.3
9        .        5.9                0.3
10        .        8.16                0.3
$offtext

* set default to 1
cap_day_coef(day,i,j)$(cap_day_coef(day,i,j)<0.1) = 1;

variable z;
binary variables
x(o,d,k,i,j )  selection of OD pair path k between i and j;

equations
so_obj
flow_on_node_origin(o,d,k,i)         origin node flow of agent a on node i at time t
flow_on_node_intermediate(o,d,k,i)   intermediate node flow of agent a on node i at time t
flow_on_node_destination(o,d,k,i)      destination node flow of agent a on node i at time t
;

so_obj.. z =e= sum ((o,d,k)$trip(o,d),sum((i,j)$(ca(i,j)>0.1), x(o,d,k,i,j)*ca_k(i,j,k)));

flow_on_node_origin(o,d,k,i)$(trip(o,d) and origin(o,d,i)=1) .. sum((j)$(ca(i,j)>0.1), x(o,d,k,i,j))-sum((j)$(ca(j,i)>0.1), x(o,d,k,j,i)) =e= origin(o,d,i);
flow_on_node_destination(o,d,k,i)$(trip(o,d) and destination(o,d,i)=1) ..   sum((j)$(ca(i,j)>0.1), x(o,d,k,i,j))-sum((j)$(ca(j,i)>0.1), x(o,d,k,j,i)) =e= (-1)*destination(o,d,i);
flow_on_node_intermediate(o,d,k,i)$(trip(o,d) and intermediate(o,d,i)=1).. sum((j)$(ca(i,j)>0.1), x(o,d,k,i,j))-sum((j)$(ca(j,i)>0.1), x(o,d,k,j,i))=e= 0;


Model SP /so_obj,flow_on_node_origin,flow_on_node_intermediate,flow_on_node_destination/ ;
solve SP using MIP minimizing z;
display x.l;


parameter SPcost(o,d,k);

SPcost(o,d,k) = sum((i,j)$(ca(i,j)>0.1), x.l(o,d,k,i,j)*ca_k(i,j,k))

display SPcost;

path_link_proportion(o,d,k,i,j) = x.l(o,d,k,i,j);

parameter link_sum(o,d,k);

link_sum(o,d,k) = sum((i,j),path_link_proportion(o,d,k,i,j)*link_id(i,j));



parameter unique_path(o,d,k);

unique_path(o,d,k) = 1;

parameter unique_path_count(o,d,k);
unique_path_count(o,d,k) =1;

Loop ((o,d,k),

         Loop ( k2$(val_k(k2) > val_k(k)),
             unique_path(o,d,k2)$(unique_path_count(o,d,k2) <>0 ) = link_sum(o,d,k)- link_sum(o,d,k2);
* if this path has been marked as overlapping paths, no need to perform further comparision

                 unique_path_count(o,d,k2)$( abs(unique_path(o,d,k2)) <0.1) = 0;
* mark off same path
                 );


);
display  unique_path;



display unique_path_count;

parameter total_unique_path(o,d);
total_unique_path(o,d) = sum(k,unique_path_count(o,d,k));
display  total_unique_path;


parameter flow_balance;

flow_balance  = - x.l('1','2','3','1','3') + x.l('1','2','3','3','1')

      + x.l('1','2','3','3','4') + x.l('1','2','3','3','12') - x.l('1','2','3','4','3') - x.l('1','2','3','12','3');

display  flow_balance;


File output_x/link_path_prop.txt/;
put output_x;
put 'o, d, k, i, j' /;
loop((o,d,k,i,j)$(unique_path(o,d,k) <> 0 and ca(i,j) and(x.l(o,d,k,i,j) = 1)),put @5, o.tl, @10, d.tl, @15, k.tl,@20, i.tl,@25, j.tl, @40, unique_path(o,d,k)/);


*$ontext
*---------------------------traffic assignment problem------------------*
parameter PI_ratio_info;

PI_ratio_info = 0.1;

positive variables
v(day,i,j )  volume on day day between i and j;

positive variables
PI_path_flow(day,o,d,k )  volume on day day for path cl day o d k;
positive variables
EV_path_flow(o,d,k )  volume on day day for path cl day o d k;

positive variables
link_TT(day,i,j )  link travel time on link  on day day;
positive variables
path_TT(day,o,d,k )  path travel time on day day for path o d k
positive variables
Disutility_path_TT(o,d,k )  path travel time on day day for path o d k

positive variables
PI_shortest_path_TT(day,o,d)  shortest path travel time on day day for path o d k
EV_shortest_path_TT(o,d)  shortest path travel time on day day for path o d k

variable z_gap;
equations
ue_gap_obj
PI_path_flow_balance(day,o,d)     PI path flow balance
EV_path_flow_balance(o,d)     EV path flow balance

link_flow_balance(day,o,d)       link flow balance
link_travel_time_def(day,i,j)       path travel time defintion
path_travel_time_def(day,o,d,k)       path travel time defintion
PI_min_travel_time_def(day,o,d,k)       min path travel time defintion
EV_min_travel_time_def(o,d,k)       min path travel time defintion
Avg_path_def(o,d,k)                 avg travel time definitional
Avg_STD_path_def(o,d,k)                 avg travel time definitional
max_path_def(o,d,k,day)                max travel time definitional
;

ue_gap_obj.. z_gap =e= sum ((day,o,d,k)$( (trip(o,d)) and unique_path(o,d,k) <>0 ), PI_path_flow(day,o,d,k)*(path_TT(day,o,d,k )-PI_shortest_path_TT(day,o,d))) + sum ( (o,d,k)$(trip(o,d) and (unique_path(o,d,k) <>0) ), EV_path_flow(o,d,k)*(Disutility_path_TT(o,d,k )-EV_shortest_path_TT(o,d) ));

PI_path_flow_balance(day,o,d)$(trip(o,d)>0.001).. sum(k $( (unique_path(o,d,k) <>0)),PI_path_flow(day,o,d,k))=e= trip(o,d)*PI_ratio_info;
EV_path_flow_balance(o,d)$(trip(o,d)>0.001).. sum(k$((unique_path(o,d,k) <>0)),EV_path_flow(o,d,k))=e= trip(o,d)*(1-PI_ratio_info);

link_flow_balance(day,i,j)$(ca(i,j)>0.1).. v(day,i,j)=e= sum((o,d,k)$(trip(o,d)>0.001 and (unique_path(o,d,k) <>0) and path_link_proportion(o,d,k,i,j) >0.1), (PI_path_flow(day,o,d,k)+EV_path_flow(o,d,k))* path_link_proportion(o,d,k,i,j));
link_travel_time_def(day,i,j)$(ca(i,j)>0.1 and ck(i,j) >0.1).. link_TT(day,i,j)=e= ca(i,j) *(1 + 0.15*power( v(day,i,j)/(ck(i,j)*cap_day_coef(day,i,j)),4));
path_travel_time_def(day,o,d,k)$(unique_path(o,d,k) <>0)..  path_TT(day,o,d,k ) =e=  sum((i,j)$ ((ca(i,j)>0.1) and path_link_proportion(o,d,k,i,j)),  link_TT(day,i,j)* path_link_proportion(o,d,k,i,j));
PI_min_travel_time_def(day,o,d,k)$(unique_path(o,d,k) <>0).. path_TT(day,o,d,k ) =g=  PI_shortest_path_TT(day,o,d);
EV_min_travel_time_def(o,d,k)$(unique_path(o,d,k) <>0).. Disutility_path_TT(o,d,k ) =g=  EV_shortest_path_TT(o,d);
Avg_path_def(o,d,k).. Disutility_path_TT(o,d,k )$(unique_path(o,d,k) <>0) =e=  sum(day,path_TT(day,o,d,k ))/day_size;
Avg_STD_path_def(o,d,k).. Disutility_path_TT(o,d,k )$(unique_path(o,d,k) <>0) =e=  sum(day,path_TT(day,o,d,k ))/day_size + 1.27*sqrt((sum(day, power(path_TT(day,o,d,k )- sum(day2,path_TT(day2,o,d,k ))/day_size,2))/day_size));
max_path_def(o,d,k,day).. Disutility_path_TT(o,d,k )$(unique_path(o,d,k) <>0) =g=  path_TT(day,o,d,k );

Model MD_TAP /ue_gap_obj,PI_path_flow_balance,EV_path_flow_balance ,link_flow_balance,link_travel_time_def,path_travel_time_def,PI_min_travel_time_def,EV_min_travel_time_def,Avg_path_def/ ;
Model MD_STD_TAP /ue_gap_obj,PI_path_flow_balance,EV_path_flow_balance ,link_flow_balance,link_travel_time_def,path_travel_time_def,PI_min_travel_time_def,EV_min_travel_time_def,Avg_STD_path_def/ ;
Model MD_Robust_TAP /ue_gap_obj,PI_path_flow_balance,EV_path_flow_balance ,link_flow_balance,link_travel_time_def,path_travel_time_def,PI_min_travel_time_def,EV_min_travel_time_def,max_path_def/ ;

solve MD_Robust_TAP using NLP minimizing z_gap;

display z_gap.l, Disutility_path_TT.l, EV_shortest_path_TT.l;

parameter vc_ratio(day,i,j);

vc_ratio(day, i,j)$(ck(i,j)>0.1) = v.l(day,i,j)/ck(i,j);
File output_VC/VC.txt/;
put output_VC;
put 'day, i, j, ratio' /;
loop((day, i,j)$(ck(i,j)>0/1),put @5, day.tl, @10, i.tl, @15, j.tl, @20, vc_ratio(day, i,j) /);

parameter avg_path_time_PI(day,o,d);
parameter avg_path_time_ETT(day,o,d);

avg_path_time_PI(day,o,d) =   sum ((k)$trip(o,d), PI_path_flow.l(day,o,d,k)*path_TT.l(day,o,d,k )) /  sum(k,PI_path_flow.l(day,o,d,k));
avg_path_time_ETT(day,o,d)=   sum ((k)$trip(o,d), EV_path_flow.l(o,d,k)*path_TT.l(day,o,d,k )) /  sum(k,EV_path_flow.l(o,d,k));
parameter PI_info_saving(day,o,d);
PI_info_saving(day,o,d) = (1-avg_path_time_PI(day,o,d)/avg_path_time_ETT(day,o,d))*100

parameter PI_info_saving_total;
PI_info_saving_total = sum((day,o,d), PI_info_saving(day,o,d));

parameter PI_info_saving_total;
pI_info_saving_total = sum((day,o,d), PI_info_saving(day,o,d));


File output_ODTT/ODTT.txt/;
put output_ODTT;
put 'day, o, d,PITT,ETT_TT, saving' /;
loop((day, o,d)$( trip(o,d)),put @5, day.tl, @10, o.tl, @15, d.tl, @20, avg_path_time_PI(day, o,d), @40,avg_path_time_ETT(day,o,d),@60,PI_info_saving(day,o,d)/);


File output_path_flow/path_TT.txt/;
put output_path_flow;
put 'o      d     k    day    path flow ETT, path flow PI, path tt, PI shortest path, Avg_path_TT, EV shortest path' /;
loop((day,o,d,k)$(( (PI_path_flow.l(day,o,d,k)+EV_path_flow.l(o,d,k)) > 1)),put @5, o.tl, @10, d.tl, @20,  k.tl, @25, day.tl, @30, EV_path_flow.l(o,d,k), @40, PI_path_flow.l(day,o,d,k) ,@55, path_TT.l(day,o,d,k),@70, PI_shortest_path_TT.l(day,o,d), @85, Disutility_path_TT.l(o,d,k), @100, EV_shortest_path_TT.l(o,d)/);
*$offtext
