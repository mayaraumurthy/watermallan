#pragma config(Sensor, S2,     lightSensor,    sensorLightActive)
#pragma config(Motor,  motorA,          rightMotor,    tmotorNXT, PIDControl, reversed, encoder)
#pragma config(Motor,  motorB,          leftMotor,     tmotorNXT, PIDControl, reversed, encoder)
#pragma config(Motor,  motorC,          flipMotor,     tmotorNXT, PIDControl, encoder)
//*!!Code automatically generated by 'ROBOTC' configuration wizard               !!*//

#pragma debuggerWindows("joystickSimple");
//*!!Code automatically generated by 'ROBOTC' configuration wizard               !!*//
#include "linefollowing_USAR.c"
#include "JoystickDriver.c"

const int line_button = 2;
const int rev_button = 1;
const int fast_button = 16;
const int slow_button = 32;

float max(float a, float b){
	if (a > b) return a;
	else return b;
}

float min(float a, float b){
	if(a < b) return a;
	else return b;
}


task main()
{
	int line_mode = 1;
	float flipPos = 0;
	int stairMode = 1;

	float dir = -1;
	bool prevline_button = false;
	bool prevrev_button = false;
	nMotorEncoder[flipMotor] = 0;

	nMotorEncoder[flipMotor] = 0;
	while(true){
		getJoystickSettings(joystick);
		if(joystick.joy1_Buttons == line_button && !prevline_button){
				if(abs(dir) > 0.75){
					dir = dir * 0.1;
				}
				else if(abs(dir) < 0.75){
					dir = dir * 10;
				}
		}
		if(line_mode == 1){
			if(joystick.joy1_Buttons == rev_button && ! prevrev_button){
				dir = dir * -1;
			}
			/*if(joystick.joy1_Buttons == slow_button){
				if(abs(dir) > 0.75){
					dir = dir * 0.1;
				}
			}
			if(joystick.joy1_Buttons == fast_button){
				if(abs(dir) < 0.75){
					dir = dir * 10;
				}
			}*/

			//movement controllers
			if(dir > 0){
				if(abs(joystick.joy1_y1) > 10){
					motor[leftMotor] = joystick.joy1_y1 * dir;
				}else{
					motor[leftMotor] = 0;
				}
				if(abs(joystick.joy1_y2) > 10){
					motor[rightMotor] = joystick.joy1_y2 * dir;
				}else{
					motor[rightMotor] = 0;
				}
			}

		//reverse drive
		else {
			if(abs(joystick.joy1_y1) > 10){
				motor[rightMotor] = joystick.joy1_y1 * dir;
			}
			else{
				motor[rightMotor] = 0;
			}
			if(abs(joystick.joy1_y2) > 10){
				motor[leftMotor] = joystick.joy1_y2 * dir;
			}
			else{
				motor[leftMotor] = 0;
			}
		}
			//flipper controller
			if(joystick.joy1_Buttons == slow_button){
				motor[flipMotor] = -50;
			}
			else if(joystick.joy1_Buttons == fast_button){
				motor[flipMotor] = 50;
			}
			//camera controller
			else if(joystick.joy1_TopHat == 6){
				motor[flipMotor] = 10;
			}
			else if(joystick.joy1_TopHat == 2){
				motor[flipMotor] = -10;
			}
			else{
				motor[flipMotor] = 0;
			}
		}
		else{

		}
		displayTextLine(4, "encoder : %d  ", nmotorEncoder[flipMotor]);
		displayTextLine(6, "lightSensor %d  ", sensorValue[lightSensor]);
		displayTextLine(7, "button %d  ", joystick.joy1_Buttons);
		prevline_button = (joystick.joy1_Buttons == line_button);
		prevrev_button = (joystick.joy1_Buttons == rev_button);
	}
}