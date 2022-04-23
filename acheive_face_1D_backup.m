function [data_processed,test_all_2D,label_v,Y_2D,test_Y_2D] = acheive_face_1D(face_all)

%% 参数说明
% train_all{1,V} :是一个大的元胞，是第v个视角下的数据。
% train_all_2D： V x Pri_dimen 矩阵。
% 

%%

global pri_dimen pin_v V pen tr para

train_all = cell(1,V);
label_v = cell(1,V);
add_count_tr = 1;
add_count_test = 1;



for v = 1: V
    list = randperm(pin_v(v));
    train_all{v}= zeros(pen*tr,pri_dimen);
    label_v{v} = zeros(pen * tr , pen);
    for i=1:pen
        for j=1:tr
            a = face_all{v}(:,(i-1)*pin_v(v) + list(j));
            train_all{v}((i-1)*tr+j,:) = a;
            label_v{v}((i-1)*tr+j,i) = 1;
            train_all_2D(add_count_tr , :) = a;
            Y_2D (add_count_tr) = i;
            add_count_tr = add_count_tr + 1;
        end
    end
    
    %构建测试矩阵
    for i=1:pen
        for j=tr+1:pin_v(v) 
            a = face_all{v}(:,(i-1)*pin_v(v) + list(j));
            test_all_2D (add_count_test ,: ) = a;
            test_Y_2D(add_count_test) = i;
            add_count_test = add_count_test + 1;
        end
    end
end

para.X_bar = mean (train_all_2D,1);
for v = 1 : V
    train_all{v} = (train_all{v} - para.X_bar)';
end

% 归一化

% 按需分配：
data_processed.X = mapminmax(train_all_2D',0,1);
data_processed.X_view_bar = train_all;

test_all_2D = mapminmax(test_all_2D',0,1);
test_data.test_all_2D = test_all_2D;