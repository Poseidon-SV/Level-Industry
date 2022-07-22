extends KinematicBody2D

var damage : int = 15
var curHP : int = 60

var gravity : int = 500
#var speed : int = 100


var player_in_R : bool = false #Detects the location of the player and store it as a bool value for letting enemy know that where the player is after getting out of his hit range
var player_in_L : bool = false #Detects the location of the player and store it as a bool value for letting enemy know that where the player is after getting out of his hit range
export var flip : bool = false #To change the direction after player runs out of the range
var attack : bool = false

var velo : Vector2 = Vector2(0,0) #To apply some direction

func _ready(): #This function is called 1st whenever this program runs 
	$AnimatedSprite.play("Idle")
	if flip == true: # Waits for the input from Player_exited() func to stay at the same direction after player leaves
		$AnimatedSprite.flip_h = true
	elif flip == false:
		$AnimatedSprite.flip_h = false
	$Label.visible = false

func _process(delta): #Runs along the program 
	velo.y += gravity * delta
	velo = move_and_slide(velo,Vector2.UP) #So body can move, this func is only for KinematicBody2D
	if curHP <= 0 : #We killed our enemy
		velo.x = 0
#		velo.y = 0
		$CloseEnough/CollisionShape2D.disabled = true
		$flame_area/CollisionShape2D.disabled = true
		$PlayerDetected_R/R_player.disabled = true
		$PlayerDetected_L/L_player.disabled = true
		$flame_area/AnimationPlayer.stop()
		set_collision_layer_bit(2, false)
		set_collision_mask_bit(0,false)
		$AnimatedSprite.play("Death")
		$Label.visible = false
		
	
func player_right(): #If Player is in the right side of the enemy(body)
#	velo.x += speed
	$AnimatedSprite.flip_h = false
#	$AnimatedSprite.play("Run")

func player_left(): #If the player is in the left side of the enemy(body)
#	velo.x -= speed
	$AnimatedSprite.flip_h = true
#	$AnimatedSprite.play("Run")

func _on_PlayerDetected_R_body_entered(_body): #It's Area2d func, calls when player is in the right side of the enemy body 
	player_right()
	player_in_R = true
	flip = false

func _on_PlayerDetected_L_body_entered(_body): #It,s Area2d func, calls when player is in the left side of the enemy body
	player_left()
	player_in_L = true
	player_in_R = false #Because the idle postion of the enemy is right
	flip = true

func _on_CloseEnough_body_entered(_body): #(Area2d) It calls when the player enters the hitrange of the enemy to attack the player an do some Damage
	$AnimatedSprite.play("Attack")
	$attack.play()
	attack = true
	if flip == false:
		$flame_area/AnimationPlayer.play("Flame_R")
	elif flip == true:
		$flame_area/AnimationPlayer.play("Flame_L")
		
#func _on_Hit_body_entered(body): #Calls when the enemy lands the hit or attack successfully
##	var pos = position.x
#	body.got_hurt(damage) #Sends the signal to the player that he has been hit or (GROUP) and Knocks back the player
	#Enemy Runs after killing the player we can make it stand there 
	#but what's better (Kill and Run) OR (Kill and Stand)
func _on_flame_area_body_entered(body):
	var pos = position.x
	body.got_hurt(damage,pos)
	
func _on_CloseEnough_body_exited(body): #It calls when the player gets out of the Hitting range of enemy so enemy can run towards the player to get back in the range
#	$Hit/AnimationPlayer.stop() #It stops attacking or hitting (and starts chasing)
	if attack == false :
		$flame_area/AnimationPlayer.play("RESET")
		$AnimatedSprite.play("Idle")
		if player_in_R == true: #Player left the attack range when he was at the right side of the body(enemy)
			return _on_PlayerDetected_R_body_entered(body) #To chase the player till he's out of the range
		elif player_in_L == true: #Player left the attack range when he was at the left side of the body(enemy)
			return _on_PlayerDetected_L_body_entered(body) #To chase the player till he,s out of the range
		
#func _on_PlayerDetected_R_body_exited(_body): #Calls when the player is out the range to chase
#	velo.x = 0 #To stop the enemy
#	return _ready() #To go back to the idle state

#func _on_PlayerDetected_L_body_exited(_body): #Calls when the player is out the range to chase
#	velo.x = 0 #To stop the enemy
#	return _ready() # To go back to the idle state

func got_hurt(damage,enemyPos): #Enemy gets 10 damage from Player and dies when it loses its full health
	curHP = curHP - damage
	velo.y = -150
	$Label.visible = true
	$Label.text = String(-damage)
	$flame_area/AnimationPlayer.play("RESET")
	if damage == 20:
		$Eball_hurt.play()
	else:
		$hurt.play()
	if curHP > 0:
		$AnimatedSprite.play("Hurt_")
		if enemyPos > position.x:
			velo.x = -100
		elif enemyPos < position.x:
			velo.x = 100
	else:
		$death.play()

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Hurt_":
		velo.x = 0
		$Label.visible = false
		return _ready()
	if $AnimatedSprite.animation == "Attack":
		attack = false
		$AnimatedSprite.play("Idle")
	if $AnimatedSprite.animation == "Death":
		get_node("../../HUD")._on_Money_got_money()
		get_node("../../Player").add_money()

