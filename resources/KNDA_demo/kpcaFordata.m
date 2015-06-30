% This is an implementation of the KPCA for dimension reduction
% Input:
%      (1)train: training data matrix
         
%      (2)test: testing data matrix

%      (3)threshold:ACR (accumulated contribution rate)

%      (4)rbf_var:kernel parameter

% Output:
%       (1)train_kpca: dimension reduced training data     
%       (2)test_kpca: dimension reduced testing data
%       (3)train_eigval:percent of prinicpal components

function [train_kpca,test_kpca,train_eigval] = kpcaFordata(train,test,threshold,rbf_var)

if nargin <4
rbf_var=8;
end
if nargin <3
threshold = 96;
end
%% data preprocessing
patterns=zscore(train); 
test_patterns=zscore(test); 
train_num=size(patterns,1); 
test_num=size(test_patterns,1);
cov_size = train_num;
% Kernel matrix computing
for i=1:cov_size,
    for j=i:cov_size,
        K(i,j) = exp(-norm(patterns(i,:)-patterns(j,:))^2/rbf_var); 
        K(j,i) = K(i,j);
    end
end
unit = ones(cov_size, cov_size)/cov_size;
% Centralize
K_n = K - unit*K - K*unit + unit*K*unit;

% Eigenvalue decomposition

[evectors_1,evaltures_1] = eig(K_n/cov_size);
[x,index]=sort(real(diag(evaltures_1))); 
evals=flipud(x) ;
index=flipud(index);

%
evectors=evectors_1(:,index);

% normalize
% for i=1:cov_size
% evecs(:,i) = evectors(:,i)/(sqrt(evectors(:,i)));
% end

% reconstruct training data
train_eigval = 100*cumsum(evals)./sum(evals);
index = find(train_eigval >threshold);

train_kpca = zeros(train_num, index(1)); 

train_kpca=[K_n * evectors(:,1:index(1))];

% reconstruct testing data

unit_test = ones(test_num,cov_size)/cov_size;
K_test = zeros(test_num,cov_size); 
for i=1:test_num, 
    for j=1:cov_size,
        K_test(i,j) = exp(-norm(test_patterns(i,:)-patterns(j,:))^2/rbf_var);
    end
end
K_test_n = K_test - unit_test*K - K_test*unit + unit_test*K*unit;

test_kpca = zeros(test_num, index(1));

test_kpca = [K_test_n * evectors(:,1:index(1))];
