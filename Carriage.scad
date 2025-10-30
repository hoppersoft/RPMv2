include <Constants.scad>

PART_VERSION_STRING="v2.0";

module carriageArm() {
    translate([0,0,ARM_THICKNESS/2])
    rotate([0,90,0])
    {
        intersection()
        {
            cylinder(h=ARM_LENGTH, d=ARM_DIAMETER, center=true, $fn=100);
            cube([ARM_THICKNESS, ARM_DIAMETER, ARM_LENGTH],center=true);
        }
        translate([0,0, ARM_LENGTH/2-(SLEEVE_LENGTH-PEG_CHANNEL_PADDING)])
        {
          rotate([0,0,90]) {
              rotate([0,90,0]) 
                carriageRotationPegs();
          }
        }
    }
}

module carriageRotationPegs() {
    translate([0,0,-ARM_DIAMETER/2])
    sphere(d=PEG_DIAMETER);
    cylinder(h=ARM_DIAMETER,d=PEG_DIAMETER,center=true);
    translate([0,0,ARM_DIAMETER/2])
    sphere(d=PEG_DIAMETER);
}

module axle(tolerance=0) {
    translate([0,0,ARM_THICKNESS/2])
    rotate([0,90,0])
    {
        translate([0,0,-3-tolerance]) difference() {
            intersection() {
                cylinder(h=9+tolerance,d=ARM_DIAMETER+tolerance, center=true, $fn=100);
                cube([ARM_THICKNESS, ARM_DIAMETER*2, ARM_LENGTH],center=true);
            }
            cube([ARM_THICKNESS+1, ARM_THICKNESS/2 + .5, ARM_THICKNESS + 1], center=true);
        }
        // Inner axle    
        translate([0,0,5])
            cylinder(h=8,d=AXLE_INNER_DIAMETER+tolerance, center=true, $fn=100);
            
        translate([0,0,9-tolerance])
            cylinder(h=5+tolerance*2,d=ARM_THICKNESS+tolerance*2, center=true, $fn=100);
    }
}

// Tack support
module breezeway() {
  cut_through_width=TACK_HOUSING_WIDTH/2-2.5;
  translate([cut_through_width/4,(TACK_HOUSING_DEPTH+2)/2,1])
  rotate([90,0,0]) linear_extrude(TACK_HOUSING_DEPTH+2) polygon([
    [0,0],
    [0,cut_through_width],
    [cut_through_width,0]
  ]);
  translate([cut_through_width+2,(TACK_HOUSING_DEPTH+2)/2,(TACK_HOUSING_DEPTH+6)/2])
  rotate([-90,0,180]) linear_extrude(TACK_HOUSING_DEPTH+2) polygon([
    [0,0],
    [0,cut_through_width],
    [cut_through_width,0]
  ]);
}

module TackHousing() {
  union() {
    // wiper
    translate([TACK_HOUSING_WIDTH/2,TACK_HOUSING_DEPTH/2+1.5,-TACK_HOUSING_HEIGHT/2+1])
    rotate([0,90,180])
      linear_extrude(TACK_HOUSING_WIDTH) polygon([
        [0,0],
        [0,WIPER_HEIGHT-1+TACK_HOUSING_DEPTH],
        [1,WIPER_HEIGHT+TACK_HOUSING_DEPTH],
        [2,WIPER_HEIGHT-1+TACK_HOUSING_DEPTH],
        [2,0]
      ]);
    // Tack holder
    translate([0,1.5,0])
    difference() {
      // Body
      cube([
        TACK_HOUSING_WIDTH,
        TACK_HOUSING_DEPTH,
        TACK_HOUSING_HEIGHT
      ], center=true);
      // Tack hole
      translate([0,-TACK_HOUSING_DEPTH/2,0])
        rotate([90,0,0])
          rotate([0,0,90])
            cylinder(d=TACK_PIN_DIAMETER,h=16,center=true);
      translate([-TACK_HOUSING_WIDTH/2,0,-TACK_HOUSING_HEIGHT/2])
        breezeway();
      translate([TACK_HOUSING_WIDTH/2,0,TACK_HOUSING_HEIGHT/2])
        rotate([0,180,0]) breezeway();
      translate([TACK_HOUSING_WIDTH/2,0,-TACK_HOUSING_HEIGHT/2])
        rotate([0,0,180]) breezeway();
      translate([-TACK_HOUSING_WIDTH/2,0,TACK_HOUSING_HEIGHT/2])
        rotate([180,0,0]) breezeway();
    }
  }
}

module carriage() {
    union() {
        difference() {
            carriageArm();
            translate([-ARM_LENGTH/2-1.35, 0, 0])
            axle(.5);
            translate([12,0,3.5])
            rotate([0,0,180])
            linear_extrude(.5) text(font=TEXT_FONT, PART_VERSION_STRING, size=3, halign="center", valign="center");
        }
        translate([-ARM_LENGTH/2-1.75, 0, 0])
        axle();
        translate([ARM_LENGTH/2+TACK_HOUSING_WIDTH/2,0,4.5])
        rotate([-90,0,90])
        TackHousing();
    }
}

//horizontalSlice(3)
carriage();

//translate([0,0,6])
//#cube([SLEEVE_LENGTH-PEG_CHANNEL_PADDING*2, 1, .5]);
