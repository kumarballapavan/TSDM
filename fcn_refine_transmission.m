function [ trans_map ] = fcn_refine_transmission(I, trans_map, r, mean_I, var_I, N )
% Function for transmission refinement
A=size(I);
%format long I1
%I1=I./N;
%disp('I1:');disp(I1);
%I2=I1*N;

%disp('A(1)');disp(A(1));disp('A(2)');disp(A(2));
    mean_I = boxfilter(I, r)./ N;
    %figure(1);imshow(mean_I);title('mean I');
    
    mean_II = boxfilter(I.*I, r) ./ N;
%figure(2);imshow(mean_II);title('mean II');
    
var_I = mean_II - mean_I .* mean_I;
%figure(3);imshow(var_I);title('var I');
   
mean_t = boxfilter(trans_map, r) ./ N;
    %mean_t=colfilt(trans_map, [2*r+1, 2*r+1], 'sliding', @sum)./N;
    %figure(4);imshow(mean_t);title('mean t');
    
    mean_It = boxfilter(I.*trans_map, r) ./ N;
    %mean_It=colfilt(I.*trans_map, [2*r+1, 2*r+1], 'sliding', @sum)./N;
    %figure(5);imshow(mean_It);title('mean I*trans');
    
    cov_It = mean_It - mean_I .* mean_t;
    %figure(6);imshow(cov_It);title('cov It');% this is the covariance of (I, p) in each local patch.
    
    at = cov_It ./ (var_I + 0.00001);
    %figure(7);imshow(at);title('at');
    
    bt = mean_t - at.* mean_I;
    %figure(8);imshow(bt);title('bt');
    
    mean_at = boxfilter(at, r) ./ N;
    %mean_at=colfilt(at, [2*r+1, 2*r+1], 'sliding', @sum)./N;
   % for i=1:A(1)
    %    for j=1:A(2)
     %       if mean_at(i,j)=='NaN'
      %      mean_at(:,:)=0;
       %     disp('i:');disp(i);disp('j:');disp(j);
        %    end
    %    end
    %end
%    disp('size of mean_at:');disp(size(mean_at));
   
     %figure(9);imshow(mean_at);title('mean at');
   
     mean_bt = boxfilter(bt, r) ./ N;
     %mean_bt=colfilt(bt, [2*r+1, 2*r+1], 'sliding', @sum)./N;
     
     %figure(10);imshow(mean_bt);title('mean bt');
   
     %writematrix(mean_bt,'mean_bt.xls');
    qt = mean_at .* I + mean_bt;
    
    %disp('size of mean_at:');disp(size(mean_at));
    trans_map = qt;
    %disp(size(trans_map));
    %figure(3);
%imshow(trans_map);
%title('Transmission refined');

end

