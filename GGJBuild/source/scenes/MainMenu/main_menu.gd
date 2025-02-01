extends Node2D

@onready var background = $Sprite2D
@onready var start_button = $Sprite2D/Start
@onready var credits_button = $Sprite2D/Credits
@onready var credits = $Credits
@onready var cutscene = $Cutscene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cutscene.disabled = true
	cutscene.animation = "initial"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	start_button.disabled = true
	credits_button.disabled = true
	var tween = get_tree().create_tween()
	tween.tween_property(background, "modulate", Color.TRANSPARENT, 1)
	await tween.finished
	cutscene.disabled = false


func _on_credits_pressed() -> void:
	start_button.disabled = true
	credits_button.disabled = true
	var tween = get_tree().create_tween()
	tween.tween_property(credits, "position", Vector2(0.0, 0.0), 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	

func _on_back_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(credits, "position", Vector2(-2200.0, 0.0), 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	await tween.finished
	start_button.disabled = false
	credits_button.disabled = false
