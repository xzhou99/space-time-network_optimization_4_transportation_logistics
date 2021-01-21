$ TITLE Recursive Logit Based Route Assignment
OPTIONS  ITERLIM=1000, RESLIM = 1000000, SYSOUT = OFF, SOLPRINT = OFF, NLP = MINOS5,OPTCR= 0.1, LIMROW = 0, LIMCOL = 0;

set i nodes /1*4/;
set k od pairs /1*2/;

alias(i,j);
alias(i,h);


parameter origin_node(k,i);
origin_node('1','1')=1;
origin_node('2','3') =1;

parameter destination_node(k,i);
destination_node('1','4')=1;
destination_node('2','4')=1;

parameter intermediate_node(k,i);
intermediate_node(k,i)=(1-origin_node(k,i))*(1-destination_node(k,i));
intermediate_node('2','1')=no;

parameter fftt(i,j) link travel time
     /1.2 3
      1.3 1
      3.2 1
      2.4 3
      3.4 6/;
parameter cap_a(i,j) link capacity
     /1.2 10
      1.3 10
      3.2 10
      2.4 10
      3.4 20/;
parameter obs_link_flow(i,j) observed link flow
      /1.2 1
       1.3 9
       2.4 14
       3.2 13
       3.4 6/;
parameter obs_d(k) demand
      /1  9
       2  10/;

parameter arc(k,i,j) define subnetwork for each od
     /1.1.2 1
      1.1.3 1
      1.3.2 1
      1.2.4 1
      1.3.4 1
      2.3.2 1
      2.3.4 1
      2.2.4 1/;

parameter Mu coefficient in utility function/-1/;

variable
      z;
positive variable
      v(k,i)
      p(k,i,j) link conditional probability
      total_p(k,i) total sum on each node
      gamma(k,i,j) link probability chosen by kth od pair
      x_od(k,i,j) link flow of od pair k
      x(i,j) link flow
      c_a(i,j)
      d(k)
;
*beta(k,i) node probability chosen by kth od pair

total_p.l(k,i)$(origin_node(k,i) or intermediate_node(k,i) or destination_node(k,i))=99999;

equations
      obj
      utility_destination(k,i)
      utility(k,i)
      link_cost(i,j)
      total_prob(k,i)
      con_prob(k,i,j)
      link_prob_origin(k,i,j)
      link_prob(k,i,j)
      link_flow_od(k,i,j)
      link_flow(i,j)
      link_cap(i,j)
      link_hard_flow(k,i,j)

;
*total_prob(k,i)
*con_prob(k,i,j)
*link_prob_origin(k,i,j)
*link_prob(k,i,j)
*link_flow_od(k,i,j)
*link_flow(i,j)

*link_cap(i,j)

obj..z=e=sum((i,j),(obs_link_flow(i,j)-x(i,j))**2)+sum(k,(obs_d(k)-d(k))**2);
*z=e=sum((i,j),(obs_link_flow(i,j)-x(i,j))**2)+sum(k,(obs_d(k)-d(k))**2);

utility_destination(k,i)$destination_node(k,i)..
      v(k,i)=e=0;

utility(k,i)$(intermediate_node(k,i) or origin_node(k,i))..
      v(k,i)=e=1/Mu*log(sum((j)$(cap_a(i,j)<>0),exp(Mu*(c_a(i,j)+v(k,j)))));

total_prob(k,i)$(intermediate_node(k,i) or origin_node(k,i))..
      total_p(k,i)=e=sum(j$cap_a(i,j),exp(1/Mu*(c_a(i,j)+v(k,j))));

con_prob(k,i,j)$arc(k,i,j)..
      p(k,i,j)=e=exp(1/Mu*(c_a(i,j)+v(k,j)))/total_p(k,i);

link_prob_origin(k,i,j)$origin_node(k,i)..
      gamma(k,i,j)=e= p(k,i,j);

link_prob(k,i,j)$(intermediate_node(k,i) and arc(k,i,j))..
      gamma(k,i,j)=e=sum(h,gamma(k,h,i))*p(k,i,j);

*link_prob(k,i,j)..
*gamma(k,i,j)=e=p(k,i,j)*sum(h$cap_a(h,i),gamma(k,h,i));



link_flow_od(k,i,j)..
      x_od(k,i,j)=e=d(k)*gamma(k,i,j);

link_flow(i,j)..
      x(i,j)=e=sum(k,x_od(k,i,j));

link_cost(i,j)$cap_a(i,j)..
            c_a(i,j)=e= fftt(i,j)*(1+0.15*x(i,j)/cap_a(i,j))**4;
*c_a(i,j)=e= fftt(i,j)*(1+0.15*x(i,j)/cap_a(i,j))**4;


link_cap(i,j)..
     x(i,j)=l=cap_a(i,j);

link_hard_flow(k,i,j)$(arc(k,i,j)=0)..x_od(k,i,j)=e=0;




model RL /all/;
solve RL using nlp minimizing z;
display z.l,v.l,total_p.l,p.l,gamma.l,x_od.l,x.l,d.l;







