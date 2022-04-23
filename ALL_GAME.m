% ALL GAME

% 几个data的循环
clear all
name{1} = '100Leaves.mat';
% name{1} = 'orl_pca_70.mat';
% name{3} = 'YALE_saltANDpapper.mat   ';

prefix = './view/';


%更改训练集需要更改的点
global pen pin pri_dimen dataset dataname dimen_result V tr pin_v para w dimen method_str
dimen_result = cell(1, size (name,2));
for tr = 4:6
for i = 1 : size (name,2)
    load(strcat(prefix , name{i}));
    %data_v{1} = feature_after_PCA';
    dataset = X;%data_view;
    V = 3;
    pin_v = [16 16 16 16];
    method_str = "MULDA";
%     V = 4;
%     pin_v = [20 20 20 20];
    pen = 100;%info(3);
    pin = 16;%info(4);
    pri_dimen = 64; %info(1);
    
    dataname = name{i};
    MvRR_exe('dimen');
    MvRR_exe('dimen',para.max_one);
    dimen = para.max_one;
    %========================
    MvRR_exe('alpha');
    MvRR_exe('alpha',para.max_one);%max_one);
    %========================
    

end
end
% save dimen_result.mat dimen_result

