 


function [CX,CY,CXY] = coupling(data1,data2,window)
%COUPLING        Time-resolved connectivity
%
%   MTD = coupling(data,window);
%   MTD = coupling(data,window,direction);
%   MTD = coupling(data,window,direction,trim);
%
%	Creates a functional coupling metric from an input matrix 'data'
%	data: should be organized in 'time x nodes' matrix
%	window: smoothing parameter for simple moving average of coupling metric (1 = forward; 0 = middle [default])
%   trim: whether to trim zeros from the end of the 3d matrix (1=yes; 0=no [default])
%
%   Inputs:
%       data1 and data2
%           time series data organized as TIME x Dimensions.
%       window,
%           window length (time points).
%       
%
%   Outputs:
%     
%           time-varying coupling with X-X, Y-Y and X-Y




    [ts1,nodes] = size(data1);
    [ts2,nodes] = size(data2);
    %calculate temporal derivative
    td1 = diff(data1);
     td2 = diff(data2);

    %standardize data

     td1 = zscore(td1);
     td2 = zscore(td2);


CX= smooth(td1(:,1).*td2(:,1),window);
CY=smooth(td1(:,2).*td2(:,2),window);

d1= sqrt(td1(:,1).^2+td1(:,2).^2);
d2= sqrt(td2(:,1).^2+td2(:,2).^2);

CXY=smooth(d1.*d2,window);




    