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
Sets comp Components and Raw Materials / c1*c6 /
     pro  Products                     / p1*p4 /
     qual Qualities                    / q1 /
     pool Pools                        / o1*o2 /

  
parameter cl(comp)     / c1   0, c2   0, c3   0, c4 0, c5 0, c6 0 /
parameter cu(comp)     / c1 600, c2 600, c3 600, c4 600, c5 600, c6 600 /
parameter cprice(comp) / c1   6, c2  16, c3  10, c4 3, c5 13, c6 7 /
parameter prl(pro) prod lb / p1   0, p2   0, p3 0, p4 0 /
parameter pru(pro) prod ub / p1 100, p2 200, p3 100, p4 200 /
parameter pprice(pro) prod price / p1 9, p2 15, p3 6, p4 12 /
parameter psize(pool) pool capacity / o1 600, o2 600 /



table ComponentQuality(comp,qual)
      q1
c1     3
c2     1
c3     2
c4   3.5
c5   1.5
c6   2.5


table ProductQualityLower(pro,qual)
      q1
p1   


table ProductQualityUpper(pro,qual)
      q1
p1    2.5
p2    1.5
p3    3
p4    2


table ComponentPoolFraction(comp,pool)  upper bound on q
      o1   o2 
c1    1
c2    1
c3
c4         1
c5         1
c6


table PoolProductBound(pool,pro) upper bound on y
         p1   p2   p3   p4
o1*o2   100  200  100  200



table ComponentProductBound(comp,pro)  upper bound on z
        p1      p2      p3    p4 
c3     100     200     100   200
c6     100     200     100   200

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
cost_fixed(pool,pro) = 0.3*price(pool,pro);

parameter capacity(pool),omega(pro),Xi(pool,pro);
capacity(pool) = psize(pool);
omega(pro) = pru(pro);
Xi(pool,pro) = PoolProductBound(pool,pro);
