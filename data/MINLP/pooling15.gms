******************************
* DATA SECTION
******************************

$eolcom //
Sets comp Components and Raw Materials / c1*c15 /
     pro  Products                     / p1*p10 /
     qual Qualities                    / q1*q2 /
     pool Pools                        / o1*o8 /

parameter cl(comp)     / c1 0, c2 0, c3 0, c4 0, c5 0, c6 0, c7 0, c8 0, c9 0, c10 0, c11 0, c12 0, c13 0, c14 0, c15 0 /
parameter cu(comp)     / c1 147, c2 122, c3 197, c4 130, c5 115, c6 83, c7 143, c8 99, c9 147, c10 146, c11 137, c12 114, c13 196, c14 157, c15 129 /
parameter cprice(comp)     / c1 2, c2 2, c3 3, c4 1, c5 1, c6 1, c7 1, c8 1, c9 1, c10 3, c11 1, c12 3, c13 3, c14 0, c15 3 /
parameter prl(pro)     / p1 0, p2 0, p3 0, p4 0, p5 0, p6 0, p7 0, p8 0, p9 0, p10 0 /
parameter pru(pro)     / p1 300, p2 150, p3 300, p4 150, p5 150, p6 300, p7 300, p8 150, p9 150, p10 300 /
parameter pprice(pro)     / p1 12, p2 9, p3 33, p4 33, p5 21, p6 3, p7 30, p8 24, p9 33, p10 27 /
parameter psize(pool)     / o1 688, o2 556, o3 553, o4 602, o5 660, o6 719, o7 753, o8 599 /

table ComponentQuality(comp,qual)
	q1	q2	
c1	8	9	
c2	2	11	
c3	7	10	
c4	11	4	
c5	7	11	
c6	9	7	
c7	9	9	
c8	10	9	
c9	8	9	
c10	5	10	
c11	9	11	
c12	5	7	
c13	7	10	
c14	11	10	
c15	7	4	

table ProductQualityLower(pro,qual)
	q1	q2	
p1	0	2	
p2	0	1	
p3	1	0	
p4	2	1	
p5	2	0	
p6	1	1	
p7	1	0	
p8	0	0	
p9	1	2	
p10	2	0	

table ProductQualityUpper(pro,qual)
	q1	q2	
p1	2	4	
p2	2	5	
p3	2	4	
p4	4	2	
p5	9	4	
p6	4	4	
p7	8	7	
p8	3	2	
p9	2	7	
p10	9	8	

table ComponentPoolFraction(comp,pool)
	o1	o2	o3	o4	o5	o6	o7	o8	
c1	1	0	0	0	0	1	1	1	
c2	1	0	0	0	1	0	0	0	
c3	0	0	1	0	0	0	1	0	
c4	0	1	0	1	1	0	0	0	
c5	0	0	0	0	1	0	0	0	
c6	0	1	0	1	0	1	0	0	
c7	1	0	1	1	0	0	1	0	
c8	0	0	1	1	0	1	0	1	
c9	1	1	0	1	1	1	0	0	
c10	0	0	0	0	1	0	0	0	
c11	0	0	0	0	0	0	1	0	
c12	0	0	1	0	0	1	0	0	
c13	0	1	0	0	0	0	0	1	
c14	0	0	0	0	0	0	0	1	
c15	1	0	0	0	0	1	1	0	

table PoolProductBound(pool,pro)
	p1	p2	p3	p4	p5	p6	p7	p8	p9	p10	
o1	0	0	300	0	0	0	300	150	0	0	
o2	0	0	0	0	0	300	0	150	150	300	
o3	300	0	0	150	0	0	300	150	150	300	
o4	300	0	0	0	0	300	0	150	150	0	
o5	0	0	0	150	150	0	0	150	150	0	
o6	300	0	0	150	150	300	0	0	0	0	
o7	300	150	0	0	0	300	0	150	150	0	
o8	0	0	300	150	150	0	300	0	0	300	

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