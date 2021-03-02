extends Control

var ammo = 100 setget set_ammo;
var magazine_size = 100 setget set_magazine_size;
var max_ammo = 100 setget set_max_ammo;
var max_magazine_size = 100 setget set_max_magazine_size;
var ammo_appearance = "p";

var weapon_active = "Pistol9mm";

func _ready():
	connect_weapon(weapon_active)
	set_active_ammo(weapon_active)

func _process(delta):
	if Input.is_action_just_pressed("pistol9mm"):
		set_weapon("Pistol9mm", "p")
	elif Input.is_action_just_pressed("mp7"):
		set_weapon("MP7", "q")
		

func set_ammo(value):
	ammo = clamp(value, 0, max_ammo);
	$Ammo.text = String(ammo);

func set_max_ammo(value):
	max_ammo = max(value, 1);
	self.ammo = min(ammo, max_ammo);
	
func set_magazine_size(value):
	magazine_size = clamp(value, 0, max_magazine_size);
	$MagazineSize.text = String(magazine_size);

func set_max_magazine_size(value):
	max_magazine_size = max(value, 1);
	self.magazine_size = min(magazine_size, max_magazine_size);

func connect_weapon(weapon_active):
	PlayerWeapons.get_node(weapon_active).connect("ammo_changed", self, "set_ammo");
	PlayerWeapons.get_node(weapon_active).connect("max_ammo_changed", self, "set_max_ammo");
	PlayerWeapons.get_node(weapon_active).connect("magazine_size_changed", self, "set_magazine_size");
	PlayerWeapons.get_node(weapon_active).connect("max_magazine_size_changed", self, "set_max_magazine_size");

func disconnect_weapon(weapon_active):
	PlayerWeapons.get_node(weapon_active).disconnect("ammo_changed", self, "set_ammo");
	PlayerWeapons.get_node(weapon_active).disconnect("max_ammo_changed", self, "set_max_ammo");
	PlayerWeapons.get_node(weapon_active).disconnect("magazine_size_changed", self, "set_magazine_size");
	PlayerWeapons.get_node(weapon_active).disconnect("max_magazine_size_changed", self, "set_max_magazine_size");
	
func set_active_ammo(weapon_active):
	self.max_ammo = PlayerWeapons.get_node(weapon_active).max_ammo;
	self.ammo = PlayerWeapons.get_node(weapon_active).ammo
	self.max_magazine_size = PlayerWeapons.get_node(weapon_active).max_magazine_size;
	self.magazine_size = PlayerWeapons.get_node(weapon_active).magazine_size

func set_weapon(weapon_active, ammo_appearance):
	$AmmoImage.text = ammo_appearance;
	disconnect_weapon(weapon_active)
	set_active_ammo(weapon_active)
	connect_weapon(weapon_active)
	
	
