function [ base_layer, detail_layer, res, amb_map, mean_I, var_I, N, residual_img ] = fcn_guided_decomposition(I, p, r, eps, scale_mapping,j)
% Function for guided filtering based image decomposition

% pre-compute common variables
[hei, wid] = size(I);
detail_layer = zeros(size(I));
res = zeros(size(I));


N = boxfilter(ones(hei, wid), r); % the size of each local patch; N=(2r+1)^2 except for boundary pixels.

mean_I = boxfilter(I, r) ./ N;
%disp(mean_I);

mean_p = boxfilter(p, r) ./ N;
mean_Ip = boxfilter(I.*p, r) ./ N;
cov_Ip = mean_Ip - mean_I .* mean_p; % this is the covariance of (I, p) in each local patch.
%disp(cov_Ip)


mean_II = boxfilter(I.*I, r) ./ N;
var_I = mean_II - mean_I .* mean_I;





% decomposition process
% ------------------------------------------------------------
q{1} = I;
for i = 1:length(eps)
    a = cov_Ip ./ (var_I + eps(i));
    
    b = mean_p - a .* mean_I;
    mean_a{i+1} = boxfilter(a, r) ./ N;
    %figure(i);imshow(mean_a{i+1});title('mean_a{i+1}');
    mean_b{i+1} = boxfilter(b, r) ./ N;
   %figure(i+5);imshow(mean_b{i+1});title('mean_b{i+1}');
    q{i+1} = mean_a{i+1} .* I + mean_b{i+1};
    residual_img{i} = q{i} - q{i+1};
    %disp('Check for number of iterations');disp(i);
    %figure(i+5);
%imshow(residual_img{i});
%title('residual_img{i}');
    detail_layer = detail_layer + fcn_mapping(residual_img{i}, 'nonlinear', scale_mapping{i}(1), scale_mapping{i}(2), 0);

end

    
    


res=residual_img{end};
base_layer = q{end};
%disp('size of base layer');disp(size(base_layer));
%figure(2);
%figure(6);imshow(base_layer);title('base_layer');
%figure(7);%imshow(detail_layer);%title('detail_layer');
amb_map = mean_b{end};
%figure(8);imshow(amb_map);title('amb_map');

end

