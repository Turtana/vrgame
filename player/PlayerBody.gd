extends KinematicBody

var gravity = Vector3(0, -1, 0) * 10
var camera

func _ready():
	$PlayerMeter.queue_free()
	camera = $ARVROrigin/Player_Camera

func _physics_process(_delta):
#	move_and_slide(gravity)
	# gravity disabled for now, as it causes problems with floor and there shouldn't be vertical movement. Subject to change.
	$CollisionShape.global_transform.origin.x = camera.global_transform.origin.x
	$CollisionShape.global_transform.origin.z = camera.global_transform.origin.z
	
	move_and_collide(Vector3.ZERO)
	# update collisions, since IRL movement doesn't update them. Otherwise the player can stick their head through walls and not set motion detectors.
