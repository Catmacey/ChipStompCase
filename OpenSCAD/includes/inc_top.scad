// Needs to be included

// Top part of the box
// Includes holes for buttons, leds and potentiometers

// Top
module top(){
	translate([0,0,middle_height])
	union(){
		// top surface
		translate([0,0,top_ceiling])
		difference(){
			union(){
				linear_extrude(top_face_thick, convexity=10){
					rounded_rectangle(box_outer_w, box_outer_h, box_outer_r);
				};

				// A couple of ribs for strength
				// H
				// translate([0,box_inner_h/4,0])
				translate([0,0,-top_rib_thick]){
					translate([0,conv_y(22.86),0]) // right through the top pots
					centered_cube([box_outer_w, 2, top_rib_thick]);
					translate([0,conv_y(53.34),0]) // right through the bottom pots
					centered_cube([box_outer_w, 2, top_rib_thick]);
					// V
					centered_cube([2, box_outer_h, top_rib_thick]);
					translate([box_inner_w/4,0,0])
					centered_cube([2, box_outer_h, top_rib_thick]);
					translate([-box_inner_w/4,0,0])
					centered_cube([2, box_outer_h, top_rib_thick]);
				}

				// Rims around the holes
				surfacehole_rims();
				// Support under labels
				surfacelabel_supports();
			}

			// Referenced from the top of the surface
			translate([0,0,top_face_thick]){
				surfaceholes();
			}

			surfacelabels();
		}

		// Wall
		render()
		difference(){
			union(){
				translate([0,0,wall_lip_height])
				linear_extrude(top_ceiling-wall_lip_height, convexity=10){
					difference(){
						rounded_rectangle(box_outer_w, box_outer_h, box_outer_r);
						rounded_rectangle(box_inner_w, box_inner_h, box_inner_r);
					}
				}
				;
				// Bit of extra support for thin/small bits of the back wall
				translate([0,0,wall_lip_height]){
					jack_supports(height=top_ceiling-wall_lip_height);
				}

				// bottom lip
				linear_extrude(wall_lip_height, convexity=10){
					difference(){
						rounded_rectangle(
								box_outer_w
							, box_outer_h
							, box_outer_r
						);
						rounded_rectangle(
								box_lip_w
							, box_lip_h
							, box_lip_r
						);
					}
				};
			}
			jack_holes(-middle_height+foot_height+pcb_t);
		}
		translate([0,0,wall_lip_height])
		cornerpads(
			width=corner_pad_r,
			height=top_ceiling-wall_lip_height,
			drill=drill_r
		);


	}
}

// Provides a thicker rim around the surface holes for more strength
module surfacehole_rims(){
	depth = top_rib_thick;
	rim_width = 1.6;
	// The round holes
	for(hole = top_holes){
		rim_depth = depth + hole[4]?hole[4]:1;
		translate([conv_x(hole[0]), conv_y(hole[1]), -rim_depth]){
			cylinder(h=rim_depth, r=hole[2]+rim_width, center=false);
		}
	}
	// The square holes
	for(hole = top_squares){
		if(hole[4]){
			// offset inner
			translate([conv_x(hole[4]), conv_y(hole[5]), -depth])
			centered_cube([hole[6]+(rim_width*2),hole[7]+(rim_width*2),depth]);
		}else{
			// simple hole
			translate([conv_x(hole[0]), conv_y(hole[1]), -depth])
			centered_cube([hole[2]+(rim_width*2),hole[3]+(rim_width*2),depth]);
		}
		if(hole[8]){
			// Another bit of inner clearance cut
			translate([conv_x(hole[8]), conv_y(hole[9]), -depth])
			centered_cube([hole[10]+(rim_width*2),hole[11]+(rim_width*2),depth]);
		}
	}
}

// Provides cutters for creating holes in the top
module surfaceholes(){
	// zero is the top of the surface
	
	// Thickness of cutter is surface + rib + 1mm either side
	cut_thick = 1 + top_face_thick + top_rib_thick + 1;
	// The round holes
	for(hole = top_holes){
		// variable depth holes
		hole_depth = cut_thick + (hole[4]?(hole[4]-top_rib_thick):0);
		translate([conv_x(hole[0]), conv_y(hole[1]), -(hole_depth-1)]){
			cylinder(h=hole_depth, r=hole[2], center=false);
		}
	}
	// Now the square ones
	for(hole = top_squares){
		translate([conv_x(hole[0]), conv_y(hole[1]), -(cut_thick-1)])
		centered_cube([hole[2],hole[3],cut_thick]);
		if(hole[4]){
			// offset inner part of cut to allow part closer to face
			translate([conv_x(hole[4]), conv_y(hole[5]), -(top_face_thick+top_rib_thick+1)])
			centered_cube([hole[6],hole[7],top_rib_thick+1]);
		}
		if(hole[8]){
			// Another bitt of inner clearance cut
			translate([conv_x(hole[8]), conv_y(hole[9]), -(top_face_thick+top_rib_thick+1)])
			centered_cube([hole[10],hole[11],top_rib_thick+1]);
		}
	}
}

hole_label_offset_y = 7;

module surfacelabels(){
	for(label = labels){
		surfacelabel(
				x=conv_x(label[0])
			, y=conv_y(label[1])
			, text=label[2]
			, size=label[3]
		);
	}
	for(hole = top_holes){
		if(hole[3]){
			surfacelabel(
					x=conv_x(hole[0])
				, y=-(conv_y(hole[1])+hole_label_offset_y)
				, text=hole[3]
			);
		}
	}	
}

module surfacelabel_supports(){
	// Creates bit of extra letter-shaped thickness below letter to provide additional support in
	// these areas where the letter has cut into the surface
	for(label = labels){
		surfacelabel_support(
				x=conv_x(label[0])
			, y=conv_y(label[1])
			, text=label[2]
			, size=label[3]
		);
	}
	for(hole = top_holes){
		if(hole[3]){
			surfacelabel_support(
					x=conv_x(hole[0])
				, y=-(conv_y(hole[1])+hole_label_offset_y)
				, text=hole[3]
			);
		}
	}		
}

font_face = "Source Sans Pro:style=Black";
font_default_size = 7;


module surfacelabel_support(x,y,text,size){
	fontsize = (size?size:font_default_size);
	// place a thin vaguely letter shaped splat under the label to increase thickness a little
	translate([x, y, -0.5])
	linear_extrude(1, convexity=10){
		minkowski(){
			hull(){
				text(
						text
					, size=fontsize
					, font = font_face
					, halign="center"
					, valign="center"
				);
			}
			circle(2);
		}
	}
}

module surfacelabel(x,y,text,size){
	depth = 0.6;
	fontsize = (size?size:font_default_size);
	// we make the cut from 1mm above the surfac e to ensure good geometry
	translate([x, y, top_face_thick-depth]){
		linear_extrude(depth+1, convexity=10)
		text(
				text
			, size=fontsize
			, font = font_face
			, halign="center"
			, valign="center"
		);
	}
}