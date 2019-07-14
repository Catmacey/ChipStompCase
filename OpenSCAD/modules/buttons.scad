// Selfcontained module
/*
 *Makes a cylindrical button with a thick base

        ├┄┄┄▷ top_rad
        ┊   ┊
    ┌───────┐ ┄┄┄┄△ top_height
    │   ┊   │     ┊ 
    │   ┊   │     ┊
    │   ┊   │     ┊
  ┌─┘┄┄┄┄┄┄┄└─┐ ┄┄┴┄┄△ base_height
  │     ┊     │      ┊     
  │     ┊     │      ┊     
  │     ┊     │      ┊
  └───────────┘ ┄┄┄┄┄┴┄┄
        ┊     ┊
        ├┄┄┄┄┄▷ base_rad

*/

module button_cyl(
		top_rad
	, top_height
	, base_rad
	, base_height
){
	union(){
		cylinder(h=top_height+base_height, r=top_rad, center=false);
		cylinder(h=base_height, r=base_rad, center=false);
	}
	translate([0,0,(top_height+base_height)]){
		scale([1,1,0.2])
		sphere(r=top_rad);
	}
}
