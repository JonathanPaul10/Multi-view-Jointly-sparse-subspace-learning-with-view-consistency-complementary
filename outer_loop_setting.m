function outer_loop_setting(super_test,best)

global V para tr dimen h w dimen_array Times pri_dimen


dimen_array = (5:5:pri_dimen-1);%(2:3:20);
lambda_array = [1e-3, 1e-2, 1e-1, 1, 10, 100];
gama_array = [1e-3, 1e-2, 1e-1, 1, 10, 100];

dimen_bias = [-3, -2, -1, 0, 1, 2, 3];
para_bias = [0.25 0.5 0.75 1 2.5 5 7.5];


if nargin==1

    if super_test == "tr"
        
    elseif super_test == "dimen"
        para.d = dimen;
        Times = size(dimen_array,2);
    elseif super_test == "gama"
        Times = size(gama_array,2);
    else
        Times = size(gama_array,2);
    end
    
elseif nargin==2
    if super_test == "dimen"
        Times = size(dimen_bias,2);
    elseif super_test == "lambda"
        Times = size(para_bias,2);
    elseif super_test == "gama"
        Times = size(para_bias,2);
    else
        Times = size(para_bias,2);
    end
end