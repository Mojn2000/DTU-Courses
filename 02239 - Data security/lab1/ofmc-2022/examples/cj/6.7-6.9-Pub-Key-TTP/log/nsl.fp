Backend: Open-Source Fixedpoint Model-Checker version 2020 
Protocol: NSL
Types:
[(Purpose,["purposeNA","purposeNB"]),(Agent False False,["A","B"]),(Number,["NA","NB"]),(Function,["pk"])]
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
State (rA,[Agent (A),Step 0,Agent (B),inv(pk(Agent (A))),(SID sid)])

=>
secret(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (B));
witness(Agent (A),Agent (B),Purpose (pBANA),Nonce (absNA(pair(Agent (A),Agent (B)))));
State (rA,[Agent (A),Step 1,Agent (B),inv(pk(Agent (A))),Nonce (absNA(pair(Agent (A),Agent (B)))),crypt(pk(Agent (B)),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (A))),(SID sid)]);
iknows(crypt(pk(Agent (B)),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),Agent (A))))

step rule_8:
State (rB,[Agent (B),Step 0,inv(pk(Agent (B))),(SID sid)]);
iknows(crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))))

=>
secret(Nonce (absNB(pair(Agent (B),Agent (A)))),Agent (A));
witness(Agent (B),Agent (A),Purpose (pABNB),Nonce (absNB(pair(Agent (B),Agent (A)))));
State (rB,[Agent (B),Step 1,inv(pk(Agent (B))),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),Nonce (absNB(pair(Agent (B),Agent (A)))),crypt(pk(Agent (A)),pair(Nonce (NA),pair(Nonce (absNB(pair(Agent (B),Agent (A)))),Agent (B)))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(Nonce (NA),pair(Nonce (absNB(pair(Agent (B),Agent (A)))),Agent (B)))))

step rule_9:
State (rB,[Agent (B),Step 0,inv(pk(Agent (B))),(SID sid)]);
iknows(pk(Agent (B)));
iknows(Nonce (NA));
iknows(Agent (A))

=>
secret(Nonce (absNB(pair(Agent (B),Agent (A)))),Agent (A));
witness(Agent (B),Agent (A),Purpose (pABNB),Nonce (absNB(pair(Agent (B),Agent (A)))));
State (rB,[Agent (B),Step 1,inv(pk(Agent (B))),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),Nonce (absNB(pair(Agent (B),Agent (A)))),crypt(pk(Agent (A)),pair(Nonce (NA),pair(Nonce (absNB(pair(Agent (B),Agent (A)))),Agent (B)))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(Nonce (NA),pair(Nonce (absNB(pair(Agent (B),Agent (A)))),Agent (B)))))

step rule_10:
State (rB,[Agent (B),Step 0,inv(pk(Agent (B))),(SID sid)]);
iknows(Agent (B));
iknows(Nonce (NA));
iknows(Agent (A))

=>
secret(Nonce (absNB(pair(Agent (B),Agent (A)))),Agent (A));
witness(Agent (B),Agent (A),Purpose (pABNB),Nonce (absNB(pair(Agent (B),Agent (A)))));
State (rB,[Agent (B),Step 1,inv(pk(Agent (B))),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),Nonce (absNB(pair(Agent (B),Agent (A)))),crypt(pk(Agent (A)),pair(Nonce (NA),pair(Nonce (absNB(pair(Agent (B),Agent (A)))),Agent (B)))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(Nonce (NA),pair(Nonce (absNB(pair(Agent (B),Agent (A)))),Agent (B)))))

step rule_11:
State (rA,[Agent (A),Step 1,Agent (B),inv(pk(Agent (A))),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),(SID sid)]);
iknows(crypt(pk(Agent (A)),pair(Nonce (NA),pair(Nonce (NB),Agent (B)))))

=>
request(Agent (A),Agent (B),Purpose (pABNB),Nonce (NB),(SID sid));
State (rA,[Agent (A),Step 2,Agent (B),inv(pk(Agent (A))),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),Nonce (NB),crypt(pk(Agent (A)),pair(Nonce (NA),pair(Nonce (NB),Agent (B)))),crypt(pk(Agent (B)),Nonce (NB)),(SID sid)]);
iknows(crypt(pk(Agent (B)),Nonce (NB)))

step rule_12:
State (rA,[Agent (A),Step 1,Agent (B),inv(pk(Agent (A))),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),(SID sid)]);
iknows(pk(Agent (A)));
iknows(Nonce (NA));
iknows(Nonce (NB));
iknows(Agent (B))

=>
request(Agent (A),Agent (B),Purpose (pABNB),Nonce (NB),(SID sid));
State (rA,[Agent (A),Step 2,Agent (B),inv(pk(Agent (A))),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),Nonce (NB),crypt(pk(Agent (A)),pair(Nonce (NA),pair(Nonce (NB),Agent (B)))),crypt(pk(Agent (B)),Nonce (NB)),(SID sid)]);
iknows(crypt(pk(Agent (B)),Nonce (NB)))

step rule_13:
State (rA,[Agent (A),Step 1,Agent (B),inv(pk(Agent (A))),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),(SID sid)]);
iknows(Agent (A));
iknows(Nonce (NA));
iknows(Nonce (NB));
iknows(Agent (B))

=>
request(Agent (A),Agent (B),Purpose (pABNB),Nonce (NB),(SID sid));
State (rA,[Agent (A),Step 2,Agent (B),inv(pk(Agent (A))),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),Nonce (NB),crypt(pk(Agent (A)),pair(Nonce (NA),pair(Nonce (NB),Agent (B)))),crypt(pk(Agent (B)),Nonce (NB)),(SID sid)]);
iknows(crypt(pk(Agent (B)),Nonce (NB)))

step rule_14:
State (rB,[Agent (B),Step 1,inv(pk(Agent (B))),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),Nonce (NB),crypt(pk(Agent (A)),pair(Nonce (NA),pair(Nonce (NB),Agent (B)))),(SID sid)]);
iknows(crypt(pk(Agent (B)),Nonce (NB)))

=>
request(Agent (B),Agent (A),Purpose (pBANA),Nonce (NA),(SID sid));
State (rB,[Agent (B),Step 2,inv(pk(Agent (B))),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),Nonce (NB),crypt(pk(Agent (A)),pair(Nonce (NA),pair(Nonce (NB),Agent (B)))),crypt(pk(Agent (B)),Nonce (NB)),(SID sid)])

step rule_15:
State (rB,[Agent (B),Step 1,inv(pk(Agent (B))),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),Nonce (NB),crypt(pk(Agent (A)),pair(Nonce (NA),pair(Nonce (NB),Agent (B)))),(SID sid)]);
iknows(pk(Agent (B)));
iknows(Nonce (NB))

=>
request(Agent (B),Agent (A),Purpose (pBANA),Nonce (NA),(SID sid));
State (rB,[Agent (B),Step 2,inv(pk(Agent (B))),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),Nonce (NB),crypt(pk(Agent (A)),pair(Nonce (NA),pair(Nonce (NB),Agent (B)))),crypt(pk(Agent (B)),Nonce (NB)),(SID sid)])

step rule_16:
State (rB,[Agent (B),Step 1,inv(pk(Agent (B))),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),Nonce (NB),crypt(pk(Agent (A)),pair(Nonce (NA),pair(Nonce (NB),Agent (B)))),(SID sid)]);
iknows(Agent (B));
iknows(Nonce (NB))

=>
request(Agent (B),Agent (A),Purpose (pBANA),Nonce (NA),(SID sid));
State (rB,[Agent (B),Step 2,inv(pk(Agent (B))),Agent (A),Nonce (NA),crypt(pk(Agent (B)),pair(Nonce (NA),Agent (A))),Nonce (NB),crypt(pk(Agent (A)),pair(Nonce (NA),pair(Nonce (NB),Agent (B)))),crypt(pk(Agent (B)),Nonce (NB)),(SID sid)])


section initial state:
init_0: iknows(Nonce (ni));
init_1: iknows(Agent (dishonest i));
init_2: State (rA,[Agent (honest a),Step 0,Agent (dishonest i),inv(pk(Agent (honest a))),(SID sid)]);
init_3: State (rA,[Agent (honest a),Step 0,Agent (honest a),inv(pk(Agent (honest a))),(SID sid)]);
init_4: iknows(Step 0);
init_5: iknows(inv(pk(Agent (dishonest i))));
init_6: iknows((SID sid));
init_7: iknows(Agent (honest a));
init_8: State (rB,[Agent (honest a),Step 0,inv(pk(Agent (honest a))),(SID sid)]);

section fixedpoint:
fp_0: secret(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i));
fp_1: witness(Agent (honest a),Agent (dishonest i),Purpose (pBANA),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))));
fp_2: State (rA,[Agent (honest a),Step 1,Agent (dishonest i),inv(pk(Agent (honest a))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),(SID sid)]);
fp_3: secret(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a));
fp_4: witness(Agent (honest a),Agent (honest a),Purpose (pBANA),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))));
fp_5: State (rA,[Agent (honest a),Step 1,Agent (honest a),inv(pk(Agent (honest a))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))),(SID sid)]);
fp_6: secret(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i));
fp_7: witness(Agent (honest a),Agent (dishonest i),Purpose (pABNB),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))));
fp_8: State (rB,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),Agent (dishonest i),Nonce (ni),crypt(pk(Agent (honest a)),pair(Nonce (ni),Agent (dishonest i))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(Nonce (ni),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))),(SID sid)]);
fp_9: secret(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a));
fp_10: witness(Agent (honest a),Agent (honest a),Purpose (pABNB),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))));
fp_11: State (rB,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),Agent (honest a),Nonce (ni),crypt(pk(Agent (honest a)),pair(Nonce (ni),Agent (honest a))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (ni),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),(SID sid)]);
fp_12: iknows(crypt(pk(Agent (honest a)),pair(Nonce (ni),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))));
fp_13: iknows(crypt(pk(Agent (dishonest i)),pair(Nonce (ni),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))));
fp_14: iknows(crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))));
fp_15: iknows(crypt(pk(Agent (dishonest i)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))));
fp_16: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_17: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_18: iknows(pair(Nonce (ni),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))));
fp_19: State (rB,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),(SID sid)]);
fp_20: iknows(crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))));
fp_21: iknows(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))));
fp_22: iknows(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))));
fp_23: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_24: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_25: iknows(pair(Nonce (ni),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))));
fp_26: State (rB,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))),(SID sid)]);
fp_27: State (rB,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),(SID sid)]);
fp_28: State (rB,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))),(SID sid)]);
fp_29: State (rB,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),(SID sid)]);
fp_30: request(Agent (honest a),Agent (honest a),Purpose (pABNB),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),(SID sid));
fp_31: State (rA,[Agent (honest a),Step 2,Agent (honest a),inv(pk(Agent (honest a))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),(SID sid)]);
fp_32: request(Agent (honest a),Agent (dishonest i),Purpose (pABNB),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_33: State (rA,[Agent (honest a),Step 2,Agent (dishonest i),inv(pk(Agent (honest a))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_34: request(Agent (honest a),Agent (dishonest i),Purpose (pABNB),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_35: State (rA,[Agent (honest a),Step 2,Agent (dishonest i),inv(pk(Agent (honest a))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_36: request(Agent (honest a),Agent (dishonest i),Purpose (pABNB),Nonce (ni),(SID sid));
fp_37: State (rA,[Agent (honest a),Step 2,Agent (dishonest i),inv(pk(Agent (honest a))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),Nonce (ni),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (ni),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),Nonce (ni)),(SID sid)]);
fp_38: request(Agent (honest a),Agent (dishonest i),Purpose (pBANA),Nonce (ni),(SID sid));
fp_39: State (rB,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),Agent (dishonest i),Nonce (ni),crypt(pk(Agent (honest a)),pair(Nonce (ni),Agent (dishonest i))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(Nonce (ni),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_40: iknows(crypt(pk(Agent (dishonest i)),Nonce (ni)));
fp_41: iknows(crypt(pk(Agent (dishonest i)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))));
fp_42: iknows(crypt(pk(Agent (dishonest i)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))));
fp_43: iknows(crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))));
fp_44: iknows(crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))));
fp_45: iknows(crypt(pk(Agent (dishonest i)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))));
fp_46: iknows(crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))));
fp_47: iknows(crypt(pk(Agent (dishonest i)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))));
fp_48: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_49: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_50: iknows(pair(Nonce (ni),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))));
fp_51: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))));
fp_52: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))));
fp_53: request(Agent (honest a),Agent (honest a),Purpose (pBANA),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_54: State (rB,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),(SID sid)]);
fp_55: request(Agent (honest a),Agent (honest a),Purpose (pBANA),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_56: State (rB,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),Agent (honest a),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),(SID sid)]);
fp_57: request(Agent (honest a),Agent (honest a),Purpose (pBANA),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),(SID sid));
fp_58: State (rB,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Agent (honest a))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),(SID sid)]);
fp_59: request(Agent (honest a),Agent (honest a),Purpose (pBANA),Nonce (ni),(SID sid));
fp_60: State (rB,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),Agent (honest a),Nonce (ni),crypt(pk(Agent (honest a)),pair(Nonce (ni),Agent (honest a))),Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),crypt(pk(Agent (honest a)),pair(Nonce (ni),pair(Nonce (absNB(pair(Agent (honest a),Agent (honest a)))),Agent (honest a)))),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (honest a))))),(SID sid)]);
fp_61: request(Agent (honest a),Agent (dishonest i),Purpose (pBANA),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_62: State (rB,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_63: request(Agent (honest a),Agent (dishonest i),Purpose (pBANA),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_64: State (rB,[Agent (honest a),Step 2,inv(pk(Agent (honest a))),Agent (dishonest i),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (honest a)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (dishonest i))),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),crypt(pk(Agent (dishonest i)),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)))),crypt(pk(Agent (honest a)),Nonce (absNB(pair(Agent (honest a),Agent (dishonest i))))),(SID sid)]);
fp_65: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_66: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a)));
fp_67: iknows(pair(Nonce (ni),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))));
fp_68: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))));
fp_69: iknows(pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),pair(Nonce (absNB(pair(Agent (honest a),Agent (dishonest i)))),Agent (honest a))));

section abstraction:
NA->Nonce (absNA(pair(A,B)));
NB->Nonce (absNB(pair(B,A)))

