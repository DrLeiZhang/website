function [w,b,obj]=mtl(train_feature,T,m)
% This is an implementation of mtl algorithm for reading ability based on eye tracking data
% Input:
%     train_feature: training data
%     T: training output
%     m: number of trivals
% Output:
%     w: prediction weights
%     b: prediction bias
%     obj: objective function value
% please contact me via the following email:
% email:leizhang@cqu.edu.cn

m_tr=size(train_feature{1},1);% number of training samples
d=size(train_feature{1},2); % dimension
% initialization
w=cell(1,m);
b=cell(1,m);
In=cell(1,m);
Wm=[];
lambda=0.01;
gamma=1;
for i=1:m
    w{1,i}=zeros(d,1);
    b{1,i}=zeros(1);
    In{1,i}=ones(m_tr,1);
    Wm=[Wm w{1,i}];
end
% training algorithm
r=0;
max_iter=5;
while 1
    r=r+1;
    D = diag(0.5*(diag(Wm*Wm'+eps).^(-0.5)));
%     for k=1:size(Wm,1),dd(k)=1/(2*norm(Wm(k,:))+eps);end;D=diag(dd);
    Wm=[];
    for i=1:m
        w{1,i}=inv(train_feature{i}'*train_feature{i}+lambda*eye(d)+gamma*D)*(train_feature{i}'*T{i}-train_feature{i}'*In{1,i}*b{1,i});
        b{1,i}=1/m_tr*(In{1,i}'*train_feature{i}*w{1,i}-In{1,i}'*T{i});
        Wm=[Wm,w{1,i}];
    end
    % objective function value
    for j=1:m
        obj1(j)=norm(train_feature{i}*w{1,i}+In{1,i}*b{1,i}-T{i})^2+lambda*norm(w{1,i})^2;
    end
       obj(r)=sum(obj1)+gamma*sum(svd(Wm));
        
    if r>=max_iter
        break
    end
end