extends Node2D

@export var main: PackedScene
var main_instance: Node = null

@export var cutscene: PackedScene
var cutscene_instance: Node = null

@export var final_menu: PackedScene
var final_menu_instance: Node = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.start_game.connect(_on_start_game)
	Globals.stage_cleaned.connect(_on_stage_cleaned)
	Globals.buy_bubble_maker.connect(_on_buy_bubble_maker)
	Globals.title_screen.connect(_on_title_screen)
	
	cutscene_instance = cutscene.instantiate()
	cutscene_instance.animation = "initial"
	call_deferred("add_child", cutscene_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#region signal functions
func _on_start_game() -> void:
	if cutscene_instance:
		cutscene_instance.queue_free()
		cutscene_instance = null
		
	main_instance = main.instantiate()
	call_deferred("add_child", main_instance)

func _on_stage_cleaned() -> void:
	final_menu_instance = final_menu.instantiate()
	# TODO: MANAGE FINAL_MENU CASES
	final_menu_instance.case = final_menu_instance.cases.LOSS
	call_deferred("add_child", final_menu_instance) 
	
	if main_instance:
		main_instance.call_deferred("queue_free")
		main_instance = null
		
func _on_buy_bubble_maker() -> void:
	pass
	
func _on_title_screen() -> void:
	cutscene_instance = cutscene.instantiate()
	cutscene_instance.animation = "initial"
	call_deferred("add_child", cutscene_instance)
#endregion
