function [tra]=Comtra(Xtrain,P,F,D,gamma)
 V=size(Xtrain,2);%视觉个数
 %[N,M]=size(Xtrain{1});%点个数
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 L=0;tF=0;
 for i=1:V
     for j=1:V
         l=trace((Xtrain{i}-Xtrain{j}*P{j}*F{i})'*D{i,j}*(Xtrain{i}-Xtrain{j}*P{j}*F{i}));
         L=L+l;
     end
     f=trace(F{i}'*F{i});
     tF=tF+f;
 end
 tra=L+gamma*tF;
     
         