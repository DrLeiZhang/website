I=imread('F:\Git\myproject\img\JT2.JPG');
I1=imresize(I(:,:,1),[570 760]);% [570 760] ����Ƭ;  [760 570]խ��Ƭ
I2=imresize(I(:,:,2),[570 760]);
I3=imresize(I(:,:,3),[570 760]);
image_rgb(:,:,1)=I1;
image_rgb(:,:,2)=I2;
image_rgb(:,:,3)=I3;
imwrite(image_rgb,'JT2.jpg','jpg'); % ֱ��ȡ��ԭ�ļ����е�ͼƬ