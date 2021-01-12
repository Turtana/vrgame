extends KinematicBody

var gravity = Vector3(0, -1, 0) * 10
var camera

var canFootSound = true

func _ready():
	$PlayerMeter.queue_free()
	camera = $ARVROrigin/Player_Camera

func _physics_process(_delta):
#	move_and_slide(gravity)
	# gravity disabled for now, as it causes problems with floor and there shouldn't be vertical movement. Subject to change.
	$CollisionShape.transform.origin.x = camera.transform.origin.x
	$CollisionShape.transform.origin.z = camera.transform.origin.z
	
	move_and_collide(Vector3.ZERO)
	# update collisions, since IRL movement doesn't update them. Otherwise the player can stick their head through walls and not set motion detectors.

func _process(_delta):
	if $ARVROrigin/ARVRControllerL.directional_movement and canFootSound:
		$CollisionShape/FootSound.play()
		canFootSound = false
		$FootTimer.start()

func _on_FootTimer_timeout():
	canFootSound = true

# footstep sound untested
