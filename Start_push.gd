extends Node2D #SAME AS MP.gd
#Used to give startin push to the player 

const Idle_duration = 1.0

export var move_to = Vector2.RIGHT * 200
export var speed = 8.0

var follow = Vector2.ZERO

onready var platform = $KinematicBody2D
onready var tween = $Tween

func _ready():
	_init_tween()

func _init_tween():
	var duration = move_to.length() / float(speed * 16)
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, Idle_duration)
	tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration * Idle_duration * 2 + 1)
#	tween.interpolate_property(platform, "position", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, Idle_duration)
#	tween.interpolate_property(platform, "position", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration * Idle_duration * 2)
	tween.start()
	
func _physics_process(_delta):
	platform.position = platform.position.linear_interpolate(follow, 0.095)
