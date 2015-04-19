const float L1 = 3.75;
const float L2 = 2.5;

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

task main{
	check2 = getGoalDegree2(-3.75, 2.5, false);
	check1 = getGoalDegree1(-3.75, 2.5, check2);
}
