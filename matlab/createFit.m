function [state,fitresult, gof] = createFit(X,Sub2fit)
%Initial value
 mph=min(Sub2fit)+(max(Sub2fit)-min(Sub2fit))/10; 
[pks,locs] = findpeaks(Sub2fit,'minpeakheight',mph);
pkslength=length(pks);
state=1;
if pkslength==0
    state=0;fitresult=0;gof=0;
    return 
end
if pkslength==1
    a1=pks(1);
    a2=pks(1);
    b1=X(locs(1));
    b2=X(locs(1));
    c1=length(Sub2fit)/3;
    c2=length(Sub2fit)/3;
else
frontindex=ceil(pkslength/3);
a1=mean(pks(1:frontindex));
a2=mean(pks(frontindex+1:pkslength));
b1=X(locs(1));
b2=X(locs(pkslength));
c1=length(Sub2fit)/3;
c2=length(Sub2fit)/3;
end
%% Fit:
[xData, yData] = prepareCurveData( X, Sub2fit );

% Set up fittype and options.
ft = fittype( 'gauss2' );
opts = fitoptions( ft );
opts.Display = 'Off';
opts.Lower = [0 0 0 0 0 0];
opts.StartPoint = [a1 b1 c1 a2 b2 c2];
opts.Upper = [Inf max(X) Inf Inf max(X) Inf];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );



