/* Parameters */

material_thickness = 4;
battery_case_height = 16;
servo_height = 21.5;
servo_length = 42.5;
sled_length = 80.5;
tab_edge_distance = 5;
tab_spacing = 0.75;
tab_length = 10;
ramp_angle = 80;
shovel_width = 105;
shovel_height = 45;

ziptie_height = 5;
ziptie_width = 2.5;

screw_diameter = 3;

caster_screw_spacing = 25;
caster_position = 12;

// Caster
WallThickness = 2;
BallSize = 12.7;
Airgap = .5;
Mount = 3;
TotalHeight = 14;
BallProtrude = .33;


/* Calculated Values */

sled_height = ((material_thickness + tab_edge_distance) * 2 ) + 
	servo_height + battery_case_height;
ramp_length = cos( ramp_angle ) * sled_height;
ramp_tab_distance = cos(ramp_angle)*(tab_edge_distance+material_thickness);
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
	translate([0, 15.2]) screw_hole();
	translate([0, 43.1]) screw_hole();
	translate([50.8, 0]) screw_hole();
	translate([52.1, 48.2]) screw_hole();
}

module pinoccio_mount() {
	height = 10.5;
	base_width = 26.5;
	base_length = 44;
	bevel_width = 11.5;
	bevel_length = 9;
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
		translate([-ramp_length + tab_edge_distance + ramp_tab_distance, 
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
	linear_extrude(height=material_thickness)
	difference() {
		union() {
			square([side_length,sled_height]);
			translate([tab_edge_distance,-material_thickness])
				tab();
			translate([tab_edge_distance, sled_height])
				tab();
			translate([side_length-tab_length-tab_edge_distance - ramp_tab_distance,sled_height])
				tab();
			translate([side_length-tab_length-tab_edge_distance - ramp_tab_distance,-material_thickness])
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
				tab_edge_distance - ziptie_width, sled_height - ziptie_height - servo_height/2 + (ziptie_height/2)])
			ziptie_hole(); // Top Left
		translate([side_length - tab_length - tab_edge_distance - tab_edge_distance, 
				servo_height/2 - (ziptie_height/2)])
			ziptie_hole(); // Bottom Right
		translate([side_length - tab_length - tab_edge_distance - tab_edge_distance, 
				sled_height - ziptie_height - servo_height/2 + (ziptie_height/2)])
			ziptie_hole(); // Top Right
	}
	// Caster
	rotate([0,0,90])
	translate([sled_height/2, -caster_position, material_thickness])
		caster();

}

module top() {
	linear_extrude(height=material_thickness)
	difference() {
		union() {
			square([sled_length,sled_height]);
			translate([tab_edge_distance,-material_thickness])
				tab();
			translate([tab_edge_distance,sled_height])
				tab();
			translate([sled_length-tab_length-tab_edge_distance,sled_height])
				tab();
			translate([sled_length-tab_length-tab_edge_distance,-material_thickness])
				tab();
		}
		translate([sled_length - 66.1, sled_height/2 - 48.2/2]) arduino_holes();
	}
}


module shovel() {
	linear_extrude(height=material_thickness)
	difference() {
		square([shovel_width, shovel_height]);
		translate([ shovel_width/2 - sled_height/2, shovel_height/2 - tab_length/2]) 
			rotate([0,0,90]) tab_hole();
		translate([shovel_width/2 + sled_height/2 + material_thickness, shovel_height/2 - tab_length/2]) 
			rotate([0,0,90]) tab_hole();

	}
}

// top();


pinoccio_mount();



//shovel();

//bottom();

//translate([ramp_length,62]) side();
