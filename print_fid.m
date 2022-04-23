function result = print_fid(re,fid,super_test)

global tr dimen para

sum_mean = mean(re);
stdre = std(re,1);
result = sum_mean;
print_variable = 0;

if super_test == "tr"
    print_variable = strcat( 'tr=',num2str(tr) );
elseif super_test == "dimen"
    print_variable = strcat( 'dimen=',num2str(dimen) ); 
elseif super_test == "lambda"
    print_variable = strcat( 'lambda=',num2str(para.lambda) ); 
elseif super_test == "gama"
    print_variable = strcat( 'gama=',num2str(para.gama) );
elseif super_test == "alpha"
    print_variable = strcat( 'alpha=',num2str(para.alpha) );
end

fprintf(fid,'%s ==== %9.2f %9.2f\r\n',print_variable, sum_mean, stdre);