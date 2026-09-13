extends Control

@export var card_name_label : Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_name_label.text = "None"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _replace_card_text(text : String) -> void:
	card_name_label.text = text
