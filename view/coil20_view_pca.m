% to obtain the coil20

% PCA first
% sum = 1;
% for i=1:20
%     for j=0:71
%         addr=strcat('D:\aaa_数据文件\Z盘\人工智能\coil20\coil-20-proc\obj',num2str(i),'__',num2str(j),'.png');
%         a=imread(addr);
%         COIL20(:,:,sum) = a;
%         sum = sum+1;
%     end
% end
% save COIL20.mat
% % 
% clear data
% % load("COIL20.mat");
% for i = 1 : size(COIL20,3)
%     a = COIL20(:,:,i);
%     a = a(:);
%     data(:,i) = double(a);
% end
% data=zscore(data);     %数据的标准化
% 
% [coeff,score,latent] = pca(data');
% feature_after_PCA=score(:,1:200);

col_data = feature_after_PCA';
data_view = cell(1,12);
for v = 1 : 12
    % 分为12个view， 一个view6张照片
    for i = 1 : 20
        from = (i-1)*72 + (v-1)*6 + 1
        end_ = (i-1)*72 + (v-1)*6 + 6
        a = col_data(:, from : end_ );
        data_view{v} = [data_view{v} a];
    end
end
