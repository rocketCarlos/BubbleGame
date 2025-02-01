extends AnimatedSprite2D

@onready var intro_music = $IntroPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation = "initial"
	frame = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animation == "initial" and not intro_music.playing:
		intro_music.play()
	
	if Input.is_action_just_released("accelerate"):
		if frame == 4:
			var tween = get_tree().create_tween()
			tween.tween_property(self, "modulate", Color.TRANSPARENT, 1)
			tween.parallel().tween_property(intro_music, "volume_db", -80, 1)
			await tween.finished
			Globals.start_game.emit()
		frame += 1
		
