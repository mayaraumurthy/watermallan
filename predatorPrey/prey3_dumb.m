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
    
    
function edge  = chooseEdge(myX, myY, enX, enY, xL, xH, yL, yH)
    rectX = [xL, xL, xH, xH, xL];
    rectY = [yL, yH, yH, yL, yL];
    newX = enX + (myX - enX) * 10;
    newY = enY + (myY - enY) * 10;
    [x, y] = polyxpoly([enX, newX], [enY, newY], rectX, rectY);
    if ((size(x) ~= 1) || (y ~= 1))
        error('there should only be one point intersecting with the boundary!');
    end
    edge = 4;
    if (x == xL)
        edge = 2;
    end
    if (x == xH)
        edge = 0;
    end
    if (y == yL)
        edge = 3;
    end
    if (y =- yH)
        edge = 1;
    end
    if (edge == 4)
        error('not finding an edge!');
    end
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
        end - enY
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
