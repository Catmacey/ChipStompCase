// Middle part of the box
module middle(){
	color("red")
	render()
	difference(){
		union(){
			cornerpads(
				width=corner_pad_r,
				height=foot_height,
				drill=drill_r
			);

			// top lip
			translate([0,0,middle_height])
			linear_extrude(wall_lip_height, convexity = 10){
				difference(){
					rounded_rectangle(
							box_lip_w
						, box_lip_h
						, box_lip_r
					);
					rounded_rectangle(
							box_inner_w
						, box_inner_h
						, box_inner_r
					);
				}
			};

			// Wall
			if(middle_height-foot_height > 0){
				translate([0,0,foot_height])
				linear_extrude(middle_height-foot_height, convexity = 10){
					difference(){
						rounded_rectangle(box_outer_w,box_outer_h,box_outer_r);
						rounded_rectangle(box_inner_w, box_inner_h, box_inner_r);
					}
				};
			}
			// inner lip
			linear_extrude(foot_height, convexity = 10){
				difference(){
					rounded_rectangle(box_outer_w,box_outer_h,box_outer_r);
					rounded_rectangle(pcb_w-wall_thick, pcb_h-wall_thick, pcb_corner_r);
				}
			}
		}
		// Clearance for the Jacks
		jack_holes(height=foot_height+pcb_t);
	};
}