extends Spatial

var door_open_extent = Vector3(0, 0, 0.5) # how much each door retracts into the wall
var move_time = .1
var doorL_closed
var doorR_closed

export var textA = ""
export var textB = ""

func _ready():
	doorL_closed = $DoorL.translation
	doorR_closed = $DoorR.translation
	$TextA.text = textA
	$TextB.text = textB

func open_door(body):
	if body.name == "PlayerBody":
		$Tween.interpolate_property($DoorL, "translation", doorL_closed, doorL_closed + door_open_extent, move_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.interpolate_property($DoorR, "translation", doorR_closed, doorR_closed - door_open_extent, move_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.start()


func close_door(body):
	if body.name == "PlayerBody":
		$Tween.interpolate_property($DoorL, "translation", doorL_closed + door_open_extent, doorL_closed, move_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.interpolate_property($DoorR, "translation", doorR_closed - door_open_extent, doorR_closed, move_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.start()
