
function  ratio = test_recognition_view(P0,P,data_processed,Y_2D,test_Y_2D);

%����test��train����Ƿ��Ǻ�
%����������������������䷶��
global V dimen

data.view_train = data_processed.X_view_bar;
data.view_test = data_processed.test_view;
data_info.num_view = V;
data.Label_train = Y_2D;
data.Label_test = test_Y_2D;



for v = 1 : V
    W{v} = P0 + P{v};
    % W{v} = A;
end

ratio=KNNtest(W,data,data_info);
display(strcat('dr=',num2str(dimen),' ƥ���ʣ�',num2str(ratio),'%'));