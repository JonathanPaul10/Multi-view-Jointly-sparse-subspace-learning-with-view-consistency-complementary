function return_value = config(i,super_test,best)

global V para tr dimen pri_dimen dimen_array Times X_bar w

para.lambda = 1;
para.gama = 1;
para.ro = 20;
para.mu_max = 1e5;
para.r = 200;
para.mu = 1.05 ;
para.alpha = 1e2;
para.X_bar = X_bar;
para.iter = 10;

%调参列表
tr1 = 2;
tr2 = 4;
tr_array = (tr1:tr2);%
lambda_array = [1e-3, 1e-2, 1e-1, 1, 10, 100];
gama_array = [1e-3, 1e-2, 1e-1, 1, 10, 100];
dimen_bias = [-3, -2, -1, 0, 1, 2, 3];
para_bias = [0.25 0.5 0.75 1 2.5 5 7.5];

para.beta = ones(1,V);

if nargin==2

    if super_test == "tr"
        tr = tr_array(i);
    elseif super_test == "dimen"
        dimen = dimen_array(i);
        Times = size(dimen_array,2);
        return_value = dimen;
    elseif super_test == "gama"
        para.gama = gama_array(i);
        return_value = para.gama;
    elseif super_test == "alpha"
        para.alpha = gama_array(i);
        return_value = para.alpha;
    elseif super_test == "beita"
        para.beita = gama_array(i);
        return_value = para.beita;
    else
        %报错
        error('没有这个选项');
        
    end
    
elseif nargin==3
    if super_test == "dimen"
        dimen_wei_tiao = (best-3:1:min(best+3,pri_dimen-1));
        dimen = dimen_wei_tiao(i);
        return_value = dimen;
    elseif super_test == "gama"
        para.gama = best * para_bias(i);
        return_value = para.gama;
    elseif super_test == "alpha"
        para.alpha = best * para_bias(i);
        return_value = para.alpha;
    elseif super_test == "beita"
        para.beita = best * para_bias(i);
        return_value = para.beita;
    else
        error('没有这个选项');
    end
    
end
        
    