include <Constants.scad>
use <Blade.scad>

PART_VERSION_STRING="v2.0";

module sleeve() {
  difference() {
    // Sleeve body
    union() {
      cylinder(h=SLEEVE_LENGTH, d=SLEEVE_DIAMETER);
      // Mount
      translate([-SLEEVE_DIAMETER/4,0,SLEEVE_HOUSING_LENGTH/2])
      {
        cube([SLEEVE_DIAMETER/2,SLEEVE_DIAMETER,SLEEVE_HOUSING_LENGTH],center=true);
        translate([-3,0,SLEEVE_HOUSING_LENGTH/2-6])
        rotate([0,180,90])
        sleeve_mount_rail(0);
      }
    }
    
    // Cutting-edge receiver
    translate([-SLEEVE_DIAMETER/2+CUTTER_WIDTH/2-.5,0,SLEEVE_LENGTH])
      scale([1.05,1.05,1.05])
      rotate([0,-90,0])
      blade();
      
    // Arm sleeve
    translate([0,0,-.5])
      cylinder(h=SLEEVE_LENGTH+2, d=ARM_DIAMETER+ARM_TOLERANCE);
      
    // Track with 90° rotation
    translate([0,0,PEG_CHANNEL_PADDING])
    rotate([0,0,90])
    union() {
      // End of track, furthest from print head
      rotate([0,0,90])
      {
        translate([0,0,KNOCKOFF_LENGTH/2 + PEG_CHANNEL_WIDTH/4])
          cube([
            PEG_CHANNEL_WIDTH,
            PEG_TRACK_DEPTH,
            KNOCKOFF_LENGTH-PEG_CHANNEL_WIDTH/4], center=true);
        translate([0,0,PEG_CHANNEL_WIDTH/2])
        // Resting spot for pegs
        rotate([90,0,0])
          cylinder(d=PEG_CHANNEL_WIDTH,h=PEG_TRACK_DEPTH,center=true);        
      }
      // Rotation + "wiggle room" where tack is level
      // (plus how the arm is inserted into the sleeve)
      translate([0,0,KNOCKOFF_LENGTH+ROTATION_LENGTH/2]) {
        // Arm rotation
        for(i=[-90:ROTATION_STEP:90]) {
          translate([0,0,ROTATION_LENGTH/2*i/90])
          rotate([0,0,-45+45 * sin(i)])
          {
            rotate([90,0,0])
            cylinder(d=PEG_CHANNEL_WIDTH,h=PEG_TRACK_DEPTH,center=true);
          }
        }
        // receive straightaway
        translate([0,0,RECEIVE_LENGTH+PEG_CHANNEL_WIDTH+PEG_CHANNEL_PADDING])
        {
          cube([PEG_CHANNEL_WIDTH,PEG_TRACK_DEPTH,RECEIVE_LENGTH+PEG_CHANNEL_WIDTH], center=true);
        }
      }
    }
    translate([-5,-SLEEVE_DIAMETER/2+.5,8]) rotate([90,90,0])
        #linear_extrude(.5) text(PART_VERSION_STRING, font=TEXT_FONT, size=3, halign="center", valign="middle");
  }
}

module sleeve_mount_rail(tolerance=0) {
  union() {
    linear_extrude(SLEEVE_HOUSING_LENGTH-6) {
      polygon([[-1-tolerance,0],[-2-tolerance,2+tolerance],[2+tolerance,2+tolerance],[1+tolerance,0]]);
    }
    translate([0,2+tolerance,0]) rotate([90,0,0]) cylinder(h=2+tolerance,d1=4+tolerance*2,d2=2+tolerance*2);
  }
}

//horizontalSlice($t*24)
sleeve();
