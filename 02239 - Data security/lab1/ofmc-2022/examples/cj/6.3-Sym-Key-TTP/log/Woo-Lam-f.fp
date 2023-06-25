Backend: Open-Source Fixedpoint Model-Checker version 2020 
Protocol: WooLamF
Types:
[(Purpose,["purposeNB"]),(Agent False False,["A","B","s"]),(Number,["NA","NB"]),(SymmetricKey,["KAB"]),(Function,["sk"])]
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
State (rA,[Agent (A),Step 0,SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (honest a),Agent (B),(SID sid)])

=>
State (rA,[Agent (A),Step 1,SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (honest a),Agent (B),(SID sid)]);
iknows(Agent (A))

step rule_7:
State (rB,[Agent (B),Step 0,SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (honest a),Agent (A),(SID sid)]);
iknows(Agent (A))

=>
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (honest a),Agent (A),Nonce (absNB(pair(Agent (B),Agent (A)))),(SID sid)]);
iknows(Nonce (absNB(pair(Agent (B),Agent (A)))))

step rule_8:
State (rA,[Agent (A),Step 1,SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (honest a),Agent (B),(SID sid)]);
iknows(Nonce (NB))

=>
witness(Agent (A),Agent (B),Purpose (pBANB),Nonce (NB));
State (rA,[Agent (A),Step 2,SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (honest a),Agent (B),Nonce (NB),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Agent (A),pair(Agent (B),Nonce (NB)))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Agent (A),pair(Agent (B),Nonce (NB)))))

step rule_9:
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (honest a),Agent (A),Nonce (NB),(SID sid)]);
iknows(Agent (dishonest i))

=>
State (rB,[Agent (B),Step 2,SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (honest a),Agent (A),Nonce (NB),Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(Agent (B),pair(Nonce (NB),Agent (dishonest i))))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(Agent (B),pair(Nonce (NB),Agent (dishonest i))))))

step rule_10:
State (rs,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (B),Agent (honest a)))),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),Agent (A),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(Agent (B),pair(Nonce (NB),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Agent (A),pair(Agent (B),Nonce (NB)))))))))

=>
State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (B),Agent (honest a)))),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Agent (A),pair(Agent (B),Nonce (NB)))),Nonce (NB),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(Agent (B),pair(Nonce (NB),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Agent (A),pair(Agent (B),Nonce (NB)))))))),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(Agent (B),Nonce (NB)))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(Agent (B),Nonce (NB)))))

step rule_11:
State (rs,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (B),Agent (honest a)))),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),Agent (A),(SID sid)]);
iknows(SymKey (sk(pair(Agent (B),Agent (honest a)))));
iknows(Agent (A));
iknows(Agent (B));
iknows(Nonce (NB));
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Agent (A),pair(Agent (B),Nonce (NB)))))

=>
State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (B),Agent (honest a)))),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Agent (A),pair(Agent (B),Nonce (NB)))),Nonce (NB),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(Agent (B),pair(Nonce (NB),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Agent (A),pair(Agent (B),Nonce (NB)))))))),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(Agent (B),Nonce (NB)))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(Agent (B),Nonce (NB)))))

step rule_12:
State (rs,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (B),Agent (honest a)))),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),Agent (A),(SID sid)]);
iknows(SymKey (sk(pair(Agent (B),Agent (honest a)))));
iknows(Agent (A));
iknows(Agent (B));
iknows(Nonce (NB));
iknows(SymKey (sk(pair(Agent (A),Agent (honest a)))))

=>
State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (B),Agent (honest a)))),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),Agent (A),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Agent (A),pair(Agent (B),Nonce (NB)))),Nonce (NB),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(Agent (B),pair(Nonce (NB),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Agent (A),pair(Agent (B),Nonce (NB)))))))),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(Agent (B),Nonce (NB)))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(Agent (B),Nonce (NB)))))

step rule_13:
State (rB,[Agent (B),Step 2,SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (honest a),Agent (A),Nonce (NB),Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(Agent (B),pair(Nonce (NB),Agent (dishonest i))))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(Agent (B),Nonce (NB)))))

=>
request(Agent (B),Agent (A),Purpose (pBANB),Nonce (NB),(SID sid));
State (rB,[Agent (B),Step 3,SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (honest a),Agent (A),Nonce (NB),Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(Agent (B),pair(Nonce (NB),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(Agent (B),Nonce (NB)))),(SID sid)])

step rule_14:
State (rB,[Agent (B),Step 2,SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (honest a),Agent (A),Nonce (NB),Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(Agent (B),pair(Nonce (NB),Agent (dishonest i))))),(SID sid)]);
iknows(SymKey (sk(pair(Agent (B),Agent (honest a)))));
iknows(Agent (A));
iknows(Agent (B));
iknows(Nonce (NB))

=>
request(Agent (B),Agent (A),Purpose (pBANB),Nonce (NB),(SID sid));
State (rB,[Agent (B),Step 3,SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (honest a),Agent (A),Nonce (NB),Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(Agent (B),pair(Nonce (NB),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(Agent (B),Nonce (NB)))),(SID sid)])


section initial state:
init_0: iknows(Nonce (ni));
init_1: iknows(Agent (dishonest i));
init_2: State (rA,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (dishonest i),(SID sid)]);
init_3: State (rA,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (honest a),(SID sid)]);
init_4: iknows(Step 0);
init_5: iknows(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))));
init_6: iknows(Agent (honest a));
init_7: iknows((SID sid));
init_8: iknows(Agent (honest a));
init_9: State (rB,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (dishonest i),(SID sid)]);
init_10: State (rB,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (honest a),(SID sid)]);
init_11: State (rs,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Agent (dishonest i),(SID sid)]);
init_12: State (rs,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),Agent (honest a),(SID sid)]);
init_13: State (rs,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (honest a),Agent (dishonest i),(SID sid)]);
init_14: State (rs,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (honest a),(SID sid)]);

section fixedpoint:
fp_0: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (dishonest i),(SID sid)]);
fp_1: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (honest a),(SID sid)]);
fp_2: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),(SID sid)]);
fp_3: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),(SID sid)]);
fp_4: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (ni)))),Nonce (ni),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(Agent (dishonest i),pair(Nonce (ni),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (ni)))))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (ni)))),(SID sid)]);
fp_5: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (ni)))));
fp_6: iknows(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))));
fp_7: iknows(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))));
fp_8: iknows(pair(Agent (dishonest i),Nonce (ni)));
fp_9: iknows(pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (ni))));
fp_10: witness(Agent (honest a),Agent (dishonest i),Purpose (pBANB),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))));
fp_11: State (rA,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_12: witness(Agent (honest a),Agent (dishonest i),Purpose (pBANB),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))));
fp_13: State (rA,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_14: witness(Agent (honest a),Agent (dishonest i),Purpose (pBANB),Nonce (ni));
fp_15: State (rA,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (dishonest i),Nonce (ni),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (ni)))),(SID sid)]);
fp_16: witness(Agent (honest a),Agent (honest a),Purpose (pBANB),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))));
fp_17: State (rA,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_18: witness(Agent (honest a),Agent (honest a),Purpose (pBANB),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))));
fp_19: State (rA,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_20: witness(Agent (honest a),Agent (honest a),Purpose (pBANB),Nonce (ni));
fp_21: State (rA,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (honest a),Nonce (ni),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (honest a),Nonce (ni)))),(SID sid)]);
fp_22: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(Agent (honest a),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))))),(SID sid)]);
fp_23: State (rB,[Agent (honest a),Step 2,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (honest a),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i))))),(SID sid)]);
fp_24: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(Agent (dishonest i),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_25: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(Agent (dishonest i),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_26: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_27: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))));
fp_28: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (honest a),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i))))));
fp_29: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(Agent (honest a),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))))));
fp_30: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (honest a),Nonce (ni)))));
fp_31: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_32: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))));
fp_33: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (ni)))));
fp_34: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_35: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))));
fp_36: iknows(pair(Agent (dishonest i),Nonce (ni)));
fp_37: iknows(pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (ni))));
fp_38: iknows(pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))));
fp_39: iknows(pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))));
fp_40: iknows(pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_41: iknows(pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_42: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_43: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_44: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),Agent (honest a),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (ni)))),Nonce (ni),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),pair(Nonce (ni),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (ni)))))))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (ni)))),(SID sid)]);
fp_45: request(Agent (honest a),Agent (honest a),Purpose (pBANB),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),(SID sid));
fp_46: State (rB,[Agent (honest a),Step 3,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (honest a),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i))))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_47: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (ni)))));
fp_48: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))))));
fp_49: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))))));
fp_50: iknows(pair(Agent (dishonest i),Nonce (ni)));
fp_51: iknows(pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (ni))));
fp_52: iknows(pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))));
fp_53: iknows(pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))));
fp_54: iknows(pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_55: iknows(pair(Agent (dishonest i),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_56: iknows(pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))))));
fp_57: iknows(pair(Agent (honest a),pair(Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_58: iknows(pair(Agent (honest a),pair(Agent (dishonest i),Nonce (ni))));

section abstraction:
NB->Nonce (absNB(pair(B,A)))

