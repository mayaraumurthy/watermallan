%COM_CloseNXT all
%h = COM_OpenNXT('bluetooth.ini');
COM_SetDefaultNXT(h)

myId = 9; % CHANGE ME: We will tell you what your tag's id is
enemyID = 1;

HPS = HowiePositioningSystem;

ids = HPS.getVisibleIds();

while true
    myPosition = HPS.getPosition(myId);
    enPosition = HPS.getPosition(enemyID);
    
    enX = enPosition.x;
    enY = enPosition.y;
    enTh = enPosition.th; 
    
    myX = myPosition.x;  %% + offset relating to theta
    myY = myPosition.y; %% + offset relating to theta
    myTh = myPosition.th;
    
    % Here we'll just print the position out
    disp('My position');
    disp(myPosition);
end