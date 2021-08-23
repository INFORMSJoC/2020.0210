* randomInstances\30perc\rand_15_8_10_4_10\rand10

set s /s1*s15/;
set j /j1*j8/;
set p /p1*p10/;
set k /k1*k4/;


alias(s,sp);
alias(p,pp);

parameter epsilon(s)  / S1 190, S2 78, S3 126, S4 139, S5 75, S6 127, S7 148, S8 101, S9 181, S10 187, S11 158, S12 147, S13 112, S14 155, S15 106 /;
parameter capacity(j)    / J1 588, J2 256, J3 374, J4 758, J5 705, J6 627, J7 498, J8 741 /;

parameter scost(s)/ S1 4, S2 3, S3 2, S4 1, S5 2, S6 1, S7 1, S8 2, S9 1, S10 4, S11 3, S12 2, S13 3, S14 3, S15 4 /;

parameter cost(s,j);
cost(s,j) = scost(s);

parameter cost_Fixed(j,p);

parameter price(j,p);

parameter omega(p)/ p1 150, p2 300, p3 300, p4 300, p5 300, p6 150, p7 300, p8 300, p9 300, p10 300 /;

parameter pprice(p)  / p1 3, p2 12, p3 33, p4 27, p5 18, p6 9, p7 3, p8 27, p9 21, p10 15 /;
price(j,p) = pprice(p);

table Tsigma(s,k)
    K1  K2  K3  K4  
S1  7   8   5   3 
S2  1   5   10  1 
S3  5   9   4   3 
S4  4   4   1   2 
S5  7   3   4   7 
S6  1   11  2   9 
S7  2   1   11  7 
S8  7   8   4   1 
S9  2   9   3   11  
S10 11  1   11  4 
S11 8   2   5   9 
S12 3   3   10  7 
S13 5   11  2   5 
S14 8   3   1   7 
S15 2   9   2   6 

parameter sigma(k,s);
sigma(k,s) = Tsigma(s,k);

table Tsigma_U(p,k)
    K1  K2  K3  K4  
p1  9   7   5   8 
p2  4   7   4   2 
p3  4   8   4   1 
p4  9   4   7   4 
p5  5   4   2   9 
p6  6   4   6   4 
p7  4   7   1   9 
p8  6   8   6   4 
p9  7   8   3   4 
p10 5   5   5   8 

parameter sigma_U(k,p);
sigma_U(k,p) = Tsigma_U(p,k);

parameter Xi(j,p);
Xi(j,p) = capacity(j);

cost_Fixed(j,p) = 0;

set t /t1*t2/;