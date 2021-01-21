$title Flight optimization Problem
*LIMROW = 0, LIMCOL = 0
OPTIONS  ITERLIM=100000, RESLIM = 1000000, SYSOUT = OFF, SOLPRINT = OFF, lp = COINGLPK, mip = COINGLPK, OPTCR= 0.1;

set f flight/1*144/;
set u airline /1*4/;
set k scenario /1*2/

set i nodes /1*18/;
set t time stamp /1*20/;


parameter first_stage(t)/
1                1
/;

parameter threshold;

threshold = 8;

parameter fu(u);
fu('1') = 57;
fu('2') = 43;
fu('3') = 29;
fu('4') = 14;

parameter fui(u,f)/
1        .        1                1
1        .        2                1
1        .        3                1
1        .        4                1
1        .        5                1
1        .        6                1
1        .        7                1
1        .        8                1
1        .        9                1
1        .        10                1
1        .        11                1
1        .        12                1
1        .        13                1
1        .        14                1
1        .        15                1
1        .        16                1
1        .        17                1
1        .        18                1
1        .        19                1
1        .        20                1
1        .        21                1
1        .        22                1
1        .        23                1
1        .        24                1
1        .        25                1
1        .        26                1
1        .        27                1
1        .        28                1
1        .        29                1
1        .        30                1
1        .        31                1
1        .        32                1
1        .        33                1
1        .        34                1
1        .        35                1
1        .        36                1
1        .        37                1
1        .        38                1
1        .        39                1
1        .        40                1
1        .        41                1
1        .        42                1
1        .        43                1
1        .        44                1
1        .        45                1
1        .        46                1
1        .        47                1
1        .        48                1
1        .        49                1
1        .        50                1
1        .        51                1
1        .        52                1
1        .        53                1
1        .        54                1
1        .        55                1
1        .        56                1
1        .        57                1
1        .        58                1
2        .        59                1
2        .        60                1
2        .        61                1
2        .        62                1
2        .        63                1
2        .        64                1
2        .        65                1
2        .        66                1
2        .        67                1
2        .        68                1
2        .        69                1
2        .        70                1
2        .        71                1
2        .        72                1
2        .        73                1
2        .        74                1
2        .        75                1
2        .        76                1
2        .        77                1
2        .        78                1
2        .        79                1
2        .        80                1
2        .        81                1
2        .        82                1
2        .        83                1
2        .        84                1
2        .        85                1
2        .        86                1
2        .        87                1
2        .        88                1
2        .        89                1
2        .        90                1
2        .        91                1
2        .        92                1
2        .        93                1
2        .        94                1
2        .        95                1
2        .        96                1
2        .        97                1
2        .        98                1
2        .        99                1
2        .        100                1
2        .        101                1
2        .        102                1
3        .        103                1
3        .        104                1
3        .        105                1
3        .        106                1
3        .        107                1
3        .        108                1
3        .        109                1
3        .        110                1
3        .        111                1
3        .        112                1
3        .        113                1
3        .        114                1
3        .        115                1
3        .        116                1
3        .        117                1
3        .        118                1
3        .        119                1
3        .        120                1
3        .        121                1
3        .        122                1
3        .        123                1
3        .        124                1
3        .        125                1
3        .        126                1
3        .        127                1
3        .        128                1
3        .        129                1
3        .        130                1
3        .        131                1
4        .        132                1
4        .        133                1
4        .        134                1
4        .        135                1
4        .        136                1
4        .        137                1
4        .        138                1
4        .        139                1
4        .        140                1
4        .        141                1
4        .        142                1
4        .        143                1
4        .        144                1
/;


alias (i, j);
alias (u, v);

alias (t, s, t_e, t_l);

**t_e: entering time, t_l: leaving time

$include "C:\\GAMS\airspace_data.csv"

parameter origin(f,i,t)  origin nodes and departure time/
1        .        1        .        1        1
2        .        1        .        1        1
3        .        1        .        1        1
4        .        1        .        2        1
5        .        1        .        2        1
6        .        1        .        2        1
7        .        1        .        3        1
8        .        1        .        3        1
9        .        1        .        3        1
10        .        1        .        4        1
11        .        1        .        4        1
12        .        1        .        4        1
13        .        1        .        5        1
14        .        1        .        5        1
15        .        1        .        5        1
16        .        12        .        1        1
17        .        12        .        1        1
18        .        12        .        1        1
19        .        12        .        2        1
20        .        12        .        2        1
21        .        12        .        2        1
22        .        12        .        3        1
23        .        12        .        3        1
24        .        12        .        3        1
25        .        12        .        4        1
26        .        12        .        4        1
27        .        12        .        4        1
28        .        12        .        5        1
29        .        12        .        5        1
30        .        12        .        5        1
31        .        12        .        6        1
32        .        12        .        6        1
33        .        12        .        6        1
34        .        12        .        7        1
35        .        12        .        7        1
36        .        12        .        7        1
37        .        5        .        1        1
38        .        5        .        1        1
39        .        5        .        1        1
40        .        5        .        2        1
41        .        5        .        2        1
42        .        5        .        2        1
43        .        5        .        3        1
44        .        5        .        3        1
45        .        5        .        3        1
46        .        5        .        4        1
47        .        5        .        4        1
48        .        5        .        4        1
49        .        5        .        5        1
50        .        5        .        5        1
51        .        5        .        5        1
52        .        8        .        1        1
53        .        8        .        1        1
54        .        8        .        1        1
55        .        8        .        2        1
56        .        8        .        2        1
57        .        8        .        2        1
58        .        8        .        3        1
59        .        8        .        3        1
60        .        8        .        3        1
61        .        8        .        4        1
62        .        8        .        4        1
63        .        8        .        4        1
64        .        8        .        5        1
65        .        8        .        5        1
66        .        8        .        5        1
67        .        8        .        6        1
68        .        8        .        6        1
69        .        8        .        6        1
70        .        8        .        7        1
71        .        8        .        7        1
72        .        8        .        7        1
73        .        1        .        1        1
74        .        1        .        1        1
75        .        1        .        1        1
76        .        1        .        2        1
77        .        1        .        2        1
78        .        1        .        2        1
79        .        1        .        3        1
80        .        1        .        3        1
81        .        1        .        3        1
82        .        1        .        4        1
83        .        1        .        4        1
84        .        1        .        4        1
85        .        1        .        5        1
86        .        1        .        5        1
87        .        1        .        5        1
88        .        12        .        1        1
89        .        12        .        1        1
90        .        12        .        1        1
91        .        12        .        2        1
92        .        12        .        2        1
93        .        12        .        2        1
94        .        12        .        3        1
95        .        12        .        3        1
96        .        12        .        3        1
97        .        12        .        4        1
98        .        12        .        4        1
99        .        12        .        4        1
100        .        12        .        5        1
101        .        12        .        5        1
102        .        12        .        5        1
103        .        12        .        6        1
104        .        12        .        6        1
105        .        12        .        6        1
106        .        12        .        7        1
107        .        12        .        7        1
108        .        12        .        7        1
109        .        5        .        1        1
110        .        5        .        1        1
111        .        5        .        1        1
112        .        5        .        2        1
113        .        5        .        2        1
114        .        5        .        2        1
115        .        5        .        3        1
116        .        5        .        3        1
117        .        5        .        3        1
118        .        5        .        4        1
119        .        5        .        4        1
120        .        5        .        4        1
121        .        5        .        5        1
122        .        5        .        5        1
123        .        5        .        5        1
124        .        8        .        1        1
125        .        8        .        1        1
126        .        8        .        1        1
127        .        8        .        2        1
128        .        8        .        2        1
129        .        8        .        2        1
130        .        8        .        3        1
131        .        8        .        3        1
132        .        8        .        3        1
133        .        8        .        4        1
134        .        8        .        4        1
135        .        8        .        4        1
136        .        8        .        5        1
137        .        8        .        5        1
138        .        8        .        5        1
139        .        8        .        6        1
140        .        8        .        6        1
141        .        8        .        6        1
142        .        8        .        7        1
143        .        8        .        7        1
144        .        8        .        7        1

/;


* add ground holding waiting arcs

arcs('1','1', t,t+1) = 0.5;
arcs('12','12', t,t+1) = 0.5;
arcs('5','5', t,t+1) = 0.5;
arcs('8','8', t,t+1) = 0.5;
* add destination waiting arcs
arcs('4','4', t,t+1) = 0.005;

TDcapacity('4','4',t) = 1000;

parameter TD_Kcapacity(i,j,t,k);

TD_Kcapacity (i,j,t,k) = 2*TDcapacity(i,j,t);

TD_Kcapacity('3','4',t,'1') = 6;
TD_Kcapacity('6','4',t,'1') = 6;

parameter destination_node(f,i,t);
destination_node(f,'4','20') = 1;


parameter intermediate(f,i,t);

intermediate(f,i,t) = (1- origin(f,i,t))* (1- destination_node(f,i,t));

parameter w(i,j,t,s,k);

w(i,j,t,s,k) = 0;

parameter w_u(u);

w_u(u)= 0;

parameter w_nac(f,i,j,t,s,k);
w_nac(f,i,j,t,s,k)$(arcs(i,j,t,s)) = 0;

variable z;
binary variables
    x(f,k,i, j, t, s)  selection flight f scenario k between i and j from time t to time s;

equations
obj                              define objective function
obj_LR                              LR objective function
flow_on_node_origin(f,i,t,k)         origin node flow on node i at time t
flow_on_node_intermediate(f,i,t,k)   intermediate node flow on node i at time t
flow_on_node_destination(f,i,t,k)      destination node flow on node i at time t
link_capacity(i,j,t,s,k)                    capacity constraint
airline_equity(u)                  airline equity constaints
NAC (f,i,j,t,s,k)                       NAC constraint
;


obj.. z =e= sum((f,k,i,j, t,s)$(arcs(i,j,t,s)), arcs(i,j,t,s)*x(f,k,i, j, t, s));

obj_LR.. z =e= sum((f,k,i,j, t,s)$(arcs(i,j,t,s)), arcs(i,j,t,s)*x(f,k,i, j, t, s)) + sum((i,j,t,s,k)$(arcs(i,j,t,s)),w(i,j,t,s,k)*(sum(f, x(f,k,i,j,t,s)) - TDcapacity(i,j,t))) + sum(u,w_u(u)*(sum((f,k,i,j, t,s)$(arcs(i,j,t,s)), fui(u,f)*arcs(i,j,t,s)*x(f,k,i, j, t, s)) -threshold)) + sum((f,i,j,t,s,k),w_nac(f,i,j,t,s,k)*(x(f,k,i,j,t,s) - x(f,'1',i,j,t,s)));

flow_on_node_origin(f,i,t,k)$(origin(f,i,t)).. sum((j,s)$(arcs(i,j,t,s)), x(f,k,i,j, t,s)) =e= 1;
flow_on_node_destination(f,i,t,k)$(destination_node(f,i,t))..  sum((j,s)$(arcs(j,i,s,t)), x(f,k,j,i,s,t))=e= 1;
flow_on_node_intermediate(f,i,t,k)$(intermediate(f,i,t)).. sum((j,s)$(arcs(i,j,t,s)), x(f,k,i, j, t,s))-sum((j,s)$(arcs(j,i,s,t)), x(f,k,j,i,s,t))=e= 0;

link_capacity(i,j,t,s,k)$(arcs(i,j,t,s)).. sum(f, x(f,k,i,j,t,s)) - TD_Kcapacity(i,j,t,k) =l=0;
airline_equity(u) .. sum((f,k,i,j,t,s)$(arcs(i,j,t,s)), fui(u,f)*arcs(i,j,t,s)*x(f,k,i, j, t, s)/fu(u)) - threshold =l=0;
NAC(f,i,j,t,s,k)$(arcs(i,j,t,s)*first_stage(t)).. x(f,k,i,j,t,s) =e= x(f,'1',i,j,t,s);

Model flight_optimization_LR /obj_LR, flow_on_node_origin, flow_on_node_intermediate, flow_on_node_destination,link_capacity,NAC/;

Model flight_optimization /obj, flow_on_node_origin, flow_on_node_intermediate, flow_on_node_destination,airline_equity,NAC/;

solve flight_optimization using MIP minimizing z;

display x.l;
display z.l, z.l;

parameter mean_cost;
mean_cost = z.l;
mean_cost = mean_cost/144;

display  mean_cost;

parameter airline_cost(u);
airline_cost(u) =   sum((f,k,i,j,t,s)$(arcs(i,j,t,s)), fui(u,f)*arcs(i,j,t,s)*x.l(f,k,i, j, t, s)/fu(u));

display airline_cost;



scalar z_optimal;
z_optimal = z.l;

scalars target target objective function value
        alpha  step adjuster / 1 /
        norm   norm of slacks
        step   step size for subgradient / na /
        zfeas  value for best known solution or valid upper bound
        zlr    Lagrangian objective value
        zl     Lagrangian objective value
        zlbest current best Lagrangian lower bound
        count  count of iterations without improvement
        reset  reset count counter / 5 /
        tol    termination tolerance / 1e-5 /
        status outer loop status /0/
        improv ;


sets  iter   subgradient iteration index / iter1 * iter20  /;

parameters   report(iter,*)   iteration log

parameter subgradient(i,j,t,s,k);

parameter subgradient_u(u);

parameter subgradient_nac(f,k,i,j,t,s);

zlbest = 0;
status = 0;

loop(iter,

*  solve Lagrangian subproblems by solving LR

    solve flight_optimization_LR using MIP minimizing z;

   zl = z.l;
   improv = 0;
   improv$(zl > zlbest) = 1;
   zlbest = max(zlbest,zl);

   subgradient(i,j,t,s,k)   = sum(f, x.l(f,k,i,j,t,s)) - TD_Kcapacity(i,j,t,k);
   subgradient_u(u) = sum((f,k,i,j, t,s)$(arcs(i,j,t,s)), fui(u,f)*arcs(i,j,t,s)*x.l(f,k,i, j, t, s))/fu(u) -threshold;
   subgradient_nac(f,k,i,j,t,s) = x.l(f,k,i,j,t,s) - x.l(f,'1',i,j,t,s);

   report(iter,'zl')     = zl;
   report(iter,'zlbest') = zlbest;
   report(iter,'gap') = (z_optimal - zl);
   report(iter,'step')   = step;


      step   = 0.2;
      w(i,j,t,s,k)$(arcs(i,j,t,s))   = max(0,w(i,j,t,s,k)+ step* subgradient(i,j,t,s,k));
      w_u(u) = max(0, w_u(u) + step*subgradient_u(u));
      w_nac(f,i,j,t,s,k)$(arcs(i,j,t,s)) = w_nac(f,i,j,t,s,k) + step*subgradient_nac(f,k,i,j,t,s);

);
display z_optimal;
display  report;
display x.l;

















