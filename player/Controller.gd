extends ARVRController

const CONTROLLER_DEADZONE = 0.65
const MOVEMENT_SPEED = 150

var directional_movement = false

var controller_velocity = Vector3(0, 0, 0)
var prior_controller_position = Vector3(0, 0, 0)
var prior_controller_velocities = []

var hand
var body
var camera

var startingpos

func _ready():
	
	connect("button_pressed", self, "button_pressed")
	
	var handname = "Hand" + get_name()[-1]
	hand = get_parent().get_node(handname)
	body = find_parent("PlayerBody")
	camera = get_parent().get_node("Player_Camera")
	
	startingpos = body.translation

func _physics_process(delta):
	
	hand.transform = transform
	hand.move_and_slide(
		(translation - hand.translation),
		Vector3.ZERO,
		false,
		4,
		PI/4,
		false
	)
	
		# Controller velocity
	# --------------------
#	if get_is_active():
#		controller_velocity = Vector3(0, 0, 0)
#
#		if prior_controller_velocities.size() > 0:
#			for vel in prior_controller_velocities:
#				controller_velocity += vel
#
#			# Get the average velocity, instead of just adding them together.
#			controller_velocity = controller_velocity / prior_controller_velocities.size()
#
#		prior_controller_velocities.append((global_transform.origin - prior_controller_position) / delta)
#
#		controller_velocity += (global_transform.origin - prior_controller_position) / delta
#		prior_controller_position = global_transform.origin
#
#		if prior_controller_velocities.size() > 30:
#			prior_controller_velocities.remove(0)
	
	
	# Directional movement
	# --------------------
	# NOTE: you may need to change this depending on which VR controllers
	# you are using and which OS you are on.
	var trackpad_vector = Vector2(-get_joystick_axis(1), get_joystick_axis(0))
	var joystick_vector = Vector2(-get_joystick_axis(5), get_joystick_axis(4))

	if trackpad_vector.length() < CONTROLLER_DEADZONE:
		trackpad_vector = Vector2(0, 0)
	else:
		trackpad_vector = trackpad_vector * ((trackpad_vector.length() - CONTROLLER_DEADZONE) / (1 - CONTROLLER_DEADZONE))

	if joystick_vector.length() < CONTROLLER_DEADZONE:
		joystick_vector = Vector2(0, 0)
	else:
		joystick_vector = joystick_vector * ((joystick_vector.length() - CONTROLLER_DEADZONE) / (1 - CONTROLLER_DEADZONE))

	var forward_direction = camera.global_transform.basis.z.normalized()
	var right_direction = camera.global_transform.basis.x.normalized()

	var movement_vector = (trackpad_vector + joystick_vector)

	# Change this. Now the movement is based on headset orientation, not controller orientation. Some people including me would prefer other way around.
	var movement_forward = forward_direction * movement_vector.x * delta * MOVEMENT_SPEED
	var movement_right = right_direction * movement_vector.y * delta * MOVEMENT_SPEED

	movement_forward.y = 0
	movement_right.y = 0

	if movement_right.length() > 0 or movement_forward.length() > 0:
		body.move_and_slide(movement_right + movement_forward)
		directional_movement = true
	else:
		directional_movement = false
	# --------------------

func button_pressed(button_index):
	print(button_index)
	
	# resets the player to the starting position. Probably not useful in the final game. Mapped to menu button.
	if button_index == 14:
		body.translation = startingpos

