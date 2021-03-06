
//*!!Code automatically generated by 'ROBOTC' configuration wizard               !!*//

/*****************************************
 * Lab 3 : Starter code
 * Written by Kaushik Viswanathan
 *****************************************/
//hello
//Global variables - you will need to change some of these
float robot_X = 0.0, robot_Y = 0.0, robot_TH = 0.0;
int velocityUpdateInterval = 5;
int PIDUpdateInterval = 2;
int inputA[3] = {60, -30, -30};
int inputB[3] = {50, 30, -42};
//int inputA[3] = {60, 0, 0};
//int inputB[3] = {50, 0, 0};
const float radius = 28;
const float base = 132;

float accumL = 0;
float accumR = 0;

float tError = 0;
float r = 0;


/*****************************************
 * Complete this function so that it
 * continuously updates the robot's position
 *****************************************/
task dead_reckoning()
{

	float prevX = 0;
	float prevY = 0;
	float prevAngle = 0;

	int prevTicksR = 0;
	int prevTicksL = 0;

	int currTicksR =0;
	int currTicksL =0;

	float prevTime = 0;
	float currTime=0;

	float timeLapse;
	while(1)
	{
		//
		//Fill in code for numerical integration / position estimation here
		currTicksR = nMotorEncoder[motorRight];
		currTicksL = nMotorEncoder[motorLeft];

		currTime = (float)nPgmTime;
		timeLapse = currTime - prevTime;
		prevTime = currTime;

		float ticksL = currTicksL - prevTicksL;
		float ticksR = currTicksR - prevTicksR;


		accumL += ticksL;
		accumR += ticksR;


		float velL=((float)(ticksL/timeLapse)) * radius*PI/180;
		float velR=((float)(ticksR/timeLapse)) * radius*PI/180;

		float vel = (velL + velR)/2;
		float angVel = (velR - velL)/base;


		float k00 = vel * cos(prevAngle);
		float k01 = vel * sin(prevAngle);
		float k02 = angVel;

		float k10 = vel * cos(((float)prevAngle) + ((float)(timeLapse/2))*k02);
		float k11 = vel * sin(((float)prevAngle) + ((float)(timeLapse/2))*k02);
		float k12 = angVel;

		float k20 = vel * cos(prevAngle + ((float)(timeLapse/2))*k12);
		float k21 = vel * sin(prevAngle + ((float)(timeLapse/2))*k12);
		float k22 = angVel;

		float k30 = vel * cos(prevAngle + ((float)(timeLapse))*k22);
		float k31 = vel * sin(prevAngle + ((float)(timeLapse))*k22);
		float k32 = angVel;


		prevX = prevX + ((float)timeLapse/6) * (k00+2*(k10+k20)+k30);
		prevY = prevY + ((float)timeLapse/6) * (k01+ 2*(k11+k21)+k31);
		prevAngle = prevAngle + ((float)timeLapse/6) * (k02+ 2*(k12+k22)+k32);

		prevTicksL = currTicksL;
		prevTicksR = currTicksR;

		robot_X = prevX;
		robot_Y = prevY;
		robot_TH = prevAngle;


		if(accumL - accumR == 0){
			r = -1;
	  }else{
	  	r = (accumL * base)/(accumL - accumR);
	  	r = -r;
	  }


		//writeDebugStream("%f% \n", radius);







		//Code that plots the robot's current position and also prints it out as text
		//writeDebugStream("%f\n", robot_X);
		/*setPixel(50 + (int)(100.0 * robot_X), 32 + (int)(100.0 * robot_Y));
		displayTextLine(0, "X: %f", robot_X);
		displayTextLine(1, "Y: %f", robot_Y);
		displayTextLine(2, "t: %f", (57.2958 * robot_TH) % 360);
	  displayTextLine(3, "r: %f", r);*/

		wait1Msec(velocityUpdateInterval);
	}
}

/*****************************************
 * Function that draws a grid on the LCD
 * for easier readout of whatever is plot
 *****************************************/


void draw_grid()
{
	for(int i = 0; i < 65; i++)
	{
		setPixel(50, i);
		int grid5 = (i - 32) % 5;
		int grid10 = (i - 32) % 10;
		if(!grid5 && grid10)
		{
			for(int j = -2; j < 3; j++)
			{
				setPixel(50 + j, i);
			}
		}
		else if(!grid10)
		{
			for(int j = -4; j < 5; j++)
			{
				setPixel(50 + j, i);
			}
		}
	}
	for(int i = 0; i < 101; i++)
	{
		setPixel(i, 32);
		int grid5 = (i - 100) % 5;
		int grid10 = (i - 100) % 10;
		if(!grid5 && grid10)
		{
			for(int j = -2; j < 3; j++)
			{
				setPixel(i, 32 + j);
			}
		}
		else if(!grid10)
		{
			for(int j = -4; j < 5; j++)
			{
				setPixel(i, 32 + j);
			}
		}
	}
}

/*****************************************
 * Main function - it is not necessary to
 * modify this
 *****************************************/
task dr_main()
{
  /* Reset encoders and turn on PID control */
	nMotorEncoder[motorRight] = 0;
	nMotorEncoder[motorLeft] = 0;
	nMotorPIDSpeedCtrl[motorRight] = mtrSpeedReg;
	nMotorPIDSpeedCtrl[motorLeft] = mtrSpeedReg;
	nPidUpdateInterval = PIDUpdateInterval;

	//getInput();

	draw_grid();
	time1[T1] = 0;
	startTask(dead_reckoning);

	for(int i = 0; i < 3; i++)
	{
		motor[motorRight] = inputA[i];
		motor[motorLeft] = inputB[i];



		wait1Msec(1000 * 5);

		if(inputA[i] != inputB[i]){
				tError += (46.87-r*.0866);
		}

	  accumL = 0;
	  accumR = 0;
  }

  	/*setPixel(50 + (int)(100.0 * robot_X), 32 + (int)(100.0 * robot_Y));
		displayTextLine(0, "X: %f", robot_X);
		displayTextLine(1, "Y: %f", robot_Y);
		displayTextLine(2, "t: %f", (float)((57.2958 * robot_TH) % 360));
	  displayTextLine(3, "r: %f", r);*/

  motor[motorRight] = 0;
	motor[motorLeft] = 0;
	nNxtButtonTask  = 0;
	while(nNxtButtonPressed != kExitButton) {;}
}
