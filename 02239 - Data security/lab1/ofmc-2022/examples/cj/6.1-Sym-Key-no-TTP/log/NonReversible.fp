Backend: Open-Source Fixedpoint Model-Checker version 2020 
Protocol: NonReversible
Types:
[(Purpose,["purposeNA","purposeNB"]),(Agent False False,["A","B"]),(Number,["NA","NB"]),(SymmetricKey,["K"]),(Function,["sk","f"])]
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
request(A,B,Purpose (purposeNB),M,(SID sid))
 | B/=Agent (dishonest i);
M/=Nonce (absNB(pair(B,A)))
=>
attack(pair(authentication,pair(A,pair(B,M))))

step rule_6:
request(A,B,Purpose (purposeNA),M,(SID sid))
 | B/=Agent (dishonest i);
M/=Nonce (absNA(pair(B,A)))
=>
attack(pair(authentication,pair(A,pair(B,M))))

step rule_7:
request(A,B,Purpose (purposeK),M,(SID sid))
 | B/=Agent (dishonest i);
M/=SymKey (absK(pair(B,A)))
=>
attack(pair(authentication,pair(A,pair(B,M))))

step rule_8:
State (rB,[Agent (B),Step 0,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),(SID sid)])

=>
witness(Agent (B),Agent (A),Purpose (pABNB),Nonce (absNB(pair(Agent (B),Agent (A)))));
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (absNB(pair(Agent (B),Agent (A)))),pair(Agent (B),Nonce (absNB(pair(Agent (B),Agent (A))))),(SID sid)]);
iknows(pair(Agent (B),Nonce (absNB(pair(Agent (B),Agent (A))))))

step rule_9:
State (rA,[Agent (A),Step 0,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),(SID sid)]);
iknows(Agent (B));
iknows(Nonce (NB))

=>
secret(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B));
witness(Agent (A),Agent (B),Purpose (pBANA),Nonce (absNA(pair(Agent (A),Agent (B)))));
State (rA,[Agent (A),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (NB),pair(Agent (B),Nonce (NB)),Nonce (absNA(pair(Agent (A),Agent (B)))),SymKey (absK(pair(Agent (A),Agent (B)))),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(f(Nonce (NB)),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),pair(Agent (A),SymKey (absK(pair(Agent (A),Agent (B))))))))),(SID sid)]);
iknows(pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(f(Nonce (NB)),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),pair(Agent (A),SymKey (absK(pair(Agent (A),Agent (B))))))))))

step rule_10:
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NB),pair(Agent (B),Nonce (NB)),(SID sid)]);
iknows(Agent (A));
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K))))))

=>
request(Agent (B),Agent (A),Purpose (pBANA),Nonce (NA),(SID sid));
State (rB,[Agent (B),Step 2,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NB),pair(Agent (B),Nonce (NB)),SymKey (K),Nonce (NA),f(Nonce (NB)),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K))))),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K)))))),pair(Agent (B),scrypt(SymKey (K),f(Nonce (NA)))),(SID sid)]);
iknows(pair(Agent (B),scrypt(SymKey (K),f(Nonce (NA)))))

step rule_11:
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NB),pair(Agent (B),Nonce (NB)),(SID sid)]);
iknows(Agent (A));
iknows(SymKey (sk(pair(Agent (A),Agent (B)))));
iknows(f(Nonce (NB)));
iknows(Nonce (NA));
iknows(SymKey (K))

=>
request(Agent (B),Agent (A),Purpose (pBANA),Nonce (NA),(SID sid));
State (rB,[Agent (B),Step 2,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NB),pair(Agent (B),Nonce (NB)),SymKey (K),Nonce (NA),f(Nonce (NB)),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K))))),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K)))))),pair(Agent (B),scrypt(SymKey (K),f(Nonce (NA)))),(SID sid)]);
iknows(pair(Agent (B),scrypt(SymKey (K),f(Nonce (NA)))))

step rule_12:
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NB),pair(Agent (B),Nonce (NB)),(SID sid)]);
iknows(Agent (A));
iknows(SymKey (sk(pair(Agent (A),Agent (B)))));
iknows(Nonce (NB));
iknows(Nonce (NA));
iknows(SymKey (K))

=>
request(Agent (B),Agent (A),Purpose (pBANA),Nonce (NA),(SID sid));
State (rB,[Agent (B),Step 2,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NB),pair(Agent (B),Nonce (NB)),SymKey (K),Nonce (NA),f(Nonce (NB)),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K))))),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K)))))),pair(Agent (B),scrypt(SymKey (K),f(Nonce (NA)))),(SID sid)]);
iknows(pair(Agent (B),scrypt(SymKey (K),f(Nonce (NA)))))

step rule_13:
State (rA,[Agent (A),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (NB),pair(Agent (B),Nonce (NB)),Nonce (NA),SymKey (K),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K)))))),(SID sid)]);
iknows(Agent (B));
iknows(scrypt(SymKey (K),f(Nonce (NA))))

=>
request(Agent (A),Agent (B),Purpose (pABNB),Nonce (NB),(SID sid));
State (rA,[Agent (A),Step 2,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (NB),pair(Agent (B),Nonce (NB)),Nonce (NA),SymKey (K),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K)))))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K))))),scrypt(SymKey (K),f(Nonce (NA))),pair(Agent (B),scrypt(SymKey (K),f(Nonce (NA)))),(SID sid)])

step rule_14:
State (rA,[Agent (A),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (NB),pair(Agent (B),Nonce (NB)),Nonce (NA),SymKey (K),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K)))))),(SID sid)]);
iknows(Agent (B));
iknows(SymKey (K));
iknows(f(Nonce (NA)))

=>
request(Agent (A),Agent (B),Purpose (pABNB),Nonce (NB),(SID sid));
State (rA,[Agent (A),Step 2,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (NB),pair(Agent (B),Nonce (NB)),Nonce (NA),SymKey (K),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K)))))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K))))),scrypt(SymKey (K),f(Nonce (NA))),pair(Agent (B),scrypt(SymKey (K),f(Nonce (NA)))),(SID sid)])

step rule_15:
State (rA,[Agent (A),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (NB),pair(Agent (B),Nonce (NB)),Nonce (NA),SymKey (K),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K)))))),(SID sid)]);
iknows(Agent (B));
iknows(SymKey (K));
iknows(Nonce (NA))

=>
request(Agent (A),Agent (B),Purpose (pABNB),Nonce (NB),(SID sid));
State (rA,[Agent (A),Step 2,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (NB),pair(Agent (B),Nonce (NB)),Nonce (NA),SymKey (K),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K)))))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K))))),scrypt(SymKey (K),f(Nonce (NA))),pair(Agent (B),scrypt(SymKey (K),f(Nonce (NA)))),(SID sid)])


section initial state:
init_0: iknows(Nonce (ni));
init_1: iknows(Agent (dishonest i));
init_2: State (rA,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),(SID sid)]);
init_3: State (rA,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),(SID sid)]);
init_4: iknows(Step 0);
init_5: iknows(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))));
init_6: iknows((SID sid));
init_7: iknows(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))));
init_8: iknows(Agent (honest a));
init_9: State (rB,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),(SID sid)]);
init_10: State (rB,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),(SID sid)]);
init_11: iknows(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))));

section fixedpoint:
fp_0: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))));
fp_1: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_2: iknows(pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_3: iknows(pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))));
fp_4: witness(Agent (honest a),Agent (honest a),Purpose (pABNB),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))));
fp_5: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),(SID sid)]);
fp_6: witness(Agent (honest a),Agent (dishonest i),Purpose (pABNB),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))));
fp_7: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_8: secret(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i));
fp_9: witness(Agent (honest a),Agent (dishonest i),Purpose (pBANA),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))));
fp_10: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (ni),pair(Agent (dishonest i),Nonce (ni)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))),(SID sid)]);
fp_11: secret(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a));
fp_12: witness(Agent (honest a),Agent (honest a),Purpose (pBANA),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))));
fp_13: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (ni),pair(Agent (honest a),Nonce (ni)),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),SymKey (absK(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))),(SID sid)]);
fp_14: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))));
fp_15: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_16: iknows(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))));
fp_17: iknows(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))));
fp_18: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (ni)))));
fp_19: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (ni)))));
fp_20: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (ni)))));
fp_21: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))));
fp_22: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))));
fp_23: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))));
fp_24: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_25: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_26: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_27: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))));
fp_28: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))));
fp_29: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))));
fp_30: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_31: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_32: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_33: iknows(pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_34: iknows(pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))));
fp_35: iknows(pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))));
fp_36: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))));
fp_37: iknows(pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));
fp_38: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))),(SID sid)]);
fp_39: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))),(SID sid)]);
fp_40: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),SymKey (absK(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))),(SID sid)]);
fp_41: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),SymKey (absK(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))),(SID sid)]);
fp_42: request(Agent (honest a),Agent (dishonest i),Purpose (pBANA),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_43: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i))))))))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_44: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),SymKey (sk(pair(Agent (dishonest i),Agent (honest a))))))))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_45: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),SymKey (sk(pair(Agent (honest a),Agent (dishonest i))))))))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_46: request(Agent (honest a),Agent (dishonest i),Purpose (pBANA),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),(SID sid));
fp_47: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i))))))))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_48: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),SymKey (sk(pair(Agent (dishonest i),Agent (honest a))))))))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_49: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),SymKey (sk(pair(Agent (honest a),Agent (dishonest i))))))))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_50: request(Agent (honest a),Agent (dishonest i),Purpose (pBANA),Nonce (ni),(SID sid));
fp_51: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (ni),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (ni),pair(Agent (dishonest i),SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (ni),pair(Agent (dishonest i),SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i))))))))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (ni)))),(SID sid)]);
fp_52: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (ni),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (ni),pair(Agent (dishonest i),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (ni),pair(Agent (dishonest i),SymKey (sk(pair(Agent (dishonest i),Agent (honest a))))))))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (ni)))),(SID sid)]);
fp_53: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (ni),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (ni),pair(Agent (dishonest i),SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (ni),pair(Agent (dishonest i),SymKey (sk(pair(Agent (honest a),Agent (dishonest i))))))))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (ni)))),(SID sid)]);
fp_54: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (ni))));
fp_55: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (ni))));
fp_56: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (ni))));
fp_57: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))));
fp_58: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))));
fp_59: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))));
fp_60: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_61: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_62: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_63: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))));
fp_64: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))));
fp_65: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_66: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_67: iknows(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))));
fp_68: iknows(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))));
fp_69: iknows(f(Nonce (ni)));
fp_70: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (ni)))));
fp_71: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (ni)))));
fp_72: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (ni)))));
fp_73: iknows(pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (ni)))));
fp_74: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))));
fp_75: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))));
fp_76: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))));
fp_77: iknows(pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))));
fp_78: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_79: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_80: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_81: iknows(pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_82: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_83: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_84: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_85: iknows(pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_86: iknows(pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))));
fp_87: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))));
fp_88: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))));
fp_89: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))));
fp_90: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))));
fp_91: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_92: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_93: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_94: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_95: iknows(pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_96: iknows(pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))));
fp_97: iknows(pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))));
fp_98: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))));
fp_99: iknows(pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));
fp_100: iknows(pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));
fp_101: iknows(pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));
fp_102: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))),(SID sid)]);
fp_103: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),SymKey (absK(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))),(SID sid)]);
fp_104: request(Agent (honest a),Agent (honest a),Purpose (pBANA),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),(SID sid));
fp_105: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),SymKey (absK(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))),pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_106: request(Agent (honest a),Agent (dishonest i),Purpose (pBANA),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_107: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))),pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_108: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i))))))))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_109: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),SymKey (sk(pair(Agent (dishonest i),Agent (honest a))))))))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_110: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),SymKey (sk(pair(Agent (honest a),Agent (dishonest i))))))))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_111: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))),pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_112: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))),pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_113: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),Nonce (ni),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (ni),pair(Agent (dishonest i),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (ni),pair(Agent (dishonest i),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))),pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (ni)))),(SID sid)]);
fp_114: request(Agent (honest a),Agent (dishonest i),Purpose (pABNB),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_115: State (rA,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),pair(Agent (dishonest i),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_116: request(Agent (honest a),Agent (dishonest i),Purpose (pABNB),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),(SID sid));
fp_117: State (rA,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),pair(Agent (dishonest i),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_118: request(Agent (honest a),Agent (dishonest i),Purpose (pABNB),Nonce (ni),(SID sid));
fp_119: State (rA,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (ni),pair(Agent (dishonest i),Nonce (ni)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),pair(Agent (dishonest i),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_120: iknows(scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (ni))));
fp_121: iknows(scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))));
fp_122: iknows(scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_123: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_124: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_125: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_126: iknows(scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_127: iknows(scrypt(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_128: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))));
fp_129: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_130: iknows(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_131: iknows(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))));
fp_132: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (ni)))));
fp_133: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (ni)))));
fp_134: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (ni)))));
fp_135: iknows(pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (ni)))));
fp_136: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))));
fp_137: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))));
fp_138: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))));
fp_139: iknows(pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))));
fp_140: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_141: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_142: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_143: iknows(pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_144: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_145: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_146: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_147: iknows(pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_148: iknows(pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))));
fp_149: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))));
fp_150: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))));
fp_151: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))));
fp_152: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))));
fp_153: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_154: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_155: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_156: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_157: iknows(pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_158: iknows(pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))));
fp_159: iknows(pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))));
fp_160: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))));
fp_161: iknows(pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));
fp_162: iknows(pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));
fp_163: iknows(pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));
fp_164: iknows(pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));
fp_165: request(Agent (honest a),Agent (dishonest i),Purpose (pABNB),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_166: State (rA,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),pair(Agent (dishonest i),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_167: request(Agent (honest a),Agent (honest a),Purpose (pABNB),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_168: State (rA,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),SymKey (absK(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))),scrypt(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_169: request(Agent (honest a),Agent (honest a),Purpose (pABNB),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_170: State (rA,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),SymKey (absK(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))),scrypt(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_171: request(Agent (honest a),Agent (honest a),Purpose (pABNB),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),(SID sid));
fp_172: State (rA,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),SymKey (absK(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))),scrypt(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_173: request(Agent (honest a),Agent (honest a),Purpose (pABNB),Nonce (ni),(SID sid));
fp_174: State (rA,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (ni),pair(Agent (honest a),Nonce (ni)),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),SymKey (absK(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))),scrypt(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_175: iknows(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))));
fp_176: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (ni)))));
fp_177: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (ni)))));
fp_178: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (ni)))));
fp_179: iknows(pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (ni)))));
fp_180: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))));
fp_181: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))));
fp_182: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))));
fp_183: iknows(pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))));
fp_184: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_185: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_186: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_187: iknows(pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_188: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_189: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_190: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_191: iknows(pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))));
fp_192: iknows(pair(Agent (honest a),scrypt(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))));
fp_193: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))));
fp_194: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))));
fp_195: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))));
fp_196: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a))))))))));
fp_197: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_198: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_199: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_200: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_201: iknows(pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_202: iknows(pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))));
fp_203: iknows(pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))));
fp_204: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))));
fp_205: iknows(pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));
fp_206: iknows(pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));
fp_207: iknows(pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));
fp_208: iknows(pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));

section abstraction:
NB->Nonce (absNB(pair(B,A)));
NA->Nonce (absNA(pair(A,B)));
K->SymKey (absK(pair(A,B)))

