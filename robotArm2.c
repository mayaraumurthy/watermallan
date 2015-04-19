const float L1 = 3.75;
const float L2 = 2.5;
const float radianPerBox = 0;


float check1 = 0;
float check2 = 0;

float getGoalDegree2(float x, float y, bool inFirstHalf){
		float angle = acos(
		((x*x) + (y*y) - (L1*L1) - (L2*L2))/(2*L1*L2)
		);

		if(inFirstHalf || angle == 0) return angle;
		return ((2 * PI) - angle);
}


float getGoalDegree1(float x, float y, float theta2){
	float alpha = 0;
	if(x == 0) alpha = (PI/2);
	else alpha = atan(y/x);

	if(x < 0) alpha = (-alpha) + (PI/2);

	return alpha - asin( (L2 * sin (theta2)) / sqrt( (x * x) + (y*y)));
}

void goToDegree(int d){
}


void goToDegree(float r1,float r2){ //DON'T FORGET TO RESET ENCODER VALUE TO BE ZERO AT THE BEGINNING
	nMotorEncoderTarget[motorA]=r1*180/PI;
	nMotorEncoderTarget[motorB]=r2*180/PI;
	motor[motorA]=50;
	float allowedError=5*PI/180;
	while ((abs((nMotorEncoder[motorA])-r1))<allowedError){
		wait10Msec(1);
	}
	motor[motorA]=0;;
	motor[motorB]=50;
	while ((abs((nMotorEncoder[motorB])-r2))<allowedError){
		wait10Msec(1);
	}
	motor[motorB]=0;
}

int fromRadianToBox(float radian){
	return (int)(radian/radianPerBox);
}

float fromBoxToRadian(int box){
	return (((float)(box))*radianPerBox);
}

void goToExactGoal(float goalR1, float goalR2){
	goToDegree(goalR1,goalR2);
}

task main()
{


}
