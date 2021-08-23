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
Sets comp Components and Raw Materials / c1*c13 /
     pro  Products                     / p1*p5 /
     qual Qualities                    / q1*q2 /
     pool Pools                        / o1*o3 /

  
parameter cl(comp)     / c1   0, c2   0, c3   0, c4   0, c5 0, c6 0, c7 0, c8 0, c9 0, c10 0, c11 0, c12 0, c13 0 /
parameter cu(comp)     / c1 600, c2  600, c3 600, c4 600, c5 600, c6 600, c7 600, c8 600, c9 600, c10 600, c11 600, c12 600, c13 600 /
parameter cprice(comp) / c1   6, c2  16, c3  15, c4  12, c5 6, c6 16, c7 15, c8 12, c9 6, c10 16, c11 15, c12 12, c13 10 /
parameter prl(pro) prod lb / p1   0, p2   0 , p3 0, p4 0, p5 0/
parameter pru(pro) prod ub / p1 100, p2 200, p3 100, p4 100, p5 100 /
parameter pprice(pro) prod price / p1 18, p2 15, p3 19, p4 16, p5 14 /
parameter psize(pool) pool capacity / o1 600, o2 600, o3 600 /


table ComponentQuality(comp,qual)
       q1    q2 
c1      3     1
c2      1     3
c3    1.2     5
c4    1.5   2.5
c5      3     1
c6      1     3
c7    1.2     5
c8    1.5   2.5
c9      3     1
c10     1     3
c11   1.2     5
c12   1.5   2.5
c13     2   2.5


table ProductQualityLower(pro,qual)
      q1
p1   


table ProductQualityUpper(pro,qual)
       q1    q2
p1     2.5   2
p2     1.5   2.5
p3       2   2.6
p4       2   2
p5       2   2



table ComponentPoolFraction(comp,pool)  upper bound on q
      o1   o2   o3
c1     1
c2     1
c3     1
c4     1
c5          1
c6          1
c7          1
c8          1
c9               1
c10              1
c11              1
c12              1
c13



table PoolProductBound(pool,pro) upper bound on y
          p1   p2   p3   p4   p5
o1       100  200  100  100  100
o2       100  100  100  200  100
o3       200  100  100  100  100


table ComponentProductBound(comp,pro)  upper bound on z
         p1      p2      p3    p4    p5
c13     100     200     100   100   100



set t /t1*t4/;

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
cost_fixed(pool,pro) = 0;

parameter capacity(pool),omega(pro),Xi(pool,pro);
capacity(pool) = psize(pool);
omega(pro) = pru(pro);
Xi(pool,pro) = PoolProductBound(pool,pro);

Xi(pool,pro) = 0.6*Xi(pool,pro);

omega(pro) = card(t)*omega(pro);
