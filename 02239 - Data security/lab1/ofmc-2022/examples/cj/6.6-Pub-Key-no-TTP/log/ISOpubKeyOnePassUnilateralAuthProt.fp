Backend: Open-Source Fixedpoint Model-Checker version 2020 
Protocol: ISO_onepass_pk
Types:
[(Purpose,["purposeText1"]),(Agent False False,["A","B","s"]),(Number,["NA","Text1"]),(Function,["pk"])]
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
State (rA,[Agent (A),Step 0,inv(pk(Agent (A))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),Agent (B),(SID sid)])

=>
witness(Agent (A),Agent (B),Purpose (pBAText1),Nonce (absText1(pair(Agent (A),Agent (B)))));
State (rA,[Agent (A),Step 1,inv(pk(Agent (A))),pk(Agent (A)),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),Agent (B),Nonce (absNA(pair(Agent (A),Agent (B)))),Nonce (absText1(pair(Agent (A),Agent (B)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(inv(pk(Agent (A))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),pair(Agent (B),Nonce (absText1(pair(Agent (A),Agent (B)))))))),(SID sid)]);
iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(inv(pk(Agent (A))),pair(Nonce (absNA(pair(Agent (A),Agent (B)))),pair(Agent (B),Nonce (absText1(pair(Agent (A),Agent (B)))))))))

step rule_8:
State (rB,[Agent (B),Step 0,pk(Agent (honest a)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(crypt(inv(pk(Agent (A))),pair(Nonce (NA),pair(Agent (B),Nonce (Text1)))))

=>
request(Agent (B),Agent (A),Purpose (pBAText1),Nonce (Text1),(SID sid));
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Nonce (Text1),Nonce (NA),crypt(inv(pk(Agent (A))),pair(Nonce (NA),pair(Agent (B),Nonce (Text1)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(inv(pk(Agent (A))),pair(Nonce (NA),pair(Agent (B),Nonce (Text1))))),(SID sid)])

step rule_9:
State (rB,[Agent (B),Step 0,pk(Agent (honest a)),(SID sid)]);
iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))));
iknows(inv(pk(Agent (A))));
iknows(Nonce (NA));
iknows(Agent (B));
iknows(Nonce (Text1))

=>
request(Agent (B),Agent (A),Purpose (pBAText1),Nonce (Text1),(SID sid));
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Nonce (Text1),Nonce (NA),crypt(inv(pk(Agent (A))),pair(Nonce (NA),pair(Agent (B),Nonce (Text1)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(inv(pk(Agent (A))),pair(Nonce (NA),pair(Agent (B),Nonce (Text1))))),(SID sid)])

step rule_10:
State (rB,[Agent (B),Step 0,pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(crypt(inv(pk(Agent (A))),pair(Nonce (NA),pair(Agent (B),Nonce (Text1)))))

=>
request(Agent (B),Agent (A),Purpose (pBAText1),Nonce (Text1),(SID sid));
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Nonce (Text1),Nonce (NA),crypt(inv(pk(Agent (A))),pair(Nonce (NA),pair(Agent (B),Nonce (Text1)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(inv(pk(Agent (A))),pair(Nonce (NA),pair(Agent (B),Nonce (Text1))))),(SID sid)])

step rule_11:
State (rB,[Agent (B),Step 0,pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(pk(Agent (A)));
iknows(inv(pk(Agent (A))));
iknows(Nonce (NA));
iknows(Agent (B));
iknows(Nonce (Text1))

=>
request(Agent (B),Agent (A),Purpose (pBAText1),Nonce (Text1),(SID sid));
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Nonce (Text1),Nonce (NA),crypt(inv(pk(Agent (A))),pair(Nonce (NA),pair(Agent (B),Nonce (Text1)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(inv(pk(Agent (A))),pair(Nonce (NA),pair(Agent (B),Nonce (Text1))))),(SID sid)])

step rule_12:
State (rB,[Agent (B),Step 0,pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(crypt(inv(pk(Agent (A))),pair(Nonce (NA),pair(Agent (B),Nonce (Text1)))))

=>
request(Agent (B),Agent (A),Purpose (pBAText1),Nonce (Text1),(SID sid));
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Nonce (Text1),Nonce (NA),crypt(inv(pk(Agent (A))),pair(Nonce (NA),pair(Agent (B),Nonce (Text1)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(inv(pk(Agent (A))),pair(Nonce (NA),pair(Agent (B),Nonce (Text1))))),(SID sid)])

step rule_13:
State (rB,[Agent (B),Step 0,pk(Agent (honest a)),(SID sid)]);
iknows(inv(pk(Agent (honest a))));
iknows(Agent (A));
iknows(inv(pk(Agent (A))));
iknows(Nonce (NA));
iknows(Agent (B));
iknows(Nonce (Text1))

=>
request(Agent (B),Agent (A),Purpose (pBAText1),Nonce (Text1),(SID sid));
State (rB,[Agent (B),Step 1,pk(Agent (honest a)),Nonce (Text1),Nonce (NA),crypt(inv(pk(Agent (A))),pair(Nonce (NA),pair(Agent (B),Nonce (Text1)))),pk(Agent (A)),Agent (A),crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (A),pk(Agent (A)))),crypt(inv(pk(Agent (A))),pair(Nonce (NA),pair(Agent (B),Nonce (Text1))))),(SID sid)])


section initial state:
init_0: iknows(Nonce (ni));
init_1: iknows(Agent (dishonest i));
init_2: State (rA,[Agent (honest a),Step 0,inv(pk(Agent (honest a))),pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),Agent (dishonest i),(SID sid)]);
init_3: State (rA,[Agent (honest a),Step 0,inv(pk(Agent (honest a))),pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),Agent (honest a),(SID sid)]);
init_4: iknows(Step 0);
init_5: iknows(inv(pk(Agent (dishonest i))));
init_6: iknows(pk(Agent (dishonest i)));
init_7: iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))));
init_8: iknows((SID sid));
init_9: iknows(Agent (honest a));
init_10: State (rB,[Agent (honest a),Step 0,pk(Agent (honest a)),(SID sid)]);
init_11: iknows(pk(Agent (honest a)));

section fixedpoint:
fp_0: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))))))));
fp_1: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_2: iknows(pair(Agent (dishonest i),pk(Agent (dishonest i))));
fp_3: witness(Agent (honest a),Agent (dishonest i),Purpose (pBAText1),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))));
fp_4: State (rA,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),Agent (dishonest i),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))))))),(SID sid)]);
fp_5: witness(Agent (honest a),Agent (honest a),Purpose (pBAText1),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))));
fp_6: State (rA,[Agent (honest a),Step 1,inv(pk(Agent (honest a))),pk(Agent (honest a)),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))))))),(SID sid)]);
fp_7: request(Agent (honest a),Agent (dishonest i),Purpose (pBAText1),Nonce (ni),(SID sid));
fp_8: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (ni),Nonce (ni),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (ni),pair(Agent (honest a),Nonce (ni)))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (ni),pair(Agent (honest a),Nonce (ni))))),(SID sid)]);
fp_9: iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a))))))));
fp_10: iknows(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))));
fp_11: iknows(crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i))))))));
fp_12: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))))))));
fp_13: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_14: iknows(pair(Agent (dishonest i),pk(Agent (dishonest i))));
fp_15: iknows(pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i))))));
fp_16: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))))));
fp_17: iknows(pair(Agent (honest a),pk(Agent (honest a))));
fp_18: iknows(pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a))))));
fp_19: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))))));
fp_20: request(Agent (honest a),Agent (honest a),Purpose (pBAText1),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),(SID sid));
fp_21: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a))))))),pk(Agent (honest a)),Agent (honest a),crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))))))),(SID sid)]);
fp_22: iknows(Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))));
fp_23: iknows(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))));
fp_24: iknows(Nonce (absText1(pair(Agent (honest a),Agent (honest a)))));
fp_25: iknows(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))));
fp_26: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))))))));
fp_27: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_28: iknows(pair(Agent (dishonest i),pk(Agent (dishonest i))));
fp_29: iknows(pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i))))));
fp_30: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))))));
fp_31: iknows(pair(Agent (honest a),pk(Agent (honest a))));
fp_32: iknows(pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a))))));
fp_33: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))))));
fp_34: request(Agent (honest a),Agent (dishonest i),Purpose (pBAText1),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_35: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))))))),(SID sid)]);
fp_36: request(Agent (honest a),Agent (dishonest i),Purpose (pBAText1),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),(SID sid));
fp_37: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))))),(SID sid)]);
fp_38: request(Agent (honest a),Agent (dishonest i),Purpose (pBAText1),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),(SID sid));
fp_39: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))))))),(SID sid)]);
fp_40: request(Agent (honest a),Agent (dishonest i),Purpose (pBAText1),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),(SID sid));
fp_41: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))))),(SID sid)]);
fp_42: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (ni),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (ni)))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (ni))))),(SID sid)]);
fp_43: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))))))),(SID sid)]);
fp_44: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))))),(SID sid)]);
fp_45: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))))))),(SID sid)]);
fp_46: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))))),(SID sid)]);
fp_47: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (ni),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (ni)))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (honest a),Nonce (ni))))),(SID sid)]);
fp_48: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))))))),(SID sid)]);
fp_49: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))))),(SID sid)]);
fp_50: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))))))),(SID sid)]);
fp_51: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))))),(SID sid)]);
fp_52: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (ni),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (ni)))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (ni))))),(SID sid)]);
fp_53: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))))))),(SID sid)]);
fp_54: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))))),(SID sid)]);
fp_55: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))))))),(SID sid)]);
fp_56: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))))),(SID sid)]);
fp_57: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (ni),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (ni)))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (ni))))),(SID sid)]);
fp_58: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))),Nonce (ni),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))))))),(SID sid)]);
fp_59: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),Nonce (ni),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))))))),(SID sid)]);
fp_60: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))),Nonce (ni),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))))))),(SID sid)]);
fp_61: State (rB,[Agent (honest a),Step 1,pk(Agent (honest a)),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),Nonce (ni),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a))))))),pk(Agent (dishonest i)),Agent (dishonest i),crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),pair(crypt(inv(pk(Agent (honest a))),pair(Agent (dishonest i),pk(Agent (dishonest i)))),crypt(inv(pk(Agent (dishonest i))),pair(Nonce (ni),pair(Agent (honest a),Nonce (absNA(pair(Agent (honest a),Agent (honest a)))))))),(SID sid)]);
fp_62: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))))))));
fp_63: iknows(pair(crypt(inv(pk(Agent (honest a))),pair(Agent (honest a),pk(Agent (honest a)))),crypt(inv(pk(Agent (honest a))),pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))))))));
fp_64: iknows(pair(Agent (dishonest i),pk(Agent (dishonest i))));
fp_65: iknows(pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i))))));
fp_66: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (dishonest i)))),pair(Agent (dishonest i),Nonce (absText1(pair(Agent (honest a),Agent (dishonest i)))))));
fp_67: iknows(pair(Agent (honest a),pk(Agent (honest a))));
fp_68: iknows(pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a))))));
fp_69: iknows(pair(Nonce (absNA(pair(Agent (honest a),Agent (honest a)))),pair(Agent (honest a),Nonce (absText1(pair(Agent (honest a),Agent (honest a)))))));

section abstraction:
NA->Nonce (absNA(pair(A,B)));
Text1->Nonce (absText1(pair(A,B)))

