
plate_x = 168;
plate_y = 130;
plate_z = 4;

decora_x = 33;
decora_y = 67;

decora_screws = 48.41875;
box_screws = 41.67125;
gang_offset = 46.0375;

dock_width = 140;
dock_height = 120;

$fn = 20;

union() {
	plate();
	dock();
}


module plate() {
	difference() {
		union() {
			translate([plate_z, plate_z, 0]) 
			cube(size = [plate_x - (2 * plate_z), plate_y - (2 * plate_z), plate_z]);
		
			// left side
			translate([plate_z, plate_z, 0])
			rotate([-90, 180, 0])
			quarter_cylinder(plate_y - (2 * plate_z), plate_z);

			// right side
			translate([plate_x - plate_z, plate_z, 0])
			rotate([-90, -90, 0])
			quarter_cylinder(plate_y - (2 * plate_z), plate_z);
	
			// top side
			translate([plate_x - plate_z, plate_y - plate_z, 0])
			rotate([0, -90, 0])
			quarter_cylinder(plate_x - (2 * plate_z), plate_z);

			// bottom side
			translate([plate_z, plate_z, 0])
			rotate([0, -90, 180])
			quarter_cylinder(plate_x - (2 * plate_z), plate_z);

			// top right
			translate([plate_x - plate_z, plate_y - plate_z, 0])
			semihemisphere(plate_z);

			// bottom right
			translate([plate_x - plate_z, plate_z, 0])
			rotate([0, 0, -90])
			semihemisphere(plate_z);

			// top left
			translate([plate_z, plate_y - plate_z, 0])
			rotate([0, 0, 90])
			semihemisphere(plate_z);

			// bottom left
			translate([plate_z, plate_z, 0])
			rotate([0, 0, 180])
			semihemisphere(plate_z);
		}

		translate([(plate_x - decora_x) / 2, (plate_y - decora_y) / 2, 0])
		cube(size = [decora_x, decora_y, plate_z]);

		// top decora screw
		translate([plate_x / 2, (plate_y / 2) + decora_screws, 0])
		inset_screw(plate_z);

		// bottom decora screw
		translate([plate_x / 2, (plate_y / 2) - decora_screws, 0])
		screw(plate_z);

		// top right screw
		translate([plate_x / 2 + gang_offset, (plate_y / 2) + box_screws, 0])
		screw(plate_z);

		// bottom right screw
		translate([plate_x / 2 + gang_offset, (plate_y / 2) - box_screws, 0])
		screw(plate_z);

		// top left screw
		translate([plate_x / 2 - gang_offset, (plate_y / 2) + box_screws, 0])
		screw(plate_z);

		// bottom left screw
		translate([plate_x / 2 - gang_offset, (plate_y / 2) - box_screws, 0])
		screw(plate_z);

		// remove a small part of the dock
		dock_solid();
	}
}

module dock() {
	difference() {
		dock_solid();
		
		translate([(plate_x - (dock_width - 10)) / 2, 10, plate_z - 1]) 
		cube([dock_width - 10, (dock_height / 2) - 10, 35]);
	}
}

module dock_solid() {
	translate([(plate_x - dock_width) / 2, (plate_y - dock_height) / 2, plate_z - 1])
	difference() {
		rotate([90, 0, 90])
		linear_extrude(height=dock_width)
		polygon(points=[[0,0], [0,40], [dock_height,5], [dock_height,0]]);	

		translate([dock_width / 4, dock_height / 2, 0])
		cube(dock_width / 2, dock_height / 2, 40);
	}
}

module inset_screw(h) {
	union() {
		cylinder(r=2, h=h-3);
	
		translate([0, 0, h-3])
		cylinder(r1=2, r2=3.3, h=h);
	}
}

module screw(h) {
	cylinder(r=2, h=h);
}

module quarter_cylinder(h, r) {
	difference() {
		cylinder(h=h, r=r);

		translate([-r, 0, 0])
		cube(size=[r, r, h]);

		translate([-r, -r, 0])
		cube(size=[2 * r, r, h]);
	}
}

module semihemisphere(r) {
	difference() {
		sphere(r=r);

		translate([-r, 0, -r])
		cube(size=[r, r, 2 * r]);

		translate([-r, -r, -r])
		cube(size=[2 * r, r, 2 * r]);

		translate([0, 0, -r])
		cube(r, r, r);
	}
}
