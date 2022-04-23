function [obj, trans_vec] = MULPP(train_data,num_view)
%% code of MULPP given by Jun Yin
% train_data:multiview data
% new_dim:target of dimension reduction
% k:k nearest points
% it_num:number of iteration
% ef:threshold value
% t:the value for affinity
% num_view:number of views

% pca_train_data = cell(1,num_view);
% pca_test_data = cell(1,num_view);
% pca_vec = cell(1,num_view);

global pri_dimen dimen 

new_dim = dimen ;
alpha = 3;
beta = 3;
ef = 10000;
k = 3;
t = 1000;
it_num = 200;


dim = zeros(1,num_view);
for view_mark = 1:num_view
    %     [pca_train_data{view_mark},pca_test_data{view_mark},pca_vec{view_mark}] = PCA_t(train_data{view_mark},test_data{view_mark},pca_perc);
    [dim(view_mark),train_data_num] = size(train_data{view_mark});%% 计算执行PCA后每个视角数据的维数
end
% clear train_data;
% clear test_data;
% train_data = pca_train_data;
% test_data = pca_test_data;
C = tensor(zeros(dim));%协方差张量
% temp1 = 1;
for train_data_mark = 1:train_data_num   %%通过for循环计算高阶协方差张量C
    for view_mark = 1:num_view
        if view_mark == 1
            %         temp1 = tensor(temp1);
            %         temp1 = ttv(temp1,train_data{view_mark}(:,train_data_mark));
            temp1 = train_data{view_mark}(:,train_data_mark);
        elseif view_mark == 2
            temp1 = temp1*train_data{view_mark}(:,train_data_mark)';
        else
            ts = size(temp1);
            temp1 = double(temp1);
            temp1 = tensor(temp1,[ts 1]);
            temp1 = ttm(temp1,train_data{view_mark}(:,train_data_mark),view_mark);
        end
    end
    C = C + temp1;
    %     temp1 = 1;
end
% G = C;
% for view_mark = 1:view_num
%     G = ttm(G,(train_data{view_mark}*train_data{view_mark}')^-0.5,view_mark);
% end

if nargin ==9
    t = inf;
end

R = cell(num_view,num_view);  % 两两视角的协方差矩阵构成的cell
for view_mark1 = 1:(num_view-1)
    for view_mark2 = (view_mark1+1):num_view
        R{view_mark1,view_mark2} = train_data{view_mark1}*train_data{view_mark2}';
    end
end

%%%以下计算拉普拉斯项
SL = cell(1,num_view);
DD = cell(1,num_view);
for view_mark = 1:num_view
    W = zeros(train_data_num,train_data_num);
    %     L = zeros(train_data_num,train_data_num);  %%laplacian矩阵
    D = zeros(train_data_num,train_data_num);
    x = zeros(train_data_num,1);
    for train_data_mark = 1:train_data_num
        x(train_data_mark) = train_data{view_mark}(:,train_data_mark)'*train_data{view_mark}(:,train_data_mark);
    end
    dis = x*ones(1,train_data_num)+ones(train_data_num,1)*x'-2*(train_data{view_mark}'*train_data{view_mark});
    
    for train_data_mark = 1:train_data_num
        [~,index] = sort(dis(train_data_mark,:));   %  arrange the distance
        for index_mark = 2:(k+1)
            W(train_data_mark,index(index_mark)) = exp(-(dis(train_data_mark,index(index_mark))^2)/t);  %compute the W matrix
            W(index(index_mark),train_data_mark) = exp(-(dis(train_data_mark,index(index_mark))^2)/t);  %compute the W matrix
        end
    end
    for train_data_mark = 1:train_data_num
        D(train_data_mark,train_data_mark) = sum(W(train_data_mark,:));   %compute the D matrix
    end
    L = D-W;     %compute the laplacian matrix
    %     B{view_mark} = (train_data{view_mark}*train_data{view_mark}')^-0.5*train_data{view_mark}*L*train_data{view_mark}'*(train_data{view_mark}*train_data{view_mark}')^-0.5;
    SL{view_mark} = train_data{view_mark}*L*train_data{view_mark}';
    %     DD{view_mark} = train_data{view_mark}*D*train_data{view_mark}';
end

J = zeros(new_dim,it_num);
%%%以下通过迭代计算多根投影轴构成最终的投影矩阵
trans_vec = cell(1,num_view); %算法的投影矩阵,初始时为空
for trans_mark = 1:new_dim
    temp_vec = cell(1,num_view);  %% 迭代过程中每个视角产生的临时投影向量
    for view_mark = 2:num_view
        temp2 = rand(dim(view_mark),1);
        %         temp2 = randn(dim(view_mark),1);
        temp_vec{view_mark} = temp2/norm(train_data{view_mark}'*temp2);  %%使用随机向量初始化第2到m视角的临时投影向量,并对其进行归一化
    end
    for it_mark = 1:it_num                    %%执行迭代
        for view_mark1 = 1:num_view
            I = eye(dim(view_mark1)); %% 生成对应视角的单位矩阵
            %             trans_vec{view_mark1} = [];
            f = C;
            h = [];
            for view_mark2 = 1:num_view                       %%通过循环计算连续的p-mode积得到对应高阶相关项的f   对应低阶相关项的g
                if view_mark2 > view_mark1
                    h = [h R{view_mark1,view_mark2}*temp_vec{view_mark2}];
                    f = ttv(f,temp_vec{view_mark2},2);
                elseif view_mark2 < view_mark1
                    h = [h R{view_mark2,view_mark1}'*temp_vec{view_mark2}];
                    f = ttv(f,temp_vec{view_mark2},1);
                end
            end
            
            f = double(f);
            temp3 = trans_vec{view_mark1};
            St = train_data{view_mark1}*train_data{view_mark1}'; %% 某视角的总体协方差矩阵
            if isempty(temp3)
                A = SL{view_mark1}-alpha*(f*f')-beta*(h*h');%%获得被特征分解的矩阵
            else
                %               A = (I - temp3/(temp3'*temp3)*temp3')*(B{view_mark1}-alpha*(f*f'));%%获得被特征分解的矩阵
                A = (I - St*temp3/(temp3'*St*temp3)*temp3')*(SL{view_mark1}-alpha*(f*f')-beta*(h*h'));%%获得被特征分解的矩阵
            end
            [temp2_vec,temp_val] = eig(A,St);
            value = diag(temp_val);
            %             value = real(value);
            [sort_val,index2] = sort(value);
            sort_vec = temp2_vec(:,index2);
            for temp_mark = 1:dim(view_mark1)         %%获得的不相关投影轴的个数不超过该视角PCA降维后的特征数
                if abs(sort_val(temp_mark)) > 1e-10
                    temp_vec{view_mark1} = sort_vec(:,temp_mark)/norm(train_data{view_mark1}'*sort_vec(:,temp_mark));   %%选择对应最小非零特征值的特征向量作为迭代过程中的临时投影向量(即本次迭代获得的投影向量)
                    %                    temp_vec{view_mark1} = sort_vec(:,temp_mark);
                    %                    temp_vec{view_mark1} = sort_vec(:,temp_mark)/norm(sort_vec(:,temp_mark));
                    break;
                end
            end
        end
        J1 =0;
        %         temp4 = 1;
        for view_mark = 1:num_view     %%计算所有视角局部保持部项的和
            J1 = J1+(temp_vec{view_mark})'*SL{view_mark}*temp_vec{view_mark};
        end
        %         beta = (temp_vec{view_num})'*f;
        J2 = alpha*((temp_vec{num_view})'*f)^2;  %% 高阶相关性项的值
        J3 = 0;
        for view_mark1 = 1:(num_view-1)
            for view_mark2 = (view_mark1+1):num_view
                J3 = J3 + beta*(temp_vec{view_mark1}'*R{view_mark1,view_mark2}*temp_vec{view_mark2})^2;  %%低阶相关性项的值
            end
        end
        J(trans_mark,it_mark) = J1-J2-J3;
        obj(it_mark) = J(trans_mark,it_mark);
        if it_mark>=2
            if abs((J(trans_mark,it_mark)-J(trans_mark,it_mark-1))/J(trans_mark,it_mark)) < ef %% 收敛则结束本次迭代
                break;
            end
            
            a1 = J(trans_mark,it_mark);
            a2 = J(trans_mark,it_mark-1);
            aa = abs((a1-a2)/a1);
        end
        %         clear temp4;
    end
    for view_mark = 1:num_view
        trans_vec{view_mark} = [trans_vec{view_mark} temp_vec{view_mark}];
        trans_vec{view_mark} = real(trans_vec{view_mark});
    end
end