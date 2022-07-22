extends Control


func _ready():
	$Node2D/AP_Up.play("UP")
	$Node2D/AP_Down.play("Down")

func _on_Button_pressed():
	$button.play()


func _on_button_finished():
	get_tree().change_scene("res://Main_Scene.tscn")
