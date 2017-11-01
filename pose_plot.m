clear all
close all

%addpath(genpath('external'))

%%getting whole data in matrix from

files=dir('*pose.json');
markers={
    'o'
    '*'};
T=length(files);
b= zeros(T,54,2); % 210 for faces
for person=1:2
    
    for i=1:T
        
        data = loadjson([files(i).name]);
        
        a= data.people{person};
        if(iscell(a.body_parts))
            b(i,:,person)= cell2mat(a.body_parts);
        else
            b(i,:,person)= a.body_parts;
        end
    end
end

%% Proximity(Overall)
for t=1:T
    disp(num2str(t))
    X1=squeeze(b(t,1:3:end,1));
    Y1=squeeze(b(t,2:3:end,1));
    X2=squeeze(b(t,1:3:end,2));
    Y2=squeeze(b(t,2:3:end,2));
    
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
plot(dstime,cl_sec)

[pA pt]=findpeaks(cl_sec,dstime,'MinPeakdistance',50);
[pANEG ptNEG]=findpeaks(-cl_sec,dstime,'MinPeakdistance',50);
%pt=union(pt,ptNEG);

% finding 3 most important positive peaks
close all
figure(3)
%plot(dstime,cl_sec,'LineWidth',2) 
%sP={'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17'};
%yP=cl(pt);
%xP=pt;
%text(xP,yP,sP)
P_pos=pt([5 8 16]);% 3 major maxima

for pp=1:length(P_pos)
    x=P_pos(pp);
    I=imread(['pngs/output_' sprintf('%3.5d',x) '.png']);
    subplot(3,3,pp)
    image(I)
    %image('XData',x,'YData',cl(x),'CData',flipud(imresize(I,0.1)))
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    text(300,100,sprintf('%d',pp),'Color','red','Fontsize',14,'FontWeight','bold')
    hold on
    
end

% finding 3 most imortant negative peaks

%plot(dstime,cl_sec,'LineWidth',2) 
%s={'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19'};
%yt=cl(ptNEG);
%xt=ptNEG;
%text(xt,yt,s)

P_neg=ptNEG([2 8 18]);% 3 major minima
for pp=1:length(P_neg)
    x=P_neg(pp);
    I=imread(['pngs/output_' sprintf('%3.5d',x) '.png']);
    subplot(3,3,3+pp)
    image(I)
    %image('XData',x,'YData',cl(x),'CData',flipud(imresize(I,0.1)))
    set(gca,'xtick',[])
     set(gca,'ytick',[])
     text(300,100,sprintf('%d',3+pp),'Color','red','Fontsize',14,'FontWeight','bold')
    hold on
    
end


subplot(3,3,[7,9]);
plot(dstime,cl_sec,'LineWidth',2);title('average proximity between Dyad')
s={'4','1','5','2','3','6'};
xt=union(P_pos,P_neg);
yt=(cl(xt));
text(xt,yt,s,'Fontsize',14,'FontWeight','bold')
xlabel('time(frames)','Fontsize',12,'FontWeight','bold')


%% Coupling 

C= b(:,10:11,1); %Child's right hand
M=b(:,19:20,2);  %Mother's left hand

win=5;
[Cx,Cy,Cxy]=coupling(C,M,5);

plot(Cxy)
title('Coupling between child right hand and mother left hand, smoothing window=5')
xlabel('time(frames)')
ylabel('coupling')
saveas(gcf,'CouplingHeads.png');

%% between heads

C= b(:,46:47,1); %Child's right ear
M=b(:,49:50,2); %Mother's left ear
[Cx,Cy,Cxy]=coupling(C,M,5);

plot(Cxy)
title('Coupling between child right and mother left hand movements, smoothing window=5')
xlabel('time(frames)')
ylabel('coupling')
saveas(gcf,'CouplingHands.png');

%% between child's right hand and mother's head

C= b(:,10:11,1); %Child's right hand
M=b(:,49:50,2); %Mother's left ear
[Cx,Cy,Cxy]=coupling(C,M,5);

plot(Cxy)
title('Coupling between child right hand and mother head movements, smoothing window=5')
xlabel('time(frames)')
ylabel('coupling')
saveas(gcf,'CouplingHands.png');


