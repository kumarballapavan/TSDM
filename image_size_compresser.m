% This is a demo script demonstrating Region based Adaptive dehazing 
% Details enhancement and pre-processing using auto-color transfer method
% Balla Pavan Kumar, Arvind Kumar and Rajoo Pandey
% 
% Paper is not published yet, details will be updated once the paper is
% published. If you use this code, please cite our paper.
% 
% 
% Please read the instructions on README.md in order to use this code.
%
% Author: Balla Pavan Kumar (kumarballapavan@gmail.com)
%
% The software code is provided under the attached LICENSE.md

clc;
clear all;
close all;

DB = 'F:\DB\GT DB';
% GT = 'F:\DB\GT DB';

output_folder = 'Dehazing_Results';
if ~isdir(DB)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', DB);
  uiwait(warndlg(errorMessage));
  return;
end

filePattern1 = fullfile(DB, '*.png');


pngFiles1 = dir(filePattern1);
count=0;
global_count=0;

for k = 1:length(pngFiles1)
  baseFileName1 = pngFiles1(k).name;
  fullFileName1 = fullfile(DB, baseFileName1);j=0;
  global_count=global_count+1;
  imageArray1 = imread(fullFileName1);
  [filepath,name,ext] = fileparts(baseFileName1);
  Oimg=imresize(imageArray1,[360 480]);
  imwrite(Oimg,[name,ext]);
%    if k==1
%    break;
%    end
end

