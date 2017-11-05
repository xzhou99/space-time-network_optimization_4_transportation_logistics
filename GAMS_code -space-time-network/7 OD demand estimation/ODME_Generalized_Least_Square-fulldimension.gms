$TITLE OD ESTIMATION PROBLEM
OPTIONS  ITERLIM=1000, RESLIM = 1000000, SYSOUT = OFF, SOLPRINT = OFF, NLP = MINOS5,OPTCR= 0.1, LIMROW = 0, LIMCOL = 0;
SET I /1*119/;
SET J /1*119/;
SET D /1*12/;
SET K /1*346/;
SET T /1*18/;

PARAMETER DTarget(I,J,D) /
   1.    1.   1    6.5600
   1.    1.   2    8.2000
   1.    1.   3    9.4300

/;

PARAMETER OBSFLOW(K,T) /
    1.    1   646
    1.    2   787
    1.    3   788
    1.    4   816
    1.    5   799
    1.    6   841
    1.    7   847
/;

PARAMETER LINKP(I,J,D,K,T) /
         1.         3.         3.       346.         4                  0.25000
         1.         3.         4.       243.         6                  0.50000
         1.         3.         4.       346.         6                  0.50000

/;



parameter w     weight on demand discrepancy term;
w = 0.3;

parameter StaticDemand(I,J);
StaticDemand(I,J) = sum(D, DTarget(I,J,D));

parameter
DEMANDFLAG(I,J)  demand flag with or without link observations;


DEMANDFLAG(I,J) = SUM((K,T,D),LINKP(I,J,D,K,T));

positive VARIABLES
Demand(I,J,D)   demand on OD pair (ij) departing at time d;

Demand.L(I,J,D) = DTarget(I,J,D);
Demand.LO(I,J,D) = 0.5*DTarget(I,J,D);
Demand.UP(I,J,D) = 1.2*DTarget(I,J,D);

*Assign an intial point to decision variable
VARIABLE
OBJ     sum of deviations between observed link volume and estimated link volume
;
EQUATIONS
OBJF    define objective function
;

OBJF.. OBJ=E=(1-w)*SUM((K,T)$(OBSFLOW(K,T) gt 0),sqr(SUM((I,J,D)$(DEMANDFLAG(I,J) gt 0),LINKP(I,J,D,K,T)*Demand(I,J, D))- OBSFLOW(K,T)))+
         w*SUM((I,J)$(DEMANDFLAG(I,J) gt 0),sqr(sum( D, Demand(I,J,D) ) - StaticDemand(I,J)));

MODEL ODE /ALL/;
SOLVE ODE USING NLP MINIMIZING OBJ;

VARIABLES
totaldemand      total demand for all the od pairs;
totaldemand.L = sum((I,J,D), Demand.L(I,J,D));

File estdemand; put estdemand;
loop((I,J,D)$(Demand.L(I,J,D) gt 0),put @3, I.tl, @16, J.tl, @36, D.tl, @54, Demand.L(I,J,D)/);

File StaticOD; put StaticOD;
loop((I,J)$((StaticDemand(I,J) gt 0)),put @3, I.tl, @16, J.tl,  @54, StaticDemand(I,J)/);

DISPLAY OBJ.L;
DISPLAY Demand.L;
DISPLAY totaldemand.L;
