extends Line2D

export var max_dots = 10
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_rotation = 0
	global_position = Vector2.ZERO
	add_point(get_parent().global_position)
	if get_point_count() > max_dots:
		remove_point(0)
# Declare member variables here. Examples:
#	pass
