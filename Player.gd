extends KinematicBody2D #Node Func which is called for every Kinematic Body to apply some build in functions
#i write spaghetti code mostly :( now let's add FINITE STATE MACHINE
#Player death(Done)
#Do things when gets hit(knock back) move from groupe(Done)
#Shoot(Done)
#game over HUD

#Changing Stats of Player
var money : int = 0
var curHP : int = 100
var damage : int = 10 #Depends on enemy like worker has 10 damage
var EnergyBall : int = 0
var enemy : int = 0

#Constant
const maxHP : int = 100
const Energy_ball = preload("res://EnergyBall.tscn")

#Enviroment Variable
var speed : int = 140
var jumpForce : int = 290
var gravity : int = 500
var inertia : int = 5
#Basic Physics Variable
var velo : Vector2 = Vector2()

#Booleans
var shoot : bool = false
var punch : bool = false #To change animation or stop animation so it can perform the given action
var death : bool = false #To shut every code down expect death code
var Hurt : bool = false #So that Player gets Knock Back
var Ladder : bool = false
var intract : bool = false
var win : bool = false
var lose : bool = true

#onready var stun_timer : Timer = $StunTimer
onready var tween : Tween = $Tween
#onready var racCast = get_node("RayCast2D") #onready : it acts like ready func but can be used as a variable

func _physics_process(delta): #This func is only for Kinematic Body to use the basicPhy. built in KinematicBody2D Node
	
	velo.y += gravity * delta #To set the gravity of Player(Delta is the frame/sec) and y and x are built in variable in Vector2() func assigned to 'velo' variable 
	
	# Linear movment and Actions 
	if Input.is_action_pressed("Move_right") and punch == false and death == false and Hurt == false :
		velo.x = lerp(velo.x,speed,0.9)#+speed
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("Run")
		$AnimatedSprite/Light2DR.enabled = true
		$AnimatedSprite/Light2DL.enabled = false 
		$Position2D.position.x = 24
		intract = false
		$Sidle.stop()
	elif Input.is_action_pressed("Move_left") and punch == false and death == false and Hurt == false :
		velo.x = lerp(velo.x,-speed,0.9)
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("Run")
		$AnimatedSprite/Light2DR.enabled = false
		$AnimatedSprite/Light2DL.enabled = true
		$Position2D.position.x = -24
		intract = false
		$Sidle.stop()
	elif Input.is_action_just_pressed("Intract") and death == false and Hurt == false:
		$AnimatedSprite.play("Intract")
		intract = true
	else:
		if punch == false and Hurt == false and death == false and Ladder == false and intract == false:
			$AnimatedSprite.play("Idle")
			$Srun.stop()
	
	# Move_and_Slide func is use to call for every moving body
	velo = move_and_slide(velo, Vector2.UP, false, 4, 0.785,false)
	velo.x = lerp(velo.x,0,0.25) #(Change 3rd variable)To give Player a smooth stoping or make player movement like its on ice when it STOPS
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("rigid_body"):
			collision.collider.apply_central_impulse(-collision.normal * inertia)
	
	# Player vertical movements and actions while it's in air
	if not is_on_floor() and punch == false and death == false and Hurt == false and Ladder == false:
		$AnimatedSprite.play("Jump")
		$Srun.stop()
		$Sidle.stop()
	if Input.is_action_just_pressed("Jump") and is_on_floor() and death == false and Hurt == false: 
		velo.y = -jumpForce
		$AnimatedSprite.play("Jump")
		$Sjump.play()
		$Srun.stop()
		$Sidle.stop()
	# To make player continue the same actions in air or above floor(Still have to control his chest light)
	if Input.is_action_pressed("Jump") and death == false and Hurt == false  : 
#		$AnimatedSprite.play("Jump")
		if Input.is_action_pressed("Move_right"):
			velo.x = +speed
			$AnimatedSprite.flip_h = false
		elif Input.is_action_pressed("Move_left"):
			velo.x = -speed
			$AnimatedSprite.flip_h = true
	if Ladder == true :
		$Srun.stop()
		$Sidle.play()
		gravity = 0
		$AnimationPlayer.stop()
		Hurt = false
		$AnimatedSprite/Light2DL.enabled = false
		$AnimatedSprite/Light2DR.enabled = false
		if Input.is_action_pressed("Climb_up"):
			$AnimatedSprite.play("Climb_up")
			velo.y = -50
		elif not is_on_floor() and Input.is_action_pressed("Climb_down"):  
			$AnimatedSprite.play("Climb_down")
			velo.y = +100
		else :
			$AnimatedSprite.play("Climb")
			velo.y = 0
	else:
		gravity = 500
	# Attack actions(Punch/Shoot)
	if Input.is_action_just_pressed("Punch") and death == false and is_on_floor() and Hurt == false :
		punch = true
		$Spunch.play()
		$Srun.stop()
		$Sidle.stop()
		$AnimationPlayer.play("Punch")
		$AnimatedSprite.play("Punch")
	if Input.is_action_just_pressed("Shoot") and shoot == false and Ladder == false and Hurt == false:
		if EnergyBall > 0:
			$Sshoot.play()
			$Srun.stop()
			$Sidle.stop()
			emit_signal("used_an_EnergyBall")
			var energyBall = Energy_ball.instance()
			get_parent().add_child(energyBall)
			energyBall.position = $Position2D.global_position
			if $Position2D.position.x == -24:
				energyBall.EgB_direction (-1)
			else:
				energyBall.EgB_direction (1)
			punch = true
			shoot = true
			EnergyBall = EnergyBall - 1 
			$AnimatedSprite.play("Shoot")
#			print(EnergyBall)
		
	# Player when it's on Transpoter
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("Transpoter_R"):
			velo.x = + float(speed/2) 
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("Transpoter_L"):
			velo.x = - float(speed/2) 

	# players health and dead status
	get_node("../HUD").health = curHP
	if curHP <= 0:
		$AnimatedSprite.play("Death")
		set_collision_layer_bit(0,false)
		set_collision_mask_bit(2,false)
		$AnimatedSprite/Light2DL.enabled = false
		$AnimatedSprite/Light2DR.enabled = false
		$AnimatedSprite/Light2DDeath.enabled = true
		$AttackArea/Punch.disabled = true
		$AnimationPlayer.play("DeathL")
		death = true
		$Srun.stop()
		$Sidle.stop()
#		lose = true
#		return
#		get_tree().change_scene("res://U dead homie.tscn") #Still have to make After death
	else:
		$AnimatedSprite/Light2DDeath.enabled = false

func add_money(): #Calls from Money.gd when player collects the money 
	enemy = enemy + 1
	if enemy == 21:
		$win_pause.start()
		if curHP == 100:
			ScoreData.score += 100
		elif curHP < 100 and curHP >= 90:
			ScoreData.score += 90
		elif curHP < 90 and curHP >= 80:
			ScoreData.score += 80
		elif curHP < 80 and curHP >= 70:
			ScoreData.score += 70
		elif curHP < 70 and curHP >= 60:
			ScoreData.score += 60
		elif curHP < 60 and curHP >= 50:
			ScoreData.score += 50
		elif curHP < 50 and curHP >= 40:
			ScoreData.score += 40
		elif curHP < 40 and curHP >= 30:
			ScoreData.score += 30
		elif curHP < 30 and curHP >= 20:
			ScoreData.score += 20
		elif curHP < 20 and curHP >= 10:
			ScoreData.score += 10
		elif curHP < 10:
			ScoreData.score += 5
#	money = money + 1
#	print(money)

signal got_EnergyBall
signal used_an_EnergyBall
func add_EnergyBall():
	EnergyBall = EnergyBall + 8
	emit_signal("got_EnergyBall")
#	print(EnergyBall)
#func stun(): ## We used Bool value(Hurt) instead of timer(Stun_timer)
#	stun_timer.wait_time = 0.3
#	stun_timer.start()
##Stun 3rd option (in got_hurt()) Input.action_release("left")
## Input.action_release("right")
#func knock_back(direction : Vector2):
#	var distance = 100
#	tween.interpolate_property(self, "position", position, position + direction * distance, 0.3, Tween.TRANS_SINE, Tween.EASE_OUT)
#	tween.start()
#func knock_back(direction):
#	velo.y = jumpForce * 0.3
#	if position.x < direction :
#		velo.x = -100
#	elif position.x > direction :
#		velo.x = 100
signal got_hurt
func got_hurt(damage = 10,enemyPos = position.x,knockback_x = 800,knockback_y = jumpForce*0.5): #Calls(Knock Back)whenever Player gets hit or take damages from any thing
	if death == false:
		$Shurt.play()
		Hurt = true
		emit_signal("got_hurt")
		$AnimatedSprite.play("Hurt")
		$AnimationPlayer.stop(true)
#		$AnimationPlayer.play("RESET") Error: player's shoot animation starts playing
		curHP = curHP-damage
#		print(curHP)
		velo.y = - knockback_y
		if enemyPos > position.x:
			velo.x = - knockback_x
	#		print("right")
		elif enemyPos < position.x:
			velo.x = knockback_x
	#		print("left")
	elif death == true:
		$Sdeath.play()
#	stun()
#	knock_back(enemyPos)
#func add_health(health = 30):
#	if curHP < maxHP:
#		curHP = curHP + health
func _on_HealthScreen_add_health(health = 30):
	if curHP < maxHP:
		curHP = curHP + health
		ScoreData.score += 30
	if curHP > maxHP:
		curHP = curHP - (curHP - maxHP)	
	
#	print(curHP)
signal full_health()
func _on_HealthScreen_is_full_health():
	if curHP >= maxHP:
		emit_signal("full_health")
		

# To state punch,Hurt = false for player to start other actions or animations
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Punch" or $AnimatedSprite.animation == "Shoot" or $AnimatedSprite.animation == "Jump" :
		punch = false
		shoot = false
		intract = false
	if  $AnimatedSprite.animation == "Intract" :
		intract = false
	elif $AnimatedSprite.animation == "Hurt" or $AnimatedSprite.animation == "Jump":
		Hurt = false
		punch = false
		intract = false
		shoot = false
	if $AnimatedSprite.animation == "Death":
		get_tree().change_scene("res://Game_Over.tscn")
		
# To deal damage to enemy
func _on_AttackArea_body_entered(body):
	var pos = position.x
	body.got_hurt(damage,pos)

func _on_win_pause_timeout():
	get_tree().change_scene("res://You_Win.tscn")

func _on_MainScene_finished():
	get_parent().get_node("MianScene-2").play()
	
### Sounds
func _input(event: InputEvent):
	if event.is_action_pressed("Move_left") or event.is_action_pressed("Move_right"):
		$Srun.play()
	elif event.is_action_pressed("Jump") and is_on_floor():
		$Sjump.play()
	else:
		$Sidle.play()
