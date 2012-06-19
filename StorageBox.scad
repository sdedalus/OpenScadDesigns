boxHeight=12;
boxWidth=12;
boxDepth=12;
materialThickness=.25;

//boxjoin_baseWidth = 20;
//boxjoin_kerf = 0.2;

function IsOdd(number) = number%2==1;
function IsEven(number) = number%2==0;
function IntToBool(number) = abs(number)>0;
function BoolToInt(value) = value==false ? 0 : 1;

module BoxBase()
{


	difference(){
        cube(size = [boxWidth,boxDepth,boxHeight], center = true);
        translate(v=[0,0,materialThickness])
		cube(size = [boxWidth-(materialThickness*2),boxDepth-(materialThickness*2),boxHeight-materialThickness], center = true);
	}
}

module BoxjoinDie (dieCount=10,dieLength = 10,kerf = 0.0,angle=[0,0,0],dieOffset=true,toggleOrientation=false) {
	dieRatio=(dieLength/dieCount);
	insideDie=[materialThickness+.0001-kerf/2,materialThickness+.0001,dieRatio+.0001-kerf];
	outsideDie=[materialThickness+.0001-kerf/2,materialThickness+.0001,dieRatio+.0001-kerf/2];
	
	orientation=90*BoolToInt(!toggleOrientation);
	
		
		
	rotate(angle)
		rotate([0,0,orientation])
			translate(v=[0,0,dieLength/-2])
				for (i = [1:dieCount]) {
					if(IsOdd(i)==dieOffset)
							if(i==dieCount || i==1)
								if(i==1)
									translate(v=[0,0,i*dieRatio-(dieRatio/2)-kerf/4])
										cube(size = outsideDie, center = true);
								else
									translate(v=[0,0,i*dieRatio-(dieRatio/2)+kerf/4])
										cube(size = outsideDie, center = true);
							else
								translate(v=[0,0,i*dieRatio-(dieRatio/2)])
									cube(size = insideDie, center = true);
	}
}

module EvenSideDie(kerf){
	translate(v=[(boxWidth/2-materialThickness/4),-(boxDepth/2-materialThickness/4),0])
		BoxjoinDie(dieCount=boxHeight*2,dieLength=boxHeight,kerf=kerf,angle=[0,0,0],toggleOrientation=false,dieOffset=true);
}

module OddSideDie(kerf){
	translate(v=[(boxWidth/2-materialThickness/4),-(boxDepth/2-materialThickness/2),0])
		BoxjoinDie(dieCount=boxHeight*2,dieLength=boxHeight,kerf=kerf,angle=[0,0,0],toggleOrientation=true,dieOffset=false);
}


module BottomEdgeEvenSide(kerf){
	translate(v=[boxWidth/-2+materialThickness/4,0,boxHeight/-2-materialThickness/-4])
		BoxjoinDie(dieCount=boxDepth*2,dieLength=boxDepth,angle=[90,0,0],toggleOrientation=false,kerf=kerf,dieOffset=false);
							
}

module BottomSideEvenEdge(kerf){
	translate(v=[boxWidth/-2+materialThickness/4,0,boxHeight/-2-materialThickness/-4])
		BoxjoinDie(dieCount=boxDepth*2,dieLength=boxDepth,angle=[90,0,0],toggleOrientation=true,kerf=kerf,dieOffset=true);
							
}

module BottomEdgeOddSide(kerf){
	translate(v=[0,boxDepth/2+materialThickness/-2,boxHeight/-2-materialThickness/-4])
		BoxjoinDie(dieCount=boxWidth*2,dieLength=boxWidth,angle=[90,0,270],toggleOrientation=false,kerf=kerf,dieOffset=false);
					
}

module BottomSideOddEdge(kerf){
	translate(v=[0,boxDepth/2+materialThickness/-4,boxHeight/-2-materialThickness/-4])
		BoxjoinDie(dieCount=boxWidth*2,dieLength=boxWidth,angle=[90,0,270],toggleOrientation=true,kerf=kerf,dieOffset=true);
					
}

module BoxSide(number=1,kerf=0.0){
 offset = IsOdd(number);
	 // translate(v=[-(boxWidth/2-materialThickness/4),-(boxDepth/2-materialThickness/4),0])
						// BoxjoinDie(dieCount=boxHeight*2,dieLength=boxHeight,kerf=kerf,angle=[0,0,0],dieOffset=true==offset);
				difference(){
					BoxBase();
					// View Front Right Side + View Right Left Side
					mirror([0,0,0])
						if(offset)
							OddSideDie(kerf);
						else
							EvenSideDie(kerf);
					
					// View Front Left Side + View Left Right Side
					mirror([1,0,0])
						if(offset)
							OddSideDie(kerf);
						else
							EvenSideDie(kerf);
					
					// View Back Left Side + View Right Right Side 
					mirror([0,1,0])
						if(offset)
							OddSideDie(kerf);
						else
							EvenSideDie(kerf);
							
					// View Back Right Side + View Left Left Side 
					mirror([1,0,0])
					mirror([0,1,0])
						if(offset)
							OddSideDie(kerf);
						else
							EvenSideDie(kerf);
					
					// View Bottom top Side + View Front bottom Side 
					mirror([0,0,0])
					if(number==5)
						BottomSideEvenEdge(kerf);
					else
						BottomEdgeEvenSide(kerf);
					
					// View Bottom Bottom Side + View Back bottom Side 
					mirror([1,0,0])
					if(number==5)
						BottomSideEvenEdge(kerf);
					else
						BottomEdgeEvenSide(kerf);
					
					// View Bottom Right Side + View Right bottom Side 
					mirror([0,0,0])
					if(number==5)
						BottomSideOddEdge(kerf);
					else
						BottomEdgeOddSide(kerf);
					
					// View Bottom Left Side + View Left bottom Side
					mirror([0,1,0])
					if(number==5)
						BottomSideOddEdge(kerf);
					else
						BottomEdgeOddSide(kerf);
				}		
			 
}


module BoxTest(){

	 difference(){
		BoxBase();
		 //View Front Left Side + View Left Right Side
		 //-(boxDepth/2-materialThickness/2)
		translate(v=[-(boxWidth/2-materialThickness/2),-(boxDepth/2-materialThickness/2),0])
			BoxjoinDie(dieCount=boxHeight*2,dieLength=boxHeight,kerf=0.0,dieOffset=true);	 
	 
		 // View Front Right Side + View Right Left Side
		 translate(v=[(boxWidth/2-materialThickness/2),-(boxDepth/2-materialThickness/2),0])
			BoxjoinDie(dieCount=boxHeight*2,dieLength=boxHeight,kerf=0.0,dieOffset=true);
		

		// View Back Left Side + View Right Right Side 
		translate(v=[boxWidth/2-materialThickness/2,boxDepth/2-materialThickness/2,0])
			BoxjoinDie(dieCount=boxHeight*2,dieLength=boxHeight,kerf=0.0,dieOffset=true);
		
		// View Back Right Side + View Left Left Side
		translate(v=[boxWidth/-2-materialThickness/-2,boxDepth/2-materialThickness/2,0])
			BoxjoinDie(dieCount=boxHeight*2,dieLength=boxHeight,kerf=0.0,dieOffset=true);

		// View Bottom Left Side + View Left Bottom 
		translate(v=[boxWidth/-2+materialThickness/2,0,boxHeight/-2-materialThickness/-2])
			rotate(a=[90,0,0])
				BoxjoinDie(dieCount=boxDepth*2,dieLength=boxDepth,kerf=0.0,dieOffset=true);
				
		// View Bottom Right Side + View Right Bottom 
		translate(v=[boxWidth/2+materialThickness/-2,0,boxHeight/-2-materialThickness/-2])
			rotate(a=[90,0,180])
				BoxjoinDie(dieCount=boxDepth*2,dieLength=boxDepth,kerf=0.0,dieOffset=true);
		
		// View Bottom Bottom + View Back Bottom
		translate(v=[0,boxDepth/2+materialThickness/-2,boxHeight/-2-materialThickness/-2])
			rotate(a=[90,0,270])
				BoxjoinDie(dieCount=boxWidth*2,dieLength=boxWidth,kerf=0.0,dieOffset=true);
		
		// View Bottom Top + View Front Bottom
		translate(v=[0,boxDepth/-2+materialThickness/2,boxHeight/-2-materialThickness/-2])
			rotate(a=[90,0,90])
				BoxjoinDie(dieCount=boxWidth*2,dieLength=boxWidth,kerf=0.0,dieOffset=true);
	 }		


	// BoxjoinDie(dieCount=7,dieLength=boxHeight,kerf=0.2,dieOffset=true);
	
	// translate(v=[boxWidth/2+.25,boxWidth/2-materialThickness/2,0])
			// BoxjoinDie(dieCount=7,dieLength=boxHeight,kerf=0.0,dieOffset=0);
}


//BoxTest();
module front(){
projection (cut=true)	
		translate (v=[0,0,-(boxDepth/2-materialThickness/2)])
		rotate(a=[-90,0,0])		
			BoxSide(number=1,kerf=0.2);
}


module back(){
projection (cut=true)

		translate (v=[0,0,boxDepth/2-materialThickness/2])
		rotate(a=[-90,0,0])		
			BoxSide(number=3,kerf=0.2);
}


module right(){
projection (cut=true)
rotate(a=[0,0,90])
	translate (v=[0,0,-(boxWidth/2-materialThickness/2)])	
		rotate(a=[0,90,0])	
			BoxSide(number=2,kerf=0.2);
}

module left(){
projection (cut=true)
rotate(a=[0,0,90])
	translate (v=[0,0,(boxWidth/2-materialThickness/2)])	
		rotate(a=[0,90,0])	
			BoxSide(number=4,kerf=0.2);
}

module bottom(){
projection (cut=true)
rotate(a=[0,0,90])
	translate (v=[0,0,(boxHeight/2-materialThickness/2)])	
		//rotate(a=[90,90,90])	
			BoxSide(number=5,kerf=0.2);
}

// BoxSide(number=5,kerf=0.2);

front();
translate(v=[boxWidth+materialThickness+2,0,0])
	right();
	
translate(v=[0,boxHeight+materialThickness+2,0])
	back();
	
translate(v=[boxWidth+materialThickness+2,boxHeight+materialThickness+2,0])
	left();

translate(v=[boxWidth+materialThickness+2,(boxHeight+materialThickness+4)*2,0])
	bottom();