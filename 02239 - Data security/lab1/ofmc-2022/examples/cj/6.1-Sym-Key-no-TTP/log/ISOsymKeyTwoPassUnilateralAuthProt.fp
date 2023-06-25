Backend: Open-Source Fixedpoint Model-Checker version 2020 
Protocol: ISO_twopass_symm
Types:
[(Purpose,["purposeText2"]),(Agent False False,["A","B"]),(Number,["NB","Text1","Text2","Text3"]),(Function,["sk"])]
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
request(A,B,Purpose (purposeText2),M,(SID sid))
 | B/=Agent (dishonest i);
M/=Nonce (absText2(pair(B,A)))
=>
attack(pair(authentication,pair(A,pair(B,M))))

step rule_7:
State (rB,[Agent (B),Step 0,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),(SID sid)])

=>
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (absNB(pair(Agent (B),Agent (A)))),(SID sid)]);
iknows(Nonce (absNB(pair(Agent (B),Agent (A)))))

step rule_8:
State (rA,[Agent (A),Step 0,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),(SID sid)]);
iknows(Nonce (NB))

=>
witness(Agent (A),Agent (B),Purpose (pBAText2),Nonce (absText2(pair(Agent (A),Agent (B)))));
State (rA,[Agent (A),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (NB),Nonce (absText2(pair(Agent (A),Agent (B)))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(Nonce (NB),pair(Agent (B),Nonce (absText2(pair(Agent (A),Agent (B))))))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(Nonce (NB),pair(Agent (B),Nonce (absText2(pair(Agent (A),Agent (B))))))))

step rule_9:
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NB),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(Nonce (NB),pair(Agent (B),Nonce (Text2)))))

=>
request(Agent (B),Agent (A),Purpose (pBAText2),Nonce (Text2),(SID sid));
State (rB,[Agent (B),Step 2,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NB),Nonce (Text2),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(Nonce (NB),pair(Agent (B),Nonce (Text2)))),(SID sid)])

step rule_10:
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NB),(SID sid)]);
iknows(SymKey (sk(pair(Agent (A),Agent (B)))));
iknows(Nonce (NB));
iknows(Agent (B));
iknows(Nonce (Text2))

=>
request(Agent (B),Agent (A),Purpose (pBAText2),Nonce (Text2),(SID sid));
State (rB,[Agent (B),Step 2,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NB),Nonce (Text2),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(Nonce (NB),pair(Agent (B),Nonce (Text2)))),(SID sid)])


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
fp_0: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),(SID sid)]);
fp_1: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),(SID sid)]);
fp_2: witness(Agent (honest a),Agent (dishonest i),Purpose (pBAText2),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))));
fp_3: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (ni),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_4: witness(Agent (honest a),Agent (honest a),Purpose (pBAText2),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))));
fp_5: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (ni),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_6: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_7: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));
fp_8: iknows(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))));
fp_9: iknows(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))));
fp_10: iknows(pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))));
fp_11: iknows(pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_12: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_13: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_14: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_15: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_16: request(Agent (honest a),Agent (dishonest i),Purpose (pBAText2),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_17: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_18: request(Agent (honest a),Agent (dishonest i),Purpose (pBAText2),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),(SID sid));
fp_19: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_20: request(Agent (honest a),Agent (dishonest i),Purpose (pBAText2),Nonce (ni),(SID sid));
fp_21: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (ni),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (ni)))),(SID sid)]);
fp_22: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_23: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_24: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));
fp_25: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));
fp_26: iknows(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))));
fp_27: iknows(pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))));
fp_28: iknows(pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_29: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_30: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_31: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_32: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_33: request(Agent (honest a),Agent (honest a),Purpose (pBAText2),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),(SID sid));
fp_34: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_35: request(Agent (honest a),Agent (dishonest i),Purpose (pBAText2),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_36: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_37: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_38: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));
fp_39: iknows(pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))));
fp_40: iknows(pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_41: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_42: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_43: iknows(pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));

section abstraction:
NB->Nonce (absNB(pair(B,A)));
Text2->Nonce (absText2(pair(A,B)))

