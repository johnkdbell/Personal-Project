extends Node

export(int) var max_health = 1 setget set_max_health;
export(int) var max_battery = 1 setget set_max_battery;
var health = max_health setget set_health;
var battery = max_battery setget set_battery;

signal no_health;
signal no_battery;
signal health_changed(value);
signal battery_changed(value);
signal max_health_changed(value)
signal max_battery_changed(value)

func set_max_health(value):
	max_health = value;
	self.health = min(health, max_health);
	emit_signal("max_health_changed", max_health);
	
func set_max_battery(value):
	max_battery = value;
	self.battery = min(battery, max_battery);
	emit_signal("max_battery_changed", max_battery);
	
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

func _ready():
	self.health = max_health;
	self.battery = 0;
	
func restart_health():
	if max_health > health:
			health = max_health
	if max_battery > battery:
			battery = max_battery
