* poolinginstances\datfiles\adhya3

set s /s1*s8/;
set j /j1*j3/;
set p /p1*p4/;
set k /k1*k6/;


alias(s,sp);
alias(p,pp);

parameter epsilon(s)  / S1  75, S2 75, S3 75, S4 75, S5 75, S6 75, S7 75, S8 75/;
parameter capacity(j)    / J1 75, J2 75, J3 75/;

parameter scost(s) /S1   7, S2  3, S3  2, S4 10, S5  5, S6  5, S7  9, S8 11/;

parameter cost(s,j);
cost(s,j) = scost(s);

parameter cost_Fixed(j,p);

parameter price(j,p);

parameter omega(p)/ p1  10, p2  25, p3 30, p4 10 /;

parameter pprice(p)  / p1 16, p2 25, p3 15, p4 10  /;
price(j,p) = pprice(p);

table Tsigma(s,k)
        K1   K2   K3   K4   K5   K6
S1       1    6    4  0.5    5    9
S2       4    1    3    2    4    4
S3       4  5.5    3  0.9    7   10
S4       3    3    3    1    3    4
S5       1  2.7    4  1.6    3    7
S6     1.8  2.7    4  3.5  6.1    3
S7       5    1  1.7  2.9  3.5  2.9
S8       3    3    3    1    5    2

parameter sigma(k,s);
sigma(k,s) = Tsigma(s,k);

table Tsigma_U(p,k)
        K1    K2    K3    K4    K5    K6
p1       3     3  3.25  0.75    6     5
p2       4   2.5  3.5   1.5     7     6
p3     1.5   5.5  3.9   0.8     7     6
p4       3     4    4   1.8     8     6

parameter sigma_U(k,p);
sigma_U(k,p) = Tsigma_U(p,k);

table Xi(j,p)
          p1   p2   p3   p4
j1        10   25   30   10
j2        10   10   25   30
j3        30   10   10   25
;

cost_Fixed(j,p) = price(j,p);

set t /t1*t6/;
epsilon(s) = epsilon(s)*card(t);
omega(p) = omega(p)*card(t);