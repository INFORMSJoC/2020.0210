******************************
* DATA SECTION
******************************

$eolcom //
Sets comp Components and Raw Materials / c1*c15 /
     pro  Products                     / p1*p10 /
     qual Qualities                    / q1*q4 /
     pool Pools                        / o1*o5 /

parameter cl(comp)     / c1 0, c2 0, c3 0, c4 0, c5 0, c6 0, c7 0, c8 0, c9 0, c10 0, c11 0, c12 0, c13 0, c14 0, c15 0 /
parameter cu(comp)     / c1 113, c2 78, c3 75, c4 90, c5 177, c6 113, c7 136, c8 188, c9 86, c10 182, c11 177, c12 168, c13 159, c14 104, c15 151 /
parameter cprice(comp)     / c1 2, c2 1, c3 2, c4 3, c5 2, c6 3, c7 2, c8 3, c9 1, c10 1, c11 1, c12 2, c13 1, c14 1, c15 2 /
parameter prl(pro)     / p1 0, p2 0, p3 0, p4 0, p5 0, p6 0, p7 0, p8 0, p9 0, p10 0 /
parameter pru(pro)     / p1 300, p2 150, p3 150, p4 150, p5 300, p6 150, p7 150, p8 300, p9 150, p10 300 /
parameter pprice(pro)     / p1 24, p2 21, p3 9, p4 6, p5 30, p6 27, p7 9, p8 18, p9 6, p10 15 /
parameter psize(pool)     / o1 540, o2 290, o3 943, o4 937, o5 161 /

table ComponentQuality(comp,qual)
	q1	q2	q3	q4	
c1	6	5	6	10	
c2	3	9	3	11	
c3	7	2	9	1	
c4	10	7	11	3	
c5	5	5	11	2	
c6	9	4	9	8	
c7	1	6	7	9	
c8	6	9	7	9	
c9	2	10	8	2	
c10	7	10	11	11	
c11	9	8	11	8	
c12	2	8	10	4	
c13	10	7	5	7	
c14	11	1	2	9	
c15	4	8	4	7	

table ProductQualityLower(pro,qual)
	q1	q2	q3	q4	
p1	2	2	2	1	
p2	2	1	2	2	
p3	1	0	0	0	
p4	1	0	0	2	
p5	2	2	0	2	
p6	1	1	1	0	
p7	1	2	0	1	
p8	0	0	2	2	
p9	2	1	1	2	
p10	2	1	1	1	

table ProductQualityUpper(pro,qual)
	q1	q2	q3	q4	
p1	4	5	3	6	
p2	5	4	6	3	
p3	3	4	5	4	
p4	4	3	8	10	
p5	4	8	4	6	
p6	9	3	9	4	
p7	6	3	3	7	
p8	5	2	5	8	
p9	6	4	4	9	
p10	8	7	8	8	

table ComponentPoolFraction(comp,pool)
	o1	o2	o3	o4	o5	
c1	0	1	0	1	0	
c2	1	0	0	1	0	
c3	1	0	1	0	1	
c4	0	0	1	0	0	
c5	0	1	0	1	0	
c6	1	0	1	0	0	
c7	0	0	1	1	0	
c8	1	0	1	1	0	
c9	1	0	0	1	1	
c10	0	0	1	0	0	
c11	0	0	0	0	0	
c12	0	0	0	0	0	
c13	0	0	1	1	0	
c14	0	0	0	0	0	
c15	0	0	0	0	0	

table PoolProductBound(pool,pro)
	p1	p2	p3	p4	p5	p6	p7	p8	p9	p10	
o1	300	0	0	150	0	0	0	0	0	0	
o2	0	0	150	0	0	150	150	0	150	0	
o3	0	0	150	0	300	150	0	0	0	0	
o4	0	150	150	150	300	0	150	300	150	0	
o5	0	0	150	0	0	0	0	161	0	161	

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