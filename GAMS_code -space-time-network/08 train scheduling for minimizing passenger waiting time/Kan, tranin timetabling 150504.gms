$title transit timetabling Problem
*OPTIONS  ITERLIM=100000, RESLIM = 1000000, SYSOUT = OFF, SOLPRINT = OFF, OPTCR= 0.1, LIMROW = 0, LIMCOL = 0;

sets
* the network is the 6-node network in DTALite
    u  station /1*9/
    k  hourly time index /1*8/
    j  train index /1*10/;

alias (u,v);
alias (j,j_p);
alias (k,k_p);

parameter cap;
cap = 10000;
*  capacity

parameter sec_min min safety time interval;
sec_min = 5;

parameter sta_min min station safety time interval;
sta_min = 5;
* pre-specified safety time headway

parameter buff_min min buffer time for each segment;
buff_min=1;

parameter buff_max max buffer time for each segment;
buff_max=20;

parameter dw_min min dwell time at station;
dw_min=2;
Parameter dw_max max dwell time at station;
dw_max = 20;


Parameter ad accelerate or decelerate time due to stop at station u;
ad = 2;


parameter val_station(u)  /
1        1
2        2
3        3
4        4
5        5
6        6
7        7
8        8
9        9
/;
parameter val_train(j)  /
1        1
2        2
3        3
4        4
5        5
6        6
7        7
8        8
9        9
10       10
/;

parameter val_k(k) time period k /
1   1
2   2
3   3
4   4
5   5
6   6
7   7
8   8
/;

parameter time(k,k_p) /
2.1 1
3.1 1
3.2 1
4.1 1
4.2 1
4.3 1
5.1 1
5.2 1
5.3 1
5.4 1
6.1 1
6.2 1
6.3 1
6.4 1
6.5 1
7.1 1
7.2 1
7.3 1
7.4 1
7.5 1
7.6 1
8.1 1
8.2 1
8.3 1
8.4 1
8.5 1
8.6 1
8.7 1
/;

parameter od(u,v) OD pair station/
1.2 1
1.3 1
1.4 1
1.5 1
1.6 1
1.7 1
1.8 1
1.9 1
2.3 1
2.4 1
2.5 1
2.6 1
2.7 1
2.8 1
2.9 1
3.4 1
3.5 1
3.6 1
3.7 1
3.8 1
3.9 1
4.5 1
4.6 1
4.7 1
4.8 1
4.9 1
5.6 1
5.7 1
5.8 1
5.9 1
6.7 1
6.8 1
6.9 1
7.8 1
7.9 1
8.9 1/;

parameter train(j,j_p) define dummy trains/
2.1 1
3.2 2
3.1 1
4.3 3
4.2 2
4.1 1
5.4 4
5.3 3
5.2 2
5.1 1
6.5 5
6.4 4
6.3 3
6.2 2
6.1 1
7.6 6
7.5 5
7.4 4
7.3 3
7.2 2
7.1 1
8.7 7
8.6 6
8.5 5
8.4 4
8.3 3
8.2 2
8.1 1
9.8 8
9.7 7
9.6 6
9.5 5
9.4 4
9.3 3
9.2 2
9.1 1
10.9 9
10.8 8
10.7 7
10.6 6
10.5 5
10.4 4
10.3 3
10.2 2
10.1 1
/;

Parameter r(u) free running time in each nearst segement follow the station u/
1    30
2    20
3    20
4    10
5    10
6    20
7    30
8    20/;

Parameter p(u,v,k) passenger arrival rate PAX_minute/
1.2.1 1
1.3.1 1
1.4.1 2
1.5.1 2
1.6.1 2
1.7.1 2
1.8.1 2
1.9.1 2
2.3.1 1
2.4.1 2
2.5.1 2
2.6.1 1
2.7.1 2
2.8.1 1
2.9.1 3
3.4.1 2
3.5.1 2
3.6.1 2
3.7.1 1
3.8.1 1
3.9.1 2
4.5.1 2
4.6.1 2
4.7.1 2
4.8.1 2
4.9.1 2
5.6.1 2
5.7.1 2
5.8.1 2
5.9.1 1
6.7.1 3
6.8.1 1
6.9.1 2
7.8.1 2
7.9.1 2
8.9.1 2
1.2.2 2
1.3.2 3
1.4.2 1
1.5.2 2
1.6.2 1
1.7.2 1
1.8.2 1
1.9.2 1
2.3.2 3
2.4.2 1
2.5.2 2
2.6.2 1
2.7.2 2
2.8.2 1
2.9.2 1
3.4.2 2
3.5.2 2
3.6.2 1
3.7.2 1
3.8.2 2
3.9.2 1
4.5.2 1
4.6.2 3
4.7.2 1
4.8.2 2
4.9.2 1
5.6.2 1
5.7.2 2
5.8.2 3
5.9.2 1
6.7.2 2
6.8.2 1
6.9.2 1
7.8.2 3
7.9.2 2
8.9.2 3
1.2.3 3
1.3.3 4
1.4.3 3
1.5.3 1
1.6.3 1
1.7.3 1
1.8.3 1
1.9.3 1
2.3.3 3
2.4.3 3
2.5.3 2
2.6.3 1
2.7.3 1
2.8.3 1
2.9.3 2
3.4.3 3
3.5.3 2
3.6.3 2
3.7.3 2
3.8.3 1
3.9.3 1
4.5.3 4
4.6.3 2
4.7.3 1
4.8.3 1
4.9.3 1
5.6.3 3
5.7.3 3
5.8.3 1
5.9.3 1
6.7.3 2
6.8.3 1
6.9.3 1
7.8.3 2
7.9.3 2
8.9.3 5
1.2.4 2
1.3.4 3
1.4.4 2
1.5.4 2
1.6.4 1
1.7.4 2
1.8.4 1
1.9.4 1
2.3.4 2
2.4.4 2
2.5.4 1
2.6.4 1
2.7.4 2
2.8.4 1
2.9.4 1
3.4.4 3
3.5.4 1
3.6.4 2
3.7.4 1
3.8.4 1
3.9.4 2
4.5.4 3
4.6.4 1
4.7.4 2
4.8.4 1
4.9.4 1
5.6.4 3
5.7.4 2
5.8.4 1
5.9.4 1
6.7.4 2
6.8.4 1
6.9.4 1
7.8.4 2
7.9.4 2
8.9.4 4
1.2.5 2
1.3.5 1
1.4.5 2
1.5.5 1
1.6.5 1
1.7.5 2
1.8.5 1
1.9.5 1
2.3.5 1
2.4.5 1
2.5.5 1
2.6.5 1
2.7.5 2
2.8.5 1
2.9.5 1
3.4.5 3
3.5.5 1
3.6.5 2
3.7.5 1
3.8.5 1
3.9.5 2
4.5.5 3
4.6.5 1
4.7.5 1
4.8.5 1
4.9.5 1
5.6.5 1
5.7.5 2
5.8.5 1
5.9.5 1
6.7.5 1
6.8.5 1
6.9.5 1
7.8.5 1
7.9.5 1
8.9.5 1
/;

table TD_1(j,*) earliest and latest departure time from first station for train
     E      L
1    1      20
2    25     30
3    35     60
4    65     80
5    85     100
6    105    130
7    135    150
8    155    170
9    175    190
10   195    300
 ;

Table s(j,u) train j skip_stop pattern at station u
      1     2        3        4        5        6        7        8      9
1     1     1        1        1        1        1        1        1      1
2     1     0        1        1        1        1        1        0      1
3     1     1        1        1        1        0        0        1      1
4     1     1        0        1        0        1        1        1      1
5     1     0        1        1        1        1        1        0      1
6     1     1        1        1        1        0        0        1      1
7     1     1        0        1        0        1        1        1      1
8     1     0        1        1        1        1        1        0      1
9     1     1        1        1        1        0        0        1      1
10    1     1        0        1        0        1        1        1      1
 ;

Binary variables
B(u,v,j,j_p)   binary variable that indicates if there is a train j_p which has the same couple_stop pattern as train j
x(u,j,k)       binary variable that indicates if a train departure time at station u belongs to a spefific period k
beta(u,v,j,j_p) binary variable for nearest dummy train pair j and j_p

;

Positive variables
TA(u,j)            arrival time for train j at station u
TD(u,j)            departure time for train j at station u
TR(u,j)            buffer time at segement ahead of station u
TS(u,j)            Stopping time at station u  ;

variables
obj               objective function
cs(u,v,j)         couple_stop index which is equal to 1 if train j stops at both station u and v
part_1(u,v,j,k)
part_2(u,v,j,k)
w(u,v,j)           passenger waiting time with OD demand before train j arrive
C(u,v,j)           nearest dummy train variable for train j in terms of OD pair uv
D(u,v,j,j_p)       variable to find train dummy train j_p
q(u,v,j)           train load
capa(j)            capacity of train j

 ;


equations
Con_1_x(u,j,k)   constraints or definition for variable_x_1
Con_2_x(u,j,k)   constraints or definition for variable_x_2
con_3_x(u,j)     define binary variable x


def_cs(u,v,j)    define couple_stop variable
def_B(u,v,j,j_p) define indicator for train

link_con_1(u,j)  linking constraints that ensure a safety arrival time at station u
link_con_2(u,j)  linking constraints that ensure a safety departure time at station u
link_con_3(u,j)

safe_TD(u,j)     safety headway constraints_1
safe_TA(u,j)     safety headway constraints_2
safe(u,j)        safety headway constraints_2

stop_TSmin(u,j)      feasible train dwell lower_bound
stop_TSmax(u,j)      feasible train dwell upper_bound
buff_TRmin(u,j)      buffer time lower bound
buff_TRmax(u,j)      buffer time upper bound

fea_TD_1(j)      feasible departure time at first station lower_bound
fea_TD_2(j)      feasible departure time at first station upper_bound

def_q(u,v,j)     amount of passenger boarding train j at station u
def_capa(j)
Cap_con(j)       Train j capacity constraints
def_w(u,v,j)     total waiting time refer to train j from u to v
def_obj          objective function definition

def_part_1(u,v,j,k) time period between t(k-1) and train j departure time TD(j) at station u
def_part_2(u,v,j,k) time period between dummy train departure time and t(k-1)

def_C(u,v,j)        find dummy train for train j
def_D(u,v,j,j_p)    if j_p is the nearest dummy train D=0
def_beta(u,v,j,j_p) if j_p is the nearest dummy train beta=1
;



Con_1_x(u,j,k).. 60*val_k(k-1)-TD(u,j)=l=100000*(1-x(u,j,k));
Con_2_x(u,j,k).. TD(u,j)-60*val_k(k)=l= 100000*(1-x(u,j,k));
con_3_x(u,j).. sum(k,x(u,j,k))=e=1;


def_cs(u,v,j)..  cs(u,v,j)=e= od(u,v)*s(j,u)*s(j,v);
def_B(u,v,j,j_p).. B(u,v,j,j_p)=e= od(u,v)*train(j,j_p)*cs(u,v,j)*cs(u,v,j_p)/val_train(j_p);
def_C(u,v,j)$(od(u,v))..C(u,v,j)=e=smax(j_p,B(u,v,j,j_p)*val_train(j_p));
def_D(u,v,j,j_p)$(train(j,j_p) and (od(u,v)))..D(u,v,j,j_p)=e=C(u,v,j)-val_train(j_p);
def_beta(u,v,j,j_p)$(train(j,j_p) and (od(u,v)))..beta(u,v,j,j_p)=e=1*(D(u,v,j,j_p)=0);



link_con_1(u,j)$(val_station(u)>1)..TA(u,j)=e=TD(u-1,j)+r(u-1)+ad*(s(j,u-1)+s(j,u))*cs(u,u-1,j)+TR(u-1,j);
link_con_2(u,j)$(val_station(u)>1)..TD(u,j)=e= TA(u,j)+TS(u,j)*s(j,u);
link_con_3(u,j)$(val_station(u)>1)..TD(u,j)=g=TD(u-1,j);



safe_TD(u,j)$(val_train(j)>1 and val_station(u)>1).. (TD(u,j)-TD(u,j-1))=g= sec_min;
safe_TA(u,j)$(val_train(j)>1 and val_station(u)>1).. (TA(u,j)-TA(u,j-1))=g= sec_min;
safe(u,j)$(val_train(j)>1 and val_station(u)>1)..    (TA(u,j)-TD(u,j-1))=g= sta_min;

stop_TSmin(u,j)$(s(j,u))..TS(u,j)=g= dw_min;
stop_TSmax(u,j)$(s(j,u))..TS(u,j)=l= dw_max;

buff_TRmin(u,j)..TR(u,j)=g= buff_min;
buff_TRmax(u,j)..TR(u,j)=l= buff_max;

fea_TD_1(j)..TD('1',j)=g= TD_1(j,'E');
fea_TD_2(j)..TD('1',j)=l= TD_1(j,'L');

def_part_1(u,v,j,k)$(od(u,v)=1)..part_1(u,v,j,k)=e= x(u,j,k)*TD(u,j)-x(u,j,k)*60*val_k(k-1);
def_part_2(u,v,j,k)$(od(u,v)=1)..part_2(u,v,j,k)=e= sum(j_p,beta(u,v,j,j_p)*x(u,j_p,k)*(60*(val_k(k)-x(u,j,k))-TD(u,j_p)));
def_q(u,v,j)..q(u,v,j)=e=cs(u,v,j)*sum(k,p(u,v,k)*(part_1(u,v,j,k)+part_2(u,v,j,k)));
def_capa(j)..capa(j)=e=sum((u,v),q(u,v,j)) ;
Cap_con(j)..capa(j)=l=cap;
def_w(u,v,j)..w(u,v,j)=e=0.5*cs(u,v,j)*sum(k,p(u,v,k)*sqr(part_1(u,v,j,k)+part_2(u,v,j,k)));
def_obj..obj=e=sum((u,v,j),w(u,v,j));

MODEL train_timetabling /all/;
* SO

SOLVE train_timetabling USING RMINLP MINIMIZING obj;
display TA.l,TD.l,TR.l,TS.l,obj.l,c.l,d.l,beta.l,capa.l,q.l,w.l,x.l,part_1.l,part_2.l;
