function [GlobalFWHM,GlobalR,result]=SubGlobalWithout(I,pixsize)
%STEP1:Skeleton
%STEP2:LS
%% User setting
%%user edit
close all;
thres=0; 
% figure;
% imshow(I,[]); 
if size(I,3)==3
    I=rgb2gray(I);
end
Idenoise=DenoiseFunc(I,pixsize);

G = fspecial('gaussian', [3 3], 1);
Ig = imfilter(Idenoise,G,'same');

if max(Ig(:))==0
    GlobalFWHM=0;
    result=[0 0];
else

% Ig=Normalized(Ig);
% img = imbinarize(Ig);
img = imbinarize(Ig);    %先归一化或后归一化，将产生不同效果
img=Normalized(img);

% figure;
% imshow(img,[]);

% figure;

%%
% the standard skeletonization:
skr=bwmorph(img,'skel',inf);
% imshow(skr);

% thresholding the skeleton can return skeletons of thickness 2,
% so the call to bwmorph completes the thinning to single-pixel width.
skel = bwmorph(skr > thres,'skel',inf);
% imshow(skel)

%%
%Basing on skeleton, LS  根据skeleton 构建模型
%初始化  para=[sigma b r]
I_Double=double(I);
II=Normalized(I_Double);
[ opara,error ] = LM_Wo( II,skel,pixsize, 'unweight');

% figure;imshow(error,[]);
result=[abs(opara(1))*pixsize,opara(2)];
GlobalFWHM=result(1)*2.3548

end
end

function [ opara,error ]=LM_Wo (subregion,skel,pixsize,TYPE)
%算法来源于 Method for Non-Linear Least Squares problems, 2nd Edition
    subsize1=size(subregion,1);
    subsize2=size(subregion,2);
    m1 =subsize1/2;
    m2 =subsize2/2;
    para= [2,0,1];    % sigma, b,A 初值
    N=20;
    ksi=0.0000001; 
    v=2;
    t=1;
    F=[];G=[]; P=[];
    P(1,1:3)=para;
    [F(1),J,error]=df_LS_Wo( subregion,para,skel,pixsize,TYPE );
     P(1,4)=F(1);
    A=J'*J;
    g=J'*F(1);
    normG=norm(g,'inf');
    found=(normG<ksi);
     i=1;
     j=1;
     
     maxaii=max(max(A));
     u=(t*maxaii);
     while (found==0) &&  (j<N)
        I=eye(size(A,1),size(A,2));
        temp=A+u*I;     %构造增量正规方程
%         h=inv(temp)*(-g);
        h=temp\(-g);
%         h=temp\g;
        if norm(h)<ksi*(norm(para)+ksi)
            found=1;
        else
            para=para+h';
            i=i+1;
            [F(i),J,error]=df_LS_Wo( subregion,para,skel,pixsize,TYPE );
            fenmu=0.5*h'*(u*h-g);
%             e=(F(i)-F(i-1))/fenmu;
             e=(P(j,3)-F(i))/fenmu;
            if e<0     % 应该是大于号还是小于号？ 
%                 if para(2)<0
%                     j=j;
%                     P(j,1:3)=para;
%                     P(j,4)=F(i);
%                 else
%                     j=j+1;
%                     P(j,1:3)=para;
%                     P(j,4)=F(i);
%                 end
                A=J'*J;
                g=J'*F(i);
                found=(norm(g,'inf')<ksi);
                maxtemp=max(1/3,1-(2*e-1)^3);
                u=u*maxtemp;
                v=2;
                j=j+1;
                P(j,1:3)=para;
                P(j,4)=F(i);
               
            else
                u=u*v;
                v=2*v;
                if (F(i)>P(j,4))
                    para=P(j,1:3);
                else 
                    j=j+1;
                    P(j,1:3)=para;
                    P(j,4)=F(i);
                end
            end
        end
     end
     opara=para;
end


function [ f,g,ff ] = df_LS_Wo( sub,para,skel,pixsize,TYPE)
%实际上求的是Jacobi
deta=1;
parasize=size(para,2);
[f,ff]= LS_Wo(para, sub,skel,pixsize,TYPE);

    for i=1:parasize
        paraadd=para;   
        paraadd(i)=paraadd(i)+deta;
        fadd(i)=LS_Wo(paraadd,sub,skel,pixsize,TYPE);
        g(i)=(fadd(i)-f)/deta;
    end

end

function [f,ff] = LS_Wo( para,sub,skel,pixsize,TYPE )
%para1:sigma  para2:b  para3：A

    xx=0;yy=0;
    sigma=para(1);
%     b=para(2);
    A=para(3);
    b=0;
%     gridsize=15;
    gridsize=ceil(15*100/pixsize);%原来是15*200/pixsize
    [x,y]=meshgrid(-gridsize:gridsize,-gridsize:gridsize);
    s1=(x-xx).^2;
    s2=(y-yy).^2;
    s=(-s1-s2)/(2*sigma*sigma);
    I0=A*exp(s)+b;
    I=conv2(skel,I0,'same');
%     mesh(I0);
%%    
%%结构加粗 -- original 201911
%     se = strel('disk',ceil(r));
%     Skel_Enhance = imdilate(skel,se);
%     Skel_Enhance=double(Skel_Enhance);
%     I=conv2( Skel_Enhance,I0,'same');
%% change by 201911
% se= MySigmoid(r);
% Skel_Enhance= conv2(skel,se,'same');
% I=conv2( Skel_Enhance,I0,'same');
%% change by 201912
% if r<1
%   I= imfilter(skel,I0,'same');
% else
%     se= MySigmoid(r);
%     se2 = se'*se;
%     Skel_Enhance=conv2(I0,se2,'same');
%     I= imfilter(skel,Skel_Enhance,'same');
% end
%%     
    %
%     I=sub.*I;
    II=Normalized(I);
    sub_N=Normalized(sub);
%      II=I;
%      sub_N=sub;
    temp=(sub_N-II).*(sub_N-II);
    w=1;
    switch TYPE
        case 'weight'
            w=1./II;
    end
    ff=w.*temp;
%     mesh(ff);
    f=sum(sum(ff));
end



