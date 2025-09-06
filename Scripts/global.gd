extends Node2D

const SAVE_PATH = "user://save.json"

func _ready() -> void:
	get_viewport().connect("gui_focus_changed",FocusChanged)

func FocusChanged(node: Control):
	$SoundFX.play()

func SaveGame(MaxScore: int):
	
	var SaveData = {
		"MaxScore": MaxScore,
	}
	
	var file = FileAccess.open_encrypted_with_pass(SAVE_PATH, FileAccess.WRITE, "PURGATÓRIO")
	if file == null:
		print("Error opening file: ", FileAccess.get_open_error())
		return
	var json_string = JSON.stringify(SaveData, "\t")
	file.store_string(json_string)
	file.close()

func LoadGame():
	if !FileAccess.file_exists(SAVE_PATH):
		return null
	var file = FileAccess.open_encrypted_with_pass(SAVE_PATH, FileAccess.READ, "PURGATÓRIO")
	var Content = file.get_as_text()
	file.close()
	
	var ParsedContent = JSON.parse_string(Content)
	if ParsedContent == null:
		print("Error parsing JSON: ", ParsedContent.get_error_message(), " at line ", ParsedContent.get_error_line())
		return null
	return ParsedContent
