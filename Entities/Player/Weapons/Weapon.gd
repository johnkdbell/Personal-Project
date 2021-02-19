extends Node2D

export var projectileDelay: float = 0.1;
export var damage = 1;
export var automatic: bool;
export(int) var max_ammo = 1 setget set_max_ammo;

var ammo = max_ammo setget set_ammo;
var player_bullet := preload("res://Entities/Player/Weapons/Projectiles/Bullet.tscn");

onready var projectileDelayTimer := $ProjectileDelayTimer;

func _ready():
	self.ammo = max_ammo;

func shoot():
	if automatic == false:
		if Input.is_action_just_pressed("shoot"):
			bullet_spawn();
	elif automatic == true:
		if Input.is_action_pressed("shoot"):
			bullet_spawn();
			
func bullet_spawn():
	if ammo > 0:
		if projectileDelayTimer.is_stopped():
			projectileDelayTimer.start(projectileDelay);
			var bullet := player_bullet.instance();
			bullet.rotation = get_angle_to(get_global_mouse_position());
			bullet.position = global_position;
			bullet.damage = damage;
			get_tree().current_scene.add_child(bullet);
			self.ammo -= 1;

func set_max_ammo(value):
	max_ammo = value;
	self.ammo = min(ammo, max_ammo);
	
func set_ammo(value):
	ammo = value;

#func _ready():
#	self.ammo = max_ammo;
