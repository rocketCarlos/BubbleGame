extends Node2D

@export var main: PackedScene
@onready var cutscene = $Cutscene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.start_game.connect(_on_start_game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_game() -> void:
	cutscene.queue_free()
	call_deferred("add_child", main.instantiate())
