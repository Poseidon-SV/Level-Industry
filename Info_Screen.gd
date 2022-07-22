extends Area2D

var show : bool = false

export var text = '' 

func _ready():
	$Panel.visible = false
	$Panel/Label.text = text


func _process(delta):
	if show == true :
		$Panel.visible = true
	else:
		$Panel.visible = false

func _on_Info_Screen_body_entered(body):
	show = true

func _on_Info_Screen_body_exited(body):
	show = false
