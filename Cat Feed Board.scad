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

board_width=158;
board_length=180+14;
board_xheight=1;
text_emboss_height=2;

$fn=100;

//board_width=90*3;
//board_length=90*2;

include <BOSL2/std.scad>
include <BOSL2/shapes3d.scad>

module switch() {
    rotate([-90,0,0])
    translate([-35.25,-5.5,0])
    import("/home/kyzik/Documents/3D models/My Designs/Cat Feed Board/EZ_Print_Slide_Switch-printables 865051.stl");
}

module switch_hull() {
    linear_extrude(height=switch_housing_height+0.01)
    projection()
    scale([0.9,0.9,1])
    switch();
}

switch_housing_height=5.6;
switch_dimensions=[37.25,20,switch_housing_height+0.1];
switch_xheight=0.1; // Extra height that the switch itself sticks up above its housing.

margin=5;
board_height=switch_housing_height+board_xheight;
difference() {
    cuboid([board_width,board_length,board_height], anchor=BOTTOM+LEFT+FRONT, rounding=1, edges=[TOP+FRONT, TOP+BACK, LEFT+FRONT, LEFT+BACK, RIGHT+FRONT, RIGHT+BACK, TOP+LEFT, TOP+RIGHT]);

    translate([0,-14,0])
    for(i=[0:6]) {
        for(j=[0:2]) {
            translate([margin+25+(switch_dimensions[0]+5)*j,board_length-switch_dimensions[1]-5+(-switch_dimensions[1]-5)*i,board_xheight])
                switch_hull();
        }
    }
}

meal_names = [["BREAKFAST",5,0], ["LUNCH",7,8.5], ["DINNER",7,5.5]];
for(i=[0:2]) {
    translate([margin+25+(switch_dimensions[0]+meal_names[i][2])*i,board_length-margin-8,board_height])
        linear_extrude(height=text_emboss_height)
        text(meal_names[i][0], size=meal_names[i][1], font="DejaVu Sans Mono");
}


translate([0,-14,0])
for(i=[0:6]) {
    dow=["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
    for(j=[0:2]) {
        translate([margin, board_length-margin-14+(-switch_dimensions[1]-5.1)*i, board_height])
        linear_extrude(height=text_emboss_height)
        text(dow[i], size=8, font="DejaVu Sans Mono");

        translate([margin+25+(switch_dimensions[0]+5)*j,board_length-switch_dimensions[1]-5+(-switch_dimensions[1]-5)*i,board_xheight])
            switch();
    }
}


// This is just to make things visible during dev
if($preview)
    #linear_extrude(height=board_xheight+0.1)
        translate([5,5,0])
            square([board_width-10, board_length-10]);
