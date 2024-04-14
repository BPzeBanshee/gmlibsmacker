// Basic variable init
#macro trace show_debug_message 
#macro msg show_message
mode = 0;
frame = 0;
timer = 0;
paused = false;
alarm_old = -1;

surf = -1;
s = -1;
bmp_buffer = -1;
snd_buffer = -1;

gmlibsmacker_init();

// Version string
msg("gmlibsmacker Version: "+gmlibsmacker_version());
	
prepare_video = function(){
// Track count
var c = gmlibsmacker_get_audio_track_count();
trace("number of channels: {0}",c);

var ac = gmlibsmacker_get_audio_channels(0);
var af = gmlibsmacker_get_audio_frequency(0);
var ab = gmlibsmacker_get_audio_bitdepth(0);
trace("track 0 info: {0} channels, {1} hz, bitdepth: {2}",ac,af,ab);

// Audio buffer
var a = gmlibsmacker_get_audio_size(0);
trace("gmlibsmacker_get_audio_size(0) returned {0}",a);

// memory needs to be pre-allocated first in GM-land
// before the DLL can manipulate it
snd_buffer = buffer_create(a,buffer_fast,1);
buffer_fill(snd_buffer,0,buffer_u8,0xFF,buffer_get_size(snd_buffer));

gmlibsmacker_load_audio(buffer_get_address(snd_buffer),a,0);
var cc = ac > 1 ? audio_stereo : audio_mono;
s = audio_create_buffer_sound(snd_buffer,buffer_u8,af,0,a,cc);

// Video buffer
ww = gmlibsmacker_get_video_width();
hh = gmlibsmacker_get_video_height();

// Y mode 0: plain, 1: interlaced (untested), 2: "double" (black padding line on even y values)
var yy = gmlibsmacker_get_video_y_mode();
trace("y mode: {0}",yy);
if yy > 0 then hh = hh*2;

ff = gmlibsmacker_get_video_frame_rate();
fc = gmlibsmacker_get_video_frame_count();
trace("{0}x{1}, {2} FPS, {3} frames",ww,hh,ff,fc);

// video buffer needs to be width * height * 4 in size for RGBA frames
// and needs to be prefilled GM-side so that the memory is allocated
bmp_buffer = buffer_create(ww*hh*4,buffer_fast,1);
buffer_fill(bmp_buffer,0,buffer_u8,0xFF,buffer_get_size(bmp_buffer));

window_set_size(ww,hh);
camera_set_view_size(view_camera[0],ww,hh);
}

update = function(){
gmlibsmacker_load_bitmap(buffer_get_address(bmp_buffer),frame);

// update surface
if !surface_exists(surf)
	{
	surf = surface_create(ww,hh);
	surface_set_target(surf);
	draw_clear_alpha(c_black,1);
	surface_reset_target();
	}
else
	{
	surface_resize(surf,ww,hh);
	surface_set_target(surf);
	draw_clear_alpha(c_black,1);
	surface_reset_target();
	}
buffer_set_surface(bmp_buffer,surf,0);
}

unload = function(){
if audio_exists(s) then audio_free_buffer_sound(s);
	
if surface_exists(surf) then surface_free(surf);
buffer_delete(bmp_buffer);
buffer_delete(snd_buffer);

gmlibsmacker_close_smk();
timer = 0;
frame = 0;

window_set_size(640,480);
camera_set_view_size(view_camera[0],640,480);
}