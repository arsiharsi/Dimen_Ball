extends Node2D



var version = "1.7_fullscreen_landscape_mod"
export (NodePath) var camera_nodepath
export (NodePath) var camera_shake_timer_nodepath
export (NodePath) var blue_player_nodepath
export (NodePath) var red_player_nodepath
export (NodePath) var ball_nodepath
export (NodePath) var positions_nodepath
export (NodePath) var ui_nodepath
export (NodePath) var animations_nodepath
export (NodePath) var score_ammount_nodepath
export (bool) var is_in_play = false
var camera
var shake_timer
var blue_player
var red_player
var ball
var ui
var animations
var score_ammount
var start_positions
var blue_points = 0
var red_points = 0
export(int) var max_points
var is_controls_checked = false
var is_waiting_for_controls = false
export(String, "in_menu","pregame" , "preparing", "playing", "countdown") var state 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _on_visibility_state_changed(state):
	AudioServer.set_bus_mute(0, state == "hidden" or $misc_for_scripts/ad_shower.last_state == "opened")


func change_game_time(new_time):
	Engine.time_scale = new_time


# Called when the node enters the scene tree for the first time.
func _ready():
	Bridge.game.connect("visibility_state_changed", self, "_on_visibility_state_changed")
	print(Bridge.platform.language)
	TranslationServer.set_locale(Bridge.platform.language)
	score_ammount = get_node(score_ammount_nodepath)
	animations = get_node(animations_nodepath)
	ui = get_node(ui_nodepath)
	blue_player = get_node(blue_player_nodepath)
	red_player = get_node(red_player_nodepath)
	start_positions = get_node(positions_nodepath)
	ball = get_node(ball_nodepath)
	randomize()
	GlobalGameScript.main_node = self
	camera = get_node(camera_nodepath)
	shake_timer = get_node(camera_shake_timer_nodepath)
	if Bridge.platform.id == "yandex":
		Bridge.platform.send_message("game_ready")
	pass # Replace with function body.

var shake_power = 0

func _process(_delta):
	$UI/menu/version.visible = Input.is_action_pressed("view_version")
	$UI/menu/version.text = "VERSION: "+version
	animations.playback_speed = int($misc_for_scripts/ad_shower.last_state != "opened")
	ui.get_node("scores/blue").text = str(blue_points)
	ui.get_node("scores/red").text = str(red_points)
	is_controls_checked = blue_player.is_controls_checked and red_player.is_controls_checked
	is_controls_checked = is_controls_checked or (blue_player.is_controls_checked and GlobalGameScript.game_mode == "1vAI")
	if state == "pregame" and is_controls_checked:
		state = "prepaing"
	if state == "prepaing":
		animations.play("second_start")
	camera.position = Vector2(512,300) + Vector2(rand_range(-shake_power,shake_power),rand_range(-shake_power,shake_power))


func camera_shake(power, duration):
	shake_power = power
	shake_timer.start(duration)
	pass



func _on_shake_timer_timeout():
	shake_power = 0
	pass # Replace with function body.


func reset_score():
	red_points = 0
	blue_points = 0


func reset_postitons():
	ball.change_state(RigidBody2D.MODE_STATIC)
	disable_players()
	blue_player.global_position= start_positions.get_node("blue").global_position
	red_player.global_position = start_positions.get_node("red").global_position
	blue_player.linear_velocity = Vector2.ZERO
	red_player.linear_velocity = Vector2.ZERO
	ball.global_position = start_positions.get_node("ball").global_position

func start_game():
	ball.change_state(RigidBody2D.MODE_RIGID)
	enable_players()


func enable_players():
	blue_player.change_state(RigidBody2D.MODE_CHARACTER)
	red_player.change_state(RigidBody2D.MODE_CHARACTER)


func disable_players():
	blue_player.change_state(RigidBody2D.MODE_STATIC)
	red_player.change_state(RigidBody2D.MODE_STATIC)


func _on_floor_body_entered(body):
	if body.name == "ball" and is_in_play:
		if body.global_position.x > 512:
			blue_points += 1
			if blue_points == max_points:
				animations.play("win_blue")
				$sound_and_music/win.play()
			else:
				$sound_and_music/goal.play()
				animations.play("second_start")
			print("blue scores")
		else:
			red_points += 1
			if red_points == max_points:
				animations.play("win_red")
				$sound_and_music/win.play()
			else:
				$sound_and_music/goal.play()
				animations.play("second_start")
			print("red scores")
	pass # Replace with function body.


func _on_change_translation_pressed():
	$sound_and_music/button.play()
	if TranslationServer.get_locale() == "en":
		TranslationServer.set_locale("ru")
	else:
		TranslationServer.set_locale("en")
	
	pass # Replace with function body.


func _on_1v1_pressed():
	$misc_for_scripts/ad_shower.show_ad()
	if check_score():
		$sound_and_music/button.play()
		reset_postitons()
		GlobalGameScript.game_mode = "1v1"
		animations.play("game_start")
	else:
		$animations/score_wrong.play("def")
	pass # Replace with function body.



func check_score():
	if score_ammount.text.is_valid_integer():
		if int(score_ammount.text) > 0:
			max_points = int(score_ammount.text)
			return true
	return false




func disable_all_menu_buttons():
	for i in range(0, ui.get_node("menu/buttons").get_child_count()):
		ui.get_node("menu/buttons").get_child(i).disabled = true

func enable_all_menu_buttons():
	for i in range(0, ui.get_node("menu/buttons").get_child_count()):
		ui.get_node("menu/buttons").get_child(i).disabled = false


func _on_pause_button_pressed():
	$sound_and_music/button.play()
	get_tree().paused = true
	ui.get_node("pause_screen/screen").show()
	pass # Replace with function body.


func _on_continue_button_pressed():
	$sound_and_music/button.play()
	get_tree().paused = false
	ui.get_node("pause_screen/screen").hide()
	pass # Replace with function body.


func _on_back_button_pressed():
	hide_player_controls()
	$sound_and_music/button.play()
	get_tree().paused = false
	ui.get_node("pause_screen/screen").hide()
	animations.play("back_to_menu")
	pass # Replace with function body.



func show_player_controls():
	blue_player.show_controls()
	if GlobalGameScript.game_mode != "1vAI":
		red_player.show_controls()
	

func hide_player_controls():
	blue_player.hide_contols()
	red_player.hide_contols()



func _on_sfx_pressed():
	$sound_and_music/button.play()
	ui.get_node("sound_edit/sfx/not_active").visible = not ui.get_node("sound_edit/sfx/not_active").visible
	AudioServer.set_bus_mute(1, ui.get_node("sound_edit/sfx/not_active").visible)
	pass # Replace with function body.


func _on_music_pressed():
	$sound_and_music/button.play()
	ui.get_node("sound_edit/music/not_active").visible = not ui.get_node("sound_edit/music/not_active").visible
	AudioServer.set_bus_mute(2, ui.get_node("sound_edit/music/not_active").visible)
	pass # Replace with function body.


func _on_1vAI_pressed():
	$misc_for_scripts/ad_shower.show_ad()
	if check_score():
		$sound_and_music/button.play()
		reset_postitons()
		GlobalGameScript.game_mode = "1vAI"
		animations.play("game_start")
	else:
		$animations/score_wrong.play("def")
	pass # Replace with function body.



func set_gamemode(gamemode):
	GlobalGameScript.game_mode = gamemode


func _on_ad_shower_ad_closed():
	#animations.playback_speed = 1
	pass # Replace with function body.
