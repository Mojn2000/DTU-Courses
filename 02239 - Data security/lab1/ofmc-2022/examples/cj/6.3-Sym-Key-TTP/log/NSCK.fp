Backend: Open-Source Fixedpoint Model-Checker version 2020 
Protocol: NSCK
Types:
[(Purpose,["purposeNB","purposeNB"]),(Agent False False,["A","B","s"]),(Number,["NA","NB","NB2"]),(SymmetricKey,["KAB"]),(Function,["sk","pre"])]
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
request(A,B,Purpose (purposeKAB),M,(SID sid))
 | B/=Agent (dishonest i);
M/=SymKey (absKAB(pair(B,A)))
=>
attack(pair(authentication,pair(A,pair(B,M))))

step rule_7:
request(A,B,Purpose (purposeNB),M,(SID sid))
 | B/=Agent (dishonest i);
M/=Nonce (absNB(pair(B,A)))
=>
attack(pair(authentication,pair(A,pair(B,M))))

step rule_8:
State (rA,[Agent (A),Step 0,SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),(SID sid)])

=>
State (rA,[Agent (A),Step 1,SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),Nonce (absNA(pair(Agent (A),Agent (B)))),pair(Agent (A),pair(Agent (B),Nonce (absNA(pair(Agent (A),Agent (B)))))),(SID sid)]);
iknows(pair(Agent (A),pair(Agent (B),Nonce (absNA(pair(Agent (A),Agent (B)))))))

step rule_9:
State (rs,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (B),Agent (honest a)))),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),Agent (A),(SID sid)]);
iknows(Agent (A));
iknows(Agent (B));
iknows(Nonce (NA))

=>
State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (B),Agent (honest a)))),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),Agent (A),Nonce (NA),pair(Agent (A),pair(Agent (B),Nonce (NA))),SymKey (absKAB(pair(Agent (B),Agent (A)))),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Nonce (NA),pair(Agent (B),pair(SymKey (absKAB(pair(Agent (B),Agent (A)))),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (B),Agent (A)))),Agent (A))))))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Nonce (NA),pair(Agent (B),pair(SymKey (absKAB(pair(Agent (B),Agent (A)))),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (B),Agent (A)))),Agent (A))))))))

step rule_10:
State (rA,[Agent (A),Step 1,SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),Nonce (NA),pair(Agent (A),pair(Agent (B),Nonce (NA))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Nonce (NA),pair(Agent (B),pair(SymKey (KAB),Agent (dishonest i))))))

=>
State (rA,[Agent (A),Step 2,SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),Nonce (NA),pair(Agent (A),pair(Agent (B),Nonce (NA))),Agent (dishonest i),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Nonce (NA),pair(Agent (B),pair(SymKey (KAB),Agent (dishonest i))))),(SID sid)]);
iknows(Agent (dishonest i))

step rule_11:
State (rA,[Agent (A),Step 1,SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),Nonce (NA),pair(Agent (A),pair(Agent (B),Nonce (NA))),(SID sid)]);
iknows(SymKey (sk(pair(Agent (A),Agent (honest a)))));
iknows(Nonce (NA));
iknows(Agent (B));
iknows(SymKey (KAB));
iknows(Agent (dishonest i))

=>
State (rA,[Agent (A),Step 2,SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),Nonce (NA),pair(Agent (A),pair(Agent (B),Nonce (NA))),Agent (dishonest i),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Nonce (NA),pair(Agent (B),pair(SymKey (KAB),Agent (dishonest i))))),(SID sid)]);
iknows(Agent (dishonest i))

step rule_12:
State (rB,[Agent (B),Step 0,SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (A),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(SymKey (KAB),Agent (A))))

=>
secret(Nonce (absNB(pair(Agent (B),Agent (A)))),Agent (A));
witness(Agent (B),Agent (A),Purpose (pABNB),Nonce (absNB(pair(Agent (B),Agent (A)))));
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (A),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(SymKey (KAB),Agent (A))),Nonce (absNB(pair(Agent (B),Agent (A)))),scrypt(SymKey (KAB),Nonce (absNB(pair(Agent (B),Agent (A))))),(SID sid)]);
iknows(scrypt(SymKey (KAB),Nonce (absNB(pair(Agent (B),Agent (A))))))

step rule_13:
State (rB,[Agent (B),Step 0,SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (A),(SID sid)]);
iknows(SymKey (sk(pair(Agent (B),Agent (honest a)))));
iknows(SymKey (KAB));
iknows(Agent (A))

=>
secret(Nonce (absNB(pair(Agent (B),Agent (A)))),Agent (A));
witness(Agent (B),Agent (A),Purpose (pABNB),Nonce (absNB(pair(Agent (B),Agent (A)))));
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (A),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(SymKey (KAB),Agent (A))),Nonce (absNB(pair(Agent (B),Agent (A)))),scrypt(SymKey (KAB),Nonce (absNB(pair(Agent (B),Agent (A))))),(SID sid)]);
iknows(scrypt(SymKey (KAB),Nonce (absNB(pair(Agent (B),Agent (A))))))

step rule_14:
State (rA,[Agent (A),Step 2,SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),Nonce (NA),pair(Agent (A),pair(Agent (B),Nonce (NA))),Agent (dishonest i),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Nonce (NA),pair(Agent (B),pair(SymKey (KAB),Agent (dishonest i))))),(SID sid)]);
iknows(scrypt(SymKey (KAB),Nonce (NB)))

=>
request(Agent (A),Agent (B),Purpose (pABNB),Nonce (NB),(SID sid));
witness(Agent (A),Agent (B),Purpose (pBANB),Nonce (NB));
State (rA,[Agent (A),Step 3,SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),Nonce (NA),pair(Agent (A),pair(Agent (B),Nonce (NA))),Agent (dishonest i),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Nonce (NA),pair(Agent (B),pair(SymKey (KAB),Agent (dishonest i))))),Nonce (NB),scrypt(SymKey (KAB),Nonce (NB)),scrypt(SymKey (KAB),pre(Nonce (NB))),(SID sid)]);
iknows(scrypt(SymKey (KAB),pre(Nonce (NB))))

step rule_15:
State (rA,[Agent (A),Step 2,SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),Nonce (NA),pair(Agent (A),pair(Agent (B),Nonce (NA))),Agent (dishonest i),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Nonce (NA),pair(Agent (B),pair(SymKey (KAB),Agent (dishonest i))))),(SID sid)]);
iknows(SymKey (KAB));
iknows(Nonce (NB))

=>
request(Agent (A),Agent (B),Purpose (pABNB),Nonce (NB),(SID sid));
witness(Agent (A),Agent (B),Purpose (pBANB),Nonce (NB));
State (rA,[Agent (A),Step 3,SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),Nonce (NA),pair(Agent (A),pair(Agent (B),Nonce (NA))),Agent (dishonest i),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Nonce (NA),pair(Agent (B),pair(SymKey (KAB),Agent (dishonest i))))),Nonce (NB),scrypt(SymKey (KAB),Nonce (NB)),scrypt(SymKey (KAB),pre(Nonce (NB))),(SID sid)]);
iknows(scrypt(SymKey (KAB),pre(Nonce (NB))))

step rule_16:
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (A),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(SymKey (KAB),Agent (A))),Nonce (NB),scrypt(SymKey (KAB),Nonce (NB)),(SID sid)]);
iknows(scrypt(SymKey (KAB),pre(Nonce (NB))))

=>
request(Agent (B),Agent (A),Purpose (pBANB),Nonce (NB),(SID sid));
State (rB,[Agent (B),Step 2,SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (A),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(SymKey (KAB),Agent (A))),Nonce (NB),scrypt(SymKey (KAB),Nonce (NB)),scrypt(SymKey (KAB),pre(Nonce (NB))),(SID sid)])

step rule_17:
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (A),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(SymKey (KAB),Agent (A))),Nonce (NB),scrypt(SymKey (KAB),Nonce (NB)),(SID sid)]);
iknows(SymKey (KAB));
iknows(pre(Nonce (NB)))

=>
request(Agent (B),Agent (A),Purpose (pBANB),Nonce (NB),(SID sid));
State (rB,[Agent (B),Step 2,SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (A),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(SymKey (KAB),Agent (A))),Nonce (NB),scrypt(SymKey (KAB),Nonce (NB)),scrypt(SymKey (KAB),pre(Nonce (NB))),(SID sid)])

step rule_18:
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (A),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(SymKey (KAB),Agent (A))),Nonce (NB),scrypt(SymKey (KAB),Nonce (NB)),(SID sid)]);
iknows(SymKey (KAB));
iknows(Nonce (NB))

=>
request(Agent (B),Agent (A),Purpose (pBANB),Nonce (NB),(SID sid));
State (rB,[Agent (B),Step 2,SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (A),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(SymKey (KAB),Agent (A))),Nonce (NB),scrypt(SymKey (KAB),Nonce (NB)),scrypt(SymKey (KAB),pre(Nonce (NB))),(SID sid)])


section initial state:
init_0: iknows(Nonce (ni));
init_1: iknows(Agent (dishonest i));
init_2: State (rA,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),(SID sid)]);
init_3: State (rA,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),(SID sid)]);
init_4: iknows(Step 0);
init_5: iknows(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))));
init_6: iknows((SID sid));
init_7: iknows(Agent (honest a));
init_8: State (rB,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),(SID sid)]);
init_9: State (rB,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),(SID sid)]);
init_10: State (rs,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Agent (dishonest i),(SID sid)]);
init_11: State (rs,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),Agent (honest a),(SID sid)]);
init_12: State (rs,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (honest a),Agent (dishonest i),(SID sid)]);
init_13: State (rs,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (honest a),(SID sid)]);

section fixedpoint:
fp_0: iknows(pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))));
fp_1: iknows(pair(Agent (honest a),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_2: iknows(pair(Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))));
fp_3: iknows(pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_4: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),(SID sid)]);
fp_5: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),(SID sid)]);
fp_6: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Agent (dishonest i),Nonce (ni),pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (ni))),SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (ni),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i))))))),(SID sid)]);
fp_7: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),Agent (honest a),Nonce (ni),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (ni))),SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (ni),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),Agent (honest a))))))),(SID sid)]);
fp_8: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (honest a),Agent (dishonest i),Nonce (ni),pair(Agent (dishonest i),pair(Agent (honest a),Nonce (ni))),SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (ni),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))))))),(SID sid)]);
fp_9: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (honest a),Nonce (ni),pair(Agent (honest a),pair(Agent (honest a),Nonce (ni))),SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (ni),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))))))),(SID sid)]);
fp_10: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (ni),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))))))));
fp_11: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (ni),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))))))));
fp_12: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (ni),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),Agent (honest a))))))));
fp_13: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (ni),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i))))))));
fp_14: iknows(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))));
fp_15: iknows(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))));
fp_16: iknows(pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))));
fp_17: iknows(pair(Agent (honest a),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_18: iknows(pair(Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))));
fp_19: iknows(pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_20: iknows(pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)))));
fp_21: iknows(pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i))))));
fp_22: iknows(pair(Nonce (ni),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_23: iknows(pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))));
fp_24: iknows(pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))))));
fp_25: iknows(pair(Nonce (ni),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_26: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i))))))),(SID sid)]);
fp_27: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i))))))),(SID sid)]);
fp_28: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),Agent (honest a))))))),(SID sid)]);
fp_29: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),Agent (honest a))))))),(SID sid)]);
fp_30: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (honest a),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))))))),(SID sid)]);
fp_31: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (honest a),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))))))),(SID sid)]);
fp_32: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))))))),(SID sid)]);
fp_33: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))))))),(SID sid)]);
fp_34: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))))))));
fp_35: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))))))));
fp_36: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))))))));
fp_37: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))))))));
fp_38: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),Agent (honest a))))))));
fp_39: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),Agent (honest a))))))));
fp_40: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i))))))));
fp_41: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i))))))));
fp_42: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i))));
fp_43: iknows(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))));
fp_44: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))));
fp_45: iknows(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))));
fp_46: iknows(pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))));
fp_47: iknows(pair(Agent (honest a),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_48: iknows(pair(Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))));
fp_49: iknows(pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_50: iknows(pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)))));
fp_51: iknows(pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i))))));
fp_52: iknows(pair(Nonce (ni),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_53: iknows(pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))));
fp_54: iknows(pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))))));
fp_55: iknows(pair(Nonce (ni),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_56: iknows(pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)));
fp_57: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_58: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_59: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_60: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_61: secret(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i));
fp_62: witness(Agent (honest a),Agent (dishonest i),Purpose (pABNB),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))));
fp_63: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_64: iknows(scrypt(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_65: iknows(pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))));
fp_66: iknows(pair(Agent (honest a),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_67: iknows(pair(Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))));
fp_68: iknows(pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_69: iknows(pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)))));
fp_70: iknows(pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i))))));
fp_71: iknows(pair(Nonce (ni),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_72: iknows(pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))));
fp_73: iknows(pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))))));
fp_74: iknows(pair(Nonce (ni),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_75: iknows(pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)));
fp_76: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_77: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_78: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_79: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_80: iknows(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))));
fp_81: iknows(pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))));
fp_82: iknows(pair(Agent (honest a),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_83: iknows(pair(Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))));
fp_84: iknows(pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_85: iknows(pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)))));
fp_86: iknows(pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i))))));
fp_87: iknows(pair(Nonce (ni),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_88: iknows(pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))));
fp_89: iknows(pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))))));
fp_90: iknows(pair(Nonce (ni),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_91: iknows(pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)));
fp_92: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_93: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_94: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_95: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_96: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i))))))),(SID sid)]);
fp_97: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),Agent (honest a))))))),(SID sid)]);
fp_98: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (honest a),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))))))),(SID sid)]);
fp_99: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))))))),(SID sid)]);
fp_100: request(Agent (honest a),Agent (dishonest i),Purpose (pBANB),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_101: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pre(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),(SID sid)]);
fp_102: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))))))));
fp_103: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))))))));
fp_104: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),Agent (honest a))))))));
fp_105: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i))))))));
fp_106: iknows(pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))));
fp_107: iknows(pair(Agent (honest a),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_108: iknows(pair(Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))));
fp_109: iknows(pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_110: iknows(pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)))));
fp_111: iknows(pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i))))));
fp_112: iknows(pair(Nonce (ni),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_113: iknows(pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))));
fp_114: iknows(pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))))));
fp_115: iknows(pair(Nonce (ni),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_116: iknows(pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)));
fp_117: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_118: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_119: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_120: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_121: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Agent (dishonest i)))))));
fp_122: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))))));

section abstraction:
NA->Nonce (absNA(pair(A,B)));
KAB->SymKey (absKAB(pair(B,A)));
NB->Nonce (absNB(pair(B,A)))

