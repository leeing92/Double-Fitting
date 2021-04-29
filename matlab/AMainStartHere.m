% simply main for junior

%%
%  Input: user parameter!!!!!!!!!!!
Path='C:'; %The Path of the image
pixelsize = 10; % nm
clearT=0.9;
SkelT =min(floor(1000/pixelsize),35); % Recommand parameter for experiment data, and for simulate data, SkelT can set to 0

ImgIn=imread(Path);

%%-------------------------------------------------------------------------------
%Measure Statistic Resolution by calculate each structure
%Output:
%  Map2Static : Record all raw data
%  ResultforStarVeri: Record all stastic data, CalNum;Meanff;Stdff is mostly used
%     [GdTruthFWHM;frame;MeanMap;StdMap;ZhixinMinMap;ZhixinMaxMap;CalNum;Meanff;Stdff];
% FWHMapRendered: Record the final local image

[ Map2Static, ResultforStarVeri,FWHMapRendered,MapResultList]= FWHMap202012(ImgIn,pixelsize,'Gauss',SkelT,0,0,0.9);

%%---------------------------------------------------------------------------------
%Measure Statistic Resolution by calculate structure by global method
%this is used in analysis blocking image in paper "Quantifying image resolution non-uniformity (IRNU) in super-resolution optical microscopy"
%Output:
%  GlobalFWHM : Record all raw data
%  GlobalR: Record the structure width, but this version emit this function
%  result: Record fitting result, not used for common user
%If it is a need for Calculating Global resolution, the following function

% [GlobalFWHM,GlobalR,result]=SubGlobalWithout(ImgIn,pixelsize);

