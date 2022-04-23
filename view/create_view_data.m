%  AR
pen = info(3);
pin = info (4);

add_count_a = 1;
add_count_b = 1;
add_count_c = 1;
data_v{1} = [];
data_v{2} = [];
data_v{3} = [];
for i = 1 : pen
    a = (i - 1) * pin + (1:4);
    b = (i - 1) * pin + (5:7);
    c = (i - 1) * pin + (8:10);
    data_v{1} = [ data_v{1} feature_after_PCA(a(:),:)'];
    data_v{2} = [ data_v{2} feature_after_PCA(b(:),:)'];
    data_v{3} = [ data_v{3} feature_after_PCA(c(:),:)'];
    a = a + 10;
    b = b + 10;
    c = c + 10;
    add_count_a = add_count_a + 5;
    add_count_a = add_count_a + 4;
    add_count_a = add_count_a + 5;
    data_v{1} = [ data_v{1} feature_after_PCA(a(:),:)'];
    data_v{2} = [ data_v{2} feature_after_PCA(b(:),:)'];
    data_v{3} = [ data_v{3} feature_after_PCA(c(:),:)'];
end


