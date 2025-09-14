extends Control

@onready var v_box: VBoxContainer = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer
@onready var v_box2: VBoxContainer = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer2

@onready var button: Button = $CenterContainer/VBoxContainer/Button


func _ready() -> void:
	button.connect("pressed", btn_pressed)
	$CenterContainer/VBoxContainer/Button.call_deferred("grab_focus")

	for score in range(Global.HighScoreTable.size()):
		if v_box.get_child(score):
			v_box.get_child(score).text = "[color=#fff]"+str(score+1)+"[/color] "+Global.HighScoreTable[score].name + " [color=#4d2f00]..........................[/color]  " + str(Global.HighScoreTable[score].score)
		else:
			v_box2.get_child(score-10).text = Global.HighScoreTable[score].name + " [color=#4d2f00]..........................[/color] " + str(Global.HighScoreTable[score].score)
func btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
