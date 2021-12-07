function [GlobalFWHM,GlobalR,result]=SubGlobalWithout(I,pixsize)
%STEP1:Skeleton
%STEP2:LS
close all
GlobalR=[];
thres=0; 
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
img = imbinarize(Ig);    
img=Normalized(img);
skr=bwmorph(img,'skel',inf);
skel = bwmorph(skr > thres,'skel',inf);
I_Double=double(I);
II=Normalized(I_Double);
[ opara,error ] = LM_Wo( II,skel,pixsize, 'unweight');
result=[abs(opara(1))*pixsize,opara(2)];
GlobalFWHM=result(1)*2.3548;
end
end

function [ opara,error ]=LM_Wo (subregion,skel,pixsize,TYPE)
%algorithm from "Method for Non-Linear Least Squares problems, 2nd Edition"
    subsize1=size(subregion,1);
    subsize2=size(subregion,2);
    m1 =subsize1/2;
    m2 =subsize2/2;
    para= [2,0,1];    
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
        temp=A+u*I;    
        h=temp\(-g);
        if norm(h)<ksi*(norm(para)+ksi)
            found=1;
        else
            para=para+h';
            i=i+1;
            [F(i),J,error]=df_LS_Wo( subregion,para,skel,pixsize,TYPE );
            fenmu=0.5*h'*(u*h-g);
             e=(P(j,3)-F(i))/fenmu;
            if e<0     
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
%Jacobi
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
    A=para(3);
    b=0;
    gridsize=ceil(15*100/pixsize);
    [x,y]=meshgrid(-gridsize:gridsize,-gridsize:gridsize);
    s1=(x-xx).^2;
    s2=(y-yy).^2;
    s=(-s1-s2)/(2*sigma*sigma);
    I0=A*exp(s)+b;
    I=conv2(skel,I0,'same');
    II=Normalized(I);
    sub_N=Normalized(sub);
    temp=(sub_N-II).*(sub_N-II);
    w=1;
    switch TYPE
        case 'weight'
            w=1./II;
    end
    ff=w.*temp;
    f=sum(sum(ff));
end



