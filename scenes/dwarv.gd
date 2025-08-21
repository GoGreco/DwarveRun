extends CharacterBody2D

@onready var jump_height_timer = $jump_height_timer
@onready var animated_sprite_2d = $AnimatedSprite2D



#defines the gravity and jump_speed constants
const gravity = 4200 
const jump_speed = -1800

#built in function to handle physics
#delta is the time elapsed from the last frame to the next
func _physics_process(delta):
	
	#just gravity doesn't work, you can only have a falling speed if it's unit of distance times the time in wich you move
	velocity.y += delta*gravity
	#checks if the dwarve is on the floor
	if is_on_floor():
		#checks if the game is running so we can switch the animation that will play
		if not get_parent().game_running:
			animated_sprite_2d.play("idle")
			
		else:
			#checks if the player pressed the space bar, also starts a timer if the player has pressed it
			#if the player pressed it it will also make the dwarve jump
			if Input.is_action_just_pressed("ui_accept"):
				jump_height_timer.start()
				velocity.y = jump_speed
			else:
				animated_sprite_2d.play("walk")
				
	else:
		animated_sprite_2d.play("jump")
	
	move_and_slide()
 
#it checks if the timer started in the function above has finished
func _on_jump_height_timer_timeout():
	#if it has finished since the player stoped pressing space, then his jump is cut short 
	if !Input.is_action_pressed("ui_accept"):
		if velocity.y < -100:
	
			velocity.y = -100
	else:
		return

	
