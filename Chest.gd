extends AnimatedSprite

export(PackedScene) var object_scene: PackedScene = null

var is_player_inside : bool = false
var is_opened : bool = false

onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
onready var tween: Tween = get_node("Tween")
#
func _ready():
	assert(object_scene != null)
	animation_player.play("Idle")
	get_node("EnrG_Ball").visible = false

func _input(event: InputEvent):
	if event.is_action_pressed("Intract") and is_player_inside and not is_opened:
		is_opened = true
		animation_player.play("Open")
		$AudioStreamPlayer.play()
		
func _drop_object():
	animation_player.play("EnrG_Ball")
#	$EnrG_Ball.visible = true
#	var object = object_scene.instance()
#	owner.get_node("../..").add_child(object)
#
#	tween.interpolate_property(object, "position", position, position + Vector2(0, -10), 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
#	tween.start()
#
#	yield(tween, "tween_completed")
#
#	tween.interpolate_property(object, "position", position + Vector2(0, -10), position, 0.3, Tween.TRANS_SINE, Tween.EASE_IN)
#	tween.start()



func _on_Area2D_body_entered(_body):
	is_player_inside = true


func _on_Area2D_body_exited(_body):
	is_player_inside = false
