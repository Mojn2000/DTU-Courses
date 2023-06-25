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

Theory Exponentiation:
  Signature:
    inve/1, 
    exp/2
  Cancellation:
    exp(exp(X1,X2),inve(X2)) = X1
    inve(inve(X1)) = X1
  Topdec:
  % exp(exp(Z1,Z2),T2) = exp(exp(Z1,T2),Z2)
    topdec(exp,exp(T1,T2))=
      [T1,T2]
      if T1==exp(Z1,Z2){
      [exp(Z1,T2),Z2]}
  Analysis:
    decana(inve(X1))= []->[X1]
    decana(exp(X1,X2))= [X2]->[X1]

Theory DiffieHellman:
  % A theory taylored towards Diffie-Hellman,
  % distinguishing the exponentiation for the half-key (kap)
  % and the exponentiation for the full-key (kep)
  Signature:
    kap/2, kep/2
  Topdec:
  % kep(kap(G,Z1),T2) = kep(kap(G,T2),Z1)
    topdec(kap,kap(T1,T2))=
      [T1,T2]
    topdec(kep,kep(T1,T2))=
      [T1,T2]
      if T1==kap(G,Z1){
      [kap(G,T2),Z1]}

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
  % Commitment schemes, where commit1 represents
  % the binding part and commit2 the opening part.
  % Note that we have to declare this as binary operators 
  % as these operators should be intruder-accesible.
  Signature:
    commit1/2,commit2/2
  Cancellation:
    pair(commit1(M1,M2),commit2(M1,M2)) = pair(M1,M2)
  Analysis:
    decana(commit1(M1,M2))=[commit2(M1,M2)]->[M1,M2]


Theory CommitUnary:
  Signature:
    bind/1,open/1,commitment/2
  Cancellation:
    commitment(bind(M),open(M))=M
  Analysis:
    decana(bind(M)) = [open(M)] -> [M]

Theory DiffieHellmanImproved:
  % A theory taylored towards Diffie-Hellman,
  % distinguishing the exponentiation for the half-key (kap)
  % and the exponentiation for the full-key (kep)
  Signature:
    halfkey/1, fullkey/2
  Topdec:
  % fullkey(halfkey(X),Y) = fullkey(halfkey(Y),X)
    topdec(halfkey,halfkey(X))=
      [X]
    topdec(fullkey,fullkey(GX,Y))=
      [GX,Y]
      if GX==halfkey(X){
      [halfkey(Y),X]}
