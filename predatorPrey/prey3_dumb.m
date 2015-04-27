function output=prey3_dumb(input)

%COM_CloseNXT all
%h = COM_OpenNXT('bluetooth.ini');
%COM_SetDefaultNXT(h)

offset = .08; %forward

myId = 7; % CHANGE ME: We will tell you what your tag's id is
enemyID = 7;
% Example HowiePositioningSystem Usage
% Example team's tag id is 1, their opponent's tag id is 40

myId = 7;
enemyId = 7;

HPS = HowiePositioningSystem;

ids = HPS.getVisibleIds();
% ids => [1; 40] (for example)

enX_Prev =0;
enY_Prev = 0;
enTh_Prev = 0;
corners = getCorner(HPS);
%while true
    myPosition = HPS.getPosition(myId);
    enemyPosition = HPS.getPosition(enemyId);
    
    % Do something with myPosition
    % You can access the x, y, and theta values like this:
    
    myX = myPosition.x;
    myY = myPosition.y;
    myTh = myPosition.th;
    myX = myPosition.x + .08*cos(myTh);  %% + offset relating to theta
    myY = myPosition.y + .08*sin(myTh); %% + offset relating to theta
    turnToEdge(myTh, 0);
    %disp(myTh / (2*pi) * 360);
        
        
%end
end

function output = turnToEdge(myTh, edge)
    disp(myTh / (2*pi) * 360);
    ratio = 60;
    L = 6.75;  %dist of wheel base
    R = 1.5;  %radius of wheel

    desiredTh = edge * (pi/2);
    disp(desiredTh/ (2*pi) * 360);
    circ = pi * L;
    dist = (abs(myTh - desiredTh) / (2 * pi)) * circ;
    one_dist = dist;
    rot = (one_dist / (pi * 2 * R)) * (360);
    disp(rot);
    motor1 = NXTMotor('A', 'Power', 100, 'TachoLimit', floor(rot));
    motor2 = NXTMotor('B', 'Power', -100, 'TachoLimit',  floor(rot));
    motor1.SendToNXT();
    motor2.SendToNXT();
    motor1.WaitFor();
    motor2.WaitFor();
end
    
    

function output = goToEdge(~, myY, myTh, enemyPos, corners)
    


    











end