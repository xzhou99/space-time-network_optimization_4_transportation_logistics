$title Railroad Yard Operation Plan Problem
$ontext
By
    Tie Shi,
    Xuesong Zhou
                              07/03,2014
$offtext
OPTIONS  ITERLIM=1000000, RESLIM = 1000000, SYSOUT = OFF, SOLPRINT = OFF, OPTCR= 0.1, LIMROW = 0, LIMCOL = 0;

sets
   t  time index "time indexund train no."/0*330/
   i  inbound train "inbound train no."/1*6/
   o  outbound train "outbound train no."/1*7/
   b  destination "railcar destination"/1*4/
   k  classification tracks "classification area"/1*4/
;
alias (i, j);
alias (t, t1);
*Value of Inbound Train No.
parameter val_InTrain(i)
/
1        1
2        2
3        3
4        4
5        5
6        6
/;

*Value of Destination
parameter val_destination(b)
/
1    1
2    2
3    3
4    4
/;

*Value of Classification Track No.
parameter val_ClaTrack(k)
/
1    1
2    2
3    3
4    4
/;

*Value of Time
parameter val_time(t)
/
 0        0
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
61        61
62        62
63        63
64        64
65        65
66        66
67        67
68        68
69        69
70        70
71        71
72        72
73        73
74        74
75        75
76        76
77        77
78        78
79        79
80        80
81        81
82        82
83        83
84        84
85        85
86        86
87        87
88        88
89        89
90        90
91        91
92        92
93        93
94        94
95        95
96        96
97        97
98        98
99        99
100        100
101        101
102        102
103        103
104        104
105        105
106        106
107        107
108        108
109        109
110        110
111        111
112        112
113        113
114        114
115        115
116        116
117        117
118        118
119        119
120        120
121        121
122        122
123        123
124        124
125        125
126        126
127        127
128        128
129        129
130        130
131        131
132        132
133        133
134        134
135        135
136        136
137        137
138        138
139        139
140        140
141        141
142        142
143        143
144        144
145        145
146        146
147        147
148        148
149        149
150        150
151        151
152        152
153        153
154        154
155        155
156        156
157        157
158        158
159        159
160        160
161        161
162        162
163        163
164        164
165        165
166        166
167        167
168        168
169        169
170        170
171        171
172        172
173        173
174        174
175        175
176        176
177        177
178        178
179        179
180        180
181        181
182        182
183        183
184        184
185        185
186        186
187        187
188        188
189        189
190        190
191        191
192        192
193        193
194        194
195        195
196        196
197        197
198        198
199        199
200        200
201        201
202        202
203        203
204        204
205        205
206        206
207        207
208        208
209        209
210        210
211        211
212        212
213        213
214        214
215        215
216        216
217        217
218        218
219        219
220        220
221        221
222        222
223        223
224        224
225        225
226        226
227        227
228        228
229        229
230        230
231        231
232        232
233        233
234        234
235        235
236        236
237        237
238        238
239        239
240        240
241        241
242        242
243        243
244        244
245        245
246        246
247        247
248        248
249        249
250        250
251        251
252        252
253        253
254        254
255        255
256        256
257        257
258        258
259        259
260        260
261        261
262        262
263        263
264        264
265        265
266        266
267        267
268        268
269        269
270        270
271        271
272        272
273        273
274        274
275        275
276        276
277        277
278        278
279        279
280        280
281        281
282        282
283        283
284        284
285        285
286        286
287        287
288        288
289        289
290        290
291        291
292        292
293        293
294        294
295        295
296        296
297        297
298        298
299        299
300        300
301        301
302        302
303        303
304        304
305        305
306        306
307        307
308        308
309        309
310        310
311        311
312        312
313        313
314        314
315        315
316        316
317        317
318        318
319        319
320        320
321        321
322        322
323        323
324        324
325        325
326        326
327        327
328        328
329        329
330        330
/;


*inspection time
parameter TI;
TI=30;

*humping jobs minimum interval
parameter HI;
HI=8;

*assmbling job TP
parameter TP;
TP=10;

*maximum  number of cars in a single outbound train
parameter N_max_o;
N_max_o=50;

*minimum number of cars in a single outbound train
parameter N_min_o;
N_min_o=20;

*classification track ID, max number of cars can be stored on classification track
parameter N_max;
N_max=60;

parameter M;
M=1000;


*inbound train i arrival time
parameter Arr(i)   arrival time of inbound train i
/
1        1
2        10
3        30
4        42
5        55
6        65
/;


*destiation, inbound train ID, number of railcars
parameter n(b,i)  the number of railcars with block type b in inbound train i
/
1        .        1        15
2        .        1        15
3        .        1        14
3        .        2        20
4        .        2        23
1        .        3        18
2        .        3        9
3        .        3        13
3        .        4        20
4        .        4        17
1        .        5        17
2        .        5        16
1        .        6        15
2        .        6        15
3        .        6        14
/;

*inbound train ID, humping time duration , calculated from hump rates and # of cars in train i
parameter TH(i)  the humping time of inbound train i
/
1        22
2        22
3        20
4        19
5        17
6        22
/;

*classification track ID, destination, accept param
parameter Phi(k,b)   equals 1 if the classification track k accepts railcar with destination b
/
1   .   1     1
2   .   2     1
3   .   3     1
4   .   4     1
/;



*combination of blocks accepted by
parameter BO(b,t)   combination of blocks accepted by outbound train o at the departure time t
/
3        .        210        1
4        .        225        1
1        .        242        1
2        .        258        1
3        .        275        1
2        .        290        1
1        .        305        1
/;

*departure time of outbound train o
parameter Dep(o) departure time of outbound train o
/
1        210
2        225
3        242
4        258
5        275
6        290
7        305
/;

*departure time of outbound train o
parameter DT(t) departure time of outbound train o
/
210        1
225        1
242        1
258        1
275        1
290        1
305        1
/;

positive variables

Ts(i)           humping job start time of inbound train i
Te(i)           humping job end time of inbound train i

A_k(k,t)        cumulative arrival number of cars
D_k(k,t)        cumulative departure number of cars

fin(b,t)        inflow of railcars going to destination b processed by pullback engine at time t
s(b,t)           supply variable
fout(b,t)       outflow of railcars going to destination b processed by pullback engine at time t
Nc(o)            number of railcars assemblied into outbound train o

;
binary variables
Delta(i,j)       humping job sequence variables that equals 1 when inbound train i is humped before inbound train j
X(i,t)           humping job end variable that equals 1 when humping job of inbound train i ends at time t
Y_k(k,t)         track open-close status variable that equals 1 when track k open at time t

;


variable
obj  objective for MIP formulation
;

equations

*Group I : Humping Jobs of Inbound Trains
*(1)Definitional constraints
*HJS(i)
HJE(i)
THJES(i,t)
THJE(i)
*(2)Humping job starts after technical inspection of inbound train
HSTI(i)
*(3)Humping job duration time of inbound train i
HJDT(i)
*(4)Humping jobs schedule rules
HJSR_1(i,j)
HJSR_2(i,j)

*(5)End time of Humping job
THJET(i)
*Group II : Sorting Railcars
*(6)  Definitional constrains
SAk(k)
SDk(k)
AAk(k,t)
DDk(k,t)
DAk(k,t)
*(7)Humping Job Flow balance from inbound trains to railcars
FBIR(k,t)
*(8) Maximum Railcar Storage Constraint
TrackCapacity(t,k)
TrackOutflowCons(k,t)
*(9) Railcars processed is less than Exisiting Railcars
ExistingRailcars(k,t)
*(10) Only one track is processed by Pullback Engine
NumberOfTracksProcessed(t)
*(11) One assembling job duration time lasts TP on one single track
TPcon(t)

*Group III : Assembling Outbound Trains
*(12)Assembling Job Flow balance from railcars to outbound trains
FBRO(b,t)
*(13)Assembling Job inFlow and outFlow balance
FOUTS(b,t)
*(14)Lot-sizing Model
lsis(b,t)
lsido(b,t)
lsfl(b,t)
lsinfl(b,t)

*(15)Assembling Outbound train o Flow Balance
OFL(b,t)

*(16)the number of railcars assembled into outbound train o
NCOT(o,t)

*(17) Outbound Train Size Constraints
MinTrainSize(o)
MaxTrainSize(o)

def_obj
;

******** Constraints ********
*Group I : Humping Jobs of Inbound Trains
*(1)Definitional constraints
HJE(i)..Te(i) =l= 330;
THJES(i,t)$(val_time(t)<=Arr(i)+TI-1)..X(i,t)=e=0;
THJE(i)..sum(t,X(i,t)) =l= 1;
*(2)Humping job starts after technical inspection of inbound train
HSTI(i)..Ts(i) =g= Arr(i)+TI;
*(3)Humping job duration time of inbound train i
HJDT(i)..Te(i)-Ts(i) =g= TH(i);
*(4)Humping jobs schedule rules
HJSR_1(i,j)$(val_InTrain(i)<>val_InTrain(j))..Ts(j)-Te(i) =g= HI-(1-Delta(i,j))*M;
HJSR_2(i,j)$(val_InTrain(i)<>val_InTrain(j))..Ts(i)-Te(j) =g= HI-Delta(i,j)*M;
*(5)End time of Humping job
THJET(i)..Te(i) =e= sum(t,X(i,t)*val_time(t));

*Group II : Sorting Railcars
*(6)  Definitional constrains
SAk(k) .. A_k(k,'0') =e= 0;
SDk(k) .. D_k(k,'0') =e= 0;
AAk(k,t) .. A_k(k,t-1) =l= A_k(k,t);
DDk(k,t) .. D_k(k,t-1) =l= D_k(k,t);
DAk(k,t) .. D_k(k,t) =l= A_k(k,t);

*(7)Humping Job Flow balance from inbound trains to railcars
FBIR(k,t)..A_k(k,t)-A_k(k,t-1) =e= sum((i,b),X(i,t)*n(b,i)*Phi(k,b));
*(8) Maximum Railcar Storage Constraint
TrackCapacity(t,k) .. A_k(k,t)-D_k(k,t) =l= N_max;
TrackOutflowCons(k,t) .. D_k(k,t)-D_k(k,t-1) =l= N_max*Y_k(k,t);
*(9) Railcars processed is less than Exisiting Railcars
ExistingRailcars(k,t) .. D_k(k,t)-D_k(k,t-1) =l= A_k(k,t-1)-D_k(k,t-1);
*(10) Only one track is processed by Pullback Engine
NumberOfTracksProcessed(t) .. sum(k,Y_k(k,t)) =l= 1;
*(11) One assembling job duration time lasts TP on one single track
TPcon(t)..sum(k,Y_k(k,t)+Y_k(k,t+1)+Y_k(k,t+2)+Y_k(k,t+3)+Y_k(k,t+4)+Y_k(k,t+5)+Y_k(k,t+6)+Y_k(k,t+7)+Y_k(k,t+8)+Y_k(k,t+9))=l=1;

*Group III : Assembling Outbound Trains
*(12)Assembling Job Flow balance from railcars to outbound trains
FBRO(b,t)..fin(b,t+TP)=e=sum(k,(D_k(k,t)-D_k(k,t-1))*Phi(k,b));
*(13)Assembling Job inFlow and outFlow balance
FOUTS(b,t)$(val_time(t)<=TP-1)..fin(b,t)=e=0;
*(14)Lot-sizing Model
lsis(b,t)$(val_time(t)<=TP-1)..s(b,t) =e= 0;
lsido(b,t)$(val_time(t)<=TP-1)..fout(b,t) =e= 0;
lsfl(b,t)..fin(b,t)+s(b,t-1)=e= s(b,t)+fout(b,t);
lsinfl(b,t)..fin(b,t) =l= sum(k,Y_k(k,t-TP)*Phi(k,b))*N_max ;

*(15)Outflow limitation
OFL(b,t)..fout(b,t) =l=N_max_o*BO(b,t);

*(16)the number of railcars assembled into outbound train o
NCOT(o,t)$(val_time(t)=Dep(o))..Nc(o) =e= sum(b,fout(b,t));

*(17) Outbound Train Size Constraints
MinTrainSize(o)..Nc(o) =g= N_min_o;
MaxTrainSize(o)..Nc(o) =l= N_max_o;

def_obj .. obj =e=sum(o,(330-Dep(o))*Nc(o));

MODEL Railroad_Yard_Operation/all/ ;
* SO
SOLVE Railroad_Yard_Operation using MIP maximizing obj;

display Ts.l, Te.l, A_k.l, D_k.l,Delta.l, X.l, Y_k.l,fin.l, s.l,fout.l,Nc.l;
