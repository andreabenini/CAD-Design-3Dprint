include <BOLTS.scad>;


$fn=150;
$dia = 35;
$height = 9;
$silicon = 3;
$rod_size = "M8";
$rod_dia = 8.6;

$center_size = "M6";
$center_width = 6.4;

$segment_dia = 4;
$no_of_segments = 12;
$extra_length = 5;

//frame(false);
//frame(true);
pcbHolder();
//rotate([90,180,0]) handleKnob();
//rotate([90,0,0]) shim();
//rotate([90,0,0]) nutHolder();
//arm(true);
//arm(false);

module shim(){
    translate([0,0,6]) difference(){
		union(){
			translate([0,-3,0])rotate([90,0,0])cylinder(d=$dia,h=7,center=true);
			for(a=[0:($no_of_segments-1)]){
				rotate([0,(360/$no_of_segments)*a,0])translate([0,-3,$dia/2])rotate([90,0,0])cylinder(d=$segment_dia,h=7,center=true);
			}
		}
		rotate([90,0,0])cylinder(d=$center_width,h=170,center=true);
        translate([0,-3.4,0]) rotate([90,0,0]) ISO4014($center_size,l=140);

	}
}


module arm($knob = true){
    difference(){
        hull(){
            translate([0,43,0]) cylinder(d=9, h=2.5);
            translate([0,-43,0]) cylinder(d=9, h=2.5);
        }
        translate([0,0,3.6]) rotate([90,0,0]) cylinder(d=4, h=75, center=true);
        
        if($knob){
            translate([0,43,2.6]) rotate([0,180,0]) ISO4014("M4",l=40); 
            
        }
        else {
            translate([0,-43,0]) cylinder(d=6.2,h=10);
        }
    }
    
    if($knob){
       difference(){
            union(){
                translate([0,-43,2.6*2+0.4]) rotate_extrude(convexity = 10) 
                hull(){
                    translate([2.5, 0, 0]) circle(d = 1.2);
                    translate([0, -0.6, 0]) square(1.2);
                }
                translate([0,-43,2.6]) cylinder(d=5.5,h=2.6);
            }
            translate([0,-43,6]) cube([1.5,10,5], center=true);
            translate([0,-43,2]) cylinder(d=3,h=10);
        } 
         
    }
    else {
        translate([0,43,0]) cylinder(d=25,h=1.5);
    }
}

module spongeHolder(){
    
}

module frame($segments = true) {
difference(){
    union(){
        hull(){
            translate([sin(360*0/3)*70, cos(360*0/3)*70, 0 ]) cylinder(h = $height, d=$dia/2);
            translate([sin(360*1/3)*70, cos(360*1/3)*70, 0 ]) cylinder(h = $height, d=$dia/2);
        }

        hull(){
            translate([sin(360*0/3)*70, cos(360*0/3)*70, 0 ]) cylinder(h = $height, d=$dia/2);
            translate([sin(360*2/3)*70, cos(360*2/3)*70, 0 ]) cylinder(h = $height, d=$dia/2);
        }
        hull(){
            translate([sin(360*1/3)*70, cos(360*1/3)*70, 0 ]) cylinder(h = $height, d=$dia/2);
            translate([sin(360*2/3)*70, cos(360*2/3)*70, 0 ]) cylinder(h = $height, d=$dia/2);
        }
            
        translate([sin(360*0/3)*70, cos(360*0/3)*70, 0 ]) cylinder(h = $height, d=$dia);
        translate([sin(360*1/3)*70, cos(360*1/3)*70, 0 ]) cylinder(h = $height, d=$dia);
        translate([sin(360*2/3)*70, cos(360*2/3)*70, 0 ]) cylinder(h = $height, d=$dia);
        
        if($segments){
            translate([sin(360*0/3)*70, cos(360*0/3)*70, $height/2 ]) rotate([90,180,0]) shimNotch();
        }
    }
    
    
    if(!$segments){
        translate([sin(360*1/3)*70, cos(360*1/3)*70, 4 ]) rotate([180,0,0]) ISO4014($rod_size,l=40);
        translate([sin(360*2/3)*70, cos(360*2/3)*70, 4 ]) rotate([180,0,0]) ISO4014($rod_size,l=40);
    }
    
    translate([sin(360*1/3)*70, cos(360*1/3)*70, 0 ])cylinder(h = $height, d=$rod_dia);
    translate([sin(360*2/3)*70, cos(360*2/3)*70, 0 ])cylinder(h = $height, d=$rod_dia);
    translate([sin(360*1/3)*70, cos(360*1/3)*70 - $dia/2+$silicon/2, $height/2 ]) cube([$silicon,$silicon,$height], center=true);
    translate([sin(360*2/3)*70, cos(360*2/3)*70 - $dia/2+$silicon/2, $height/2 ]) cube([$silicon,$silicon,$height], center=true);

    translate([sin(360*0/3)*70, cos(360*0/3)*70, 0 ]) cylinder(h = $height*2, d=$center_width);
}
}


module nutHolder(){
    translate([0,0,6]) difference(){
		difference(){
            translate([0,-3,0])rotate([90,0,0])cylinder(d=$dia-6,h=9,center=true);
			for(a=[0:5]){
				rotate([0,(360/6)*a,0])translate([0,-3,21.5])rotate([90,0,0])cylinder(d=18,h=9.2,center=true);
			}
		}
		rotate([90,0,0])cylinder(d=$rod_dia,h=170,center=true);
        translate([0,-3.56,0]) rotate([90,0,0]) ISO4014($rod_size,l=140);

	}
}



module shimNotch() {
	difference(){
		translate([0,-4,0])rotate([90,0,0])cylinder(d=$dia,h=$height,center=true);
		translate([0,-8,0])for(a=[0:($no_of_segments-1)]){
			rotate([0,(360/$no_of_segments)*a,0])translate([0,0,$dia/2-($dia/4.5)/2])cylinder(d=$segment_dia,h=$dia/4,center=true);
		}
	}
}

module handleKnob() {
	difference(){
		union(){
			translate([0,-($dia+$extra_length)/2,0])rotate([90,0,0])cylinder(d=$dia,h=$dia+$extra_length,center=true);
			for(a=[0:($no_of_segments-1)]){
				rotate([0,(360/$no_of_segments)*a,0])translate([0,-$dia-$extra_length,$dia/2-($dia/4.5)/2])cylinder(d=$segment_dia,h=$dia/4.5,center=true);
			}
			for(a=[0:($no_of_segments-1)]){
				rotate([0,(360/$no_of_segments)*a,0])translate([0,-($dia+$extra_length)/2,$dia/2])rotate([90,0,0])cylinder(d=$segment_dia,h=$dia+$extra_length,center=true);
			}
			for(a=[0:($no_of_segments-1)]){
				rotate([0,(360/$no_of_segments)*a,0])translate([0,-$dia-$extra_length,$dia/2])sphere(d=$segment_dia);
			}
		}
		#rotate([90,0,0])cylinder(d=$center_width,h=170,center=true);
        translate([0,-3.7,0]) rotate([90,0,0]) ISO4014($center_size,l=140);

	}
}

module pcbHolder() {
	difference(){
		union(){
			translate([0,9/2,0]) cube([40,21,12],center=true);
			translate([0,15,0])rotate([90,0,0])cylinder(r=8,h=10);
			translate([0,5.2,0])sphere(r=8);
			translate([12,10,6.75])cylinder(d=9,h=3,center=true);
		}
		translate([0,17,0])rotate([90,0,0])cylinder(d=$center_width,h=30,center=true);
        translate([0,1.5,0])rotate([90,0,0])cylinder(d=$center_width+4,h=5,center=true);
		translate([0,-17.5,0])cube([41,30,1.4],center=true);
		translate([0,-17.5,-4])rotate([15,0,0])cube([41,30,1.4],center=true);
		translate([0,-17.5,4])rotate([-15,0,0])cube([41,30,1.4],center=true);
        translate([0,5.7,-0.2]) scale([1,1.44,1]) rotate([90,90,180]) ISO4014($center_size,l=40);
		translate([0,2.5,5])cube([11.75,6.5,10],center=true);
		translate([12,10,0])cylinder(d=4.15,h=30,center=true);
		translate([12,10,-3.3]) rotate([0,0,30]) ISO4014("M4",l=40);
        
        translate([7.5,-17.5,0])rotate([-30,90,0])cube([41,30,1.4],center=true);
        translate([-7.5,-17.5,0])rotate([30,90,0])cube([41,30,1.4],center=true);
        translate([0,-19.22,0])rotate([0,90,0])cube([41,30,1.4],center=true);
        
        
        translate([7.5+13,-17.5,0])rotate([-30,90,0])cube([41,30,1.4],center=true);
        translate([-7.5+13,-17.5,0])rotate([30,90,0])cube([41,30,1.4],center=true);
        translate([13,-19.22,0])rotate([0,90,0])cube([41,30,1.4],center=true);
        
        translate([7.5-13,-17.5,0])rotate([-30,90,0])cube([41,30,1.4],center=true);
        translate([-7.5-13,-17.5,0])rotate([30,90,0])cube([41,30,1.4],center=true);
        translate([-13,-19.22,0])rotate([0,90,0])cube([41,30,1.4],center=true);
	}
}

