* poolinginstances\datfiles\adhya1

set s /s1*s5/;
set j /j1*j2/;
set p /p1*p4/;
set k /k1*k4/;


alias(s,sp);
alias(p,pp);

parameter epsilon(s)  /   S1  75, S2 75, S3 75, S4 75, S5 75   /;
parameter capacity(j)    / J1 75, J2 75 /;

parameter scost(s) /S1   7, S2  3, S3  2, S4 10, S5  5 /;

parameter cost(s,j);
cost(s,j) = scost(s);

parameter cost_Fixed(j,p);

parameter price(j,p);

parameter omega(p)/p1  10, p2  25, p3 30, p4 10 /;

parameter pprice(p)  /  p1 16, p2 25, p3 15, p4 10  /;
price(j,p) = pprice(p);

table Tsigma(s,k)
         K1   K2   K3   K4
S1       1    6    4    0.5
S2       4    1    3    2
S3       4    5.5  3    0.9
S4       3    3    3    1
S5       1    2.7  4    1.6

parameter sigma(k,s);
sigma(k,s) = Tsigma(s,k);

table Tsigma_U(p,k)
         K1    K2   K3    K4 
p1       3     3    3.25  0.75
p2       4     2.5  3.5   1.5
p3       1.5   5.5  3.9   0.8
p4       3     4    4     1.8

parameter sigma_U(k,p);
sigma_U(k,p) = Tsigma_U(p,k);

parameter Xi(j,p);
Xi(j,p) = 0.7*capacity(j);

cost_Fixed(j,p) = price(j,p);

set t /t1*t8/;
epsilon(s) = epsilon(s)*8
