function [ oImg ] = MixShow( I_ori,I_label,Color )
%

% I_max=max(max(I_ori));
% I_min=min(min(I_ori));
% if I_max-I_min<20
% I_ori=(I_ori-I_min)/(I_max-I_min);
% I_ori=imadjust(I_ori, stretchlim(I_ori));
% end

Img_R=I_ori;
Img_G=I_ori;
Img_B=I_ori;
I_max=max(max(I_ori));
I_min=min(min(I_ori));
if(I_max-(I_min+200)>0) 
    I_show=I_max;
else I_show=I_min+200;
end


switch Color
    case 'b'
        Img_R(I_label ==1)=I_min;
        Img_G(I_label ==1)=I_min;
        Img_B(I_label ==1)=I_show;
    case 'r'
        Img_R(I_label ==1)=I_show;
        Img_G(I_label ==1)=I_min;
        Img_B(I_label ==1)=I_min;
    case 'g'
         Img_R(I_label ==1)=I_min;
        Img_G(I_label ==1)=I_show;
        Img_B(I_label ==1)=I_min;
end
    oImg=cat(3,Img_R,Img_G,Img_B);

end

