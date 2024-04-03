function [out_img, time, trans_map, A] = fcn_multi(img,HDE,temp)

%The main function of multi-band enhancement.
% 
% The details of the algorithm are described in this paper: 
% Model Assisted Multi-band Fusion for Single Image Enhancement and Applications to Robot Vision
% Y. Cho, J. Jeong, A. Kim, IEEE RA-L, 2018
% which can be found at:
% http://irap.kaist.ac.kr/publications/ycho-2018-ral.pdf
% This code is inspired from the above paper, if you use this code, please
% cite the above paper.
%
%   Input arguments:
%   ----------------
%	- img : input haze image, type "double"
%	- scale_smooth : predifined smoothing factors (epsilon)
%	- scale_mapping : parameters for mapping function (optional)
%   - box_size: size of default box for filtering
%
%   Output arguments:
%   ----------------
%   - out_img: output dehazed image
%   - trans_map: transmission map
%   - A: ampbient light
%
% Author: Younggun Cho (yg.cho@kaist.ac.kr)
%
% The software code is provided under the attached LICENSE.md



% if HDE<0.6
% 
% if temp==3
% scale_smooth = [1e-6,1e-5,1e-4,1e-3,1e-2];
% % scale_smooth = [1e-5,1e-4,1e-3,1e-2,1e-1];
% scale_mapping = {[0.5,40], [0.8, 40], [0.8, 30],[0.8, 30],[0.8, 20]};
% % scale_smooth = [1e-3,1e-2,1e-1];
% % scale_mapping = {[0.5,40], [0.8, 37], [0.8, 34]};
% % disp('In temp=3');
% end
% 
% if temp==2
% scale_smooth = [1e-6,1e-5,1e-4,1e-3,1e-2];
% % scale_smooth = [1e-5,1e-4,1e-3,1e-2,1e-1];
% scale_mapping = {[0.5,40], [0.8, 30], [0.8, 30],[0.8, 20],[0.8, 10]};
% % scale_smooth = [1e-3,1e-2,1e-1];
% % scale_mapping = {[0.5,30], [0.8, 27], [0.8, 24]};
% % disp('In temp=2');
% end
% 
% if temp==1
% scale_smooth = [1e-6,1e-5,1e-4,1e-3,1e-2];
% % scale_smooth = [1e-5,1e-4,1e-3,1e-2,1e-1];
% scale_mapping = {[0.5,30], [0.8, 20], [0.8, 20],[0.8, 10],[0.8, 10]};
% % scale_smooth = [1e-3,1e-2,1e-1];
% % scale_mapping = {[0.5,20], [0.8, 17], [0.8, 14]};
% % disp('In temp=1');
% end
% disp('HDE < 0.6');
% disp('HDE:');disp(HDE);
% else
%     disp('HDE > 0.6');
%     disp('HDE:');disp(HDE);
% if temp==3
% % scale_smooth = [1e-6,1e-5,1e-4,1e-3,1e-2];
% scale_smooth = [1e-5,1e-4,1e-3,1e-2,1e-1];
% scale_mapping = {[0.5,40], [0.8, 38], [0.8, 36],[0.8, 34],[0.8, 32]};
% % scale_smooth = [1e-3,1e-2,1e-1];
% % scale_mapping = {[0.5,40], [0.8, 37], [0.8, 34]};
% % disp('In temp=3');
% end
% 
% if temp==2
% % scale_smooth = [1e-6,1e-5,1e-4,1e-3,1e-2];
% scale_smooth = [1e-5,1e-4,1e-3,1e-2,1e-1];
% scale_mapping = {[0.5,30], [0.8, 28], [0.8, 26],[0.8, 24],[0.8, 22]};
% % scale_smooth = [1e-3,1e-2,1e-1];
% % scale_mapping = {[0.5,30], [0.8, 27], [0.8, 24]};
% % disp('In temp=2');
% end
% 
% if temp==1
% scale_smooth = [1e-6,1e-5,1e-4,1e-3,1e-2];
% % scale_smooth = [1e-5,1e-4,1e-3,1e-2,1e-1];
% scale_mapping = {[0.5,20], [0.8, 18], [0.8, 16],[0.8, 14],[0.8, 12]};
% % scale_smooth = [1e-3,1e-2,1e-1];
% % scale_mapping = {[0.5,20], [0.8, 17], [0.8, 14]};
% % disp('In temp=1');
% end
% 
% end
    
%if temp==4
%scale_smooth = [1e-6,1e-5,1e-4,1e-3,1e-2];
%scale_mapping = {[0.5,20], [0.8, 20], [0.8, 10],[0.8, 10],[0.8, 10]};
%disp('In temp=4');
%end

% scale_smooth = [(HDE*1e-5+(1-HDE)*1e-6),(HDE*1e-4+(1-HDE)*1e-5),(HDE*1e-3+(1-HDE)*1e-4),(HDE*1e-2+(1-HDE)*1e-3),(HDE*1e-1+(1-HDE)*1e-2)];



a1=23.7841;b1=0.917;a2=39.4822;b2=0.8717;a3=56.5685;b3=0.8409;HDE_th=0.6;%HDE_th1=0.3;

scale_smooth = [10^(-HDE_th*6/HDE),10^(-HDE_th*5/HDE),10^(-HDE_th*4/HDE),10^(-HDE_th*3/HDE),10^(-HDE_th*2/HDE)];

if temp==1
    scale_mapping = {[0.5,a1*b1^((HDE_th/HDE)*1)], [0.8, a1*b1^((HDE_th/HDE)*2)], [0.8, a1*b1^((HDE_th/HDE)*3)],[0.8, a1*b1^((HDE_th/HDE)*4)],[0.8, a1*b1^((HDE_th/HDE)*5)]};
end

if temp==2
    scale_mapping = {[0.5,a2*b2^((HDE_th/HDE)*1)], [0.8, a2*b2^((HDE_th/HDE)*2)], [0.8, a2*b2^((HDE_th/HDE)*3)],[0.8, a2*b2^((HDE_th/HDE)*4)],[0.8, a2*b2^((HDE_th/HDE)*5)]};
end

if temp==3
    scale_mapping = {[0.5,a3*b3^((HDE_th/HDE)*1)], [0.8, a3*b3^((HDE_th/HDE)*2)], [0.8, a3*b3^((HDE_th/HDE)*3)],[0.8, a3*b3^((HDE_th/HDE)*4)],[0.8, a3*b3^((HDE_th/HDE)*5)]};
end

%disp(scale_smooth)
%scale_mapping = {[0.5, 40], [0.8, 40], [0.8, 10]};
box_size = 20;

tic;

[out_img, amb_map, trans_map, A] = fcn_multiscale_enhancement(img, img, box_size, scale_smooth, scale_mapping);
amb_map=rgb2gray(amb_map);
%figure; imshow(amb_map); title('amb_map');
%trans_map=trans_map
%imwrite(trans_map,'trans_map.jpg');
%colormap jet
%figure; imshow(trans_map); title('trans map');
%colormap jet
adj_percent = [0.005, 0.995];
out_img = imadjust(out_img, adj_percent);

time = toc;

