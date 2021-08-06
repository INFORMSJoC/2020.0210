******************************
* DATA SECTION
******************************

$eolcom //
Sets comp Components and Raw Materials / c1*c15 /
     pro  Products                     / p1*p10 /
     qual Qualities                    / q1*q2 /
     pool Pools                        / o1*o8 /

parameter cl(comp)     / c1 0, c2 0, c3 0, c4 0, c5 0, c6 0, c7 0, c8 0, c9 0, c10 0, c11 0, c12 0, c13 0, c14 0, c15 0 /
parameter cu(comp)     / c1 98, c2 93, c3 192, c4 145, c5 124, c6 102, c7 112, c8 153, c9 196, c10 182, c11 93, c12 176, c13 180, c14 194, c15 91 /
parameter cprice(comp)     / c1 4, c2 6, c3 2, c4 1, c5 3, c6 4, c7 1, c8 6, c9 2, c10 3, c11 1, c12 15, c13 1, c14 4, c15 6 /
parameter prl(pro)     / p1 0, p2 0, p3 0, p4 0, p5 0, p6 0, p7 0, p8 0, p9 0, p10 0 /
parameter pru(pro)     / p1 150, p2 300, p3 150, p4 300, p5 300, p6 150, p7 150, p8 300, p9 150, p10 300 /
parameter pprice(pro)     / p1 30, p2 30, p3 3, p4 3, p5 33, p6 9, p7 18, p8 33, p9 18, p10 9 /
parameter psize(pool)     / o1 492, o2 719, o3 594, o4 714, o5 1132, o6 650, o7 341, o8 911 /

table ComponentQuality(comp,qual)
	q1	q2	
c1	2	3	
c2	6	3	
c3	6	7	
c4	2	10	
c5	7	10	
c6	6	3	
c7	11	9	
c8	5	4	
c9	11	4	
c10	3	11	
c11	3	8	
c12	2	2	
c13	4	9	
c14	6	4	
c15	4	5	

table ProductQualityLower(pro,qual)
	q1	q2	
p1	2	1	
p2	0	0	
p3	2	0	
p4	1	2	
p5	1	2	
p6	1	0	
p7	2	0	
p8	0	1	
p9	1	2	
p10	2	0	

table ProductQualityUpper(pro,qual)
	q1	q2	
p1	5	3	
p2	2	4	
p3	3	2	
p4	2	6	
p5	6	8	
p6	2	3	
p7	3	5	
p8	8	5	
p9	8	8	
p10	10	7	

table ComponentPoolFraction(comp,pool)
	o1	o2	o3	o4	o5	o6	o7	o8	
c1	0	0	0	0	1	0	0	1	
c2	1	0	1	1	0	1	0	0	
c3	0	1	0	0	1	0	0	1	
c4	0	0	1	1	0	0	1	0	
c5	1	0	0	0	1	0	0	0	
c6	0	0	0	1	1	1	0	0	
c7	0	0	0	0	0	0	0	1	
c8	0	1	0	0	1	0	0	1	
c9	0	0	0	0	0	0	1	0	
c10	1	0	0	0	0	1	0	0	
c11	1	0	0	0	1	1	0	0	
c12	0	0	1	0	1	0	0	1	
c13	0	1	1	1	0	1	0	1	
c14	0	1	0	1	1	0	0	0	
c15	0	0	0	0	0	0	0	0	

table PoolProductBound(pool,pro)
	p1	p2	p3	p4	p5	p6	p7	p8	p9	p10	
o1	0	0	0	300	0	0	150	300	0	300	
o2	0	300	150	300	0	150	150	0	0	300	
o3	0	0	150	0	0	150	0	0	150	0	
o4	0	0	0	0	0	0	0	0	0	300	
o5	0	0	150	0	0	0	0	300	0	0	
o6	0	0	0	0	0	0	150	300	150	300	
o7	0	0	0	300	300	150	0	0	0	0	
o8	0	0	150	0	0	0	0	0	0	0	

table ComponentProductBound(comp,pro)
	p1	p2	p3	p4	p5	p6	p7	p8	p9	p10	
c1	0	0	0	0	0	0	0	0	0	0	
c2	0	0	0	0	0	0	0	0	0	0	
c3	0	0	0	0	0	0	0	0	0	0	
c4	0	0	0	0	0	0	0	0	0	0	
c5	0	0	0	0	0	0	0	0	0	0	
c6	0	0	0	0	0	0	0	0	0	0	
c7	0	0	0	0	0	0	0	0	0	0	
c8	0	0	0	0	0	0	0	0	0	0	
c9	0	0	0	0	0	0	0	0	0	0	
c10	0	0	0	0	0	0	0	0	0	0	
c11	0	0	0	0	0	0	0	0	0	0	
c12	0	0	0	0	0	0	0	0	0	0	
c13	0	0	0	0	0	0	0	0	0	0	
c14	0	0	0	0	0	0	0	0	0	0	
c15	0	0	0	0	0	0	0	0	0	0	



option optcr=0.0, optca=1e-6;

set t /t1*t6/;

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

