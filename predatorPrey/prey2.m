function output =prey2(input)



offset = .08; %forward
% Example HowiePositioningSystem Usage
% Example team's tag id is 1, their opponent's tag id is 40

COM_CloseNXT all
hNXT = COM_OpenNXT('bluetooth.ini');
COM_SetDefaultNXT(hNXT)

myId = 7;
enemyId = 31;

HPS = HowiePositioningSystem;

ids = HPS.getVisibleIds();
OpenSwitch(SENSOR_1);
% ids => [1; 40] (for example)

enX_Prev =0;
enY_Prev = 0;
enTh_Prev = 0;
corners = getCorner(HPS);
historysz= 10;
history=zeros(2,historysz);
largeTime=50;
smallTime=15;
stdThreshold=.2;
enemyDistThreshold=.45;
counter=0;
timeCount = 0;
timeLimitForLocalMin = 5;
while true
    enemyPosition = HPS.getPosition(enemyId);
    myPosition = HPS.getPosition(myId);
    
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
    historyStd= (sqrt((var(history(1,:)))^2+(var(history(2,:)))^2));
    
    %display([currDist, historyStd]);
    if (currDist<enemyDistThreshold) && (historyStd<stdThreshold) && (timeCount == 0)
        dT=largeTime;
        disp('IN LOCAL MINEMA!!');
        timeCount = timeCount + 1;
    else
        if (timeCount > 0)
              dT=largeTime;
        else
              dT=smallTime;
        end
    end
    
    
    pos = nextPos(myX,myY,enemyPosition.x,enemyPosition.y, 20,dT,24, 0.1, corners(1,1).x,corners(2,2).x,corners(1,1).y,corners(2,2).y);
    
    [P1, P2] = makeMove(corners(1,1).x, corners(1,1).y, myX,myY,myTh, pos(1), pos(2));
    
    motor1 = NXTMotor('A', 'Power', P1);
    motor2 = NXTMotor('B', 'Power', P2);
    motor3 = NXTMotor('C', 'Power', 0);
    
    motor3.Stop('Brake');

    motor1.SendToNXT();
    motor2.SendToNXT();
    
    pause(0.5);
    
    if GetSwitch(SENSOR_1)
        NXT_PlayTone(800, 1000);
        motor1.Stop('brake');
        motor2.Stop('brake');
        break;
    end
    
    if (timeCount == timeLimitForLocalMin)
        timeCount = 0;
    end
    
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

function validPos =filterNotValidPos(possiblePos,xL,xH,yL,yH,m,should_recurse)
   
    validPos=[];
    for i=1:length(possiblePos)
        preyX=possiblePos(1,i);
        preyY=possiblePos(2,i);
        
        if (~((preyX<(xL+m))||(preyY<(yL+m))||(preyX>(xH-m))||(preyY>(yH-m))))
            validPos=horzcat(validPos,[preyX ;preyY]);
        end
        
    end
    if (isempty(validPos))
        if(should_recurse)
            disp('BECAME EMPTY');
            validPos =filterNotValidPos(possiblePos,xL,xH,yL,yH,0*m, false);
        else
            NXT_PlayTone(800, 1000);
            NXT_PlayTone(800, 1000);
        end
        
    end
    
end

function possiblePos =getNextPositions(preyX,preyY,spd,dT, numPos)
    angles=(0:(numPos-1))/numPos*(2*pi) ;
    possiblePos=[preyX+spd*dT*cos(angles);preyY+spd*dT*sin(angles)]; 
    %possiblePos=horzcat(possiblePos,[preyX;preyY]);
end

function pos= nextPos(preyX,preyY,predX,predY,mp,dT,numPos,m,xL,xH,yL,yH)
    spd = 1.5/(5*12)*mp/100*125/60;
    possiblePos=getNextPositions(preyX,preyY,spd,dT,numPos);
    validPos=filterNotValidPos(possiblePos,xL,xH,yL,yH,m, true);
    display(validPos);

    pos=bestNextPos(validPos,predX,predY);
end
