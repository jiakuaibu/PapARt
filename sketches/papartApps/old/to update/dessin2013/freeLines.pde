

int FREE_LINES_MODE = 2311;

// MODE_NONE is accessible for all modes.
int lineMode = MODE_NONE;

int CREATE_LINE = 0;
int EDIT_LEFT = 1;
int EDIT_RIGHT = 2;

int EDIT_HORIZ = 40;
int EDIT_VERT = 41;
int EDIT_LINE_POS = 42;

// DEPRECATED ???

int EDIT_TAN_LEFT = 4;
int EDIT_TAN_RIGHT = 5;

int EDIT_WEIGHT = 3;
// EDIT = ...

PImage lineL, lineR, lineSel, lineWeight;
PImage greenImg, green1Img, greenHorizImg, greenVertImg, redBlueImg;
PImage lineSnap, lineSnapOff, indirectImg, directImg;
PImage hideImg, showImg;

ArrayList<Line> lines;
Line activeLine = null;
Line lastLine = null;

boolean isLineSnapOn = false;
boolean isIndirectOn = false;

boolean isSelecting = true;
int idFondSize = 15;
int startSelecting;
int selectionTextTime = 2000;

float yTouchOffset = 20f;

boolean use3DSelection = false;

void initFreeLinesMode(){
    
    lineL = loadImage(sketchPath + "/images/line-l.png");
    lineR = loadImage(sketchPath + "/images/line-r.png");
    lineSel = loadImage(sketchPath + "/images/line-s.png");

    green1Img = loadImage(sketchPath + "/images/green1.png");
    greenImg = loadImage(sketchPath + "/images/green.png");
    greenHorizImg = loadImage(sketchPath + "/images/cross1.png");

    redBlueImg = loadImage(sketchPath + "/images/red-blue.png");
    lineWeight = loadImage(sketchPath + "/images/line-w.png");
    lineSnap = loadImage(sketchPath + "/images/line-snap.png");
    lineSnapOff = loadImage(sketchPath + "/images/line-snap2.png");
    indirectImg = loadImage(sketchPath + "/images/indirect.png");
    directImg = loadImage(sketchPath + "/images/direct.png");

    hideImg = loadImage(sketchPath + "/images/hide.png");
    showImg = loadImage(sketchPath + "/images/show.png");

    lines = new ArrayList<Line>();

}

void enterFreeLinesMode(){
    resetFullNumPad();
    setActiveLine(null);
    exitSelection();
}

void leaveFreeLinesMode(){
    setActiveLine(null);
    lastLine = null;
    setNoActiveKey();
}


void exitSelection(){
    lineMode = MODE_NONE;

    lastLine = activeLine;
    setActiveLine(null);
    numPadSetTwoLinesText("Create or ", "choose line");
}


void setActiveLine(Line l){

    // Used only on creation...


    activeLine = l;

    if(l == null){
	int[] keys = {0, 3, 9};
	setActiveKeys(keys);

    }
    else{
	updateLineMode();
    }

}

void updateLineMode(){

    if(activeLine.isStandard()){
	setStdLineMode();
    } else {
	setPointMode();
    }

}

void setPointMode(){

    int[] keys = {0, 3, 4, 5, 6, 8, 10};
    setActiveKeys(keys);

    numPadSetTwoLinesText("Point Mode", "");
    //    numPadSetTwoLinesText("Point Mode", "point " + lines.indexOf(activeLine));
}

void setStdLineMode(){
    int[] keys = {0, 1, 2, 3, 6, 8, 10};
    setActiveKeys(keys);

    numPadSetTwoLinesText("Line Mode ", "");
    //    numPadSetTwoLinesText("Line Mode ", "line " + lines.indexOf(activeLine));
}


void backToEditLine(){

    lineMode = EDIT;
    updateLineMode();

}

void keyAllLines(){

    if(key == '*'){
	isLineSnapOn = !isLineSnapOn;
	if(isLineSnapOn){
	    numPadSetUpdateSecondLine("Snap ON");
	}else {
	    numPadSetUpdateSecondLine("snap OFF");
	}

    }

    keyIndirect();
}


void keyIndirect(){

    if(key == '9'){
	isIndirectOn = !isIndirectOn;
	if(isIndirectOn){
	    numPadSetUpdateSecondLine("Indirect mvt");
	}else {
	    numPadSetUpdateSecondLine("Direct mvt");
	}

    }

}

void keyFreeLines(){

    keyAllLines();


    //// Not used anymore ... 
    // if(key == '0'){
    // 	//	createStandardLine();
    // 	lineMode = EDIT;
    // }

    if(key == '.'){
	if(activeLine != null && lines.size() > 0) {
	    lines.remove(activeLine);
	}
	setActiveLine(null);
    }
    

    if((lineMode == EDIT || lineMode == MODE_NONE) && !lines.isEmpty()){
    	if(key == '+'){
    	    int id = (lines.indexOf(activeLine) + 1) % lines.size();
    	    setActiveLine(lines.get(id));

	    startSelecting = millis();
	    isSelecting = true;
    	}

    	if(key == '-'){
    	    int id = (lines.indexOf(activeLine) - 1) % lines.size();
    	    if(id < 0)
    		id = lines.size() - 1;
    	    setActiveLine(lines.get(id));

	    startSelecting = millis();
	    isSelecting = true;
    	}
    }


    if(keyCode == ENTER){
	exitSelection();
    }

    ////////// No active line - Create one ? ////////

    //    if(activeLine == null){
    
    if(key == '1'){
	createStandardLine();
	setStdLineMode();

	editStandardLine(EDIT_LEFT, "Set Red");
    }
    
    
    if(key == '4'){
	createPointLine();
	setPointMode();

	editPointLine();	
    }
    
    //    } 

    ////////// The next buttons require an active line ////////
    if(activeLine == null)
	return;
    

    // if(key == '1'){

    // 	// CREATE ONLY !!

    // 	// A Refaire
    // 	//	activeLine.setStandard(true);
    // 	// setStdLineMode();
    // 	// lineMode = MODE_NONE;

    // }


    // if(key == '4'){

    // 	// int[] keys = {3, 8, 10};
    // 	// setActiveKeys(keys);
	
    // }


    ////////// Standard mode buttons ///////////

    if(activeLine.isStandard()){

	if(key == '2'){
	    if(lineMode == EDIT_LEFT)
		backToEditLine();
	    else{
		editStandardLine(EDIT_LEFT, "Set Red");

	    }
	}

	if(key == '3')
	    if(lineMode == EDIT_RIGHT)
		backToEditLine();
	    else{
		editStandardLine(EDIT_RIGHT, "Set Blue");
	    }
    }

    else { ///////////////// Non standard mode Buttons ////////


	if(key == '5'){

	    if(lineMode == EDIT_LINE_POS){
		backToEditLine();
	    }
	    else{
		editPointLine();
	    }
	}


	if(key == '6'){

	    if(!activeLine.isStandard)
		((PointLine) activeLine).switchHorizonVert();

	}

    } 

    if(key == '7'){

	activeLine.isHidden = !activeLine.isHidden;
	if(activeLine.isHidden)
	    exitSelection();
    }



    // if(lineMode == EDIT_WEIGHT){

    // 	if(activeLine != null){
    // 	    if(key == '+'){
    // 		activeLine.w++;
    // 	    }
	   
    // 	    if(key == '-'){
    // 		activeLine.w--;
    // 		if(activeLine.w <= 0)
    // 		    activeLine.w = 1;
    // 	    }
    // 	}
    // }


}

void createPointLine(){
    Line l = new PointLine();
    setActiveLine(l);
    lines.add(l);

    // For stats
    creationPointLine++;
}

void createStandardLine(){
    Line l = new StandardLine();
    setActiveLine(l);
    lines.add(l);

    // For stats
    creationStandardLine++;
}

void editStandardLine(int mode, String text){

    lineMode = mode;
    
    int[] keys = {1, 2, 8, 10};
    setActiveKeys(keys);
    
    numPadSetUpdateSecondLine(text);
    
    startAnim = millis();
    editStandard++;
}

void editPointLine(){
    lineMode = EDIT_LINE_POS;
    
    int[] keys = {4, 5, 8, 10};
    setActiveKeys(keys);
    numPadSetUpdateSecondLine("Set Position");

    startAnim = millis();
    editPoint++;
}





void numPadLines(){

    if(isLineSnapOn)
	numPadImages[10] = lineSnap;
    else
	numPadImages[10] = lineSnapOff;

    numPadIndirect();
}

void numPadIndirect(){

    if(isIndirectOn)
	numPadImages[8] = indirectImg;
    else
	numPadImages[8] = directImg;
}


void touchFreeLines(TouchElement te){

    // Selection !

    if(use3DSelection && activeLine == null){
	for(PVector p : te.position3D){
	    
	    PVector p1 = p.get();
	    p1.x *= drawSize.x;
	    p1.y = p1.y * drawSize.y + yTouchOffset *2;
	    for(Line l : lines){
		for (PVector v : l.snapPoints){

		    float d = v.dist(p1);
		    if(d < 25){

			setActiveLine(l);
			// activeLine = l;
			l.setActive(v);
		    }

		}
	    }
	}
    }



    if(activeLine != null){
	if(!isIndirectOn && te.position2D.size() >= 1){
	    
	    PVector p0 = te.position2D.get(0);
	    p0 = PVector.mult(p0, drawSize);
	    p0.y += yTouchOffset;


	    if(activeLine.isStandard()){

		StandardLine l = (StandardLine) activeLine;
		
		if(lineMode == EDIT_LEFT){
		    l.moveLeftTo(p0);
		}
		
		if(lineMode == EDIT_RIGHT){
		    l.moveRightTo(p0);
		    
		}
	    } else {

		PointLine l = (PointLine) activeLine;
		if(lineMode == EDIT_LINE_POS ||
		   lineMode == EDIT_HORIZ ||
		   lineMode == EDIT_VERT){
		    l.movePosTo(p0);
		}
	    }

	}


	if(isIndirectOn && te.speed2D.size() >= 1){
	    
	    PVector p0 = te.speed2D.get(0);

	    if(activeLine.isStandard()){
		StandardLine l = (StandardLine) activeLine;


		if(lineMode == EDIT_LEFT)
		l.moveLeftBy(PVector.mult(p0, drawSize));
	    
	    if(lineMode == EDIT_RIGHT)
		l.moveRightBy(PVector.mult(p0, drawSize));

	    }else {
		PointLine l = (PointLine) activeLine;

		// TODO: this will change. 

		if(lineMode == EDIT_LINE_POS || 
		   lineMode == EDIT_HORIZ ||
		   lineMode == EDIT_VERT){
		    l.movePosBy(PVector.mult(p0, drawSize));
		}
		
	    }

	}
    }

}

void drawFreeLines(GLGraphicsOffScreen g){


    if(millis() - startSelecting > selectionTextTime )
	isSelecting = false;
    

    if(globalMode == FREE_LINES_MODE){

	numPadImages[0] = redBlueImg;
	numPadImages[1] = lineL;
	numPadImages[2] = lineR;

	numPadImages[3] = green1Img;
	numPadImages[4] = greenImg;
	numPadImages[5] = greenHorizImg;


	if(activeLine != null){
	    if(activeLine.isHidden){
		numPadImages[6] = showImg;
	    }else {
		numPadImages[6] = hideImg;
	    }


	}

	//	numPadImages[3] = tanLImg;
	//	numPadImages[4] = tanRImg;
	numPadLines();
    }
    
    // // Draw inside the virtual screen.

    g.strokeWeight(2);
    g.stroke(255);

    g.noFill();


    for(Line l : lines){
	l.drawSelf(g);
    }


}


int selectionAnimDuration = 1000;
int selectionAnimEndDist = 18;
int selectionAnimBeginDist = 80;


float getSizeAnimated(){
    float s = selectionAnimEndDist;
    int now = millis();
    
    // if still animating 
    if(now - startAnim < selectionAnimDuration){
	s = (int) lerp(selectionAnimEndDist, 
		       selectionAnimBeginDist, 
		       1f - (float)(now - startAnim) / (float)selectionAnimDuration);
    }
    return s;

}

