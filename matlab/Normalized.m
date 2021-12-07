function [oI] = Normalized(I)
    minI=min(min(I));
    maxI=max(max(I));
    oI=(I-minI)/(maxI-minI);
end

