I=imread('F:\Git\myproject\img\me_new_7.JPG');
I1=imresize(I(:,:,1),[240 194]);
I2=imresize(I(:,:,2),[240 194]);
I3=imresize(I(:,:,3),[240 194]);
image_rgb(:,:,1)=I1;
image_rgb(:,:,2)=I2;
image_rgb(:,:,3)=I3;