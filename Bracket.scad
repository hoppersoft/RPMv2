include <Constants.scad>
use <Sleeve.scad>

PART_VERSION_STRING="BigBrain RPM v2.0";

BRACKET_WIDTH = 25;
BRACKET_HEIGHT = 99;
BRACKET_THICKNESS = 5;
BRACKET_ROUNDING_DIAMETER=8;
SPRING_MOUNT_BASE_DIAMETER=6;
SPRING_MOUNT_BASE_HEIGHT=1;
SPRING_MOUNT_DIAMETER=4;
SPRING_MOUNT_HEIGHT=8.5;
SPRING_MOUNT_LIP_DIAMETER=5;
SPRING_MOUNT_LIP_HEIGHT=1;

module spring_mount() {
        translate([0, 0, BRACKET_THICKNESS/2+SPRING_MOUNT_BASE_HEIGHT/2])
        {
            cylinder(h=SPRING_MOUNT_BASE_HEIGHT, d1=SPRING_MOUNT_BASE_DIAMETER, d2=SPRING_MOUNT_DIAMETER, center=true);
            translate([0, 0, SPRING_MOUNT_HEIGHT/2])
            {
                cylinder(h=SPRING_MOUNT_HEIGHT, d=SPRING_MOUNT_DIAMETER, center=true);
                translate([0, 0, SPRING_MOUNT_HEIGHT/2 + SPRING_MOUNT_LIP_HEIGHT/2])
                cylinder(h=SPRING_MOUNT_LIP_HEIGHT, d1=SPRING_MOUNT_DIAMETER, d2=SPRING_MOUNT_LIP_DIAMETER, center=true);
            }
        }
}

module m3_screw()
{
    cylinder(d=3.3, h=BRACKET_THICKNESS, center=true);
    translate([0,0,-BRACKET_THICKNESS/2+.5])
    cylinder(d1=6.2, d2=3.3, h=1.5, center=true);
}

module bracket() {
    translate([0,-20.5,0]) {
        difference() {
            hull() {
                translate([0,-BRACKET_ROUNDING_DIAMETER/2,0])
                    cube([BRACKET_WIDTH,BRACKET_HEIGHT-BRACKET_ROUNDING_DIAMETER,BRACKET_THICKNESS], center=true);
                // Rounded top
                translate([0,BRACKET_HEIGHT/2-BRACKET_ROUNDING_DIAMETER/2,0]) {
                    translate([8.5,0,0]) cylinder(h=BRACKET_THICKNESS, d=BRACKET_ROUNDING_DIAMETER,center=true);
                    translate([-8.5,0,0]) cylinder(h=BRACKET_THICKNESS, d=BRACKET_ROUNDING_DIAMETER,center=true);
                }
            }
            translate([9.5,-44,2.6]) 
            //translate([-9.5,64.5,5.1]) 
                rotate([90,-180,-90])
                    sleeve_mount_rail(.1);
            translate([0, 45.55,0]) {
                translate([-BRACKET_WIDTH/2+6.25, 0, 0]) m3_screw();
                translate([BRACKET_WIDTH/2-6.25, 0,0]) m3_screw();
            }
            translate([0,0,-2])
            rotate([0,-180,90])
            #linear_extrude(.6) text(font=TEXT_FONT, PART_VERSION_STRING, size=6, halign="center", valign="center");
        }  
    }
    
    translate([-9.5, -47, 0])
        spring_mount();
    translate([0, -47, 0])
        spring_mount();
    // bump-out for lever
    difference() {
        hull() {
            translate([-15.5,-18.25,0]) cube([8,17,BRACKET_THICKNESS], center=true);
            translate([-19.1,-22,0])
            {
                cylinder(d=10, h=BRACKET_THICKNESS, center=true);
                translate([0,7.3,0])
                    cylinder(d=10, h=BRACKET_THICKNESS, center=true);
            }
        }
        translate([-19.5,-18.25,0])
        cylinder(h=BRACKET_THICKNESS+1, d=5, center=true);
    }
    translate([-10,-8.3,BRACKET_THICKNESS/2]) difference() {
        cube([5,8.3,7]);
        translate([0,1.5,0]) cube([5,5,5]);
    }
    translate([7.5,-8.3,BRACKET_THICKNESS/2]) difference() {
        cube([5,8.3,7]);
        translate([0,1.5,0]) cube([5,5,5]);
    }
}

bracket();
