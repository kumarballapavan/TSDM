function [Haze_score3,tallimage1]=Image_Classification_HS(I,Atm_Light)


I=im2double(I);


block_size=20;



I2=I;

[Oimgpart1, OimgR, OimgC]=blocks(I2,block_size);

Oimgpart1=im2uint8(Oimgpart1);

parts=OimgR*OimgC;

Odiff2= zeros(size(Oimgpart1));
B_Map_d= zeros(size(Oimgpart1));
C_Map_d= zeros(size(Oimgpart1));
HDE_d=zeros(size(Oimgpart1));


part=1:parts;Red_blocks=0;ctr=1;Red_buffer=zeros(1,parts);all_count=0;


Contrast1Oimg_d= zeros(3,parts);
%  Contrast2Oimg= zeros(3,parts);
 MeanOimg_d= zeros(3,parts);
 Contrast1Oimg_h= zeros(3,parts);
  MeanOimg_h= zeros(3,parts);
  
  HDEOimg_d=zeros(1,parts);
  HDEOimg_h=zeros(1,parts);

 B_sat1=0;B_sat2=0;Haze_score1=0;Haze_score2=0;Haze_score3=0;
Contrast_hazy=0;I_b_count=0;
count=0; B_count=0; C_count=0; O_count=0;
 for i=1:parts
   
        
    count=count+1;
    
    Contrast1Oimg_d(:,i)=max(max(Oimgpart1(:,:,:,i)))-min(min(Oimgpart1(:,:,:,i)));%This may be hazy image
    Contrast_local=mean(Contrast1Oimg_d(:,i));
    Contrast_hazy=Contrast_hazy+Contrast_local./parts;

    MeanOimg_d(:,i) = mean(mean(Oimgpart1(:,:,:,i)));

        
        B_dehazed=mean(MeanOimg_d(:,i))./255;
        C_dehazed=mean(Contrast1Oimg_d(:,i))./255;

        
        Haze3=(max(0.004,abs(1-C_dehazed)))*(max(0.004,B_dehazed))/(Atm_Light);
        

        
        Haze_score3=Haze3+Haze_score3;
        
        Haze3_C=(max(0.004,abs(1-C_dehazed)));
        
        for k=1:block_size
            for l=1:block_size
                C_Map_d(k,l,:,i)=Haze3_C;
            end            
        end
        

    
      
    
 end


disp('Atm_Light');disp(Atm_Light);



Haze_score3=(Haze_score3/432);


 
  disp('Haze score:');disp(Haze_score3);

wideimage1=[C_Map_d(:,:,:,1), C_Map_d(:,:,:,2),C_Map_d(:,:,:,3), C_Map_d(:,:,:,4),C_Map_d(:,:,:,5), C_Map_d(:,:,:,6),C_Map_d(:,:,:,7), C_Map_d(:,:,:,8),C_Map_d(:,:,:,9), C_Map_d(:,:,:,10),C_Map_d(:,:,:,11), C_Map_d(:,:,:,12),C_Map_d(:,:,:,13), C_Map_d(:,:,:,14),C_Map_d(:,:,:,15), C_Map_d(:,:,:,16),C_Map_d(:,:,:,17), C_Map_d(:,:,:,18),C_Map_d(:,:,:,19), C_Map_d(:,:,:,20),C_Map_d(:,:,:,21), C_Map_d(:,:,:,22),C_Map_d(:,:,:,23), C_Map_d(:,:,:,24)];
wideimage2=[C_Map_d(:,:,:,25), C_Map_d(:,:,:,26),C_Map_d(:,:,:,27), C_Map_d(:,:,:,28),C_Map_d(:,:,:,29), C_Map_d(:,:,:,30),C_Map_d(:,:,:,31), C_Map_d(:,:,:,32),C_Map_d(:,:,:,33), C_Map_d(:,:,:,34),C_Map_d(:,:,:,35), C_Map_d(:,:,:,36),C_Map_d(:,:,:,37), C_Map_d(:,:,:,38),C_Map_d(:,:,:,39), C_Map_d(:,:,:,40),C_Map_d(:,:,:,41), C_Map_d(:,:,:,42),C_Map_d(:,:,:,43), C_Map_d(:,:,:,44),C_Map_d(:,:,:,45), C_Map_d(:,:,:,46),C_Map_d(:,:,:,47), C_Map_d(:,:,:,48)];
wideimage3=[C_Map_d(:,:,:,49), C_Map_d(:,:,:,50),C_Map_d(:,:,:,51), C_Map_d(:,:,:,52),C_Map_d(:,:,:,53), C_Map_d(:,:,:,54),C_Map_d(:,:,:,55), C_Map_d(:,:,:,56),C_Map_d(:,:,:,57), C_Map_d(:,:,:,58),C_Map_d(:,:,:,59), C_Map_d(:,:,:,60),C_Map_d(:,:,:,61), C_Map_d(:,:,:,62),C_Map_d(:,:,:,63), C_Map_d(:,:,:,64),C_Map_d(:,:,:,65), C_Map_d(:,:,:,66),C_Map_d(:,:,:,67), C_Map_d(:,:,:,68),C_Map_d(:,:,:,69), C_Map_d(:,:,:,70),C_Map_d(:,:,:,71), C_Map_d(:,:,:,72)];
wideimage4=[C_Map_d(:,:,:,73), C_Map_d(:,:,:,74),C_Map_d(:,:,:,75), C_Map_d(:,:,:,76),C_Map_d(:,:,:,77), C_Map_d(:,:,:,78),C_Map_d(:,:,:,79), C_Map_d(:,:,:,80),C_Map_d(:,:,:,81), C_Map_d(:,:,:,82),C_Map_d(:,:,:,83), C_Map_d(:,:,:,84),C_Map_d(:,:,:,85), C_Map_d(:,:,:,86),C_Map_d(:,:,:,87), C_Map_d(:,:,:,88),C_Map_d(:,:,:,89), C_Map_d(:,:,:,90),C_Map_d(:,:,:,91), C_Map_d(:,:,:,92),C_Map_d(:,:,:,93), C_Map_d(:,:,:,94),C_Map_d(:,:,:,95), C_Map_d(:,:,:,96)];
wideimage5=[C_Map_d(:,:,:,97), C_Map_d(:,:,:,98),C_Map_d(:,:,:,99), C_Map_d(:,:,:,100),C_Map_d(:,:,:,101), C_Map_d(:,:,:,102),C_Map_d(:,:,:,103), C_Map_d(:,:,:,104),C_Map_d(:,:,:,105), C_Map_d(:,:,:,106),C_Map_d(:,:,:,107), C_Map_d(:,:,:,108),C_Map_d(:,:,:,109), C_Map_d(:,:,:,110),C_Map_d(:,:,:,111), C_Map_d(:,:,:,112),C_Map_d(:,:,:,113), C_Map_d(:,:,:,114),C_Map_d(:,:,:,115), C_Map_d(:,:,:,116),C_Map_d(:,:,:,117), C_Map_d(:,:,:,118),C_Map_d(:,:,:,119), C_Map_d(:,:,:,120)];
wideimage6=[C_Map_d(:,:,:,121), C_Map_d(:,:,:,122),C_Map_d(:,:,:,123), C_Map_d(:,:,:,124),C_Map_d(:,:,:,125), C_Map_d(:,:,:,126),C_Map_d(:,:,:,127), C_Map_d(:,:,:,128),C_Map_d(:,:,:,129), C_Map_d(:,:,:,130),C_Map_d(:,:,:,131), C_Map_d(:,:,:,132),C_Map_d(:,:,:,133), C_Map_d(:,:,:,134),C_Map_d(:,:,:,135), C_Map_d(:,:,:,136),C_Map_d(:,:,:,137), C_Map_d(:,:,:,138),C_Map_d(:,:,:,139), C_Map_d(:,:,:,140),C_Map_d(:,:,:,141), C_Map_d(:,:,:,142),C_Map_d(:,:,:,143), C_Map_d(:,:,:,144)];
wideimage7=[C_Map_d(:,:,:,145), C_Map_d(:,:,:,146),C_Map_d(:,:,:,147), C_Map_d(:,:,:,148),C_Map_d(:,:,:,149), C_Map_d(:,:,:,150),C_Map_d(:,:,:,151), C_Map_d(:,:,:,152),C_Map_d(:,:,:,153), C_Map_d(:,:,:,154),C_Map_d(:,:,:,155), C_Map_d(:,:,:,156),C_Map_d(:,:,:,157), C_Map_d(:,:,:,158),C_Map_d(:,:,:,159), C_Map_d(:,:,:,160),C_Map_d(:,:,:,161), C_Map_d(:,:,:,162),C_Map_d(:,:,:,163), C_Map_d(:,:,:,164),C_Map_d(:,:,:,165), C_Map_d(:,:,:,166),C_Map_d(:,:,:,167), C_Map_d(:,:,:,168)];
wideimage8=[C_Map_d(:,:,:,169), C_Map_d(:,:,:,170),C_Map_d(:,:,:,171), C_Map_d(:,:,:,172),C_Map_d(:,:,:,173), C_Map_d(:,:,:,174),C_Map_d(:,:,:,175), C_Map_d(:,:,:,176),C_Map_d(:,:,:,177), C_Map_d(:,:,:,178),C_Map_d(:,:,:,179), C_Map_d(:,:,:,180),C_Map_d(:,:,:,181), C_Map_d(:,:,:,182),C_Map_d(:,:,:,183), C_Map_d(:,:,:,184),C_Map_d(:,:,:,185), C_Map_d(:,:,:,186),C_Map_d(:,:,:,187), C_Map_d(:,:,:,188),C_Map_d(:,:,:,189), C_Map_d(:,:,:,190),C_Map_d(:,:,:,191), C_Map_d(:,:,:,192)];
wideimage9=[C_Map_d(:,:,:,193), C_Map_d(:,:,:,194),C_Map_d(:,:,:,195), C_Map_d(:,:,:,196),C_Map_d(:,:,:,197), C_Map_d(:,:,:,198),C_Map_d(:,:,:,199), C_Map_d(:,:,:,200),C_Map_d(:,:,:,201), C_Map_d(:,:,:,202),C_Map_d(:,:,:,203), C_Map_d(:,:,:,204),C_Map_d(:,:,:,205), C_Map_d(:,:,:,206),C_Map_d(:,:,:,207), C_Map_d(:,:,:,208),C_Map_d(:,:,:,209), C_Map_d(:,:,:,210),C_Map_d(:,:,:,211), C_Map_d(:,:,:,212),C_Map_d(:,:,:,213), C_Map_d(:,:,:,214),C_Map_d(:,:,:,215), C_Map_d(:,:,:,216)];
wideimage10=[C_Map_d(:,:,:,217), C_Map_d(:,:,:,218),C_Map_d(:,:,:,219), C_Map_d(:,:,:,220),C_Map_d(:,:,:,221), C_Map_d(:,:,:,222),C_Map_d(:,:,:,223), C_Map_d(:,:,:,224),C_Map_d(:,:,:,225), C_Map_d(:,:,:,226),C_Map_d(:,:,:,227), C_Map_d(:,:,:,228),C_Map_d(:,:,:,229), C_Map_d(:,:,:,230),C_Map_d(:,:,:,231), C_Map_d(:,:,:,232),C_Map_d(:,:,:,233), C_Map_d(:,:,:,234),C_Map_d(:,:,:,235), C_Map_d(:,:,:,236),C_Map_d(:,:,:,237), C_Map_d(:,:,:,238),C_Map_d(:,:,:,239), C_Map_d(:,:,:,240)];
wideimage11=[C_Map_d(:,:,:,241), C_Map_d(:,:,:,242),C_Map_d(:,:,:,243), C_Map_d(:,:,:,244),C_Map_d(:,:,:,245), C_Map_d(:,:,:,246),C_Map_d(:,:,:,247), C_Map_d(:,:,:,248),C_Map_d(:,:,:,249), C_Map_d(:,:,:,250),C_Map_d(:,:,:,251), C_Map_d(:,:,:,252),C_Map_d(:,:,:,253), C_Map_d(:,:,:,254),C_Map_d(:,:,:,255), C_Map_d(:,:,:,256),C_Map_d(:,:,:,257), C_Map_d(:,:,:,258),C_Map_d(:,:,:,259), C_Map_d(:,:,:,260),C_Map_d(:,:,:,261), C_Map_d(:,:,:,262),C_Map_d(:,:,:,263), C_Map_d(:,:,:,264)];
wideimage12=[C_Map_d(:,:,:,265), C_Map_d(:,:,:,266),C_Map_d(:,:,:,267), C_Map_d(:,:,:,268),C_Map_d(:,:,:,269), C_Map_d(:,:,:,270),C_Map_d(:,:,:,271), C_Map_d(:,:,:,272),C_Map_d(:,:,:,273), C_Map_d(:,:,:,274),C_Map_d(:,:,:,275), C_Map_d(:,:,:,276),C_Map_d(:,:,:,277), C_Map_d(:,:,:,278),C_Map_d(:,:,:,279), C_Map_d(:,:,:,280),C_Map_d(:,:,:,281), C_Map_d(:,:,:,282),C_Map_d(:,:,:,283), C_Map_d(:,:,:,284),C_Map_d(:,:,:,285), C_Map_d(:,:,:,286),C_Map_d(:,:,:,287), C_Map_d(:,:,:,288)];
wideimage13=[C_Map_d(:,:,:,289), C_Map_d(:,:,:,290),C_Map_d(:,:,:,291), C_Map_d(:,:,:,292),C_Map_d(:,:,:,293), C_Map_d(:,:,:,294),C_Map_d(:,:,:,295), C_Map_d(:,:,:,296),C_Map_d(:,:,:,297), C_Map_d(:,:,:,298),C_Map_d(:,:,:,299), C_Map_d(:,:,:,300),C_Map_d(:,:,:,301), C_Map_d(:,:,:,302),C_Map_d(:,:,:,303), C_Map_d(:,:,:,304),C_Map_d(:,:,:,305), C_Map_d(:,:,:,306),C_Map_d(:,:,:,307), C_Map_d(:,:,:,308),C_Map_d(:,:,:,309), C_Map_d(:,:,:,310),C_Map_d(:,:,:,311), C_Map_d(:,:,:,312)];
wideimage14=[C_Map_d(:,:,:,313), C_Map_d(:,:,:,314),C_Map_d(:,:,:,315), C_Map_d(:,:,:,316),C_Map_d(:,:,:,317), C_Map_d(:,:,:,318),C_Map_d(:,:,:,319), C_Map_d(:,:,:,320),C_Map_d(:,:,:,321), C_Map_d(:,:,:,322),C_Map_d(:,:,:,323), C_Map_d(:,:,:,324),C_Map_d(:,:,:,325), C_Map_d(:,:,:,326),C_Map_d(:,:,:,327), C_Map_d(:,:,:,328),C_Map_d(:,:,:,329), C_Map_d(:,:,:,330),C_Map_d(:,:,:,331), C_Map_d(:,:,:,332),C_Map_d(:,:,:,333), C_Map_d(:,:,:,334),C_Map_d(:,:,:,335), C_Map_d(:,:,:,336)];
wideimage15=[C_Map_d(:,:,:,337), C_Map_d(:,:,:,338),C_Map_d(:,:,:,339), C_Map_d(:,:,:,340),C_Map_d(:,:,:,341), C_Map_d(:,:,:,342),C_Map_d(:,:,:,343), C_Map_d(:,:,:,344),C_Map_d(:,:,:,345), C_Map_d(:,:,:,346),C_Map_d(:,:,:,347), C_Map_d(:,:,:,348),C_Map_d(:,:,:,349), C_Map_d(:,:,:,350),C_Map_d(:,:,:,351), C_Map_d(:,:,:,352),C_Map_d(:,:,:,353), C_Map_d(:,:,:,354),C_Map_d(:,:,:,355), C_Map_d(:,:,:,356),C_Map_d(:,:,:,357), C_Map_d(:,:,:,358),C_Map_d(:,:,:,359), C_Map_d(:,:,:,360)];
wideimage16=[C_Map_d(:,:,:,361), C_Map_d(:,:,:,362),C_Map_d(:,:,:,363), C_Map_d(:,:,:,364),C_Map_d(:,:,:,365), C_Map_d(:,:,:,366),C_Map_d(:,:,:,367), C_Map_d(:,:,:,368),C_Map_d(:,:,:,369), C_Map_d(:,:,:,370),C_Map_d(:,:,:,371), C_Map_d(:,:,:,372),C_Map_d(:,:,:,373), C_Map_d(:,:,:,374),C_Map_d(:,:,:,375), C_Map_d(:,:,:,376),C_Map_d(:,:,:,377), C_Map_d(:,:,:,378),C_Map_d(:,:,:,379), C_Map_d(:,:,:,380),C_Map_d(:,:,:,381), C_Map_d(:,:,:,382),C_Map_d(:,:,:,383), C_Map_d(:,:,:,384)];
wideimage17=[C_Map_d(:,:,:,385), C_Map_d(:,:,:,386),C_Map_d(:,:,:,387), C_Map_d(:,:,:,388),C_Map_d(:,:,:,389), C_Map_d(:,:,:,390),C_Map_d(:,:,:,391), C_Map_d(:,:,:,392),C_Map_d(:,:,:,393), C_Map_d(:,:,:,394),C_Map_d(:,:,:,395), C_Map_d(:,:,:,396),C_Map_d(:,:,:,397), C_Map_d(:,:,:,398),C_Map_d(:,:,:,399), C_Map_d(:,:,:,400),C_Map_d(:,:,:,401), C_Map_d(:,:,:,402),C_Map_d(:,:,:,403), C_Map_d(:,:,:,404),C_Map_d(:,:,:,405), C_Map_d(:,:,:,406),C_Map_d(:,:,:,407), C_Map_d(:,:,:,408)];
wideimage18=[C_Map_d(:,:,:,409), C_Map_d(:,:,:,410),C_Map_d(:,:,:,411), C_Map_d(:,:,:,412),C_Map_d(:,:,:,413), C_Map_d(:,:,:,414),C_Map_d(:,:,:,415), C_Map_d(:,:,:,416),C_Map_d(:,:,:,417), C_Map_d(:,:,:,418),C_Map_d(:,:,:,419), C_Map_d(:,:,:,420),C_Map_d(:,:,:,421), C_Map_d(:,:,:,422),C_Map_d(:,:,:,423), C_Map_d(:,:,:,424),C_Map_d(:,:,:,425), C_Map_d(:,:,:,426),C_Map_d(:,:,:,427), C_Map_d(:,:,:,428),C_Map_d(:,:,:,429), C_Map_d(:,:,:,430),C_Map_d(:,:,:,431), C_Map_d(:,:,:,432)];

tallimage1=[wideimage1;wideimage2;wideimage3;wideimage4;wideimage5;wideimage6;wideimage7;wideimage8;wideimage9;wideimage10;wideimage11;wideimage12;wideimage13;wideimage14;wideimage15;wideimage16;wideimage17;wideimage18];

tallimage1=im2gray(tallimage1);



end

