function [MP1, MP2] = makeMove (baseX, baseY, currX, currY, currTh, goalX, goalY)
    
    %base: the coordinates of corner (0,0).
    %curr: the coordinates of the robot (angle required).
    %goal: the point we want to go.
    %MP1, MP2: the power of two motors.

    ratio = 60; %camera dist to actual dist (in inch) 
   
    currX = (currX - baseX) * ratio;
    currY = (currY - baseY) * ratio;
    goalX = (goalX - baseX) * ratio;
    goalY = (goalY - baseY) * ratio;

    offX = 3.5;  %center of robot with respect to center of tag
    offY = 0;
    k = 1;  %k for PID (no need for pid so very large)
    L = 6.75;  %dist of wheel base 4.5
    R = 1.5;  %radius of wheel
    
    distX = (goalX - currX) * k;
    distY = (goalY - currY) * k;
    
    M = [cos(currTh) - sin(currTh) * offY / offX, ...
         sin(currTh) + cos(currTh) * offY / offX; ...
         -sin(currTh) / offX, cos(currTh) / offX];
    velocity = M * [distX; distY];
    v = velocity(1);
    w = velocity(2);
    
    MP1 = 90/pi * (2*v - L*w) / R;
    MP2 = 90/pi * (2*v + L*w) / R;
    if ((MP1 == 0) && (MP2 == 0))
        MP1 = 0;
        MP2 = 0;
    else  
        MP1 = round(MP1 / max(abs(MP1), abs(MP2)) * -20);
        MP2 = round(MP2 / max(abs(MP1), abs(MP2)) * -20);
    end
     
end