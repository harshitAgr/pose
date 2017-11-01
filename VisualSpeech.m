%% X and Y (downsampled by 50, meadian filtered with order 5)

%downsampling and median filtering


    b = downsample(b1,50);
    b_x=b(:,1:3:end);% x points
    b_y=b(:,2:3:end);% y points
    b_x=medfilt1(b_x,5); %median filter
    b_y=medfilt1(b_y,5); %median filter
    
    z_x=zscore(b_x);
    z_y=zscore(b_y);
  Points=[19,24,51,57,48,54,0,16]+1;
  txt={"right eyebrow_Y","left eyebrow_Y","upper lip_Y","lower lip_Y","lip rightmost_X","lip leftmost_X"};

  %A   
 M=[z_y(:,20) z_y(:,25) z_y(:,52) z_y(:,58) z_x(:,49) z_x(:,55)];
   plot((M+repmat(5*[1:6],479,1))) 
title('X & Y movements')
xlabel('time(sec)')

%B
 
imagesc(corr(M))
title('correlation matrix between 6 points')
colorbar
xticks([1 2 3 4 5 6])
xticklabels(txt)
yticks([1 2 3 4 5 6])
yticklabels(txt)

%% B