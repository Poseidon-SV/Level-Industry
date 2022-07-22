extends KinematicBody2D

var damage : int = 10
var curHP : int = 40

var gravity : int = 500
var speed : int = 100


var player_in_R : bool = false #Detects the location of the player and store it as a bool value for letting enemy know that where the player is after getting out of his hit range
var player_in_L : bool = false #Detects the location of the player and store it as a bool value for letting enemy know that where the player is after getting out of his hit range
var flip : bool = false #To change the direction after player runs out of the range

var velo : Vector2 = Vector2(0,0) #To apply some direction

func _ready(): #This function is called 1st whenever this program runs 
	$AnimatedSprite.play("Idle")
	if flip == true: # Waits for the input from Player_exited() func to stay at the same direction after player leaves
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
	$Label.visible = false
	
func _process(delta): #Runs along the program 
	velo.y += gravity * delta
	velo = move_and_slide(velo,Vector2.UP) #So body can move, this func is only for KinematicBody2D
	if curHP <= 0 : #We killed our enemy
		velo.x = 0
#		velo.y = 0
#		$money.play()
		$run.stop()
		$CloseEnough/CollisionShape2D.disabled = true
		$Hit/CollisionShape2D.disabled = true
		$PlayerDetected_R/R_player.disabled = true
		$PlayerDetected_L/L_player.disabled = true
		$Hit/AnimationPlayer.stop()
		set_collision_layer_bit(2, false)
		set_collision_mask_bit(0,false)
		$AnimatedSprite.play("Death")
			
func player_right(): #If Player is in the right side of the enemy(body)
	velo.x += speed
	$AnimatedSprite.flip_h = false
	$AnimatedSprite.play("Run")
	$run.play()

func player_left(): #If the player is in the left side of the enemy(body)
	velo.x -= speed
	$AnimatedSprite.flip_h = true
	$AnimatedSprite.play("Run")
	$run.play()

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
	$Hit/AnimationPlayer.play("Hit")
	$run.stop()

func _on_Hit_body_entered(body): #Calls when the enemy lands the hit or attack successfully
	var pos = position.x
	$attack.play()
	body.got_hurt(damage, pos) #Sends the signal to the player that he has been hit or (GROUP) and Knocks back the player
	#Enemy Runs after killing the player we can make it stand there 
	#but what's better (Kill and Run) OR (Kill and Stand)
	
func _on_CloseEnough_body_exited(body): #It calls when the player gets out of the Hitting range of enemy so enemy can run towards the player to get back in the range
#	$Hit/AnimationPlayer.stop() #It stops attacking or hitting (and starts chasing)
	$Hit/AnimationPlayer.play("RESET")
	$AnimatedSprite.stop()
	if player_in_R == true: #Player left the attack range when he was at the right side of the body(enemy)
		return _on_PlayerDetected_R_body_entered(body) #To chase the player till he's out of the range
	elif player_in_L == true: #Player left the attack range when he was at the left side of the body(enemy)
		return _on_PlayerDetected_L_body_entered(body) #To chase the player till he,s out of the range
		
func _on_PlayerDetected_R_body_exited(_body): #Calls when the player is out the range to chase
	velo.x = 0 #To stop the enemy
	$run.stop()
	return _ready() #To go back to the idle state

func _on_PlayerDetected_L_body_exited(_body): #Calls when the player is out the range to chase
	velo.x = 0 #To stop the enemy
	$run.stop()
	return _ready() # To go back to the idle state

func got_hurt(damage,enemyPos = position.x): #Enemy gets 10 damage from Player and dies when it loses its full health
	curHP = curHP - damage
	velo.y = -150
	$Label.visible = true
	$Label.text = String(-damage)
	$Hit/AnimationPlayer.play("RESET")
	if damage == 20:
		$Eball_hurt.play()
	else:
		$hurt.play()
	if curHP > 0:
		$Timer.start()
		$AnimatedSprite.play("Hurt")
		if enemyPos > position.x:
			velo.x = -300
		elif enemyPos < position.x:
			velo.x = 300
	else:
		$death.play()

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Hurt":
		velo.x = 0
		
	$Label.visible = false
	if $AnimatedSprite.animation == "Death":
		get_node("../../HUD")._on_Money_got_money()
		get_node("../../Player").add_money()

func _on_Timer_timeout():
	velo.x = 0
	if player_in_R == true: #Player left the attack range when he was at the right side of the body(enemy)
		return player_right() #To chase the player till he's out of the range
	elif player_in_L == true: #Player left the attack range when he was at the left side of the body(enemy)
		return player_left()
	
