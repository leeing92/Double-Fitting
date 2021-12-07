% simply main for junior

%%
%  Input: user parameter!!!!!!!!!!!
Path='T1.tif'; %The Path of the image
pixelsize = 5; % nm
clearT=0.9; %thershold for skeleton thinning
SkelT =min(floor(1000/pixelsize),35); % Recommand parameter for experiment data, and for simulate data, SkelT can set to 0

ImgIn=imread(Path);

%%-------------------------------------------------------------------------------
% Measure Statistic Resolution by calculating each structure
%Output:
%  Map2Static : Record all raw data
%  ResultforStarVeri: Record all stastic data, CalNum;Meanff;Stdff is mostly used
%     [GdTruthFWHM;frame;MeanMap;StdMap;ZhixinMinMap;ZhixinMaxMap;CalNum;Meanff;Stdff];
% FWHMapRendered: Record the final local image

[ Map2Static, ResultforStarVeri,FWHMapRendered,MapResultList]= DoubleFitting(ImgIn,pixelsize,'Gauss',SkelT,0,0,clearT);

%%---------------------------------------------------------------------------------
% Measure Statistic Resolution by calculating structure by global method
%this also can be used in analysis blocking image 
%Output:
%  GlobalFWHM : Record all raw data
%  GlobalR: Record the structure width, but this version emit this function
%  result: Record fitting result, not used for common user
%If it is a need for Calculating, using the following function

% [GlobalFWHM,GlobalR,result]=SubGlobalWithout(ImgIn,pixelsize);

