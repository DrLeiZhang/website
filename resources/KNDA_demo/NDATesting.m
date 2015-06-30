% This is an implementation of the NDA model test for classification
% Input:
%      (1)input: n*d matrix,representing samples
         
%      (2)target: n*1 matrix,class label

%      (3)ClassLabel:the class name of each class

%      (4)model:the well trained model parameters

% Output:
%       (1)target: predicted labels      
%       (2)s: votes number
%       
function [target,s]=NDATesting(input,k,model,ClassLabel)
% input:        
% target:       

[n dim]=size(input);
s=zeros(n,k);target=zeros(n,1);
for j=1:k*(k-1)/2   
    a=model(j).a;   
    b=model(j).b;    
    w=model(j).W;   
    m=model(j).means;  
    for i=1:n       
        sample=input(i,:);    
        tmp=sample*w;      
        if norm(tmp-m(1,:))<norm(tmp-m(2,:))     
            s(i,a)=s(i,a)+1;       
        else
            s(i,b)=s(i,b)+1; 
        end
%         if (tmp-m(1,:))*cov([tmp;m(1,:)])*(tmp-m(1,:))<(tmp-m(2,:))*cov([tmp;m(2,:)])*(tmp-m(2,:))   
%             s(i,a)=s(i,a)+1;       
%         else
%             s(i,b)=s(i,b)+1;
%         end
    end
end
for i=1:n   
    pos=1; 
    maxV=0;   
    for j=1:k    
        if s(i,j)>maxV   
            maxV=s(i,j);   
            pos=j;   
        end
    end
    target(i)=ClassLabel(pos);
end
