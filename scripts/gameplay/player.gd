extends RigidBody2D

export(String, "1", "2") var player_id
export(Color) var color
export(NodePath) var spr_nodepath
export(NodePath) var trail_nodepath
export(float) var jump_force
export(float) var horiz_force
export(float) var slam_force
export(float) var dash_force
export(NodePath) var target_nodepath
var target
var trail
export(NodePath) var dash_timer_nodepath
export (NodePath) var double_tap_timer_nodepath
var dash_timer
var double_tap_timer
var spr_node
var current_button = ""
var is_able_to_dash = true
var is_button_window = false
var is_controls_checked = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func change_state(state):
	mode = state


# Called when the node enters the scene tree for the first time.
func _ready():
	trail = get_node_or_null(trail_nodepath)
	target = get_node_or_null(target_nodepath)
	spr_node = get_node_or_null(spr_nodepath)
	dash_timer = get_node_or_null(dash_timer_nodepath)
	double_tap_timer = get_node_or_null(double_tap_timer_nodepath)
	spr_node.modulate = color
	trail.gradient = Gradient.new()
	trail.gradient.colors = PoolColorArray([Color(0,0,0,0),color])
	pass # Replace with function body.



func controls_checked():
	if !is_controls_checked:
		if Input.is_action_just_pressed("p"+player_id+"_right") or Input.is_action_pressed("p"+player_id+"_left"):
			is_controls_checked = true
			hide_contols()
		elif Input.is_action_just_pressed("p"+player_id+"_up") or Input.is_action_pressed("p"+player_id+"_down"):
			is_controls_checked = true
			hide_contols()
		



func _integrate_forces(state):
	animate(state)
	controls_checked()
	look_at_target()
	#double_tap()
	if player_id != "2" or GlobalGameScript.game_mode != "1vAI":
		var horiz_vec = int(Input.is_action_pressed("p"+player_id+"_right"))-int(Input.is_action_pressed("p"+player_id+"_left"))
		linear_velocity.x = horiz_force*horiz_vec
	#	if state.get_contact_count() >= 1 and linear_velocity.length() >=600:
	#		GlobalGameScript.main_node.camera_shake(linear_velocity.length()/500, 0.1)
		if state.get_contact_count() >= 1 and Input.is_action_just_pressed("p"+player_id+"_up"):
			apply_central_impulse(jump_force*state.get_contact_local_normal(0))
			$jump.play()
		elif Input.is_action_just_pressed("p"+player_id+"_down"):
			apply_central_impulse(slam_force*Vector2.DOWN)
	else:
		var horiz_vec = sign(GlobalGameScript.ball_global_position.x - global_position.x)/2
		linear_velocity.x = horiz_force*horiz_vec
		if state.get_contact_count() >= 1 and abs(GlobalGameScript.ball_global_position.x - global_position.x) <= 160 and GlobalGameScript.ball_global_position.y<global_position.y:
			$jump.play()
			apply_central_impulse(jump_force*state.get_contact_local_normal(0))
		elif GlobalGameScript.ball_global_position.y>global_position.y and linear_velocity.y < 1000:
			apply_central_impulse(slam_force*Vector2.DOWN)


func animate(state):
	if state.get_contact_count() >= 1:
		if state.get_contact_collider_object(0).name == "ball":
			spr_node.play("charge")
		else:
			spr_node.play("def")
	else:
		spr_node.play("recharge")
	pass


func look_at_target():
	spr_node.flip_h = target.global_position.x < global_position.x

func double_tap():
	if Input.is_action_just_pressed("p"+player_id+"_right") and current_button!="p"+player_id+"_right":
		current_button = "p"+player_id+"_right"
		is_button_window = true
		double_tap_timer.start()
	elif Input.is_action_just_pressed("p"+player_id+"_left") and current_button!="p"+player_id+"_left":
		current_button = "p"+player_id+"_left"
		is_button_window = true
		double_tap_timer.start()
	else:
		if Input.is_action_just_pressed("p"+player_id+"_right") and is_able_to_dash:
			apply_central_impulse(dash_force*Vector2.RIGHT)
			is_able_to_dash = false
			current_button = null
			is_button_window = false
			dash_timer.start()
		elif Input.is_action_just_pressed("p"+player_id+"_left") and is_able_to_dash:
			apply_central_impulse(dash_force*Vector2.LEFT)
			is_able_to_dash = false
			current_button = null
			is_button_window = false
			dash_timer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func show_controls():
	is_controls_checked = false
	$controls.play(str(player_id))
	$controls/def.play("show")
	pass



func hide_contols():
	$controls.play(str(player_id))
	$controls/def.play("hide")
	pass


func _on_double_cd_timeout():
	is_button_window = false
	pass # Replace with function body.


func _on_dash_cd_timeout():
	is_able_to_dash = true
	pass # Replace with function body.
