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

var player_bullet := preload("res://Entities/Player/Weapons/Projectiles/Bullet.tscn");

onready var projectileDelayTimer := $ProjectileDelayTimer;
#onready var screenShake = get_node("/root/World/YSort/Player/RemoteTransform2D/Camera2D/ScreenShake")

func _ready():
	self.magazine_size = magazine_size;	
	self.ammo = ammo;
	
func _physics_process(delta):
	if magazine_size <= 0:
		if ammo > 0:
			if ammo >= max_magazine_size:
				magazine_size += max_magazine_size;
				ammo -= max_magazine_size;
	elif magazine_size >= 1 && Input.is_action_just_pressed("reload"):
		if ammo > 0:
			var remaing_magazine_size = max_magazine_size - magazine_size
			if ammo >= max_magazine_size || max_ammo > remaing_magazine_size:
				ammo -= remaing_magazine_size;
				magazine_size += remaing_magazine_size;
	elif ammo < 0:
		ammo = 0;

func shoot():
	if automatic == false:
		if Input.is_action_just_pressed("shoot"):
			bullet_spawn();
	elif automatic == true:
		if Input.is_action_pressed("shoot"):
			bullet_spawn();
			
func bullet_spawn():
	if magazine_size > 0:
		if projectileDelayTimer.is_stopped():
			projectileDelayTimer.start(projectileDelay);
			var bullet := player_bullet.instance();
			bullet.rotation = get_angle_to(get_global_mouse_position());
			bullet.position = global_position;
			bullet.damage = damage;
			get_tree().current_scene.add_child(bullet);
			self.magazine_size -= 1;
#			screenShake.start(0.05, 5, 10);


func set_max_ammo(value):
	max_ammo = value;
	self.ammo = min(ammo, max_ammo);
	
func set_ammo(value):
	ammo = value;
	
func set_max_magazine_size(value):
	max_magazine_size = value;
	
func set_magazine_size(value):
	magazine_size = value;
