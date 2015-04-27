<<<<<<< HEAD
%COM_CloseNXT all
%h = COM_OpenNXT('bluetooth.ini');
%COM_SetDefaultNXT(h)

offset = .08; %forward

myId = 7; % CHANGE ME: We will tell you what your tag's id is
enemyID = 7;
% Example HowiePositioningSystem Usage
% Example team's tag id is 1, their opponent's tag id is 40

COM_CloseNXT all
hNXT = COM_OpenNXT('bluetooth.ini');
COM_SetDefaultNXT(hNXT)

myId = 7;
enemyId = 17;

HPS = HowiePositioningSystem;

ids = HPS.getVisibleIds();
% ids => [1; 40] (for example)

<<<<<<< HEAD
enX_Prev =0;
enY_Prev = 0;
enTh_Prev = 0;

=======
% Your main loop
>>>>>>> d618e21fcfa47e047476d605de620011926c82fa
while true
    myPosition = HPS.getPosition(myId);
    enemyPosition = HPS.getPosition(enemyId);
    
    % Do something with myPosition
    % You can access the x, y, and theta values like this:
    
<<<<<<< HEAD
    
=======
    myX = myPosition.x;
    myY = myPosition.y;
>>>>>>> d618e21fcfa47e047476d605de620011926c82fa
    myTh = myPosition.th;
    myX = myPosition.x + .08*cos(myTh);  %% + offset relating to theta
    myY = myPosition.y + .08*sin(myTh); %% + offset relating to theta
    corners = getCorner(HPS);
    
    up = 100*sqrt((corners(1,2).y-myY)/(corners(1,2).y - corners(1,1).y));
    down = 100*sqrt((myY-corners(1,1).y)/(corners(1,2).y - corners(1,1).y));
    left = 100*sqrt((myX-corners(1,1).x)/(corners(2,1).x - corners(1,1).x));
    right = 100*sqrt((corners(2,1).y-myX)/(corners(2,1).x - corners(1,1).x));
    
    disp(strcat('up:', int2str(up), 'down:', int2str(down)));
    disp(strcat('left:', int2str(left), 'right', int2str(right)));
    
    x_diff = (enX - myX);
    y_diff = (enY - myY); 
    
    
    corners = getCorner(HPS);
    
    enemyX = enemyPosition.x;
    enemyY = enemyPosition.y;
    enemyTh = enemyPosition.th;   
    
    corners = getCorner(HPS);
    
    % Here we'll just print the position out
    disp('My position');
    disp(myPosition);
end
    
