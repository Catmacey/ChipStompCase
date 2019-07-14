// Self contained helper modules

// 2d Rectangle with rounded corners
module rounded_rectangle(width=100, height=80, corner_r=4){
	minkowski(){
		square([width-(corner_r*2),height-(corner_r*2)], true);
		circle(r=corner_r);
	}
};

// Corner pad with hole
module cornerpad (x, y, width, height, drill, rotation=0){
	translate([x,y,0]){
		rotate([0,0,rotation]){
			linear_extrude(height){
				difference(){
					hull(){
						square([width,width], false);
						translate([-width,-width,0]){
						 	square([width,width], false);
						}
						circle(width);
					}
					if(drill){
						circle(drill);
					}
				}
			}
		}
	}
};

// Countersunk losenge
module countersunkslot(height, radius, width, sinkdepth){
	sinkradius = radius + sinkdepth; // always 45deg
	off_w = ((width/2) > radius ) ? (width/2)-radius : 0;
	render(){
		union(){
			hull(){
				translate([off_w,0,0])
				cylinder(height-sinkdepth, r=radius, center=false);
				translate([-off_w,0,0])
				cylinder(height-sinkdepth, r=radius, center=false);
			}
			hull(){
				translate([off_w,0,height-sinkdepth])
				cylinder(sinkdepth, r1=radius, r2=sinkradius, center=false);
				translate([-off_w,0,height-sinkdepth])
				cylinder(sinkdepth, r1=radius, r2=sinkradius, center=false);
			};
		};
	};
};


module countersunkhole(height, radius,	sinkdepth){
	sinkradius = radius + sinkdepth; // always 45deg
	render()
	union(){
		cylinder(height-sinkdepth, r=radius, center=false);
		translate([0,0,height-sinkdepth])
		cylinder(sinkdepth, r1=radius, r2=sinkradius, center=false);
	};
}


// Helper module: centered cube on (X,Y) but not on Z, like cylinder
module centered_cube(size){
  translate([-size[0]/2, -size[1]/2, 0])
    cube(size);
}