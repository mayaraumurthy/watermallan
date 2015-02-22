//#include "localization.c"

//interpret inputs to the obstacles array
void convertInput(int obs, data* d) {
  int i;
  for (i = 0; i < 10; i++) {
  	d->obstacles[i] = obs & 1;
  	obs = obs >> 1;
  }
}

//convert inch to mm
float inToMm(float in) {
	return in * 25.4;
}

float blocksToMM(int block){
	return inToMM(block*6);
}

//figure out relative positions to the bottom left corner facing away from the windows
void figurePos(float* pos, int indx) {
	switch (indx) {
		case 0:
		  pos[0] = blocksToMM(0);
		  pos[1] = blocksToMM(1);
		  break;
		case 1;
		  pos[0] = blocksToMM(0);
		  pos[1] = blocksToMM(2);
		  break;
	  case 2;
	    pos[0] = blocksToMM(0);
		  pos[1] = blocksToMM(3);
		  break;
		case 3;
	  	pos[0] = blocksToMM(-1);
		  pos[1] = blocksToMM(3);
		  break;
		case 4;
		  pos[0] = blocksToMM(-2);
		  pos[1] = blocksToMM(3);
		  break;
		case 5;
	  	pos[0] = blocksToMM(-2);
		  pos[1] = blocksToMM(2);
		  break;
		case 6;
		  pos[0] = blocksToMM(-2);
		  pos[1] = blocksToMM(1);
		  break;
		case 7;
		  pos[0] = blocksToMM(-2);
		  pos[1] = blocksToMM(-0);
		  break;
		case 8;
		  pos[0] = blocksToMM(-1);
		  pos[1] = blocksToMM(-1);
		  break;
		case 9;
		  pos[0] = blocksToMM(0);
		  pos[1] = blocksToMM(0);
		  break;
		default:
		  pos[0] = blocksToMM(-1.0);
		  pos[1] = blocksToMM(-1.0);
	}
	return;
}

//figure out the relative distances to travel
void figureDistance(float* posDiff, int curr, int goal) {
	float posCurr[2];
	float posGoal[2];

	figurePos(posCurr, curr);
	figurePos(posGoal, goal);
	posDiff[0] = posGoal[0] - posCurr[0];
	posDiff[2] = posGoal[1] - posCurr[1];
	return;
}

//determine the finish point, given current deadReckoning reading, current index and the goal index.
void figureGoal (float* goalPos, float prevX, float prevY, int curr, int goal) {
	float posDiff[2];

	figureDistance(posDiff, curr, goal);
	goalPos[0] = prevX + posDiff[0];
	goalPos[1] = prevY + posDiff[1];
}
