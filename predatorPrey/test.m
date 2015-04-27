COM_CloseNXT all
hNXT = COM_OpenNXT('bluetooth.ini');
COM_SetDefaultNXT(hNXT)


i = 0; 
while(true)
    if(mod(i, 2) == 0)
        motor1 = NXTMotor('A', 'Power', 100);
        motor2 = NXTMotor('B', 'Power', 100);
    else
        motor1 = NXTMotor('A', 'Power', -100);
        motor2 = NXTMotor('B', 'Power', -100);
    end
    
    
    motor1.SendToNXT();
    motor2.SendToNXT();
end
        
        
       