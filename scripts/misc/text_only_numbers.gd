extends LineEdit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


onready var LineEditRegEx = RegEx.new()
var old_text = ""

func _ready() -> void:
	old_text = text
	LineEditRegEx.compile("^[0-9.]*$")


func _on_text_changed(new_text):
	if LineEditRegEx.search(new_text):
		old_text = str(new_text)
	else:
		text = old_text
		set_cursor_position(text.length())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
