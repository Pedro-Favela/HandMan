extends Node2D

@onready var AnimSoundTest: AnimationPlayer = $SoundTest/AnimationPlayer
@onready var SoundTest: AudioStreamPlayer = $SoundTest



func _ready() -> void:
	$VBoxContainer/Master.call_deferred("grab_focus")
	for slider in $VBoxContainer.get_children():
		if slider is HSlider:
			slider.connect("value_changed", SliderValueChanged.bind(slider.name))
			var BusIndex = AudioServer.get_bus_index(slider.name)
			slider.value = db_to_linear(AudioServer.get_bus_volume_db(BusIndex))
	$VBoxContainer/Button.connect("pressed", BackToMainMenu)

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if !event.is_pressed() or event.is_echo():
			return
		if event.keycode == KEY_ESCAPE:
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")
		
		

func SliderValueChanged(value: float, BusName: String):
	var BusIndex = AudioServer.get_bus_index(BusName)
	AudioServer.set_bus_volume_db(BusIndex,linear_to_db(value))
	SoundTest.bus = BusName
	match(BusName):
		"SoundFXs":
			AnimSoundTest.play("SoundFXTest")
		"Voice":
			AnimSoundTest.play("VoiceTest")
	
	
func BackToMainMenu():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
