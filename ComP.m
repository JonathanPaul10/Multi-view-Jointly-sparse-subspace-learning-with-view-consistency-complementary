function [P]=ComP(Xtrain,D,gamma)
 V=size(Xtrain,2);
 N=size(Xtrain{1},1);

 for i=1:V
     Dm(i)=size(Xtrain{i},2);
 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 Q=zeros(sum(Dm),sum(Dm));
 for i=1:V
     X_1=[];
     for j=1:V         
        X_1=[X_1,D{i,j}*Xtrain{j}];
     end
     l=X_1'*Xtrain{i}*Xtrain{i}'*X_1;
     Q=Q+l;
 end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L=[];d=zeros(N,N);
 for i=1:V
     for j=1:V
         d=d+D{j,i};
     end
     D1=Xtrain{i}'*d*Xtrain{i};
     L=blkdiag(L,D1);
 end
 a=size(L,1);
 I=eye(a);
 H=L+gamma*I;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 C=(I/(H))*(Q);
[W,SS1]=eig(C);
[disc_value1,index1]=sort(diag(SS1),'descend'); 
S=W(:,index1); 
S=S(:,1:Dm(1));
a=0;
for i=1:V
    s=S(a+1:a+Dm(i),:);
    P{i}=real(s);
    a=a+Dm(i);
end
 
     
     
     