extends KinematicBody

var held = null
var other_hand = null

func _ready():
	get_node("SleepArea").connect("body_entered", self, "sleep_area_entered")
	get_node("SleepArea").connect("body_exited", self, "sleep_area_exited")
	
	if name == "HandL":
		# Mirror hand
		$HandOpen.scale.y = -0.5
		$HandGrip.scale.y = -0.5
		$GrabArea.translation.x = 0.05
		other_hand = get_parent().find_node("HandR")
	else:
		other_hand = get_parent().find_node("HandL")

func _physics_process(_delta):
	if held:
		held.global_transform = $HeldPosition.global_transform
		$HeldObjectCollision.global_transform = $HeldPosition.global_transform

# physics optimization stuff, I suppose
#                V
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
	
	# NOTE! The held object HAS to have CollisionShape with the same name, so it can have only one collisionshape! Keep the physics objects simple.
	# Also, don't put ANY rigidbodies in the scene that you don't want to be movable by the player!
	
	if held == null:
		var bodies = $GrabArea.get_overlapping_bodies()
		for body in bodies:
			if body is RigidBody:
			# take one randomly, if there are many
				held = bodies[0]
				
				# holding the same objedct with both hands causes trouble. If you grab the same object the other hand is holding, release the other hand.
				if held == other_hand.held:
					other_hand.release()
				
				# make the held object not collide with the hand. Both should still collide with other objects.
				held.mode = RigidBody.MODE_KINEMATIC
				held.get_node("CollisionShape").disabled = true
				
				# hold the object in this position
				$HeldPosition.global_transform = held.global_transform
				
				# This collision shape simulates the collisions of the held object.
				# It's actually part of the hand.
				# This code fits it with the held object.
				$HeldObjectCollision.disabled = false
				$HeldObjectCollision.shape = held.get_node("CollisionShape").shape
				$HeldObjectCollision.global_transform = $GrabArea.global_transform # sets both position and rotation
				
				# skip the rest of the bodies
				break
	
func release():
	$HandOpen.visible = true
	$HandGrip.visible = false

	if held:
		held.mode = RigidBody.MODE_RIGID
		held.get_node("CollisionShape").disabled = false
		$HeldObjectCollision.disabled = true
		
		held = null

# TEST: grab one crate in each hand and bang them against one another
