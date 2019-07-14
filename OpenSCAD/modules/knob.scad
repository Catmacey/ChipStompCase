// Makes a knurled knob for the keyed (D shaped) shaft of a potentiometer

module knob(
		shaft_rad = 3 
	, shaft_depth = 10
	, outer_rad = 5
	, key_depth = 7  // Has a keyed shaft
	, knurled = 0 // Knurling on the outside
	, centerpoint = true // include a centerpoint indicator
){
	top_thick = 1;
	top_extra = 0.5; // To ensure we have some thickness to the top
	clearance = 0.1;
	cube_width = (shaft_rad*2)+1; // slighly bigger than shaft rad to ensure good geom
	overall_height = top_thick + shaft_depth + top_extra;
	difference(){
		hull(){
			translate([0,0,shaft_depth+1])
				cylinder(h=top_thick, r=outer_rad-1, center=false)
			;
			cylinder(h=shaft_depth+top_extra, r=outer_rad, center=false);
		}
		// hole for shaft
		translate([0,0,-1]){
			if(key_depth > 0){
				intersection(){
					cylinder(h=shaft_depth+1, r=shaft_rad+clearance, center=false);
					union(){
						// 3/4 moon
						translate([0,(shaft_rad/2),0])
							centered_cube([cube_width,shaft_rad*2,shaft_depth+1])
						;
						// lobes
						centered_cube([shaft_rad,cube_width,shaft_depth+1]);
						// only top 7mm bottom part is full circle
						centered_cube([
								cube_width
							,	cube_width
							, shaft_depth-key_depth+1
						]);
					}
				}
			}else{
				cylinder(h=shaft_depth+1, r=shaft_rad+clearance, center=false);
			}
		};
		if(centerpoint){
		// Centerpoint marker
			translate([0,outer_rad/2,shaft_depth+1])
				centered_cube([1.5,outer_rad,2])
			;
			translate([0,outer_rad,3])
				centered_cube([1.5,2,shaft_depth])
			;
		}
		if(knurled){
			// scallop out the outside
			k_offset = outer_rad + 2;
			k_rad = 3;
			for(r = [1 : knurled]){
				rotate([0,0,(360/knurled)*r])
				translate([0,k_offset,-1])
				cylinder(h=overall_height+2, r=k_rad, center=false);
			}
		}
	}

	// Helper module: centered cube on (X,Y) but not on Z, like cylinder
	module centered_cube(size){
	  translate([-size[0]/2, -size[1]/2, 0])
	    cube(size);
	}

}