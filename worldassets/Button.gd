extends Spatial

var press_position

signal pressed

var bred = load("res://worldassets/materials/ButtonRed.tres")
var bgreen = load("res://worldassets/materials/ButtonGreen.tres")

func _ready():
	press_position = $Button.translation
	
func reset():
	$Button.translation = press_position
	$Button.material = bgreen

func _on_PressArea_body_entered(body):
	if body.name == "HandL" or body.name == "HandR":
		emit_signal("pressed")
		$Button.material = bred
		$Button.translation = Vector3(0,0,0.01)
		# untested. Test it.
