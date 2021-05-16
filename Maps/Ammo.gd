extends KinematicBody2D

const ACCELERATION = 900;
const MAX_SPEED = 1000;
const FRICTION = 1.05;
export(bool) var ABSORBABLE;
export(bool) var FLOATING_TAB;

export(bool) var PISTOL9MM;
export(bool) var MP7

var velocity = Vector2.ZERO;
var being_picked_up = false;
var player;
var weapon;
var active_weapon = weapon;

onready var playerDetection = $PlayerDetection;
onready var tabFloatingButton = $Tab;

func _ready():
	selected_weapon();

func _physics_process(delta):
	if FLOATING_TAB == false: # Display floating tab image above item drop
		tabFloatingButton.visible = false;
	item_absorption(delta);
	velocity = move_and_slide(velocity / FRICTION);
	
func pick_up_item(body):
	player = body
	being_picked_up = true
	
func item_absorption(delta):
	selected_weapon();
	if weapon.ammo != weapon.max_ammo:
		if (playerDetection.can_see_player() && ABSORBABLE == true):
			player = playerDetection.player;
			move_towards_direction(delta)
		elif (being_picked_up == true && Input.is_action_pressed("pickup")):
			move_towards_direction(delta)
			ABSORBABLE = true;
		else:
			pass;
		
func move_towards_direction(delta):
	var direction = global_position.direction_to(player.global_position);
	var distance = global_position.distance_to(player.global_position);
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta);
	tabFloatingButton.visible = false;
	if distance < 10:
		ammo();
		queue_free();
		
func ammo():
	if weapon.ammo >= (weapon.max_ammo - weapon.max_magazine_size):
		weapon.ammo = weapon.max_ammo;
		weapon.ammo = weapon.ammo;
	else:
		weapon.ammo += weapon.max_magazine_size;
		weapon.ammo = weapon.ammo;
		
func selected_weapon():
	if PISTOL9MM == true:
		weapon = PlayerWeapons.get_node("Pistol9mm");
	if MP7 == true:
		weapon = PlayerWeapons.get_node("MP7");
