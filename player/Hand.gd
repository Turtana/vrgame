extends Spatial

func _ready():
	get_node("SleepArea").connect("body_entered", self, "sleep_area_entered")
	get_node("SleepArea").connect("body_exited", self, "sleep_area_exited")

func sleep_area_entered(body):
	if "can_sleep" in body:
		body.can_sleep = false
		body.sleeping = false

func sleep_area_exited(body):
	if "can_sleep" in body:
		body.can_sleep = true
