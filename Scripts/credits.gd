extends Node2D

func _ready() -> void:
	$LinkedIn.call_deferred("grab_focus")
	for btn in get_children():
		if btn is Button:
			btn.connect("pressed", BtnPressed.bind(btn.name))

func BtnPressed(btn_name: String):
	match(btn_name):
		"LinkedIn":
			OS.shell_open("https://linkedin.com/in/pedro-henrique-pereira-favela")
		"Github":
			OS.shell_open("https://github.com/Pedro-Favela")
		"Back":
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _process(delta: float) -> void:
	pass
