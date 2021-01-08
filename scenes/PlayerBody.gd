extends KinematicBody

var gravity = Vector3(0, -1, 0) * 10

func _ready():
	$PlayerMeter.queue_free()

func _physics_process(_delta):
#	move_and_slide(gravity)
	# gravity disabled for now, as it causes problems with floor and there shouldn't be vertical movement. Subject to change.
	$CollisionShape.global_transform.origin.x = $ARVROrigin/Player_Camera.global_transform.origin.x
	$CollisionShape.global_transform.origin.z = $ARVROrigin/Player_Camera.global_transform.origin.z
	
	move_and_collide(Vector3.ZERO)
	# update collisions, since IRL movement doesn't update them. Otherwise the player can stick their head through walls and not set motion detectors.
