///@desc Update frame
if mode == 0 then exit;
if frame < fc-1
	{
	frame++;
	update();
	alarm[0] = ceil(60/ff);
	}