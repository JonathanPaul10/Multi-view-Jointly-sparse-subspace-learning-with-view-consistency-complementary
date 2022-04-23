function [Q,tra]=RCRMvFE(Xtrain,gamma)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Xtrain:Training samples(Cell array); Xtrain{i}:represents the sample matrix from view-i;
%gamma: Parameter
%T: Number of Iteration,T=10;
%P:Projection matrix
%tra: Objective function value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global dimen 
V=size(Xtrain,2);%Number of view
for i = 1 : V
    Xtrain{i} = Xtrain{i}';
end
N=size(Xtrain{1},1);%Number of sample
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Initialize Dij
for i=1:V
    for j=1:V
        D{1}{i,j}=eye(N);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T=10;
for i=1:T
    % Update P
    [P{i}]=ComP(Xtrain,D{i},gamma);
    % Update F
    [F{i}]=ComF(Xtrain,D{i},P{i},gamma);
    % Update D
    [D{i+1}]=ComD(Xtrain,P{i},F{i});
    %Compute tra
    [tra(i)]=Comtra(Xtrain,P{i},F{i},D{i+1},gamma);
end
P1=P{T};    
for v = 1 : V
    A = P1{v};
    Q{v} =A(:,1:dimen);
end
    
    
    
    
    




    
     
 