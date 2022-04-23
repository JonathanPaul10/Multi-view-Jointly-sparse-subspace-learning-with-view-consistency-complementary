function [F]=ComF(Xtrain,D,Q,gamma)
 V=size(Xtrain,2);
 [N,M]=size(Xtrain{1});
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 H=zeros(M,M);
 for i=1:V
     H=zeros(M,M);I=eye(M);O=zeros(M,M);
     for j=1:V
         H=H+Q{j}'*Xtrain{j}'*D{i,j}*Xtrain{j}*Q{j};
         O=O+Q{j}'*Xtrain{j}'*D{i,j}*Xtrain{i};
     end
     F{i}=(I/(H+gamma*I))*O;
 end
         
     