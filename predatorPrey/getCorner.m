function [ corners ] = getCorner( HPS)


ids = HPS.getVisibleIds();
while(~ismember(23, ids))
    ids = HPS.getVisibleIds();
end
c23 = HPS.getPosition(23);
while(~ismember(20, ids))
    ids = HPS.getVisibleIds();
end
c20 = HPS.getPosition(20);
while(~ismember(21, ids))
    ids = HPS.getVisibleIds();
end
c21 = HPS.getPosition(21);
while(~ismember(22, ids))
    ids = HPS.getVisibleIds();
end
c22 = HPS.getPosition(22);

corners = [c20 , c23;c21 , c22];

end

