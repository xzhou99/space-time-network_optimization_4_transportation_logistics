$title household scheduling problem
OPTIONS mip = CPLEX;

set i nodes /1*13/;
set t time stamp /1*170/;
set k time_winow_node /1*8/
set w state /1*8/;
set a mandatory activity /1*1/;

alias (i, j);
alias (t, s);
alias (w,wp);

*------------------------------------------------------------------------------------------------------------
*conncet time window nodes with the real nodes in the network based on given time window values
parameter win(t,k) time window index /
1.1 1
2.1 1
3.1 1
15.2 10
16.2 10
114.3 11
115.3 11
28.4 12
29.4 12
30.4 12
127.5 13
128.5 13
129.5 13
130.5 13
131.5 13
132.5 13
133.5 13
134.5 13
135.5 13
136.5 13
137.5 13
138.5 13
139.5 13
127.6 8
128.6 8
129.6 8
149.7 9
150.7 9
151.7 9
41.8 6
42.8 6
43.8 6
/;

* -----------physical netowrk with arc travel time----------------------
parameter arcs(i,j,t,s) link travel time ;
arcs('1','2',t,t+10)$(win(t,'1')= 1)=10;
arcs('1','4',t,t+12)$(win(t,'1')= 1)=12;
arcs('2','1',t,t+10)=10;
arcs('4','1',t,t+12)=12;
arcs('2','3',t,t+5)=5;
arcs('3','2',t,t+5)=5;
arcs('2','5',t,t+10)=10;
arcs('5','2',t,t+10)=10;
arcs('2','4',t,t+8)=8;
arcs('4','2',t,t+8)=8;
arcs('4','3',t,t+10)=10;
arcs('3','4',t,t+10)=10;
arcs('4','5',t,t+10)=10;
arcs('5','4',t,t+10)=10;
arcs('5','3',t,t+8)=8;
arcs('3','5',t,t+8)=8;
arcs('4','10',t,t+1)=1;
arcs('10','4',t,t+1)$(win(t,'2')= 10)=1;
arcs('4','11',t,t+1)=1;
arcs('11','4',t,t+1)$(win(t,'3')= 11)=1;
arcs('5','12',t,t+1)=1;
arcs('12','5',t,t+1)$(win(t,'4')= 12)=1;
arcs('5','13',t,t+1)=1;
arcs('13','5',t,t+1)$(win(t,'5')= 13)=1;
arcs('3','8',t,t+1)=1;
arcs('8','3',t,t+1)$(win(t,'6')= 8)=1;
arcs('3','9',t,t+1)=1;
arcs('9','3',t,t+1)$(win(t,'7')= 9)=1;
arcs('2','6',t,t+1)=1;
arcs('6','7',t,t+60)$(win(t,'8')= 6)=60;
arcs('7','2',t,t+1)=1;
arcs(i,i,t,t+1)= 1;

*------------------arc travel cost defined by the author-------------------
parameter travel_cost(i,j,t,s);
travel_cost('1','2',t,t+10)$(win(t,'1')= 1)=10;
travel_cost('1','4',t,t+12)$(win(t,'1')= 1)=12;
travel_cost('2','1',t,t+10)=10;
travel_cost('4','1',t,t+12)=12;
travel_cost('2','3',t,t+5)=5;
travel_cost('3','2',t,t+5)=5;
travel_cost('2','5',t,t+10)=10;
travel_cost('5','2',t,t+10)=10;
travel_cost('2','4',t,t+8)=8;
travel_cost('4','2',t,t+8)=8;
travel_cost('4','3',t,t+10)=10;
travel_cost('3','4',t,t+10)=10;
travel_cost('4','5',t,t+10)=10;
travel_cost('5','4',t,t+10)=10;
travel_cost('5','3',t,t+8)=8;
travel_cost('3','5',t,t+8)=8;
travel_cost('4','10',t,t+1)=1;
travel_cost('10','4',t,t+1)$(win(t,'2')= 10)=1;
travel_cost('4','11',t,t+1)=1;
travel_cost('11','4',t,t+1)$(win(t,'3')= 11)=1;
travel_cost('5','12',t,t+1)=1;
travel_cost('12','5',t,t+1)$(win(t,'4')= 12)=1;
travel_cost('5','13',t,t+1)=1;
travel_cost('13','5',t,t+1)$(win(t,'5')= 13)=1;
travel_cost('3','8',t,t+1)=1;
travel_cost('8','3',t,t+1)$(win(t,'6')= 8)=1;
travel_cost('3','9',t,t+1)=1;
travel_cost('9','3',t,t+1)$(win(t,'7')= 9)=1;
travel_cost('2','6',t,t+1)=1;
travel_cost('6','7',t,t+60)$(win(t,'8')= 6)=-20;
travel_cost('7','2',t,t+1)=1;
travel_cost(i,i,t,t+1)= 1;
travel_cost('1','1',t,t+1)=0;

*-----state:000=1,100=2,101=3,201=4,202=5,211=6,212=7,222=8; 1=activty 2, 2=activity 3, 3=activity 4,------
parameter w_trans(w,wp) TRANSITION MATRIX/
1. 2 -1
2. 3 -3
3. 4 1
4. 5 3
4. 6 -2
6. 7 3
7. 8 2
/;

*----indicater of passenger picked up or delivered---------
parameter delivery(i,t);
delivery('10',t)$(win(t,'2')= 10)=-1;
delivery('12',t)$(win(t,'4')= 12)=-3;
delivery('8',t)$(win(t,'6')= 8)=-2;

parameter pickup(i,t);
pickup('11',t)$(win(t,'3')= 11)=1;
pickup('13',t)$(win(t,'5')= 13)=3;
pickup('9',t)$(win(t,'7')= 9)=2;

*---------real travel cost-----------------------
parameter travel_real_cost(i,j,t,s,w,wp);
travel_real_cost(i,j,t,s,w,wp)=travel_cost(i,j,t,s);
travel_real_cost('10','10',t,t,w,wp)$(delivery('10',t)= -1)=-10;
travel_real_cost('12','12',t,t,w,wp)$(delivery('12',t)= -3)=-15;
travel_real_cost('8','8',t,t,w,wp)$(delivery('8',t)= -2)=-15;

*------------origin, destination, and intermidiate nodes of each household memeber----------------
parameter origin(i,t,w);
origin('1','1','1')=1;

parameter destination(i,t,w);
destination('1','170','8')=1;

parameter intermediate(i,t,w);
intermediate(i,t,w) = (1- origin(i,t,w))* (1- destination(i,t,w));

*------- indicator of space-time-state arc ------------
parameter arcs_w(i,j,t,s,w,wp);
arcs_w(i,j,t,s,w,w)$(arcs(i,j,t,s)>0.1) = 1;
arcs_w(i,i,t,t,w,wp)$(pickup(i,t)=1 and (w_trans(w,wp) eq pickup(i,t)))= 1;
arcs_w(i,i,t,t,w,wp)$(pickup(i,t)=2 and (w_trans(w,wp) eq pickup(i,t)))= 1;
arcs_w(i,i,t,t,w,wp)$(pickup(i,t)=3 and (w_trans(w,wp) eq pickup(i,t)))= 1;
arcs_w(i,i,t,t,w,wp)$(delivery(i,t)= -1 and (w_trans(w,wp) eq delivery(i,t)))= 1;
arcs_w(i,i,t,t,w,wp)$(delivery(i,t)= -2 and (w_trans(w,wp) eq delivery(i,t)))= 1;
arcs_w(i,i,t,t,w,wp)$(delivery(i,t)= -3 and (w_trans(w,wp) eq delivery(i,t)))= 1;
arcs_w('1','1',t,t+1,'5','8') = 1;

*-----------the relation between activity links and its activity----------
parameter act_link(a,i,j) /
1.6.7 1
/;

variable z;

binary variables
x(i,j,t,s,w,wp)

equations
obj                                   define objective function for vehicles
agent_on_node_origin(i,t,w)                vehicle origin node flow on node i at time t
agent_on_node_intermediate(i,t,w)          vehicle intermediate node flow on node i at time t
agent_on_node_destination(i,t,w)           vehicle destination node flow on node i at time t
mandatory_act(a)                           mandatory activity number
;

obj.. z =e= sum((i,j,t,s,w,wp)$(arcs_w(i,j,t,s,w,wp)=1), travel_real_cost(i,j,t,s,w,wp)* x(i,j,t,s,w,wp));
agent_on_node_origin(i,t,w)$(origin(i,t,w)).. sum((j,s,wp)$(arcs_w(i,j,t,s,w,wp)=1), x(i,j, t,s,w,wp)) =e= 1;
agent_on_node_intermediate(i,t,w)$(intermediate(i,t,w)).. sum((j,s,wp)$(arcs_w(i,j,t,s,w,wp)=1), x(i,j,t,s,w,wp))-sum((j,s,wp)$(arcs_w(j,i,s,t,wp,w)), x(j,i,s,t,wp,w)) =e= 0;
agent_on_node_destination(i,t,w)$(destination(i,t,w))..  sum((j,s,wp)$(arcs_w(j,i,s,t,wp,w)=1), x(j,i,s,t,wp,w))=e= 1;
mandatory_act(a) .. sum((i,j,t,s,w,wp)$(arcs_w(i,j,t,s,w,wp)=1 and act_link(a,i,j)=1), x(i,j,t,s,w,wp)) =e= 1;

Model Household_scheduling_case_2_1 /all/ ;
solve Household_scheduling_case_2_1 using MIP minimizing z;
display x.l;
display z.l;

File output2_1_x;
put output2_1_x;
loop((i,j,t,s,w,wp)$((x.l(i,j,t,s,w,wp) = 1)),put @5, i.tl, @10, j.tl, @20, t.tl,  @30, s.tl, @40, w.tl, @50, wp.tl/);


