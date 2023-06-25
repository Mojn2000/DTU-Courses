Backend: Open-Source Fixedpoint Model-Checker version 2020 
Protocol: WooLam92
Types:
[(Purpose,[]),(Agent False False,["A","B","s"]),(Number,["NA","NB"]),(SymmetricKey,["KS"]),(Function,["pk"])]
section rules:
step rule_0:
iknows(crypt(K,M));
iknows(inv(K))

=>
iknows(M)

step rule_1:
iknows(crypt(inv(K),M));
iknows(K)

=>
iknows(M)

step rule_2:
iknows(scrypt(K,M));
iknows(K)

=>
iknows(M)

step rule_3:
iknows(pair(M1,M2))

=>
iknows(M1);
iknows(M2)

step rule_4:
secret(M,Agent (honest a));
iknows(M)

=>
attack(pair(secrecy,M))

step rule_5:
request(A,B,Purpose (purposeNA),M,(SID sid))
 | B/=Agent (dishonest i);
M/=Nonce (absNA(pair(B,A)))
=>
attack(pair(authentication,pair(A,pair(B,M))))

step rule_6:
request(A,B,Purpose (purposeKS),M,(SID sid))
 | B/=Agent (dishonest i);
M/=SymKey (absKS(pair(B,A)))
=>
attack(pair(authentication,pair(A,pair(B,M))))

step rule_7:
request(A,B,Purpose (purposeNB),M,(SID sid))
 | B/=Agent (dishonest i);
M/=Nonce (absNB(pair(B,A)))
=>
attack(pair(authentication,pair(A,pair(B,M))))

step rule_8:
State (rA,[Agent (A),Step 0,Agent (B),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (A))),pk(Agent (A)),(SID sid)])

=>
State (rA,[Agent (A),Step 1,Agent (B),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (A))),pk(Agent (A)),pair(Agent (A),Agent (B)),(SID sid)]);
iknows(pair(Agent (A),Agent (B)))

step rule_9:
State (rs,[Agent (honest a),Step 0,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (B)),pk(Agent (A)),Agent (B),Agent (A),(SID sid)]);
iknows(Agent (A));
iknows(Agent (B))

=>
State (rs,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (B)),pk(Agent (A)),Agent (B),Agent (A),pair(Agent (A),Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))))

step rule_10:
State (rA,[Agent (A),Step 1,Agent (B),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (A))),pk(Agent (A)),pair(Agent (A),Agent (B)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))))

=>
State (rA,[Agent (A),Step 2,Agent (B),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (A))),pk(Agent (A)),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),Nonce (absNA(pair(Agent (A),Agent (B)))),crypt(pk(Agent (B)),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (A))),(SID sid)]);
iknows(crypt(pk(Agent (B)),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (A))))

step rule_11:
State (rA,[Agent (A),Step 1,Agent (B),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (A))),pk(Agent (A)),pair(Agent (A),Agent (B)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (B));
iknows(pk(Agent (B)))

=>
State (rA,[Agent (A),Step 2,Agent (B),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (A))),pk(Agent (A)),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),Nonce (absNA(pair(Agent (A),Agent (B)))),crypt(pk(Agent (B)),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (A))),(SID sid)]);
iknows(crypt(pk(Agent (B)),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (A))))

step rule_12:
State (rA,[Agent (A),Step 1,Agent (B),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (A))),pk(Agent (A)),pair(Agent (A),Agent (B)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (B))

=>
State (rA,[Agent (A),Step 2,Agent (B),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (A))),pk(Agent (A)),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),Nonce (absNA(pair(Agent (A),Agent (B)))),crypt(pk(Agent (B)),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (A))),(SID sid)]);
iknows(crypt(pk(Agent (B)),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (A))))

step rule_13:
State (rB,[Agent (B),Step 0,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),(SID sid)]);
iknows(crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))))

=>
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),(SID sid)]);
iknows(pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))))

step rule_14:
State (rB,[Agent (B),Step 0,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),(SID sid)]);
iknows(pk(Agent (B)));
iknows(Nonce (NA));
iknows(Agent (A))

=>
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),(SID sid)]);
iknows(pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))))

step rule_15:
State (rB,[Agent (B),Step 0,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),(SID sid)]);
iknows(Agent (B));
iknows(Nonce (NA));
iknows(Agent (A))

=>
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),(SID sid)]);
iknows(pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))))

step rule_16:
State (rs,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (B)),pk(Agent (A)),Agent (B),Agent (A),pair(Agent (A),Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),(SID sid)]);
iknows(Agent (A));
iknows(Agent (B));
iknows(crypt(pk(Agent (honest a)),Nonce (NA)))

=>
witness(Agent (honest a),Agent (A),Purpose (pAsKSB),pair(SymKey (absKS(pair(Agent (B),Agent (A)))),Agent (B)));
witness(Agent (honest a),Agent (B),Purpose (pBsKSA),pair(SymKey (absKS(pair(Agent (B),Agent (A)))),Agent (A)));
secrets(SymKey (absKS(pair(Agent (B),Agent (A)))),secrecyset(pair(Agent (honest a),pair((SID sid),Purpose (pKS)))));
contains(secrecyset(pair(Agent (honest a),pair((SID sid),Purpose (pKS)))),Agent (A));
contains(secrecyset(pair(Agent (honest a),pair((SID sid),Purpose (pKS)))),Agent (B));
contains(secrecyset(pair(Agent (honest a),pair((SID sid),Purpose (pKS)))),Agent (honest a));
State (rs,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (B)),pk(Agent (A)),Agent (B),Agent (A),pair(Agent (A),Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),Nonce (NA),crypt(pk(Agent (honest a)),Nonce (NA)),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),SymKey (absKS(pair(Agent (B),Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (absKS(pair(Agent (B),Agent (A)))),pair(Agent (B),Agent (A))))))),(SID sid)]);
iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (absKS(pair(Agent (B),Agent (A)))),pair(Agent (B),Agent (A))))))))

step rule_17:
State (rs,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (B)),pk(Agent (A)),Agent (B),Agent (A),pair(Agent (A),Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),(SID sid)]);
iknows(Agent (A));
iknows(Agent (B));
iknows(pk(Agent (honest a)));
iknows(Nonce (NA))

=>
witness(Agent (honest a),Agent (A),Purpose (pAsKSB),pair(SymKey (absKS(pair(Agent (B),Agent (A)))),Agent (B)));
witness(Agent (honest a),Agent (B),Purpose (pBsKSA),pair(SymKey (absKS(pair(Agent (B),Agent (A)))),Agent (A)));
secrets(SymKey (absKS(pair(Agent (B),Agent (A)))),secrecyset(pair(Agent (honest a),pair((SID sid),Purpose (pKS)))));
contains(secrecyset(pair(Agent (honest a),pair((SID sid),Purpose (pKS)))),Agent (A));
contains(secrecyset(pair(Agent (honest a),pair((SID sid),Purpose (pKS)))),Agent (B));
contains(secrecyset(pair(Agent (honest a),pair((SID sid),Purpose (pKS)))),Agent (honest a));
State (rs,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (B)),pk(Agent (A)),Agent (B),Agent (A),pair(Agent (A),Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),Nonce (NA),crypt(pk(Agent (honest a)),Nonce (NA)),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),SymKey (absKS(pair(Agent (B),Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (absKS(pair(Agent (B),Agent (A)))),pair(Agent (B),Agent (A))))))),(SID sid)]);
iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (absKS(pair(Agent (B),Agent (A)))),pair(Agent (B),Agent (A))))))))

step rule_18:
State (rs,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (B)),pk(Agent (A)),Agent (B),Agent (A),pair(Agent (A),Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),(SID sid)]);
iknows(Agent (A));
iknows(Agent (B));
iknows(Agent (honest a));
iknows(Nonce (NA))

=>
witness(Agent (honest a),Agent (A),Purpose (pAsKSB),pair(SymKey (absKS(pair(Agent (B),Agent (A)))),Agent (B)));
witness(Agent (honest a),Agent (B),Purpose (pBsKSA),pair(SymKey (absKS(pair(Agent (B),Agent (A)))),Agent (A)));
secrets(SymKey (absKS(pair(Agent (B),Agent (A)))),secrecyset(pair(Agent (honest a),pair((SID sid),Purpose (pKS)))));
contains(secrecyset(pair(Agent (honest a),pair((SID sid),Purpose (pKS)))),Agent (A));
contains(secrecyset(pair(Agent (honest a),pair((SID sid),Purpose (pKS)))),Agent (B));
contains(secrecyset(pair(Agent (honest a),pair((SID sid),Purpose (pKS)))),Agent (honest a));
State (rs,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (B)),pk(Agent (A)),Agent (B),Agent (A),pair(Agent (A),Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),Nonce (NA),crypt(pk(Agent (honest a)),Nonce (NA)),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),SymKey (absKS(pair(Agent (B),Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (absKS(pair(Agent (B),Agent (A)))),pair(Agent (B),Agent (A))))))),(SID sid)]);
iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (absKS(pair(Agent (B),Agent (A)))),pair(Agent (B),Agent (A))))))))

step rule_19:
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))))

=>
State (rB,[Agent (B),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),crypt(pk(Agent (honest a)),Nonce (NA)),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))),Nonce (absNB(pair(Agent (B),Agent (A)))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))))

step rule_20:
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(pk(Agent (B)));
iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))

=>
State (rB,[Agent (B),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),crypt(pk(Agent (honest a)),Nonce (NA)),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))),Nonce (absNB(pair(Agent (B),Agent (A)))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))))

step rule_21:
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(pk(Agent (B)));
iknows(inv(pk(Agent (honest a))));
iknows(Nonce (NA));
iknows(SymKey (KS));
iknows(Agent (B));
iknows(Agent (A))

=>
State (rB,[Agent (B),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),crypt(pk(Agent (honest a)),Nonce (NA)),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))),Nonce (absNB(pair(Agent (B),Agent (A)))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))))

step rule_22:
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(Agent (B));
iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))

=>
State (rB,[Agent (B),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),crypt(pk(Agent (honest a)),Nonce (NA)),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))),Nonce (absNB(pair(Agent (B),Agent (A)))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))))

step rule_23:
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(Agent (B));
iknows(inv(pk(Agent (honest a))));
iknows(Nonce (NA));
iknows(SymKey (KS));
iknows(Agent (A))

=>
State (rB,[Agent (B),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),crypt(pk(Agent (honest a)),Nonce (NA)),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))),Nonce (absNB(pair(Agent (B),Agent (A)))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))))

step rule_24:
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))))

=>
State (rB,[Agent (B),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),crypt(pk(Agent (honest a)),Nonce (NA)),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))),Nonce (absNB(pair(Agent (B),Agent (A)))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))))

step rule_25:
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(pk(Agent (B)));
iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))

=>
State (rB,[Agent (B),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),crypt(pk(Agent (honest a)),Nonce (NA)),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))),Nonce (absNB(pair(Agent (B),Agent (A)))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))))

step rule_26:
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(pk(Agent (B)));
iknows(Nonce (NA));
iknows(SymKey (KS));
iknows(Agent (B))

=>
State (rB,[Agent (B),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),crypt(pk(Agent (honest a)),Nonce (NA)),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))),Nonce (absNB(pair(Agent (B),Agent (A)))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))))

step rule_27:
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(Agent (B));
iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))

=>
State (rB,[Agent (B),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),crypt(pk(Agent (honest a)),Nonce (NA)),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))),Nonce (absNB(pair(Agent (B),Agent (A)))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))))

step rule_28:
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(Agent (B));
iknows(Nonce (NA));
iknows(SymKey (KS))

=>
State (rB,[Agent (B),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),crypt(pk(Agent (honest a)),Nonce (NA)),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))),Nonce (absNB(pair(Agent (B),Agent (A)))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))))

step rule_29:
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))))

=>
State (rB,[Agent (B),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),crypt(pk(Agent (honest a)),Nonce (NA)),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))),Nonce (absNB(pair(Agent (B),Agent (A)))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))))

step rule_30:
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (B)));
iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))

=>
State (rB,[Agent (B),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),crypt(pk(Agent (honest a)),Nonce (NA)),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))),Nonce (absNB(pair(Agent (B),Agent (A)))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))))

step rule_31:
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (B)));
iknows(Nonce (NA));
iknows(SymKey (KS));
iknows(Agent (B))

=>
State (rB,[Agent (B),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),crypt(pk(Agent (honest a)),Nonce (NA)),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))),Nonce (absNB(pair(Agent (B),Agent (A)))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))))

step rule_32:
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(Agent (B));
iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))

=>
State (rB,[Agent (B),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),crypt(pk(Agent (honest a)),Nonce (NA)),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))),Nonce (absNB(pair(Agent (B),Agent (A)))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))))

step rule_33:
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(Agent (B));
iknows(Nonce (NA));
iknows(SymKey (KS))

=>
State (rB,[Agent (B),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),crypt(pk(Agent (honest a)),Nonce (NA)),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))),Nonce (absNB(pair(Agent (B),Agent (A)))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (absNB(pair(Agent (B),Agent (A)))))))

step rule_34:
State (rA,[Agent (A),Step 2,Agent (B),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (A))),pk(Agent (A)),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (NB))))

=>
request(Agent (A),Agent (honest a),Purpose (pAsKSB),pair(SymKey (KS),Agent (B)),(SID sid));
secrets(SymKey (KS),secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))));
contains(secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))),Agent (A));
contains(secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))),Agent (B));
contains(secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))),Agent (honest a));
State (rA,[Agent (A),Step 3,Agent (B),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (A))),pk(Agent (A)),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),Nonce (NB),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (NB))),scrypt(SymKey (KS),Nonce (NB)),(SID sid)]);
iknows(scrypt(SymKey (KS),Nonce (NB)))

step rule_35:
State (rA,[Agent (A),Step 2,Agent (B),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (A))),pk(Agent (A)),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),(SID sid)]);
iknows(pk(Agent (A)));
iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))));
iknows(Nonce (NB))

=>
request(Agent (A),Agent (honest a),Purpose (pAsKSB),pair(SymKey (KS),Agent (B)),(SID sid));
secrets(SymKey (KS),secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))));
contains(secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))),Agent (A));
contains(secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))),Agent (B));
contains(secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))),Agent (honest a));
State (rA,[Agent (A),Step 3,Agent (B),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (A))),pk(Agent (A)),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),Nonce (NB),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (NB))),scrypt(SymKey (KS),Nonce (NB)),(SID sid)]);
iknows(scrypt(SymKey (KS),Nonce (NB)))

step rule_36:
State (rA,[Agent (A),Step 2,Agent (B),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (A))),pk(Agent (A)),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),(SID sid)]);
iknows(pk(Agent (A)));
iknows(inv(pk(Agent (honest a))));
iknows(Nonce (NA));
iknows(SymKey (KS));
iknows(Agent (B));
iknows(Agent (A));
iknows(Nonce (NB))

=>
request(Agent (A),Agent (honest a),Purpose (pAsKSB),pair(SymKey (KS),Agent (B)),(SID sid));
secrets(SymKey (KS),secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))));
contains(secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))),Agent (A));
contains(secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))),Agent (B));
contains(secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))),Agent (honest a));
State (rA,[Agent (A),Step 3,Agent (B),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (A))),pk(Agent (A)),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),Nonce (NB),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (NB))),scrypt(SymKey (KS),Nonce (NB)),(SID sid)]);
iknows(scrypt(SymKey (KS),Nonce (NB)))

step rule_37:
State (rA,[Agent (A),Step 2,Agent (B),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (A))),pk(Agent (A)),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),(SID sid)]);
iknows(Agent (A));
iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))));
iknows(Nonce (NB))

=>
request(Agent (A),Agent (honest a),Purpose (pAsKSB),pair(SymKey (KS),Agent (B)),(SID sid));
secrets(SymKey (KS),secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))));
contains(secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))),Agent (A));
contains(secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))),Agent (B));
contains(secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))),Agent (honest a));
State (rA,[Agent (A),Step 3,Agent (B),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (A))),pk(Agent (A)),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),Nonce (NB),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (NB))),scrypt(SymKey (KS),Nonce (NB)),(SID sid)]);
iknows(scrypt(SymKey (KS),Nonce (NB)))

step rule_38:
State (rA,[Agent (A),Step 2,Agent (B),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (A))),pk(Agent (A)),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),(SID sid)]);
iknows(Agent (A));
iknows(inv(pk(Agent (honest a))));
iknows(Nonce (NA));
iknows(SymKey (KS));
iknows(Agent (B));
iknows(Nonce (NB))

=>
request(Agent (A),Agent (honest a),Purpose (pAsKSB),pair(SymKey (KS),Agent (B)),(SID sid));
secrets(SymKey (KS),secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))));
contains(secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))),Agent (A));
contains(secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))),Agent (B));
contains(secrecyset(pair(Agent (A),pair((SID sid),Purpose (pKS)))),Agent (honest a));
State (rA,[Agent (A),Step 3,Agent (B),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (A))),pk(Agent (A)),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),Nonce (NB),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (NB))),scrypt(SymKey (KS),Nonce (NB)),(SID sid)]);
iknows(scrypt(SymKey (KS),Nonce (NB)))

step rule_39:
State (rB,[Agent (B),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),crypt(pk(Agent (honest a)),Nonce (NA)),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))),Nonce (NB),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (NB))),(SID sid)]);
iknows(scrypt(SymKey (KS),Nonce (NB)))

=>
request(Agent (B),Agent (honest a),Purpose (pBsKSA),pair(SymKey (KS),Agent (A)),(SID sid));
secrets(SymKey (KS),secrecyset(pair(Agent (B),pair((SID sid),Purpose (pKS)))));
contains(secrecyset(pair(Agent (B),pair((SID sid),Purpose (pKS)))),Agent (A));
contains(secrecyset(pair(Agent (B),pair((SID sid),Purpose (pKS)))),Agent (B));
contains(secrecyset(pair(Agent (B),pair((SID sid),Purpose (pKS)))),Agent (honest a));
State (rB,[Agent (B),Step 3,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),crypt(pk(Agent (honest a)),Nonce (NA)),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))),Nonce (NB),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (NB))),scrypt(SymKey (KS),Nonce (NB)),(SID sid)])

step rule_40:
State (rB,[Agent (B),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),crypt(pk(Agent (honest a)),Nonce (NA)),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))),Nonce (NB),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (NB))),(SID sid)]);
iknows(SymKey (KS));
iknows(Nonce (NB))

=>
request(Agent (B),Agent (honest a),Purpose (pBsKSA),pair(SymKey (KS),Agent (A)),(SID sid));
secrets(SymKey (KS),secrecyset(pair(Agent (B),pair((SID sid),Purpose (pKS)))));
contains(secrecyset(pair(Agent (B),pair((SID sid),Purpose (pKS)))),Agent (A));
contains(secrecyset(pair(Agent (B),pair((SID sid),Purpose (pKS)))),Agent (B));
contains(secrecyset(pair(Agent (B),pair((SID sid),Purpose (pKS)))),Agent (honest a));
State (rB,[Agent (B),Step 3,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (B))),pk(Agent (B)),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),pair(Agent (A),pair(Agent (B),crypt(pk(Agent (honest a)),Nonce (NA)))),crypt(pk(Agent (honest a)),Nonce (NA)),SymKey (KS),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A)))))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))))),Nonce (NB),crypt(pk(Agent (A)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (NA),pair(SymKey (KS),pair(Agent (B),Agent (A))))),Nonce (NB))),scrypt(SymKey (KS),Nonce (NB)),(SID sid)])


section initial state:
init_0: iknows(Nonce (ni));
init_1: iknows(Agent (dishonest i));
init_2: State (rA,[Agent (honest a),Step 0,Agent (dishonest i),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),(SID sid)]);
init_3: State (rA,[Agent (honest a),Step 0,Agent (honest a),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),(SID sid)]);
init_4: iknows(Step 0);
init_5: iknows(pk(Agent (honest a)));
init_6: iknows(Agent (honest a));
init_7: iknows(inv(pk(Agent (dishonest i))));
init_8: iknows(pk(Agent (dishonest i)));
init_9: iknows((SID sid));
init_10: iknows(Agent (honest a));
init_11: State (rB,[Agent (honest a),Step 0,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (dishonest i),(SID sid)]);
init_12: State (rB,[Agent (honest a),Step 0,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (honest a),(SID sid)]);
init_13: State (rs,[Agent (honest a),Step 0,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),pk(Agent (dishonest i)),Agent (dishonest i),Agent (dishonest i),(SID sid)]);
init_14: State (rs,[Agent (honest a),Step 0,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),pk(Agent (honest a)),Agent (dishonest i),Agent (honest a),(SID sid)]);
init_15: State (rs,[Agent (honest a),Step 0,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),pk(Agent (dishonest i)),Agent (honest a),Agent (dishonest i),(SID sid)]);
init_16: State (rs,[Agent (honest a),Step 0,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),Agent (honest a),(SID sid)]);

section fixedpoint:
fp_0: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni))));
fp_1: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_2: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_3: iknows(pair(Agent (honest a),Agent (honest a)));
fp_4: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_5: State (rA,[Agent (honest a),Step 1,Agent (dishonest i),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),pair(Agent (honest a),Agent (dishonest i)),(SID sid)]);
fp_6: State (rA,[Agent (honest a),Step 1,Agent (honest a),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),pair(Agent (honest a),Agent (honest a)),(SID sid)]);
fp_7: State (rs,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),pk(Agent (dishonest i)),Agent (dishonest i),Agent (dishonest i),pair(Agent (dishonest i),Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),(SID sid)]);
fp_8: State (rs,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),pk(Agent (honest a)),Agent (dishonest i),Agent (honest a),pair(Agent (honest a),Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),(SID sid)]);
fp_9: State (rs,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),pk(Agent (dishonest i)),Agent (honest a),Agent (dishonest i),pair(Agent (dishonest i),Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),(SID sid)]);
fp_10: State (rs,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),Agent (honest a),pair(Agent (honest a),Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),(SID sid)]);
fp_11: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (dishonest i),Nonce (ni),crypt(pk(Agent (honest a)),pair(Nonce (ni),Agent (dishonest i))),pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))),(SID sid)]);
fp_12: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (honest a),Nonce (ni),crypt(pk(Agent (honest a)),pair(Nonce (ni),Agent (honest a))),pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))),(SID sid)]);
fp_13: iknows(crypt(pk(Agent (honest a)),Nonce (ni)));
fp_14: iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))));
fp_15: iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))));
fp_16: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_17: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_18: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_19: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_20: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni))));
fp_21: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_22: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_23: iknows(pair(Agent (honest a),Agent (honest a)));
fp_24: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_25: iknows(pair(Agent (dishonest i),pk(Agent (dishonest i))));
fp_26: iknows(pair(Agent (honest a),pk(Agent (honest a))));
fp_27: State (rA,[Agent (honest a),Step 2,Agent (dishonest i),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),pair(Agent (honest a),Agent (dishonest i)),pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),(SID sid)]);
fp_28: State (rA,[Agent (honest a),Step 2,Agent (honest a),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),pair(Agent (honest a),Agent (honest a)),pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))),(SID sid)]);
fp_29: witness(Agent (honest a),Agent (dishonest i),Purpose (pAsKSB),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)));
fp_30: witness(Agent (honest a),Agent (dishonest i),Purpose (pBsKSA),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)));
fp_31: secrets(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),secrecyset(pair(Agent (honest a),pair((SID sid),Purpose (pKS)))));
fp_32: contains(secrecyset(pair(Agent (honest a),pair((SID sid),Purpose (pKS)))),Agent (dishonest i));
fp_33: contains(secrecyset(pair(Agent (honest a),pair((SID sid),Purpose (pKS)))),Agent (honest a));
fp_34: State (rs,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),pk(Agent (dishonest i)),Agent (dishonest i),Agent (dishonest i),pair(Agent (dishonest i),Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),Nonce (ni),crypt(pk(Agent (honest a)),Nonce (ni)),pair(Agent (dishonest i),pair(Agent (dishonest i),crypt(pk(Agent (honest a)),Nonce (ni)))),SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))),(SID sid)]);
fp_35: witness(Agent (honest a),Agent (honest a),Purpose (pAsKSB),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i)));
fp_36: witness(Agent (honest a),Agent (dishonest i),Purpose (pBsKSA),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),Agent (honest a)));
fp_37: secrets(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),secrecyset(pair(Agent (honest a),pair((SID sid),Purpose (pKS)))));
fp_38: State (rs,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),pk(Agent (honest a)),Agent (dishonest i),Agent (honest a),pair(Agent (honest a),Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),Nonce (ni),crypt(pk(Agent (honest a)),Nonce (ni)),pair(Agent (honest a),pair(Agent (dishonest i),crypt(pk(Agent (honest a)),Nonce (ni)))),SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))),(SID sid)]);
fp_39: witness(Agent (honest a),Agent (dishonest i),Purpose (pAsKSB),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_40: witness(Agent (honest a),Agent (honest a),Purpose (pBsKSA),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)));
fp_41: secrets(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),secrecyset(pair(Agent (honest a),pair((SID sid),Purpose (pKS)))));
fp_42: State (rs,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),pk(Agent (dishonest i)),Agent (honest a),Agent (dishonest i),pair(Agent (dishonest i),Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),Nonce (ni),crypt(pk(Agent (honest a)),Nonce (ni)),pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))),SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_43: witness(Agent (honest a),Agent (honest a),Purpose (pAsKSB),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)));
fp_44: witness(Agent (honest a),Agent (honest a),Purpose (pBsKSA),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)));
fp_45: secrets(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),secrecyset(pair(Agent (honest a),pair((SID sid),Purpose (pKS)))));
fp_46: State (rs,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),Agent (honest a),pair(Agent (honest a),Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),Nonce (ni),crypt(pk(Agent (honest a)),Nonce (ni)),pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))),SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_47: iknows(crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a)))))));
fp_48: iknows(crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))))));
fp_49: iknows(crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))))));
fp_50: iknows(crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))))));
fp_51: iknows(crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))));
fp_52: iknows(crypt(pk(Agent (dishonest i)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))));
fp_53: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_54: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_55: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_56: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_57: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni))));
fp_58: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_59: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_60: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_61: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))));
fp_62: iknows(pair(Agent (honest a),Agent (honest a)));
fp_63: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_64: iknows(pair(Agent (dishonest i),pk(Agent (dishonest i))));
fp_65: iknows(pair(Agent (honest a),pk(Agent (honest a))));
fp_66: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_67: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))),pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_68: State (rB,[Agent (honest a),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (dishonest i),Nonce (ni),crypt(pk(Agent (honest a)),pair(Nonce (ni),Agent (dishonest i))),pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))),crypt(pk(Agent (honest a)),Nonce (ni)),SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))))),pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),(SID sid)]);
fp_69: State (rB,[Agent (honest a),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (honest a),Nonce (ni),crypt(pk(Agent (honest a)),pair(Nonce (ni),Agent (honest a))),pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))),crypt(pk(Agent (honest a)),Nonce (ni)),SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a)))))),pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),(SID sid)]);
fp_70: iknows(crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))));
fp_71: iknows(crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_72: iknows(crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))));
fp_73: iknows(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))));
fp_74: iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))));
fp_75: iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))));
fp_76: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_77: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_78: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_79: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_80: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_81: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_82: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_83: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_84: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_85: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_86: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_87: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_88: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni))));
fp_89: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_90: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_91: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_92: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_93: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_94: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_95: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))));
fp_96: iknows(pair(Agent (honest a),Agent (honest a)));
fp_97: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_98: iknows(pair(Agent (dishonest i),pk(Agent (dishonest i))));
fp_99: iknows(pair(Agent (honest a),pk(Agent (honest a))));
fp_100: iknows(pair(Agent (dishonest i),Agent (honest a)));
fp_101: iknows(pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))));
fp_102: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_103: iknows(pair(Agent (dishonest i),Agent (dishonest i)));
fp_104: iknows(pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))));
fp_105: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_106: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_107: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_108: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))),pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_109: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_110: State (rs,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),pk(Agent (dishonest i)),Agent (dishonest i),Agent (dishonest i),pair(Agent (dishonest i),Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),pair(Agent (dishonest i),pair(Agent (dishonest i),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))),(SID sid)]);
fp_111: State (rs,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),pk(Agent (honest a)),Agent (dishonest i),Agent (honest a),pair(Agent (honest a),Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),pair(Agent (honest a),pair(Agent (dishonest i),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))),(SID sid)]);
fp_112: State (rs,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),pk(Agent (dishonest i)),Agent (honest a),Agent (dishonest i),pair(Agent (dishonest i),Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_113: State (rs,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),Agent (honest a),pair(Agent (honest a),Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_114: State (rs,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),pk(Agent (dishonest i)),Agent (dishonest i),Agent (dishonest i),pair(Agent (dishonest i),Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Agent (dishonest i),pair(Agent (dishonest i),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))),(SID sid)]);
fp_115: State (rs,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),pk(Agent (honest a)),Agent (dishonest i),Agent (honest a),pair(Agent (honest a),Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Agent (honest a),pair(Agent (dishonest i),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))),(SID sid)]);
fp_116: State (rs,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),pk(Agent (dishonest i)),Agent (honest a),Agent (dishonest i),pair(Agent (dishonest i),Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_117: State (rs,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),Agent (honest a),pair(Agent (honest a),Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_118: iknows(crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a)))))));
fp_119: iknows(crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))))));
fp_120: iknows(crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))))));
fp_121: iknows(crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))))));
fp_122: iknows(crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a)))))));
fp_123: iknows(crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))))));
fp_124: iknows(crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))))));
fp_125: iknows(crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))))));
fp_126: iknows(crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))));
fp_127: iknows(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))));
fp_128: iknows(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))));
fp_129: iknows(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))));
fp_130: iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))));
fp_131: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_132: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_133: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_134: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_135: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_136: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_137: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_138: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_139: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_140: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_141: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_142: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_143: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_144: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_145: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_146: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_147: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni))));
fp_148: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_149: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_150: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_151: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_152: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_153: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_154: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_155: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_156: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_157: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))));
fp_158: iknows(pair(Agent (honest a),Agent (honest a)));
fp_159: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_160: iknows(pair(Agent (dishonest i),pk(Agent (dishonest i))));
fp_161: iknows(pair(Agent (honest a),pk(Agent (honest a))));
fp_162: iknows(pair(Agent (dishonest i),Agent (honest a)));
fp_163: iknows(pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))));
fp_164: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_165: iknows(pair(Agent (dishonest i),Agent (dishonest i)));
fp_166: iknows(pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))));
fp_167: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_168: iknows(pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))));
fp_169: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))));
fp_170: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_171: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_172: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))),pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_173: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_174: State (rs,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),pk(Agent (dishonest i)),Agent (dishonest i),Agent (dishonest i),pair(Agent (dishonest i),Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Agent (dishonest i),pair(Agent (dishonest i),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))),(SID sid)]);
fp_175: State (rs,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),pk(Agent (honest a)),Agent (dishonest i),Agent (honest a),pair(Agent (honest a),Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Agent (honest a),pair(Agent (dishonest i),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))),(SID sid)]);
fp_176: State (rs,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),pk(Agent (dishonest i)),Agent (honest a),Agent (dishonest i),pair(Agent (dishonest i),Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_177: State (rs,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),Agent (honest a),pair(Agent (honest a),Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_178: State (rB,[Agent (honest a),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))),pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))))),pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),(SID sid)]);
fp_179: State (rB,[Agent (honest a),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a)))))),pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),(SID sid)]);
fp_180: State (rB,[Agent (honest a),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))),pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a)))))),pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),(SID sid)]);
fp_181: iknows(crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))));
fp_182: iknows(crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))));
fp_183: iknows(crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_184: iknows(crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a)))))));
fp_185: iknows(crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))))));
fp_186: iknows(crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))))));
fp_187: iknows(crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))))));
fp_188: iknows(crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_189: iknows(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))));
fp_190: iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))));
fp_191: iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))));
fp_192: iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))));
fp_193: iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))));
fp_194: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_195: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_196: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_197: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_198: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_199: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_200: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_201: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_202: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_203: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_204: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_205: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_206: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_207: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_208: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_209: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_210: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni))));
fp_211: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_212: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_213: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_214: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_215: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_216: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_217: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_218: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_219: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_220: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))));
fp_221: iknows(pair(Agent (honest a),Agent (honest a)));
fp_222: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_223: iknows(pair(Agent (dishonest i),pk(Agent (dishonest i))));
fp_224: iknows(pair(Agent (honest a),pk(Agent (honest a))));
fp_225: iknows(pair(Agent (dishonest i),Agent (honest a)));
fp_226: iknows(pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))));
fp_227: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_228: iknows(pair(Agent (dishonest i),Agent (dishonest i)));
fp_229: iknows(pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))));
fp_230: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_231: iknows(pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))));
fp_232: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))));
fp_233: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_234: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_235: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_236: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_237: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_238: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_239: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_240: State (rB,[Agent (honest a),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))),pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))))),pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),(SID sid)]);
fp_241: State (rB,[Agent (honest a),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a)))))),pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),(SID sid)]);
fp_242: request(Agent (honest a),Agent (honest a),Purpose (pAsKSB),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)),(SID sid));
fp_243: State (rA,[Agent (honest a),Step 3,Agent (honest a),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),pair(Agent (honest a),Agent (honest a)),pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),scrypt(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),(SID sid)]);
fp_244: request(Agent (honest a),Agent (honest a),Purpose (pAsKSB),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i)),(SID sid));
fp_245: State (rA,[Agent (honest a),Step 3,Agent (dishonest i),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),pair(Agent (honest a),Agent (dishonest i)),pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_246: State (rA,[Agent (honest a),Step 3,Agent (dishonest i),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),pair(Agent (honest a),Agent (dishonest i)),pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_247: State (rA,[Agent (honest a),Step 3,Agent (dishonest i),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),pair(Agent (honest a),Agent (dishonest i)),pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),Nonce (ni),SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))),Nonce (ni))),scrypt(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),Nonce (ni)),(SID sid)]);
fp_248: request(Agent (honest a),Agent (honest a),Purpose (pBsKSA),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)),(SID sid));
fp_249: State (rB,[Agent (honest a),Step 3,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))),pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))))),pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_250: State (rB,[Agent (honest a),Step 3,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (dishonest i),Nonce (ni),crypt(pk(Agent (honest a)),pair(Nonce (ni),Agent (dishonest i))),pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))),crypt(pk(Agent (honest a)),Nonce (ni)),SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))))),pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_251: iknows(scrypt(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),Nonce (ni)));
fp_252: iknows(scrypt(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))));
fp_253: iknows(scrypt(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_254: iknows(scrypt(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))));
fp_255: iknows(crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))));
fp_256: iknows(crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_257: iknows(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))));
fp_258: iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))));
fp_259: iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))));
fp_260: iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))));
fp_261: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_262: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_263: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_264: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_265: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_266: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_267: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_268: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_269: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_270: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_271: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_272: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_273: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_274: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_275: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_276: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_277: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni))));
fp_278: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_279: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_280: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_281: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_282: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_283: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_284: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_285: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_286: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_287: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))));
fp_288: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))));
fp_289: iknows(pair(Agent (honest a),Agent (honest a)));
fp_290: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_291: iknows(pair(Agent (dishonest i),pk(Agent (dishonest i))));
fp_292: iknows(pair(Agent (honest a),pk(Agent (honest a))));
fp_293: iknows(pair(Agent (dishonest i),Agent (honest a)));
fp_294: iknows(pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))));
fp_295: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_296: iknows(pair(Agent (dishonest i),Agent (dishonest i)));
fp_297: iknows(pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))));
fp_298: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_299: iknows(pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))));
fp_300: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))));
fp_301: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_302: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_303: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_304: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_305: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))));
fp_306: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_307: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_308: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_309: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_310: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_311: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_312: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i))),pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_313: State (rA,[Agent (honest a),Step 3,Agent (dishonest i),pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),pair(Agent (honest a),Agent (dishonest i)),pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),scrypt(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),(SID sid)]);
fp_314: request(Agent (honest a),Agent (honest a),Purpose (pBsKSA),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)),(SID sid));
fp_315: State (rB,[Agent (honest a),Step 3,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a)))))),pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),scrypt(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),(SID sid)]);
fp_316: State (rB,[Agent (honest a),Step 3,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a)))))),pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),scrypt(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),(SID sid)]);
fp_317: State (rB,[Agent (honest a),Step 3,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))),pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a)))))),pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),scrypt(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),(SID sid)]);
fp_318: State (rB,[Agent (honest a),Step 3,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (honest a),Nonce (ni),crypt(pk(Agent (honest a)),pair(Nonce (ni),Agent (honest a))),pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))),crypt(pk(Agent (honest a)),Nonce (ni)),SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a)))))),pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),scrypt(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),(SID sid)]);
fp_319: State (rB,[Agent (honest a),Step 3,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))),pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))))),pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_320: iknows(scrypt(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))));
fp_321: iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))));
fp_322: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_323: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_324: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_325: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_326: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_327: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_328: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_329: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_330: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_331: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_332: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_333: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_334: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_335: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_336: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_337: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_338: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni))));
fp_339: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_340: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_341: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_342: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_343: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_344: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_345: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_346: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_347: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_348: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))));
fp_349: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))));
fp_350: iknows(pair(Agent (honest a),Agent (honest a)));
fp_351: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_352: iknows(pair(Agent (dishonest i),pk(Agent (dishonest i))));
fp_353: iknows(pair(Agent (honest a),pk(Agent (honest a))));
fp_354: iknows(pair(Agent (dishonest i),Agent (honest a)));
fp_355: iknows(pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))));
fp_356: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_357: iknows(pair(Agent (dishonest i),Agent (dishonest i)));
fp_358: iknows(pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))));
fp_359: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_360: iknows(pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))));
fp_361: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))));
fp_362: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_363: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_364: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_365: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_366: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))));
fp_367: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_368: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_369: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))));
fp_370: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_371: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_372: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_373: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_374: State (rB,[Agent (honest a),Step 2,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i))),pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))))),pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),(SID sid)]);
fp_375: iknows(crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_376: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_377: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_378: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_379: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_380: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_381: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_382: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_383: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_384: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_385: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_386: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_387: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_388: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_389: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_390: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_391: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_392: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni))));
fp_393: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_394: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_395: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_396: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_397: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_398: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_399: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_400: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_401: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_402: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))));
fp_403: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))));
fp_404: iknows(pair(Agent (honest a),Agent (honest a)));
fp_405: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_406: iknows(pair(Agent (dishonest i),pk(Agent (dishonest i))));
fp_407: iknows(pair(Agent (honest a),pk(Agent (honest a))));
fp_408: iknows(pair(Agent (dishonest i),Agent (honest a)));
fp_409: iknows(pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))));
fp_410: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_411: iknows(pair(Agent (dishonest i),Agent (dishonest i)));
fp_412: iknows(pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))));
fp_413: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_414: iknows(pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))));
fp_415: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))));
fp_416: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_417: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_418: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_419: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_420: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))));
fp_421: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_422: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_423: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))));
fp_424: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_425: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_426: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_427: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_428: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_429: State (rB,[Agent (honest a),Step 3,pk(Agent (honest a)),Agent (honest a),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i))),pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))))),pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_430: iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))));
fp_431: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_432: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_433: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_434: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Agent (honest a))))))));
fp_435: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_436: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_437: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_438: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))))));
fp_439: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_440: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_441: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_442: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))))))));
fp_443: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_444: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_445: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_446: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_447: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni))));
fp_448: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_449: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_450: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_451: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_452: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_453: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (ni)))));
fp_454: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_455: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_456: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_457: iknows(pair(Agent (dishonest i),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))));
fp_458: iknows(pair(Agent (honest a),pair(Agent (honest a),crypt(pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))));
fp_459: iknows(pair(Agent (honest a),Agent (honest a)));
fp_460: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_461: iknows(pair(Agent (dishonest i),pk(Agent (dishonest i))));
fp_462: iknows(pair(Agent (honest a),pk(Agent (honest a))));
fp_463: iknows(pair(Agent (dishonest i),Agent (honest a)));
fp_464: iknows(pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a))));
fp_465: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_466: iknows(pair(Agent (dishonest i),Agent (dishonest i)));
fp_467: iknows(pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i))));
fp_468: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_469: iknows(pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))));
fp_470: iknows(pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))));
fp_471: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_472: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_473: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_474: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_475: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))));
fp_476: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),Agent (honest a)))));
fp_477: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Agent (dishonest i),Agent (dishonest i)))));
fp_478: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))));
fp_479: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i)))));
fp_480: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_481: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (ni),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_482: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_483: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_484: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKS(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));

section abstraction:
NA->Nonce (absNA(pair(A,B)));
KS->SymKey (absKS(pair(B,A)));
NB->Nonce (absNB(pair(B,A)))

