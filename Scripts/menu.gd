extends Node2D

func _ready() -> void:
	for btn in $Buttons.get_children():
		btn.connect("pressed", btn_pressed.bind(btn.name.to_upper()))
	$Buttons.get_child(0).call_deferred("grab_focus")

func btn_pressed(btn_name:String) -> void:
	match(btn_name):
		"PLAY":
			get_tree().change_scene_to_file("res://Scenes/main.tscn")
		"OPTIONS":
			get_tree().change_scene_to_file("res://Scenes/options.tscn")
		"CREDITS":
			get_tree().change_scene_to_file("res://Scenes/credits.tscn")
		"QUIT":
			get_tree().quit()
		_:
			print(btn_name)
