%LDA
function result_dimension = MvRR_exe(super_test,best)
global  dataset dataname tr Times dimen_array V para method_str
%����ѵ������Ҫ���ĵĵ�

if nargin == 1
    outer_loop_setting(super_test);
elseif nargin == 2
    outer_loop_setting(super_test,best);
end

test_loop_Times = [];
result = [];
%���ò����б�
%˳�� a������ά�ȡ�ѵ��������
fid=fopen(strcat('./report/',dataname,'_',method_str,'.txt'),'a+');
% ��������
for i  = 1: Times
    if nargin == 1
        a = config(i,super_test);
        test_loop_Times = [test_loop_Times a];
    elseif nargin == 2
        a = config(i,super_test,best);
        test_loop_Times = [test_loop_Times a];
    end
    fprintf(fid,'%17s %9s %9s   tr = %d\r\n','dimen_array','���','��׼��',tr);
    for j=1:10
        [data_processed,test_all_2D,label,Y_2D,test_Y_2D] = acheive_face_1D(dataset);
        % [P,Q,alpha] = MvRR(train_all ,label);
        tic
%         [~, W] = MULPP(data_processed.X_view_bar,V);
        if method_str == "YiFan_v1" || method_str == "YiFan_v2"
            [W,W0,Q] = Yi_fan(data_processed,method_str);
        elseif  method_str == "MLDA" || method_str == "MULDA" 
            W = MULDA(data_processed.X_view_bar,label,1,para.alpha,tr, method_str);
            W0 = zeros(size(W{1}));
        elseif method_str == "RCRMvFE"
            [W]=RCRMvFE(data_processed.X_view_bar,para.alpha);
        elseif method_str == "CRMvFE"
            [W]=CRMvFE(data_processed.X_view_bar,para.alpha);
        end
        toc
        recog_rate = test_recognition_view(W0,W,data_processed,Y_2D,test_Y_2D);
        re(j) = recog_rate;
    end %jѭ������
    result(i) = print_fid(re,fid,super_test);
end %i
[maxx, index] = max(result);
result_dimension = result;
para.max_one = test_loop_Times(index);
fprintf(fid,'�����ڵĲ���Ϊ%s\n',super_test);
fprintf(fid,'��ߵ���%.2f,����Ϊ = %11.2f\r\n',maxx, test_loop_Times(index));
fclose(fid);
