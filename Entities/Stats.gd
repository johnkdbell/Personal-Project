extends Node

export(int) var max_health = 1 setget set_max_health;
export(int) var max_battery = 1 setget set_max_battery;
export(int) var max_flashlight = 1 setget set_max_flashlight;
var health = max_health setget set_health;
var battery = max_battery setget set_battery;
var flashlight = max_flashlight setget set_flashlight;

signal no_health;
signal no_battery;
signal no_flashlight;
signal health_changed(value);
signal battery_changed(value);
signal flashlight_changed(value);
signal max_health_changed(value);
signal max_battery_changed(value);
signal max_flashlight_changed(value);

func set_max_health(value):
	max_health = value;
	self.health = min(health, max_health);
	emit_signal("max_health_changed", max_health);
	
func set_max_battery(value):
	max_battery = value;
	self.battery = min(battery, max_battery);
	emit_signal("max_battery_changed", max_battery);
	
func set_max_flashlight(value):
	max_flashlight = value;
	self.flashlight = min(flashlight, max_flashlight);
	emit_signal("max_flashlight_changed", max_flashlight);
	
func set_health(value):
	health = value;
	emit_signal("health_changed", health);
	if health <= 0:
		emit_signal("no_health");
		
func set_battery(value):
	battery = value;
	emit_signal("battery_changed", battery);
	if battery <= 0:
		emit_signal("no_battery");
		
func set_flashlight(value):
	flashlight = value;
	emit_signal("flashlight_changed", flashlight);
	if flashlight <= 0:
		emit_signal("no_flashlight");

func _ready():
	self.health = max_health;
	self.battery = 0;
	self.flashlight = max_flashlight;
	
func restart_health():
	if max_health > health:
			health = max_health;
	if max_battery > battery:
			battery = 0;
	if max_flashlight > flashlight:
			flashlight = max_flashlight;
