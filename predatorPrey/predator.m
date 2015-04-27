% Example HowiePositioningSystem Usage
% Example team's tag id is 1, their opponent's tag id is 40

COM_CloseNXT all
hNXT = COM_OpenNXT('bluetooth.ini');
COM_SetDefaultNXT(hNXT)

myId = 9;
enemyId = 17;
flag = 0; % 0 = we are the prey, 1 = we are the predator 

HPS = HowiePositioningSystem;

ids = HPS.getVisibleIds();
% ids => [1; 40] (for example)

% Your main loop
while true
    myPosition = HPS.getPosition(myId);
    enemyPosition = HPS.getPosition(enemyId);
    
    % Do something with myPosition
    % You can access the x, y, and theta values like this:
    
    myX = myPosition.x;
    myY = myPosition.y;
    myTh = myPosition.th;
    
    enemyX = enemyPosition.x;
    enemyY = enemyPosition.y;
    enemyTh = enemyPosition.th;   
    
    corners = getCorner(HPS);
    
    % Here we'll just print the position out
    disp('My position');
    disp(myPosition);
end
    
