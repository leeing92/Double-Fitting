function [ ] = MixPicLine(Im,angle, r, x0,y0,color)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
     size1=size(Im,1);
     size2=size(Im,2);
    xlow=max(1,x0-r);
    xhigh=min(size1,x0+r);
    ylow=max(1,y0-r);
    yhigh=min(size2,y0+r);
    Sub2Show=Im(xlow:xhigh,ylow:yhigh);    
    k=tan(angle/180*3.1415926);
    dertax= sqrt(1/(k.^2+1))*r;
    dertay=k*dertax;
    x=(size(Sub2Show,1)-1)/2+1;
   y=(size(Sub2Show,2)-1)/2+1;
    x1=x+dertax;
    y1=y+dertay;
    x2=x-dertax;
    y2=y-dertay;
    imagesc(Sub2Show);
    colormap (jet);
    colorbar;
    freezeColors;
    hold on
%     rectangle('position',[x0-r,y0-r,2*r,2*r],'LineWidth',2, 'EdgeColo','y');
     plot([x1,x2],[y1,y2],color,'LineWidth',3);
    hold off
end

