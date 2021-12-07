function [ Map2Static, ResultforStarVeri,FWHMapRendered,MapResultList] = DoubleFitting( RenderedImg,pixelsize,FitMethod,SkelT,GdTruthFWHM,frame,FittingScore )
% Optimized by Mengting Lee， 2020.12.30 This is for Local Resolution
% For Global resolution use function SubGlobalWithout
%Input:  RenderedImg and the pixelsize of RenderedImg
%        FitMethod: default 'Gauss'
%        SkelT: default 30   determine the skeleton
% GdTruthFWHM is for groudtruth verification
% frame is for recording the frame num
% FittingScore usually is 0.9,here 
% If this code is not for verify, 
% u can simply use FWHMap202012(ImgIn,pixelsize,'Gauss',30,0,0,0.9);

close all
ResultforStarVeri=zeros(9,1);
tic
n=ceil(20/pixelsize);
 se=strel('disk',n);
if size(RenderedImg,3)==3
    RenderedImg=rgb2gray(RenderedImg);
end

    Im=DenoiseFunc(RenderedImg,pixelsize);
    RenderedImg2BS=Normalized(imdilate(Im,se)); 
    Bounderpre=imbinarize(RenderedImg2BS,'adaptive','Sensitivity',0.4); 
    h=fspecial('laplacian',0);
    Im2select=imfilter(Bounderpre,h,'same');
    thres=SkelT;

    skeletontemp1=Normalized(Im);
    skeletontemp=imbinarize(skeletontemp1,'adaptive','Sensitivity',0.4);
    [skr,rad] = skeleton( skeletontemp);
    SkelImwithout1 = bwmorph(skr > thres,'skel',inf);
    [~,ImGrad]=Grad202012( double(Bounderpre));

%Calculate
    MapResultList=FWHM202012(SkelImwithout1,Im2select,ImGrad,RenderedImg,pixelsize,FitMethod);
    
    %forming image
    FWHMap=FromList2Image(MapResultList(:,1:4),size(RenderedImg,1),size(RenderedImg,2),FittingScore);
    
    %stastic
    FWHMapIndex=MapResultList(:,4)>FittingScore & MapResultList(:,3)~=0;
    FWHMList=MapResultList(FWHMapIndex,:);
    Map2Static=FWHMList(:,3);
    Map2Static=log(Map2Static);
    if length(Map2Static)>2
        MeanMap=roundn(mean(Map2Static),-2);
        StdMap=roundn(std(Map2Static),-2);
        MinM=roundn(min(Map2Static),-2);
        MaxM=roundn(max(Map2Static),-2);
        [n, xout]=hist(Map2Static,MinM:0.02:MaxM);
        n = 100* n / sum(n);
        options= fitoptions('gauss1', 'Lower', [0 MinM 0 ]);
        [ff, gof]=fit(xout',n','gauss1',options);
        Meanff=roundn(ff.b1,-2);
        Stdff=roundn(ff.c1,-2);
    [ZhixinMinMap,ZhixinMaxMap]=StaRegin1(Meanff,Stdff,MinM);
    ZhixinMinMap = roundn(ZhixinMinMap,-2);
    ZhixinMaxMap =roundn(ZhixinMaxMap,-2);
    fitgoodness=roundn(gof.rsquare,-2);
%Show the statistics of FWHMap
    figure;
    bar(xout, n);
    a=get(gca);
    x=a.XLim;
    y=a.YLim;
    k=[0.65 0.85];
    textxx=x(1)+k(1)*(x(2)-x(1));
    textyy=y(1)+k(2)*(y(2)-y(1));
    text(textxx,textyy,['Fitgoodness:',num2str(fitgoodness)],'FontSize',16,'FontWeight','bold');
      kk=[0.65 0.75];
    textx=x(1)+kk(1)*(x(2)-x(1));
    texty=y(1)+kk(2)*(y(2)-y(1));
    text(textx,texty,['R-Mean: ', num2str(Meanff),' (',num2str(roundn(exp(Meanff),-2)),')'],'FontSize',16,'FontWeight','bold');
    kk1=[0.65 0.65];
    textxx1=x(1)+kk1(1)*(x(2)-x(1));
    textyy1=y(1)+kk1(2)*(y(2)-y(1));
    text(textxx1,textyy1,['R-mini ',num2str(ZhixinMinMap),' (',num2str(roundn(exp(ZhixinMinMap),-2)),')'],'FontSize',16,'FontWeight','bold');
    hold on
    h=plot(ff);
    set(h,'MarkerSize',16,'LineWidth',2);  
    ylabel('Frequency (%)','FontSize',16,'FontWeight','bold');
    xlabel('ln FWHM (nm)','FontSize',16,'FontWeight','bold');
    title('Statistic Resolution','FontSize',16,'FontWeight','bold');
    set(gca,'FontSize',16,'LineWidth',2);
    box off
    legend off

CalNum= length(Map2Static( Map2Static~=0));
ResultforStarVeri=[GdTruthFWHM;frame;MeanMap;StdMap;ZhixinMinMap;ZhixinMaxMap;CalNum;Meanff;Stdff];
%---------------------    

    end  
       

    disksize=ceil(Meanff/pixelsize/2);
    se = strel('disk',disksize);
    FWHMapRendered=imdilate(FWHMap,se);
    figure;imshow(FWHMapRendered,[]);colormap ('hot');
    MergeImg=RawResultMerge(RenderedImg,FWHMapRendered,[]);


toc
% TodayTime=datestr(now,30);
%  save(['result-',TodayTime,'.mat']);

end

