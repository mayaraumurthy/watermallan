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
    turnToEdge(myTh, 3);
    %disp(myTh / (2*pi) * 360);
        
        
%end
end

function output = turnToEdge(myTh, edge)
    ratio = 60;
    L = 6.75;  %dist of wheel base
    R = 1.5;  %radius of wheel
    if(myTh < 0)
        myTh = (pi * 2) + myTh;
    end
    disp(myTh / (2*pi) * 360);
    desiredTh = edge * (pi/2);
    if(desiredTh ==0 && myTh > pi)
        desiredTh = pi * 2;
    end
    disp(desiredTh/ (2*pi) * 360);
    circ = pi * L;
    dist = (abs(myTh - desiredTh) / (2 * pi)) * circ;
    one_dist = dist;
    rot = (one_dist / (pi * 2 * R)) * (360);
    disp(rot);
    if(myTh > desiredTh)
        motor1 = NXTMotor('A', 'Power', -50, 'TachoLimit', floor(rot));
        motor2 = NXTMotor('B', 'Power', 50, 'TachoLimit',  floor(rot));
    else
        motor1 = NXTMotor('A', 'Power', 50, 'TachoLimit', floor(rot));
        motor2 = NXTMotor('B', 'Power', -50, 'TachoLimit',  floor(rot));
    end
    motor1.SendToNXT();
    motor2.SendToNXT();
    motor1.WaitFor();
    motor2.WaitFor();
end
    
    
function edge  = chooseEdge(myX, myY, myTh, enX, enY, xL, xH, yL, yH)
    dists = [abs(xH - enX), abs(yH - enY), abs(xL - enX), abs(yL - enY)];
    [~, minEnemy] = min(dists);
    possibilities = [xH, yH, xL, yL];
    if (mod(minEnemy,2) == 1)
        possibilities(minEnemy) = myX;
    else
        possibilities(minEnemy) = myY;
    end
    dists = abs(possibilities - [myX, myY, myX, myY]);
    [~, edge] = max(dists);
end

function powers = move_to_edge(edge, myX, myY, corners)
    ratio = 60;
    diff = 0;
    if(edge == 0)
        diff = corners(2,2).x - myX;
    elseif(edge == 1)
        diff = corners(2,2).y - myY;
    elseif(edge == 2)
        diff = myX - corners(1,1).x;
    elseif(edge == 3)
        diff = myY - corners(1,1).y;
    end
    dist = (diff - .1) * ratio ;
    rot = (dist / (pi * 2 * R)) * (360);
    motor1 = NXTMotor('A', 'Power', 50, 'TachoLimit', floor(rot));
    motor2 = NXTMotor('B', 'Power', 50, 'TachoLimit',  floor(rot));
    motor1.SendToNXT();
    motor2.SendToNXT();
    motor1.WaitFor();
    motor2.WaitFor();
end
    

function output = goToEdge(myX, myY, myTh, enX, enyY, corners)
    edge = chooseEdge(myX, myY, myTh, enX, enY, corners(1, 1).x,  corners(2, 2).x, corners(1, 1).y, corners(1,1).x);
    turnToEdge(myTh, edge)
    myPosition = HPS.getPosition(myId);
    turnToEdge(myPosition.th, edge);
    
    


    











end
