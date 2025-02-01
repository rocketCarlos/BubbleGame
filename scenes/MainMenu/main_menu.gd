extends Node2D

@onready var background = $Sprite2D
@onready var start_button = $Sprite2D/Start
@onready var cutscene = $Cutscene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cutscene.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	start_button.disabled = true
	var tween = get_tree().create_tween()
	tween.tween_property(background, "modulate", Color.TRANSPARENT, 1)
	await tween.finished
	cutscene.disabled = false


func _on_credits_pressed() -> void:
	pass # Replace with function body.
