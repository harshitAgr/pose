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
 
imagesc(corr(M),[-1,1])
title('correlation matrix between 6 points')
colorbar
xticks([1 2 3 4 5 6])
xticklabels(txt)
yticks([1 2 3 4 5 6])
yticklabels(txt)

%% B
n=length(M);
% regress with right ear
[c,bint,r] = regress(M(:,1),[z_y(:,1) ones(n,1)]);
R(:,1)=r;
[c,bint,r] = regress(M(:,2),[z_y(:,1) ones(n,1)]);
R(:,2)=r;
[c,bint,r] = regress(M(:,3),[z_y(:,1) ones(n,1)]);
R(:,3)=r;
[c,bint,r] = regress(M(:,4),[z_y(:,1) ones(n,1)]);
R(:,4)=r;
[c,bint,r] = regress(M(:,5),[z_x(:,1) ones(n,1)]);
R(:,5)=r;
[c,bint,r] = regress(M(:,6),[z_x(:,1) ones(n,1)]);
R(:,6)=r;
plot((R+repmat(5*[1:6],479,1))) 
title('X & Y movements regressed with right ear')
xlabel('time(sec)')
% correlation matrix
figure(1)
imagesc(corr(R),[-1,1])
title('correlation matrix (regressed with right ear)')
colorbar
xticks([1 2 3 4 5 6])
xticklabels(txt)
yticks([1 2 3 4 5 6])
yticklabels(txt)


%% regression with left ear
[c,bint,r] = regress(M(:,1),[z_y(:,17) ones(n,1)]);
R(:,1)=r;
[c,bint,r] = regress(M(:,2),[z_y(:,17) ones(n,1)]);
R(:,2)=r;
[c,bint,r] = regress(M(:,3),[z_y(:,17) ones(n,1)]);
R(:,3)=r;
[c,bint,r] = regress(M(:,4),[z_y(:,17) ones(n,1)]);
R(:,4)=r;
[c,bint,r] = regress(M(:,5),[z_x(:,17) ones(n,1)]);
R(:,5)=r;
[c,bint,r] = regress(M(:,6),[z_x(:,17) ones(n,1)]);
R(:,6)=r;
plot((R+repmat(5*[1:6],479,1))) 
title('X & Y movements regressed with left ear')
xlabel('time(sec)')
% correlation matrix
figure(2)
imagesc(corr(R),[-1,1])
title('correlation matrix (regressed with left ear)')
colorbar
xticks([1 2 3 4 5 6])
xticklabels(txt)
yticks([1 2 3 4 5 6])
yticklabels(txt)


%% regression with global signal Full average
G=mean([z_x z_y],2);
[c,bint,r] = regress(M(:,1),[G,ones(n,1)]);
R(:,1)=r;
[c,bint,r] = regress(M(:,2),[G,ones(n,1)]);
R(:,2)=r;
[c,bint,r] = regress(M(:,3),[G,ones(n,1)]);
R(:,3)=r;
[c,bint,r] = regress(M(:,4),[G,ones(n,1)]);
R(:,4)=r;
[c,bint,r] = regress(M(:,5),[G,ones(n,1)]);
R(:,5)=r;
[c,bint,r] = regress(M(:,6),[G,ones(n,1)]);
R(:,6)=r;
plot((R+repmat(5*[1:6],479,1))) 
title('X & Y movements regressed with global signal(Full average)')
xlabel('time(sec)')
% correlation matrix
imagesc(corr(R),[-1,1])
title('correlation matrix (regressed full global average)')
colorbar
xticks([1 2 3 4 5 6])
xticklabels(txt)
yticks([1 2 3 4 5 6])
yticklabels(txt)


%% Regression with Global average of six time series
G=mean(M,2);
[c,bint,r] = regress(M(:,1),[G ones(n,1)]);
R(:,1)=r;
[c,bint,r] = regress(M(:,2),[G ones(n,1)]);
R(:,2)=r;
[c,bint,r] = regress(M(:,3),[G ones(n,1)]);
R(:,3)=r;
[c,bint,r] = regress(M(:,4),[G ones(n,1)]);
R(:,4)=r;
[c,bint,r] = regress(M(:,5),[G ones(n,1)]);
R(:,5)=r;
[c,bint,r] = regress(M(:,6),[G ones(n,1)]);
R(:,6)=r;
plot((R+repmat(5*[1:6],479,1))) 
title('X & Y movements regressed with global signal(six time series)')
xlabel('time(sec)')
% correlation matrix
imagesc(corr(R),[-1,1])
title('correlation matrix (regressed average of 6 timeseries)')
colorbar
xticks([1 2 3 4 5 6])
xticklabels(txt)
yticks([1 2 3 4 5 6])
yticklabels(txt)

%% derivatives
D=diff(M);
n=length(M);
imagesc(corr(D),[-1,1])
title('correlation matrix between derivatives')
colorbar
xticks([1 2 3 4 5 6])
xticklabels(txt)
yticks([1 2 3 4 5 6])
yticklabels(txt)


% regress with right ear
[c,bint,r] = regress(M(:,1),[z_y(:,1) ones(n,1)]);
R(:,1)=r;
[c,bint,r] = regress(M(:,2),[z_y(:,1) ones(n,1)]);
R(:,2)=r;
[c,bint,r] = regress(M(:,3),[z_y(:,1) ones(n,1)]);
R(:,3)=r;
[c,bint,r] = regress(M(:,4),[z_y(:,1) ones(n,1)]);
R(:,4)=r;
[c,bint,r] = regress(M(:,5),[z_x(:,1) ones(n,1)]);
R(:,5)=r;
[c,bint,r] = regress(M(:,6),[z_x(:,1) ones(n,1)]);
R(:,6)=r;
plot((R+repmat(5*[1:6],n,1))) 
title('X & Y movements regressed with right ear')
xlabel('time(sec)')
R=diff(R);
% correlation matrix
figure(1)
imagesc(corr(R),[-1,1])
title('derivative correlation matrix (regressed with right ear)')
colorbar
xticks([1 2 3 4 5 6])
xticklabels(txt)
yticks([1 2 3 4 5 6])
yticklabels(txt)

