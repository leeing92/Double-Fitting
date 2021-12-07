function [ MapResultList,TwoResultList,AddResultList] = FWHM202012( SkelIm,BonderIm,GradIm,RenderedIm,pixelsize,Method )
%%OUTPUT
    % MapResultList:[X,Y,FWHM,Fittingoodness,Angle]
    % TwoResultList:[X,Y,TwoDistance,Fittingoodness]
    % AddResultList:[X,Y,FWHM,Fittingoodness of Two Distance]
%%

%%

    
    size1=size(SkelIm,1);
    size2=size(SkelIm,2);
    [row,col,~]=find((SkelIm==1));
    N=length(row);
    TwoResultList=zeros(N,4);
    MapResultList=zeros(N,5);
    AddResultList=zeros(2*N,4); 
    TotalNum=sum(SkelIm(:));
    
    parfor i=1:N
        Angle=[];
        disp(['TotalNum  ',num2str(TotalNum),'  -current  ', num2str(i)]);
        x0=row(i);
        y0=col(i);
        for r=2:max(size1,size2)
            xlow=max(1,x0-r);
            xhigh=min(size1,x0+r);
            ylow=max(1,y0-r);
            yhigh=min(size2,y0+r);
            Box=BonderIm(xlow:xhigh,ylow:yhigh);
            flag=sum(sum(Box));
            if flag>=2*r
                break
            end
        end
        gn=2;
        gxlow=max(1,xlow-gn);
        gxhigh=min(size1,xhigh+gn);
        gylow=max(1,ylow-gn);
        gyhigh=min(size2,yhigh+gn);
        AngleTemp=GradIm(gxlow:gxhigh,gylow:gyhigh);
        AngleTemp=round(AngleTemp,2);
        AngleStastic=tabulate(AngleTemp(AngleTemp~=0));

%--------Code Changes on 2021.1.21---------
    if isequal(AngleTemp,zeros(size(AngleTemp)))
             Angle=0;
    else 
        if isequal(AngleStastic(:,1)~=90 & AngleStastic(:,1)~=-90, zeros(size(AngleStastic(:,1))))
            Angle=90;
        else
            if AngleStastic(1,1)==-90 && isequal(AngleStastic(:,1)>0,[0;ones(size(AngleStastic(:,1),1)-1,1)])
                 AngleStastic(1,1)=90;
                 Angle=AngleStastic(:,1).*AngleStastic(:,3);
                 Angle=sum(Angle)/100;
            else
                if AngleStastic(size(AngleStastic,1),1)==90 && isequal(AngleStastic(AngleStastic(:,1)~=90,1)<0,ones(size(AngleStastic(:,1),1)-1,1))
                    AngleStastic(size(AngleStastic,1),1)=-90;
                    Angle=AngleStastic(:,1).*AngleStastic(:,3);
                    Angle=sum(Angle)/100;
                else
                    if AngleStastic(1,1)==-90 && AngleStastic(size(AngleStastic,1),1)==90
                        if sum(AngleStastic(AngleStastic(:,1)<0&AngleStastic(:,1)~=-90,2))>sum(AngleStastic(AngleStastic(:,1)>0&AngleStastic(:,1)~=90,2))
                            AngleStastic(size(AngleStastic,1),1)=-90;
                            Angle=AngleStastic(:,1).*AngleStastic(:,3);
                            Angle=sum(Angle)/100;
                        else
                            if sum(AngleStastic(AngleStastic(:,1)<0&AngleStastic(:,1)~=-90,2))<sum(AngleStastic(AngleStastic(:,1)>0&AngleStastic(:,1)~=90,2))
                                AngleStastic(1,1)=90;
                                Angle=AngleStastic(:,1).*AngleStastic(:,3);
                                Angle=sum(Angle)/100;
                            end
                        end
                    else
                        Angle=AngleStastic(:,1).*AngleStastic(:,3);
                        Angle=sum(Angle)/100;
                    end
                end
            end
        end
     end



    if  ~isnan(Angle)
        Sub2fit=RenderedIm(xlow:xhigh,ylow:yhigh);
          temp=double(-Angle);
         TransSub=imrotate(Sub2fit,temp);
          heng=median(1:size(TransSub,1));
          heng=floor(heng);
           Line2fit=sum(TransSub(heng-1:heng+1,:));
           X=1:length(Line2fit);
           X=X*pixelsize;
           Line2fit=double(Line2fit);
           Line2fit=(Line2fit-min(Line2fit))/(max(Line2fit)-min(Line2fit));   %Normalized Intensity
%--------------------
  
        if length(Line2fit)>6 && (max(Line2fit)>0)   
           switch Method 
               case 'Gauss'
                   options = fitoptions('gauss1', 'Lower', [ 0 0 0],'Upper',[max(Line2fit) max(X) mean(X)]);
                     [fitresult, gof]=fit(X',Line2fit','gauss1',options);
                    FitFlag=gof.rsquare;
                    result=1.6651*fitresult.c1;
                    MapResultList(i,:)=[x0,y0,result,FitFlag,Angle];
 

           end
       end
     end
    end
    end



