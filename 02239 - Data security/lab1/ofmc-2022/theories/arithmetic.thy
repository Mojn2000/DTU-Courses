%% OFMC - Algebraic Theories
%%
%% Author Sebastian Moedersheim

Theory StdAsymEnc: 
  % Standard Asymetric Encryption
  Signature:
     inv/1, 
     crypt/2
  Cancellation: 
    crypt(inv(X1),crypt(X1,X2)) = X2
    inv(inv(X1)) = X1
  Analysis:
    decana(crypt(inv(X1),X2))=[X1]->[X2]
    decana(crypt(X1,X2)) | X1/=inv(X3) =[inv(X1)]->[X2]

Theory StdSymEnc:
  % Standard Symmetric Encryption
  Signature:
    scrypt/2
  Cancellation:
    scrypt(X1,scrypt(X1,X2)) = X2
  Analysis:
    decana(scrypt(X1,X2))=[X1]->[X2] 

Theory Concatenation:
  % Concatenation/Pairing
  % This operator is associative which can be changed 
  % by simply commenting-out the entire topdec-section.
  Signature: 
    fst/1, snd/1, pair/2
  Cancellation:
    fst(pair(X1,X2)) = X1
    snd(pair(X1,X2)) = X2
  Topdec:
  % pair(pair(Z1,Z2),T2)=pair(Z1,pair(Z2,T2))
    topdec(pair,pair(T1,T2))=
      [T1,T2]
      if T1==pair(Z1,Z2){
        [Z1,pair(Z2,T2)]}
  Analysis:
    decana(pair(X1,X2))=[]->[X1,X2]

Theory Arithmetic:
  Signature:
    add/2, neg/1, zero/0,
    mult/2, minv/1, one/0,
    exp/2
  Cancellation:
    add(X,neg(X))=zero
    add(X,zero)=X
    add(add(X,Y),neg(Y))=X
    mult(X,minv(X))=one
    mult(X,one)=X
    mult(mult(X,Y),minv(Y))=X
  Topdec:
    % add is associative and commutative:
    topdec(add,add(T1,T2))=
      [T1,T2]
      [T2,T1]
      if T1==add(Z1,Z2){
        [Z1,add(Z2,T2)]
        [add(Z1,T2),Z2]
        if T2==add(Z3,Z4){
          [add(Z1,Z3),add(Z2,Z4)]}}
      if T2==add(Z1,Z2){
        [add(T1,Z1),Z2]
        [Z1,add(T1,Z2)]}
    % mult is associative and commutative:
    topdec(mult,mult(T1,T2))=
      [T1,T2]
      [T2,T1]
      if T1==mult(Z1,Z2){
        [Z1,mult(Z2,T2)]
        [mult(Z1,T2),Z2]
        if T2==mult(Z3,Z4){
          [mult(Z1,Z3),mult(Z2,Z4)]}}
      if T2==mult(Z1,Z2){
        [mult(T1,Z1),Z2]
        [Z1,mult(T1,Z2)]}
    % Distributivity: mult(X1,add(X2,X3))=add(mult(X1,X2),mult(X1,X3))
    topdec(add,mult(X1,X2))=
      if X2==add(X3,X4){
        [mult(X1,X3),mult(X1,X4)]}
%    topdec(mult,add(X1,X2))=
%      if X1==mult(X3,X4){
%        if X2==mult(X3,X5){
%          [X3,mult(X4,X5)]}}
    % Relation between exp,mult and add: 
    % exp(exp(X1,X2),X3)=exp(X1,mult(X2,X3))
    % exp(X1,sum(X2,X3))=mult(exp(X1,X2),exp(X1,X3))
    topdec(exp,exp(T1,T2))=
      [T1,T2]
      if T1==exp(Z1,Z2){
       [Z1,mult(T2,Z2)]
       [exp(Z1,T2),Z2]}
      if T2==mult(Z1,Z2){
       [exp(T1,Z1),Z2]}
    topdec(mult,exp(T1,T2))=
      if T2==sum(Z1,Z2){
      [exp(T1,Z2),exp(T1,Z2)]}
  Analysis:
    decana(add(X1,X2)) =[X1]->[X2]
    decana(mult(X1,X2))=[X1]->[X2]
    decana(exp(X1,X2)) =[X2]->[X1]
    decana(neg(X))=[]->[X]
    decana(minv(X))=[]->[X]

Theory Xor:
  % Bitwise exclusive or.
  Signature:
    e/0, 
    xor/2
  Cancellation:
    xor(xor(X1,X1),X2) = X2
    xor(X1,X1) = e
    xor(X1,e)  = X1
  Topdec:
  % xor is associative and commutative
   topdec(xor,xor(T1,T2))=
     [T1,T2]
     [T2,T1]
     if T1==xor(Z1,Z2){
       [Z1,xor(Z2,T2)]
       [xor(Z1,T2),Z2]
       if T2==xor(Z3,Z4){
         [xor(Z1,Z3),xor(Z2,Z4)]}}
     if T2==xor(Z1,Z2){
       [xor(T1,Z1),Z2]
       [Z1,xor(T1,Z2)]}
  Analysis:
    decana(xor(X1,X2))= 
      [X1]->[X2] 
      %[xor(X1,X3)]->[xor(X2,X3)]

Theory Skey:
  % Symmetric key table
  % Mind the underscore in the 'skey_', which means that this 
  % operator is not intruder-accessible. 
  Signature:
    skey_/2
  Topdec:
   % skey_(A,B) = skey_(B,A)
    topdec(skey_,skey_(A,B))=
       [A,B]
       [B,A]

Theory Commit:
  Signature:
    bind/1,open/1,commitment/2
  Cancellation:
    commitment(bind(M),open(M))=M
  Analysis:
    decana(bind(M)) = [open(M)] -> [M]
