extends Node2D

const SAVE_PATH:String = "user://save.json"
var HighScoreTable: Array = [
	{
		"name": "DEUS",
		"score": 666
	}
]:
	set(new_value):
		HighScoreTable = new_value
		HighScoreTable.sort_custom(func(a,b): return a["score"]>b["score"])
		if HighScoreTable.size() > 20:
			HighScoreTable.pop_back()

func _ready() -> void:
	get_viewport().connect("gui_focus_changed",FocusChanged)
	if LoadGame():
		HighScoreTable = LoadGame()
	

func FocusChanged(_node: Control):
	$SoundFX.play()

func SaveGame():
	var file = FileAccess.open_encrypted_with_pass(SAVE_PATH, FileAccess.WRITE, "PURGATÓRIO")
	if file == null:
		print("Error opening file: ", FileAccess.get_open_error())
		return
	var json_string = JSON.stringify(HighScoreTable, "\t")
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
