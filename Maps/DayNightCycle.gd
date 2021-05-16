extends CanvasModulate

var timer;
var minute = 0;
var hour = 0;
var day = 0;
var smooth_hour = 3;

func _process(_delta):
	
	if minute > 59:
		hour += 1;
		minute = 0;

	if minute > 59:
		hour += 1;
		minute = 0;
		
	if hour >= 24:
		day += 1;
		hour = 0;
		
	if smooth_hour >= 24:
		smooth_hour = 0;
		
	$Time.text = "Day: " + String(day) + "/Hour: " + String(hour) + "/Minute: " + String(round(minute)) + "/SH: " + String(smooth_hour)

	var curretFrame = range_lerp(smooth_hour,0,24,0,24)
	$AnimationPlayer.play("Day_Night_Cycle")
	$AnimationPlayer.seek(curretFrame)

func _on_SmoothHour_timeout():
		minute += 1
		smooth_hour += 0.016666667;
