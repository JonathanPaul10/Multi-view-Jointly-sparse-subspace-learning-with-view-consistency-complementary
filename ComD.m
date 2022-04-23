function [D]=ComD(Xtrain,P,F)
 V=size(Xtrain,2);
 [N,M]=size(Xtrain{1});
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 for i=1:V
     for j=1:V
         d=zeros(N,N);
         for z=1:N
             d(z,z)=1/(2*norm(Xtrain{i}(z,:)-Xtrain{j}(z,:)*P{j}*F{i}));
         end
         D{i,j}=d;
     end
 end
         