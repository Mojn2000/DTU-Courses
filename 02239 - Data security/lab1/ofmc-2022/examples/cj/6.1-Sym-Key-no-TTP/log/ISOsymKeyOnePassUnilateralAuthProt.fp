Backend: Open-Source Fixedpoint Model-Checker version 2020 
Protocol: ISO_onepass_symm
Types:
[(Purpose,["purposeText1"]),(Agent False False,["A","B"]),(Number,["NA","Text1"]),(Function,["sk"])]
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
request(A,B,Purpose (purposeText1),M,(SID sid))
 | B/=Agent (dishonest i);
M/=Nonce (absText1(pair(B,A)))
=>
attack(pair(authentication,pair(A,pair(B,M))))

step rule_7:
State (rA,[Agent (A),Step 0,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),(SID sid)])

=>
witness(Agent (A),Agent (B),Purpose (pBAText1),Nonce (absText1(pair(Agent (A),Agent (B)))));
State (rA,[Agent (A),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (B),Nonce (absNA(pair(Agent (A),Agent (B)))),Nonce (absText1(pair(Agent (A),Agent (B)))),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),pair(Agent (B),Nonce (absText1(pair(Agent (A),Agent (B))))))),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),pair(Agent (B),Nonce (absText1(pair(Agent (A),Agent (B))))))))

step rule_8:
State (rB,[Agent (B),Step 0,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),(SID sid)]);
iknows(scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(Nonce (NA),pair(Agent (B),Nonce (Text1)))))

=>
request(Agent (B),Agent (A),Purpose (pBAText1),Nonce (Text1),(SID sid));
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (Text1),Nonce (NA),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(Nonce (NA),pair(Agent (B),Nonce (Text1)))),(SID sid)])

step rule_9:
State (rB,[Agent (B),Step 0,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),(SID sid)]);
iknows(SymKey (sk(pair(Agent (A),Agent (B)))));
iknows(Nonce (NA));
iknows(Agent (B));
iknows(Nonce (Text1))

=>
request(Agent (B),Agent (A),Purpose (pBAText1),Nonce (Text1),(SID sid));
State (rB,[Agent (B),Step 1,SymKey (sk(pair(Agent (A),Agent (B)))),Agent (A),Nonce (Text1),Nonce (NA),scrypt(SymKey (sk(pair(Agent (A),Agent (B)))),pair(Nonce (NA),pair(Agent (B),Nonce (Text1)))),(SID sid)])


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
fp_0: witness(Agent (honest a),Agent (dishonest i),Purpose (pBAText1),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))));
fp_1: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_2: witness(Agent (honest a),Agent (honest a),Purpose (pBAText1),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))));
fp_3: State (rA,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_4: request(Agent (honest a),Agent (dishonest i),Purpose (pBAText1),Nonce (ni),(SID sid));
fp_5: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (ni),Nonce (ni),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (ni),pair(Agent (honest a),Nonce (ni)))),(SID sid)]);
fp_6: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a))))))));
fp_7: iknows(scrypt(SymKey (sk(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i))))))));
fp_8: iknows(pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i))))));
fp_9: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))))));
fp_10: request(Agent (honest a),Agent (honest a),Purpose (pBAText1),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),(SID sid));
fp_11: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (honest a),Agent (honest a)))),Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),scrypt(SymKey (sk(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a))))))),(SID sid)]);
fp_12: iknows(Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))));
fp_13: iknows(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))));
fp_14: iknows(pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i))))));
fp_15: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))))));
fp_16: request(Agent (honest a),Agent (dishonest i),Purpose (pBAText1),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_17: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_18: request(Agent (honest a),Agent (dishonest i),Purpose (pBAText1),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_19: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_20: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (ni),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (ni)))),(SID sid)]);
fp_21: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_22: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_23: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (ni),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (ni)))),(SID sid)]);
fp_24: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),Nonce (ni),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_25: State (rB,[Agent (honest a),Step 1,SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Nonce (ni),scrypt(SymKey (sk(pair(Agent (dishonest i),Agent (honest a)))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),(SID sid)]);
fp_26: iknows(pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i))))));
fp_27: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))))));

section abstraction:
NA->Nonce (absNA(pair(A,B)));
Text1->Nonce (absText1(pair(A,B)))

