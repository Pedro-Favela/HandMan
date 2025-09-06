extends Sprite2D

var ShakeStrength: float = 0.0
var Fear:int = 0:
	set(new_value):
		if new_value <= 0:
			Fear = 0
		else:
			Fear = new_value
		
		ShakeStrength = Fear * 0.1


func _process(delta: float) -> void:
	shake()



func shake():
	var RandomOffset = Vector2(randf_range(-ShakeStrength,ShakeStrength),randf_range(-ShakeStrength,ShakeStrength))
	offset = RandomOffset
