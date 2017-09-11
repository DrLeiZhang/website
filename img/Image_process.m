I=imread('F:\Git\myproject\img\JT2.JPG');
I1=imresize(I(:,:,1),[570 760]);% [570 760] 宽照片;  [760 570]窄照片
I2=imresize(I(:,:,2),[570 760]);
I3=imresize(I(:,:,3),[570 760]);
image_rgb(:,:,1)=I1;
image_rgb(:,:,2)=I2;
image_rgb(:,:,3)=I3;
imwrite(image_rgb,'JT2.jpg','jpg'); % 直接取代原文件夹中的图片