include <Constants.scad>

PART_VERSION_STRING="v2.0";

module purge_action() {
    difference() {
        cube([48.5,4.5,3.6]);
        translate([40.5,0,0])
            cube([6,2.7,3.6]);
        translate([40.025,0,0])
            #cube([.475, .475, 3.6]);
        translate([1,1,3.1])
        #linear_extrude(.5) text(PART_VERSION_STRING, size=2);
    }
    translate([40.025,.475,0])
        cylinder(d=.95, h=3.6, $fn=100);
}

purge_action();