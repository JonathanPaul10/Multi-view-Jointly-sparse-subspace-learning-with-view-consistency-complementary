
function  ratio = test_recognition(P,P0,train_all_2D,Y_2D,test_all_2D,test_Y_2D)

%����test��train����Ƿ��Ǻ�
%����������������������䷶��
global V dimen

% train_all_2D
% projection = zeros(size(P{1}));
% for v = 1 : V
%     projection = projection + alpha(v) .* P{v};
% end

projection = P;

%����train���ܾ���
train = projection * train_all_2D ;
test = projection * test_all_2D;

test_num = size(test, 2);
tr_num = size(train,2);

num = 0;
for j = 1 : test_num
    distance = 1e120;
    aimone = 0;
    for k = 1 : tr_num
        temp = norm(train(:,k) - test(:,j));%������� ȡŷʽ���룬�������Ϊ���������
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
%ƥ����
ratio=100*num/test_num;
clear count
display(strcat('dr=',num2str(dimen),' ƥ���ʣ�',num2str(ratio),'%'));
end