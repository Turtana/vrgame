extends Spatial

var held = null

func _ready():
	get_node("SleepArea").connect("body_entered", self, "sleep_area_entered")
	get_node("SleepArea").connect("body_exited", self, "sleep_area_exited")
	
	if name[-1] == "L":
		# Mirror hand
		$HandOpen.scale.y = -0.5
		$HandGrip.scale.y = -0.5
		$GrabArea.translation.x = 0.05

func _physics_process(delta):
	if held:
		held.global_transform = $GrabArea.global_transform # change this. It "snaps" the object to transform area

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
		if len(bodies) > 0:
			held = bodies[0]
	
func release():
	$HandOpen.visible = true
	$HandGrip.visible = false

	if held:
		held = null
		

# GRABBING AND THROWING STUFF IS UNTESTED!
