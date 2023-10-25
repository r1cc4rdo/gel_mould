/* [Mould dimensions] */
// Width x Height x Thickness (mm)
Mould_dimensions = [18, 8, 1]; // [0:0.1:100]
// Corner cutout (%)
Mould_cutout = 0.15; // [0:0.01:0.3]

/* [Slots count and position] */
// Columns x rows
Slots_count = [16, 2];
// Horz/vert spacing (mm)
Slots_spacing = [1, 2]; // [0:0.01:5]
// Slots vertical displacement (%)
Slots_displacement = 0.12; // [-1:0.01:1]

/* [Slot dimensions] */
// Width x Height x Inset (mm)
Slot_dimensions = [0.4, 1.6, 0.2]; // [0:0.01:10]
// Soften slot corners (mm)
Slot_corner_radius = 0.08; // [0:0.01:0.2]
// Adds a draft to help mould release (mm)
Slot_release = 0.15; // [0:0.01:0.5]
// Angle into the surface, after inset (deg)
Slot_angle = 25; // [0:0.1:45]

/* [Gel grid] */
Enable_grid = true;
Grid_step = 1; // [0.01:0.01:100]
Grid_thickness = 0.02; // [0.01:0.01:0.5]

/* [Gel text] */
Enable_gel_text = true;
Gel_text = "Angle 25, grid 1mm";
// Gel text size (pt)
Gel_text_size = 1; // [0.1:0.01:10]
// Gel text thickness (mm)
Gel_text_thickness = 0.05; // [0.01:0.01:0.5]
// Gel text horizontal displacement (%)
Gel_text_horz_disp = 0; // [-1:0.01:1]
// Gel text vertical displacement (%)
Gel_text_vert_disp = -0.6; // [-1:0.01:1]

/* [Mold top text] */
Enable_top_text = true;
Top_text = "Angle 25, 16x2 slots";
// Mold top text size (pt)
Top_text_size = 1; // [0.1:0.01:10]
// Mold top text thickness (mm)
Top_text_thickness = 0.05; // [0.01:0.01:0.5]
// Mold top text horizontal displacement (%)
Top_text_horz_disp = 0; // [-1:0.01:1]
// Mold top text vertical displacement (%)
Top_text_vert_disp = -0.6; // [-1:0.01:1]

/* [Mold bottom text] */
Enable_bottom_text = true;
Bottom_text = "Renee Chow lab, Monash U";
// Mold bottom text size (pt)
Bottom_text_size = 0.6; // [0.1:0.01:10]
// Mold bottom text thickness (mm)
Bottom_text_thickness = 0.05; // [0.01:0.01:0.5]
// Mold bottom text horizontal displacement (%)
Bottom_text_horz_disp = 0; // [-1:0.01:1]
// Mold bottom text vertical displacement (%)
Bottom_text_vert_disp = 0.8; // [-1:0.01:1]

/* [Mold logo] */
Enable_logo = true;
Logo_filename = "logo.svg";
Logo_scale = 1; // [0:0.01:100]
// Logo thicknesst (mm)
Logo_thickness = 0.05; // [0.01:0.01:0.5]
// Logo horizontal displacement (%)
Logo_text_horz_disp = 0.28; // [-1:0.01:1]
// Logo vertical displacement (%)
Logo_text_vert_disp = 0.28; // [-1:0.01:1]


module base()
{
    mx = Mould_dimensions[0]; // mould width (mm)
    my = Mould_dimensions[1]; // mould height (mm)
    mz = Mould_dimensions[2]; // mould thickness (mm)
    mc = Mould_cutout; // cutout (%)

    gx = Grid_step;
    gy = Grid_step;
    gz = Grid_thickness;
                
    max_dim = max(mx, my);
    top_corner = [mx/2, my/2];

    difference()
    {
        union()
        {
            cube(size=[mx, my, mz], center=true); // Mould body
                        
            if (Enable_gel_text)
            {
                horz_pos = -mx * Gel_text_horz_disp / 2;
                vert_pos = -my * Gel_text_vert_disp / 2;
                
                color("green")
                translate([horz_pos, vert_pos, mz/2]) rotate([0, 180, 0])
                linear_extrude(height=Gel_text_thickness * 2, center=true)
                text(Gel_text, size=Gel_text_size, halign="center", valign="center", $fn=20);
            };
            
            if (Enable_grid)
            {            
                for(g = [-my/2+gy : gy : my/2-gy]) // horz. grid lines
                translate([0, g, mz/2]) rotate([0, 90, 0])
                cylinder(mx, r=gz, center=true, $fn = 20);
                
                for(g = [-mx/2+gx : gx : mx/2-gx]) // vert. grid lines
                translate([g, 0, mz/2]) rotate([90, 0, 0])
                cylinder(my, r=gz, center=true, $fn = 20);
            };
        };
    
        translate(top_corner) rotate(45) // Corner cutout
        cube(size=[max_dim * mc, max_dim * 2, (mz + gz) * 2], center=true);
        
        if (Enable_top_text)
        {
            horz_pos = -mx * Top_text_horz_disp / 2;
            vert_pos = -my * Top_text_vert_disp / 2;
            
            color("green")
            translate([horz_pos, vert_pos, -mz/2]) rotate([0, 180, 0])
            linear_extrude(height=Top_text_thickness * 2, center=true)
            text(Top_text, size=Top_text_size, halign="center", valign="center", $fn=20);
        };

        if (Enable_logo)
        {
            horz_pos = -mx * Logo_text_horz_disp;
            vert_pos = -my * Logo_text_vert_disp;
            
            color("green")
            translate([horz_pos, vert_pos, -mz/2])
            linear_extrude(height=Logo_thickness * 2, center=true)
            scale(Logo_scale)
            import (file=Logo_filename);
        };
        
        if (Enable_bottom_text)
        {
            horz_pos = -mx * Bottom_text_horz_disp / 2;
            vert_pos = -my * Bottom_text_vert_disp / 2;
            
            color("green")
            translate([horz_pos, vert_pos, -mz/2]) rotate([0, 180, 0])
            linear_extrude(height=Bottom_text_thickness * 2, center=true)
            text(Bottom_text, size=Bottom_text_size, halign="center", valign="center", $fn=20);
        };

//    translate([0, text_displacement, 0])
//    info("Renee fish mold", mold_dimensions[2] * 2);

//    color("green")
//    translate([0, text_displacement, text_thickness])
//    info("Renee fish mold", mold_dimensions[2]);

    };
};

module slot()
{
    render() // cache part
    {
        c = Slot_corner_radius; // rounded corners
        x = Slot_dimensions[0] - c; // width of slot
        y = Slot_dimensions[1] - c; // height of slot
        z = Slot_dimensions[2] - c; // inset before angle
        d = tan(Slot_angle) * y; // slope depth
        r = Slot_release; // mould draft angle
        
        points = [[0, 0, z], [x, 0, z], [x, y, z+d], [0, y, z+d],
            [-r, -r, -c], [x+r, -r, -c], [x+r, y+r, -c], [-r, y+r, -c]];
        
        faces = [
            [3,2,1,0], // slanted bottom
            [0,1,5,4], [1,2,6,5], // sides
            [2,3,7,6], [3,0,4,7], // sides
            [4,5,6,7]]; // flush with base
        
        minkowski($fn=40)
        {
            polyhedron(points=points, faces=faces);
            sphere(r=c);
        };
    };
};

module slots()
{
    translate([0, -Slots_displacement * Mould_dimensions[1], Mould_dimensions[2]/2])
    translate([
        -(Slots_count[0] - 1) * Slots_spacing[0] / 2 - Slot_dimensions[0] / 2,
        -(Slots_count[1] - 1) * Slots_spacing[1] / 2 - Slot_dimensions[1] / 2])
    for (i=[0:Slots_count[0]-1])
    for (j=[0:Slots_count[1]-1])
        translate([i * Slots_spacing[0], j * Slots_spacing[1]])
        slot();
}

base();
color("pink") slots();
