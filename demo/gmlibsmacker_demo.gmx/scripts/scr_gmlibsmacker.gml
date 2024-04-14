#define scr_gmlibsmacker

#define gmlibsmacker_init
var dll = "gmlibsmacker32.dll";
var call = dll_cdecl;
global.dll_gmlibsmacker_version = external_define(dll,"get_version",call,ty_string,0);
global.dll_gmlibsmacker_open_smk = external_define(dll,"open_smk",call,ty_real,1,ty_string);
global.dll_gmlibsmacker_close_smk = external_define(dll,"close_smk",call,ty_real,0);
global.dll_gmlibsmacker_set_bgra = external_define(dll,"use_bgra",call,ty_real,1,ty_real);

global.dll_gmlibsmacker_get_audio_track_count = external_define(dll,"get_audio_track_count",call,ty_real,0);
global.dll_gmlibsmacker_get_audio_channels = external_define(dll,"get_audio_channels",call,ty_real,1,ty_real);
global.dll_gmlibsmacker_get_audio_bitdepth = external_define(dll,"get_audio_bitdepth",call,ty_real,1,ty_real);
global.dll_gmlibsmacker_get_audio_frequency = external_define(dll,"get_audio_frequency",call,ty_real,1,ty_real);
global.dll_gmlibsmacker_get_audio_size = external_define(dll,"get_audio_size",call,ty_real,1,ty_real);

global.dll_gmlibsmacker_get_video_width = external_define(dll,"get_video_width",call,ty_real,0);
global.dll_gmlibsmacker_get_video_height = external_define(dll,"get_video_height",call,ty_real,0);
global.dll_gmlibsmacker_get_video_y_mode = external_define(dll,"get_video_y_mode",call,ty_real,0);
global.dll_gmlibsmacker_get_video_frame_count = external_define(dll,"get_video_frame_count",call,ty_real,0);
global.dll_gmlibsmacker_get_video_frame_rate = external_define(dll,"get_video_frame_rate",call,ty_real,0);

global.dll_gmlibsmacker_load_bitmap = external_define(dll,"load_bitmap",call,ty_real,2,ty_string,ty_real);
global.dll_gmlibsmacker_load_audio = external_define(dll,"load_audio",call,ty_real,3,ty_string,ty_real,ty_real);

#define gmlibsmacker_free
external_free("gmlibsmacker32.dll");
global.dll_gmlibsmacker_version = -1;
global.dll_gmlibsmacker_open_smk = -1;
global.dll_gmlibsmacker_close_smk = -1;

global.dll_gmlibsmacker_get_audio_track_count = -1;
global.dll_gmlibsmacker_get_audio_channels = -1;
global.dll_gmlibsmacker_get_audio_bitdepth = -1;
global.dll_gmlibsmacker_get_audio_frequency = -1;
global.dll_gmlibsmacker_get_audio_size = -1;

global.dll_gmlibsmacker_get_video_width = -1;
global.dll_gmlibsmacker_get_video_height = -1;
global.dll_gmlibsmacker_get_video_y_mode = -1;
global.dll_gmlibsmacker_get_video_frame_count = -1;
global.dll_gmlibsmacker_get_video_frame_rate = -1;

global.dll_gmlibsmacker_load_bitmap = -1;
global.dll_gmlibsmacker_load_audio = -1;
return 0;

#define gmlibsmacker_version
var e = external_call(global.dll_gmlibsmacker_version);
return e;

#define gmlibsmacker_open_smk
var e = external_call(global.dll_gmlibsmacker_open_smk,argument0);
return e;

#define gmlibsmacker_close_smk
var e = external_call(global.dll_gmlibsmacker_close_smk);
return e;

#define gmlibsmacker_get_audio_track_count
var e = external_call(global.dll_gmlibsmacker_get_audio_track_count);
return e;

#define gmlibsmacker_get_audio_channels
var e = external_call(global.dll_gmlibsmacker_get_audio_channels,argument0);
return e;

#define gmlibsmacker_get_audio_bitdepth
var e = external_call(global.dll_gmlibsmacker_get_audio_bitdepth,argument0);
return e;

#define gmlibsmacker_get_audio_frequency
var e = external_call(global.dll_gmlibsmacker_get_audio_frequency,argument0);
return e;

#define gmlibsmacker_get_audio_size
var e = external_call(global.dll_gmlibsmacker_get_audio_size,argument0);
return e;

#define gmlibsmacker_get_video_width
var e = external_call(global.dll_gmlibsmacker_get_video_width);
return e;

#define gmlibsmacker_get_video_height
var e = external_call(global.dll_gmlibsmacker_get_video_height);
return e;

#define gmlibsmacker_get_video_y_mode
var e = external_call(global.dll_gmlibsmacker_get_video_y_mode);
return e;

#define gmlibsmacker_get_video_frame_count
var e = external_call(global.dll_gmlibsmacker_get_video_frame_count);
return e;

#define gmlibsmacker_get_video_frame_rate
var e = external_call(global.dll_gmlibsmacker_get_video_frame_rate);
return e;

#define gmlibsmacker_load_audio
var e = external_call(global.dll_gmlibsmacker_load_audio,argument0,argument1,argument2);
return e;

#define gmlibsmacker_load_bitmap
var e = external_call(global.dll_gmlibsmacker_load_bitmap,argument0,argument1);
return e;
#define gmlibsmacker_set_bgra
var e = external_call(global.dll_gmlibsmacker_set_bgra,argument0);
return e;