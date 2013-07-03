WallThickness = 2;
BallSize = 15.88;
Airgap = .5;
Mount = 3;
TotalHeight = 19.5;
MountScrewRad = 1.5;  //3mm screw
BallProtrude = .33; //percentage of ball radius sticking out 

MountType = 1;  //1=ears  2=center screw
ScrewSpacing = 25;


cylheight = TotalHeight;
cylrad = (BallSize/2) + WallThickness + Airgap;
echo (cylheight);
difference () {
	cylinder(r1 = cylrad , r2 = cylrad,  cylheight - (BallSize*BallProtrude));

	translate([0,0,TotalHeight - BallSize/2]) {
		cube(size = [cylrad*2+5, cylrad/2, BallSize*1.25], center = true );
		}

	translate([0,0,TotalHeight - (BallSize/2)]) {
		sphere (BallSize/2+Airgap, $fa=5, $fs=0.1);
		}
	}

difference (){
	linear_extrude(height=Mount)
	hull() {
		translate([ScrewSpacing/2,0,0]) {
			circle(  MountScrewRad*3);
			}
  		translate([1-ScrewSpacing/2,0,0]) {
			circle( MountScrewRad*3);
   			}
		circle( cylrad);
		}

	translate([ScrewSpacing/2,0,0]) {
		cylinder(r1 = MountScrewRad, r2 = MountScrewRad, h= Mount+2);
		}
  	translate([1-ScrewSpacing/2,0,0]) {
		cylinder(r1 = MountScrewRad, r2 = MountScrewRad, h= Mount+2);
   		}
}
