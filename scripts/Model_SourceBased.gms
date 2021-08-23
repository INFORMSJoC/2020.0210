

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
cost_fixed(pool,pro) = 0.1*pprice(pro);

parameter capacity(pool),omega(pro),Xi(pool,pro);
capacity(pool) = psize(pool);
omega(pro) = pru(pro);
Xi(pool,pro) = PoolProductBound(pool,pro);

omega(pro) = card(t)*omega(pro);

psize(pool) = 0.5*psize(pool);
* ------ Preprocessing ------


*$ontext
set S_U(comp,pro);
S_U(comp,pro) = YES;

loop (comp,
  loop(pro,
    loop (qual,
      if (sigma(qual,comp) > sigma_U(qual,pro),
         S_U(comp,pro) = NO;
      );
    );
  );
);

Parameter gamma_k(comp,pro,qual);
gamma_k(comp,pro,qual) = 1;

Parameter sigma_min(qual);

sigma_min(qual) = smin(comp,sigma(qual,comp));
gamma_k(comp,pro,qual) = 1;
gamma_k(comp,pro,qual)$( NOT S_U(comp,pro) AND (sigma(qual,comp) > sigma_min(qual))) = (sigma_U(qual,pro) - sigma_min(qual))/(sigma(qual,comp) - sigma_min(qual));

Parameter gamma_max(comp,pro);
gamma_max(comp,pro) = smin(qual,gamma_k(comp,pro,qual));

set s_less(comp,compp,pro);
s_less(comp,compp,pro) = NO;

loop(comp,
  loop(pro$(NOT S_U(comp,pro)),
    loop(compp,
      if (gamma_max(compp,pro) <= gamma_max(comp,pro),
      s_less(comp,compp,pro) = yes;
      );
    );
  );
);



* s_star: the only good stream
set s_star(comp,pro,qual);
loop(qual,
  loop(pro,
    loop(comp$(sigma(qual,comp) = smin(compp,sigma(qual,compp))),
      s_star(comp,pro,qual) = yes;
        loop (compp$(sigma(qual,compp)>sigma(qual,comp)),
          if(sigma(qual,compp)<sigma_U(qual,pro),
            s_star(comp,pro,qual) = no;
          )
        )
    )
  )
);

* Added 042019
set s_best(comp,qual);
s_best(comp,qual) = no;
parameter sigma_best(qual);

loop(comp,
  loop(qual,
    if (sigma(qual,comp) = smin(compp,sigma(qual,compp)),
    s_best(comp,qual) = yes;
    sigma_best(qual) = sigma(qual,comp);
    )
  )
)

set s_secbest(comp,qual);
s_secbest(comp,qual) = no;
parameter sigma_secbest(qual);

loop(comp,
  loop(qual$(NOT s_best(comp,qual)),
    if (sigma(qual,comp) = smin(compp$(NOT s_best(compp,qual)),sigma(qual,compp)),
    s_secbest(comp,qual) = yes;
    sigma_secbest(qual) = sigma(qual,comp);
    )
  )
)

loop(comp,
  loop(qual$(NOT s_best(comp,qual) AND NOT s_secbest(comp,qual)),
    loop(pro,
      loop(compp$(s_best(compp,qual)),
        if (gamma_max(compp,pro) < 1 - gamma_max(comp,pro),
        gamma_max(comp,pro) = max(0, ((gamma_max(compp,pro) - 1)*(sigma_secbest(qual) - sigma_U(qual,pro)) - gamma_max(compp,pro)*(sigma_best(qual)- sigma_U(qual,pro)))/(sigma(qual,comp) - sigma_secbest(qual)) )
        )
      )
    )
  )
);
*$offtext
*$offtext
parameter Max_V(comp,pro);
Max_V(comp,pro) = gamma_max(comp,pro);

loop(comp,
    loop(pro,
        Max_V(comp,pro) = min(1,Max_V(comp,pro));
        Max_V(comp,pro) = max(0,Max_V(comp,pro));
    )
)

positive variable x(comp,pool,t);
positive variable y(pool,pro,t);
positive variable ys(comp,pool,pro,t);
positive variable r(pool,pro,t);
positive variable I(pool,t);
positive variable Is(comp,pool,t);
binary variable z(pool,pro,t);

Is.fx(comp,pool,t)$(ord(t) = 1) = 0;


x.fx(comp,pool,t)$(ord(t)=card(t)) = 0;
y.fx(pool,pro,t)$(ord(t)=card(t)) = 0;
ys.fx(comp,pool,pro,t)$(ord(t)=card(t)) = 0;
r.fx(pool,pro,t)$(ord(t)=card(t)) = 0;

variable profit;

Equation StreamCap(comp);
StreamCap(comp).. sum((pool,t),x(comp,pool,t)) =l= epsilon(comp);

Equation PoolCap(pool,t);
PoolCap(pool,t).. sum(comp,Is(comp,pool,t)) =l= capacity(pool);

Equation PoolCov(comp,pool,t);
PoolCov(comp,pool,t)$(ord(t)<card(t)).. Is(comp,pool,t+1) =e= Is(comp,pool,t) + x(comp,pool,t) - sum(pro,ys(comp,pool,pro,t));

Equation OutFlowS(comp,pool,pro,t);
OutFlowS(comp,pool,pro,t).. ys(comp,pool,pro,t) =e= Is(comp,pool,t)*r(pool,pro,t);

Equation RSimplex(pool,t);
RSimplex(pool,t).. sum(pro,r(pool,pro,t)) =l= 1;

Equation RON1(pool,pro,t);
RON1(pool,pro,t).. r(pool,pro,t) =l= Z(pool,pro,t);

Equation arc_cap(pool,pro,t);
arc_cap(pool,pro,t).. sum(comp,ys(comp,pool,pro,t)) =l= Xi(pool,pro);

Equation OutFlowRLT2(pool,pro,t);
OutFlowRLT2(pool,pro,t).. sum(comp,ys(comp,pool,pro,t)) =l= capacity(pool)*r(pool,pro,t);

Equation OutFlowSpec(pool,qual,pro,t);
OutFlowSpec(pool,qual,pro,t).. sum(comp,sigma(qual,comp)*ys(comp,pool,pro,t)) =l= sigma_U(qual,pro)*sum(comp,ys(comp,pool,pro,t));

Equation Max_Demand(pro);
Max_Demand(pro).. sum((comp,pool,t),ys(comp,pool,pro,t)) =l= omega(pro);

Equation OptLogic(pool,pro,t);
OptLogic(pool,pro,t).. sum(comp,x(comp,pool,t)) =l= capacity(pool)*(1-z(pool,pro,t));


Equation obj;
obj.. profit =e= sum((comp,pool,pro,t),price(pool,pro)*ys(comp,pool,pro,t)) - sum((pool,pro,t),cost_Fixed(pool,pro)*z(pool,pro,t)) - sum((comp,pool,t),cost(comp,pool)*x(comp,pool,t));

Model M1_MINLP /StreamCap,PoolCap,PoolCov,OutFlowS,RSimplex,RON1,arc_cap,OutFlowRLT2,OutFlowSpec,Max_Demand,OptLogic,obj/;

Equation Spec_BigM(qual,pool,pro,t);
Spec_BigM(qual,pool,pro,t).. sum(comp,sigma(qual,comp)*Is(comp,pool,t)) =l= sigma_U(qual,pro)*sum(comp,Is(comp,pool,t)) + capacity(pool)*smax(comp,sigma(qual,comp))*(1 - z(pool,pro,t));

Model M1_BigM /M1_MINLP,Spec_BigM/;

positive variable v(comp,pool,pro,t),u(comp,pool,pro,t);

Equation V_def(pool,pro,t);
V_def(pool,pro,t).. sum(comp,v(comp,pool,pro,t)) =l= capacity(pool)*z(pool,pro,t);

Equation U_def(pool,pro,t);
U_def(pool,pro,t).. sum(comp,U(comp,pool,pro,t)) =l= capacity(pool)*(1 - z(pool,pro,t));

Equation I_Reform(comp,pool,pro,t);
I_Reform(comp,pool,pro,t).. Is(comp,pool,t) =e= v(comp,pool,pro,t) + u(comp,pool,pro,t);

Equation ys_Reform(comp,pool,pro,t);
ys_Reform(comp,pool,pro,t).. ys(comp,pool,pro,t) =e= v(comp,pool,pro,t)*r(pool,pro,t);

Model M2_V /StreamCap,PoolCap,PoolCov,RSimplex,RON1,arc_cap,OutFlowRLT2,OutFlowSpec,obj,V_def,U_def,I_Reform,ys_Reform,Max_Demand,OptLogic/;

Equation v_spec(pool,qual,pro,t);
v_spec(pool,qual,pro,t).. sum(comp,sigma(qual,comp)*v(comp,pool,pro,t)) =l= sigma_U(qual,pro)*sum(comp,v(comp,pool,pro,t));


Model M2_VSpec /M2_V,v_spec/;
 


Equation V_UP(comp,pool,pro,t);
V_UP(comp,pool,pro,t)$(Max_V(comp,pro)<1).. v(comp,pool,pro,t) =l= Max_V(comp,pro)*capacity(pool);

Equation V_RLT_GE(comp,pool,pro,t);
V_RLT_GE(comp,pool,pro,t)$(Max_V(comp,pro)<1).. ys(comp,pool,pro,t) =g= Max_V(comp,pro)*capacity(pool)*r(pool,pro,t) + v(comp,pool,pro,t) - Max_V(comp,pro)*capacity(pool);

Equation V_UP_Agg(pool,qual,pro,t);
V_UP_Agg(pool,qual,pro,t)$(sigma_min(qual) ne  sigma_U(qual,pro)).. sum(comp$(sigma(qual,comp)>sigma_min(qual)),(1 - (sigma(qual,comp) - sigma_U(qual,pro))/(sigma_min(qual) -  sigma_U(qual,pro)))*V(comp,pool,pro,t)) =l= capacity(pool)

Equation V_RLT_Agg(pool,qual,pro,t) RLT for Eqn.24;
V_RLT_Agg(pool,qual,pro,t)$(sigma_min(qual) ne  sigma_U(qual,pro)).. sum(comp$(sigma(qual,comp)>sigma_min(qual)),(1 - (sigma(qual,comp) - sigma_U(qual,pro))/(sigma_min(qual) -  sigma_U(qual,pro)))*(v(comp,pool,pro,t)-ys(comp,pool,pro,t))) =l= capacity(pool)*(1-r(pool,pro,t))

display Max_V; 
* test solve 6
Model M3_VT /M2_VSpec,V_UP,V_RLT_GE,V_UP_Agg,V_RLT_Agg/;
*Model M3_VT /M2_VSpec,V_UP/;
Model M4_NoRLT /M2_VSpec,V_UP,V_UP_Agg/;
Model M5_NoAgg /M2_VSpec,V_UP,V_RLT_GE/;


Model M6_RT /M2_VSpec,V_UP,V_RLT_GE,V_RLT_Agg/;

option minlp = baron;

M1_MINLP.optcr = 1e-4;
M1_MINLP.reslim = 300;

M1_BigM.optcr = 1e-4;
M1_BigM.reslim = 300;

M2_VSpec.optcr = 1e-4;
M2_VSpec.reslim = 300;

M3_VT.optcr = 1e-4;
M3_VT.reslim = 300;

M4_NoRLT.optcr = 1e-4;
M4_NoRLT.reslim = 300;

M5_NoAgg.optcr = 1e-4;
M5_NoAgg.reslim = 300;

M6_RT.optcr = 1e-4;
M6_RT.reslim = 300;

parameter NocutTime, UVTime, UVNoTightenTime, UVRTTime;

Solve M1_BigM using minlp maximizing profit;
NocutTime = TimeElapsed;

x.l(comp,pool,t) = 0;
y.l(pool,pro,t) = 0;
ys.l(comp,pool,pro,t) = 0;
r.l(pool,pro,t) = 0;
I.l(pool,t) = 0;
Is.l(comp,pool,t) = 0;
z.l(pool,pro,t) = 0;

M2_VSpec.reslim = 300;

Solve M2_VSpec using minlp maximizing profit;
UVTime = TimeElapsed - NocutTime;

x.l(comp,pool,t) = 0;
y.l(pool,pro,t) = 0;
ys.l(comp,pool,pro,t) = 0;
r.l(pool,pro,t) = 0;
I.l(pool,t) = 0;
Is.l(comp,pool,t) = 0;
z.l(pool,pro,t) = 0;


Solve M3_VT using minlp maximizing profit;
UVRTTime = TimeElapsed - NocutTime - UVTime;

x.l(comp,pool,t) = 0;
y.l(pool,pro,t) = 0;
ys.l(comp,pool,pro,t) = 0;
r.l(pool,pro,t) = 0;
I.l(pool,t) = 0;
Is.l(comp,pool,t) = 0;
z.l(pool,pro,t) = 0;

Max_V(comp,pro) = 1;

M3_VT.reslim = 300;
Solve M3_VT using minlp maximizing profit;
UVNoTightenTime = TimeElapsed - NocutTime - UVTime - UVRTTime;
