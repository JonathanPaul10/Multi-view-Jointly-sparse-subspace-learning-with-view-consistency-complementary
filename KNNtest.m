% function accurate=KNNtest(W,view_train,view_test,Label_train,Label_test,num_view,test_total)
function accurate=KNNtest(W,data,data_info)
% W=W_GMvDA_MMC;
% data=database;
% data_info=dataInfo;
view_train=data.view_train;
view_test=data.view_test;
num_view=data_info.num_view;
%test_total=data_info.test_total;
Label_train=data.Label_train;
Label_test=data.Label_test;
X_train=cell(1,num_view);%存放投影后的训练集
X_test=cell(1,num_view);%存放投影后的测试集
for i=1:num_view
     X_train{i}=W{i}'*view_train{i};
     X_test{i}=W{i}'*view_test{i};

end
accurate=KNN(X_train,X_test,Label_train,Label_test,num_view)*100;
end