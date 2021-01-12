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
	
	# pull hand to the controller, minding collisions
	hand.transform = transform
	hand.move_and_slide(
		(translation - hand.translation),
		Vector3.ZERO,
		false,
		4,
		PI/4,
		false
	)
	
	# Directional movement
	# Use only the left controller for moving
	if name[-1] == "L":
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

		# Change this. Now the movement is based on headset orientation, not controller orientation. Some people including me would prefer other way around.
		
		var forward_direction
		var right_direction
		
		if GeneralSettings.HEAD_CONTROLS:
			forward_direction = camera.global_transform.basis.z.normalized()
			right_direction = camera.global_transform.basis.x.normalized()
		else:
			forward_direction = global_transform.basis.z.normalized()
			right_direction = global_transform.basis.x.normalized()

		var movement_vector = (trackpad_vector + joystick_vector).normalized()

		var movement_forward = forward_direction * movement_vector.x * delta * MOVEMENT_SPEED
		var movement_right = right_direction * movement_vector.y * delta * MOVEMENT_SPEED

		movement_forward.y = 0
		movement_right.y = 0

		if movement_right.length() > 0 or movement_forward.length() > 0:
			body.move_and_slide(movement_right + movement_forward)
			directional_movement = true
		else:
			directional_movement = false
		
		if joystick_vector.length() != 0:
			print(joystick_vector)


func button_pressed(button_index):
	print(name[-1], " " , button_index)
	
	# resets the player to the starting position. Probably not useful in the final game. Mapped to menu button.
	# NOTE: ACTIVATES ON INDEX KNUCKLES WITH JOYSTICK!! 
#	if button_index == 14:
#		body.translation = startingpos

