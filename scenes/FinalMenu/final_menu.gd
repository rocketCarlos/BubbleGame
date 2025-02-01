extends Node2D

@onready var button_exit = $Buttons/Exit
@onready var button_play_again = $Buttons/PlayAgain
@onready var button_buy = $Buttons/Buy
@onready var title_success = $TextContainer/TitleSuccess
@onready var title_loss = $TextContainer/TitleLoss
@onready var title_after_buying = $TextContainer/TitleAfterBuying
@onready var description_loss = $TextContainer/TitleLoss/DescriptionLoss
@onready var description_after_buying  = $TextContainer/TitleAfterBuying/DescriptionAfterBuying
@onready var value_base_money = $TextContainer/TitleSuccess/MoneyDetail/BaseMoney/Value
@onready var value_penalties = $TextContainer/TitleSuccess/MoneyDetail/Penalties/Value
@onready var value_time_bonus = $TextContainer/TitleSuccess/MoneyDetail/TimeBonus/Value
@onready var value_total_money = $TextContainer/TitleSuccess/MoneyDetail/TotalMoney/Value
@onready var value_bubble_cost = $TextContainer/TitleSuccess/MoneyDetail/BubbleCost/Value
@onready var money_sound = $Money



enum cases{
	SUCCESS_AND_MONEY,
	SUCCESS_NO_MONEY,
	LOSS,
	AFTER_BUYING,
}

var case: cases

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(956.0, 517.0), 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	hide_all()
	
	value_base_money.text = Globals.final_menu_values['value_base_money']
	value_penalties.text = Globals.final_menu_values['value_penalties']
	value_time_bonus.text = Globals.final_menu_values['value_time_bonus']
	value_total_money.text = Globals.final_menu_values['value_total_money']
	value_bubble_cost.text = Globals.final_menu_values['value_bubble_cost']
	
	match case:
		cases.SUCCESS_AND_MONEY:
			button_buy.show()
			title_success.show()
			money_sound.play()
		cases.SUCCESS_NO_MONEY:
			button_exit.show()
			button_play_again.show()
			title_success.show()
			money_sound.play()
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
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 1)
	await tween.finished
#endregion

#region signal functions
func _on_exit_pressed() -> void:
	print("hello")
	disable_all()
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
