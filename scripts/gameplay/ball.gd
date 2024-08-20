extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func change_state(state):
	mode = state

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _integrate_forces(state):
	GlobalGameScript.ball_global_position = global_position
	if state.get_contact_count() >= 1:
		$bounce.play()
		GlobalGameScript.main_node.camera_shake(linear_velocity.length()/300, 0.2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
