/*
 * =============================================================================
 * SumoBot Kit Master OpenSCAD File
 * =============================================================================
 * All measurements are in mm, because go metric or go home.
 */

 /* Build Flags - Variables to programatically select which part to output */

  build_laser_sheet = 1;
  build_wheel = 0;
  build_top = 0;
  build_shovel = 0;
  build_bottom = 0;
  build_side = 0;

/* Features Flags */

  // For 3D printing, we can have a curved or flat shovel
  curved_shovel = 0;

  // For 3D printing, we can include a ball caster on the bottom
  built_in_caster = 0;

  // For 3D printing, we can have a built in wheel hub
  built_in_hub = 1;

  // For 3D printing, we can select a pinoccio mount for the top
  pinoccio_top = 0;

/* Parameters */

  // Kerf is the amount of space removed by a cutting tool. I use it
  // here to describe how much space to leave between tabs and space.
  // For laser cutters, I use 0.05, for 3D printers I use 0.375
  kerf = 0.05;

  // How thick is the material? This also is the tab height.
  material_thickness = 4.75;

  // How high is the battery case?
  battery_case_height = 16;

  // How large is our servo hole?
  servo_height = 21.5;
  servo_length = 42.5;

  // How long is the sumo bot?
  sled_length = 80.5;

  // How wide is the sumo bot?
  sled_width = 63.5;

  // How close to the edge of the material do we place a tab?
  tab_edge_distance = 5;

  // How long are our tabs?
  tab_length = 10;

  // What is the angle that the sumobot shovel?
  ramp_angle = 80;

  // How wide is the shovel?
  shovel_width = 100;

  // How high is the shovel?
  shovel_height = 45;

  // Only for a 3D printed, curved shovel, how tall is the side?
  shovel_side_height = 20;

  // How big are our ziptie holes?
  ziptie_height = 5;
  ziptie_width = 2.5;

  // How big are the screw holes? 2.25mm is good for #4 wood screws
  screw_diameter = 2.25;

  // How far apart are our ball caster holes?
  caster_screw_spacing = 25;

  // How far back from the front do we place the caster?
  caster_position = 12;

  // How big are our wheels?
  wheel_radius = 30;

  // Caster Settings
  Caster_WallThickness = 2;
  Caster_BallSize = 12.5;
  Caster_Airgap = .5;
  Caster_TotalHeight = 14;
  Caster_BallProtrude = .33;

  // Servo Wheel
  SERVO_HEAD_CLEAR = 0.2;
  FUTABA_3F_SPLINE = [
      [6, 4, 1.1, 2.5],
      [25, 0.3, 0.7, 0.1]
  ];
  FUTABA_3F_SPLINE_KERF = [
      [6-(kerf/2), 4, 1.1, 2.5],
      [25, 0.3, 0.7, 0.1]
  ];

/* Calculated Values */

  // Tab spacing account for kerf
  tab_spacing = kerf * 2;

  // We figure out the side based on a snug fit for the battery case
  sled_height = ((material_thickness + tab_edge_distance) * 2 ) +
  	servo_height + battery_case_height;

  // Length of the ramp (bottom of the right triangle) depends on the angle
  ramp_length = cos( ramp_angle ) * sled_height;

  // We want to place the tab the correct tab distance on the bottom, so we need
  // to cut into the distance taken up by the ramp.
  ramp_tab_distance = cos(ramp_angle)*( tab_edge_distance + material_thickness);

  // The length of the sled plus the length of the ramp
  side_length = sled_length + ( cos( ramp_angle ) * (sled_height - tab_edge_distance) );

/* Utility Modules */

// A hole for a screw.
module screw_hole() {
	circle(d=screw_diameter);
}

// Male side of the tab
module tab() {
	square([tab_length, material_thickness]);
}

// Female side of the tab
module tab_hole() {
	translate([tab_spacing/-2,tab_spacing/-2])
		square([tab_length + tab_spacing, material_thickness +tab_spacing]);
}

// A ziptie hole
module ziptie_hole() {
	square([ziptie_width,ziptie_height]);
}

// Built-in ball caster
module caster() {
	cylheight = Caster_TotalHeight;
	cylrad = (Caster_BallSize/2) + Caster_WallThickness + Caster_Airgap;
	difference () {
		cylinder(r1 = cylrad , r2 = cylrad,  cylheight - (Caster_BallSize*Caster_BallProtrude));
		translate([0,0,Caster_TotalHeight - Caster_BallSize/2]) {
			cube(size = [cylrad*2+5, cylrad/2, Caster_BallSize*1.25], center = true );
		}
		translate([0,0,Caster_TotalHeight - (Caster_BallSize/2)]) {
			sphere (Caster_BallSize/2+Caster_Airgap, $fa=5, $fs=0.1);
		}
	}
}

// Servo mounting hole including a circular cutout for the wires
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

// Mounting holes for an arduino
module arduino_holes() {
	translate([-26.05,-24.1]) {
		translate([0, 15.2]) screw_hole();
		translate([0, 43.1]) screw_hole();
		translate([50.8, 0]) screw_hole();
		translate([52.1, 48.2]) screw_hole();
	}
}

// A special pinoccio shaped mount for the top of the bot
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

// The little curved part on the side of the curved shovel
module sloped_support(size) {
	difference() {
		cube([size,material_thickness,size]);
		translate([size,material_thickness+1,size])
			rotate([90])
			cylinder(r=size-material_thickness,h=material_thickness+2);
	}
}

// Side for a curved shovel (___)
module shovel_side() {
	cube([material_thickness,shovel_height,shovel_side_height]);
	sloped_support(shovel_side_height);
	translate([0,shovel_height-material_thickness])
		sloped_support(shovel_side_height);
}

module servo_head_tooth(length, width, height, head_height) {
    linear_extrude(height = head_height) {
        polygon([[-length / 2, 0], [-width / 2, height], [width / 2, height], [length / 2,0]]);
    }
}

// The little part that you can attach servo hubs to on a servo, used for the
// built in hub option of the wheel.
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

// The little screw slot in the side of the sumo bot -
module wheel_screw_slot() {
	hull() {
		translate([0,0,-1])
			cylinder(d=screw_diameter,h=material_thickness+2);
		translate([0,8,-1])
			cylinder(d=screw_diameter,h=material_thickness+2);
	}
}

/* Parts */

// The side of the sumobot /___|
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

// The bottom of the sumobot [: ]
module bottom(built_in_caster=built_in_caster) {
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
		if (!built_in_caster) {
			translate([caster_position, sled_width/2 + caster_screw_spacing/2]) screw_hole();
			translate([caster_position, sled_width/2 - caster_screw_spacing/2]) screw_hole();
		}

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
	if (built_in_caster) {
		rotate([0,0,90])
		translate([sled_width/2, -caster_position, material_thickness])
			caster();
	}

}

// The top of the sumobot. [: ;]
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
    if ( pinoccio_top ) {
      translate([sled_length/2,sled_width/2,material_thickness])
        pinoccio_mount();
    }
	}
}

// The front of the sumobot [ ' '' ]
module shovel(curved_shovel=curved_shovel) {
	union() {
	linear_extrude(height=material_thickness)
	difference() {
		square([shovel_width, shovel_height]);
		translate([ shovel_width/2 - sled_width/2, shovel_height/2 - tab_length/2])
			rotate([0,0,90]) tab_hole();
		translate([shovel_width/2 + sled_width/2 + material_thickness, shovel_height/2 - tab_length/2])
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

// Sumobot wheel ( )
module wheel(built_in_hub=built_in_hub) {
	layer_height = material_thickness/3;
	difference() {
		union() {
			cylinder(r=wheel_radius,h=layer_height);
				cylinder(r=wheel_radius-0.5,h=material_thickness);
			translate([0,0,layer_height*2])
				cylinder(r=wheel_radius,h=layer_height);
			if (built_in_hub)
				cylinder(r=5,h=4.5);
		}
		translate([0,0,-1])
			cylinder(d=screw_diameter,h=material_thickness+2);
		if (built_in_hub) {
			translate([0,0,1])
				servo_head(FUTABA_3F_SPLINE);
		} else {
			servo_head(FUTABA_3F_SPLINE_KERF);
			// screw hole
			translate([0,7])
				wheel_screw_slot();
			translate([0,-15])
				wheel_screw_slot();
		}
	}
}

// When we want to make a file for laser cutting, we can use this to keep
// all components on one sheet.
module laser_sheet(spacing=2) {

	// We want high resolution circles.
	$fn = 50;

	// Right Side
	translate([sled_length+spacing, sled_height+spacing]) mirror([1,0,0])
		side();
	translate([ramp_length+spacing,-shovel_height - spacing])
		side();
	translate([spacing-ramp_length,sled_height-shovel_height])
		shovel(curved_shovel=0);
	translate([wheel_radius+spacing,-shovel_height-wheel_radius-spacing*2])
		wheel(built_in_hub=0);


	// Left Side
	translate([0,-wheel_radius/2]) {
		translate([-wheel_radius,sled_width+wheel_radius+material_thickness])
			wheel(built_in_hub=0);
		translate([-sled_length - ramp_length, 0])
			top();
		translate([-sled_length - ramp_length, -sled_width - material_thickness * 2 - spacing ])
			bottom(built_in_caster=0);
	}

}

/* Part Output */

if ( build_laser_sheet ) {
  projection(cut=true)
  	laser_sheet(2);
}

if ( build_wheel ) {
  wheel();
}

if ( build_top ) {
  top();
}

if ( build_shovel ) {
  shovel();
}

if ( build_bottom ) {
  bottom();
}

if ( build_side ) {
  side();
}
