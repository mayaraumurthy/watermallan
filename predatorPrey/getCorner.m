function [ corners ] = getCorner( HPS)
c23 = HPS.getPosition(23);
c20 = HPS.getPosition(20);
c21 = HPS.getPosition(21);
c22 = HPS.getPosition(22);

corners = [c23, c20 ; c22, c21];


end

