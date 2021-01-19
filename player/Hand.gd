extends KinematicBody

var held = null
var held_offset = Vector3(0,0,0)

func _ready():
	get_node("SleepArea").connect("body_entered", self, "sleep_area_entered")
	get_node("SleepArea").connect("body_exited", self, "sleep_area_exited")
	
	if name[-1] == "L":
		# Mirror hand
		$HandOpen.scale.y = -0.5
		$HandGrip.scale.y = -0.5
		$GrabArea.translation.x = 0.05

func _physics_process(_delta):
	if held:
		held.global_transform.origin = $GrabArea.global_transform.origin + held_offset
		$HeldObjectCollision.global_transform.origin = $GrabArea.global_transform.origin + held_offset

func sleep_area_entered(body):
	if "can_sleep" in body:
		body.can_sleep = false
		body.sleeping = false

func sleep_area_exited(body):
	if "can_sleep" in body:
		body.can_sleep = true

func grip():
	$HandOpen.visible = false
	$HandGrip.visible = true
	
	if held == null:
		var bodies = $GrabArea.get_overlapping_bodies()
		for body in bodies:
			# take one randomly, if many
			if body is RigidBody:
				held = bodies[0]
				held.mode = RigidBody.MODE_KINEMATIC
				held_offset = held.global_transform.origin - $GrabArea.global_transform.origin
				
				# make the held object not collide with the hand. Both should still collide with other objects.
				held.collision_mask = 0
				collision_mask = 0
				
				$HeldObjectCollision.disabled = false
				$HeldObjectCollision.shape = held.get_node("CollisionShape").shape
				$HeldObjectCollision.global_transform = $GrabArea.global_transform
				break
	
func release():
	$HandOpen.visible = true
	$HandGrip.visible = false

	if held:
		held.mode = RigidBody.MODE_RIGID
		held.collision_mask = 1
		collision_mask = 1
		held = null
		$HeldObjectCollision.disabled = true

# GRABBING AND THROWING STUFF IS UNTESTED!
