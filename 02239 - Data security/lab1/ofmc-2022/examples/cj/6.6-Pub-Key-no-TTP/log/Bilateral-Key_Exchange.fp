Backend: Open-Source Fixedpoint Model-Checker version 2020 
Protocol: BilateralKeyExchange
Types:
[(Purpose,["purposeK"]),(Agent False False,["A","B"]),(Number,["NA","NB"]),(SymmetricKey,["K"]),(Function,["pk","f"])]
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
State (rB,[Agent (B),Step 0,inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (A)),Agent (A),(SID sid)])

=>
State (rB,[Agent (B),Step 1,inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (A)),Agent (A),Nonce (absNB(pair(Agent (B),Agent (A)))),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (absNB(pair(Agent (B),Agent (A)))),Agent (B)))),(SID sid)]);
iknows(pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (absNB(pair(Agent (B),Agent (A)))),Agent (B)))))

step rule_9:
State (rA,[Agent (A),Step 0,inv(pk(Agent (A))),pk(Agent (B)),pk(Agent (A)),Agent (B),(SID sid)]);
iknows(Agent (B));
iknows(crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B))))

=>
secret(SymKey (absK(pair(Agent (A),Agent (B)))),Agent (B));
witness(Agent (A),Agent (B),Purpose (pBAK),SymKey (absK(pair(Agent (A),Agent (B)))));
State (rA,[Agent (A),Step 1,inv(pk(Agent (A))),pk(Agent (B)),pk(Agent (A)),Agent (B),Nonce (NB),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B))),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B)))),Nonce (absNA(pair(Agent (A),Agent (B)))),SymKey (absK(pair(Agent (A),Agent (B)))),crypt(pk(Agent (B)),pair(f(Nonce (NB)),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),pair(Agent (A),SymKey (absK(pair(Agent (A),Agent (B)))))))),(SID sid)]);
iknows(crypt(pk(Agent (B)),pair(f(Nonce (NB)),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),pair(Agent (A),SymKey (absK(pair(Agent (A),Agent (B)))))))))

step rule_10:
State (rA,[Agent (A),Step 0,inv(pk(Agent (A))),pk(Agent (B)),pk(Agent (A)),Agent (B),(SID sid)]);
iknows(Agent (B));
iknows(pk(Agent (A)));
iknows(Nonce (NB))

=>
secret(SymKey (absK(pair(Agent (A),Agent (B)))),Agent (B));
witness(Agent (A),Agent (B),Purpose (pBAK),SymKey (absK(pair(Agent (A),Agent (B)))));
State (rA,[Agent (A),Step 1,inv(pk(Agent (A))),pk(Agent (B)),pk(Agent (A)),Agent (B),Nonce (NB),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B))),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B)))),Nonce (absNA(pair(Agent (A),Agent (B)))),SymKey (absK(pair(Agent (A),Agent (B)))),crypt(pk(Agent (B)),pair(f(Nonce (NB)),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),pair(Agent (A),SymKey (absK(pair(Agent (A),Agent (B)))))))),(SID sid)]);
iknows(crypt(pk(Agent (B)),pair(f(Nonce (NB)),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),pair(Agent (A),SymKey (absK(pair(Agent (A),Agent (B)))))))))

step rule_11:
State (rA,[Agent (A),Step 0,inv(pk(Agent (A))),pk(Agent (B)),pk(Agent (A)),Agent (B),(SID sid)]);
iknows(Agent (B));
iknows(Agent (A));
iknows(Nonce (NB))

=>
secret(SymKey (absK(pair(Agent (A),Agent (B)))),Agent (B));
witness(Agent (A),Agent (B),Purpose (pBAK),SymKey (absK(pair(Agent (A),Agent (B)))));
State (rA,[Agent (A),Step 1,inv(pk(Agent (A))),pk(Agent (B)),pk(Agent (A)),Agent (B),Nonce (NB),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B))),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B)))),Nonce (absNA(pair(Agent (A),Agent (B)))),SymKey (absK(pair(Agent (A),Agent (B)))),crypt(pk(Agent (B)),pair(f(Nonce (NB)),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),pair(Agent (A),SymKey (absK(pair(Agent (A),Agent (B)))))))),(SID sid)]);
iknows(crypt(pk(Agent (B)),pair(f(Nonce (NB)),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),pair(Agent (A),SymKey (absK(pair(Agent (A),Agent (B)))))))))

step rule_12:
State (rB,[Agent (B),Step 1,inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (A)),Agent (A),Nonce (NB),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B)))),(SID sid)]);
iknows(crypt(pk(Agent (B)),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K))))))

=>
request(Agent (B),Agent (A),Purpose (pBAK),SymKey (K),(SID sid));
State (rB,[Agent (B),Step 2,inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (A)),Agent (A),Nonce (NB),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B)))),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B))),SymKey (K),Nonce (NA),f(Nonce (NB)),crypt(pk(Agent (B)),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K))))),scrypt(SymKey (K),f(Nonce (NA))),(SID sid)]);
iknows(scrypt(SymKey (K),f(Nonce (NA))))

step rule_13:
State (rB,[Agent (B),Step 1,inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (A)),Agent (A),Nonce (NB),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B)))),(SID sid)]);
iknows(pk(Agent (B)));
iknows(f(Nonce (NB)));
iknows(Nonce (NA));
iknows(Agent (A));
iknows(SymKey (K))

=>
request(Agent (B),Agent (A),Purpose (pBAK),SymKey (K),(SID sid));
State (rB,[Agent (B),Step 2,inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (A)),Agent (A),Nonce (NB),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B)))),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B))),SymKey (K),Nonce (NA),f(Nonce (NB)),crypt(pk(Agent (B)),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K))))),scrypt(SymKey (K),f(Nonce (NA))),(SID sid)]);
iknows(scrypt(SymKey (K),f(Nonce (NA))))

step rule_14:
State (rB,[Agent (B),Step 1,inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (A)),Agent (A),Nonce (NB),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B)))),(SID sid)]);
iknows(pk(Agent (B)));
iknows(Nonce (NB));
iknows(Nonce (NA));
iknows(Agent (A));
iknows(SymKey (K))

=>
request(Agent (B),Agent (A),Purpose (pBAK),SymKey (K),(SID sid));
State (rB,[Agent (B),Step 2,inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (A)),Agent (A),Nonce (NB),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B)))),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B))),SymKey (K),Nonce (NA),f(Nonce (NB)),crypt(pk(Agent (B)),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K))))),scrypt(SymKey (K),f(Nonce (NA))),(SID sid)]);
iknows(scrypt(SymKey (K),f(Nonce (NA))))

step rule_15:
State (rB,[Agent (B),Step 1,inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (A)),Agent (A),Nonce (NB),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B)))),(SID sid)]);
iknows(Agent (B));
iknows(f(Nonce (NB)));
iknows(Nonce (NA));
iknows(Agent (A));
iknows(SymKey (K))

=>
request(Agent (B),Agent (A),Purpose (pBAK),SymKey (K),(SID sid));
State (rB,[Agent (B),Step 2,inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (A)),Agent (A),Nonce (NB),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B)))),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B))),SymKey (K),Nonce (NA),f(Nonce (NB)),crypt(pk(Agent (B)),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K))))),scrypt(SymKey (K),f(Nonce (NA))),(SID sid)]);
iknows(scrypt(SymKey (K),f(Nonce (NA))))

step rule_16:
State (rB,[Agent (B),Step 1,inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (A)),Agent (A),Nonce (NB),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B)))),(SID sid)]);
iknows(Agent (B));
iknows(Nonce (NB));
iknows(Nonce (NA));
iknows(Agent (A));
iknows(SymKey (K))

=>
request(Agent (B),Agent (A),Purpose (pBAK),SymKey (K),(SID sid));
State (rB,[Agent (B),Step 2,inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (A)),Agent (A),Nonce (NB),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B)))),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B))),SymKey (K),Nonce (NA),f(Nonce (NB)),crypt(pk(Agent (B)),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K))))),scrypt(SymKey (K),f(Nonce (NA))),(SID sid)]);
iknows(scrypt(SymKey (K),f(Nonce (NA))))

step rule_17:
State (rA,[Agent (A),Step 1,inv(pk(Agent (A))),pk(Agent (B)),pk(Agent (A)),Agent (B),Nonce (NB),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B))),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B)))),Nonce (NA),SymKey (K),crypt(pk(Agent (B)),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K))))),(SID sid)]);
iknows(scrypt(SymKey (K),f(Nonce (NA))))

=>
State (rA,[Agent (A),Step 2,inv(pk(Agent (A))),pk(Agent (B)),pk(Agent (A)),Agent (B),Nonce (NB),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B))),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B)))),Nonce (NA),SymKey (K),crypt(pk(Agent (B)),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K))))),scrypt(SymKey (K),f(Nonce (NA))),(SID sid)])

step rule_18:
State (rA,[Agent (A),Step 1,inv(pk(Agent (A))),pk(Agent (B)),pk(Agent (A)),Agent (B),Nonce (NB),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B))),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B)))),Nonce (NA),SymKey (K),crypt(pk(Agent (B)),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K))))),(SID sid)]);
iknows(SymKey (K));
iknows(f(Nonce (NA)))

=>
State (rA,[Agent (A),Step 2,inv(pk(Agent (A))),pk(Agent (B)),pk(Agent (A)),Agent (B),Nonce (NB),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B))),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B)))),Nonce (NA),SymKey (K),crypt(pk(Agent (B)),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K))))),scrypt(SymKey (K),f(Nonce (NA))),(SID sid)])

step rule_19:
State (rA,[Agent (A),Step 1,inv(pk(Agent (A))),pk(Agent (B)),pk(Agent (A)),Agent (B),Nonce (NB),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B))),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B)))),Nonce (NA),SymKey (K),crypt(pk(Agent (B)),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K))))),(SID sid)]);
iknows(SymKey (K));
iknows(Nonce (NA))

=>
State (rA,[Agent (A),Step 2,inv(pk(Agent (A))),pk(Agent (B)),pk(Agent (A)),Agent (B),Nonce (NB),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B))),pair(Agent (B),crypt(pk(Agent (A)),pair(Nonce (NB),Agent (B)))),Nonce (NA),SymKey (K),crypt(pk(Agent (B)),pair(f(Nonce (NB)),pair(Nonce (NA),pair(Agent (A),SymKey (K))))),scrypt(SymKey (K),f(Nonce (NA))),(SID sid)])


section initial state:
init_0: iknows(Nonce (ni));
init_1: iknows(Agent (dishonest i));
init_2: State (rA,[Agent (honest a),Step 0,inv(pk(Agent (honest a))),pk(Agent (dishonest i)),pk(Agent (honest a)),Agent (dishonest i),(SID sid)]);
init_3: State (rA,[Agent (honest a),Step 0,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),(SID sid)]);
init_4: iknows(Step 0);
init_5: iknows(inv(pk(Agent (dishonest i))));
init_6: iknows(pk(Agent (dishonest i)));
init_7: iknows((SID sid));
init_8: iknows(pk(Agent (honest a)));
init_9: iknows(Agent (honest a));
init_10: State (rB,[Agent (honest a),Step 0,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),Agent (dishonest i),(SID sid)]);
init_11: State (rB,[Agent (honest a),Step 0,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),(SID sid)]);

section fixedpoint:
fp_0: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))));
fp_1: iknows(pair(Agent (honest a),crypt(pk(Agent (dishonest i)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))));
fp_2: State (rB,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),crypt(pk(Agent (dishonest i)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))),(SID sid)]);
fp_3: State (rB,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),(SID sid)]);
fp_4: secret(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i));
fp_5: witness(Agent (honest a),Agent (dishonest i),Purpose (pBAK),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))));
fp_6: State (rA,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),pk(Agent (dishonest i)),pk(Agent (honest a)),Agent (dishonest i),Nonce (ni),crypt(pk(Agent (honest a)),pair(Nonce (ni),Agent (dishonest i))),pair(Agent (dishonest i),crypt(pk(Agent (honest a)),pair(Nonce (ni),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))),(SID sid)]);
fp_7: secret(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),Agent (honest a));
fp_8: witness(Agent (honest a),Agent (honest a),Purpose (pBAK),SymKey (absK(pair(Agent (honest a),Agent (honest a)))));
fp_9: State (rA,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),Nonce (ni),crypt(pk(Agent (honest a)),pair(Nonce (ni),Agent (honest a))),pair(Agent (honest a),crypt(pk(Agent (honest a)),pair(Nonce (ni),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),SymKey (absK(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))),(SID sid)]);
fp_10: iknows(crypt(pk(Agent (honest a)),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))));
fp_11: iknows(crypt(pk(Agent (dishonest i)),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_12: iknows(crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))));
fp_13: iknows(crypt(pk(Agent (dishonest i)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))));
fp_14: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))));
fp_15: iknows(pair(Agent (honest a),crypt(pk(Agent (dishonest i)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))));
fp_16: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_17: iknows(pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))));
fp_18: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))));
fp_19: iknows(pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));
fp_20: State (rA,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))),pair(Agent (honest a),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),SymKey (absK(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))),(SID sid)]);
fp_21: iknows(crypt(pk(Agent (honest a)),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))));
fp_22: iknows(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))));
fp_23: iknows(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))));
fp_24: iknows(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))));
fp_25: iknows(f(Nonce (ni)));
fp_26: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))));
fp_27: iknows(pair(Agent (honest a),crypt(pk(Agent (dishonest i)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))));
fp_28: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_29: iknows(pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))));
fp_30: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))));
fp_31: iknows(pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));
fp_32: State (rA,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),pk(Agent (dishonest i)),pk(Agent (honest a)),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))),pair(Agent (dishonest i),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))),(SID sid)]);
fp_33: State (rA,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),pk(Agent (dishonest i)),pk(Agent (honest a)),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))),pair(Agent (dishonest i),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))),(SID sid)]);
fp_34: State (rA,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),pair(Agent (honest a),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),SymKey (absK(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))),(SID sid)]);
fp_35: State (rA,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),pair(Agent (honest a),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),SymKey (absK(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))),(SID sid)]);
fp_36: request(Agent (honest a),Agent (honest a),Purpose (pBAK),SymKey (absK(pair(Agent (honest a),Agent (honest a)))),(SID sid));
fp_37: State (rB,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))),SymKey (absK(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),crypt(pk(Agent (honest a)),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))),scrypt(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),(SID sid)]);
fp_38: request(Agent (honest a),Agent (dishonest i),Purpose (pBAK),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_39: State (rB,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),crypt(pk(Agent (dishonest i)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))),crypt(pk(Agent (dishonest i)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),crypt(pk(Agent (honest a)),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))),(SID sid)]);
fp_40: State (rB,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),crypt(pk(Agent (dishonest i)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))),crypt(pk(Agent (dishonest i)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),crypt(pk(Agent (honest a)),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),(SID sid)]);
fp_41: State (rB,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),crypt(pk(Agent (dishonest i)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))),crypt(pk(Agent (dishonest i)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),Nonce (ni),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),crypt(pk(Agent (honest a)),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (ni),pair(Agent (dishonest i),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (ni))),(SID sid)]);
fp_42: State (rA,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (dishonest i)),pk(Agent (honest a)),Agent (dishonest i),Nonce (ni),crypt(pk(Agent (honest a)),pair(Nonce (ni),Agent (dishonest i))),pair(Agent (dishonest i),crypt(pk(Agent (honest a)),pair(Nonce (ni),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),(SID sid)]);
fp_43: iknows(scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (ni))));
fp_44: iknows(scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))));
fp_45: iknows(scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))))));
fp_46: iknows(scrypt(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))));
fp_47: iknows(crypt(pk(Agent (honest a)),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))));
fp_48: iknows(crypt(pk(Agent (honest a)),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))));
fp_49: iknows(crypt(pk(Agent (dishonest i)),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_50: iknows(crypt(pk(Agent (dishonest i)),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_51: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))));
fp_52: iknows(pair(Agent (honest a),crypt(pk(Agent (dishonest i)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))));
fp_53: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_54: iknows(pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))));
fp_55: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))));
fp_56: iknows(pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));
fp_57: iknows(pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));
fp_58: iknows(pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));
fp_59: State (rA,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (dishonest i)),pk(Agent (honest a)),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))),pair(Agent (dishonest i),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),(SID sid)]);
fp_60: State (rA,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (dishonest i)),pk(Agent (honest a)),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))),pair(Agent (dishonest i),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))))),scrypt(SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))),f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))),(SID sid)]);
fp_61: State (rA,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),pair(Agent (honest a),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),SymKey (absK(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))),scrypt(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),(SID sid)]);
fp_62: State (rA,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),pair(Agent (honest a),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),SymKey (absK(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))),scrypt(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),(SID sid)]);
fp_63: State (rA,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))),pair(Agent (honest a),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),SymKey (absK(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(f(Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))),scrypt(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),(SID sid)]);
fp_64: State (rA,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),Nonce (ni),crypt(pk(Agent (honest a)),pair(Nonce (ni),Agent (honest a))),pair(Agent (honest a),crypt(pk(Agent (honest a)),pair(Nonce (ni),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),SymKey (absK(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (honest a)))))))),scrypt(SymKey (absK(pair(Agent (honest a),Agent (honest a)))),f(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))),(SID sid)]);
fp_65: iknows(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_66: iknows(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))));
fp_67: iknows(pair(Agent (honest a),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))));
fp_68: iknows(pair(Agent (honest a),crypt(pk(Agent (dishonest i)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))));
fp_69: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_70: iknows(pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))));
fp_71: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i)))))));
fp_72: iknows(pair(f(Nonce (ni)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));
fp_73: iknows(pair(f(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));
fp_74: iknows(pair(f(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),SymKey (absK(pair(Agent (honest a),Agent (dishonest i))))))));

section abstraction:
NB->Nonce (absNB(pair(B,A)));
NA->Nonce (absNA(pair(A,B)));
K->SymKey (absK(pair(A,B)))

