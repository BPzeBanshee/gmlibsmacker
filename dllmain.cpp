// dllmain.cpp : Defines the entry point for the DLL application.
#pragma once

#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows headers
// Windows Header Files
#include <windows.h>
#include <stdlib.h>
#include "libsmacker/smacker.h"
#define GMEXPORT extern "C"  __declspec (dllexport)
smk s = NULL;
static bool bool_use_bgra = false;

GMEXPORT const char* get_version() {
	return "v1.0";
}

// ========= FILE I/O FUNCTIONS ===========

int file_open(char* file) {
	s = smk_open_file(file, SMK_MODE_MEMORY);
	if (s == NULL) return -1;
	return 0;
}
int file_close() {
	smk_close(s);
	return 0;
}

GMEXPORT double open_smk(char* file) {
	if (s != NULL) return -1;
	int e = file_open(file);
	return e;
}

GMEXPORT double close_smk() {
	if (s == NULL) return -1;
	file_close();
	s = NULL;
	return 0;
}

GMEXPORT double use_bgra(double value) {
	if (value > 0) {
		bool_use_bgra = true;
	}
	else {
		bool_use_bgra = false;
	}
	return (double)bool_use_bgra;
}

// ========== VIDEO FUNCTIONS ============

GMEXPORT double get_video_width() {
	if (s == NULL) return -1;
	unsigned long w;
	smk_info_video(s, &w, NULL, NULL);
	return w;
}

GMEXPORT double get_video_height() {
	if (s == NULL) return -1;
	unsigned long h;
	smk_info_video(s, NULL, &h, NULL);
	return h;
}

GMEXPORT double get_video_y_mode() {
	if (s == NULL) return -1;
	unsigned char y;
	smk_info_video(s, NULL, NULL, &y);
	return (int)y;
}

GMEXPORT double get_video_frame_count() {
	if (s == NULL) return -1;
	unsigned long f;
	smk_info_all(s, NULL, &f, NULL);
	return f;
}

GMEXPORT double get_video_frame_rate() {
	if (s == NULL) return -1;
	double 	usf;
	smk_info_all(s, NULL, NULL, &usf);
	return 1000000.0 / usf;
}

// =========== AUDIO FUNCTIONS ==============

GMEXPORT double get_audio_channels(double track) {
	if (s == NULL) return -1;

	unsigned char a_t, a_c[7];
	smk_info_audio(s, &a_t, a_c, NULL, NULL);

	return a_c[(int) track];
}

GMEXPORT double get_audio_track_count() {
	if (s == NULL) return -1;

	double num = 0;
	for (int i = 0; i < 7; i++) {
		if (get_audio_channels(i) > 0) num++;
	}

	return num;
}

GMEXPORT double get_audio_bitdepth(double track) {
	if (s == NULL) return -1;

	unsigned char a_t, a_d[7];
	smk_info_audio(s, &a_t, NULL, a_d, NULL);

	return a_d[(int) track];
}

GMEXPORT double get_audio_frequency(double track) {
	if (s == NULL) return -1;

	unsigned char a_t;
	unsigned long a_r[7];
	smk_info_audio(s, &a_t, NULL, NULL, a_r);

	return a_r[(int) track];
}

GMEXPORT double get_audio_size(double track) {
	if (s == NULL) return -1;

	unsigned long size = 0;
	unsigned char	a_t, a_c[7], a_d[7];
	unsigned long	a_r[7];
	smk_info_audio(s, &a_t, a_c, a_d, a_r);
	smk_enable_video(s, 0);
	if (a_t & (1 << (int)track)) {
		smk_enable_audio(s, track, 1);
	}

	//Get a pointer to first frame
	smk_first(s);
	unsigned long cur_frame = 0;
	unsigned long end_frame = 0;
	smk_info_all(s, &cur_frame, &end_frame, NULL);
	size += smk_get_audio_size(s, track);
	
	// add consecutive frame info
	for (cur_frame = 1; cur_frame < end_frame; cur_frame++) {
		smk_next(s);
		size += smk_get_audio_size(s, track);
	}

	return (double)size;
}

// ============== ACTUAL RENDER FUNCTIONS ==================

GMEXPORT double load_audio(char* audio_buffer, double size, double track) {
	if (s == NULL) return -1;

	unsigned char	a_t, a_c[7], a_d[7];
	unsigned long	a_r[7];
	smk_info_audio(s, &a_t, a_c, a_d, a_r);
	smk_enable_video(s, 0);

	// Turn on decoding for audio track 0
	if (a_t & (1 << (int)track)) {
		smk_enable_audio(s, track, 1);
	}

	// Get a pointer to first frame
	smk_first(s);
	unsigned long cur_frame = 0;
	unsigned long end_frame = 0;
	smk_info_all(s, &cur_frame, &end_frame, NULL);

	// get first data
	const unsigned char* snd = smk_get_audio(s, track);
	int pos = 0;
	for (int i = 0; i < smk_get_audio_size(s, track); i++) {
		if (pos < size) {
			audio_buffer[i] = snd[i];
			pos++;
		}
	}
	
	// get consecutive data
	for (cur_frame = 1; cur_frame < end_frame; cur_frame++) {
		smk_next(s);
		snd = smk_get_audio(s, track);
		int ii = pos;
		for (int i = 0; i < smk_get_audio_size(s, track); i++) {
			if (pos < size) {
				audio_buffer[ii+i] = snd[i];
				pos++;
			}
		}
	}
	return 0;
}

GMEXPORT double load_bitmap(char* bmp_buffer, double frame) {
	if (s == NULL) return -1;

	// Turn on decoding for palette, video, and audio track 0
	smk_enable_video(s, 1);
	
	unsigned long c_frame = frame;
	smk_seek_keyframe(s, c_frame); // BUG: this keeps going back to frame 0 in unaltered libsmacker, use fork
	smk_info_all(s, &c_frame, NULL, NULL);
	unsigned long	w, h;
	unsigned char mode;
	smk_info_video(s, &w, &h, &mode);
	const unsigned char* pal = smk_get_palette(s);
	const unsigned char* vid = smk_get_video(s);

	int i = 0;
	switch (mode) {
		// SimTunes is as ordinary as it gets, y scale mode 0
		case SMK_FLAG_Y_NONE: {
			if (bool_use_bgra){
				for (int yy = 0; yy < h; yy++) {
					for (int xx = 0; xx < w; xx++) {
						bmp_buffer[i] = pal[vid[(yy * w) + xx] * 3 + 2]; i++;
						bmp_buffer[i] = pal[vid[(yy * w) + xx] * 3 + 1]; i++;
						bmp_buffer[i] = pal[vid[(yy * w) + xx] * 3]; i++;
						bmp_buffer[i] = 255; i++;
					}
				}
			}
			else {
				for (int yy = 0; yy < h; yy++) {
					for (int xx = 0; xx < w; xx++) {
						bmp_buffer[i] = pal[vid[(yy * w) + xx] * 3]; i++;
						bmp_buffer[i] = pal[vid[(yy * w) + xx] * 3 + 1]; i++;
						bmp_buffer[i] = pal[vid[(yy * w) + xx] * 3 + 2]; i++;
						bmp_buffer[i] = 255; i++;
					}
				}
			}
			break;
		}

		// TODO: Total Annihilation uses double-line video, the libsmacker #defines say it's mode 2, 
		// but comments in smacker.c say it's mode 1, so without actually knowing any examples of 
		// actual interlaced Smacker videos let's assume either of those values are double.
		case SMK_FLAG_Y_INTERLACE:
		case SMK_FLAG_Y_DOUBLE: {
			bool interlace = false;
			int y2 = 0;

			if (bool_use_bgra) {
				for (int yy = 0; yy < h * 2; yy++) {
					if (!interlace) {
						for (int xx = 0; xx < w; xx++) {
							bmp_buffer[i] = pal[vid[(y2 * w) + xx] * 3 + 2]; i++;
							bmp_buffer[i] = pal[vid[(y2 * w) + xx] * 3 + 1]; i++;
							bmp_buffer[i] = pal[vid[(y2 * w) + xx] * 3]; i++;
							bmp_buffer[i] = 255; i++;
						}
						y2++;
					}
					else {
						for (int xx = 0; xx < w; xx++) {
							bmp_buffer[i] = 0; i++;
							bmp_buffer[i] = 0; i++;
							bmp_buffer[i] = 0; i++;
							bmp_buffer[i] = 255; i++;
						}
					}
					interlace = !interlace;
				}
			}
			else {
				for (int yy = 0; yy < h * 2; yy++) {
					if (!interlace) {
						for (int xx = 0; xx < w; xx++) {
							bmp_buffer[i] = pal[vid[(y2 * w) + xx] * 3]; i++;
							bmp_buffer[i] = pal[vid[(y2 * w) + xx] * 3 + 1]; i++;
							bmp_buffer[i] = pal[vid[(y2 * w) + xx] * 3 + 2]; i++;
							bmp_buffer[i] = 255; i++;
						}
						y2++;
					}
					else {
						for (int xx = 0; xx < w; xx++) {
							bmp_buffer[i] = 0; i++;
							bmp_buffer[i] = 0; i++;
							bmp_buffer[i] = 0; i++;
							bmp_buffer[i] = 255; i++;
						}
					}
					interlace = !interlace;
				}
			}
			break;
		}
	}

	return 0;
}

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
                     )
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
        break;
    }
    return TRUE;
}

