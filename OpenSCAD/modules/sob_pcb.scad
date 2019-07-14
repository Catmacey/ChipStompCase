// DP SOB pcb format
module sob_pcb(
		width=100
	, height=80
	, thickness=1.6
){
	pcb_corner_r = 4; // corner radius
	hole_r = 1.6; // mounting hole radius
	hole_off = 4; // mounting hole offset
	off_w = (width/2)-hole_off;
	off_h = (height/2)-hole_off;
	// The PCB
	color("DarkGreen", 1);
	linear_extrude(height = thickness, center = false){
		difference(){
			minkowski(){
				square([width-(pcb_corner_r*2),height-(pcb_corner_r*2)], true);
				circle(r=pcb_corner_r, center=true);
			}
			for(coord = [
				[-off_w,-off_h],
				[-off_w,off_h],
				[off_w,off_h],
				[off_w,-off_h]
			]){
				translate([coord[0],coord[1],0]){
					circle(r=hole_r, center=false);
				}
				
			}
		}
	}

}
