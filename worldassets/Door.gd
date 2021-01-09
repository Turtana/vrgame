extends Spatial

var door_open_extent = Vector3(0, 0, 0.5) # how much each door retracts into the wall
var move_time = .1
var doorL_closed
var doorR_closed

var closed = true

export var textA = ""
export var textB = ""

func _ready():
	doorL_closed = $DoorL.translation
	doorR_closed = $DoorR.translation
	$TextA.text = textA
	$TextB.text = textB
	
	$ButtonA.connect("pressed", self, "open_door")
	$ButtonB.connect("pressed", self, "open_door")

func open_door():
	if closed:
		$Tween.interpolate_property($DoorL, "translation", doorL_closed, doorL_closed + door_open_extent, move_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.interpolate_property($DoorR, "translation", doorR_closed, doorR_closed - door_open_extent, move_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.start()
		closed = false


func close_door(body):
	if body.name == "PlayerBody" and not closed:
		$Tween.interpolate_property($DoorL, "translation", doorL_closed + door_open_extent, doorL_closed, move_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.interpolate_property($DoorR, "translation", doorR_closed - door_open_extent, doorR_closed, move_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.start()
		$ButtonA.reset()
		$ButtonB.reset()
