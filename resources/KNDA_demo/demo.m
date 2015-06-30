% This is an implementation of the NDA model for classification
%
% Please refer to the following paper
% Lei Zhang and Feng-Chun Tian,"A new kernel discriminant analysis framework for electronic nose recognition", Analytica Chimica Acta,816(2014)8-17.
% If you would like to use this code, please kindly cite this paper for reference. Thank you very much.
% please contact us via the following email if there is any problem in debugging:
% email:leizhang@cqu.edu.cn

clear;
clc;
load('DataCodeTest')


dim_reduction_method='KPCA';
switch dim_reduction_method
    case 'raw'
       train_kernel=X_train;test_kernel=X_test;
    case 'KPCA'
        ACR=96;
        sigma=6;
      [train_kernel,test_kernel,train_eigval] = kpcaFordata(X_train,X_test,ACR,sigma);
end

C=6;
ClassLabel=(1:C)';

% NDA training and testing phase

[model,k,ClassLabel] = NDATraining(train_kernel,label_train);

ytrain = NDATesting(train_kernel,k,model,ClassLabel);

ytest = NDATesting(test_kernel,k,model,ClassLabel); 

test_accuracy = length(find(label_test==ytest))/length(label_test)*100;

