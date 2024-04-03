function [atmosphere] = Alight( image, win_size )
%DEHZE Summary of this function goes here
%   Detailed explanation goes here

if ~exist('omega', 'var')
    omega = 0.95;
end

if ~exist('win_size', 'var')
    win_size = 15;
end

if ~exist('lambda', 'var')
    lambda = 0.0001;
end

[m, n, ~] = size(image);

dark_channel = get_dark_channel(image, win_size);

% figure;
% imshow(dark_channel);
% title('dark channel');

atmosphere = get_atmosphere(image, dark_channel);

end

