function config(i,super_test,best)

global V para tr dimen pri_dimen dimen_array Times X_bar

para.lambda = 1;
para.gama = 1;
para.ro = 20;
para.mu_max = 1e5;
para.r = 200;
para.mu = 1.05 ;
para.alpha = 1e-2;
para.X_bar = X_bar;
para.iter = 2;
dimen = 60;


%调参列表
tr1 = 2;
tr2 = 4;
tr_array = (tr1:tr2);%
dimen_array = (25:5:pri_dimen-1);
lambda_array = [1e-3, 1e-2, 1e-1, 1, 10, 100];
gama_array = [1e-3, 1e-2, 1e-1, 1, 10, 100];
dimen_bias = [-3, -2, -1, 0, 1, 2, 3];
para_bias = [0.25 0.5 0.75 1 2.5 5 7.5];

para.beta = gama_array;

if nargin==2

    if super_test == "tr"
        tr = tr_array(i);
    elseif super_test == "dimen"
        dimen = dimen_array(i);
        Times = size(dimen_array,2);
    elseif super_test == "lambda"
        para.lambda  = lambda_array(i);
    elseif super_test == "gama"
        para.gama = gama_array(i);
    end
    
elseif nargin==3
    if super_test == "dimen"
        dimen = best + dimen_bias(i);
    elseif super_test == "lambda"
        para.lambda = best * para_bias(i);
    elseif super_test == "gama"
        para.gama = best * para_bias(i);
    end
end
        
        
    