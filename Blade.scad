include <Constants.scad>

PART_VERSION_STRING="v2.0";

module cutter(width,height,depth) {
  CutterPoints=[
    [0,0,0], // 1
    [width,0,0], // 2
    [width,depth,0], // 3
    [0,depth,0], // 4
    [0,0,height-height*sin(15)], // 5
    [width,0,height], // 6
    [width,depth,height-depth*cos(30)], // 7
    [0,depth,height-depth*cos(30)-height*sin(15)] // 8
  ];
  CutterFaces=[
    [0,1,2,3],
    [4,5,6,7],
    [0,1,5,4],
    [1,2,6,5],
    [2,3,7,6],
    [0,3,7,4]
  ];
  union() {
    translate([-width/2,-depth/2,0])
      polyhedron(CutterPoints, CutterFaces);

    blade_insert_tolerance = 0;
    translate([-blade_insert_tolerance,-depth*.75/2,-CUTTER_INSERT_LENGTH])
      cube([width/2+blade_insert_tolerance,depth*.75,CUTTER_INSERT_LENGTH]);
   
  }
}

module blade() {
//  translate([CUTTER_WIDTH*2,0,CUTTER_WIDTH/2])
    difference() {
        rotate([0,90,0])
        cutter(CUTTER_WIDTH,TACK_HOUSING_HEIGHT,SLEEVE_DIAMETER);
        translate([1,0,-.5])
        rotate([180,0,90])
        linear_extrude(.5) text(PART_VERSION_STRING, font=TEXT_FONT, size=3, halign="center", valign="middle");
    }
}
blade();