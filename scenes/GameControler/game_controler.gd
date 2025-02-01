extends Node2D

@export var main: PackedScene
var main_instance: Node = null

@export var cutscene: PackedScene
var cutscene_instance: Node = null

@export var final_menu: PackedScene
var final_menu_instance: Node = null

@export var main_menu_scene: PackedScene
var main_menu_instance: Node = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.start_game.connect(_on_start_game)
	Globals.game_ended.connect(_on_game_ended)
	Globals.buy_bubble_maker.connect(_on_buy_bubble_maker)
	Globals.title_screen.connect(_on_title_screen)
	
	main_menu_instance = main_menu_scene.instantiate()
	call_deferred("add_child", main_menu_instance)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#region signal functions
func _on_start_game() -> void:
	if cutscene_instance:
		cutscene_instance.queue_free()
		cutscene_instance = null
		
	if main_instance:
		main_instance.call_deferred("queue_free")
		main_instance = null
		
	if main_menu_instance:
		main_menu_instance.call_deferred("queue_free")
		main_menu_instance = null
		
	main_instance = main.instantiate()
	call_deferred("add_child", main_instance)

func _on_game_ended() -> void:
	final_menu_instance = final_menu.instantiate()
	
	Globals.final_menu_values = {
		'value_base_money' : str(main_instance.GOLD_VICTORY),
		'value_penalties' : '%.0f x %.0f = %.0f' % [main_instance.penalties, main_instance.GOLD_PENALTY, main_instance.penalties*main_instance.GOLD_PENALTY],
		'value_time_bonus' : '%.0f x %.0f = %.0f' % [main_instance.GOLD_EXTRA_PER_SECOND, main_instance.clock.time_left, main_instance.GOLD_EXTRA_PER_SECOND * main_instance.clock.time_left],
		'value_total_money' : '%.0f' % [main_instance.money],
		'value_bubble_cost' : '%.0f' % [main_instance.GOLD_GOAL],
	}
	
	match main_instance.final_type:
		'loss':
			final_menu_instance.case = final_menu_instance.cases.LOSS
		'success_and_money':
			final_menu_instance.case = final_menu_instance.cases.SUCCESS_AND_MONEY
		'success_no_money':
			final_menu_instance.case = final_menu_instance.cases.SUCCESS_NO_MONEY
	
	
	call_deferred("add_child", final_menu_instance) 

		
func _on_buy_bubble_maker() -> void:
	Globals.level += 1
	
	if main_instance:
		main_instance.call_deferred("queue_free")
		main_instance = null
	
	cutscene_instance = cutscene.instantiate()
	cutscene_instance.animation = "final"
	call_deferred("add_child", cutscene_instance)
	
func _on_title_screen() -> void:
	if main_menu_instance:
		main_menu_instance.call_deferred("queue_free")
		main_menu_instance = null
		
	main_menu_instance = main_menu_scene.instantiate()
	call_deferred("add_child", main_menu_instance)
#endregion
