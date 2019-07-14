// Needs to be included

//Bottom feet of the box with central space for a standard 3 AA cell battery holder
module bottom(){
	// Battery box dims
	batt_w = 58;
	batt_h = 47;
	// depth of bracing
	supp_thick = 6;
	color("blue")
	union(){
		// Lip for battery box
		translate([0,0,-2])
		linear_extrude(2, convexity = 10){
			difference(){
				square([batt_w,batt_h],true);
				square([batt_w-(wall_thick*2),batt_h-(wall_thick*2)],true);
			}
		};

		translate([0,0,-supp_thick])
		linear_extrude(supp_thick, convexity = 10){
			// horiz supports
			translate([0,(batt_h/2)+(wall_thick/2),0]) square([box_inner_w, wall_thick], true);
			translate([0,-((batt_h/2)+(wall_thick/2)),0]) square([box_inner_w, wall_thick], true);
			// Vertical supports
			translate([(batt_w/2)+(wall_thick/2),0,0]) square([wall_thick, box_inner_h], true);
			translate([-((batt_w/2)+(wall_thick/2)),0,0]) square([wall_thick, box_inner_h], true);
		};

		translate([0,0,-foot_height]){
			cornerpads(
				width=corner_pad_r,
				height=foot_height,
				drill=drill_r
			);
			// Inner lip
			linear_extrude(foot_height, convexity = 10){
				difference(){
					rounded_rectangle(box_outer_w,box_outer_h,box_outer_r);
					rounded_rectangle(pcb_w-wall_thick, pcb_h-wall_thick, box_inner_r);
				}
			}
			// wall
			translate([0,0,-20])
			render()
			difference(){
				linear_extrude(20, convexity = 10){
					difference(){
						rounded_rectangle(box_outer_w,box_outer_h,box_outer_r);
						rounded_rectangle(box_inner_w, box_inner_h, box_inner_r);
					}
				}
				chop_rad = 15;
				chop_space = 12;
				chop_extra = 8;
				rotate([0,90,0])
				hull(){
					translate([0,-((box_outer_h/2)-chop_rad-chop_space),0])
					cylinder(h=box_outer_w+chop_extra, r=chop_rad, center=true);
					translate([0,((box_outer_h/2)-chop_rad-chop_space),0])
					cylinder(h=box_outer_w+chop_extra, r=chop_rad, center=true);
				}
				rotate([90,0,0])
				hull(){
					translate([-((box_outer_w/2)-chop_rad-chop_space),0,0])
					cylinder(h=box_outer_h+chop_extra, r=chop_rad, center=true);
					translate([((box_outer_w/2)-chop_rad-chop_space),0,0])
					cylinder(h=box_outer_h+chop_extra, r=chop_rad, center=true);
				}
			}
		}
	}
}