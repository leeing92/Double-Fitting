function Image=FromList2Image(OriList,size1,size2,fitgood)
    Image =zeros(size1,size2);
    Index=OriList(:,4)>fitgood &OriList(:,3)~=0;
    List=OriList(Index,:);
    for i=1:size(List,1)
        x=List(i,1);
        y=List(i,2);
        v=List(i,3);
        if x>0 && y>0
            Image(x,y)=v;
        end
    end
end