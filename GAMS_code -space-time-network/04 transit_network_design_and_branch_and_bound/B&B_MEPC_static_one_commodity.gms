$title Discrete Transit Netwrok Design Problem

$ontext
reference:
Erwin Kalvelagen, 2003
Cardinality constrained mean-variance portfolio model.Branch-and-bound algorithm written in GAMS.

$offtext

OPTIONS  RMPEC = NLPEC;
*OPTIONS  MINLP = SCIP,RMPEC = NLPEC;

set i /1*4/;
alias (i, j);

parameter c_a(i,j) link travel time /
1. 2   60
1. 3   10
2. 4   10
3. 4   60
3. 2   10
/;

parameter c_b(i,j) link cost parameter /
1. 2   1
1. 3   2
2. 4   2
3. 4   1
3. 2   1
/;

parameter Cap(i,j) link capacity /
1. 2   2
1. 3   4
3. 2   1
2. 4   4
3. 4   3
/;
parameter ccost(i,j) construction cost /
1. 2   0
1. 3   0
2. 4   0
3. 4   0
3. 2  10
/;

parameter Budget;
Budget =15;

parameter r(i,j) existing link factor /
1. 2   1
1. 3   1
2. 4   1
3. 4   1
3. 2   0
/;

parameter demand_comm;
demand_comm = 6;

parameter  arcs_comm(i,j);
arcs_comm(i,j) = c_a(i,j);

parameter origin_comm(i);
origin_comm('1') = 1;

parameter destination_comm(i);
destination_comm('4') = 1;

parameter intermediate_comm(i);
intermediate_comm(i) = (1- origin_comm(i))* (1- destination_comm(i));

variable z;

positive variables
x(i,j)  selection of  comm p between i and j;
positive variable pie(i);
pie.l('1')=0;
positive variable alpha(i,j);

binary variables y(i,j);
y.fx(i,j)$(r(i,j)>0.1)=1;

equations
ue_obj
comm_flow_on_node_origin(i)         origin node flow pv on node i at time t
comm_flow_on_node_intermediate(i)   intermediate node flow k on node i at time t
comm_flow_on_node_destination(i)      destination node flow k on node i at time t
budget_constraint
cap_constraint_1(i,j)
link_rational_1(i,j);

ue_obj.. z =e= sum((i,j)$(c_a(i,j)>0.1), x(i,j)*c_a(i,j) + c_b(i,j)*x(i,j)*x(i,j));
comm_flow_on_node_origin(i)$(origin_comm(i)).. sum((j)$(c_a(i,j)>0.1), x(i,j)) =e= demand_comm;
comm_flow_on_node_destination(i)$(destination_comm(i))..  sum((j)$(c_a(j,i)>0.1), x(j,i))=e= demand_comm;
comm_flow_on_node_intermediate(i)$(intermediate_comm(i)).. sum((j)$(c_a(i,j)>0.1), x(i,j))-sum((j)$(c_a(j,i)>0.1), x(j,i))=e= 0;
budget_constraint ..  sum((i,j)$(c_a(i,j)>0.1), ccost(i,j)*y(i,j)) =l= Budget;
cap_constraint_1(i,j)$(c_a(i,j)>0.1).. Cap(i,j)*y(i,j)-x(i,j) =g=0;
link_rational_1(i,j)$(c_a(i,j)>0.1).. (c_a(i,j) + c_b(i,j)*x(i,j)+alpha(i,j))+ pie(i)-pie(j)=g=0;

*-------------------------------------------------------------
* simple branch and bound algorithm
*-------------------------------------------------------------

Model DTNDP /ue_obj,budget_constraint,comm_flow_on_node_origin.pie, comm_flow_on_node_destination.pie, comm_flow_on_node_intermediate.pie,link_rational_1.x,cap_constraint_1.alpha/ ;

*---------------------------------------------------------
* datastructure for node pool
* each node has variables x(i,j) which is either
* still free, or fixed to zero or with a lowerbound
* of minx.
*---------------------------------------------------------
set node                'maximum size of the node pool'    /node1*node1000/;
parameter bound(node)   'node n will have an obj <= bound(n)';
set fixedzero(node,i,j)   'variables y(k,i,j) are fixed to zero in this node';
set fixedone(node,i,j)    'variables y(k,j) are fixed to one in this node';
scalar bestfound        'lowerbound in B&B tree'   /+INF/;
scalar bestpossible     'upperbound in B&B tree'   /-INF/;
set newnode(node)       'new node (singleton)';
set waiting(node)       'waiting node list';
set current(node)       'current node (singleton except exceptions)';
parameter bblog(node,*) 'logging information';
scalar done             'terminate'              /0/;
scalar first            'controller for loop';
scalar first2           'controller for loop';
scalar subobj           'objective of subproblem';
scalar maxx;
set wait(node)          'waiting nodes';
parameter nodenumber(node);
parameter bestx(i,j)      'record best solution';
parameter besty(i,j)      'record best solution';

nodenumber(node) = ord(node);

fixedzero(node,i,j)$(c_a(i,j)>0.1) = no;
fixedone(node,i,j)$(c_a(i,j)>0.1) = no;

set fx(i,j) 'used in fixing variables';
alias (nd,node);
*
* add root node to the waiting node list
*
waiting('node1') = yes;
current('node1') = yes;
newnode('node1') = yes;
bound('node1') =INF;

loop(node$(not done),

*
* node selection
*
     bestpossible = smin(waiting(nd), bound(nd));
     current(nd) = no;
     current(waiting(nd))$(bound(nd) = bestpossible)  = yes;
     first = 1;
*
* only consider first in set current
*
     loop(current$first,
          first = 0;

          bblog(node,'node') = nodenumber(current);
          bblog(node,'lb') = bestpossible;
*
* remove current node from waiting list
*
          waiting(current) = no;
*
* clear bounds
*
          y.lo(i,j)$(c_a(i,j)>0.1) = 0;
          y.up(i,j)$(c_a(i,j)>0.1) = 1;
*
* set appropriate bounds
*
          fx(i,j)$(c_a(i,j)>0.1) = fixedzero(current,i,j);
          y.fx(fx) = 0;
          fx(i,j)$(c_a(i,j)>0.1) = fixedone(current,i,j);
          y.fx(fx) = 1;
          display y.lo,y.up;

*
* solve subproblem
*

          solve DTNDP using rmpec minimizing z;
          display x.l;
          display y.l;
*
* check for optimal solution
*
          bblog(node,'solvestat') = DTNDP.solvestat;
          bblog(node,'modelstat') = DTNDP.modelstat;

          abort$(DTNDP.solvestat <> 1) "Solver did not return ok";
          if (DTNDP.modelstat = 1 or DTNDP.modelstat = 2,
*
* get objective
*
              subobj = z.l;
              bblog(node,'obj') = subobj;
*
*  check "integrality"
*
              maxx = smax((i,j)$(c_a(i,j)> 0.1), min(y.l(i,j), 1-y.l(i,j)));
              if (maxx = 0,
*
* found a new "integer" solution
*
                  bblog(node,'integer') = 1;
                  if (subobj < bestfound,
*
* improved the best found solution
*
                        bblog(node,'best') = 1;
                        bestfound = subobj;
*
* record best solution
*
                        bestx(i,j) = x.l(i,j);
                        besty(i,j) = y.l(i,j);
*
* remove all waiting nodes with bound > bestfound
*
                        wait(nd) = no; wait(waiting) = yes;
                        waiting(wait)$(bound(wait) > bestfound) = no;
                  );
              else
*
* "fractional" solution
*
                  fx(i,j) = no;
                  fx(i,j)$(min(y.l(i,j), 1-y.l(i,j))=maxx) = yes;
                  first2 = 1;
                  loop(fx$first2,
                      first2 = 0;
*
* create 2 new nodes
*
                      newnode(nd) = newnode(nd-1);
                      fixedzero(newnode,i,j)$(c_a(i,j)>0.1) = fixedzero(current,i,j);
                      fixedone(newnode,i,j)$(c_a(i,j)>0.1) = fixedone(current,i,j);
                      bound(newnode) = subobj;
                      waiting(newnode) = yes;

                      fixedzero(newnode,fx) = yes;

                      newnode(nd) = newnode(nd-1);
                      fixedzero(newnode,i,j)$(c_a(i,j)>0.1) = fixedzero(current,i,j);
                      fixedone(newnode,i,j)$(c_a(i,j)>0.1) = fixedone(current,i,j);
                      bound(newnode) = subobj;
                      waiting(newnode) = yes;

                      fixedone(newnode,fx) = yes;

                  );
              );
          else
*
* if subproblem is infeasible this node is fathomed.
* otherwise it is an error.
*
             abort$(DTNDP.modelstat <> 4 and DTNDP.modelstat <> 5)
                                        "Solver did not solve subproblem";
          );

          bblog(node,'waiting') = card(waiting);
     );
*
* are there new waiting nodes?
*
     done$(card(waiting) = 0) = 1;

*
* display log
*
     display bblog;
);

display bestx,besty,bestfound,alpha.l,pie.l;

