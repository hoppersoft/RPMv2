include <Constants.scad>
THICKNESS=3.85;
AXLE_CENTER=17.25;
SPRING_MOUNT_DIAMETER=2;
DISTANCE_TO_BACK=2.45;
PART_VERSION_STRING="v2.0";

difference() {
    union()
    {
        axle();
        springMounts();
        driverArm();
        lever();
    }
    translate([0,AXLE_CENTER,-1]) cylinder(h=13, d=2.9);
    #translate([-1,0,.5])
        rotate([180,0,90])
            linear_extrude(.5) text(PART_VERSION_STRING, font=TEXT_FONT, size=3, halign="center", valign="middle");
}

module axle() {
    translate([0,AXLE_CENTER,0]) {
        union() {
            cylinder(h=11.4, d=4.8);
            cylinder(h=THICKNESS+DISTANCE_TO_BACK, d=6.5);
            cylinder(h=3.9, d=9.85);
        }
    }
}

module springMounts() {
    difference() {
        translate([0,11.5,0])
        linear_extrude(THICKNESS) {
            polygon([[0,0],[-28.85,9.2],[-28.85,12.3], [0,11.9]]);
        }
        translate([-26.65,22,-1]) {
            cylinder(h=6, d=SPRING_MOUNT_DIAMETER);
            translate([4.85,-1.25,0]) cylinder(h=6, d=SPRING_MOUNT_DIAMETER);
            translate([10.5,-3.25,0]) cylinder(h=6, d=SPRING_MOUNT_DIAMETER);
            translate([15.25,-4.7,0]) cylinder(h=6, d=SPRING_MOUNT_DIAMETER);
        }
    }        
}

module driverArm() {
    SLOT_THICKNESS=ARM_THICKNESS/2-ARM_TOLERANCE*.5;
    // descending arm
    linear_extrude(THICKNESS)
        polygon([[-5,AXLE_CENTER],[-1.15,-25.75],[1.15,-25.55],[5,AXLE_CENTER]]);
    // connect the slot insert to the arm
    translate([-0,-29.5,0]) linear_extrude(SLOT_THICKNESS)
        polygon([[-2.1,0],[-1.1,4],[1.17,4],[1,0]]);
    
    // the slot insert; we have rounded edges on the
    // upper-right and lower-left to reduce catching
    translate([-.75,-31.5,0])
        cube([1.75,2.45,SLOT_THICKNESS]);
    translate([-.95,-30.8,0])
        cylinder(h=SLOT_THICKNESS, d=3.5);
    translate([-2.7,-36.6,0])
        cube([3.7,5.5,SLOT_THICKNESS]);
    translate([.5,-36.75,0])
        cylinder(h=SLOT_THICKNESS, d=1);
    translate([-2.7,-37.25,0])
        cube([3.2,1.5,SLOT_THICKNESS]);
}

module lever() {
    translate([0,AXLE_CENTER,0])
    {
        linear_extrude(THICKNESS)
            polygon([[-5,0],[-1,12],[1,12],[5,0]]);
        translate([-1,12,0])
        cube([2,9,THICKNESS+.5]);
    }
}