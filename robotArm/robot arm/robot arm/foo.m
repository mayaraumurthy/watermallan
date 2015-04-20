xlimit = [5, 9];
ylimit = [5.5, 8];
xbox1 = xlimit([1, 1, 2, 2, 1]);
ybox1 = ylimit([1, 2, 2, 1, 1]);

xlimit = [-0.1, 14.1];
ylimit = [-0.1, 8.1];
xbox2 = xlimit([1, 1, 2, 2, 1]);
ybox2 = ylimit([1, 2, 2, 1, 1]);

map = zeros(181, 361);
for i = 0:180
    for j = 0:360
        display([i, j]);
        
        angle1 = i / 180 * pi;
        angle2 = j / 180 * pi + pi;
        
        M1 = [cos(angle1), -sin(angle1), 0; sin(angle1), cos(angle1), 0; 0, 0, 1];
        M2 = [cos(angle2), -sin(angle2), 0; sin(angle2), cos(angle2), 0; 0, 0, 1];
        
        M1 = M1 * [1, 0, 3.75;0, 1, 0;0, 0, 1];
        M2 = M2 * [1, 0, 2.5;0, 1, 0;0, 0, 1];
        x1 = 7;
        y1 = 0;
        move1 = M1 * [0;0;1];
        move2 = M1 * M2 * [0;0;1];
        
        x2 = -move1(1) + 7;
        y2 = move1(2);
        x3 = -move2(1) + 7;
        y3 = move2(2);
        
        X = [x1, x2, x3];
        Y = [y1, y2, y3];
        [rst1x, rst1y] = polyxpoly(xbox1, ybox1, X, Y);
        [rst2x, rst2y] = polyxpoly(xbox2, ybox2, X, Y);
        
        if ((numel(rst1x) > 0) || (numel(rst2x) > 0))
            map(i + 1, j + 1) = 1;
        else
            map(i + 1, j + 1) = 0;
        end
    end
end

save('foo.mat', 'map');