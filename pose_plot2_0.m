close all
clear all

%% get video parameters and pngs out of the video

videoObject = VideoReader('outout.avi');
	% Determine how many frames there are.
	numberOfFrames1 = videoObject.NumberOfFrames;

    duration1= videoObject.Duration;
    
    ii = 1;

while hasFrame(videoObject)
   img = readFrame(videoObject);
   filename = [sprintf('%3.5d',ii) '.png'];
   fullname = fullfile('pngs',filename);
   imwrite(img,fullname)    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
   ii = ii+1;
end
%

%%


    files1=dir([datapath '*keypoints.json']);
markers={
    'o'
    '*'};
T=length(files1);

% 54 pose points
b1= zeros(T,54,2); 
for person=1:2
    for i=1:T
        
        data = loadjson([files1(i).name]);
        
        a= data.people{person};
        if(iscell(a.pose_keypoints))
            b1(i,:,person)= cell2mat(a.pose_keypoints);
        else
            b1(i,:,person)= a.pose_keypoints;
        end
    end
end
 

%filter data, median filter of order 5
for j=1:2
    b1(:,:,j)=medfilt1(b1(:,:,j),5);
end


%Proximity
for t=1:T
    disp(num2str(t))
    X1=squeeze(b1(t,1:3:end,1));
    Y1=squeeze(b1(t,2:3:end,1));
    X2=squeeze(b1(t,1:3:end,2));
    Y2=squeeze(b1(t,2:3:end,2));
    
     %X1=squeeze(b(t,46,1));
    %Y1=squeeze(b(t,47,1));
    %X2=squeeze(b(t,49,2));
    %Y2=squeeze(b(t,50,2));
    DX1=repmat(X1,length(X1),1);
    DX2=repmat(X2',1,length(X2));
    DX=(DX1-DX2).^2;
    
    DY1=repmat(Y1,length(Y1),1);
    DY2=repmat(Y2',1,length(Y2));
    DY=(DY1-DY2).^2;
    cl(t)=sum(sqrt(DX(:)+DY(:)));
    
end 

cl=2000*cl/max(cl);
 cl=-cl;
%
close all

DSF=10; % downsampling factor
cl_sec=resample(cl,1,DSF);

dstime=1:DSF:length(cl);
figure()
plot(dstime,cl_sec)

[pA pt]=findpeaks(cl_sec,dstime,'MinPeakdistance',50);
[pANEG ptNEG]=findpeaks(-cl_sec,dstime,'MinPeakdistance',50);
%pt=union(pt,ptNEG);

% finding 3 most important positive peaks
t=linspace(0,duration1,numberOfFrames1);
figure(3)
plot(dstime,cl_sec,'LineWidth',2) 
sP={'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'};
yP=cl(pt);
xP=pt;
text(xP,yP,sP)

P_pos=pt([4 7 9]);% 3 major maxima

for pp=1:length(P_pos)
    x=P_pos(pp);
    I=imread(['pngs/' sprintf('%3.5d',x) '.png']);
    subplot(3,3,pp)
    image(I)
    %image('XData',x,'YData',cl(x),'CData',flipud(imresize(I,0.1)))
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    text(300,100,sprintf('%d',pp),'Color','red','Fontsize',14,'FontWeight','bold')
    hold on
    
end

% finding 3 most imortant negative peaks
figure()
plot(dstime,cl_sec,'LineWidth',2) 
s={'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18'};
yt=cl(ptNEG);
xt=ptNEG;
text(xt,yt,s);

P_neg=ptNEG([3 17 18]);% 3 major minima
for pp=1:length(P_neg)
    x=P_neg(pp);
    I=imread(['pngs/' sprintf('%3.5d',x) '.png']);
    subplot(3,3,3+pp)
    image(I)
    %image('XData',x,'YData',cl(x),'CData',flipud(imresize(I,0.1)))
    set(gca,'xtick',[])
     set(gca,'ytick',[])
     text(300,100,sprintf('%d',3+pp),'Color','red','Fontsize',14,'FontWeight','bold')
    hold on
    
end
%
cl=(cl - min(cl)) / ( max(cl) - min(cl) );
subplot(3,3,[7,9]);
plot(t(dstime(2:end-1)),cl(dstime(2:end-1)),'LineWidth',2);title('average proximity between dyad','Fontsize',20)
s={'4','1','2','3','5','6'};
xt=union(P_pos,P_neg);
yt=(cl(xt));
xt=t(union(P_pos,P_neg));
text(xt,yt,s,'Fontsize',20,'FontWeight','bold')
xlabel('time(sec)','Fontsize',20,'FontWeight','bold')
xlim([0 duration1+1])

ylabel('proximity','Fontsize',20,'FontWeight','bold')
set(gca, 'FontSize', 16)

%%


%Proximity between right hands of child and left hands of mother
 RH1= zeros(T,63,2);
for person=1:2
    for i=1:T
        
        data = loadjson([files1(i).name]);
        
        a= data.people{person};
        if(iscell(a.hand_right_keypoints))
            RH1(i,:,person)= cell2mat(a.hand_right_keypoints);
        else
            RH1(i,:,person)= a.hand_left_keypoints;
        end
    end
end

LH1= zeros(T,63,2);
for person=1:2
    for i=1:T
        
        data = loadjson([files1(i).name]);
        
        a= data.people{person};
        if(iscell(a.hand_left_keypoints))
            LH1(i,:,person)= cell2mat(a.hand_left_keypoints);
        else
            LH1(i,:,person)= a.hand_left_keypoints;
        end
    end
end

for j=1:2
    RH1(:,:,j)=medfilt1(RH1(:,:,j),5);
    LH1(:,:,j)=medfilt1(LH1(:,:,j),5);
end


for t=1:T
    disp(num2str(t))
    X1=squeeze(RH1(t,1:3:end,1));
    Y1=squeeze(RH1(t,2:3:end,1));
    X2=squeeze(LH1(t,1:3:end,2));
    Y2=squeeze(LH1(t,2:3:end,2));
    
     %X1=squeeze(b(t,46,1));
    %Y1=squeeze(b(t,47,1));
    %X2=squeeze(b(t,49,2));
    %Y2=squeeze(b(t,50,2));
    DX1=repmat(X1,length(X1),1);
    DX2=repmat(X2',1,length(X2));
    DX=(DX1-DX2).^2;
    
    DY1=repmat(Y1,length(Y1),1);
    DY2=repmat(Y2',1,length(Y2));
    DY=(DY1-DY2).^2;
    cl(t)=sum(sqrt(DX(:)+DY(:)));
    
end 

cl=2000*cl/max(cl);
 cl=-cl;
%
close all

DSF=20; % downsampling factor
cl_sec=resample(cl,1,DSF);

dstime=1:DSF:length(cl);
figure()
plot(dstime,cl_sec)

[pA pt]=findpeaks(cl_sec,dstime,'MinPeakdistance',50);
[pANEG ptNEG]=findpeaks(-cl_sec,dstime,'MinPeakdistance',50);
%pt=union(pt,ptNEG);

% finding 3 most important positive peaks
t=linspace(0,duration1,numberOfFrames1);
figure(3)
plot(dstime,cl_sec,'LineWidth',2) 
sP={'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'};
yP=cl(pt);
xP=pt;
text(xP,yP,sP)

figure()
P_pos=pt([4 7 14]);% 3 major maxima

for pp=1:length(P_pos)
    x=P_pos(pp);
    I=imread(['pngs/' sprintf('%3.5d',x) '.png']);
    subplot(3,3,pp)
    image(I)
    %image('XData',x,'YData',cl(x),'CData',flipud(imresize(I,0.1)))
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    text(300,100,sprintf('%d',pp),'Color','red','Fontsize',14,'FontWeight','bold')
    hold on
    
end

% finding 3 most imortant negative peaks
figure()
plot(dstime,cl_sec,'LineWidth',2) 
s={'1','2','3','4','5','6','7','8','9','10','11','12','13','14'};
yt=cl(ptNEG);
xt=ptNEG;
text(xt,yt,s)

P_neg=ptNEG([2 4 15]);% 3 major minima

P_neg=ptNEG([2 5 14]);
for pp=1:length(P_neg)
    x=P_neg(pp);
    I=imread(['pngs/' sprintf('%3.5d',x) '.png']);
    subplot(3,3,3+pp)
    image(I)
    %image('XData',x,'YData',cl(x),'CData',flipud(imresize(I,0.1)))
    set(gca,'xtick',[])
     set(gca,'ytick',[])
     text(300,100,sprintf('%d',3+pp),'Color','red','Fontsize',14,'FontWeight','bold')
    hold on
    
end
%
cl=(cl - min(cl)) / ( max(cl) - min(cl) );
subplot(3,3,[7,9]);
plot(t(dstime(2:end-1)),cl(dstime(2:end-1)),'LineWidth',2);title('hand proximity between dyad','Fontsize',20)
s={'4','1','5','2','3','6'};
xt=union(P_pos,P_neg);
yt=(cl(xt));
xt=t(union(P_pos,P_neg));
text(xt,yt,s,'Fontsize',20,'FontWeight','bold')
xlabel('time(sec)','Fontsize',20,'FontWeight','bold')
xlim([0 duration1])

ylabel('proximity','Fontsize',20,'FontWeight','bold')
set(gca, 'FontSize', 16)

%% Coupling 

C= b1(:,10:11,1); %Child's right hand
M=b1(:,19:20,2);  %Mother's left hand

win=25;
[Cx,Cy,Cxy]=coupling(C,M,win);
time=linspace(0,duration1,T);
Cxy=(Cxy-min(Cxy))./(max(Cxy)-min(Cxy));
plot(time(2:end),Cxy,'LineWidth',2)
title('hand coupling between dyad')
xlabel('time(sec)','Fontsize',20,'FontWeight','bold')
xlim([0 duration1+1])
yticks([0 0.2 0.4 0.6 0.8 1])
ylabel('coupling','Fontsize',20,'FontWeight','bold')
set(gca, 'FontSize', 16)%% between heads
mean_hand=mean(Cxy);
%%
C= b1(:,46:47,1); %Child's right ear
M=b1(:,49:50,2); %Mother's left ear
[Cx,Cy,Cxy]=coupling(C,M,win);
time=linspace(0,duration1,T);
Cxy=(Cxy-min(Cxy))./(max(Cxy)-min(Cxy));

plot(time(2:end),Cxy,'LineWidth',2)
title('head coupling between dyad')

xlabel('time(sec)','Fontsize',20,'FontWeight','bold')
xlim([0 duration1+1])
yticks([0 0.2 0.4 0.6 0.8 1])
ylabel('coupling','Fontsize',20,'FontWeight','bold')
set(gca, 'FontSize', 16)%% between heads

mean_head= mean(Cxy);
