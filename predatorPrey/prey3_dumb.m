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



function output = goToEdge(~, myY, myTh, enemyPos, corners)

end
