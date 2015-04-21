//Library
use <text_on.scad>

//general settings
$fn = 64;

//buffer for printing
buffer = 1;

//sensor
sensorWidth = 6;
sensorHight = 6;
sensorDepth = 3;
sensorSink = 15;
pathHeight = 3;

//cylinder
cylinderHeight = 60;
cylinderInnerRadius1 = 13;
cylinderInnerRadius2 = 16;
cylinderOuterRadius = 19;

//ring
fixumWidth = 5;
fixumThickness = 1;

//text
text="Tropfenfalle";
textDepth = 1;
textHeight = 7;

//calculated
distance = (cylinderOuterRadius + cylinderInnerRadius1) / 2;

//sensor 
module sensor() {
    //sensor 1
	translate([-sensorWidth/2, distance-sensorDepth/2, -buffer]) {
		cube([sensorWidth, sensorDepth, sensorSink+buffer]);
	}
    //path 1
    translate([-sensorWidth/2, distance, -buffer]) {
		cube([sensorWidth, cylinderOuterRadius-distance+buffer, pathHeight+buffer]);
	}
    //sensor 2
	translate([-sensorWidth/2, -distance-sensorDepth/2, -buffer]) {
		cube([sensorWidth, sensorDepth, sensorSink+buffer]);
	}
    //path 2
	translate([-sensorWidth/2, -cylinderOuterRadius-buffer, -buffer]) {
		cube([sensorWidth, cylinderOuterRadius-distance+buffer, pathHeight+buffer]);
	}
    //light tunnel
	translate([0, 0, sensorSink-sensorWidth/2+1]) {
		rotate([0, 90, 90]) {
			translate([0, 0, -distance]) {
				cylinder(r=sensorWidth/2-buffer, h=2*distance);
			}
		}
	}
}

//Ring
module ring() {
	difference() {
		cylinder(r=cylinderOuterRadius, h=cylinderHeight);
		translate([0, 0, cylinderHeight / 2-buffer]) {
			cylinder(r1=cylinderInnerRadius1, r2=cylinderInnerRadius2, h=cylinderHeight/2+2*buffer);
		}
		translate([0, 0, -1]) {
			cylinder(r=cylinderInnerRadius1, h=cylinderHeight/2+2*buffer);
		}
        text_on_cylinder(t=text, r=cylinderOuterRadius-textDepth, h=cylinderHeight, direction="ltr", font="Liberation Mono", size=textHeight, extrusion_height=textDepth+buffer);
	}
}

//fix rings
module fixRings() {
    //lower ring
	difference() {
        translate([0, 0, sensorSink+buffer]) {
			cylinder(r=cylinderOuterRadius+buffer, h=fixumThickness);
        }
        translate([0, 0, sensorSink]) {
 			cylinder(r=cylinderOuterRadius-buffer, h=fixumThickness+2*buffer);
		}
	}
    //upper ring
	difference() {
        translate([0, 0, sensorSink+fixumWidth+buffer]) {
			cylinder(r=cylinderOuterRadius+buffer, h=fixumThickness);
        }
    	translate([0, 0, sensorSink+fixumWidth]) {
            cylinder(r=cylinderOuterRadius-buffer, h=fixumThickness+2*buffer);
		}
	}
}

//cable through rings
module fixum() {
    //fixum 1
	translate([-sensorWidth/2, cylinderOuterRadius, sensorSink-2*buffer]) {
		cube([sensorWidth, 2*buffer, fixumWidth+4*buffer]);
	}
    //fixum2
	translate([-sensorWidth/2, -cylinderOuterRadius-2, sensorSink-2*buffer]) {
		cube([sensorWidth, 2*buffer, fixumWidth+4*buffer]);
	}
}

//major form
color("red")
difference() {
	ring();
	sensor();
}

//additional ring
color("blue")
difference() {
	fixRings();
	fixum();
}