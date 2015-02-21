typedef struct data
{
	int obstacles[14];
	float sensorReadings[14];
	float probs[14];
	int size;
} data;

void shiftProbs(data* D, bool shiftLeft){
	//copy probabilities to another array
	int i;

	if (shiftLeft){
		float firstProb=D->probs[0];
		for(i=0;i<((D->size));i++){
			D->probs[i]=D->probs[i+1];
		}
		D->probs[(D->size)-1]=firstProb;
	}else{ //shift right
		float lastProb=D->probs[(D->size)-1];
		for(i=((D->size)-1);i>=0;i--){
			D->probs[i]=D->probs[i-1];
		}
		D->probs[0]=lastProb;
	}
}

void normalize(float* array,int size){
	//find max
	int i;
	float max=-1.0;
	for(i=0;i<size;i++){
		if (array[i]>=max) max=array[i];
	}

	for(i=0;i<size;i++){
		array[i]=array[i]/max;
	}

}


void multProbsSensor(data* D){
	int i;
	for(i=0;i<((D->size));i++){
		D->probs[i]=(D->probs[i])*(D->sensorReadings[i]);
	}
}

void updateSensorReadings(data* D, bool sensedObstacle){
	int i;
	for(i=0;i<((D->size));i++){
		if (sensedObstacle){
			D->sensorReadings[i]=D->obstacles[i];
		}else{
			//put a one for every location without an obstacle

			D->sensorReadings[i]=(float)(((int)(D->obstacles[i]))^1);

		}
	}
}




task main()
{

}
