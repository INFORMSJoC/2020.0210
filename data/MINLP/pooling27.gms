******************************
* DATA SECTION
******************************

$eolcom //
Sets comp Components and Raw Materials / c1*c15 /
     pro  Products                     / p1*p10 /
     qual Qualities                    / q1*q4 /
     pool Pools                        / o1*o5 /

parameter cl(comp)     / c1 0, c2 0, c3 0, c4 0, c5 0, c6 0, c7 0, c8 0, c9 0, c10 0, c11 0, c12 0, c13 0, c14 0, c15 0 /
parameter cu(comp)     / c1 193, c2 199, c3 166, c4 142, c5 200, c6 117, c7 192, c8 130, c9 147, c10 85, c11 91, c12 180, c13 111, c14 189, c15 167 /
parameter cprice(comp)     / c1 2, c2 1, c3 4, c4 1, c5 1, c6 3, c7 4, c8 6, c9 6, c10 2, c11 2, c12 2, c13 3, c14 6, c15 2 /
parameter prl(pro)     / p1 0, p2 0, p3 0, p4 0, p5 0, p6 0, p7 0, p8 0, p9 0, p10 0 /
parameter pru(pro)     / p1 300, p2 300, p3 300, p4 300, p5 300, p6 300, p7 300, p8 300, p9 300, p10 150 /
parameter pprice(pro)     / p1 3, p2 30, p3 21, p4 3, p5 12, p6 12, p7 6, p8 24, p9 12, p10 24 /
parameter psize(pool)     / o1 839, o2 558, o3 926, o4 588, o5 271 /

table ComponentQuality(comp,qual)
	q1	q2	q3	q4	
c1	3	9	2	4	
c2	7	11	6	9	
c3	1	9	1	7	
c4	1	11	9	10	
c5	7	7	6	9	
c6	5	6	10	4	
c7	3	11	1	5	
c8	6	2	1	6	
c9	8	2	7	3	
c10	11	1	1	11	
c11	9	1	6	8	
c12	10	3	4	5	
c13	8	9	11	10	
c14	2	7	2	4	
c15	6	3	6	9	

table ProductQualityLower(pro,qual)
	q1	q2	q3	q4	
p1	2	0	0	1	
p2	2	1	0	1	
p3	1	2	0	1	
p4	2	2	0	1	
p5	2	0	2	2	
p6	1	2	0	2	
p7	1	1	1	1	
p8	0	2	1	2	
p9	0	1	1	2	
p10	0	1	1	2	

table ProductQualityUpper(pro,qual)
	q1	q2	q3	q4	
p1	6	2	7	5	
p2	6	6	2	9	
p3	6	9	4	3	
p4	10	8	6	5	
p5	10	2	9	3	
p6	2	4	4	10	
p7	2	8	3	3	
p8	1	9	5	6	
p9	8	3	9	6	
p10	6	2	4	5	

table ComponentPoolFraction(comp,pool)
	o1	o2	o3	o4	o5	
c1	1	0	0	0	0	
c2	1	0	1	0	0	
c3	0	1	0	0	0	
c4	0	0	0	0	0	
c5	1	1	0	1	0	
c6	1	0	1	0	0	
c7	0	1	1	0	0	
c8	1	0	0	1	0	
c9	0	0	1	0	0	
c10	0	0	0	0	0	
c11	0	0	1	1	1	
c12	0	0	1	0	1	
c13	0	0	0	0	0	
c14	0	0	0	0	0	
c15	0	0	0	1	0	

table PoolProductBound(pool,pro)
	p1	p2	p3	p4	p5	p6	p7	p8	p9	p10	
o1	300	300	0	0	0	0	300	0	0	0	
o2	300	0	0	0	300	0	300	0	0	150	
o3	300	0	300	300	300	300	0	0	0	0	
o4	0	300	300	0	0	0	0	300	0	0	
o5	0	0	0	271	271	271	0	271	0	150	

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