// Modules that need to be included to take advantage of global variables


module cornerpads(width, height, drill){
	// Offsets for centers of the corner drills
	off_w = (pcb_w/2)-pcb_hole_off;
	off_h = (pcb_h/2)-pcb_hole_off;
	for(coord = [
		[-off_w,-off_h, 90],
		[-off_w,off_h, 0],
		[off_w,off_h, 90],
		[off_w,-off_h, 0]
	]){
		cornerpad(
			x=coord[0],
			y=coord[1],
			width=width,
			height=height,
			drill=drill,
			rotation=coord[2]
		);
	}
}

module jack_supports(height=10){
	// Creates wedge shaped ribs against the back wall next to the jacks
	// 1mm before the start of the shell
	wallinnerface = (pcb_h/2)+pcb_tolerance;

	// inbetween usb and the input jack
	usb_edge = (conv_x(usb_center) + (usb_clear_w/2));
	jack_in_edge = (conv_x(jack_in) - (jack_clear_r));
	mid_point = ((jack_in_edge - usb_edge)/2)+usb_edge;

	translate([
			mid_point
		, wallinnerface
		, 0
	])
	support_wedge(height=height, width=2);
}

module support_wedge(height=10, width=2){
	hull(){
		centered_cube([width,1,1]);
		translate([0,-1,height-1]) centered_cube([width,2,1]);
	}
	;
}

module jack_holes(height=0){
	// 1mm extra either side of the shell thickness
	cut_depth = wall_thick+pcb_tolerance+(wall_thick/2)+2; 
	// 1mm before the start of the shell
	cut_start_y = (pcb_h/2)-(wall_thick/2)-1;
	
	// USB
	translate([
			conv_x(usb_center)
		, cut_start_y
		, height+usb_height
	])
	rotate([-90,0,0])
	countersunkslot(
			height=cut_depth
		, radius=usb_clear_r
		, width=usb_clear_w
		, sinkdepth=2
	);

	// In
	translate([
			conv_x(jack_in)
		, cut_start_y
		, height+jack_height
	])
	rotate([-90,0,0])
	countersunkhole(
			height=cut_depth
		, radius=jack_clear_r
		, sinkdepth=2
	);

	// Out
	translate([
			conv_x(jack_out)
		, cut_start_y
		, height+jack_height
	])
	rotate([-90,0,0])
	countersunkhole(
			height=cut_depth
		, radius=jack_clear_r
		, sinkdepth=2
	);
}

// Converts coord from top left to offset from center
function conv_x(x) = x - (pcb_w/2);
function conv_y(y) = -(y - (pcb_h/2));