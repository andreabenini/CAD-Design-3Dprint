//-- Parametric Spool Hub for 606zz bearings
//--
//-- remixed from thing #605360 by Ben (Andrea Benini) 2021-02
//-- remixed from thing #545954 by mateddy (James Lee)
//-- redesigned from thing #27139 by QuantumConcepts (Josh McCullough)
//-- and also based on a brilliant design by Sylvain Rochette (labidus),
//-- Thingiverse thing #596838. AndrewBCN - Barcelona, Spain - December 2014
//-- GPLV3


// Program Parameters

// Spool Hole Diameter
spool_hole_diam = 58.0;     // [40.0:60.0] 53.5 Small, 58.0 Medium, 72.5 Big

// Internal Spool Thickness
spool_wall_thickness=18;    // [5.0:12.0]  10   Small, 18 Big Reel

// Bearing shape [inner, outer, height]
// 608zz = 8x22x7, radius 11.1
// 606zz = 6x17x6, radius ~8.5/8.6
bearingHeight = 6;          // bearing height
bearingRadius = 8.6;        // bearing radius with tolerance for insertion


// DO NOT TOUCH ANYTHING BELOW IF YOU DON'T KNOW WHAT YOU'RE DOING

/* [Hidden] */
//-- the rest are not adjustable
r_spool  = 45;              // radius of spool hub 
edge_cut = 1;               // decreases by edge edge_cut

h = 20;                     // Roller height
w = 20;                     // Roller width

ir = 3.3;                   // threaded rod radius + ample tolerance
t  = 4;                     // Roller body radius
e  = 0.02; 

$fn = 64;

// Modules

module cutouts() {
    // make four cutouts (yes, I know I should use a for loop)
    cube([5,100,50], center=true);
    cube([100,5,50], center=true);
    rotate([0,0,45]) cube([5,100,50], center=true);
    rotate([0,0,45]) cube([100,5,50], center=true);
}

module new_hub() {
    difference () {
        union() {
            // base
            difference() {
                cylinder(r=spool_hole_diam/2 + 4, h=3);
                // space for bearing
                translate([0,0,-e]) cylinder(r=bearingRadius+e, h=h+e);
                cutouts();
            }
            
            // core which holds the bearing
            hub_core();
            
            // wall
            difference() {
                cylinder(r=spool_hole_diam/2, h=5+spool_wall_thickness, $fn=100);
                translate([0,0,-e]) cylinder(r=spool_hole_diam/2-2, h=6+spool_wall_thickness+1);
                cutouts();
            }
            
            // torus-shaped ridge using rotate_extrude, yeah!!
            difference() {
                translate([0,0,4.8+spool_wall_thickness])
                rotate_extrude(convexity = 10, $fn=64)
                translate([spool_hole_diam/2-0.7, 0, 0])
                circle(r = 1.7, $fn=64);
                translate([0,0,-e]) cylinder(r=spool_hole_diam/2-2, h=6+spool_wall_thickness+1);
                cutouts();
            }
            
            // torus-shaped reinforcement
            difference() {
                translate([0, 0, 3.4])
                rotate_extrude(convexity=10, $fn=64)
                translate([bearingRadius+5, 1, 0])
                circle(r=4.1, $fn=26);
                cutouts();
            }
            
            // another torus-shaped reinforcement
            difference() {
                translate([0,0,3.4])
                rotate_extrude(convexity = 10, $fn=64)
                translate([spool_hole_diam/2-2.1, 0, 0])
                circle(r = 2, $fn=16);
                cutouts();
            }
        }
        
        // extra hole at 12 o'clock position
        translate ([0,spool_hole_diam/2+3.9,-1 ]) cylinder(r=5.8, h=40);
    }
}

// core which holds the bearing
module hub_core() {
    intersection() {
        difference() {
            cylinder(r1=r_spool, r2=ir, h=h);
      
            // eliminate sharp edge at top
            translate([0,0,h-0.2+1]) cube([100,100,2], center=true);
      
            // space for bearing
            translate([0,0,-e]) intersection() {
                cylinder(r=bearingRadius+e, h=h+e);
                cylinder(r1 = bearingRadius+bearingHeight+e, r2=ir, h=bearingRadius+bearingHeight - ir + e);
            }
            
            // central hole for threaded rod
            cylinder(r=ir, h=h+e);
        }
        cylinder(r=bearingRadius+t, h=h);
    }
}

// Print the part
new_hub();
