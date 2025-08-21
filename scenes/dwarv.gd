extends CharacterBody2D

@onready var jump_height_timer = $jump_height_timer
@onready var animated_sprite_2d = $AnimatedSprite2D

#defines the gravity and jump_speed constants
const gravity = 4200 
const jump_speed = -1800

#built in function to handle physics
#delta is the time elapsed from the last frame to the next
func _physics_process(delta):
	velocity.y += delta*gravity
	if is_on_floor():
		if not get_parent().game_running:
			animated_sprite_2d.play("idle")
			
		else:
			if Input.is_action_just_pressed("ui_accept"):
				jump_height_timer.start()
				velocity.y = jump_speed
			else:
				animated_sprite_2d.play("walk")

	else:
		animated_sprite_2d.play("jump")
	move_and_slide()
 
func _on_jump_height_timer_timeout():
	if !Input.is_action_pressed("ui_accept"):
		if velocity.y < -100:
	
			velocity.y = -100
	else:
		return

	
