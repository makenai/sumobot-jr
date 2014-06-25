/* Options */

curved_shovel = 1;


/* Parameters */

material_thickness = 4;
battery_case_height = 16;
servo_height = 21.5;
servo_length = 42.5;
sled_length = 80.5;
sled_width = 63.5;
tab_edge_distance = 5;
tab_spacing = 0.75;
tab_length = 10;
ramp_angle = 80;
shovel_width = 90;
shovel_height = 45;
shovel_side_height = 20;

ziptie_height = 5;
ziptie_width = 2.5;

screw_diameter = 3;

caster_screw_spacing = 25;
caster_position = 12;

wheel_radius = 30;

// Caster
WallThickness = 2;
BallSize = 12.5;
Airgap = .5;
Mount = 3;
TotalHeight = 14;
BallProtrude = .33;

// Servo Wheel
SERVO_HEAD_CLEAR = 0.2;
FUTABA_3F_SPLINE = [
    [6, 4, 1.1, 2.5],
    [25, 0.3, 0.7, 0.1]
];


/* Calculated Values */

sled_height = ((material_thickness + tab_edge_distance) * 2 ) + 
	servo_height + battery_case_height;
ramp_length = cos( ramp_angle ) * sled_height;
ramp_tab_distance = cos(ramp_angle)*( tab_edge_distance + material_thickness);
side_length = sled_length + ( cos( ramp_angle ) * (sled_height - tab_edge_distance) );

/* Functions */

module screw_hole() {
	circle(d=screw_diameter);
}

module tab() {
	square([tab_length, material_thickness]);
}

module tab_hole() {
	translate([tab_spacing/-2,tab_spacing/-2])
		square([tab_length + tab_spacing, material_thickness +tab_spacing]);
}

module ziptie_hole() {
	square([ziptie_width,ziptie_height]);
}

module caster() {
	cylheight = TotalHeight;
	cylrad = (BallSize/2) + WallThickness + Airgap;
	difference () {
		cylinder(r1 = cylrad , r2 = cylrad,  cylheight - (BallSize*BallProtrude));
		translate([0,0,TotalHeight - BallSize/2]) {
			cube(size = [cylrad*2+5, cylrad/2, BallSize*1.25], center = true );
		}
		translate([0,0,TotalHeight - (BallSize/2)]) {
			sphere (BallSize/2+Airgap, $fa=5, $fs=0.1);
		}
	}
}

module servo_hole() {
	square([servo_length, servo_height]);
	// screw holes
	translate([-4.5,(servo_height/2)+5])
		screw_hole();
	translate([-4.5,(servo_height/2)-5])
		screw_hole();
	translate([servo_length+4.5,(servo_height/2)+5])
		screw_hole();
	translate([servo_length+4.5,(servo_height/2)-5])
		screw_hole();
	// wire hole
	hull() {
		translate([servo_length-1,servo_height/2])
			square(6,center=true);
		translate([servo_length+2.5,servo_height/2])
			circle(3,center=true);
	}

}

module arduino_holes() {
	translate([-26.05,-24.1]) { 
		translate([0, 15.2]) screw_hole();
		translate([0, 43.1]) screw_hole();
		translate([50.8, 0]) screw_hole();
		translate([52.1, 48.2]) screw_hole();
	}
}

module pinoccio_mount() {
	height = 11;
	base_width = 26.5;
	base_length = 45.5;
	bevel_width = 11;
	bevel_length =8.5;
	wall_thickness = 2;
	plug_hole_size = 3.5;

	translate([base_length/-2-bevel_length/-2,-base_width/2])
	difference() {
		linear_extrude(height)
		hull() {
			translate([0,-wall_thickness])
				square([base_length + wall_thickness,base_width + wall_thickness*2]);
 			translate([-bevel_length - wall_thickness,base_width/2-bevel_width/2])	
				square(bevel_width);
		}
		translate([0,0,-1])
		linear_extrude(height+2)
		hull() {
			square([base_length,base_width]);
			translate([-bevel_length,base_width/2-bevel_width/2])
				square(bevel_width); 
		}
		translate([base_length-1, base_width/2,height])
			rotate([0,90])
			cylinder(r=plug_hole_size,h=wall_thickness+2);
	}
}


module side() {
	linear_extrude(height=material_thickness)
	difference() {

		union() {
			square([sled_length, sled_height]);
			polygon([[0,0], [0,sled_height], [-ramp_length,0]] );
			translate([-ramp_length/2,sled_height/2])
				rotate(ramp_angle)
				translate([-tab_length/2,-0.1])
				tab();
		}
	
		// Servo hole
		translate([sled_length - servo_length - tab_length - tab_edge_distance - tab_edge_distance, 
				material_thickness + tab_edge_distance])
			servo_hole();

		// Bottom right
		translate([sled_length - tab_length - tab_edge_distance, tab_edge_distance])
			tab_hole();

		// Bottom Left
		translate([-ramp_length + ramp_tab_distance + tab_edge_distance, 
				tab_edge_distance])
			tab_hole();

		// Top left
		translate([tab_edge_distance, sled_height - material_thickness - tab_edge_distance])
			tab_hole();

		// Top right
		translate([sled_length - tab_length - tab_edge_distance, 
				sled_height - material_thickness - tab_edge_distance])
			tab_hole();
	}
}


module bottom() {
	bottom_offset = (ramp_length + sled_length) - side_length;
	translate([bottom_offset, 0])
	linear_extrude(height=material_thickness)
	difference() {
		union() {
			square([side_length,sled_width]);
			translate([-bottom_offset + ramp_tab_distance + tab_edge_distance,-material_thickness])
				tab();
			translate([-bottom_offset + ramp_tab_distance + tab_edge_distance, sled_width])
				tab();
			translate([side_length-tab_length-tab_edge_distance,sled_width])
				tab();
			translate([side_length-tab_length-tab_edge_distance,-material_thickness])
				tab();
		}

		// Screw Holes
		// translate([caster_position, sled_height/2 + caster_screw_spacing/2]) screw_hole();
		// translate([caster_position, sled_height/2 - caster_screw_spacing/2]) screw_hole();

		// Ziptie Holes
		translate([side_length - servo_length - tab_length - tab_edge_distance - 
				tab_edge_distance - ziptie_width, servo_height/2 - (ziptie_height/2)])
			ziptie_hole(); // Bottom Left
		translate([side_length - servo_length - tab_length - tab_edge_distance - 
				tab_edge_distance - ziptie_width, sled_width - ziptie_height - servo_height/2 + (ziptie_height/2)])
			ziptie_hole(); // Top Left
		translate([side_length - tab_length - tab_edge_distance - tab_edge_distance, 
				servo_height/2 - (ziptie_height/2)])
			ziptie_hole(); // Bottom Right
		translate([side_length - tab_length - tab_edge_distance - tab_edge_distance, 
				sled_width - ziptie_height - servo_height/2 + (ziptie_height/2)])
			ziptie_hole(); // Top Right
	}
	// Caster
	rotate([0,0,90])
	translate([sled_width/2, -caster_position, material_thickness])
		caster();

}

module top() {
	union() {
	linear_extrude(height=material_thickness)
	difference() {
		union() {
			square([sled_length,sled_width]);
			translate([tab_edge_distance,-material_thickness])
				tab();
			translate([tab_edge_distance,sled_width])
				tab();
			translate([sled_length-tab_length-tab_edge_distance,sled_width])
				tab();
			translate([sled_length-tab_length-tab_edge_distance,-material_thickness])
				tab();
		}
		translate([sled_length/2,sled_width/2]) arduino_holes();
	}
	// translate([sled_length/2,sled_width/2,material_thickness])
	//	pinoccio_mount();
	}
}

module sloped_support(size) {
	difference() {
		cube([size,material_thickness,size]);
		translate([size,material_thickness+1,size])
			rotate([90])
			cylinder(r=size-material_thickness,h=material_thickness+2);
	}
}

module shovel_side() {
	cube([material_thickness,shovel_height,shovel_side_height]);
	sloped_support(shovel_side_height);
	translate([0,shovel_height-material_thickness])
		sloped_support(shovel_side_height);
}

module shovel() {
	union() {
	linear_extrude(height=material_thickness)
	difference() {
		square([shovel_width, shovel_height]);
		translate([ shovel_width/2 - sled_height/2, shovel_height/2 - tab_length/2]) 
			rotate([0,0,90]) tab_hole();
		translate([shovel_width/2 + sled_height/2 + material_thickness, shovel_height/2 - tab_length/2]) 
			rotate([0,0,90]) tab_hole();
	}
	if (curved_shovel) {
		shovel_side();
		translate([shovel_width,shovel_height])
		rotate([0,0,180])
			shovel_side();
		}
	}
}


module servo_head_tooth(length, width, height, head_height) {
    linear_extrude(height = head_height) {
        polygon([[-length / 2, 0], [-width / 2, height], [width / 2, height], [length / 2,0]]);
    }
}

/**
 *  Servo head
 */
module servo_head(params, clear = SERVO_HEAD_CLEAR) {

    head = params[0];
    tooth = params[1];

    head_diameter = head[0];
    head_heigth = head[1];

    tooth_count = tooth[0];
    tooth_height = tooth[1];
    tooth_length = tooth[2];
    tooth_width = tooth[3];

	union() {
    cylinder(r = head_diameter / 2 + 0.1, h = head_heigth + 1);

    cylinder(r = head_diameter / 2 - tooth_height + 0.03 + clear, h = head_heigth);

    for (i = [0 : tooth_count]) {
        rotate([0, 0, i * (360 / tooth_count)]) {
            translate([0, head_diameter / 2 - tooth_height + clear, 0]) {
                servo_head_tooth(tooth_length, tooth_width, tooth_height, head_heigth);
            }
        }
    }
	}
}

module wheel() {
	layer_height = material_thickness/3;
	difference() {
		union() {
			cylinder(r=wheel_radius,h=layer_height);
				cylinder(r=wheel_radius-0.5,h=material_thickness);
			translate([0,0,layer_height*2])
				cylinder(r=wheel_radius,h=layer_height);
			cylinder(r=5,h=4.5);
		}
		translate([0,0,-1])
			cylinder(d=screw_diameter,h=material_thickness+2);
		translate([0,0,1])
			servo_head(FUTABA_3F_SPLINE);

	}
}


//wheel();

//top();

// shovel();

//bottom();

side();