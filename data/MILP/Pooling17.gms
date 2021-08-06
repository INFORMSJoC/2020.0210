set s /s1*s15/;
set j /j1*j10/;
set p /p1*p10/;
set k /k1*k2/;

alias(s,sp);
alias(p,pp);

parameter epsilon(s)  / s1 134, s2 86, s3 172, s4 179, s5 112, s6 85, s7 111, s8 85, s9 166, s10 182, s11 149, s12 84, s13 115, s14 104, s15 192 / ;
parameter capacity(j)  / j1 428, j2 530, j3 466, j4 234, j5 469, j6 223, j7 381, j8 879, j9 388, j10 215 /   ;

parameter scost(s) / s1 1, s2 10, s3 3, s4 9, s5 6, s6 2, s7 1, s8 3, s9 3, s10 4, s11 2, s12 6, s13 10, s14 0, s15 2 /;
parameter cost(s,j);
cost(s,j) = scost(s);

parameter cost_Fixed(j,p);

parameter price(j,p);


parameter omega(p) / p1 300, p2 150, p3 150, p4 150, p5 150, p6 150, p7 150, p8 300, p9 300, p10 150 /  ;

parameter pprice(p)  / p1 30, p2 18, p3 18, p4 27, p5 21, p6 33, p7 9, p8 9, p9 24, p10 33 /;
price(j,p) = pprice(p);


table Tsigma(s,k)
        k1      k2
s1      10      9
s2      2       2
s3      7       6
s4      1       5
s5      1       2
s6      11      8
s7      7       5
s8      3       10
s9      9       5
s10     9       1
s11     4       8
s12     2       8
s13     1       1
s14     10      11
s15     2       5

parameter sigma(k,s);
sigma(k,s) = Tsigma(s,k);

table Tsigma_U(p,k)
        k1      k2
p1      4       10
p2      6       3
p3      2       3
p4      4       5
p5      8       3
p6      8       1
p7      3       6
p8      3       4
p9      7       3
p10     9       5

parameter sigma_U(k,p);
sigma_U(k,p) = Tsigma_U(p,k);

table Xi(j,p)
        p1      p2      p3      p4      p5      p6      p7      p8      p9      p10
j1      0       0       0       0       0       0       0       0       0       0
j2      0       150     0       0       0       150     0       0       0       0
j3      0       0       0       150     0       0       0       0       300     150
j4      234     0       0       0       0       0       0       0       234     0
j5      0       0       150     0       150     150     0       0       0       0
j6      0       150     0       0       0       0       0       0       0       150
j7      0       0       0       0       0       0       0       0       0       0
j8      0       150     0       0       0       0       0       300     300     150
j9      0       0       0       0       0       0       150     0       0       0
j10     0       0       0       0       0       150     0       0       0       0
;

cost_Fixed(j,p) = 0;

set t /t1*t2/;