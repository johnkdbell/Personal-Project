extends Node

export var projectileDelay: float = 0.1;
export var damage = 1;
export var automatic: bool;

export(int) var max_ammo = 1 setget set_max_ammo;
export(int) var ammo = 1 setget set_ammo;
export(int) var max_magazine_size = 1 setget set_max_magazine_size;
export(int) var magazine_size = 1 setget set_magazine_size;

signal no_ammo;
signal no_magazine_size;
signal ammo_changed(value);
signal magazine_size_changed(value);
signal max_ammo_changed(value)
signal max_magazine_size_changed(value)

onready var projectileDelayTimer := $ProjectileDelayTimer;
#onready var screenShake = get_node("/root/World/YSort/Player/RemoteTransform2D/Camera2D/ScreenShake")

func _ready():
	self.magazine_size = magazine_size;	
	self.ammo = ammo;
	print(self.name)
	
func set_max_ammo(value):
	max_ammo = value;
	self.ammo = min(ammo, max_ammo);
	emit_signal("max_ammo_changed", max_ammo);
	
func set_ammo(value):
	ammo = value;
	emit_signal("ammo_changed", ammo);
	
func set_max_magazine_size(value):
	max_magazine_size = value;
	self.magazine_size = min(magazine_size, max_magazine_size);
	emit_signal("max_magazine_size_changed", max_magazine_size);
	
func set_magazine_size(value):
	magazine_size = value;
	emit_signal("magazine_size_changed", magazine_size);
	
func restart_weapons():
	if max_ammo > ammo:
			ammo = max_ammo
	if max_magazine_size > magazine_size:
			magazine_size = max_magazine_size

