close all
clear all



% Copying jSON files
addpath('/Users/harshit/Desktop/openpose/incompV/');
datapath= '/Users/harshit/Desktop/openpose/incompV/';

    files1=dir([datapath '*keypoints.json']);

% get video parameters 

videoObject = VideoReader('output.avi');
	% Determine how many frames there are.
	numberOfFrames1 = videoObject.NumberOfFrames;

    duration1= videoObject.Duration;
    

% reading points
T=numberOfFrames1;
b1= zeros(T,210); 
% point 9765 copied from  9764 since it was empty
    for i=1:T
        
        data = loadjson([files1(i).name]);
        
        a= data.people;
        if(iscell(a{1,1}.face_keypoints))
            b1(i,:)= cell2mat(a{1,1}.face_keypoints);
        else
            b1(i,:)= a{1,1}.face_keypoints;
        end
    end

%downsampling and median filtering
    b = downsample(b1,50);
    b_x=b(:,1:3:end);
    b_y=b(:,2:3:end);
    b_x=medfilt1(b_x,5);
    b_y=medfilt1(b_y,5);
 
%% ------------------------Part1---------------------------------
% distance matrix
N=length(b);
dimatrix=zeros(70,70,N);
for i=1:N
    for j=1:70
        for k=1:70
       d(j,k)=sqrt((b_x(i,j)-b_x(i,k)).^2+(b_y(i,j)-b_y(i,k)).^2);
        end
    end
    dimatrix(:,:,i)=d;
   
end
    
% visualize matrix for each second
for i=1:N
 image(dimatrix(:,:,i))
 colorbar
title(sprintf('%d sec',i))
 pause;
end

% distance between upper and lower lips
dis=dimatrix(63,67,:);
dis=(dis-mean(dis))/(max(dis)-min(dis));
plot(squeeze(dis))


% PCA of derivatives
td1=diff(b_x);
td2=diff(b_y);
td=sqrt(td1.^2+td2.^2);
[coeff,score,latent] = pca(td);


% Plot PCA1 on face
ba=mean(b);%mean position of points
for t=48
    figure(1)
    I=imread([sprintf('%3.5d',t) '.png']);
    image(I)
    title('PCA1 components for derivatives')
    hold on
        for cID=1:70
            
            i=P(cID,1);
            d=ba((1:2)+(i-1)*3);
        
            scatter(d(1)+50,d(2)+10,2000*coeff(cID,1),'filled');
            hold on
        end
    
end
%% Mega matrix (distance between pairs)(number of links between nodes)
M=cell(1,1000);
k=1;
%different pairs for all points
for i=1:69
    for j=i+1:70
       M{1,k}={i,j};
       k=k+1;
    end
end
% Mega matrix calculation
k=1;
for i=1:69
    for j=i+1:70
        megdis(:,k)=sqrt((b_x(:,i)-b_x(:,j)).^2 +(b_y(:,i)-b_y(:,j)).^2 );
        k=k+1;
    end
end

%
[coeff] = pca(megdis);

[M1,I1]=sort(coeff(:,100),'descend'); %PCA1 indices
L=100;%number of point pairs
for i=1:P %Select 100 Major pair components along PCA1
    p=M{1,I1(i)};%points on the face
    P(i,:)=cell2mat(p);
end

% Plot PCA1 on face

ba=mean(b);%mean position of points
for t=48
    figure(1)
    I=imread([sprintf('%3.5d',t) '.png']);
    image(I)
    title('PCA1 major components')
    hold on
        for cID=1:L
            
            i=P(cID,1);
            d=ba((1:2)+(i-1)*3);
        
            scatter(d(1)+50,d(2)+10,2000*M1(cID),'filled');
            hold on
            i=P(cID,2);
            d=ba((1:2)+(i-1)*3);
           
            scatter(d(1)+30,d(2)+10,2000*M1(cID),'filled');
            hold on
        end
    
end
axis equal

% Plot PCA2

[M1,I1]=sort(coeff(:,2),'descend'); %PCA2 indices
L=100;%number of point pairs
for i=1:P %Select 100 Major pair components along PCA2
    p=M{1,I1(i)};%points on the face
    P(i,:)=cell2mat(p);
end

% Plot PCA2 on face

ba=mean(b);%mean position of points
for t=48
    figure(2)
    I=imread([sprintf('%3.5d',t) '.png']);
    image(I)
    title('PCA2 major components')
    hold on
        for cID=1:L
            
            i=P(cID,1);
            d=ba((1:2)+(i-1)*3);
        
            scatter(d(1)+50,d(2)+10,2000*M1(cID),'filled');
            hold on
            i=P(cID,2);
            d=ba((1:2)+(i-1)*3);
           
            scatter(d(1)+30,d(2)+10,2000*M1(cID),'filled');
            hold on
        end
    
end
axis equal


