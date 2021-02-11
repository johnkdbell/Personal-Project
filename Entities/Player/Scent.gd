extends Node2D

var player;

func _ready():
	$Timer.connect("timeout", self, "remove_scent")

func remove_scent():
	if player:
		player.scent_trail.erase(self)
		queue_free();

