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
    
    
    pos = nextPos(myX,myY,enemyPosition.x,enemyPosition.y,0.2,0.2,8,0.1, corners(1,1).x,corners(2,1).x,corneres(1,1).x,corners(2,2).y);
    disp(strcat('x:', pos(1), 'y:', pos(2)))
    
end
end










%COM_CloseNXT all
%h = COM_OpenNXT('bluetooth.ini');
%COM_SetDefaultNXT(h)




function bestPos =bestNextPos(validPos,predX,predY)
    distances=(validPos(1,:)-predX)^2+(validPos(2,:)-predY)^2;
    [~,maxIdx]=max(distances);
    
    bestPos=[validPos(1,maxIdx);validPos(2,maxIdx)];

end

function validPos =filterNotValidPos(possiblePos,xL,xH,yL,yH,m)
    validPos=[];
    for i=1:length(possiblePos)
        preyX=possiblePos(1,i);
        preyY=possiblePos(2,i);
        
        if ((abs(preyX-xL)<m)&&(abs(preyX-xH)<m)&&(abs(preyY-yL)<m) &&(abs(preyY-yH)<m))
            validPos=horzcat(validPos,[preyX,preyY]);
        end
    end
end

function possiblePos =getNextPositions(preyX,preyY,spd,dT, numPos)
    angles=(0:(numPos-1))/numPos*(2*pi) ;
    possiblePos=[preyX+spd*dT*cos(angles);preyY+spd*dT*sin(angles)];    
end

function pos= nextPos(preyX,preyY,predX,predY,spd,dT,numPos,m,xL,xH,yL,yH)
    possiblePos=getNextPositions(preyX,preyY,spd,dT,numPos);
    validPos=filterNotValidPos(possiblePos,xL,xH,yL,yH,m);
    pos=bestNextPos(validPos,predX,predY);
end
