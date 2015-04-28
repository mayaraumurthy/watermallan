function offset=prey3_dumb(input)
COM_CloseNXT all
h = COM_OpenNXT('bluetooth.ini');
COM_SetDefaultNXT(h)

offset = .08; %forward
% Example HowiePositioningSystem Usage
% Example team's tag id is 1, their opponent's tag id is 40

myId = 7;
enemyId = 31;

HPS = HowiePositioningSystem;

ids = HPS.getVisibleIds();
% ids => [1; 40] (for example)

enX_Prev =0;
enY_Prev = 0;
enTh_Prev = 0;
corners = getCorner(HPS);

start = true;
edge = 0;
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
    
    enX = enemyPosition.x;
    enY = enemyPosition.y;
    
    if(start)
        edge = goToEdge(myX, myY, myTh, enemyPosition.x, enemyPosition.y, corners, HPS, myId)
        start = false;
    else
        rot = move_to_edge(edge, myX, myY, corners)
        motor1 = NXTMotor('A', 'Power', -100, 'TachoLimit', floor(rot));
        motor2 = NXTMotor('B', 'Power', -100, 'TachoLimit',  floor(rot));
        motor1.SendToNXT();
        motor2.SendToNXT();
        if(at_edge(myX, myY, edge, corners))
            edge = choose_edge_from_corner(myX, myY, corners, enX, enY)
        end
        
    end
        
end
        
    
      
end

function ratio = turnToEdge(myTh, edge)
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
        motor1 = NXTMotor('A', 'Power', -100, 'TachoLimit', floor(rot));
        motor2 = NXTMotor('B', 'Power', 100, 'TachoLimit',  floor(rot));
    else
        motor1 = NXTMotor('A', 'Power', 100, 'TachoLimit', floor(rot));
        motor2 = NXTMotor('B', 'Power', -100, 'TachoLimit',  floor(rot));
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

function rot = move_to_edge(edge, myX, myY, corners)
    ratio = 60;
    L = 6.75;  %dist of wheel base
    R = 1.5;  %radius of wheel
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
    dist = max(0, (diff - .125)) * ratio ;
    rot = (dist / (pi * 2 * R)) * (360);
end

function b = at_edge(myX, myY, curr_dest, corners)
   b = false;
   threshold = 0.1
   if(curr_dest == 0)
       if(myX > corners(2,2).x - threshold) && (myY < corners(1,1).y + threshold || myY > corners(2,2).y - threshold)
           b = true;
       end
   end
   
   if(curr_dest == 1)
       if(myY > corners(2,2).y - threshold) && (myX < corners(1,1).x + threshold || myX > corners(1,1).x - threshold)
           b = true;
       end
   end
   
   if(curr_dest == 2)
       if(myX < corners(1,1).x + threshold) && (myY < corners(1,1).y + threshold || myY > corners(2,2).y - threshold)
           b = true;
       end
   end
   
   if(curr_dest == 3)
       if(myY < corners(1,1).y + threshold) && (myX < corners(1,1).x + threshold || myX > corners(2,2).x - threshold)
           b = true;
       end
   end
end

function new_edge = choose_edge_from_corner(myX, myY, corners, enX, enY)
    midY = corners(2,2).y - corners(1,1).y
    midX = cornerS(2,2).x - corners(2,2).y
    new_edge = curr_edge;
    if((myX < midX && myY < midY))
        new_edge = 1;
        disty = enY - corners(1,1).y;
        distx = eX - corners(1,1).x
        if(disty > dist)
            new_edge = 0;
        end
    end
    
   if((myX > midX && myY < midY))
        new_edge = 1;
        disty = enY - corners(1,1).y;
        distx = corners(2,2).x - enX
        if(disty > dist)
            new_edge = 2;
        end
   end
   
   if((myX > midX && myY > midY))
        new_edge = 3;
        disty = corners(2,2).y - enY;
        distx = corners(2,2).x - enX;
        if(disty > dist)
            new_edge = 2;
        end
   end
   
   if((myX < midX && myY > midY))
        new_edge = 3;
        disty = corners(2,2).y - enY;
        distx = enX - corners(1,1).x;
        if(disty > dist)
            new_edge = 0;
        end
   end
end



function new_edge = should_change_edge(myX, myY, enX, enY, curr_dest, corners)
    threshold = 0.1;

    new_edge = curr_dest;
    midx = (corners(2,2).x - corners(1,1).x) / 2;
    midy = (corners(2,2).y - corners(1,1).y) / 2;
    if(curr_dest == 0)
        if(myY < midy)
            if((enX > myX) && (enY < midY - threshold))
                new_edge = 2;
            end
        else
            if((enX > myX) && enY(enY > midY + threshold))
                new_edge = 2;
            end
        end
   end
    
   if(curr_dest == 1)
        if(myX < midX)
            if((enY > myY) && (enX < midX - threshold))
                new_edge = 3;
            end
        else
            if((enY > myY) && enY(enX > midX + threshold))
                new_edge = 3;
            end
        end
    end
    
    if(curr_dest == 2)
        if(myY < midy)
            if((enX < myX) && (enY < midY - threshold))
                new_edge = 0;
            end
        else
            if((enX < myX) && enY(enY > midY + threshold))
                new_edge = 0; 
            end
        end
    end
    
   if(curr_dest == 3)
        if(myX < midX)
            if((enY < myY) && (enX < midX - threshold))
                new_edge = 1;
            end
        else
            if((enY < myY) && enY(enX > midX + threshold))
                new_edge = 1;
            end
        end
   end
end

function edge = goToEdge(myX, myY, myTh, enX, enY, corners, HPS, myId)
    edge = chooseEdge(myX, myY, myTh, enX, enY, corners(1, 1).x,  corners(2, 2).x, corners(1, 1).y, corners(1,1).x);
    edge = edge-1;
    turnToEdge(myTh, edge)
    myPosition = HPS.getPosition(myId);
    turnToEdge(myPosition.th, edge);
    rot = move_to_edge(edge, myX, myY, corners)
    motor1 = NXTMotor('A', 'Power', -100, 'TachoLimit', floor(rot));
    motor2 = NXTMotor('B', 'Power', -100, 'TachoLimit',  floor(rot));
    motor1.SendToNXT();
    motor2.SendToNXT();
    motor1.WaitFor();
    motor2.WaitFor();
    
    edge = turnToEdge(myTh, mod(edge+1, 4));
end
