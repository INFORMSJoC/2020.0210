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
Sets comp Components and Raw Materials / c1*c8 /
     pro  Products                     / p1*p5 /
     qual Qualities                    / q1*q4 /
     pool Pools                        / o1*o2 /

  
parameter cl(comp)     / c1   0, c2   0, c3   0, c4  0, c5  0, c6  0, c7  0, c8  0 /
parameter cu(comp)     / c1  85, c2  85, c3  85, c4 85, c5 85, c6 85, c7 85, c8 85 /
parameter cprice(comp) / c1  15, c2   7, c3   4, c4  5, c5  6, c6  3, c7  5, c8  5 /
parameter prl(pro) prod lb / p1  0, p2  0, p3  0, p4  0, p5 0 /
parameter pru(pro) prod ub / p1 15, p2 25, p3 10, p4 20, p5 15 /
parameter pprice(pro) prod price / p1 10, p2 25, p3 30, p4  6, p5 10 /
parameter psize(pool) pool capacity / o1 85, o2 85 /


table ComponentQuality(comp,qual)
        q1   q2   q3   q4
c1     0.5  1.9  1.3    1
c2     1.4  1.8  1.7  1.6
c3     1.2  1.9  1.4  1.4
c4     1.5  1.2  1.7  1.3
c5     1.6  1.8  1.6    2
c6     1.2  1.1  1.4    2
c7     1.5  1.5  1.5  1.5
c8     1.4  1.6  1.2  1.6


table ProductQualityLower(pro,qual)
      q1
p1   


table ProductQualityUpper(pro,qual)
       q1    q2    q3    q4
p1     1.2   1.7  1.4   1.7
p2     1.4   1.3  1.8   1.4
p3     1.3   1.3  1.9   1.9
p4     1.2   1.1  1.7   1.6
p5     1.6   1.9    2   2.5



table ComponentPoolFraction(comp,pool)  upper bound on q
       o1   o2
c1     1
c2     1
c3     1
c4     1
c5          1
c6          1
c7          1
c8          1



table PoolProductBound(pool,pro) upper bound on y
          p1   p2   p3   p4   p5
o1        15   25   10   20   15
o2        10   20   15   15   25


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
cost_fixed(pool,pro) = 0;

parameter capacity(pool),omega(pro),Xi(pool,pro);
capacity(pool) = psize(pool);
omega(pro) = pru(pro);
Xi(pool,pro) = PoolProductBound(pool,pro);

Xi(pool,pro) = 0.8*Xi(pool,pro);