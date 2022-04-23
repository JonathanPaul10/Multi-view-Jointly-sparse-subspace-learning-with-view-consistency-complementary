%LDA
function result_dimension = MvRR_exe(super_test,best)
global  dataset dataname tr Times dimen_array
%����ѵ������Ҫ���ĵĵ�

config(1,super_test);
%���ò����б�
%˳�� a������ά�ȡ�ѵ��������
fid=fopen(strcat('./report/',dataname,'.txt'),'a+');
% ��������
for i  = 1: Times
    if nargin == 1
        config(i,super_test);
    elseif nargin == 2
        config(i,super_test,best);
    end
    fprintf(fid,'%17s %9s %9s   tr = %d\r\n','dimen_array','���','��׼��',tr);
    for j=1:20
        [data_processed,test_all_2D,label,Y_2D,test_Y_2D] = acheive_face_1D(dataset);
        % [P,Q,alpha] = MvRR(train_all ,label);
        tic
        [W,W0,Q] = Yi_fan(data_processed);
        toc
        recog_rate = test_recognition(W,W0,data_processed.X,Y_2D,test_all_2D,test_Y_2D);
        re(j) = recog_rate;
    end %jѭ������
    result(i) = print_fid(re,fid,super_test);
end %i
[maxx, index] = max(result);
result_dimension = result;
fprintf(fid,'��ߵ���%.2f,ά��Ϊ = %11d\r\n',maxx, dimen_array(index));
fclose(fid);
