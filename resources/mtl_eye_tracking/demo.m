% this is a demo for reading ability analysis based on eye tracking data
% please run this code for insight of the data
% if you want to change other data or add new data please modify the
% "74m42data.txt" file.

clc;
clear all;
close all;
addpath([cd '/mtl_eye_tracking']);
for run_time=1:100
    %% read data
     load('74m42data.txt');
     data=X74m42data;
     % sort the first column
     [v,ind1]=sort(data(:,1),'ascend');
     data=data(ind1,:);
     % sort the second column
     m=length(find(data(:,1)==1)); % number of trivals
     n=size(data,1)/m; % number of persons
     for i=1:n
         p1=m*(i-1)+1:m*i;
         di=data(p1,:);
         [v,indi]=sort(di(:,2),'ascend');
         data(p1,:)=di(indi,:);
     end

    % sort the data from person 1 to person n, where for each person the data
    % is ranked from trival 1 to trival m

    %% find out the maximum index value of 42 trivals for each person
     for i=1:n
         person_i=data(m*(i-1)+1:m*i,:);
         maximum_value(i,:)=max(person_i(:,3:25));
        if maximum_value(i,1)==0,
            maximum_value(i,1)=1;
        end
     end

    %% extract m types of feature for each person
     for i=1:m
         feature{i}=data(find(data(:,2)==i),:); % multi-modal feature
     end 
    
     % normalization is person-specific
     for i=1:m
         feati=[feature{i}(:,3:25),feature{i}(:,26)];
         for j=1:size(feati,2)-1 % the sex is un-normalized
             feati(:,j)=feati(:,j)./max(feati(:,j));% maximum_value(:,j); 
         end
    
%        feati(:,21:23)=feati(:,21:23)/150; % test scores
         feati(:,size(feati,2))=feati(:,size(feati,2))/100; % reading score
         feature{i}=feati;
     end


    %% train and test feature
    index=1:n;
    index=index(randperm(n));
    train_index=index(1:n/2); 
    test_index=index(n/2+1:n);
    for i=1:m
        train_feature{i}=feature{i}(train_index,1:end-1);
        T{i}=feature{i}(train_index,end);
        test_feature{i}=feature{i}(test_index,1:end-1);
        TestT{i}=feature{i}(test_index,end);
    end


    %% multi-feature learning algorithm for prediction
    [w,b,obj]=mtl(train_feature,T,m);

%    feature mapping
%{
     NumberofHiddenNeurons=30;
     NumberofInputNeurons=d;
     InputWeight=rand(NumberofHiddenNeurons,NumberofInputNeurons)*2-1;
     BiasofHiddenNeurons=rand(NumberofHiddenNeurons,1);
     for i=1:m
          tempH1=train_feature{i}*InputWeight';
          ind=ones(1,m_tr);
          BiasMatrix=BiasofHiddenNeurons(:,ind)';
          tempH1=tempH1+BiasMatrix;
          train_feature{i} = 1 ./ (1 + exp(-tempH1));
    
          tempH2=test_feature{i}*InputWeight';
          ind=ones(1,m_te);
          BiasMatrix=BiasofHiddenNeurons(:,ind)';
          tempH2=tempH2+BiasMatrix;
          test_feature{i} = 1 ./ (1 + exp(-tempH2));
          d=NumberofHiddenNeurons;
     end
%}

%      test process
       for i=1:m
           Int{1,i}=ones(size(test_feature{1},1),1);
       end
       f=zeros(size(test_feature,1),1);
       for i=1:m
           f=f+1/m*(test_feature{i}*w{1,i}+Int{1,i}*b{1,i});
       end
       
      absolute_err(run_time)=mean(abs(f-TestT{1}))*100;
      fprintf('%f\n',absolute_err);
      W{run_time}=w;
      B{run_time}=b;
end
ave=mean(absolute_err);
std=sqrt(mean(absolute_err.^2)-mean(absolute_err)^2);
fprintf('mean absolute prediction error and standard deviation:')
fprintf('%f,%f\n',[mean(absolute_err) std])
fprintf('The best result (error):')
fprintf('%f\n',min(absolute_err))

% objective function value
plot(obj,'linewidth',2)
xlabel('iteration');
ylabel('objective value')

figure; 
[v,ind]=min(absolute_err);w=W{ind};
for i=1:m
    plot(w{i});hold on;
end
xlabel('eye tracking factor');ylabel('contribution')

for i=1:m
    nw(i)=norm(w{i});
end
figure;plot(nw); xlabel('trival index');ylabel('contribution coefficient');

% plot(f);hold on; xlabel('test persons');ylabel('reading score');plot(TestT{1},'r')
% legend('predicted score','ground truth')