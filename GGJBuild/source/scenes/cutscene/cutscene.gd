extends AnimatedSprite2D

@onready var intro_music = $IntroPlayer
@export var menu_scene: PackedScene
var disabled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frame = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not intro_music.playing:
		intro_music.play()
		
	if not disabled:
		if frame == 1 and animation == "final":
				match Globals.level:
					0:
						frame = 1
					1: 
						frame = 1
					2: 
						frame = 2
					3: 
						frame = 3
					_: 
						frame = 4
		if Input.is_action_just_pressed("accelerate"):			
			if frame == 3 and animation == "initial" or frame > 0 and animation == "final":
				var tween = get_tree().create_tween()
				tween.tween_property(self, "modulate", Color.TRANSPARENT, 1)
				tween.parallel().tween_property(intro_music, "volume_db", -80, 1)
				await tween.finished
				
				if animation == "initial":
					Globals.start_game.emit()
				elif animation == "final":
					var menu_instance = menu_scene.instantiate()
					menu_instance.case = menu_instance.cases.AFTER_BUYING
					call_deferred("add_sibling", menu_instance)
					call_deferred("queue_free")
					
			frame += 1
		
