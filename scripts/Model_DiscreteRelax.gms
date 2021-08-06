
* ------ Preprocessing ------

*$ontext
set S_U(s,p);
S_U(s,p) = YES;

loop (s,
  loop(p,
    loop (k,
      if (sigma(k,s) > sigma_U(k,p),
         S_U(s,p) = NO;
      );
    );
  );
);

Parameter gamma_k(s,p,k);
gamma_k(s,p,k) = 1;

Parameter sigma_min(k);

sigma_min(k) = smin(s,sigma(k,s));
gamma_k(s,p,k) = 1;
gamma_k(s,p,k)$( NOT S_U(s,p) AND (sigma(k,s) > sigma_min(k))) = (sigma_U(k,p) - sigma_min(k))/(sigma(k,s) - sigma_min(k));

Parameter gamma_max(s,p);
gamma_max(s,p) = smin(k,gamma_k(s,p,k));

set s_less(s,sp,p);
s_less(s,sp,p) = NO;

loop(s,
  loop(p$(NOT S_U(s,p)),
    loop(sp,
      if (gamma_max(sp,p) <= gamma_max(s,p),
      s_less(s,sp,p) = yes;
      );
    );
  );
);



* s_star: the only good stream
set s_star(s,p,k);
loop(k,
  loop(p,
    loop(s$(sigma(k,s) = smin(sp,sigma(k,sp))),
      s_star(s,p,k) = yes;
        loop (sp$(sigma(k,sp)>sigma(k,s)),
          if(sigma(k,sp)<sigma_U(k,p),
            s_star(s,p,k) = no;
          )
        )
    )
  )
);

set s_best(s,k);
s_best(s,k) = no;
parameter sigma_best(k);

loop(s,
  loop(k,
    if (sigma(k,s) = smin(sp,sigma(k,sp)),
    s_best(s,k) = yes;
    sigma_best(k) = sigma(k,s);
    )
  )
)

set s_secbest(s,k);
s_secbest(s,k) = no;
parameter sigma_secbest(k);

loop(s,
  loop(k$(NOT s_best(s,k)),
    if (sigma(k,s) = smin(sp$(NOT s_best(sp,k)),sigma(k,sp)),
    s_secbest(s,k) = yes;
    sigma_secbest(k) = sigma(k,s);
    )
  )
)

loop(s,
  loop(k$(NOT s_best(s,k) AND NOT s_secbest(s,k)),
    loop(p,
      loop(sp$(s_best(sp,k)),
        if (gamma_max(sp,p) < 1 - gamma_max(s,p),
        gamma_max(s,p) = max(0, ((gamma_max(sp,p) - 1)*(sigma_secbest(k) - sigma_U(k,p)) - gamma_max(sp,p)*(sigma_best(k)- sigma_U(k,p)))/(sigma(k,s) - sigma_secbest(k)) )
        )
      )
    )
  )
);
*$offtext
*$offtext
parameter Max_V(s,p);
Max_V(s,p) = gamma_max(s,p);

positive variable x(s,j,t);
positive variable y(j,p,t);
positive variable ys(s,j,p,t);
positive variable r(j,p,t);
positive variable I(j,t);
positive variable Is(s,j,t);
binary variable z(j,p,t);

Is.fx(s,j,"t1") = 0;
$ontext
x.fx(s,j,t)$(ord(t)=card(t)) = 0;
y.fx(j,p,t)$(ord(t)=card(t)) = 0;
ys.fx(s,j,p,t)$(ord(t)=card(t)) = 0;
r.fx(j,p,t)$(ord(t)=card(t)) = 0;
$offtext

variable profit;

Equation StreamCap(s);
StreamCap(s).. sum((j,t),x(s,j,t)) =l= epsilon(s);

Equation PoolCap(j,t);
PoolCap(j,t).. sum(s,Is(s,j,t)) =l= capacity(j);

Equation PoolCov(s,j,t);
PoolCov(s,j,t)$(ord(t)<card(t)).. Is(s,j,t+1) =e= Is(s,j,t) + x(s,j,t) - sum(p,ys(s,j,p,t));

Equation PoolCovTerminal(s,j,t);
PoolCovTerminal(s,j,t)$(ord(t)=card(t)).. 0 =l= Is(s,j,t) + x(s,j,t) - sum(p,ys(s,j,p,t));

Equation OutFlowS(s,j,p,t);
OutFlowS(s,j,p,t).. ys(s,j,p,t) =e= Is(s,j,t)*r(j,p,t);

Equation RSimplex(j,t);
RSimplex(j,t).. sum(p,r(j,p,t)) =l= 1;

Equation RON1(j,p,t);
RON1(j,p,t).. r(j,p,t) =l= Z(j,p,t);

Equation arc_cap(j,p,t);
arc_cap(j,p,t).. sum(s,ys(s,j,p,t)) =l= Xi(j,p);

Equation OutFlowRLT2(j,p,t);
OutFlowRLT2(j,p,t).. sum(s,ys(s,j,p,t)) =l= capacity(j)*r(j,p,t);

Equation OutFlowSpec(j,k,p,t);
OutFlowSpec(j,k,p,t).. sum(s,sigma(k,s)*ys(s,j,p,t)) =l= sigma_U(k,p)*sum(s,ys(s,j,p,t));

Equation Max_Demand(p);
Max_Demand(p).. sum((s,j,t),ys(s,j,p,t)) =l= omega(p);

Equation OptLogic(j,p,t);
OptLogic(j,p,t).. sum(s,x(s,j,t)) =l= capacity(j)*(1-z(j,p,t));


Equation obj;
obj.. profit =e= sum((s,j,p,t),price(j,p)*ys(s,j,p,t)) - sum((j,p,t),cost_Fixed(j,p)*z(j,p,t)) - sum((s,j,t),cost(s,j)*x(s,j,t));

Model M1_MINLP /StreamCap,PoolCap,PoolCov,PoolCovTerminal,OutFlowS,RSimplex,RON1,arc_cap,OutFlowRLT2,OutFlowSpec,Max_Demand,OptLogic,obj/;

Equation Spec_BigM(k,j,p,t);
Spec_BigM(k,j,p,t).. sum(s,sigma(k,s)*Is(s,j,t)) =l= sigma_U(k,p)*sum(s,Is(s,j,t)) + capacity(j)*smax(s,sigma(k,s))*(1 - z(j,p,t));

Model M1_BigM /M1_MINLP,Spec_BigM/;

positive variable v(s,j,p,t),u(s,j,p,t);

Equation V_def(j,p,t);
V_def(j,p,t).. sum(s,v(s,j,p,t)) =l= capacity(j)*z(j,p,t);

Equation U_def(j,p,t);
U_def(j,p,t).. sum(s,U(s,j,p,t)) =l= capacity(j)*(1 - z(j,p,t));

Equation I_Reform(s,j,p,t);
I_Reform(s,j,p,t).. Is(s,j,t) =e= v(s,j,p,t) + u(s,j,p,t);

Equation ys_Reform(s,j,p,t);
ys_Reform(s,j,p,t).. ys(s,j,p,t) =e= v(s,j,p,t)*r(j,p,t);

Model M2_V /StreamCap,PoolCap,PoolCov,PoolCovTerminal,RSimplex,RON1,arc_cap,OutFlowRLT2,OutFlowSpec,obj,V_def,U_def,I_Reform,ys_Reform,Max_Demand,OptLogic/;

Equation v_spec(j,k,p,t);
v_spec(j,k,p,t).. sum(s,sigma(k,s)*v(s,j,p,t)) =l= sigma_U(k,p)*sum(s,v(s,j,p,t));

*Equation V_T2(s,j,p,t);
*V_T2(s,j,p,t)$(NOT S_U(s,p)).. sum(sp$(s_less(s,sp,p)),ys(sp,j,p,t)) =l= Max_V(s,p)*capacity(j)*r(j,p,t);

*Equation V_T3MINLP(s,j,p,k,t);
*V_T3MINLP(s,j,p,k,t)$(s_star(s,p,k)).. sum(sp$( ord(sp) ne ord(s)),(sigma(k,sp) - sigma(k,s))*ys(sp,j,p,t)) =l= capacity(j)*(sigma_U(k,p) - sigma(k,s))*r(j,p,t);


Model M2_VSpec /M2_V,v_spec/;




*Equation V_T3Agg(s,j,p,k,t);
*V_T3Agg(s,j,p,k,t)$(gamma_k(s,p,k)<1).. sum(sp$(gamma_k(sp,p,k)<=gamma_k(s,p,k)),ys(sp,j,p,t)) =g= gamma_k(s,p,k)*capacity(j)*r(j,p,t) + sum(sp$(gamma_k(sp,p,k)<=gamma_k(s,p,k)),v(sp,j,p,t)) - gamma_k(s,p,k)*capacity(j);


Equation V_UP(s,j,p,t);
V_UP(s,j,p,t)$(Max_V(s,p)<1).. v(s,j,p,t) =l= Max_V(s,p)*capacity(j);

Equation V_RLT_GE(s,j,p,t);
V_RLT_GE(s,j,p,t)$(Max_V(s,p)<1).. ys(s,j,p,t) =g= Max_V(s,p)*capacity(j)*r(j,p,t) + v(s,j,p,t) - Max_V(s,p)*capacity(j);

Equation V_UP_Agg(j,k,p,t);
V_UP_Agg(j,k,p,t)$(sigma_min(k) ne  sigma_U(k,p)).. sum(s$(sigma(k,s)>sigma_min(k)),(1 - (sigma(k,s) - sigma_U(k,p))/(sigma_min(k) -  sigma_U(k,p)))*V(s,j,p,t)) =l= capacity(j)

Equation V_RLT_Agg(j,k,p,t) RLT for Eqn.24;
V_RLT_Agg(j,k,p,t)$(sigma_min(k) ne  sigma_U(k,p)).. sum(s$(sigma(k,s)>sigma_min(k)),(1 - (sigma(k,s) - sigma_U(k,p))/(sigma_min(k) -  sigma_U(k,p)))*(v(s,j,p,t)-ys(s,j,p,t))) =l= capacity(j)*(1-r(j,p,t))


Model M3_VT /M2_VSpec,V_UP,V_RLT_GE,V_UP_Agg,V_RLT_Agg/;
Model M4_NoRLT /M2_VSpec,V_UP,V_UP_Agg/;
Model M5_NoAgg /M2_VSpec,V_UP,V_RLT_GE/;
*Equation V_UP_Agg(s,j,p,k,t);
*V_UP_Agg(s,j,p,k,t)$(gamma_k(s,p,k)<1).. sum(sp$(gamma_k(sp,p,k)<=gamma_k(s,p,k)),v(sp,j,p,t)) =l= gamma_k(s,p,k)*capacity(j);

*Model M2_VTNew /M2_VSpec,V_T3,V_UP/;
*Model M2_VTRLT /M2_VSpec,V_T3/;

parameter d number of discrete point /10/;
set M /M1*M10/;
parameter psi(m);
parameter Incre incremental;

Incre = 1/d;

loop(m$(ord(m)<=d),
    psi(m) = (ord(m) - 1)*Incre;
);

display psi;

* ys_Reform(s,j,p,t).. ys(s,j,p,t) =e= v(s,j,p,t)*r(j,p,t);
* ysys(s,j,p,t) =e= Is(s,j,t)*r(j,p,t);

binary variable z_dis(j,p,t,m) for r;
positive variable W_ys(s,j,p,t) for ys;
positive variable W_vm(s,j,p,t,m) for v;
*positive variable W_IM(s,j,t,m) for I;
positive variable z_plus(j,p,t,m);
positive variable z_minus(j,p,t,m);
positive variable W_vm_plus(s,j,p,t,m);
positive variable W_vm_minus(s,j,p,t,m);


Equation Eqn_11_24;
Eqn_11_24(j,p,t).. sum(m$(ord(m)<=d), z_dis(j,p,t,m)) =e= 1;

Equation Eqn_11_25;
Eqn_11_25(j,p,t).. r(j,p,t) =e= sum(m$(ord(m)<=d), psi(m)*z_dis(j,p,t,m));

Equation Eqn_11_27;
Eqn_11_27(s,j,p,t)..  ys(s,j,p,t) =e= W_ys(s,j,p,t);

Equation Eqn_11_28;
Eqn_11_28(s,j,p,t).. v(s,j,p,t) =e= sum(m$(ord(m)<=d),W_vm(s,j,p,t,m));

Equation Eqn_11_28_I;
Eqn_11_28_I(s,j,p,t).. Is(s,j,t) =e= sum(m$(ord(m)<=d),W_vm(s,j,p,t,m));

Equation Eqn_11_29_Tightening;
Eqn_11_29_Tightening(s,j,p,t,m).. W_vm(s,j,p,t,m) =l= Max_V(s,p)*capacity(j)*z_dis(j,p,t,m);

Equation Eqn_11_29_NoTightening;
Eqn_11_29_NoTightening(s,j,p,t,m).. W_vm(s,j,p,t,m) =l= capacity(j)*z_dis(j,p,t,m);

Equation Eqn_11_32;
Eqn_11_32(s,j,p,t).. W_ys(s,j,p,t) =e= sum(m$(ord(m)<=d),psi(m)*W_vm(s,j,p,t,m));

Equation Eqn_11_34;
Eqn_11_34(j,p,t,m)$(ord(m)<d).. Z_minus(j,p,t,m) + Z_plus(j,p,t,m) =e= z_dis(j,p,t,m);

Equation Eqn_11_36 replacing 11_25 in Rex;
Eqn_11_36(j,p,t).. r(j,p,t) =e= sum(m$(ord(m)<d), psi(m)*z_dis(j,p,t,m)) + sum(m$(ord(m)<d), (psi(m+1) - psi(m))*z_plus(j,p,t,m));

Equation Eqn_11_38;
Eqn_11_38(s,j,p,t,m)$(ord(m)<d).. W_vm_plus(s,j,p,t,m) + W_vm_minus(s,j,p,t,m) =e= W_vm(s,j,p,t,m);

Equation Eqn_11_40 replacing 11_28 in Rex;
Eqn_11_40(s,j,p,t).. v(s,j,p,t) =e= sum(m$(ord(m)<d),psi(m)*W_vm(s,j,p,t,m)) + sum(m$(ord(m)<d), capacity(j)*(psi(m+1) - psi(m))*W_vm_plus(s,j,p,t,m));

Equation Eqn_11_40_I replacing 11_28_I in Rex;
Eqn_11_40_I(s,j,p,t).. Is(s,j,t) =e= sum(m$(ord(m)<d),psi(m)*W_vm(s,j,p,t,m)) + sum(m$(ord(m)<d), capacity(j)*(psi(m+1) - psi(m))*W_vm_plus(s,j,p,t,m));


*Equation Eqn_11_32_Is;
*Eqn_11_32_Is(s,j,p,t).. 

Model M_UV_Dis_NoT /StreamCap,
                    PoolCap,
                    PoolCov,
                    PoolCovTerminal,
                    RSimplex,
                    RON1,
                    arc_cap,
                    OutFlowRLT2,
                    OutFlowSpec,
                    obj,
                    
                    V_def,
                    U_def,
                    I_Reform,
                    
                    Eqn_11_24,
                    Eqn_11_25,
                    Eqn_11_27,
                    Eqn_11_28,
                    Eqn_11_29_NoTightening,
                    Eqn_11_32,
                    
                    Max_Demand,
                    OptLogic/;
                    
Model M_Dis         /StreamCap,
                    PoolCap,
                    PoolCov,
                    PoolCovTerminal,
                    RSimplex,
                    RON1,
                    arc_cap,
                    OutFlowRLT2,
                    OutFlowSpec,
                    obj,

                    
                    Eqn_11_24,
                    Eqn_11_25,
                    Eqn_11_27,
                    Eqn_11_28_I,
                    Eqn_11_29_NoTightening,
                    Eqn_11_32,
                    
                    Max_Demand,
                    OptLogic/;
                    
$ontext
Model M_DisRex    /StreamCap,
                    PoolCap,
                    PoolCov,
                    PoolCovTerminal,
                    RSimplex,
                    RON1,
                    arc_cap,
                    OutFlowRLT2,
                    OutFlowSpec,
                    obj,

                    
                    Eqn_11_24,
                    Eqn_11_36,
                    Eqn_11_27,
                    Eqn_11_40_I,
                    Eqn_11_29_NoTightening,
                    Eqn_11_32,
                    Eqn_11_34,
                    Eqn_11_38,
                    
                    Max_Demand,
                    OptLogic/;
$offtext

Model M_UV_Dis_T /StreamCap,
                    PoolCap,
                    PoolCov,
                    PoolCovTerminal,
                    RSimplex,
                    RON1,
                    arc_cap,
                    OutFlowRLT2,
                    OutFlowSpec,
                    obj,
                    V_def,
                    U_def,
                    I_Reform,
                    
                    Eqn_11_24,
                    Eqn_11_25,
                    Eqn_11_27,
                    Eqn_11_28,
                    Eqn_11_29_Tightening,
                    Eqn_11_32,
                    
                    Max_Demand,
                    OptLogic,
                    
                    V_UP,
                    V_RLT_GE,
                    V_RLT_AGG/;
                    
Model M_UV_DisRex_NoT /StreamCap,
                    PoolCap,
                    PoolCov,
                    PoolCovTerminal,
                    RSimplex,
                    RON1,
                    arc_cap,
                    OutFlowRLT2,
                    OutFlowSpec,
                    obj,
                    V_def,
                    U_def,
                    I_Reform,
                    
                    Eqn_11_24,
                    Eqn_11_36,
                    Eqn_11_27,
                    Eqn_11_40,
                    Eqn_11_29_NoTightening,
                    Eqn_11_32,
                    Eqn_11_34,
                    Eqn_11_38,
                    
                    Max_Demand,
                    OptLogic/;
                    
Model M_UV_DisRex_T /StreamCap,
                    PoolCap,
                    PoolCov,
                    PoolCovTerminal,
                    RSimplex,
                    RON1,
                    arc_cap,
                    OutFlowRLT2,
                    OutFlowSpec,
                    obj,
                    V_def,
                    U_def,
                    I_Reform,
                    
                    Eqn_11_24,
                    Eqn_11_36,
                    Eqn_11_27,
                    Eqn_11_40,
                    Eqn_11_29_Tightening,
                    Eqn_11_32,
                    Eqn_11_34,
                    Eqn_11_38,
                    
                    Max_Demand,
                    OptLogic,
                    
                    V_UP,
                    V_RLT_GE,
                    V_RLT_AGG                    /;
                    

Model M_DisRex    /StreamCap,
                    PoolCap,
                    PoolCov,
                    PoolCovTerminal,
                    RSimplex,
                    RON1,
                    arc_cap,
                    OutFlowRLT2,
                    OutFlowSpec,
                    obj,

*$ontext                    
                    Eqn_11_24,
                    Eqn_11_36,
                    Eqn_11_27,
                    Eqn_11_40_I,
                    Eqn_11_29_NoTightening,
                    Eqn_11_32,
                    Eqn_11_34,
                    Eqn_11_38,
*$offtext                     
                    Max_Demand,
                    OptLogic/;
                    
Model M_MINLP_Test    /StreamCap,
                    PoolCap,
                    PoolCov,
                    PoolCovTerminal,
                    RSimplex,
                    RON1,
                    arc_cap,
                    OutFlowRLT2,
                    OutFlowSpec,
                    obj,
                    OutFlowS,

$ontext                    
                    Eqn_11_24,
                    Eqn_11_36,
                    Eqn_11_27,
                    Eqn_11_40_I,
                    Eqn_11_29_NoTightening,
                    Eqn_11_32,
                    Eqn_11_34,
                    Eqn_11_38,
$offtext                     
                    Max_Demand,
                    OptLogic/;

option mip = cplex;

M_UV_Dis_NoT.optcr = 0;
M_UV_Dis_NoT.reslim = 300;

M_UV_Dis_T.optcr = 0;
M_UV_Dis_T.reslim = 300;

M_UV_DisRex_NoT.optcr = 0;
M_UV_DisRex_NoT.reslim = 300;

M_UV_DisRex_T.optcr = 0;
M_UV_DisRex_T.reslim = 300;

M_Dis.optcr = 0;
M_Dis.reslim = 300;

M_DisRex.optcr = 0;
M_DisRex.reslim = 300;

M1_MINLP.optcr = 0;
M1_MINLP.reslim = 300;

M1_BigM.optcr = 0;
M1_BigM.reslim = 300;

solve M_UV_DisRex_NoT using mip maximizing profit;
option minlp = baron;
solve M1_BigM using minlp maximizing profit;



















