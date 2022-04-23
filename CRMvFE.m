function [QQ]=CRMvFE(Xtrain,gamma)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Xtrain:Training samples(Cell array); Xtrain{i}:represents the sample matrix from view-i;
%gamma: Parameter
%P:Projection matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global dimen

V=size(Xtrain,2);%Number of views
for i = 1 : V
    Xtrain{i} = Xtrain{i}';
end
N=size(Xtrain{1},1);%Number of samples
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 for i=1:V
     Dm(i)=size(Xtrain{i},2);
 end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L=[];X=[];x_v=zeros(N,N);
for i=1:V
    D=Xtrain{i}'*Xtrain{i};
    L=blkdiag(L,D); 
    X=[X,Xtrain{i}];
    x_v=x_v+Xtrain{i}*Xtrain{i}';  
end
Q=X'*x_v*X;
I=eye(size(L,1));
H=L+gamma*I;
C=(I/(H))*(Q);
[W,SS1]=eig(C);
[disc_value1,index1]=sort(diag(SS1),'descend');  %返回按照排列的S及对应的下标
S=W(:,index1);   %特征向量按照特征值降序排列
a=0;
for i=1:V
    s=S(a+1:a+Dm(i),:);
    P{i}=real(s);
    a=a+Dm(i);
end
 
for v = 1 : V
    A = P{v};
    QQ{v} =A(:,1:dimen);
end
    