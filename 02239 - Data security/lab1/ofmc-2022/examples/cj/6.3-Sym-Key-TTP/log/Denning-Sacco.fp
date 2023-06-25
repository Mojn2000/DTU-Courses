Backend: Open-Source Fixedpoint Model-Checker version 2020 
Protocol: DenningSacco
Types:
[(Purpose,["purposePayload"]),(Agent False False,["A","B","s"]),(Number,["T","timestamp","Payload"]),(SymmetricKey,["KAB"]),(Function,["sk"])]
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
request(A,B,Purpose (purposeKAB),M,(SID sid))
 | B/=Agent (dishonest i);
M/=SymKey (absKAB(pair(B,A)))
=>
attack(pair(authentication,pair(A,pair(B,M))))

step rule_6:
request(A,B,Purpose (purposeT),M,(SID sid))
 | B/=Agent (dishonest i);
M/=Nonce (absT(pair(B,A)))
=>
attack(pair(authentication,pair(A,pair(B,M))))

step rule_7:
request(A,B,Purpose (purposePayload),M,(SID sid))
 | B/=Agent (dishonest i);
M/=Nonce (absPayload(pair(B,A)))
=>
attack(pair(authentication,pair(A,pair(B,M))))

step rule_8:
State (rA,[Agent (A),Step 0,Nonce (timestamp),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),(SID sid)])

=>
State (rA,[Agent (A),Step 1,Nonce (timestamp),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),pair(Agent (A),Agent (B)),(SID sid)]);
iknows(pair(Agent (A),Agent (B)))

step rule_9:
State (rs,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (B),Agent (honest a)))),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),Agent (A),(SID sid)]);
iknows(Agent (A));
iknows(Agent (B))

=>
State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (B),Agent (honest a)))),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),Agent (A),pair(Agent (A),Agent (B)),SymKey (absKAB(pair(Agent (B),Agent (A)))),Nonce (absT(pair(Agent (B),Agent (A)))),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Agent (B),pair(SymKey (absKAB(pair(Agent (B),Agent (A)))),pair(Nonce (absT(pair(Agent (B),Agent (A)))),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(SymKey (absKAB(pair(Agent (B),Agent (A)))),Nonce (absT(pair(Agent (B),Agent (A))))))))))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Agent (B),pair(SymKey (absKAB(pair(Agent (B),Agent (A)))),pair(Nonce (absT(pair(Agent (B),Agent (A)))),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(SymKey (absKAB(pair(Agent (B),Agent (A)))),Nonce (absT(pair(Agent (B),Agent (A))))))))))))

step rule_10:
State (rA,[Agent (A),Step 1,Nonce (timestamp),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),pair(Agent (A),Agent (B)),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Agent (B),pair(SymKey (KAB),pair(Nonce (T),Agent (dishonest i))))))

=>
State (rA,[Agent (A),Step 2,Nonce (timestamp),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),pair(Agent (A),Agent (B)),Agent (dishonest i),Nonce (T),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Agent (B),pair(SymKey (KAB),pair(Nonce (T),Agent (dishonest i))))),(SID sid)]);
iknows(Agent (dishonest i))

step rule_11:
State (rA,[Agent (A),Step 1,Nonce (timestamp),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),pair(Agent (A),Agent (B)),(SID sid)]);
iknows(SymKey (sk(pair(Agent (A),Agent (honest a)))));
iknows(Agent (B));
iknows(SymKey (KAB));
iknows(Nonce (T));
iknows(Agent (dishonest i))

=>
State (rA,[Agent (A),Step 2,Nonce (timestamp),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),pair(Agent (A),Agent (B)),Agent (dishonest i),Nonce (T),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Agent (B),pair(SymKey (KAB),pair(Nonce (T),Agent (dishonest i))))),(SID sid)]);
iknows(Agent (dishonest i))

step rule_12:
State (rB,[Agent (B),Step 0,Nonce (timestamp),SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (A),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(SymKey (KAB),Nonce (T)))))

=>
secret(Nonce (absPayload(pair(Agent (B),Agent (A)))),Agent (A));
witness(Agent (B),Agent (A),Purpose (pABPayload),Nonce (absPayload(pair(Agent (B),Agent (A)))));
State (rB,[Agent (B),Step 1,Nonce (timestamp),SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (A),Nonce (T),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(SymKey (KAB),Nonce (T)))),Nonce (absPayload(pair(Agent (B),Agent (A)))),scrypt(SymKey (KAB),Nonce (absPayload(pair(Agent (B),Agent (A))))),(SID sid)]);
iknows(scrypt(SymKey (KAB),Nonce (absPayload(pair(Agent (B),Agent (A))))))

step rule_13:
State (rB,[Agent (B),Step 0,Nonce (timestamp),SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (A),(SID sid)]);
iknows(SymKey (sk(pair(Agent (B),Agent (honest a)))));
iknows(Agent (A));
iknows(SymKey (KAB));
iknows(Nonce (T))

=>
secret(Nonce (absPayload(pair(Agent (B),Agent (A)))),Agent (A));
witness(Agent (B),Agent (A),Purpose (pABPayload),Nonce (absPayload(pair(Agent (B),Agent (A)))));
State (rB,[Agent (B),Step 1,Nonce (timestamp),SymKey (sk(pair(Agent (B),Agent (honest a)))),Agent (A),Nonce (T),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (B),Agent (honest a)))),pair(Agent (A),pair(SymKey (KAB),Nonce (T)))),Nonce (absPayload(pair(Agent (B),Agent (A)))),scrypt(SymKey (KAB),Nonce (absPayload(pair(Agent (B),Agent (A))))),(SID sid)]);
iknows(scrypt(SymKey (KAB),Nonce (absPayload(pair(Agent (B),Agent (A))))))

step rule_14:
State (rA,[Agent (A),Step 2,Nonce (timestamp),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),pair(Agent (A),Agent (B)),Agent (dishonest i),Nonce (T),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Agent (B),pair(SymKey (KAB),pair(Nonce (T),Agent (dishonest i))))),(SID sid)]);
iknows(scrypt(SymKey (KAB),Nonce (Payload)))

=>
request(Agent (A),Agent (B),Purpose (pABPayload),Nonce (Payload),(SID sid));
State (rA,[Agent (A),Step 3,Nonce (timestamp),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),pair(Agent (A),Agent (B)),Agent (dishonest i),Nonce (T),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Agent (B),pair(SymKey (KAB),pair(Nonce (T),Agent (dishonest i))))),Nonce (Payload),scrypt(SymKey (KAB),Nonce (Payload)),(SID sid)])

step rule_15:
State (rA,[Agent (A),Step 2,Nonce (timestamp),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),pair(Agent (A),Agent (B)),Agent (dishonest i),Nonce (T),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Agent (B),pair(SymKey (KAB),pair(Nonce (T),Agent (dishonest i))))),(SID sid)]);
iknows(SymKey (KAB));
iknows(Nonce (Payload))

=>
request(Agent (A),Agent (B),Purpose (pABPayload),Nonce (Payload),(SID sid));
State (rA,[Agent (A),Step 3,Nonce (timestamp),SymKey (sk(pair(Agent (A),Agent (honest a)))),Agent (B),pair(Agent (A),Agent (B)),Agent (dishonest i),Nonce (T),SymKey (KAB),scrypt(SymKey (sk(pair(Agent (A),Agent (honest a)))),pair(Agent (B),pair(SymKey (KAB),pair(Nonce (T),Agent (dishonest i))))),Nonce (Payload),scrypt(SymKey (KAB),Nonce (Payload)),(SID sid)])


section initial state:
init_0: iknows(Nonce (ni));
init_1: iknows(Agent (dishonest i));
init_2: State (rA,[Agent (honest a),Step 0,Nonce (timestamp),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),(SID sid)]);
init_3: State (rA,[Agent (honest a),Step 0,Nonce (timestamp),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),(SID sid)]);
init_4: iknows(Step 0);
init_5: iknows(Nonce (timestamp));
init_6: iknows(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))));
init_7: iknows((SID sid));
init_8: iknows(Agent (honest a));
init_9: State (rB,[Agent (honest a),Step 0,Nonce (timestamp),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),(SID sid)]);
init_10: State (rB,[Agent (honest a),Step 0,Nonce (timestamp),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),(SID sid)]);
init_11: State (rs,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Agent (dishonest i),(SID sid)]);
init_12: State (rs,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),Agent (honest a),(SID sid)]);
init_13: State (rs,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (honest a),Agent (dishonest i),(SID sid)]);
init_14: State (rs,[Agent (honest a),Step 0,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (honest a),(SID sid)]);

section fixedpoint:
fp_0: iknows(pair(Agent (honest a),Agent (honest a)));
fp_1: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_2: State (rA,[Agent (honest a),Step 1,Nonce (timestamp),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),pair(Agent (honest a),Agent (dishonest i)),(SID sid)]);
fp_3: State (rA,[Agent (honest a),Step 1,Nonce (timestamp),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),pair(Agent (honest a),Agent (honest a)),(SID sid)]);
fp_4: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Agent (dishonest i),pair(Agent (dishonest i),Agent (dishonest i)),SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i))))))))))),(SID sid)]);
fp_5: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),Agent (honest a),pair(Agent (honest a),Agent (dishonest i)),SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absT(pair(Agent (dishonest i),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absT(pair(Agent (dishonest i),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absT(pair(Agent (dishonest i),Agent (honest a))))))))))),(SID sid)]);
fp_6: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (honest a),Agent (dishonest i),pair(Agent (dishonest i),Agent (honest a)),SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absT(pair(Agent (honest a),Agent (dishonest i))))))))))),(SID sid)]);
fp_7: State (rs,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Agent (honest a),pair(Agent (honest a),Agent (honest a)),SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),Nonce (absT(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absT(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),Nonce (absT(pair(Agent (honest a),Agent (honest a))))))))))),(SID sid)]);
fp_8: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absT(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),Nonce (absT(pair(Agent (honest a),Agent (honest a))))))))))));
fp_9: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absT(pair(Agent (honest a),Agent (dishonest i))))))))))));
fp_10: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absT(pair(Agent (dishonest i),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (honest a)))),Nonce (absT(pair(Agent (dishonest i),Agent (honest a))))))))))));
fp_11: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i))))))))))));
fp_12: iknows(pair(Agent (honest a),Agent (honest a)));
fp_13: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_14: iknows(pair(Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))))))));
fp_15: iknows(pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i))))))))));
fp_16: iknows(pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))))))))));
fp_17: iknows(pair(Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_18: iknows(pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absT(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_19: iknows(pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))))))))));
fp_20: iknows(scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i))))))));
fp_21: iknows(Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))));
fp_22: iknows(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))));
fp_23: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absT(pair(Agent (honest a),Agent (dishonest i))))))));
fp_24: iknows(Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))));
fp_25: iknows(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))));
fp_26: iknows(pair(Agent (honest a),Agent (honest a)));
fp_27: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_28: iknows(pair(Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))))))));
fp_29: iknows(pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i))))))))));
fp_30: iknows(pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))))))))));
fp_31: iknows(pair(Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_32: iknows(pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absT(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_33: iknows(pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))))))))));
fp_34: iknows(pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i))))));
fp_35: iknows(pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))))));
fp_36: secret(Nonce (absPayload(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i));
fp_37: witness(Agent (honest a),Agent (dishonest i),Purpose (pABPayload),Nonce (absPayload(pair(Agent (honest a),Agent (dishonest i)))));
fp_38: State (rB,[Agent (honest a),Step 1,Nonce (timestamp),SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (dishonest i),Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))),SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absT(pair(Agent (honest a),Agent (dishonest i))))))),Nonce (absPayload(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absPayload(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_39: iknows(scrypt(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absPayload(pair(Agent (honest a),Agent (dishonest i))))));
fp_40: iknows(pair(Agent (honest a),Agent (honest a)));
fp_41: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_42: iknows(pair(Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))))))));
fp_43: iknows(pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i))))))))));
fp_44: iknows(pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))))))))));
fp_45: iknows(pair(Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_46: iknows(pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absT(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_47: iknows(pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))))))))));
fp_48: iknows(pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i))))));
fp_49: iknows(pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))))));
fp_50: iknows(Nonce (absPayload(pair(Agent (honest a),Agent (dishonest i)))));
fp_51: iknows(pair(Agent (honest a),Agent (honest a)));
fp_52: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_53: iknows(pair(Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))))))));
fp_54: iknows(pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i))))))))));
fp_55: iknows(pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))))))))));
fp_56: iknows(pair(Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_57: iknows(pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absT(pair(Agent (honest a),Agent (dishonest i))))))))));
fp_58: iknows(pair(Agent (honest a),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absT(pair(Agent (honest a),Agent (dishonest i)))))))))));
fp_59: iknows(pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i))))));
fp_60: iknows(pair(Agent (dishonest i),pair(SymKey (absKAB(pair(Agent (dishonest i),Agent (dishonest i)))),Nonce (absT(pair(Agent (dishonest i),Agent (dishonest i)))))));

section abstraction:
KAB->SymKey (absKAB(pair(B,A)));
T->Nonce (absT(pair(B,A)));
Payload->Nonce (absPayload(pair(B,A)))

