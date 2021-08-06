$title The Pooling Problem (POOL,SEQ=254)

$ontext
This model presents a number of pooling problems from the
literature in a unified framework. It represents the
pq-formulation as of the pooling problem described in:

M. Tawarmalani and N. V. Sahinidis, in "Convexification
and Global Optimization of the Pooling Problem," May 2002,
Mathematical Programming, submitted.

All 14 problems have known global solutions.

MODIFIED BY CLAUDIA D'AMBROSIO, ISyE Department, University of Wisconsin-Madison
$offtext


******************************
* DATA SECTION
******************************

$eolcom //
Sets comp Components and Raw Materials / c1*c5 /
     pro  Products                     / p1*p4 /
     qual Qualities                    / q1*q4 /
     pool Pools                        / o1*o2 /

  
parameter cl(comp)     / c1   0, c2  0, c3  0, c4  0, c5  0 /
parameter cu(comp)     / c1  75, c2 75, c3 75, c4 75, c5 75 /
parameter cprice(comp) / c1   7, c2  3, c3  2, c4 10, c5  5 /
parameter prl(pro) prod lb / p1   0, p2   0, p3  0, p4  0 /
parameter pru(pro) prod ub / p1  10, p2  25, p3 30, p4 10 /
parameter pprice(pro) prod price / p1 16, p2 25, p3 15, p4 10 /
parameter psize(pool) pool capacity / o1 75, o2 75 /


table ComponentQuality(comp,qual)
        q1   q2   q3   q4
c1       1    6    4  0.5
c2       4    1    3    2
c3       4  5.5    3  0.9
c4       3    3    3    1
c5       1  2.7    4  1.6

table ProductQualityLower(pro,qual)
      q1
p1   


table ProductQualityUpper(pro,qual)
        q1    q2    q3    q4 
p1       3     3  3.25  0.75
p2       4   2.5  3.5   1.5
p3     1.5   5.5  3.9   0.8
p4       3     4    4   1.8


table ComponentPoolFraction(comp,pool)  upper bound on q
      o1   o2
c1     1
c2     1
c3          1
c4          1
c5          1


table PoolProductBound(pool,pro) upper bound on y
          p1   p2   p3   p4
o1        10   25   30   10
o2        30   10   10   25


table ComponentProductBound(comp,pro)  upper bound on z
       p1
c1     

set t /t1*t5/;

parameter epsilon(comp);
epsilon(comp) = cu(comp);
epsilon(comp) = card(t)*epsilon(comp);

parameter sigma(qual,comp),sigma_U(qual,pro);
sigma(qual,comp) = ComponentQuality(comp,qual);
sigma_U(qual,pro) = ProductQualityUpper(pro,qual);

alias(comp,compp);

parameter price(pool,pro),cost_fixed(pool,pro),cost(comp,pool);
cost(comp,pool) = cprice(comp);
price(pool,pro) = pprice(pro);
cost_fixed(pool,pro) = 0.3*pprice(pro);

parameter capacity(pool),omega(pro),Xi(pool,pro);
capacity(pool) = psize(pool);
omega(pro) = pru(pro);
Xi(pool,pro) = PoolProductBound(pool,pro);

omega(pro) = card(t)*omega(pro);