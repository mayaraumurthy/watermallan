ratio = 60
L = 6.75;  %dist of wheel base
R = 1.5;  %radius of wheel


function output =prey2(input)


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

enX_Prev =0;
enY_Prev = 0;
enTh_Prev = 0;

while true
    myPosition = HPS.getPosition(myId);
    enemyPosition = HPS.getPosition(enemyId);
    
    % Do something with myPosition
    % You can access the x, y, and theta values like this:
    
    myX = myPosition.x;
    myY = myPosition.y;
    myTh = myPosition.th;
    myX = myPosition.x + .08*cos(myTh);  %% + offset relating to theta
    myY = myPosition.y + .08*sin(myTh); %% + offset relating to theta
    corners = getCorner(HPS);
end
end

function output = turnToEdge(myTh, edge)
    desiredTh = edge * (pi/2);
    circ = pi * r;
    dist = ((myTh - desiredTh) / (2 * pi)) * circ;
    one_dist = dist / 2;
    rot = (one_dist / (pi * 2 * R)) * (360)
    motor1 = NXTMotor('A', 'Power', 100, 'TachoLimit', rot);
    motor2 = NXTMotor('B', 'Power', -100, 'TachoLimit',  rot);
    motor1.sendToNxt();
    motor2.sendToNxt();
end
    
    

function output = goToEdge(myX, myY, myTh, enemyPos, corners)
    


    











end
