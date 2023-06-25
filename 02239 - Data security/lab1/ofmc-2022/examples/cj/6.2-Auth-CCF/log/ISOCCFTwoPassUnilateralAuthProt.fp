Backend: Open-Source Fixedpoint Model-Checker version 2020 
Protocol: ISO_twopass_CCF
Types:
[(Purpose,["purposeText2"]),(Agent False False,["A","B"]),(Number,["NB","Text1","Text2","Text3"]),(Function,["sk","f"])]
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
State (rA,[Agent (A),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (NB),Nonce (absText2(pair(Agent (A),Agent (B)))),pair(f(pair(SymKey (sk(pair(Agent (A),Agent (B)))),pair(Nonce (NB),pair(Agent (B),Nonce (absText2(pair(Agent (A),Agent (B)))))))),pair(Nonce (NB),pair(Agent (B),Nonce (absText2(pair(Agent (A),Agent (B))))))),(SID sid)]);
iknows(pair(f(pair(SymKey (sk(pair(Agent (A),Agent (B)))),pair(Nonce (NB),pair(Agent (B),Nonce (absText2(pair(Agent (A),Agent (B)))))))),pair(Nonce (NB),pair(Agent (B),Nonce (absText2(pair(Agent (A),Agent (B))))))))

step rule_9:
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NB),(SID sid)]);
iknows(f(pair(SymKey (sk(pair(Agent (A),Agent (B)))),pair(Nonce (NB),pair(Agent (B),Nonce (Text2))))));
iknows(Nonce (NB));
iknows(Agent (B));
iknows(Nonce (Text2))

=>
request(Agent (B),Agent (A),Purpose (pBAText2),Nonce (Text2),(SID sid));
State (rB,[Agent (B),Step 2,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NB),Nonce (Text2),f(pair(SymKey (sk(pair(Agent (A),Agent (B)))),pair(Nonce (NB),pair(Agent (B),Nonce (Text2))))),pair(f(pair(SymKey (sk(pair(Agent (A),Agent (B)))),pair(Nonce (NB),pair(Agent (B),Nonce (Text2))))),pair(Nonce (NB),pair(Agent (B),Nonce (Text2)))),(SID sid)])

step rule_10:
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NB),(SID sid)]);
iknows(SymKey (sk(pair(Agent (A),Agent (B)))));
iknows(Nonce (NB));
iknows(Agent (B));
iknows(Nonce (Text2))

=>
request(Agent (B),Agent (A),Purpose (pBAText2),Nonce (Text2),(SID sid));
State (rB,[Agent (B),Step 2,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (NB),Nonce (Text2),f(pair(SymKey (sk(pair(Agent (A),Agent (B)))),pair(Nonce (NB),pair(Agent (B),Nonce (Text2))))),pair(f(pair(SymKey (sk(pair(Agent (A),Agent (B)))),pair(Nonce (NB),pair(Agent (B),Nonce (Text2))))),pair(Nonce (NB),pair(Agent (B),Nonce (Text2)))),(SID sid)])


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
fp_0: iknows(pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))));
fp_1: iknows(pair(Nonce (ni),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))));
fp_2: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_3: iknows(pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))));
fp_4: iknows(pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_5: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));
fp_6: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),(SID sid)]);
fp_7: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),(SID sid)]);
fp_8: witness(Agent (honest a),Agent (dishonest i),Purpose (pBAText2),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))));
fp_9: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (ni),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_10: witness(Agent (honest a),Agent (honest a),Purpose (pBAText2),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))));
fp_11: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (ni),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_12: iknows(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))));
fp_13: iknows(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))));
fp_14: iknows(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))));
fp_15: iknows(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_16: iknows(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))));
fp_17: iknows(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))));
fp_18: iknows(pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))));
fp_19: iknows(pair(Nonce (ni),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))));
fp_20: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_21: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))));
fp_22: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_23: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))));
fp_24: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_25: iknows(pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))));
fp_26: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_27: iknows(pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))));
fp_28: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_29: iknows(pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))));
fp_30: iknows(pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_31: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));
fp_32: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_33: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));
fp_34: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_35: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));
fp_36: iknows(pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_37: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));
fp_38: iknows(pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_39: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));
fp_40: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_41: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_42: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_43: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_44: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_45: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_46: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_47: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_48: request(Agent (honest a),Agent (dishonest i),Purpose (pBAText2),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),(SID sid));
fp_49: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),f(pair(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(f(pair(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_50: request(Agent (honest a),Agent (dishonest i),Purpose (pBAText2),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_51: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),f(pair(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(f(pair(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_52: request(Agent (honest a),Agent (dishonest i),Purpose (pBAText2),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_53: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),f(pair(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))))),pair(f(pair(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_54: request(Agent (honest a),Agent (dishonest i),Purpose (pBAText2),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),(SID sid));
fp_55: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),f(pair(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))))),pair(f(pair(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_56: request(Agent (honest a),Agent (dishonest i),Purpose (pBAText2),Nonce (ni),(SID sid));
fp_57: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (ni),f(pair(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (ni))))),pair(f(pair(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (ni))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (ni)))),(SID sid)]);
fp_58: iknows(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))));
fp_59: iknows(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))));
fp_60: iknows(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))));
fp_61: iknows(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))));
fp_62: iknows(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_63: iknows(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_64: iknows(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_65: iknows(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_66: iknows(pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))));
fp_67: iknows(pair(Nonce (ni),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))));
fp_68: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_69: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))));
fp_70: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_71: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))));
fp_72: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_73: iknows(pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))));
fp_74: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_75: iknows(pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))));
fp_76: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_77: iknows(pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))));
fp_78: iknows(pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_79: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));
fp_80: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_81: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));
fp_82: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_83: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));
fp_84: iknows(pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_85: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));
fp_86: iknows(pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_87: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));
fp_88: request(Agent (honest a),Agent (honest a),Purpose (pBAText2),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),(SID sid));
fp_89: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_90: iknows(pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))));
fp_91: iknows(pair(Nonce (ni),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))));
fp_92: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_93: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))));
fp_94: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_95: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))));
fp_96: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_97: iknows(pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))));
fp_98: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_99: iknows(pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))));
fp_100: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a)))))))),pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText2(pair(Agent (honest a),Agent (honest a))))))));
fp_101: iknows(pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))));
fp_102: iknows(pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_103: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (ni),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));
fp_104: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_105: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));
fp_106: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_107: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));
fp_108: iknows(pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_109: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));
fp_110: iknows(pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))));
fp_111: iknows(pair(f(pair(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i)))))))),pair(Nonce (absText2(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),Nonce (absText2(pair(Agent (honest a),Agent (dishonest i))))))));

section abstraction:
NB->Nonce (absNB(pair(B,A)));
Text2->Nonce (absText2(pair(A,B)))

