

% This is the demo of the Three-stage dehazing model, details
% enhancement and pre-processing using auto-color transfer method
% 
% The pre-proessing of hazy image (auto-color transfer) is performed using 
% the function: 'CT'
%
% The image categorization of hazy image (less affected by haze, moderately
% affected by haze and more affected by haze regions) is performed using 
% the function 'Image_Classification')
%
%   Input arguments:
%   ----------------
%	- Oimg : input haze image, type "unsigned integer"
%	- GT : Ground-Truth image
%   - count : Counter for hazy images
%	- validation : If hazy image has a corresponding ground-truth image,
%	  its one, else its zero.
%   - imagename: Name of the hazy image from the DB

clc;
close all;
clear all;

Oimg=imread('hazy/03_hazyc.png');
output_folder = 'Dehazing_Results';

Oimg=imresize(Oimg,[360 480]);
%GT=imresize(GT,[360 480]);

img = im2double(Oimg);
imgg = im2double(Oimg);

%outputFileName = fullfile(output_folder, [imagename, '.png']);

img_gray=rgb2gray(img);

[m,n]=size(img_gray);

% Function 'CT' for auto-color transfer function, to enhance the
% low-intensity regions of a hazy image.
%
%   Input arguments:
%   ----------------
%	- S: Source Image
%   - Tg: Target Image
%
%   Output arguments:
%   ----------------
%   - r: Enhanced Image
%   - comp_time0 : Computation time of this function.

B=mean(mean(img_gray));count75=0;

for i=1:m
   for j=1:n
       
       if img_gray(i,j)<0.3
           count75=count75+1;
       end
           
   end
end


if count75>1000
disp('Low-light regions are available, IACT is applied to hazy image')    
img_gt=img.^0.7;
% img_gt=img.^0.4;
Tg=im2uint8(img);
S=im2uint8(img_gt);
imwrite(Tg,'Tg.png');
imwrite(S,'S.png');
S=imread('S.png');
Tg=imread('Tg.png');
%figure;
%imshow([S Tg]);

[r, comp_time0]=CT(double(S)/255,double(Tg)/255);

%imwrite(im2uint8(r),outputFileName);
%return


img=r;
end


img1=zeros(size(img));%img1f=zeros(size(img));
%img1=im2double(img1);

% Function 'Image_Classification' for auto-color transfer function, to enhance the
% low-intensity regions of a hazy image.
%
%   Input arguments:
%   ----------------
%	- img: Pre-processed Hazy Image
%
%   Output arguments:
%   ----------------
%   - img_map: Image map with region classification i.e., Red colour for
%   less-affected by haze regions, Green colour for moderately affected by
%   haze regions and blue colour for more-affected by haze regions.


img_map=Image_Classification(img);

% img=imgg;
HDE=new_indicator_v5_opt(img);

Atm_light=Alight(im2double(img));
%Atm_light_h=Alight(im2double(GT));

% HS=Image_Classification_HS(img,mean(Atm_light));
% if HDE>0.5
%     imwrite(img,[imagename, '.png']);
% end
[dehazed_img1, comp_time1, trans_map1] = fcn_multi(img,HDE,1);

%imwrite(Odehazed_img,outputFileName);
[dehazed_img2, comp_time2, trans_map2] = fcn_multi(img,HDE,2);

[dehazed_img3, comp_time3, trans_map3] = fcn_multi(img,HDE,3);
% Odehazed_img3=im2uint8(dehazed_img3);

dehazed_img=zeros(size(img));k=0;



% Mapping of dehazing results with their respective regions


img1=zeros(size(img));
img2=zeros(size(img));
img3=zeros(size(img));

img_map_R=img_map(:,:,1);img_map_G=img_map(:,:,2); img_map_B=img_map(:,:,3);

I_cond= img_map_R~=0;
I_cond31=I_cond(:,:,[1 1 1]);


dehazed_img(I_cond31)=dehazed_img1(I_cond31);
img1(I_cond31)=dehazed_img1(I_cond31);


I_cond= img_map_G~=0;
I_cond32=I_cond(:,:,[1 1 1]);

dehazed_img(I_cond32)=dehazed_img2(I_cond32);
img2(I_cond32)=dehazed_img2(I_cond32);

I_cond= img_map_B~=0;
I_cond33=I_cond(:,:,[1 1 1]);

dehazed_img(I_cond33)=dehazed_img3(I_cond33);
img3(I_cond33)=dehazed_img3(I_cond33);



Odehazed_img=im2uint8(dehazed_img);

Final_result=post_processing(Odehazed_img);

Oimg=im2uint8(img);



imwrite(Final_result,"dehazed_result.png");


close all;
figure;
imshow([Oimg Odehazed_img]);title('GT hazy dehazed');


