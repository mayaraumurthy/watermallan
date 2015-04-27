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
OpenSwitch(SENSOR_1);

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
    
    base = corners(1, 1);
    baseX = base.x;
    baseY = base.y;
    
    %just move towards the enemy
    [P1, P2] = makeMove(baseX, baseY, myX, myY, myTh, enemyX, enemyY);
    
    timeStep = 360;
    
    motor1 = NXTMotor('A', 'Power', P1, 'TachoLimit', 180);
    motor2 = NXTMotor('B', 'Power', P2, 'TachoLimit', 180);
    
    motor1.SendToNXT();
    motor1.WaitFor();
    motor2.SendToNXT();
    motor2.WaitFor();
    
    if GetSwitch(SENSOR_1)
        NXT_PlayTone(800, 1000);
        motor1.Stop('brake');
        motor2.Stop('brake');
    end
    
end
    
