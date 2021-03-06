//#include <stdbool.h>
//#include <stdio.h>
//#include <assert.h>

typedef struct space
{
	int matrix[19][10]; //change to fit gridsize
	int rows;
	int cols;
} space;

typedef struct node
{
	struct node* prev;
	struct node* next;
	int r;
	int c;
} node;

typedef struct queue
{ node* front;
	node* back;
} queue;

typedef struct loc
{
	float r;
	float c;
	float dist;
}loc;

typedef struct path{
	loc waypoints[100];
	int pathLength;
	float dir[2];
	bool validPath;
}path;
 //#define NULL ((void *)0)

node neighbors[500]; /// might need to be changed to handle larger grid

loc temp[100];

bool is4pt=true;

struct space S_full;


/*
{{0, 0, 0, 1, 1, 0, 0, 0},
{0, 0, 0, 1, 1, 0, 0, 0},
{0, 0, 1, 1, 1, 0, 0, 0},
{0, 0, 1, 1, 0, 0, 0, 0},
{0, 0, 0, 1, 1, 1, 0, 0},
{0, 0, 1, 1, 1, 1, 0, 0},
{0, 0, 1, 1, 1, 0, 0, 0},
{0, 0, 0, 1, 1, 0, 0, 0},
{0, 0, 0, 1, 1, 1, 0, 0},
{0, 1, 1, 0, 1, 0, 0, 0},
{0, 1, 1, 0, 0, 0, 1, 0},
{0, 0, 0, 0, 0, 0, 1, 0},
{0, 0, 0, 0, 1, 1, 0, 0},
{0, 0, 0, 0, 1, 1, 1, 1},
{0, 0, 0, 0, 0, 0, 1, 1},
{0, 0, 0, 0, 0, 0, 0, 0}};
*/



bool isEmpty(queue* Q){
	if(Q->back) return false;
	else return true;

}


void enq(queue* Q,node* n){
	if (isEmpty(Q)){

		Q->front=n;
		Q->back=n;
		n->prev=NULL;
		n->next=NULL;
	}else{
		Q->back->next=n;
		n->prev=Q->back;
		Q->back=n;
		n->next=NULL;
	}

}


bool fourPoint(int dr,int dc){
	return (is4pt &&((dc*dr)==0));
}

node* deq(queue* Q){
	if (Q==NULL) ASSERT(false);
	node* n=Q->front;
	if (Q->front==NULL) ASSERT(false);
	Q->front=Q->front->next;
	if (Q->front==NULL){
		Q->back=NULL;
	}else{
		Q->front->prev=NULL;
	}
	return n;

}

bool isInBounds(int r,int c, space* S){
	return (r>=0)&&(c>=0)&&(r<(S->rows))&&(c<(S->cols));
}
int findMinAdjRC(space* S,int r,int c, int rDir,int cDir){
	int currR;
	int currC;
	int dr;
	int dc;
	int minR=r;
	int minC=c;
	int minVal=1000;
	int dist;
	//check the one that is in its direction
	int inDirR=r+rDir;
	int inDirC=c+cDir;
	if ((isInBounds(inDirR,inDirC,S)) &&(!(S->matrix[inDirR][inDirC]==1))){
		if ((S->matrix[inDirR][inDirC])<((S->matrix[r][c]))){
			return inDirR*(S->cols)+inDirC;
		}
	}

	for (dr=-1;dr<=1;dr++){
		for (dc=-1;dc<=1;dc++){
			if ((!((dr==0) && (dc==0)))&&((dc*dr)==0)){//
				currR=r+dr;
				currC=c+dc;
				if ((isInBounds(currR,currC,S)) &&(!(S->matrix[currR][currC]==1))){
					dist=S->matrix[currR][currC];
					if (dist<minVal){
						minVal=dist;
						minR=currR;
						minC=currC;
					}

				}
			}
		}
	}
	return minR*(S->cols)+minC;

}

int getRow(space* S,int index){
		return index/(S->cols);
}
int getCol(space* S,int index){
	return index % (S->cols);
}

void findPath(space*S,int startR,int startC, path* pathArray, int rDir, int cDir){
	int rowColIndex;
	int prevR;
	int prevC;

	int r=startR;
	int c=startC;

	pathArray->waypoints[1].r=startR;
	pathArray->waypoints[1].c=startC;

	int arrayIndex=2;

	while(true){
		rowColIndex=findMinAdjRC(S,r,c,rDir,cDir);
		prevR=r;
		prevC=c;
		r=getRow(S,rowColIndex);
		c=getCol(S,rowColIndex);

		rDir=r-prevR;
		cDir=c-prevC;

		pathArray->waypoints[arrayIndex].r=r;
		pathArray->waypoints[arrayIndex].c=c;



		if ((S->matrix[r][c])==2) {
			pathArray->dir[0] = rDir;
			pathArray->dir[1] = cDir;
			arrayIndex++;
			break;
		}
		arrayIndex++;


	}


	pathArray->pathLength=arrayIndex;
	//-1 R -1 C DENOTES END OF PATH
	pathArray->waypoints[arrayIndex+1].r=-1;
	pathArray->waypoints[arrayIndex+1].c=-1;

}

int calcDist (int x1, int y1, int x2, int y2) {
	 return abs(x1 - x2) + abs(y1 - y2);
}

void getCritical(path* pathArray) {
	int prevR,prevC;
	int currR, currC;
	int nextR, nextC;
	int dirx1, dirx2, diry1, diry2;
	int currIndex = 0;
	int counter = 0;
	int distTotal = 0;

	temp = *pathArray;
	temp[counter].r = pathArray->waypoints[currIndex].r;
	temp[counter].c = pathArray->waypoints[currIndex].c;
	counter = counter + 1;
	do {
	  nextR = pathArray->waypoints[currIndex + 2].r;
	  nextC = pathArray->waypoints[currIndex + 2].c;
		currR = pathArray->waypoints[currIndex + 1].r;
		currC = pathArray->waypoints[currIndex + 1].c;
		prevR = pathArray->waypoints[currIndex].r;
		prevC = pathArray->waypoints[currIndex].c;
		dirx1 = currR - prevR;
		dirx2 = nextR - currR;
		diry1 = currC - prevC;
		diry2 = nextC - currC;
		if ((dirx1 != dirx2) || (diry1 != diry2)) {
			 temp[counter].r = pathArray->waypoints[currIndex + 1].r;
			 temp[counter].c = pathArray->waypoints[currIndex + 1].c;
			 counter = counter + 1;
    }
    currIndex = currIndex + 1;
	} while ((nextR != -1) && (nextC != -1));
	temp[counter].r = currR;
  temp[counter].c = currC;
  counter = counter + 1;
  temp[counter].r = -1;
  temp[counter].c = -1;
  for (int i = 0; i < counter + 1; i++) {
  	pathArray->waypoints[i].r = temp[i].r;
  	pathArray->waypoints[i].c = temp[i].c;
    if (i >= counter - 1) {
      pathArray->waypoints[i].dist = 0;
    } else {
      pathArray->waypoints[i].dist = calcDist(temp[i + 1].r, temp[i + 1].c, temp[i].r, temp[i].c);
    }
    distTotal = distTotal + pathArray->waypoints[i].dist;
  }
  pathArray->pathLength = distTotal;
}


void wavefront(int r,int c, space* S){
	int label=2;
	int dr;
	int dc;
	int neighbR;
	int neighbC;
	node* neighbor;
	int neighbIdx=0;

	queue Q;
	Q.front=NULL;
	Q.back=NULL;
	node firstNode;
	firstNode.r=r;
	firstNode.c=c;
	S->matrix[r][c]=label;


	enq(&Q, &firstNode);

	node* currNode;


	while (!(isEmpty(&Q))){
		currNode=deq(&Q);
		r=currNode->r;
		c=currNode->c;

		for (dr=-1;dr<=1;dr++){
			for (dc=-1;dc<=1;dc++){
				if ((!((dr==0) && (dc==0)))&&((dc*dr)==0)){//
					neighbR=r+dr;
					neighbC=c+dc;
					if ((isInBounds(neighbR,neighbC,S))&&(S->matrix[neighbR][neighbC]==0)){
						S->matrix[neighbR][neighbC]=S->matrix[r][c]+1;
						neighbor=&neighbors[neighbIdx];
						neighbIdx++;

						neighbor->r=neighbR;
						neighbor->c=neighbC;
						enq(&Q,neighbor);
					}
				}
			}
		}


	}


}

void initializeStuff(path *pathArray){
  S_full.cols = 10;
	S_full.rows = 19;

	for(int i = 0; i < S_full.rows; i++){
		for(int j = 0; j < S_full.cols; j++){
			S_full.matrix[i][j] = 0;
		}
	}
	S_full.matrix[0][0] = 1;S_full.matrix[0][1] = 1;
  S_full.matrix[1][0] = 1;S_full.matrix[1][1] = 1;
  S_full.matrix[2][0] = 1;S_full.matrix[2][1] = 1;
  S_full.matrix[3][0] = 1;S_full.matrix[3][1] = 1;
  S_full.matrix[4][0] = 1;S_full.matrix[4][1] = 1;
  S_full.matrix[5][0] = 1;S_full.matrix[5][1] = 1;
  S_full.matrix[6][0] = 1;S_full.matrix[6][1] = 1;
  S_full.matrix[7][0] = 1;S_full.matrix[8][0] = 1;


 S_full.matrix[6][4] = 1;S_full.matrix[6][5] = 1; S_full.matrix[6][6] = 1;
 S_full.matrix[7][4] = 1;S_full.matrix[7][5] = 1; S_full.matrix[7][6] = 1;S_full.matrix[7][3] = 1;
 S_full.matrix[8][3] = 1;S_full.matrix[8][4] = 1;S_full.matrix[8][5] = 1;S_full.matrix[8][6] = 1;
 S_full.matrix[9][3] = 1;S_full.matrix[9][4] = 1;S_full.matrix[9][5] = 1;
 S_full.matrix[10][2] = 1;S_full.matrix[10][3] = 1;S_full.matrix[10][4] = 1;S_full.matrix[10][5] = 1;
 S_full.matrix[11][2] = 1;S_full.matrix[11][3] = 1;S_full.matrix[10][4] = 1;S_full.matrix[12][2]
 S_full.matrix[12][5] = 1;S_full.matrix[12][4] = 1;

 S_full.matrix[9][8]=1;
S_full.matrix[10][8]=1;
S_full.matrix[11][8]=1;
S_full.matrix[12][8]=1;
S_full.matrix[13][8]=1;
S_full.matrix[14][8]=1;
S_full.matrix[15][8]=1;
S_full.matrix[16][8]=1;
S_full.matrix[17][8]=1;

S_full.matrix[12][7]=1;
S_full.matrix[13][7]=1;
S_full.matrix[14][7]=1;
S_full.matrix[15][7]=1;
S_full.matrix[16][7]=1;
S_full.matrix[17][7]=1;

	for(int i = 0; i < 500; i++){
		neighbors[i].r = 0;
		neighbors[i].c = 0;
		neighbors[i].prev = NULL;
		neighbors[i].next = NULL;
	}

	pathArray->validPath = false;
	pathArray->pathLength = 0;
	for(int i = 0; i < 100; i ++){
		pathArray->waypoints[i].r = 0;
		pathArray->waypoints[i].c = 0;
		pathArray->waypoints[i].dist = 0;
		temp[i].r = 0;
		temp[i].c = 0;
		temp[i].dist = 0;
	}

}



void calcPath(path* pathArray, int goalRow, int goalCol, int startRow, int startCol)
{
	initializeStuff(pathArray);

	if(goalRow > 0 && goalCol < S_full.rows){
		if(goalCol > 0 && goalRow < S_full.rows){
				if(S_full.matrix[goalRow][goalCol] == 1) return;
		}
		else return;
	}
	else return;


	pathArray->validPath = true;
	wavefront(goalRow,goalCol,&S_full);

	findPath(&S_full,startRow,startCol,pathArray,1,0);
	//getCritical(pathArray);
}
