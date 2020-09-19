$title Customzed shuttle services
OPTIONS mip = CPLEX;
$ontext
By
    Lu Tong,
    Xuesong Zhou,
    Jiangtao Liu
                              9/20,2016
$offtext

set k bus /1*4/;
set k_h(k) physical bus /1*3/;
set k_r(k) virtual bus /4/;
set i nodes /1*25/;
set depot(i) destination depots /7,8,18/;
set t time stamp /1*60/;
set p passenger /1*21/;
set p_h(p) physical passenger /1*20/;
set p_r(p) virtual passenger /21/;

alias (i, j);
alias (t, s);



parameter phi_o(p_h,i,t) passenger pick-up region /
1. 3. 7   1,        1. 3. 8   1,        1. 3. 9   1,        1. 3. 10   1,        1. 3. 11   1,        1. 3. 12   1,        1. 3. 13   1,        1. 3. 14   1,        1. 3. 15   1
2. 3. 10   1,        2. 3. 11   1,        2. 3. 12   1,        2. 3. 13   1,        2. 3. 14   1,        2. 3. 15   1,        2. 3. 16   1,        2. 3. 17   1,        2. 3. 18   1
3. 4. 11   1,        3. 4. 12   1,        3. 4. 13   1,        3. 4. 14   1,        3. 4. 15   1,        3. 4. 16   1,        3. 4. 17   1,        3. 4. 18   1,        3. 4. 19   1
4. 4. 16   1,        4. 4. 17   1,        4. 4. 18   1,        4. 4. 19   1,        4. 4. 20   1,        4. 4. 21   1,        4. 4. 22   1,        4. 4. 23   1,        4. 4. 24   1
4. 5. 16   1,        4. 5. 17   1,        4. 5. 18   1,        4. 5. 19   1,        4. 5. 20   1,        4. 5. 21   1,        4. 5. 22   1,        4. 5. 23   1,        4. 5. 24   1
5. 5. 11   1,        5. 5. 12   1,        5. 5. 13   1,        5. 5. 14   1,        5. 5. 15   1,        5. 5. 16   1,        5. 5. 17   1,        5. 5. 18   1,        5. 5. 19   1
6. 11. 8   1,        6. 11. 9   1,        6. 11. 10   1,        6. 11. 11   1,        6. 11. 12   1,        6. 11. 13   1,        6. 11. 14   1,        6. 11. 15   1,        6. 11. 16   1
7. 12. 3   1,        7. 12. 4   1,        7. 12. 5   1,        7. 12. 6   1,        7. 12. 7   1,        7. 12. 8   1,        7. 12. 9   1,        7. 12. 10   1,        7. 12. 11   1
8. 12. 6   1,        8. 12. 7   1,        8. 12. 8   1,        8. 12. 9   1,        8. 12. 10   1,        8. 12. 11   1,        8. 12. 12   1,        8. 12. 13   1,        8. 12. 14   1
9. 12. 33   1,        9. 12. 34   1,        9. 12. 35   1,        9. 12. 36   1,        9. 12. 37   1,        9. 12. 38   1,        9. 12. 39   1,        9. 12. 54   1,        9. 12. 55   1
10. 20. 46   1,        10. 20. 47   1,        10. 20. 48   1,        10. 20. 49   1,        10. 20. 50   1,        10. 20. 51   1,        10. 20. 52   1,        10. 20. 53   1,        10. 20. 54   1
11. 20. 46   1,        11. 20. 47   1,        11. 20. 48   1,        11. 20. 49   1,        11. 20. 50   1,        11. 20. 51   1,        11. 20. 52   1,        11. 20. 53   1,        11. 20. 54   1
12. 20. 48   1,        12. 20. 49   1,        12. 20. 50   1,        12. 20. 51   1,        12. 20. 52   1,        12. 20. 53   1,        12. 20. 54   1,        12. 20. 55   1,        12. 20. 56   1
13. 20. 48   1,        13. 20. 49   1,        13. 20. 50   1,        13. 20. 51   1,        13. 20. 52   1,        13. 20. 53   1,        13. 20. 54   1,        13. 20. 55   1,        13. 20. 56   1
14. 21. 40   1,        14. 21. 41   1,        14. 21. 42   1,        14. 21. 43   1,        14. 21. 44   1,        14. 21. 45   1,        14. 21. 46   1,        14. 21. 47   1,        14. 21. 48   1
15. 21. 41   1,        15. 21. 42   1,        15. 21. 43   1,        15. 21. 44   1,        15. 21. 45   1,        15. 21. 46   1,        15. 21. 47   1,        15. 21. 48   1,        15. 21. 49   1
15. 22. 41   1,        15. 22. 42   1,        15. 22. 43   1,        15. 22. 44   1,        15. 22. 45   1,        15. 22. 46   1,        15. 22. 47   1,        15. 22. 48   1,        15. 22. 49   1
16. 22. 35   1,        16. 22. 36   1,        16. 22. 37   1,        16. 22. 38   1,        16. 22. 39   1,        16. 22. 40   1,        16. 22. 41   1,        16. 22. 42   1,        16. 22. 43   1
17. 23. 37   1,        17. 23. 38   1,        17. 23. 39   1,        17. 23. 40   1,        17. 23. 41   1,        17. 23. 42   1,        17. 23. 43   1,        17. 23. 44   1,        17. 23. 45   1
18. 23. 39   1,        18. 23. 40   1,        18. 23. 41   1,        18. 23. 42   1,        18. 23. 43   1,        18. 23. 44   1,        18. 23. 45   1,        18. 23. 46   1,        18. 23. 47   1
19. 23. 37   1,        19. 23. 38   1,        19. 23. 39   1,        19. 23. 40   1,        19. 23. 41   1,        19. 23. 42   1,        19. 23. 43   1,        19. 23. 44   1,        19. 23. 45   1
19. 24. 37   1,        19. 24. 38   1,        19. 24. 39   1,        19. 24. 40   1,        19. 24. 41   1,        19. 24. 42   1,        19. 24. 43   1,        19. 24. 44   1,        19. 24. 45   1
20. 24. 39   1,        20. 24. 40   1,        20. 24. 41   1,        20. 24. 42   1,        20. 24. 43   1,        20. 24. 44   1,        20. 24. 45   1,        20. 24. 46   1,        20. 24. 47   1
/;


parameter phi_d(p_h,i,t) passenger delivery region /
1. 7. 22   1,        1. 7. 23   1,        1. 7. 24   1,        1. 7. 25   1,        1. 7. 26   1,        1. 7. 27   1,        1. 7. 28   1,        1. 7. 29   1,        1. 7. 30   1
2. 8. 22   1,        2. 8. 23   1,        2. 8. 24   1,        2. 8. 25   1,        2. 8. 26   1,        2. 8. 27   1,        2. 8. 28   1,        2. 8. 29   1,        2. 8. 30   1
3. 7. 22   1,        3. 7. 23   1,        3. 7. 24   1,        3. 7. 25   1,        3. 7. 26   1,        3. 7. 27   1,        3. 7. 28   1,        3. 7. 29   1,        3. 7. 30   1
4. 8. 22   1,        4. 8. 23   1,        4. 8. 24   1,        4. 8. 25   1,        4. 8. 26   1,        4. 8. 27   1,        4. 8. 28   1,        4. 8. 29   1,        4. 8. 30   1
5. 18. 22   1,        5. 18. 23   1,        5. 18. 24   1,        5. 18. 25   1,        5. 18. 26   1,        5. 18. 27   1,        5. 18. 28   1,        5. 18. 29   1,        5. 18. 30   1
6. 8. 22   1,        6. 8. 23   1,        6. 8. 24   1,        6. 8. 25   1,        6. 8. 26   1,        6. 8. 27   1,        6. 8. 28   1,        6. 8. 29   1,        6. 8. 30   1
7. 7. 22   1,        7. 7. 23   1,        7. 7. 24   1,        7. 7. 25   1,        7. 7. 26   1,        7. 7. 27   1,        7. 7. 28   1,        7. 7. 29   1,        7. 7. 30   1
8. 8. 22   1,        8. 8. 23   1,        8. 8. 24   1,        8. 8. 25   1,        8. 8. 26   1,        8. 8. 27   1,        8. 8. 28   1,        8. 8. 29   1,        8. 8. 30   1
9. 7. 52   1,        9. 7. 53   1,        9. 7. 54   1,        9. 7. 55   1,        9. 7. 56   1,        9. 7. 57   1,        9. 7. 58   1,        9. 7. 59   1,        9. 7. 60   1
10. 7. 52   1,        10. 7. 53   1,        10. 7. 54   1,        10. 7. 55   1,        10. 7. 56   1,        10. 7. 57   1,        10. 7. 58   1,        10. 7. 59   1,        10. 7. 60   1
11. 7. 52   1,        11. 7. 53   1,        11. 7. 54   1,        11. 7. 55   1,        11. 7. 56   1,        11. 7. 57   1,        11. 7. 58   1,        11. 7. 59   1,        11. 7. 60   1
12. 18. 52   1,        12. 18. 53   1,        12. 18. 54   1,        12. 18. 55   1,        12. 18. 56   1,        12. 18. 57   1,        12. 18. 58   1,        12. 18. 59   1,        12. 18. 60   1
13. 18. 52   1,        13. 18. 53   1,        13. 18. 54   1,        13. 18. 55   1,        13. 18. 56   1,        13. 18. 57   1,        13. 18. 58   1,        13. 18. 59   1,        13. 18. 60   1
14. 7. 52   1,        14. 7. 53   1,        14. 7. 54   1,        14. 7. 55   1,        14. 7. 56   1,        14. 7. 57   1,        14. 7. 58   1,        14. 7. 59   1,        14. 7. 60   1
15. 7. 52   1,        15. 7. 53   1,        15. 7. 54   1,        15. 7. 55   1,        15. 7. 56   1,        15. 7. 57   1,        15. 7. 58   1,        15. 7. 59   1,        15. 7. 60   1
16. 8. 49   1,        16. 8. 50   1,        16. 8. 51   1,        16. 8. 52   1,        16. 8. 53   1,        16. 8. 54   1,        16. 8. 55   1,        16. 8. 56   1,        16. 8. 57   1
17. 7. 52   1,        17. 7. 53   1,        17. 7. 54   1,        17. 7. 55   1,        17. 7. 56   1,        17. 7. 57   1,        17. 7. 58   1,        17. 7. 59   1,        17. 7. 60   1
18. 18. 52   1,        18. 18. 53   1,        18. 18. 54   1,        18. 18. 55   1,        18. 18. 56   1,        18. 18. 57   1,        18. 18. 58   1,        18. 18. 59   1,        18. 18. 60   1
19. 7. 52   1,        19. 7. 53   1,        19. 7. 54   1,        19. 7. 55   1,        19. 7. 56   1,        19. 7. 57   1,        19. 7. 58   1,        19. 7. 59   1,        19. 7. 60   1
20. 18. 52   1,        20. 18. 53   1,        20. 18. 54   1,        20. 18. 55   1,        20. 18. 56   1,        20. 18. 57   1,        20. 18. 58   1,        20. 18. 59   1,        20. 18. 60   1
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
travel_cost(k_h,'1','1',t,t+1)= 0;
travel_cost(k_h,'2','2',t,t+1)= 0;
travel_cost(k_h,'13','13',t,t+1)= 0;
travel_cost(k_h,'25','25',t,t+1)= 0;


parameter origin_node(k_h,i,t)  origin nodes and departure time;
origin_node('1','1','1') = 1;
origin_node('2','2','1') = 1;
origin_node('3','13','35') = 1;

parameter destination_node(k_h,i,t);
destination_node('1','25','30') = 1;
destination_node('2','25','60') = 1;
destination_node('3','25','60') = 1;

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
obj                                   define objective function
obj_GAP                                   define objective function
obj_routing                                   define objective function
passenger_assignment(p)               passenger p assigned to bus k
pick_up_condition(p,k)              passenger pick-up region
delivery_condition(p,k)             passenger delivery region
low_capacity_constraint(k_h)            min load factor
high_capacity_constraint(k_h)           max load factor

flow_on_node_origin(k,i,t)         origin node flow on node i at time t
flow_on_node_intermediate(k,i,t)   intermediate node flow on node i at time t
flow_on_node_destination(k,i,t)      destination node flow on node i at time t
;

obj.. z =e= sum((p,k),cost(p,k) * x(p,k)) + sum((k_h,i,j,t,s)$arcs(i,j,t,s), travel_cost(k_h,i,j,t,s)* y(k_h,i,j,t,s));
obj_GAP.. z_GAP =e= sum((p,k),cost(p,k) * x(p,k)) +  sum((p_h,k_h),pie(p_h,k_h) * x(p_h,k_h));
obj_routing.. z_routing =e= sum((k_h,i,j,t,s)$arcs(i,j,t,s), (travel_cost(k_h,i,j,t,s)- sum(p_h$phi_o(p_h,i,t),pie(p_h,k_h))) * y(k_h,i,j,t,s));

passenger_assignment(p_h).. sum(k, x(p_h,k)) =e= 1;
pick_up_condition(p_h,k_h).. x(p_h,k_h) =l= sum((i,j,t,s)$ (phi_o(p_h,i,t) and arcs(i,j,t,s)), y(k_h,i,j,t,s));
delivery_condition(p_h,k_h).. x(p_h,k_h) =l= sum((i,j,t,s)$ (phi_d(p_h,j,s) and arcs(i,j,t,s)), y(k_h,i,j,t,s));
low_capacity_constraint(k_h).. load_factor(k_h) =l= sum(p, ass_cap(p,k_h) * x(p,k_h));
high_capacity_constraint(k_h).. sum(p,ass_cap(p,k_h) * x(p,k_h)) =l= capacity(k_h);
flow_on_node_origin(k_h,i,t)$(origin_node(k_h,i,t)).. sum((j,s)$(arcs(i,j,t,s)), y(k_h,i,j, t,s)) =e= 1;
flow_on_node_destination(k_h,i,t)$(destination_node(k_h,i,t))..  sum((j,s)$(arcs(j,i,s,t)), y(k_h,j,i,s,t))=e= 1;
flow_on_node_intermediate(k_h,i,t)$(intermediate_node(k_h,i,t)).. sum((j,s)$(arcs(i,j,t,s)), y(k_h,i,j,t,s))-sum((j,s)$(arcs(j,i,s,t)), y(k_h,j,i,s,t)) =e= 0;


Model customized_bueses_optimization /ALL/;
Model customized_bueses_GAP /obj_GAP, passenger_assignment,low_capacity_constraint,high_capacity_constraint/;
Model customized_bueses_routing /obj_routing,flow_on_node_origin,flow_on_node_destination,flow_on_node_intermediate/;


solve customized_bueses_optimization using MIP minimizing z ;

display x.l;
display y.l;
display z.l;

file output_y; put output_y;
loop((K_H,T,S,I,J)$((y.l(k_h,i, j, t,s) gt 0)),put @5, k_h.tl, @10, i.tl, @20, j.tl,  @30, t.tl, @40, s.tl/);
putclose output_y;
