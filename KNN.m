function accurate=KNN(X_train,X_test,Label_train,Label_test,num_view)
% KNN(view_train,view_test,Label_train,Label_test,num_view,test_total);
% Label_train需为字符串
% Label_test需为数字
train_data=[];
test_data=[];
% X_train=view_train;
% X_test=view;
% Label_train=Label_view;
% Label_test=Label_view_num;
for i=1:num_view
    train_data=[train_data X_train{i}];
    test_data=[test_data X_test{i}];
end
labeltr = Label_train;
labelte = Label_test;
train_data=train_data';
test_data=test_data';
class = ClassificationKNN.fit(train_data,labeltr','NumNeighbors',3);
test_result = class.predict(test_data);
accr=0;
test_total = size(test_data,1);
a = (labelte==test_result');
accr = sum(a);
accurate=accr/(test_total);