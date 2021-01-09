extends Spatial

var press_position

signal pressed

var bred = load("res://worldassets/materials/ButtonRed.tres")
var bgreen = load("res://worldassets/materials/ButtonGreen.tres")

func _ready():
	press_position = $Press.translation

func _on_ButtonDetector_body_entered(body):
	if body.name == "Press":
		emit_signal("pressed")
		print("button pressed")
		
		$Press/CSGBox.material = bred
		$Press.linear_velocity = Vector3.ZERO
		$Press.sleeping = true
		
func reset():
	$Press.translation = press_position
	$Press.linear_velocity = Vector3.ZERO
	$Press/CSGBox.material = bgreen
