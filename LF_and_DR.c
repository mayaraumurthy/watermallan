#pragma config(Sensor, S1,     lightSensor,    sensorLightActive)
#pragma config(Sensor, S2,     sonarSensor,    sensorSONAR)
#pragma config(Motor,  motorA,          motorRight,    tmotorNXT, PIDControl, encoder)
#pragma config(Motor,  motorB,          motorLeft,     tmotorNXT, PIDControl, encoder)
//*!!Code automatically generated by 'ROBOTC' configuration wizard               !!*//

#include "localization.c"
#include "helpers.c"

bool goToGoal = false;

task main()
{
	int oldSensorVal=SensorValue[lightSensor];
	int desiredMin=44;
	int desiredMax=60;
	int prevError=0;
	int defaultPower = 5;
	int turnPower = 5;
	int powerL;
	int powerR;
	int error;
	int turn;
	int whiteCounter;
	int turnTime = 25;  //in miliseconds
	int blackThreshold = 150;
	float k= 3;

	float relGoalPos[2];

	int blackTime = 0;
	startTask(local_main);
	int currSensorVal;
	while(!stop_lf){
		displayTextLine(6, "X: %f", SensorValue[sonarSensor]);
		currSensorVal=SensorValue[lightSensor];
		if ((desiredMin <= currSensorVal) && ( currSensorVal <= desiredMax)) {
		  error = 0;
		  blackTime = 0;
	  } else if (currSensorVal < desiredMin) {
	    error = currSensorVal - desiredMin;
	    blackTime++;
	  } else {
	    error = currSensorVal - desiredMax;
	    blackTime = 0;
	  }
		turn=(int)(k*((float)error));
		if (blackTime > blackThreshold) {
			powerR = -50;
			powerL = 10;
			motor[motorLeft]=powerL;
	  	motor[motorRight]=powerR;
	  	wait1Msec(turnTime);
	  	motor[motorLeft]=defaultPower;
	  	motor[motorRight]=defaultPower;
	  	whiteCounter = 0;
	  	while ((SensorValue[lightSensor] > desiredMax) &&(whiteCounter <= 250)) {
	  		whiteCounter++;
	  	}
	  	continue;
		} else{
		  if (turn == 0) {
			  powerR = defaultPower;
			  powerL = defaultPower;
	    } else if (turn > 0) {
	  	  powerR=turnPower+turn;
	  	  //powerL=0;
	  	  powerL=turnPower-turn;
	    } else {
	      //powerR=0;
	    	powerR=turnPower+turn;
	  	  powerL=turnPower-turn;
	    }
	  }
		motor[motorLeft]=powerL;
		motor[motorRight]=powerR;
		prevError=error;
		oldSensorVal=currSensorVal;

	}
	 //displayTextLine(5, "loc %d  ", end_loc);
	  motor[motorLeft]=0;
		motor[motorRight]=0;
		nNxtButtonTask  = 0;

	displayTextLine(2, "%d %f %f", end_loc, robot_X, relGoalPos[0]);
	displayTextLine(3, "%d %f %f", end_loc, robot_Y, relGoalPos[1]);
	while(nNxtButtonPressed != kExitButton) {;}

}
