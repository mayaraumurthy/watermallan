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
OpenSwitch(SENSOR_1);
% ids => [1; 40] (for example)

enX_Prev =0;
enY_Prev = 0;
enTh_Prev = 0;
 corners = getCorner(HPS);
   enemyPosition = HPS.getPosition(enemyId);
while true
    myPosition = HPS.getPosition(myId);
    if(ismember(enemyID, 17))
        enemyPosition = HPS.getPosition(enemyId);
    end
    
    % Do something with myPosition
    % You can access the x, y, and theta values like this:
    
   % myX = myPosition.x;
   % myY = myPosition.y;
    myTh = myPosition.th;
    myX = myPosition.x + .08*cos(myTh);  %% + offset relating to theta
    myY = myPosition.y + .08*sin(myTh); %% + offset relating to theta
    
    
    pos = nextPos(myX,myY,enemyPosition.x,enemyPosition.y, 20,10,24, 0.5, corners(1,1).x,corners(2,2).x,corners(1,1).y,corners(2,2).y);
    
    [P1, P2] = makeMove(corners(1,1).x, corners(1,1).y, myX,myY,myTh, pos(1), pos(2));
    
    motor1 = NXTMotor('A', 'Power', P1);
    motor2 = NXTMotor('B', 'Power', P2);
    motor3 = NXTMotor('C', 'Power', 0);
    
    motor3.Stop('Brake');

    motor1.SendToNXT();
    motor2.SendToNXT();
    
    pause(0.5)
    
    if GetSwitch(SENSOR_1)
        NXT_PlayTone(800, 1000);
        motor1.Stop('brake');
        motor2.Stop('brake');
        break;
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
            disp('BECAME EMPTY')
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
    if ((validPos(1,1) == -100) && (validPos(2,1) == -100))
        pos = [preyX; preyY];
    else  
        pos=bestNextPos(validPos,predX,predY);
    end
end
