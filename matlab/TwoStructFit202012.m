function [DistanceMap,X1Result,X2Result,state]=TwoStructFit202012(X,Line2fit,RenderedIm,x0,y0,r,Angle,Method,pixelsize,i,FittingScore)
        global ChangeStateFlag;
        global countchange;
        global ChangeStateInfo;
         
        DistanceMap=0;
        X1Result=[1,1,0];
        X2Result=[1,1,0];
        state =0;
        
    if length(Line2fit)>6 && (max(Line2fit)>0)   
             [s,fitresult, gof]=createFit(X,Line2fit);
        if s==0
        else

            Fitlength=length(Line2fit)*pixelsize;            
            state=gof.rsquare;
            a1=fitresult.a1; b1=fitresult.b1; c1=fitresult.c1;
            a2=fitresult.a2; b2=fitresult.b2; c2=fitresult.c2;
            X1Result=[x0,y0,0];
            X2Result=[x0,y0,0];
                        
% adding result 
                    detl1=(Fitlength/2-b1)/pixelsize;
                    detl2=(Fitlength/2-b2)/pixelsize;
                    x1=x0-detl1*sin(Angle/180*pi);
                    x2=x0-detl2*sin(Angle/180*pi);
                    y1=y0+detl1*cos(Angle/180*pi);
                    y2=y0+detl2*cos(Angle/180*pi);
                    if x1>0 &&x2>0 &&y1>0 &&y2>0
                    X1Result=[round(x1),round(y1),c1];
                    X2Result=[round(x2),round(y2),c2];
                    else 
                        X1Result=[x0,y0,0];
                        X2Result=[x0,y0,0];
                    end              
                x=1:0.0001:Fitlength;
                f=a1*exp(-((x-b1)/c1).^2)+a2*exp(-((x-b2)/c2).^2);
                mph=min(f)+(max(f)-min(f))/10;
                [pks,locs] = findpeaks(f,'minpeakheight',mph);
             if length(locs)==2
                    index=locs(1):locs(2);
                    localmin=min(f(index));
                    localmax=max(pks);
                    localstate1=localmin/localmax;
                    sigmastate1=c1/c2;
                if localstate1<=0.8  && sigmastate1>0.1 &&sigmastate1<10  %&& localstate2>0.2
                  DistanceMap=(locs(2)-locs(1)-2)*0.0001;
                        if ChangeStateFlag==1
                            ChangeStateInfo(countchange,:)=[i,x0,y0,r,DistanceMap,Angle];
                            countchange=countchange+1;
                        else
                            ChangeStateInfo(countchange,:)=[i,x0,y0,r,DistanceMap,Angle];
                        end
                end
            end
        end
    end
end