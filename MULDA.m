function W_M = MULDA(X_multiview,Label_multiview,alignMode,Lamda,num_classtrain,methodType)
%% code of MULDA given by Jun Yin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% X_multiview: multiview train data, each view corresponds to one cell;
% each row is one instance;
% Label_multiview: class label of X_multiview, type: string;
% each view has the same number of classes;
% W_mulda: multiple view-specific transforms, one for each view;
% methodType: type of method,string
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global pen dimen


%% get different Sb Sw St for each view
nV = length(X_multiview);
Sb = cell(nV,1);
Sw = cell(nV,1);
St = cell(nV,1);

% 此处为根据自己数据做出的调整
for i = 1 : nV
    X_multiview{i} = X_multiview{i}';
end

Dim = zeros(nV,1);
nS = zeros(nV,1);
Mean = cell(nV,1);
classMean = cell(nV,1);
%D = cell{nV,1};
kN = zeros(nV,1);
W_mlda = cell(nV,1);
W_mulda = cell(nV,1);

for i = 1:nV
    [nS(i) Dim(i)] = size(X_multiview{i});
    Mean{i,1} = mean(X_multiview{i});
    tmp = Label_multiview{i};
    label = [1:1:pen];
    kN(i)=length(label);
    classMean{i,1} = zeros(kN(i),Dim(i));
    for c = 1:kN(i)
        loc = find(tmp == label(c));
        [num o] = size(loc);
        %classMean{i,1}(c,:) = sum(X_multiview{i,1}(loc,1:Dim(i)))/num;
        classMean{i,1}(c,:) = mean(X_multiview{i}(loc,:));
        B{i,1}(c,:) = sqrt(num)*(classMean{i,1}(c,:) - Mean{i,1});
        B{i,1}(loc+kN(i),:) = X_multiview{i}(loc,:) - ones(num,1)*classMean{i,1}(c,:);
    end
    Hb{i,1} = B{i,1}(1:kN(i),:)';
    Hw{i,1}= B{i,1}(kN(i)+1:kN(i)+nS(i),:)';
    Sb{i,1} = Hb{i,1} * Hb{i,1}';
    Sw{i,1} = Hw{i,1} * Hw{i,1}';
    St{i,1} = Sb{i,1}+Sw{i,1};
end
%% compute matrix sA and sB
% Cij

switch alignMode
    case 1 % centered
        for i = 1:nV
            alignCol{i,1} = X_multiview{i} - ones(nS(i),1)*Mean{i,1};
        end
    case 2 % average
        for i = 1:nV
            alignCol{i,1} = classMean{i,1};
        end
    case 3 %DCCA
        Ai = zeros(max(nS),max(nS));% DCCA: A = Ai'*Ai
        k = max(kN);
        for c = 1:k
            Ai(num_classtrain*(c-1)+1:num_classtrain*c,num_classtrain*(c-1)+1) = 1;
        end
        for i = 1:nV
            alignCol{i,1} = Ai' * (X_multiview{i} - ones(nS(i),1)*Mean{i,1});
        end
end

% sA,sB
sA = zeros(sum(Dim),sum(Dim));
sB = zeros(sum(Dim),sum(Dim));

Mult = zeros(nV,1);
Mult(1) = 1;
for i = 2:nV
    Mult(i) = 1/trace(St{i,1});
    for j = 1:i-1
        Mult(i) = Mult(i) * trace(St{j,1});
    end
    for k = i+1:nV
        Mult(i) = Mult(i) * trace(St{k,1});
    end
end

for r = 1:nV
    for c = r:nV
        rs = sum(Dim(1:r-1))+1;
        re = sum(Dim(1:r));
        cs = sum(Dim(1:c-1))+1;
        ce = sum(Dim(1:c));
        if r == c
            sA(rs:re,cs:ce) = 2*Sb{r,1};
            sB(rs:re,cs:ce) = St{r,1}*Mult(i)+0.01*eye(Dim(r));%nonsingularity
        else
            tmp = alignCol{r,1}'*alignCol{c,1}*Lamda;
            sA(rs:re,cs:ce) = tmp;
            sA(cs:ce,rs:re) = tmp';
        end
    end
end

%% get w_mulda
L = max(kN);
L = min(L,min(Dim));
L = dimen;
%L = 5;
sA=(sA+sA')/2;
sB=(sB+sB')/2;
% initiate w1,D{i,1}
[V E] = eigs(sA,sB,L,'LA');
switch methodType
    case 'MLDA'
        for i =1:nV
            D{i,1} = [];
            D{i,1} = V(sum(Dim(1:i-1))+1:sum(Dim(1:i)),:); %mlda
        end
        for i = 1:nV
            W_mlda{i,1} = D{i,1};  %mlda
        end
        
        for ii = 1 : nV
            W_M{ii} = real(W_mlda{ii});
        end
        fprintf('MLDA finished\n');
        
    case 'MULDA'
        for i =1:nV
            D_mu{i,1} = [];
            D_mu{i,1} = V(sum(Dim(1:i-1))+1:sum(Dim(1:i)),1); %mulda
        end
        % get other wi
        PP = zeros(sum(Dim),sum(Dim));
        for i = 2:L
            for j = 1:nV
                Tmp = D_mu{j,1}'*St{j,1}*D_mu{j,1};
                Pj = eye(Dim(j))-St{j,1}*D_mu{j,1}*inv(Tmp)*D_mu{j,1}';
                js = sum(Dim(1:j-1))+1;
                je = sum(Dim(1:j));
                PP(js:je,js:je) = Pj;
            end
            sA = PP*sA;
            [V E] = eigs(sA,sB,1,'LR');
            for r = 1:nV
                D_mu{r,1} =[D_mu{r,1} V(sum(Dim(1:r-1))+1:sum(Dim(1:r)),1)];
            end
        end
        for i = 1:nV
            W_mulda{i,1} = D_mu{i,1};  %mulda
        end
        
        for ii = 1 : nV
            W_M{ii} = real(W_mulda{ii});
        end
        fprintf('MULDA finished\n');
end
