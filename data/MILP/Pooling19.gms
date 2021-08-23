* randomInstances\30perc\rand_15_8_10_4_10\rand9

set s /s1*s15/;
set j /j1*j8/;
set p /p1*p10/;
set k /k1*k4/;


alias(s,sp);
alias(p,pp);

parameter epsilon(s)  / S1 110, S2 164, S3 172, S4 82, S5 179, S6 142, S7 168, S8 98, S9 108, S10 152, S11 132, S12 124, S13 106, S14 130, S15 168  /;
parameter capacity(j)    / J1 683, J2 889, J3 410, J4 464, J5 904, J6 492, J7 371, J8 928 /;

parameter scost(s)/S1 4, S2 1, S3 2, S4 3, S5 6, S6 3, S7 3, S8 3, S9 2, S10 2, S11 2, S12 1, S13 4, S14 3, S15 3  /;

parameter cost(s,j);
cost(s,j) = scost(s);

parameter cost_Fixed(j,p);

parameter price(j,p);

parameter omega(p)/p1 300, p2 300, p3 150, p4 150, p5 150, p6 300, p7 150, p8 300, p9 150, p10 300 /;

parameter pprice(p)  / p1 15, p2 3, p3 30, p4 30, p5 3, p6 3, p7 18, p8 27, p9 6, p10 9 /;
price(j,p) = pprice(p);

table Tsigma(s,k)
    K1  K2  K3  K4  
S1  8   8   1   3 
S2  10  11  4   3 
S3  5   10  1   11  
S4  2   4   3   2 
S5  4   7   2   7 
S6  11  8   8   9 
S7  8   10  11  8 
S8  6   6   9   2 
S9  2   7   2   9 
S10 6   6   11  11  
S11 4   9   8   4 
S12 11  10  5   3 
S13 3   6   9   1 
S14 11  3   9   8 
S15 10  6   2   5 

parameter sigma(k,s);
sigma(k,s) = Tsigma(s,k);

table Tsigma_U(p,k)
    K1  K2  K3  K4  
p1  4   8   3   3 
p2  5   5   1   8 
p3  6   3   5   10  
p4  7   8   8   10  
p5  6   4   4   5 
p6  7   2   6   3 
p7  6   6   4   1 
p8  3   2   5   6 
p9  9   6   8   4 
p10 10  6   4   7 

parameter sigma_U(k,p);
sigma_U(k,p) = Tsigma_U(p,k);

parameter Xi(j,p);
Xi(j,p) = capacity(j);

cost_Fixed(j,p) = 0;

set t /t1*t2/;