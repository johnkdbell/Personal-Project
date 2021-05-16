extends Control

var flashlight = 100 setget set_flashlight;
var max_flashlight = 100 setget set_max_flashlight;
var flashlight_active = true;

onready var heartUIFull = $HeartUIFull;
onready var heartUIEmpty = $HeartUIEmpty;

func _process(_delta):
	input();

func set_flashlight(value):
	flashlight = clamp(value, 0, max_flashlight);
#	$Symbol.text = "^ ";	
#	$Flashlight.text = String(round(flashlight));
	if heartUIFull != null:
		heartUIFull.rect_size.x = (flashlight / 7.99) * 4;

func set_max_flashlight(value):
	max_flashlight = max(value, 1);
	self.flashlight = min(flashlight, max_flashlight);
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = (max_flashlight / 7.99) * 4;

func _ready():
	self.hide();
	self.max_flashlight = PlayerStats.max_flashlight;
	self.flashlight = PlayerStats.flashlight;
	PlayerStats.connect("flashlight_changed", self, "set_flashlight");
	PlayerStats.connect("max_flashlight_changed", self, "set_max_flashlight");

func input():
	if Input.is_action_just_pressed("flashlight") && flashlight_active == false || PlayerStats.flashlight >= 100:
		self.hide();
		flashlight_active = true;
	elif Input.is_action_just_pressed("flashlight") && flashlight_active == true || PlayerStats.flashlight <= 100:
		flashlight_active = false
		self.show();

