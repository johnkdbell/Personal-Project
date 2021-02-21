extends Control

var battery = 100 setget set_battery;
var max_battery = 100 setget set_max_battery;

func set_battery(value):
	battery = clamp(value, 0, max_battery);
	$Symbol.text = "||| "
	$Battery.text = String(battery);

func set_max_battery(value):
	max_battery = max(value, 1);
	self.battery = min(battery, max_battery);
	
func _ready():
	self.max_battery = PlayerStats.max_battery;
	self.battery = PlayerStats.battery;
	PlayerStats.connect("battery_changed", self, "set_battery");
	PlayerStats.connect("max_battery_changed", self, "set_max_battery");
	
