******************************
* DATA SECTION
******************************

$eolcom //
Sets comp Components and Raw Materials / c1*c15 /
     pro  Products                     / p1*p10 /
     qual Qualities                    / q1*q4 /
     pool Pools                        / o1*o5 /

parameter cl(comp)     / c1 0, c2 0, c3 0, c4 0, c5 0, c6 0, c7 0, c8 0, c9 0, c10 0, c11 0, c12 0, c13 0, c14 0, c15 0 /
parameter cu(comp)     / c1 181, c2 79, c3 117, c4 106, c5 147, c6 170, c7 168, c8 82, c9 153, c10 173, c11 90, c12 101, c13 129, c14 117, c15 171 /
parameter cprice(comp)     / c1 6, c2 2, c3 1, c4 2, c5 3, c6 6, c7 1, c8 3, c9 2, c10 1, c11 1, c12 1, c13 1, c14 9, c15 2 /
parameter prl(pro)     / p1 0, p2 0, p3 0, p4 0, p5 0, p6 0, p7 0, p8 0, p9 0, p10 0 /
parameter pru(pro)     / p1 300, p2 300, p3 150, p4 300, p5 300, p6 300, p7 150, p8 300, p9 150, p10 300 /
parameter pprice(pro)     / p1 12, p2 9, p3 33, p4 12, p5 18, p6 9, p7 3, p8 24, p9 30, p10 12 /
parameter psize(pool)     / o1 461, o2 504, o3 1125, o4 769, o5 424 /

table ComponentQuality(comp,qual)
	q1	q2	q3	q4	
c1	2	10	4	3	
c2	11	1	2	4	
c3	7	11	1	10	
c4	3	3	5	8	
c5	3	3	9	11	
c6	2	9	4	1	
c7	10	10	9	5	
c8	6	9	11	7	
c9	7	3	8	6	
c10	3	7	7	7	
c11	5	7	3	7	
c12	8	6	2	10	
c13	6	8	9	5	
c14	4	2	5	2	
c15	11	3	4	3	

table ProductQualityLower(pro,qual)
	q1	q2	q3	q4	
p1	2	1	2	2	
p2	2	2	2	0	
p3	2	2	1	2	
p4	1	0	2	2	
p5	2	2	2	0	
p6	2	2	0	1	
p7	1	2	2	1	
p8	2	1	0	0	
p9	2	0	2	2	
p10	2	0	0	2	

table ProductQualityUpper(pro,qual)
	q1	q2	q3	q4	
p1	9	5	6	5	
p2	8	7	3	7	
p3	7	10	6	10	
p4	4	3	9	4	
p5	5	7	3	8	
p6	10	8	4	7	
p7	2	3	6	3	
p8	4	6	2	8	
p9	10	5	4	7	
p10	4	3	3	8	

table ComponentPoolFraction(comp,pool)
	o1	o2	o3	o4	o5	
c1	0	0	0	1	0	
c2	0	1	1	1	0	
c3	0	1	0	1	0	
c4	0	0	1	0	1	
c5	0	0	1	0	1	
c6	0	0	1	0	0	
c7	0	0	1	0	0	
c8	0	0	0	0	0	
c9	0	0	1	0	0	
c10	1	0	1	1	0	
c11	0	1	0	1	0	
c12	0	1	0	0	0	
c13	0	0	1	1	0	
c14	1	1	0	0	0	
c15	1	0	0	0	1	

table PoolProductBound(pool,pro)
	p1	p2	p3	p4	p5	p6	p7	p8	p9	p10	
o1	300	0	150	0	0	0	0	0	150	300	
o2	0	300	0	0	300	0	0	300	0	0	
o3	0	0	0	0	0	0	150	0	0	0	
o4	0	0	0	300	0	300	150	0	150	0	
o5	300	300	150	0	0	0	0	0	0	0	

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

omega(pro) = card(t)*omega(pro);