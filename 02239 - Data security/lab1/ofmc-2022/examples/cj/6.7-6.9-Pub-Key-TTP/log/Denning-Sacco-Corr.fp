Backend: Open-Source Fixedpoint Model-Checker version 2020 
Protocol: DenningSaccoCorr
Types:
[(Purpose,["purposeKAB"]),(Agent False False,["A","B","s"]),(Number,["NA","Text1","Text2","Text3","Text4","tag"]),(SymmetricKey,["KAB"]),(Function,["pk"])]
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
request(A,B,Purpose (purposeNA),M,(SID sid))
 | B/=Agent (dishonest i);
M/=Nonce (absNA(pair(B,A)))
=>
attack(pair(authentication,pair(A,pair(B,M))))

step rule_7:
State (rA,[Agent (A),Step 0,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),(SID sid)])

=>
State (rA,[Agent (A),Step 1,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),pair(Agent (A),Agent (B)),(SID sid)]);
iknows(pair(Agent (A),Agent (B)))

step rule_8:
State (rs,[Agent (honest a),Step 0,Nonce (tag),inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (B)),pk(Agent (A)),Agent (B),Agent (A),(SID sid)]);
iknows(Agent (A));
iknows(Agent (B))

=>
State (rs,[Agent (honest a),Step 1,Nonce (tag),inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (B)),pk(Agent (A)),Agent (B),Agent (A),pair(Agent (A),Agent (B)),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B))))),(SID sid)]);
iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B))))))

step rule_9:
State (rA,[Agent (A),Step 1,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),pair(Agent (A),Agent (B)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))))

=>
secret(SymKey (absKAB(pair(Agent (A),Agent (B)))),Agent (B));
witness(Agent (A),Agent (B),Purpose (pBAKAB),SymKey (absKAB(pair(Agent (A),Agent (B)))));
State (rA,[Agent (A),Step 2,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B))))),SymKey (absKAB(pair(Agent (A),Agent (B)))),Nonce (absNA(pair(Agent (A),Agent (B)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (absKAB(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B)))),Nonce (tag))))),(SID sid)]);
iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (absKAB(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B)))),Nonce (tag))))))

step rule_10:
State (rA,[Agent (A),Step 1,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),pair(Agent (A),Agent (B)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(inv(pk(Agent (honest a))));
iknows(Agent (B));
iknows(pk(Agent (B)))

=>
secret(SymKey (absKAB(pair(Agent (A),Agent (B)))),Agent (B));
witness(Agent (A),Agent (B),Purpose (pBAKAB),SymKey (absKAB(pair(Agent (A),Agent (B)))));
State (rA,[Agent (A),Step 2,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B))))),SymKey (absKAB(pair(Agent (A),Agent (B)))),Nonce (absNA(pair(Agent (A),Agent (B)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (absKAB(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B)))),Nonce (tag))))),(SID sid)]);
iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (absKAB(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B)))),Nonce (tag))))))

step rule_11:
State (rA,[Agent (A),Step 1,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),pair(Agent (A),Agent (B)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(inv(pk(Agent (honest a))));
iknows(Agent (B))

=>
secret(SymKey (absKAB(pair(Agent (A),Agent (B)))),Agent (B));
witness(Agent (A),Agent (B),Purpose (pBAKAB),SymKey (absKAB(pair(Agent (A),Agent (B)))));
State (rA,[Agent (A),Step 2,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B))))),SymKey (absKAB(pair(Agent (A),Agent (B)))),Nonce (absNA(pair(Agent (A),Agent (B)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (absKAB(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B)))),Nonce (tag))))),(SID sid)]);
iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (absKAB(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B)))),Nonce (tag))))))

step rule_12:
State (rA,[Agent (A),Step 1,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),pair(Agent (A),Agent (B)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))))

=>
secret(SymKey (absKAB(pair(Agent (A),Agent (B)))),Agent (B));
witness(Agent (A),Agent (B),Purpose (pBAKAB),SymKey (absKAB(pair(Agent (A),Agent (B)))));
State (rA,[Agent (A),Step 2,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B))))),SymKey (absKAB(pair(Agent (A),Agent (B)))),Nonce (absNA(pair(Agent (A),Agent (B)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (absKAB(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B)))),Nonce (tag))))),(SID sid)]);
iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (absKAB(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B)))),Nonce (tag))))))

step rule_13:
State (rA,[Agent (A),Step 1,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),pair(Agent (A),Agent (B)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(Agent (B));
iknows(pk(Agent (B)))

=>
secret(SymKey (absKAB(pair(Agent (A),Agent (B)))),Agent (B));
witness(Agent (A),Agent (B),Purpose (pBAKAB),SymKey (absKAB(pair(Agent (A),Agent (B)))));
State (rA,[Agent (A),Step 2,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B))))),SymKey (absKAB(pair(Agent (A),Agent (B)))),Nonce (absNA(pair(Agent (A),Agent (B)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (absKAB(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B)))),Nonce (tag))))),(SID sid)]);
iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (absKAB(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B)))),Nonce (tag))))))

step rule_14:
State (rA,[Agent (A),Step 1,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),pair(Agent (A),Agent (B)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(Agent (B))

=>
secret(SymKey (absKAB(pair(Agent (A),Agent (B)))),Agent (B));
witness(Agent (A),Agent (B),Purpose (pBAKAB),SymKey (absKAB(pair(Agent (A),Agent (B)))));
State (rA,[Agent (A),Step 2,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B))))),SymKey (absKAB(pair(Agent (A),Agent (B)))),Nonce (absNA(pair(Agent (A),Agent (B)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (absKAB(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B)))),Nonce (tag))))),(SID sid)]);
iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (absKAB(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B)))),Nonce (tag))))))

step rule_15:
State (rA,[Agent (A),Step 1,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),pair(Agent (A),Agent (B)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))))

=>
secret(SymKey (absKAB(pair(Agent (A),Agent (B)))),Agent (B));
witness(Agent (A),Agent (B),Purpose (pBAKAB),SymKey (absKAB(pair(Agent (A),Agent (B)))));
State (rA,[Agent (A),Step 2,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B))))),SymKey (absKAB(pair(Agent (A),Agent (B)))),Nonce (absNA(pair(Agent (A),Agent (B)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (absKAB(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B)))),Nonce (tag))))),(SID sid)]);
iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (absKAB(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B)))),Nonce (tag))))))

step rule_16:
State (rA,[Agent (A),Step 1,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),pair(Agent (A),Agent (B)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(Agent (B));
iknows(pk(Agent (B)))

=>
secret(SymKey (absKAB(pair(Agent (A),Agent (B)))),Agent (B));
witness(Agent (A),Agent (B),Purpose (pBAKAB),SymKey (absKAB(pair(Agent (A),Agent (B)))));
State (rA,[Agent (A),Step 2,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B))))),SymKey (absKAB(pair(Agent (A),Agent (B)))),Nonce (absNA(pair(Agent (A),Agent (B)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (absKAB(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B)))),Nonce (tag))))),(SID sid)]);
iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (absKAB(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B)))),Nonce (tag))))))

step rule_17:
State (rA,[Agent (A),Step 1,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),pair(Agent (A),Agent (B)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(Agent (B))

=>
secret(SymKey (absKAB(pair(Agent (A),Agent (B)))),Agent (B));
witness(Agent (A),Agent (B),Purpose (pBAKAB),SymKey (absKAB(pair(Agent (A),Agent (B)))));
State (rA,[Agent (A),Step 2,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (A))),pk(Agent (A)),Agent (B),pair(Agent (A),Agent (B)),pk(Agent (B)),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B))))),SymKey (absKAB(pair(Agent (A),Agent (B)))),Nonce (absNA(pair(Agent (A),Agent (B)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (absKAB(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B)))),Nonce (tag))))),(SID sid)]);
iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (absKAB(pair(Agent (A),Agent (B)))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B)))),Nonce (tag))))))

step rule_18:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))));
iknows(crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_19:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))));
iknows(pk(Agent (B)));
iknows(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_20:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))));
iknows(pk(Agent (B)));
iknows(inv(pk(Agent (A))));
iknows(SymKey (KAB));
iknows(Nonce (NA));
iknows(Agent (B));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_21:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))));
iknows(Agent (B));
iknows(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_22:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))));
iknows(Agent (B));
iknows(inv(pk(Agent (A))));
iknows(SymKey (KAB));
iknows(Nonce (NA));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_23:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(inv(pk(Agent (honest a))));
iknows(Agent (B));
iknows(pk(Agent (B)));
iknows(crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_24:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(inv(pk(Agent (honest a))));
iknows(Agent (B));
iknows(pk(Agent (B)));
iknows(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_25:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(inv(pk(Agent (honest a))));
iknows(Agent (B));
iknows(pk(Agent (B)));
iknows(inv(pk(Agent (A))));
iknows(SymKey (KAB));
iknows(Nonce (NA));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_26:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(inv(pk(Agent (honest a))));
iknows(Agent (B));
iknows(pk(Agent (B)));
iknows(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_27:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(inv(pk(Agent (honest a))));
iknows(Agent (B));
iknows(pk(Agent (B)));
iknows(inv(pk(Agent (A))));
iknows(SymKey (KAB));
iknows(Nonce (NA));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_28:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(inv(pk(Agent (honest a))));
iknows(Agent (B));
iknows(crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_29:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(inv(pk(Agent (honest a))));
iknows(Agent (B));
iknows(pk(Agent (B)));
iknows(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_30:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(inv(pk(Agent (honest a))));
iknows(Agent (B));
iknows(pk(Agent (B)));
iknows(inv(pk(Agent (A))));
iknows(SymKey (KAB));
iknows(Nonce (NA));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_31:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(inv(pk(Agent (honest a))));
iknows(Agent (B));
iknows(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_32:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(inv(pk(Agent (honest a))));
iknows(Agent (B));
iknows(inv(pk(Agent (A))));
iknows(SymKey (KAB));
iknows(Nonce (NA));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_33:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))));
iknows(crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_34:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))));
iknows(pk(Agent (B)));
iknows(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_35:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))));
iknows(pk(Agent (B)));
iknows(inv(pk(Agent (A))));
iknows(SymKey (KAB));
iknows(Nonce (NA));
iknows(Agent (B));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_36:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))));
iknows(Agent (B));
iknows(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_37:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))));
iknows(Agent (B));
iknows(inv(pk(Agent (A))));
iknows(SymKey (KAB));
iknows(Nonce (NA));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_38:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(Agent (B));
iknows(pk(Agent (B)));
iknows(crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_39:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(Agent (B));
iknows(pk(Agent (B)));
iknows(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_40:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(Agent (B));
iknows(pk(Agent (B)));
iknows(inv(pk(Agent (A))));
iknows(SymKey (KAB));
iknows(Nonce (NA));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_41:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(Agent (B));
iknows(pk(Agent (B)));
iknows(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_42:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(Agent (B));
iknows(pk(Agent (B)));
iknows(inv(pk(Agent (A))));
iknows(SymKey (KAB));
iknows(Nonce (NA));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_43:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(Agent (B));
iknows(crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_44:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(Agent (B));
iknows(pk(Agent (B)));
iknows(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_45:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(Agent (B));
iknows(pk(Agent (B)));
iknows(inv(pk(Agent (A))));
iknows(SymKey (KAB));
iknows(Nonce (NA));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_46:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(Agent (B));
iknows(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_47:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(Agent (B));
iknows(inv(pk(Agent (A))));
iknows(SymKey (KAB));
iknows(Nonce (NA));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_48:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))));
iknows(crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_49:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))));
iknows(pk(Agent (B)));
iknows(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_50:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))));
iknows(pk(Agent (B)));
iknows(inv(pk(Agent (A))));
iknows(SymKey (KAB));
iknows(Nonce (NA));
iknows(Agent (B));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_51:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))));
iknows(Agent (B));
iknows(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_52:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))));
iknows(Agent (B));
iknows(inv(pk(Agent (A))));
iknows(SymKey (KAB));
iknows(Nonce (NA));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_53:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(Agent (B));
iknows(pk(Agent (B)));
iknows(crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_54:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(Agent (B));
iknows(pk(Agent (B)));
iknows(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_55:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(Agent (B));
iknows(pk(Agent (B)));
iknows(inv(pk(Agent (A))));
iknows(SymKey (KAB));
iknows(Nonce (NA));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_56:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(Agent (B));
iknows(crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_57:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(Agent (B));
iknows(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])

step rule_58:
State (rB,[Agent (B),Step 0,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(Agent (B));
iknows(inv(pk(Agent (A))));
iknows(SymKey (KAB));
iknows(Nonce (NA));
iknows(Nonce (tag))

=>
request(Agent (B),Agent (A),Purpose (pBAKAB),SymKey (KAB),(SID sid));
State (rB,[Agent (B),Step 1,Nonce (tag),inv(pk(Agent (B))),pk(Agent (B)),pk(Agent (honest a)),Nonce (NA),SymKey (KAB),crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (B),pk(Agent (B)))),crypt(pk(Agent (B)),pair(crypt(inv(pk(Agent (A))),pair(SymKey (KAB),pair(Nonce (NA),Agent (B)))),Nonce (tag))))),(SID sid)])


section initial state:
init_0: iknows(Nonce (ni));
init_1: iknows(Agent (dishonest i));
init_2: State (rA,[Agent (honest a),Step 0,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (dishonest i),(SID sid)]);
init_3: State (rA,[Agent (honest a),Step 0,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (honest a),(SID sid)]);
init_4: iknows(Step 0);
init_5: iknows(Nonce (tag));
init_6: iknows(pk(Agent (honest a)));
init_7: iknows(inv(pk(Agent (dishonest i))));
init_8: iknows(pk(Agent (dishonest i)));
init_9: iknows((SID sid));
init_10: iknows(Agent (honest a));
init_11: State (rB,[Agent (honest a),Step 0,Nonce (tag),inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),(SID sid)]);
init_12: State (rs,[Agent (honest a),Step 0,Nonce (tag),inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),pk(Agent (dishonest i)),Agent (dishonest i),Agent (dishonest i),(SID sid)]);
init_13: State (rs,[Agent (honest a),Step 0,Nonce (tag),inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),pk(Agent (honest a)),Agent (dishonest i),Agent (honest a),(SID sid)]);
init_14: State (rs,[Agent (honest a),Step 0,Nonce (tag),inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),pk(Agent (dishonest i)),Agent (honest a),Agent (dishonest i),(SID sid)]);
init_15: State (rs,[Agent (honest a),Step 0,Nonce (tag),inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),Agent (honest a),(SID sid)]);

section fixedpoint:
fp_0: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a))))));
fp_1: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a))))));
fp_2: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i))))));
fp_3: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i))))));
fp_4: iknows(pair(Agent (honest a),Agent (honest a)));
fp_5: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_6: State (rA,[Agent (honest a),Step 1,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (dishonest i),pair(Agent (honest a),Agent (dishonest i)),(SID sid)]);
fp_7: State (rA,[Agent (honest a),Step 1,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (honest a),pair(Agent (honest a),Agent (honest a)),(SID sid)]);
fp_8: State (rs,[Agent (honest a),Step 1,Nonce (tag),inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),pk(Agent (dishonest i)),Agent (dishonest i),Agent (dishonest i),pair(Agent (dishonest i),Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i))))),(SID sid)]);
fp_9: State (rs,[Agent (honest a),Step 1,Nonce (tag),inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (dishonest i)),pk(Agent (honest a)),Agent (dishonest i),Agent (honest a),pair(Agent (honest a),Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i))))),(SID sid)]);
fp_10: State (rs,[Agent (honest a),Step 1,Nonce (tag),inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),pk(Agent (dishonest i)),Agent (honest a),Agent (dishonest i),pair(Agent (dishonest i),Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a))))),(SID sid)]);
fp_11: State (rs,[Agent (honest a),Step 1,Nonce (tag),inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),pk(Agent (honest a)),Agent (honest a),Agent (honest a),pair(Agent (honest a),Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a))))),(SID sid)]);
fp_12: iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))));
fp_13: iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))));
fp_14: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),Nonce (tag)))));
fp_15: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),Nonce (tag))))));
fp_16: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (tag)))));
fp_17: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (tag))))));
fp_18: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a))))));
fp_19: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a))))));
fp_20: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i))))));
fp_21: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i))))));
fp_22: iknows(pair(Agent (honest a),Agent (honest a)));
fp_23: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_24: iknows(pair(Agent (dishonest i),pk(Agent (dishonest i))));
fp_25: iknows(pair(Agent (honest a),pk(Agent (honest a))));
fp_26: secret(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i));
fp_27: witness(Agent (honest a),Agent (dishonest i),Purpose (pBAKAB),SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))));
fp_28: State (rA,[Agent (honest a),Step 2,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (dishonest i),pair(Agent (honest a),Agent (dishonest i)),pk(Agent (dishonest i)),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i))))),SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (tag))))),(SID sid)]);
fp_29: secret(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a));
fp_30: witness(Agent (honest a),Agent (honest a),Purpose (pBAKAB),SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))));
fp_31: State (rA,[Agent (honest a),Step 2,Nonce (tag),pk(Agent (honest a)),inv(pk(Agent (honest a))),pk(Agent (honest a)),Agent (honest a),pair(Agent (honest a),Agent (honest a)),pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a))))),SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),Nonce (tag))))),(SID sid)]);
fp_32: iknows(crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),Nonce (tag))));
fp_33: iknows(crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (tag))));
fp_34: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),Nonce (tag)))));
fp_35: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),Nonce (tag))))));
fp_36: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (tag)))));
fp_37: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (tag))))));
fp_38: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a))))));
fp_39: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a))))));
fp_40: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i))))));
fp_41: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i))))));
fp_42: iknows(pair(Agent (honest a),Agent (honest a)));
fp_43: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_44: iknows(pair(Agent (dishonest i),pk(Agent (dishonest i))));
fp_45: iknows(pair(Agent (honest a),pk(Agent (honest a))));
fp_46: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (tag)));
fp_47: request(Agent (honest a),Agent (honest a),Purpose (pBAKAB),SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),(SID sid));
fp_48: State (rB,[Agent (honest a),Step 1,Nonce (tag),inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pk(Agent (honest a)),Agent (honest a),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),Nonce (tag))))),(SID sid)]);
fp_49: iknows(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))));
fp_50: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),Nonce (tag)))));
fp_51: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),Nonce (tag))))));
fp_52: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (tag)))));
fp_53: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (tag))))));
fp_54: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a))))));
fp_55: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a))))));
fp_56: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i))))));
fp_57: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i))))));
fp_58: iknows(pair(Agent (honest a),Agent (honest a)));
fp_59: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_60: iknows(pair(Agent (dishonest i),pk(Agent (dishonest i))));
fp_61: iknows(pair(Agent (honest a),pk(Agent (honest a))));
fp_62: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)));
fp_63: iknows(pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))));
fp_64: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (tag)));
fp_65: iknows(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))));
fp_66: iknows(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))));
fp_67: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),Nonce (tag)))));
fp_68: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),Nonce (tag))))));
fp_69: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (tag)))));
fp_70: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (tag))))));
fp_71: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a))))));
fp_72: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a))))));
fp_73: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i))))));
fp_74: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i))))));
fp_75: iknows(pair(Agent (honest a),Agent (honest a)));
fp_76: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_77: iknows(pair(Agent (dishonest i),pk(Agent (dishonest i))));
fp_78: iknows(pair(Agent (honest a),pk(Agent (honest a))));
fp_79: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)));
fp_80: iknows(pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))));
fp_81: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (tag)));
fp_82: request(Agent (honest a),Agent (dishonest i),Purpose (pBAKAB),SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_83: State (rB,[Agent (honest a),Step 1,Nonce (tag),inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (dishonest i))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (dishonest i))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))),Nonce (tag))))),(SID sid)]);
fp_84: State (rB,[Agent (honest a),Step 1,Nonce (tag),inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),Nonce (ni),SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (ni),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (dishonest i))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (ni),Agent (honest a)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (dishonest i))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (ni),Agent (honest a)))),Nonce (tag))))),(SID sid)]);
fp_85: State (rB,[Agent (honest a),Step 1,Nonce (tag),inv(pk(Agent (honest a))),pk(Agent (honest a)),pk(Agent (honest a)),Nonce (tag),SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (tag),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (dishonest i))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (tag),Agent (honest a)))),Nonce (tag))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (dishonest i))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (tag),Agent (honest a)))),Nonce (tag))))),(SID sid)]);
fp_86: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),Nonce (tag)))));
fp_87: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(pk(Agent (honest a)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),Nonce (tag))))));
fp_88: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (tag)))));
fp_89: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (tag))))));
fp_90: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a))))));
fp_91: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a))))));
fp_92: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i))))));
fp_93: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i))))));
fp_94: iknows(pair(Agent (honest a),Agent (honest a)));
fp_95: iknows(pair(Agent (honest a),Agent (dishonest i)));
fp_96: iknows(pair(Agent (dishonest i),pk(Agent (dishonest i))));
fp_97: iknows(pair(Agent (honest a),pk(Agent (honest a))));
fp_98: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)));
fp_99: iknows(pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))));
fp_100: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(SymKey (absKAB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),Nonce (tag)));

section abstraction:
KAB->SymKey (absKAB(pair(A,B)));
NA->Nonce (absNA(pair(A,B)))

