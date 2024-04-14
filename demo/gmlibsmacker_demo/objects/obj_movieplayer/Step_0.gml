var full = window_get_fullscreen();
if keyboard_check_pressed(vk_f4) then window_set_fullscreen(!full);

switch mode
	{
	case 0:
		{
		window_set_caption("gmlibsmacker demo: press 1 to load file");
		if keyboard_check_pressed(ord("1"))
			{
			if full then window_set_fullscreen(!full);
			var d = get_open_filename_ext("SMK|*.smk|ZRB|*.zrb","",program_directory,"Open Smacker Movie File");
			if full then window_set_fullscreen(full);
			
			if d != ""
				{
				// Open SMK file
				var o = gmlibsmacker_open_smk(d);
				if o < 0
					{
					msg(string("problem loading {0}",d));
					}
				else
					{
					window_set_caption("gmlibsmacker demo: "+filename_name(d));
					mode = 1;
					}
				}
			}
		break;
		}
	case 1:
		{
		prepare_video();
		update();
		if audio_exists(s)
			{
			audio_play_sound(s,0,false);
			timer = 0;
			alarm[0] = ceil(60/ff);
			mode++;
			}
		else 
			{
			msg(string("problem loading audio for movie"));
			mode = 0;
			}
		break;
		}
	case 2:
		{
		if keyboard_check_pressed(vk_space)
			{
			paused = !paused;
			
			if paused
				{
				audio_pause_sound(s);
				alarm_old = alarm[0];
				alarm[0] = -1;
				}
			else
				{
				audio_resume_sound(s);
				alarm[0] = alarm_old;
				alarm_old = -1;
				}
			}
		if !paused then timer += 1;
		if timer >= (audio_sound_length(s)*60) 
		or keyboard_check_pressed(vk_escape)//or (keyboard_check_pressed(vk_anykey) && !keyboard_check(vk_f4))
			{
			audio_stop_sound(s);
			unload();
			mode = 0;
			}
		break;
		}
	}