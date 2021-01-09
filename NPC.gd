extends KinematicBody

var camera

func _ready():
	camera = get_parent().find_node("Player_Camera")

func _process(_delta):
	look_at(Vector3(camera.global_transform.origin.x, translation.y, camera.global_transform.origin.z), Vector3.UP)
