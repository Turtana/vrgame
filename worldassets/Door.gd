extends Spatial

var door_open_extent = Vector3(0, 0, 0.5) # how much each door retracts into the wall
var move_time = .3
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
		$Hiss.play()
		$Thud.play()
		$Tween.interpolate_property($DoorL, "translation", doorL_closed, doorL_closed + door_open_extent, move_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.interpolate_property($DoorR, "translation", doorR_closed, doorR_closed - door_open_extent, move_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.start()
		closed = false


func close_door(body):
	if body.name == "PlayerBody" and not closed:
		$Hiss.play()
		# wait for a while
		yield(get_tree().create_timer(0.4), "timeout")
		
		# door start closing, buttons reset
		$Tween.interpolate_property($DoorL, "translation", doorL_closed + door_open_extent, doorL_closed, move_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.interpolate_property($DoorR, "translation", doorR_closed - door_open_extent, doorR_closed, move_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.start()
		$ButtonA.reset()
		$ButtonB.reset()
		
		# play "thud" and reset buttons as the doors close
		yield(get_tree().create_timer(move_time-0.1), "timeout")
		$Thud.play()
		closed = true
