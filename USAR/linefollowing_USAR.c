int left = leftMotor;
int right = rightMotor;

int oldSensorVal=SensorValue[lightSensor];
const int desiredMin=45
const int desiredMax=55
int prevError=0;
const int defaultPower = 25
const int turnPower = 15
int powerL;
int powerR;
int error;
int turn;
int whiteCounter;
int turnTime = 100//in miliseconds
const int blackThreshold = 100
float k = 3

int blackTime = 0

int currSensorVal;

void line_reset(){
	oldSensorVal=SensorValue[lightSensor];
	prevError=0;
	blackTime = 0
}


void line_following()
{
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
		motor[left]=powerL;
		motor[right]=powerR;
		wait1Msec(turnTime);
		motor[left]=defaultPower;
		motor[right]=defaultPower;
		whiteCounter = 0;
		while ((SensorValue[lightSensor] > desiredMax) &&(whiteCounter <= 250)) {
			whiteCounter++;
		}
		return;
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
	displayTextLine(4, " %d  ", blackTime);
	motor[left]=powerL;
	motor[right]=powerR * 5
	prevError=error;
	oldSensorVal=currSensorVal;
}
