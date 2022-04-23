function [W,W0,Q]=Yi_fan(data,method)
%% author information
% Zhuozhen Yu, Zhihui Lai
% 2022 Jan. ALL RIGHTS PRESEVERED. 

%% info:
% ---input---
% X := training samples: (d x N)
% method := (string) YiFan_v1 or YiFan_v2
% global : 
% para := parameters list 
% para.alpha;
% para.beta(V)
% W := projection matrix (a cell for each view)
% Q := reconstruction matrix (a cell for each view)

%% initial setting
global pri_dimen V dimen para pen
Q = cell(1,V);
W = cell(1,V);
D = cell(1,V);
W = cell(1,V);
for i = 1 : V
    W{i} = rand(dimen,pri_dimen);
    % intial Q to be an orth-martrix
    Q{i} = rand(pri_dimen, pri_dimen);
    Q{i} = orth(Q{i});
    Q{i} = Q{i}(:,(1:dimen));
end
W0 = rand(dimen,pri_dimen);
F0 = zeros(dimen,pri_dimen);
Phi = zeros(dimen,pri_dimen);
W0_last_one = zeros(dimen,pri_dimen);

beta = para.beta;
alpha = para.alpha;
rho = para.ro;
mu = para.mu;
mu_max = para.mu_max;
iter = para.iter;
X = data.X;
XXT = X*X';
X_view_bar = data.X_view_bar;
for i = 1:V
    Xi_bar_2{i} = X_view_bar{i}*X_view_bar{i}';
    Dw{i} = updateG(W{i}* X_view_bar{i}) ;
end
T = 1;
%% Iterative method
while 1
    % W0-subproblem
    % update F0
    A = 2*V*X*X'+mu*eye(pri_dimen);
    B = zeros(dimen,pri_dimen);
    for v = 1 : V
        C = Q{i}'-W{i};
        B = C + mu*W0 + Phi;
    end
%     F0 = B * inv(A) ;
    F0 = B/A;
    
    % update W0: exploit SVT algorithm
    [U1,S1,V1] = svt(F0 + Phi / mu,'lambda',alpha/mu);
%     [U1,S1,V1] = svd(F0 + Phi / mu);
%     diag(S1)'
    
    W0 =U1*S1*V1';
    
    if(size(W0,1)==0)
        W0 = zeros(size(W{1}));
    end
    Phi = Phi + mu *(F0-W0);
    mu = min(rho*mu, mu_max);
    
    for view = 1 : V
       % update Wi
       Z = (W0-Q{i}');
       if method == "YiFan_v1"
       for row = 1 : dimen 
           %w_view_row = Z(row,:)*XXT*inv(XXT + beta(view)*Xi_bar_2{view});
           w_view_row = Z(row,:)*XXT/(XXT + beta(view)*Dw{view}(row,row)*Xi_bar_2{view});
           
           W{view}(row,:) =  w_view_row;
       end
       elseif method == "YiFan_v2"
       % V2:= 视为Sylvester
       A = inv(beta(view)*Dw{view});
       B = (Xi_bar_2{view}*Xi_bar_2{view}')/(XXT);
       C = A * Z;
       W{view} = sylvester(A,B,C);
       end
       % update Dw
       Dw{view} = updateG(W{view}* X_view_bar{view}) ;
       
       % update Qi
       % OMP-version
%        Q{view}  = OMP(X',((W0+W{view})*X)' , size(Q{view},2))'; 
       % SVD-version
       [UU,~,VV] = svd(XXT*(W0+W{view})','econ');
       Q{view} = UU * VV';
    end
    % if converge- times converage
    % if (T >= iter) break;end;
    % T = T + 1;
    if (max(norm(abs(W0 - W0_last_one)))<= 1e-3 || T > iter) break;end;
    W0_last_one = W0;
    
    T = T + 1 ;
    % v3
    % update beta_i
    
end
%%

