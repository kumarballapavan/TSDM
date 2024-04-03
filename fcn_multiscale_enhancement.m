function [ out_I, amb_map, trans_map, A ] = fcn_multiscale_enhancement( I, p, box_size, scale_smooth, scale_mapping)
% The core implementation of "Multi-band-enhancement". Given predefined
% parameters, each module is operated sequentially. The detail of the
% process is implemented in each function.
% This code is motivated by the code form original guided filter
% implementation of Kaiming He (http://kaiminghe.com/eccv10/)
%
%   Input arguments:
%   ----------------
%	- I : guidance image
%   - p : filtering input image
%	- scale_smooth : predifined smoothing factors (epsilon)
%	- scale_mapping : parameters for mapping function (optional)
%   - box_size: size of default box for filtering

%% Preallocation
n_channel = size(I,3);
out_I = zeros(size(I));
base_layer = zeros(size(I));
detail_layer = zeros(size(I));
res = zeros(size(I));
amb_map = zeros(size(I));
mean_I = zeros(size(I));
var_I = zeros(size(I));
A = zeros(1, n_channel);
% [m,n,q] = size(I);
%figure(1);
%imshow([I p]);
%title('Same or Not');
j=1;
%% Guided-filtering based decomposition
for i = 1:n_channel
    
    [base_layer(:,:,i), detail_layer(:,:,i), res(:,:,i), amb_map(:,:,i), mean_I(:,:,i), var_I(:,:,i), N] = .... 
        fcn_guided_decomposition(I(:,:,i), p(:,:,i), box_size, scale_smooth, scale_mapping,j);
    j=j+1;
end
% base_layer2=rgb2gray(base_layer);
% detail_layer2=rgb2gray(detail_layer);
% amb_map2=rgb2gray(amb_map);
% %figure;imshow(base_layer);title('base layer');
% %figure;imshow(detail_layer2);title('detail layer');
% Br=mean2(detail_layer2);
% disp('bright in detail');disp(Br);
% %colormap jet
% detail_layer3=zeros(size(I));
% W=[1,1,1];
% for i=1:m
%     for j=1:n
%         for k=1:q
%             if (detail_layer(i,j,q)> 0)
%                 detail_layer3(i,j,:)=detail_layer(i,j,:);
%             else
%                 detail_layer3(i,j,:)=W;
%                 %k=k+1;
%             end
%         end
%     end
% end
%figure;imshow(detail_layer3);title('detail layer');
%detail_layer31=rgb2gray(detail_layer3);
%figure;imshow(detail_layer31);title('detail layer');
%colormap winter


%amb_map=amb_map
%figure;imshow(amb_map);title('amb map');

%colormap jet

%figure(1001);imshow(detail_layer);title('detail layer');
%figure(1002);imshow(res);title('residual layer');
%figure(14);imshow(amb_map2);title('amb map gray');
%figure(13);imshow(amb_map);title('amb map');
% P1=0.5;P2=0.5;
%disp('number of dark pixels in ambient map');disp(numel(amb_map(amb_map<P1)));
%disp('number of bright pixels in ambient map');disp(numel(amb_map(amb_map>P2)));
%disp('ratio of dark to bright pixels');disp(numel(amb_map(amb_map<P1))/numel(amb_map(amb_map>P2)));
% img=rgb2gray(I);

%disp('number of dark pixels in original gray image');disp(numel(img(img<P1)));
%disp('number of bright pixels in original gray image');disp(numel(img(img>P2)));
%disp('ratio of dark to bright pixels of original gray image');disp(numel(img(img<P1))/numel(img(img>P2)));


%disp('number of dark pixels in ambient map gray');disp(numel(amb_map2(amb_map2<P1)));
%disp('number of bright pixels in ambient map gray');disp(numel(amb_map2(amb_map2>P2)));
%disp('ratio of dark to bright pixels for gray ambient map');disp(numel(amb_map2(amb_map2<P1))/numel(amb_map2(amb_map2>P2)));



%% Intensity Module

% ambient light estimation
A = fcn_estim_ambient(I, amb_map, 0);
% disp('Atmospheric Light:'); disp(A);
% transmission estimation
trans_map = fcn_estim_transmission(base_layer, A, box_size, 0);
%figure;imshow(trans_map);title('trans map');
%colormap jet

%% Laplacian Module 
if size(I,3) == 3
    guide_I = rgb2gray(base_layer);
else
    guide_I = base_layer;
end

% transmission refinement
trans_map = fcn_refine_transmission(guide_I, trans_map, box_size, mean(mean_I, 3), mean(var_I,3), N);
 %figure;imshow(trans_map);title('refined trans map');
%colormap jet   
%disp(trans_map)   
    %figure(101); imshow(trans_map); title('Transmission Map Refined');
    

%% Color correction
if n_channel == 3
    if std(A) >  0.2
        disp ('Color biased');
        A2 = norm(A)*ones(size(A)) ./ sqrt(3);
    else
        A2 = 1*A;
    end
else
    A2 = 1*A;
end
%disp('standard deviation =');disp(std(A));
%disp(A)
%disp(A2)


%% Reconstruction
J = zeros(size(out_I));
for i = 1:n_channel
    J(:,:,i) = (base_layer(:,:,i) - A(i))./(1*trans_map) + A2(i);
    out_I(:,:,i) = J(:,:,i) + detail_layer(:,:,i);
end

end



