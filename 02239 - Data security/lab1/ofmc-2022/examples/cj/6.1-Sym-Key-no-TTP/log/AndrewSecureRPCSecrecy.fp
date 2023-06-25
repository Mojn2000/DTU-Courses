Backend: Open-Source Fixedpoint Model-Checker version 2020 
Protocol: Andrew_Secure_RPC_Secrecy
Types:
[(Purpose,[]),(Agent False False,["A","B"]),(Number,["NA","NB","NB2"]),(Function,["sk","succ"])]
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
request(A,B,Purpose (purposeNB),M,(SID sid))
 | B/=Agent (dishonest i);
M/=Nonce (absNB(pair(B,A)))
=>
attack(pair(authentication,pair(A,pair(B,M))))

step rule_7:
request(A,B,Purpose (purposeNB2),M,(SID sid))
 | B/=Agent (dishonest i);
M/=Nonce (absNB2(pair(B,A)))
=>
attack(pair(authentication,pair(A,pair(B,M))))

step rule_8:
State (rA,[Agent (A),Step 0,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),(SID sid)])

=>
State (rA,[Agent (A),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (absNA(pair(Agent (A),Agent (B)))),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (absNA(pair(Agent (A),Agent (B)))))),(SID sid)]);
iknows(pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (absNA(pair(Agent (A),Agent (B)))))))

step rule_9:
State (rB,[Agent (B),Step 0,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),(SID sid)]);
iknows(Agent (A));
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA)))

=>
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NA),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA)),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA))),Nonce (absNB(pair(Agent (B),Agent (A)))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(succ(Nonce (NA)),Nonce (absNB(pair(Agent (B),Agent (A)))))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(succ(Nonce (NA)),Nonce (absNB(pair(Agent (B),Agent (A)))))))

step rule_10:
State (rB,[Agent (B),Step 0,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),(SID sid)]);
iknows(Agent (A));
iknows(SymKey (sk(pair(Agent (A),Agent (B)))));
iknows(Nonce (NA))

=>
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NA),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA)),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA))),Nonce (absNB(pair(Agent (B),Agent (A)))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(succ(Nonce (NA)),Nonce (absNB(pair(Agent (B),Agent (A)))))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(succ(Nonce (NA)),Nonce (absNB(pair(Agent (B),Agent (A)))))))

step rule_11:
State (rA,[Agent (A),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (NA),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(succ(Nonce (NA)),Nonce (NB))))

=>
State (rA,[Agent (A),Step 2,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (NA),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA)),Nonce (NB),succ(Nonce (NA)),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(succ(Nonce (NA)),Nonce (NB))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),succ(Nonce (NB))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),succ(Nonce (NB))))

step rule_12:
State (rA,[Agent (A),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (NA),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA))),(SID sid)]);
iknows(SymKey (sk(pair(Agent (A),Agent (B)))));
iknows(succ(Nonce (NA)));
iknows(Nonce (NB))

=>
State (rA,[Agent (A),Step 2,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (NA),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA)),Nonce (NB),succ(Nonce (NA)),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(succ(Nonce (NA)),Nonce (NB))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),succ(Nonce (NB))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),succ(Nonce (NB))))

step rule_13:
State (rA,[Agent (A),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (NA),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA))),(SID sid)]);
iknows(SymKey (sk(pair(Agent (A),Agent (B)))));
iknows(Nonce (NA));
iknows(Nonce (NB))

=>
State (rA,[Agent (A),Step 2,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (NA),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA)),Nonce (NB),succ(Nonce (NA)),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(succ(Nonce (NA)),Nonce (NB))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),succ(Nonce (NB))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),succ(Nonce (NB))))

step rule_14:
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NA),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA)),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA))),Nonce (NB),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(succ(Nonce (NA)),Nonce (NB))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),succ(Nonce (NB))))

=>
secret(Nonce (absNB2(pair(Agent (B),Agent (A)))),Agent (A));
State (rB,[Agent (B),Step 2,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NA),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA)),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA))),Nonce (NB),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(succ(Nonce (NA)),Nonce (NB))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),succ(Nonce (NB))),Nonce (absNB2(pair(Agent (B),Agent (A)))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (absNB2(pair(Agent (B),Agent (A))))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (absNB2(pair(Agent (B),Agent (A))))))

step rule_15:
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NA),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA)),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA))),Nonce (NB),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(succ(Nonce (NA)),Nonce (NB))),(SID sid)]);
iknows(SymKey (sk(pair(Agent (A),Agent (B)))));
iknows(succ(Nonce (NB)))

=>
secret(Nonce (absNB2(pair(Agent (B),Agent (A)))),Agent (A));
State (rB,[Agent (B),Step 2,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NA),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA)),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA))),Nonce (NB),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(succ(Nonce (NA)),Nonce (NB))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),succ(Nonce (NB))),Nonce (absNB2(pair(Agent (B),Agent (A)))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (absNB2(pair(Agent (B),Agent (A))))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (absNB2(pair(Agent (B),Agent (A))))))

step rule_16:
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NA),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA)),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA))),Nonce (NB),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(succ(Nonce (NA)),Nonce (NB))),(SID sid)]);
iknows(SymKey (sk(pair(Agent (A),Agent (B)))));
iknows(Nonce (NB))

=>
secret(Nonce (absNB2(pair(Agent (B),Agent (A)))),Agent (A));
State (rB,[Agent (B),Step 2,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NA),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA)),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA))),Nonce (NB),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(succ(Nonce (NA)),Nonce (NB))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),succ(Nonce (NB))),Nonce (absNB2(pair(Agent (B),Agent (A)))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (absNB2(pair(Agent (B),Agent (A))))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (absNB2(pair(Agent (B),Agent (A))))))

step rule_17:
State (rA,[Agent (A),Step 2,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (NA),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA)),Nonce (NB),succ(Nonce (NA)),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(succ(Nonce (NA)),Nonce (NB))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),succ(Nonce (NB))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NB2)))

=>
State (rA,[Agent (A),Step 3,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (NA),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA)),Nonce (NB),succ(Nonce (NA)),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(succ(Nonce (NA)),Nonce (NB))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),succ(Nonce (NB))),Nonce (NB2),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NB2)),(SID sid)])

step rule_18:
State (rA,[Agent (A),Step 2,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (NA),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA)),Nonce (NB),succ(Nonce (NA)),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(succ(Nonce (NA)),Nonce (NB))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),succ(Nonce (NB))),(SID sid)]);
iknows(SymKey (sk(pair(Agent (A),Agent (B)))));
iknows(Nonce (NB2))

=>
State (rA,[Agent (A),Step 3,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (NA),pair(Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NA)),Nonce (NB),succ(Nonce (NA)),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(succ(Nonce (NA)),Nonce (NB))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),succ(Nonce (NB))),Nonce (NB2),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),Nonce (NB2)),(SID sid)])


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
fp_0: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_1: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_2: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),(SID sid)]);
fp_3: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),(SID sid)]);
fp_4: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (ni),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (ni)),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (ni))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(succ(Nonce (ni)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),(SID sid)]);
fp_5: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(succ(Nonce (ni)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_6: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))));
fp_7: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))));
fp_8: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_9: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_10: iknows(pair(succ(Nonce (ni)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_11: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),(SID sid)]);
fp_12: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))));
fp_13: iknows(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))));
fp_14: iknows(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))));
fp_15: iknows(succ(Nonce (ni)));
fp_16: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_17: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_18: iknows(pair(succ(Nonce (ni)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_19: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),(SID sid)]);
fp_20: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(succ(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),(SID sid)]);
fp_21: State (rA,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),succ(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),(SID sid)]);
fp_22: State (rA,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),(SID sid)]);
fp_23: State (rA,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),(SID sid)]);
fp_24: State (rA,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (ni),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (ni))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (ni))),(SID sid)]);
fp_25: secret(Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i));
fp_26: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (ni),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (ni)),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (ni))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(succ(Nonce (ni)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),succ(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_27: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i))))));
fp_28: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (ni))));
fp_29: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_30: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_31: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),succ(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))));
fp_32: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(succ(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_33: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_34: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_35: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_36: iknows(pair(succ(Nonce (ni)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_37: iknows(pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_38: iknows(pair(succ(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_39: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(succ(Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),(SID sid)]);
fp_40: secret(Nonce (absNB2(pair(Agent (honest a),Agent (honest a)))),Agent (honest a));
fp_41: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),succ(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),Nonce (absNB2(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNB2(pair(Agent (honest a),Agent (honest a))))),(SID sid)]);
fp_42: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),succ(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_43: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(succ(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),succ(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_44: State (rA,[Agent (honest a),Step 3,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),succ(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),(SID sid)]);
fp_45: State (rA,[Agent (honest a),Step 3,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_46: State (rA,[Agent (honest a),Step 3,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_47: State (rA,[Agent (honest a),Step 3,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (ni),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (ni))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (ni))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_48: State (rA,[Agent (honest a),Step 3,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_49: State (rA,[Agent (honest a),Step 3,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (ni),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (ni)),(SID sid)]);
fp_50: State (rA,[Agent (honest a),Step 3,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_51: State (rA,[Agent (honest a),Step 3,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (ni),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (ni)),(SID sid)]);
fp_52: State (rA,[Agent (honest a),Step 3,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (ni),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (ni))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (ni))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_53: State (rA,[Agent (honest a),Step 3,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (ni),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (ni))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (ni))),Nonce (ni),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (ni)),(SID sid)]);
fp_54: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNB2(pair(Agent (honest a),Agent (honest a))))));
fp_55: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(succ(Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_56: iknows(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))));
fp_57: iknows(succ(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_58: iknows(Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))));
fp_59: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_60: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_61: iknows(pair(succ(Nonce (ni)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_62: iknows(pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_63: iknows(pair(succ(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_64: iknows(pair(succ(Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_65: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNB2(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNB2(pair(Agent (honest a),Agent (honest a))))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNB2(pair(Agent (honest a),Agent (honest a)))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(succ(Nonce (absNB2(pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),(SID sid)]);
fp_66: State (rA,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))))),(SID sid)]);
fp_67: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i))))),pair(Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(succ(Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),succ(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_68: State (rA,[Agent (honest a),Step 3,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),succ(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),Nonce (absNB2(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNB2(pair(Agent (honest a),Agent (honest a))))),(SID sid)]);
fp_69: State (rA,[Agent (honest a),Step 3,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_70: State (rA,[Agent (honest a),Step 3,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_71: State (rA,[Agent (honest a),Step 3,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (ni),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (ni))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (ni))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_72: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_73: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(succ(Nonce (absNB2(pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))));
fp_74: iknows(succ(Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i))))));
fp_75: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_76: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_77: iknows(pair(succ(Nonce (ni)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_78: iknows(pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_79: iknows(pair(succ(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_80: iknows(pair(succ(Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_81: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNB2(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNB2(pair(Agent (honest a),Agent (honest a))))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNB2(pair(Agent (honest a),Agent (honest a)))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(succ(Nonce (absNB2(pair(Agent (honest a),Agent (honest a))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),succ(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))),Nonce (absNB2(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNB2(pair(Agent (honest a),Agent (honest a))))),(SID sid)]);
fp_82: State (rA,[Agent (honest a),Step 3,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_83: State (rA,[Agent (honest a),Step 3,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_84: State (rA,[Agent (honest a),Step 3,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_85: State (rA,[Agent (honest a),Step 3,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),succ(Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i)))))),Nonce (ni),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (ni)),(SID sid)]);
fp_86: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_87: iknows(pair(Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_88: iknows(pair(succ(Nonce (ni)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_89: iknows(pair(succ(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_90: iknows(pair(succ(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_91: iknows(pair(succ(Nonce (absNB2(pair(Agent (honest a),Agent (dishonest i))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));

section abstraction:
NA->Nonce (absNA(pair(A,B)));
NB->Nonce (absNB(pair(B,A)));
NB2->Nonce (absNB2(pair(B,A)))

