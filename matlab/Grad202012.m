function [ angle,Tempangle ] = Grad202012( A )

kernel1=[-1 -1 -1; 0 0 0;1 1 1];
kernel2=[1 0 -1; 1 0 -1; 1 0 -1];
Gy=imfilter(A,kernel1,'replicate');
Gx=imfilter(A,kernel2,'replicate');
Tempangle=atan2(Gy,Gx)*180/3.1415926;
Tempangle=roundn(Tempangle,-2);
Temp=(Tempangle>90.00&Tempangle<270);
Tempangle=Tempangle-180*double(Temp);
Temp=(Tempangle<-90.00 &Tempangle>-270);
Tempangle=Tempangle+180*double(Temp);
  length1=size(Tempangle,1);
  length2=size(Tempangle,2);
  x=ceil(mean(1:length1));
  y=ceil(mean(1:length2));
  angle=   max(max(Tempangle(x-1:x+1,y-1:y+1)));

end

