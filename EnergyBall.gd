extends Area2D

var speed : int = 100
var velo : Vector2 = Vector2()
var damage :int = 20
var direction = 1

func _physics_process(delta):
	velo.x = speed * delta * direction
	translate(velo)
	$AnimatedSprite.play("Energy_Ball")

func EgB_direction (dir):
	direction = dir 
	if dir == -1 :
		$AnimatedSprite.flip_h = true
		

func _on_AnimatedSprite_animation_finished():
	queue_free()


func _on_EnergyBall_body_entered(body):
	var pos = position.x
	body.got_hurt(damage, pos)	
	queue_free()


func _on_Area2D_body_entered(body):
	queue_free()
