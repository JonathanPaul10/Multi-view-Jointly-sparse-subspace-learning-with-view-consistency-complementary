
function  ratio = test_recognition_v2(P,train_all_2D,Y_2D,test_all_2D,test_Y_2D)

%计算test与train编号是否吻合
%利用两个列向量相减，求其范数
global V dimen

% train_all_2D
% projection = zeros(size(P{1}));
% for v = 1 : V
%     projection = projection + alpha(v) .* P{v};
% end

projection = P;

%构建train的总矩阵
train = projection * train_all_2D ;
test = projection * test_all_2D;

test_num = size(test, 2);
tr_num = size(train,2);

num = 0;
for j = 1 : test_num
    distance = 1e120;
    aimone = 0;
    for k = 1 : tr_num
        temp = norm(train(:,k) - test(:,j));%两者相减 取欧式距离，以这个作为分类的依据
        if(distance>temp)
            aimone = k;
            distance = temp;
        end
    end
    q = test_Y_2D(j) ;
    p = Y_2D(aimone);
    if test_Y_2D(j) == Y_2D(aimone)
       num = num + 1;
    end
end
clear i point
%匹配率
ratio=100*num/test_num;
clear count
display(strcat('dr=',num2str(dimen),' 匹配率：',num2str(ratio),'%'));
end