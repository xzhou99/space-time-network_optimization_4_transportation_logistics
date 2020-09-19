$title household scheduling problem
OPTIONS mip = CPLEX;

set i nodes /1*18/;
set t time stamp /1*125/;
set a agent /1*2/;
set k time_winow_node /1*7/
set v vehicle /1*2/;
set m opt_act /1*1/;

alias (i, j);
alias (t, s);


*------------------------------------------------------------------------------------------------------------
*conncet time window nodes with the real nodes in the network based on given time window values
parameter win(t,k)  /
1.1 1
2.1 1
3.1 1
1.2 2
2.2 2
3.2 2
15.3 11
16.3 11
17.3 11
18.3 11
15.4 13
16.4 13
17.4 13
18.4 13
18.5 15
19.5 15
20.5 15
86.6 17
87.6 17
88.6 17
89.6 17
90.6 17
/;

* -----------physical netowrk with arc travel time----------------------
parameter arcs(i,j,t,s) link travel time ;
arcs('1','3',t,t+1)$(win(t,'1')= 1)=1;
arcs('1','4',t,t+1)$(win(t,'1')= 1)=1;
arcs('1','5',t,t+1)$(win(t,'1')= 1)=1;

arcs('2','4',t,t+1)$(win(t,'2')= 2)=1;
arcs('2','5',t,t+1)$(win(t,'2')= 2)=1;

arcs('3','6',t,t+1)=1;
arcs('4','6',t,t+1)=1;
arcs('6','5',t,t+1)=1;

arcs('6','7',t,t+10)=10;
arcs('7','6',t,t+10)=10;

arcs('6','9',t,t+12)=12;
arcs('9','6',t,t+12)=12;

arcs('7','9',t,t+8)=8;
arcs('9','7',t,t+8)=8;

arcs('7','8',t,t+5)=5;
arcs('8','7',t,t+5)=5;

arcs('8','9',t,t+10)=10;
arcs('9','8',t,t+10)=10;

arcs('8','10',t,t+8)=8;
arcs('10','8',t,t+8)=8;

arcs('9','10',t,t+10)=10;
arcs('10','9',t,t+10)=10;

arcs('7','10',t,t+10)=10;
arcs('10','7',t,t+10)=10;

arcs('7','11',t,t+1)=1;
arcs('11','12',t,t+60)$(win(t,'3')= 11)=60;
arcs('12','7',t,t+1)=1;

arcs('9','13',t,t+1)=1;
arcs('13','14',t,t+30)$(win(t,'4')= 13)=30;
arcs('14','9',t,t+1)=1;

arcs('10','17',t,t+1)=1;
arcs('17','18',t,t+20)$(win(t,'6')= 17)=20;
arcs('18','10',t,t+1)=1;

arcs('8','15',t,t+1)=1;
arcs('15','16',t,t+30)$(win(t,'5')= 15)=30;
arcs('16','8',t,t+1)=1;

arcs(i,i,t,t+1)= 1;

*------------------arc travel cost defined by the author-------------------
parameter travel_cost(i,j,t,s);
travel_cost('1','3',t,t+1)$(win(t,'1')= 1)=1;
travel_cost('1','4',t,t+1)$(win(t,'1')= 1)=1;
travel_cost('1','5',t,t+1)$(win(t,'1')= 1)=0;

travel_cost('2','4',t,t+1)$(win(t,'2')= 2)=1;
travel_cost('2','5',t,t+1)$(win(t,'2')= 2)=0;

travel_cost('3','6',t,t+1)=1;
travel_cost('4','6',t,t+1)=1;
travel_cost('6','5',t,t+1)=1;
travel_cost('6','7',t,t+10)=10;
travel_cost('7','6',t,t+10)=10;
travel_cost('6','9',t,t+12)=12;
travel_cost('9','6',t,t+12)=12;
travel_cost('7','9',t,t+8)=8;
travel_cost('9','7',t,t+8)=8;
travel_cost('7','8',t,t+5)=5;
travel_cost('8','7',t,t+5)=5;
travel_cost('8','9',t,t+10)=10;
travel_cost('9','8',t,t+10)=10;
travel_cost('8','10',t,t+8)=8;
travel_cost('10','8',t,t+8)=8;
travel_cost('9','10',t,t+10)=10;
travel_cost('10','9',t,t+10)=10;
travel_cost('7','10',t,t+10)=10;
travel_cost('10','7',t,t+10)=10;

travel_cost('7','11',t,t+1)=1;
travel_cost('11','12',t,t+60)$(win(t,'3')= 11)=-20;
travel_cost('12','7',t,t+1)=1;

travel_cost('9','13',t,t+1)=1;
travel_cost('13','14',t,t+30)$(win(t,'4')= 13)=-10;
travel_cost('14','9',t,t+1)=1;

travel_cost('10','17',t,t+1)=1;
travel_cost('17','18',t,t+20)$(win(t,'6')= 17)=-20;
travel_cost('18','10',t,t+1)=1;

travel_cost('8','15',t,t+1)=1;
travel_cost('15','16',t,t+30)$(win(t,'5')= 15)=-15;
travel_cost('16','8',t,t+1)=1;

travel_cost(i,i,t,t+1)= 1;
travel_cost('1','1',t,t+1)=0;
travel_cost('2','2',t,t+1)=0;
travel_cost('5','5',t,t+1)=0;

*------------origin, destination, and intermidiate nodes of each household memeber----------------
parameter origin(a,i,t);
origin('1','1','1')=1;
origin('2','2','1')=1;

parameter destination(a,i,t);
destination('1','5','125')=1;
destination('2','5','125')=1;

parameter intermediate(a,i,t);
intermediate(a,i,t) = (1- origin(a,i,t))* (1- destination(a,i,t));

* ------------the activity type of each household member: 1 is mandatory and 2 is semi-mandatroy---------
parameter dif_act(a) /
1 1
2 2
/;

*--------------nodes representing vehicles----------------
parameter veh_node(v,i) /
1.3 1
2.4 1
/;

*---------the relation between optional activities and household memebers
parameter act_agent(m,a) /
1.1 1
/;

*-----------the relation between activity links and its household memeber
parameter act_link(a,i,j) /
1.11.12 1
2.13.14 2
2.15.16 2
1.17.18 3
/;


variable z;

binary variables
x(a,i,j,t,s )

equations
obj                                 objective function
agent_on_node_origin(a,i,t)         origin node agent a on node i at time t
agent_on_node_intermediate(a,i,t)   intermediate node agent a on node i at time t
agent_on_node_destination(a,i,t)    destination node agent a on node i at time t
mandatory_act(a)                    mandatory activity of agent a (assume each agent has one mandatory activity here!)
vehicle_selection(v)                vehicle selection condition
semi_mand_act(a)                    semi-mandatory activites of egent a (one of them should be performed)
optional_act(m,a)                     optional activity that can be performed by multiple household memebers
;

obj.. z =e= sum (a,(sum((i,j,t,s)$(arcs(i,j,t,s)>0.1), x(a,i,j,t,s)*travel_cost(i,j,t,s))));
agent_on_node_origin(a,i,t)$(origin(a,i,t)=1) .. sum((j,s)$(arcs(i,j,t,s)>0.1), x(a,i,j,t,s)) =e= origin(a,i,t);
agent_on_node_destination(a,i,t)$(destination(a,i,t)=1) ..  sum((j,s)$(arcs(j,i,s,t)>0.1), x(a,j,i,s,t))=e= destination(a,i,t);
agent_on_node_intermediate(a,i,t)$(intermediate(a,i,t)=1).. sum((j,s)$(arcs(i,j,t,s)>0.1), x(a,i, j, t,s))-sum((j,s)$(arcs(j,i,s,t)>0.1), x(a,j,i,s,t))=e= 0;
mandatory_act(a)$(dif_act(a)=1) .. sum((i,j,t,s)$(arcs(i,j,t,s)>0.1 and act_link(a,i,j)=1), x(a,i,j,t,s)) =e= 1;
vehicle_selection(v).. sum (a,(sum((i,j,t,s)$(arcs(i,j,t,s)>0.1 and veh_node(v,j)>0.1),x(a,i,j,t,s)))) =l= 1;
semi_mand_act(a)$(dif_act(a)=2) .. sum((i,j,t,s)$(arcs(i,j,t,s)>0.1 and act_link(a,i,j)=2), x(a,i,j,t,s)) =e= 1;
optional_act(m,a).. sum((i,j,t,s)$(arcs(i,j,t,s)>0.1 and act_link(a,i,j)=3 and act_agent(m,a)=1),x(a,i,j,t,s))=l= 1;


Model Household_scheduling_case_4 /all/ ;
solve Household_scheduling_case_4 using MIP minimizing z;
display x.l;
display z.l;

File output_x;
put output_x;
loop((a,i,j,t,s)$((x.l(a,i,j,t,s) = 1)),put @5, a.tl, @10, i.tl, @20, j.tl,  @30, t.tl, @40, s.tl/);


