function output =prey2(input)



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
 corners = getCorner(HPS);
historysz= 10;
history=zeros(2,historysz);
largeTime=5;
smallTime=1;
dT=smallTime;
stdThreshold=.05;
enemyDistThreshold=.35;
counter=0;
while true
    myPosition = HPS.getPosition(myId);
    enemyPosition = HPS.getPosition(enemyId);
    
    % Do something with myPosition
    % You can access the x, y, and theta values like this:
    
   % myX = myPosition.x;
   % myY = myPosition.y;
    myTh = myPosition.th;
    myX = myPosition.x + .08*cos(myTh);  %% + offset relating to theta
    myY = myPosition.y + .08*sin(myTh); %% + offset relating to theta
    enemyX = enemyPosition.x;
    enemyY = enemyPosition.y;
    
    %update our history of coordinates
    history(:,(mod(counter,historysz)+1))=[myX;myY];
    
    %when enemy is close to us, observe standard deviation of history
    %if std is below threshold, then make dT large
    %switch dT back to small after this
   
    currDist=sqrt((myX-enemyX)^2+(myY-enemyY)^2);
    historyStd= sqrt(sqrt((var(history(1,:)))^2+(var(history(2,:)))^2));
    
    if (currDist<enemyDistThreshold) && (historyStd<stdThreshold)
        dT=largeTime;
    else
        dT=smallTime;
    end
    
    
    
    
    pos = nextPos(myX,myY,enemyPosition.x,enemyPosition.y,0.2,dT,8,0.12, corners(1,1).x,corners(2,2).x,corners(1,1).y,corners(2,2).y);
    
    [P1, P2] = makeMove(corners(1,1).x, corners(1,1).y, myX,myY,myTh, pos(1), pos(2));
    
    motor1 = NXTMotor('A', 'Power', P1);
    motor2 = NXTMotor('B', 'Power', P2);
    motor3 = NXTMotor('C', 'Power', 0);
    
    motor3.Stop('Brake');

    motor1.SendToNXT();
    motor2.SendToNXT();
    
    
end
end










%COM_CloseNXT all
%h = COM_OpenNXT('bluetooth.ini');
%COM_SetDefaultNXT(h)




function bestPos =bestNextPos(validPos,predX,predY)
    distances=(validPos(1,:)-predX).^2+(validPos(2,:)-predY).^2;
    [~,maxIdx]=max(distances);
    
    bestPos=[validPos(1,maxIdx);validPos(2,maxIdx)];

end

function validPos =filterNotValidPos(possiblePos,xL,xH,yL,yH,m)
    validPos=[];
    for i=1:length(possiblePos)
        preyX=possiblePos(1,i);
        preyY=possiblePos(2,i);
        
        if (~((preyX<(xL+m))||(preyY<(yL+m))||(preyX>(xH-m))||(preyY>(yH-m))))
            validPos=horzcat(validPos,[preyX ;preyY]);
        end
        
    end
    if (isempty(validPos))
        validPos=[-100; -100];
    end
end

function possiblePos =getNextPositions(preyX,preyY,spd,dT, numPos)
    angles=(0:(numPos-1))/numPos*(2*pi) ;
    possiblePos=[preyX+spd*dT*cos(angles);preyY+spd*dT*sin(angles)];    
end

function pos= nextPos(preyX,preyY,predX,predY,spd,dT,numPos,m,xL,xH,yL,yH)
    possiblePos=getNextPositions(preyX,preyY,spd,dT,numPos);
    validPos=filterNotValidPos(possiblePos,xL,xH,yL,yH,m);
    display(validPos);
    if ((validPos(1,1) == -100) && (validPos(2,1) == -100))
        pos = [preyX; preyY];
    else  
        pos=bestNextPos(validPos,predX,predY);
    end
end
