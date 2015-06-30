% This is an implementation of the NDA model training for parameters
% Input:
%      (1)input:  n*d matrix,representing samples
%         
%      (2)target: n*1 matrix,class label


% Output:
%      (1)model:  struct type(see codes below)
%      (2)k:      the total class number
%      (3)ClassLabel:   the class name of each class

function [model,k,ClassLabel]=NDATraining(input,target)
         
[n dim]=size(input);
ClassLabel=unique(target);
k=length(ClassLabel);
t=1;
for i=1:k-1 
    for j=i+1:k      % train k*(k-1)/2 models by OAO strategy
        model(t).a=i;      
        model(t).b=j;      
        g1=(target==ClassLabel(i));      
        g2=(target==ClassLabel(j));     
        tmp1=input(g1,:);      
        tmp2=input(g2,:);        
        in=[tmp1;tmp2];       
        out=ones(size(in,1),1);     
        out(1:size(tmp1,1))=ClassLabel(i); 
        out(1+size(tmp1,1):size(tmp1,1)+size(tmp2,1))=ClassLabel(j);
        %         tmp3=target(g1);
        %         tmp4=target(g2);
        %         tmp3=repmat(tmp3,length(tmp3),1);
        %         tmp4=repmat(tmp4,length(tmp4),1);
        %         out=[tmp3;tmp4];       
        [w m]=NDA(tmp1',tmp2');  
        model(t).W=w;      
        model(t).means=m;    
        t=t+1;   
    end
end