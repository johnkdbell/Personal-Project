extends Node2D

var item_name
var item_quantity

func _ready():
	randomize();
	var rand_val = randi() % 3;
	if rand_val == 0:
		item_name = "Iron Sword"
	elif rand_val == 1:
		item_name = "Tree Branch"	
	else:
		item_name = "Slime Potion"
		
	$TextureRect.texture = load("res://UI/Inventory/Item Icons/" + item_name + ".png")
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	item_quantity = randi() % stack_size + 1;
	
	if stack_size == 1:
		$Label.visible = false;
	else:
		$Label.text = String(item_quantity);
		
func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add;
	$Label.text = String(item_quantity);
	
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove;
	$Label.text = String(item_quantity);
