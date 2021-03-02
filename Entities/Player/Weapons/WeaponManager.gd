extends Node2D

var player_bullet := preload("res://Entities/Player/Weapons/Projectiles/Bullet.tscn");
onready var weapon = PlayerWeapons.get_node("Pistol9mm");
onready var active_weapon = $Pistol9mm;

func _ready():
	active_weapon.show()

func _physics_process(delta):
	if weapon.magazine_size <= 0:
		if weapon.ammo > 0:
			if weapon.ammo >= weapon.max_magazine_size:
				weapon.magazine_size += weapon.max_magazine_size;
				weapon.ammo -= weapon.magazine_size;
			elif weapon.max_magazine_size >= weapon.ammo:
				weapon.magazine_size += weapon.ammo;
				weapon.ammo = 0;
	elif weapon.magazine_size >= 1 && Input.is_action_just_pressed("reload"):
		reload();
	elif weapon.ammo < 0:
		weapon.ammo = 0;

func shoot():
	if weapon.automatic == false:
		if Input.is_action_just_pressed("shoot"):
			bullet_spawn();
	elif weapon.automatic == true:
		if Input.is_action_pressed("shoot"):
			bullet_spawn();
			
func bullet_spawn():
	if weapon.magazine_size > 0:
		if weapon.projectileDelayTimer.is_stopped():
			weapon.projectileDelayTimer.start(weapon.projectileDelay);
			var bullet := player_bullet.instance();
			bullet.dir = get_angle_to(get_global_mouse_position());
			bullet.rotation = get_angle_to(get_global_mouse_position());
			bullet.position = global_position;
			bullet.damage = weapon.damage;
			print(bullet.damage)
			get_tree().current_scene.add_child(bullet);
			weapon.magazine_size -= 1;
			
func input():
	if Input.is_action_just_released("mp7"):
		weapon("MP7", $MP7);
	elif Input.is_action_just_released("pistol9mm"):
		weapon("Pistol9mm", $Pistol9mm);		
	if Input.is_action_pressed("right_mouse_button"):
		if Input.is_action_pressed("left_mouse_button"):
			shoot();

func reload():
	print(weapon.name)
	if weapon.ammo >= 0:
		var remaing_magazine_size = weapon.max_magazine_size - weapon.magazine_size
		if weapon.ammo >= weapon.max_magazine_size || weapon.max_ammo > remaing_magazine_size:
			weapon.ammo -= remaing_magazine_size;
			weapon.magazine_size += remaing_magazine_size;

func weapon(weapon_name, weapon_node):
	active_weapon.hide();
	weapon = PlayerWeapons.get_node(weapon_name);
	active_weapon = weapon_node;
	active_weapon.show();
