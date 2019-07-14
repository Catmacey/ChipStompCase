$fn=48;

// Use are self contained
use <modules/sob_pcb.scad>;
use <modules/helpers.scad>;
use <modules/buttons.scad>;
use <modules/knob.scad>;



// dp_sob_100x80_base
nozzle = 0.4;
// Ideal printable wall thickness 
// Should be multiple of nozzle width for best results
wall_thick = (nozzle * 5);

// Overlapping wall lip thicknesses 
wall_lip_inner = wall_thick * 0.4;
wall_lip_outer = wall_thick - wall_lip_inner;

// PCB dimensions
pcb_w = 100; // width
pcb_h = 80; // height
pcb_t = 1.6; // thickness
pcb_hole_r = 1.6; // mounting hole radius
pcb_hole_off = 4; // mounting hole offset
pcb_corner_r = 4; // corner radius
pcb_tolerance = 0.25; // How much space to allow for over sized PCBs

// Overall widths of box shell
box_inner_w = pcb_w + (pcb_tolerance*2);
box_outer_w = box_inner_w + (wall_thick*2);
box_inner_h = pcb_h + (pcb_tolerance*2);
box_outer_h = box_inner_h + (wall_thick*2);
box_lip_w = box_inner_w + (wall_lip_inner*2); 
box_lip_h = box_inner_h + (wall_lip_inner*2);

box_inner_r = pcb_corner_r + pcb_tolerance;
box_outer_r = pcb_corner_r + pcb_tolerance + wall_thick;
box_lip_r = pcb_corner_r + pcb_tolerance + wall_lip_inner;

wall_lip_height = 1;
foot_height = 2;
middle_height = 5.5;

// How much vertical space the electronics have inside the middle/top enclosure from the top of the middle foot (eg the underside of PCB) to the underside of the top surface (not including ribs)
middle_top_internal_height = 11;

top_ceiling = middle_top_internal_height + foot_height - middle_height; // How much inner height belongs to the top
top_face_thick = 1;
top_rib_thick = 1;

drill_r = 1.5;
corner_pad_r = pcb_hole_off + pcb_tolerance + pcb_tolerance;

// Positions of in/outs on back side
// heights are from PCB top surface
jack_in = 57.8;
jack_out = 77.8;
jack_height = 2.65;
jack_clear_r = 3.5;
usb_center = 45.72;
usb_clear_w = 10;
usb_clear_r = 2.5;
usb_height = 1.5;

// Position of twiddlers on the top
pot_rad = 3.4;
top_holes = [
		// x, y, radius, label, supportdepth
		[58.42, 22.86, pot_rad, "F"] // Feedback
	, [87.63, 22.86, pot_rad, "M"] // Mix
	,	[58.42, 53.34, pot_rad, "G"] // Gain
	, [87.63, 53.34, pot_rad, "V"] // Volume
	, [30.48, 53.34, 3.8] // encoder
	, [17.78, 69.85, 5] // button 1
	, [43.18, 69.85, 5] // button 2
	, [5.08, 53.34, 1, undef, 4] // led 1
	, [5.08, 63.5, 1, undef, 4] // led 2
	, [58.42, 15.24, 1, undef, 2] // clipled
];
// x, y, w, h
top_squares = [
		// [30.48, 20.32 ,35.5, 23.5] // screen
		[
			// screen
			30.48, 18.5, 34, 19, // outer hole (in the surface)
			30.48, 20.25, 35, 23.5, //inner hole (for clearance)
			30.48, 33, 15, 6// 15mm Clearance for flex cable
		] 
	, [6.55, 16.51, 5, 7.5] // switch
];

// Labels
labels = [
		[6.55, 16.51-8, "0", 5] // off
	, [6.55, 16.51+8, "1", 5] // on
	, [jack_in, 2.5, "▼", 4] // in
	, [jack_out, 2.5, "▲", 4] // out
	// , [62, 15.24, "!"] // clip
];


// Button height above PCB surface (including height of tactile)
tactile_height = 4.5;
button_z_offset = tactile_height + pcb_t + foot_height;
// Internal height
button_base_height = middle_top_internal_height-(pcb_t+tactile_height+top_rib_thick);
// external height
button_top_height = top_rib_thick + top_face_thick + 2;
// Translation


// The PCB (Handy for visualizing)
*translate([0,0,foot_height]){
	sob_pcb(width=pcb_w, height=pcb_h, thickness=pcb_t);
}


// Build the model
top();
// middle();
// bottom();
// A knurled knob
*translate([conv_x(30.48), conv_y(53.34), middle_top_internal_height+top_face_thick+top_rib_thick+1.5])
	knob(
			shaft_rad=3
		, shaft_depth=9
		, outer_rad=7
		, key_depth=7
		, knurled=8
		, centerpoint=false
	)
;
// Potentiometer knows
*translate([conv_x(58.42), conv_y(22.86), middle_top_internal_height+top_face_thick+top_rib_thick+1.5])
	knob(shaft_rad=3, shaft_depth=9, outer_rad=5, key_depth=7)
;
*translate([conv_x(87.63), conv_y(22.86), middle_top_internal_height+top_face_thick+top_rib_thick+1.5])
	knob(shaft_rad=3, shaft_depth=9, outer_rad=5, key_depth=0)
;
*translate([conv_x(58.42), conv_y(53.34), middle_top_internal_height+top_face_thick+top_rib_thick+1.5])
	knob(shaft_rad=3, shaft_depth=9, outer_rad=5, key_depth=7)
;
*translate([conv_x(87.63), conv_y(53.34), middle_top_internal_height+top_face_thick+top_rib_thick+1.5])
	knob(shaft_rad=3, shaft_depth=9, outer_rad=5, key_depth=0)
;

// Don't need to see the buttons normally
*translate([conv_x(17.78), conv_y(69.85), button_z_offset]){
	color("green")
	button_cyl(
			4.8
		,	3.5
		,	6
		,	button_base_height
	);
}
*translate([conv_x(43.18), conv_y(69.85), button_z_offset]){
	color("green")
	button_cyl(
			4.8
		,	3.5
		,	6
		,	button_base_height
	);
}


// Includes have access to variables declare in here
include <includes/modules_include.scad>;
// separate parts
include <includes/inc_top.scad>;
include <includes/inc_middle.scad>;
include <includes/inc_bottom.scad>;
