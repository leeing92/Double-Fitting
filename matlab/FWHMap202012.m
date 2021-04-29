function [ Map2Static, ResultforStarVeri,FWHMapRendered,MapResultList] = FWHMap202012( RenderedImg,pixelsize,FitMethod,SkelT,GdTruthFWHM,frame,FittingScore )
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

    Im=DenoiseFunc(RenderedImg,pixelsize); %当结构稀疏时，不合适，见pixelsize为1时的图片
    RenderedImg2BS=Normalized(imdilate(Im,se)); %add Normalized on 2021.1.24
%     Bounderpre=RenderedImg2BS>0; 
    Bounderpre=imbinarize(RenderedImg2BS,'adaptive','Sensitivity',0.4); %changes on 2021.1.24
    h=fspecial('laplacian',0);
    Im2select=imfilter(Bounderpre,h,'same');% 外轮廓
    thres=SkelT;

    skeletontemp1=Normalized(Im);
    skeletontemp=imbinarize(skeletontemp1,'adaptive','Sensitivity',0.4);
    [skr,rad] = skeleton( skeletontemp);
    SkelImwithout1 = bwmorph(skr > thres,'skel',inf);
    [~,ImGrad]=Grad202012( double(Bounderpre));


%把骨架图与原图进行merge显示
%      oImg = MixShow(RenderedImg,SkelImwithout1,'r' );
%      oImg1= MixShow(RenderedImg,Im2select,'b');
%      figure(1); imshow(oImg);
%      figure(2);imshow(oImg1);
%      figure(3);imagesc(ImGrad);

 
%得Map:半高全宽和TwoStuct
    MapResultList=FWHM202012(SkelImwithout1,Im2select,ImGrad,RenderedImg,pixelsize,FitMethod);
    % MapResultList:[X,Y,FWHM,Fittingoodness]
    
    %forming image
    FWHMap=FromList2Image(MapResultList(:,1:4),size(RenderedImg,1),size(RenderedImg,2),FittingScore);
    
    %stastic
    FWHMapIndex=MapResultList(:,4)>FittingScore & MapResultList(:,3)~=0;
    FWHMList=MapResultList(FWHMapIndex,:);
    Map2Static=FWHMList(:,3);
    if length(Map2Static)>2
        MeanMap=roundn(mean(Map2Static),-2);
        StdMap=roundn(std(Map2Static),-2);
        MinM=roundn(min(Map2Static),-2);
        MaxM=roundn(max(Map2Static),-2);
        [n, xout]=hist(Map2Static,MinM:1:MaxM);
        n = 100* n / sum(n);
        options= fitoptions('gauss1', 'Lower', [0 MinM 0 ],'Upper',[100 MaxM MeanMap]);
        [ff, gof]=fit(xout',n','gauss1',options);
        Meanff=roundn(ff.b1,-2)
        Stdff=roundn(ff.c1,-2)
    [ZhixinMinMap,ZhixinMaxMap]=StaRegin1(Meanff,Stdff,MinM);
    ZhixinMinMap = roundn(ZhixinMinMap,-2);
    ZhixinMaxMap =roundn(ZhixinMaxMap,-2);

%Show the statistics of FWHMap
    figure;
    bar(xout, n);
    a=get(gca);
    x=a.XLim;%获取横坐标上下限
    y=a.YLim;%获取纵坐标上下限
    k=[0.65 0.85];%给定text相对位置
    textxx=x(1)+k(1)*(x(2)-x(1));%获取text横坐标
    textyy=y(1)+k(2)*(y(2)-y(1));%获取text纵坐标
    text(textxx,textyy,[num2str(MeanMap),'\pm ',num2str(StdMap)],'FontSize',16,'FontWeight','bold');
      kk=[0.65 0.75];%给定text相对位置
    textx=x(1)+kk(1)*(x(2)-x(1));%获取text横坐标
    texty=y(1)+kk(2)*(y(2)-y(1));%获取text纵坐标
    text(textx,texty,['Mean: ', num2str(Meanff)],'FontSize',16,'FontWeight','bold');
    kk1=[0.65 0.65];%给定text相对位置
    textxx1=x(1)+kk1(1)*(x(2)-x(1));%获取text横坐标
    textyy1=y(1)+kk1(2)*(y(2)-y(1));%获取text纵坐标
    text(textxx1,textyy1,['[ ',num2str(ZhixinMinMap),' ,',num2str(ZhixinMaxMap),']'],'FontSize',16,'FontWeight','bold');
    ylabel('Frequency (%)','FontSize',16,'FontWeight','bold');
    xlabel('FWHM (nm)','FontSize',16,'FontWeight','bold');
    title('FWHMap','FontSize',16,'FontWeight','bold');
    set(gca,'FontSize',16,'LineWidth',2);
    
    
    
%---------------save for star verification
% str=['E:\Mine\LAB\Resolution\Resolution research\Fig3 Verify\star2\OurMethod\GdTruthFWHM',num2str(GdTruthFWHM),'-px',num2str(pixelsize),'-frame',num2str(frame)];
% save([str,'.mat']);
CalNum= length(Map2Static( Map2Static~=0));
ResultforStarVeri=[GdTruthFWHM;frame;MeanMap;StdMap;ZhixinMinMap;ZhixinMaxMap;CalNum;Meanff;Stdff];
%---------------------    

  end  
    
    
%     disksize=5;
    disksize=ceil(Meanff/pixelsize/2);
    se = strel('disk',disksize);
    FWHMapRendered=imdilate(FWHMap,se);
%     disksize=Meanff/pixelsize;
%     FWHMapRendered=imgaussfilt(FWHMap,disksize);
    figure;imshow(FWHMapRendered,[]);colormap('hot');

toc
TodayTime=datestr(now,30);
 save(['result-',TodayTime,'.mat']);
 
 PlotGaussianDistribution;
  Untitled2; 
  FittingGoodness(log(Map2Static),49)
  FittingGoodness(Map2Static,49)
end

