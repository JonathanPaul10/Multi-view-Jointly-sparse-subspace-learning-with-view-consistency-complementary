function [P,Q,alpha] = MvRR(X,Y)
%% info:
% ---input---
% X := training samples
% Y := training labels 
% global : 
% para := parameters list 
% P := projection matrix (a cell for each view)
% Q := reconstruction matrix (a cell for each view)
% alpha 


%% initial process (superior parameters)
global pri_dimen V dimen para pen
Q = cell(1,V);
P = cell(1,V);
D = cell(1,V);
W = cell(1,V);
for i = 1 : V
    P{i} = rand(pri_dimen,dimen);
    Q{i} = rand(dimen, pen);
    h{i} = rand(pen,1);
end

clear i

lambda = para.lambda;
gama = para.gama;
ro = para.ro;
mu_max = para.mu_max;
r = para.r;
mu = para.mu;
alpha = para.alpha;
X_bar = para.X_bar;

iter_time = 0;

for v = 1 : V
    % construct D
    D{v} = updateG( (X{v} - X_bar) * P{v});
    % construct W
    W{v} = updateG(Q{v});
    % construct R
    vec_1 = ones(size(D{v},2),1);
    R{v} = updateG( Y{v} - X{v} * P{v} * Q{v} + vec_1 * h{v}' );
    C{v} = zeros(size(X{v},1),size(P{v},2));
    F{v} = (X{v} - X_bar) * P{v};
end


%% function content
while 1
    trace_view = zeros(1,V);
    for v = 1 :V
        vec_1 = ones(size(D{v},2),1);
        ylb =  Y{v}+ vec_1 * h{v}';
        Q{v} = alpha(v)* ( alpha(v) * P{v}' * X{v}' * R{v} * X{v} * P{v} + lambda * W{v}) \ P{v}'* X{v}' * R{v}' * ylb;
        
        % construct W
        W{v} = updateG(Q{v});
        
        % solve P
        % P{v}
        P2 = P{v};
        for iter = 1: 5
            % interative to update each other
            X_TRX = X{v}' * R{v} * X{v} + 1e-4 * eye(size( X{v}' * R{v} * X{v}));
            QQ_T = Q{v} * Q{v}' +  1e-4 * eye(size(Q{v} * Q{v}' ));
            
            item_a = X{v}' * R{v} * ylb * Q{v}';
            item_b = (X{v} - X_bar)' * (mu(v)*eye(size( D{v} )) - gama * D{v}) * (X{v} - X_bar);
            item_c = ((C{v}' - mu(v) * F{v}') * (X{v} - X_bar))';
            
            %update P1
            P1 = (X_TRX) \ ( item_a + (1 / alpha(v)) .* item_b * P2 - (1 / alpha(v)) .* item_c) / (QQ_T );
            
            item_d = X_TRX * P1 * QQ_T;
            
            %update P2
            P2 = (item_b + 1e-5*eye(size(item_b))) \ ( alpha(v) * item_d - alpha(v) * item_a + item_c);
            
            %update P{v}
            P{v} = P2;
        end
        clear P1 P2
        
        % construct D
        D{v} = updateG( (X{v} - X_bar) * P{v});
        
        F{v} = (mu(v)*(X{v} - X_bar)*P{v} - C{v}) / ( gama * W{v} + (mu(v)/2) * eye(size(W{v})) ) ;
        h{v} = (Y{v}' - Q{v}' * P{v}' * X{v}') * D{v} * vec_1 / (vec_1' * D{v} * vec_1);
        C{v} = C{v} + (F{v} - (X{v} - X_bar) * P{v});
        mu(v) = min( ro*mu(v) , mu_max );
        
        temp = Y{v} - X{v} * P{v} * Q{v} + vec_1 * h{v}';
        trace_view(v) = 1 / (trace(temp' * D{v} * temp) ^ (1/(r-1)));
    end
    
    %update alpha{v}
    sum_trace = sum(trace_view,2);
    alpha = trace_view ./ sum_trace;
    
    iter_time = iter_time + 1;
%     if (mod(iter_time ,5) == 0)
%         for v = 1:V
%             
%         end
%     end
    if (iter_time > 5), break, end
end

