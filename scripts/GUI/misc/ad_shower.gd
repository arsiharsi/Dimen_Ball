extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ad_closed
var pause = true
var last_state = ""
# Called when the node enters the scene tree for the first time.
func _on_interstitial_state_changed(state):
	last_state = state
	#opened, closed
	if state == "opened":
		AudioServer.set_bus_mute(0, true)
		if pause:
			get_tree().paused = true
	elif state == "closed":
		AudioServer.set_bus_mute(0, false)
		emit_signal("ad_closed")
		if pause:
			get_tree().paused = false


func show_ad():
	var ignore_delay = true
	print("inter_ad")
	Bridge.advertisement.show_interstitial(ignore_delay)

# Called when the node enters the scene tree for the first time.
func _ready():
	Bridge.advertisement.connect("interstitial_state_changed", self, "_on_interstitial_state_changed")


func _on_ad_shower_ad_closed():
	get_tree().paused = false
	pass # Replace with function body.
