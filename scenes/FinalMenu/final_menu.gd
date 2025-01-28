extends Node2D

@onready var button_exit = $Buttons/Exit
@onready var button_play_again = $Buttons/PlayAgain
@onready var button_buy = $Buttons/Buy
@onready var title_success = $TextContainer/TitleSuccess
@onready var title_loss = $TextContainer/TitleLoss
@onready var title_after_buying = $TextContainer/TitleAfterBuying
@onready var description_loss = $TextContainer/TitleLoss/DescriptionLoss
@onready var description_after_buying  = $TextContainer/TitleAfterBuying/DescriptionAfterBuying

enum cases{
	SUCCESS_AND_MONEY,
	SUCCESS_NO_MONEY,
	LOSS,
	AFTER_BUYING,
}

var case: cases

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_all()
	match case:
		cases.SUCCESS_AND_MONEY:
			button_buy.show()
			title_success.show()
		cases.SUCCESS_NO_MONEY:
			button_exit.show()
			button_play_again.show()
			title_success.show()
		cases.LOSS:
			button_exit.show()
			button_play_again.show()
			title_loss.show()
			description_loss.show()
		cases.AFTER_BUYING:
			button_exit.show()
			button_play_again.show()
			title_after_buying.show()
			description_after_buying.show()
		_:
			printerr("Not a valid case: ", case)


#region utility functions
func hide_all() -> void:
	button_exit.hide()
	button_play_again.hide()
	button_buy.hide()
	title_success.hide()
	title_loss.hide()
	title_after_buying.hide()
	description_loss.hide()
	description_after_buying.hide()
	
func disable_all() -> void:
	button_buy.disabled = true
	button_play_again.disabled = true
	button_buy.disabled = true
	
func exit_animation() -> void:
	print("exiting")
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 1)
	await tween.finished
#endregion

#region signal functions
func _on_exit_pressed() -> void:
	print("hello")
	#disable_all()
	await exit_animation()
	Globals.title_screen.emit()
	queue_free()
	

func _on_play_again_pressed() -> void:
	disable_all()
	await exit_animation()
	Globals.start_game.emit()
	queue_free()

func _on_buy_pressed() -> void:
	disable_all()
	await exit_animation()
	Globals.buy_bubble_maker.emit()
	queue_free()
#endregion
