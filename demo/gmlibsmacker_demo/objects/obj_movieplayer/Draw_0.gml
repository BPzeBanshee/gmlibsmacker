draw_set_alpha(1);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);

var xx = camera_get_view_width(view_camera[0])/2;
var yy = camera_get_view_height(view_camera[0])/2;
switch mode
	{
	case 0: draw_text(xx,yy,"1 TO LOAD VIDEO"); break;
	case 2: 
	if surface_exists(surf) then draw_surface(surf,0,0); 
	if paused then draw_text(xx,yy,"PAUSED");
	break;
	}