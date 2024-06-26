function fused = post_processing(I)

I_flime=zeros(size(I));
C=I_flime;

if  ~exist( 'mu', 'var' )
    mu = 1;
end

if ~exist( 'a', 'var' )
    a = -0.3293;
end

if ~exist( 'b', 'var' )
    b = 1.1258;
end

if ~isfloat(I)
    I = im2double( I );
   % gt=im2double(gt);
end

lambda = 0.5;
sigma = 5;

Atm_light_d=Alight(im2double(I));
%Atm_light_h=Alight(im2double(gt));

I_g=im2gray(I);
I_b=mean(mean(I_g));

disp('I_b');disp(I_b);

[HS,C_map]=Image_Classification_HS(I,mean(Atm_light_d));

if HS<0.4
    Wg=100;
    disp('No Post-processing Needed');
    
    fused=I;
end



if HS>0.4
    
Wg=1;

% if B_sat1 > 0.3
%     Wg=2;
%     disp('Low Brightness and Contrast');
% end

disp('Low Contrast, ACE is applied to the dehazed image');

LAB = rgb2lab(I);

L = LAB(:,:,1)/100;

%L = adapthisteq(L,'NumTiles',[16 16],'ClipLimit',0.02*Haze_score2);

L = adapthisteq(L,'NumTiles',[16 16],'ClipLimit',0.01);

LAB(:,:,1) = L*100;

C = lab2rgb(LAB);

C=im2uint8(C);

t_b = max( I, [], 3 ); % also work for single-channel image


t_b=t_b.*C_map;

t_our2 = imgaussfilt(t_b,16);

t_our = t_our2;


%% k: exposure ratio
if  ~exist( 'k', 'var' ) || isempty(k)
    isBad = t_our < 0.5;
    J = maxEntropyEnhance(I, isBad);
%     disp('In exposure ratio if');
    %disp('isBad:');disp(isBad);
else
    J = applyK(I, k, a, b); %k
    J = min(J, 1); % fix overflow
%     disp('In exposure ratio else');
end

%% W: Weight Matrix 
t = repmat(t_our, [1 1 size(I,3)]);
W = t.^mu;

I2 = im2double(C).*W;
J2 = im2double(I).*(1-W);

fused=I2 + J2;

% fused=C;

%fused=Haze_score2*C+(1-Haze_score2)*im2uint8(I);

% I_res=C-im2uint8(I);
% 
% fused=im2uint8(I)+((Haze_score2-0.3)/0.7).*I_res;
% 
% disp('Max Residual:');disp(max(max(I_res)));
% 
% imshow(I_res);title('Low Contrast');
% drawnow;
% 
% pause(2);



end



%% t: scene illumination map





% if B_sat1 > 0.28 && Haze_score2>0.28
% 
%     Wg=0.5;
%     
%     %fused = Wg*I_flime+(1-Wg)*C;
%     
%     
%     
%     fused=((B_sat1-0.3).*I_flime+(Haze_score2-0.3).*C)/(B_sat1+Haze_score2-0.6);
%     
%     disp('NBD:');disp(B_sat1); disp('NCD:');disp(Haze_score2);
%     
% end















    function J = maxEntropyEnhance(I, isBad)
        Y = rgb2gm(real(max(imresize(I, [50 50]), 0))); % max - avoid complex number 
        
        if exist('isBad', 'var')
            isBad = (imresize(isBad, [50 50]));
            Y = Y(isBad);
        end
        
        if isempty(Y)
           J = I; % no enhancement k = 1
           return;
        end
        
        opt_k = fminbnd(@(k) ( -entropy(applyK(Y, k)) ),1, 7);
        J = applyK(I, opt_k, a, b) - 0.01;
        %xlswrite(filename,opt_k,'opt_k');
%         disp('opt k:');disp(opt_k);
    end
end

function I = rgb2gm(I)
if size(I,3) == 3
    I = im2double(max(0,I)); % negative double --> complex double
    I = ( I(:,:,1).*I(:,:,2).*I(:,:,3) ).^(1/3);
end
end

function J = applyK(I, k, a, b)

if ~exist( 'a', 'var' )
    a = -0.3293;
end

if ~exist( 'b', 'var' )
    b = 1.1258;
end

%disp('k:');disp(k);

f = @(x)exp((1-x.^a)*b);
beta = f(k);
gamma = k.^a;
J = I.^gamma.*beta;
% disp('gamma:');disp(gamma);
% disp('beta:');disp(beta);
end

function S = tsmooth( I, lambda, sigma, sharpness)
if ( ~exist( 'lambda', 'var' ) )
    lambda = 0.01;
end
if ( ~exist( 'sigma', 'var' ) )
    sigma = 3.0;
end
if ( ~exist( 'sharpness', 'var' ) )
    sharpness = 0.001;
end
% disp('lambda:');disp(lambda);
% disp('sigma:');disp(sigma);
% disp('sharpness:');disp(sharpness);
I = im2double( I );
x = I;
[ wx, wy ] = computeTextureWeights( x, sigma, sharpness);
S = solveLinearEquation( I, wx, wy, lambda );
end

function [ W_h, W_v ] = computeTextureWeights( fin, sigma, sharpness)

dt0_v = [diff(fin,1,1);fin(1,:)-fin(end,:)];
dt0_h = [diff(fin,1,2)';fin(:,1)'-fin(:,end)']';

gauker_h = filter2(ones(1,sigma),dt0_h);
gauker_v = filter2(ones(sigma,1),dt0_v);
W_h = 1./(abs(gauker_h).*abs(dt0_h)+sharpness);
W_v = 1./(abs(gauker_v).*abs(dt0_v)+sharpness);

end

function OUT = solveLinearEquation( IN, wx, wy, lambda )
[ r, c, ch ] = size( IN );
k = r * c;
dx =  -lambda * wx( : );
dy =  -lambda * wy( : );
tempx = [wx(:,end),wx(:,1:end-1)];
tempy = [wy(end,:);wy(1:end-1,:)];
dxa = -lambda *tempx(:);
dya = -lambda *tempy(:);
tempx = [wx(:,end),zeros(r,c-1)];
tempy = [wy(end,:);zeros(r-1,c)];
dxd1 = -lambda * tempx(:);
dyd1 = -lambda * tempy(:);
wx(:,end) = 0;
wy(end,:) = 0;
dxd2 = -lambda * wx(:);
dyd2 = -lambda * wy(:);

Ax = spdiags( [dxd1,dxd2], [-k+r,-r], k, k );
Ay = spdiags( [dyd1,dyd2], [-r+1,-1], k, k );

D = 1 - ( dx + dy + dxa + dya);
A = (Ax+Ay) + (Ax+Ay)' + spdiags( D, 0, k, k );

if exist( 'ichol', 'builtin' )
    L = ichol( A, struct( 'michol', 'on' ) );
    OUT = IN;
    for ii = 1:ch
        tin = IN( :, :, ii );
        [ tout, ~ ] = pcg( A, tin( : ), 0.1, 50, L, L' );
        OUT( :, :, ii ) = reshape( tout, r, c );
    end
else
    OUT = IN;
    for ii = 1:ch
        tin = IN( :, :, ii );
        tout = A\tin( : );
        OUT( :, :, ii ) = reshape( tout, r, c );
    end
end
end





