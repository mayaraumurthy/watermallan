% Example HowiePositioningSystem Usage
% Example team's tag id is 1, their opponent's tag id is 40


COM_CloseNXT all
hNXT = COM_OpenNXT('bluetooth.ini');
COM_SetDefaultNXT(hNXT)
disp('connected');
myId = 7;
enemyId = 17;

HPS = HowiePositioningSystem;

ids = HPS.getVisibleIds();
% ids => [1; 40] (for example)
OpenSwitch(SENSOR_1);
corners = getCorner(HPS);
% Your main loop
while true
    myPosition = HPS.getPosition(myId);
    if(ismember(enemyId, ids))
        enemyPosition = HPS.getPosition(enemyId);
    end
    
    % Do something with myPosition
    % You can access the x, y, and theta values like this:
    
    myTh = myPosition.th;
    myX = myPosition.x + .08*cos(myTh);  %% + offset relating to theta
    myY = myPosition.y + .08*sin(myTh); %% + offset relating to theta
    
    enemyX = enemyPosition.x;
    enemyY = enemyPosition.y;
    enemyTh = enemyPosition.th;   
    
    %disp(strcat('enemyx:', int2str(enemyX), ' enemyY:', enemyY, ' enemyTH:', enemyTh));
    
    % Here we'll just print the position out
    disp('My position');
    disp(myPosition);
    
    base = corners(1, 1);
    baseX = base.x;
    baseY = base.y;
    
    %just move towards the enemy
    [P1, P2] = makeMove(baseX, baseY, myX, myY, myTh, enemyX, enemyY, -20);
    
    timeStep = 360;
    

    motor1 = NXTMotor('A', 'Power', P1);
    motor2 = NXTMotor('B', 'Power', P2);
    motor3 = NXTMotor('C', 'Power', 0);
    
    motor3.Stop('Brake');

    motor1.SendToNXT();
    motor2.SendToNXT();
    
    if GetSwitch(SENSOR_1)
        NXT_PlayTone(800, 1000);
        motor1.Stop('brake');
        motor2.Stop('brake');
        %break;
    end
    pause(0.15)
    
end
    
