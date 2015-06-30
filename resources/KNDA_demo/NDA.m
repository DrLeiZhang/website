% This is an implementation of the NDA model for classification
%
% Please refer to the following paper
% Lei Zhang and Feng-Chun Tian,"A new kernel discriminant analysis framework for electronic nose recognition", Analytica Chimica Acta,816(2014)8-17.

% Input:
%      (1)X1; % Data of class 1
%          X1:dxN1 (d is the number of dimension and N1 is the number of samples)
%      (2)X2; % Data of class 2
%          Tt:dxN2(d is the number of dimension and N1 is the number of samples)

% Output:
%      (1)W: transformation matrix
%      (2)centers: the center matrix of the two classes after transformation

% please contact us via the following email:
% email:leizhang@cqu.edu.cn

 function [W,centers]=NDA(X1,X2)

 dim1=size(X1,1);
 dim2=size(X2,1);
 N1=size(X1,2);
 N2=size(X2,2);
 m1=mean(X1,2);
 m2=mean(X2,2);
 m=mean([X1,X2],2);
 % calculate Between-class scatter matrix
 SB=zeros(dim1,dim2);
 for i=1:N1
     for j=1:N2
         temp=X1(:,i)-X2(:,j);
         SB=SB+temp*temp'*exp(-norm(temp)^2/10);
     end
 end
 % SB=N1*(m1-m)*(m1-m)'+N2*(m2-m)*(m2-m)';
 % SB=SB/(N1*N2);

 % calculate Within-class scatter matrix

 SW1=zeros(dim1,dim2);
  for i=1:N1
      for j=1:N1
          temp1=X1(:,i)-X1(:,j);
          SW1=SW1+temp1*temp1'*exp(-1*norm(temp1)^2/10);
      end
  end
 SW2=zeros(dim1,dim2);
  for i=1:N2
      for j=1:N2
          temp2=X2(:,i)-X2(:,j);
          SW2=SW2+temp2*temp2'*exp(-1*norm(temp2)^2/10);
      end
  end
  SW=SW1/N1^2+SW2/N2^2;
 % SW=SW1+SW2;
 %   DeltS=SB-SW;
 DeltS=inv(SW)*SB;
 [eigvector,eigvalue]=eig(DeltS);
 [d,index] = sort(diag(eigvalue),'descend');
 W=eigvector(:,index(1));
 centers=[m1'*W m2'*W]';
 end

  