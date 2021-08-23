set s /s1*s15/;
set j /j1*j10/;
set p /p1*p10/;
set k /k1/;

alias(s,sp);
alias(p,pp);

parameter epsilon(s) / S1 179, S2 150, S3 104, S4 185, S5 172, S6 126, S7 97, S8 137, S9 112, S10 190, S11 125, S12 78, S13 175, S14 94, S15 100 /;
parameter capacity(j)/ j1 298, j2 363, j3 922, j4 628, j5 691, j6 684, j7 837, j8 172, j9 613, j10 215 /;

parameter scost(s) / S1 20, S2 3, S3 3, S4 1, S5 2, S6 6, S7 20, S8 5, S9 1, S10 15, S11 3, S12 1, S13 6, S14 3, S15 3 /;
parameter cost(s,j);
cost(s,j) = scost(s);

parameter cost_Fixed(j,p);

parameter price(j,p);


parameter omega(p)/ p1 300, p2 300, p3 300, p4 300, p5 300, p6 150, p7 300, p8 300, p9 300, p10 150 / ;

parameter pprice(p) / p1 33, p2 9, p3 24, p4 12, p5 18, p6 33, p7 6, p8 6, p9 12, p10 27 /;
price(j,p) = pprice(p);


table Tsigma(s,k)
        k1
S1      1
S2      7
S3      3
S4      9
S5      9
S6      3
S7      1
S8      2
S9      10
S10     2
S11     10
S12     9
S13     5
S14     3
S15     6

parameter sigma(k,s);
sigma(k,s) = Tsigma(s,k);

table Tsigma_U(p,k)
        k1
p1      4
p2      5
p3      3
p4      4
p5      6
p6      4
p7      4
p8      5
p9      7
p10     3

parameter sigma_U(k,p);
sigma_U(k,p) = Tsigma_U(p,k);

parameter Xi(j,p);
Xi(j,p) = 0.7*capacity(j);

cost_Fixed(j,p) = 0;

set t /t1*t2/;
