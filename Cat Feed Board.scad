/****************************************************************************
**
** Copyright (C) 2024 Keith Kyzivat
**
** GNU General Public License Usage
** This file may be used under the terms of the GNU General Public License
** version 3 as published by the Free Software Foundation.
**
** Please review the following information to ensure the GNU General Public
** License requirements will be met:
** https://www.gnu.org/licenses/gpl-3.0.html.
**
****************************************************************************/

board_width=150;
board_length=177.5;
board_xheight=1;
text_emboss_height=2;
$fn=100;
testing=0; // [0:No Test, 1:Test Fit, 2:Test just switch]

module end_of_customizer() {}

include <BOSL2/std.scad>
include <BOSL2/shapes3d.scad>

fidget_slide_switch_housing_height=5.6;
fidget_slide_switch_dimensions=[37.25,20,fidget_slide_switch_housing_height+0.1];
fidget_slide_switch_xheight=0.1; // Extra height that the switch itself sticks up above its housing.

module fidget_slide_switch() {
    rotate([-90,0,0])
    translate([-35.25,-5.5,0])
    import("EZ_Print_Slide_Switch-printables 865051.stl");
}

module fidget_slide_switch_hull() {
    linear_extrude(height=fidget_slide_switch_housing_height+0.01)
    projection()
    scale([0.96,0.96,1])
    fidget_slide_switch();
}

toggle_switch_dimensions=[75, 22, 10];
module toggle_switch_base() {
    translate([toggle_switch_dimensions[0]/2,toggle_switch_dimensions[1]/2,0])
    import("printables-725306 toggle_switch_base.stl");
}

module toggle_switch_base_hull() {
    linear_extrude(height=toggle_switch_dimensions[2]+0.01)
    projection()
    toggle_switch_base();
}

small_thin_toggle_switch_dimensions=[37.5,18,4.35];
module small_thin_toggle_switch_base() {
    import("toggle_switch_small_short_with_divot.base-fed-feed-v1.stl");

    // Remove the rounded edges, since we will be embedding this in a board.
    cube([37.5,2,4.35], center=false);
    translate([0,16,0])
        cube([37.5,2,4.35], center=false);
}

module small_thin_toggle_switch_base_hull() {
    linear_extrude(height=small_thin_toggle_switch_dimensions[2]+0.01)
    projection()
    small_thin_toggle_switch_base();
}



module switch_board() {
    switch_dimensions=small_thin_toggle_switch_dimensions;
    switch_housing_height=small_thin_toggle_switch_dimensions[2];
    board_height=switch_housing_height+board_xheight;
    margin=5;
    dow_offset=18;

    translate([0,-19,0])
    for(i=[0:6]) {
        dow=["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
        for(j=[0:2]) {
            translate([margin, board_length-margin-7+(-switch_dimensions[1]-5.1)*i, board_height])
            #linear_extrude(height=text_emboss_height)
            text(dow[i], size=6, font="DejaVu Sans Mono:style=Bold",);

            translate([margin+dow_offset+(switch_dimensions[0]+margin)*j,board_length-switch_dimensions[1]-(switch_dimensions[1]+5)*i,board_xheight])
                small_thin_toggle_switch_base();
        }
    }

    // Meal names, font size to use, and the width in mm of the te+5xt.
    meal_names = [
        ["BREAKFAST",6,"DejaVu Sans Mono",4.8*9],
        ["LUNCH",6,"DejaVu Sans Mono",4.8*5],
        ["DINNER",6,"DejaVu Sans Mono",4.8*6]
    ];
    bld_xdist_to_split=board_width-margin*2-dow_offset;
    translate([margin+dow_offset,0,0])
    for(i=[0:2]) {
        col_width = bld_xdist_to_split/3;
        col_xcenterpoint = (switch_dimensions[0]-1)/2+((switch_dimensions[0]+margin))*i;

        translate([col_xcenterpoint-meal_names[i][3]/2,board_length-margin-8,board_height]) {
            #linear_extrude(height=text_emboss_height)
            text(meal_names[i][0], size=meal_names[i][1], font=meal_names[i][2]);
        }
    }

    difference() {
        cuboid([board_width,board_length,board_height], anchor=BOTTOM+LEFT+FRONT, rounding=1, edges=[TOP+FRONT, TOP+BACK, LEFT+FRONT, LEFT+BACK, RIGHT+FRONT, RIGHT+BACK, TOP+LEFT, TOP+RIGHT]);

        translate([0,-14,0])
        for(i=[0:6]) {
            for(j=[0:2]) {
                translate([margin+dow_offset+(switch_dimensions[0]+margin)*j,board_length-switch_dimensions[1]-5+(-switch_dimensions[1]-5)*i,board_xheight])
                    small_thin_toggle_switch_base_hull(); //fidget_slide_switch_hull();
            }
        }
    }
}

if(testing == 1) {
    intersection() {
        switch_board();
        cube([toggle_switch_dimensions[0]+34,30,30]);
    }
} else if(testing == 2) {
    small_thin_toggle_switch_base();

    translate([small_thin_toggle_switch_dimensions[0]+10,0,0])
        small_thin_toggle_switch_base_hull();
}
else {
    switch_board();
}


// This is just to make things visible during dev
if($preview) {
    if(!testing) {
        #linear_extrude(height=board_xheight+.8)
            translate([5,5,0])
                square([board_width-10, board_length-10]);
    }

    // for determining the width of text.
    translate([-40,-7,0])
        text("G", 7, "DejaVu Sans Mono");

    translate([0,-20,0]) {
        difference() {
            union() {
                cube([2,10,2]);
                cube([10,2,2]);
                translate([2,2,0])
                    fillet(l=10, r=4);
            }
            fillet(l=10, r=5);
        }
    }
}
