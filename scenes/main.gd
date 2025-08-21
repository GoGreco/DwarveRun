extends Node
#preloading obstacles
var ogre = preload("res://scenes/ogre.tscn")
var goblin = preload("res://scenes/goblin.tscn")


#game variables
#import variables
@onready var dwarve = $Dwarve
@onready var camera = $Camera2D
@onready var ground = $Ground
@onready var score_label = $HUD/score
@onready var high_score_label = $HUD/high_score
@onready var start_label = $HUD/start
@onready var restar_button = $HUD/game_over


#game start variables
const dwarve_start_position := Vector2i(80, 576)
const camera_start_position := Vector2i(576, 324)
var game_running : bool

#movement Variables
var speed
const max_speed : float = 25.0
const start_speed : float = 10.0
const speed_modifier : float = 5000.00

var screen_size : Vector2i
var ground_height : int 
var ground_scale : int

var last_enemy
var enemy_types := [ogre, goblin]
var enemies_created : Array
	
#score variables
var score_changer
var score : int
var high_score : int
const score_modifier = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	restar_button.pressed.connect(new_game)
	
	screen_size = get_window().size
	ground_height = ground.get_node("Sprite2D").texture.get_height()
	ground_scale = int(ground.get_node("Sprite2D").scale.y)
	new_game()


#Function that will reset the game variables to their original state
func new_game():
	
	#guarantee the game will start fresh from the beginning
	score = 0
	
	start_label.text = "PRESS SPACE TO START: "
	
	get_tree().paused = false
	
	
	dwarve.position = dwarve_start_position
	dwarve.velocity = Vector2i(0, 0)
	camera.position = camera_start_position
	ground.position = Vector2i(0, 0)
	game_running = false
	start_label.show()
	restar_button.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):  
	speed = start_speed
	
	if game_running:
		#generate enemies
		create_enemy()

		score_changer = int(speed)
		#checks if the player has hit the maximum speed
		if speed < max_speed:
			speed += float(score)/speed_modifier
		else:
			speed = max_speed
			

		#camera and dwarve velocity
		#basically the dwarve will move along with the camera while everything happens around them
			
		dwarve.position.x += speed
		camera.position.x += speed
		
		#updating the score based on the score_chager wich is speed before it was altered and showing it on screen
		score+= score_changer
		show_score()
		
		#increase the speed value
		for foe in enemies_created:
			if foe.position.x < camera.position.x - screen_size.x:
				remove_enemy(foe)
				
		
		#updating the ground position
		if camera.position.x - ground.position.x > screen_size.x *1.5:
			ground.position.x += screen_size.x 

		#remove the enemies off-screen
		
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			start_label.hide()
			

func show_score():
	score_label.text = "SCORE: " + str(score/score_modifier)
	

func high_score_setter():
	if score > high_score:
		high_score = score
		high_score_label.text = "HIGH SCORE: "+ str(high_score)


func create_enemy():
	#checks if we have already created an enemy
	if enemies_created.is_empty() or last_enemy.position.x < camera.position.x:
		#chooses a radom enemy type
		var enemy_type = enemy_types[randi()%enemy_types.size()]
		var enemy
		var max_enemy = 3
		for i in range(randi() % max_enemy+1):
			#stores that random enemy inside this enemy variable, also adds him to the main scene and adds him to the list of enemies
			#now we instantiated an enemy, we can make him appear
			enemy = enemy_type.instantiate()
			last_enemy = enemy
			enemy.get_node("AnimatedSprite2D").play("default")
			#once we instantiated an enemy we can access theyr properties 
			#all of this block is here because I decided to put animation on my enemies, fuck this block, fuck this animation
			#I cannot get the texture from an animation, so I looked for a specific frame to get it's texture
			#and so I added to a function for better visualization, once I have calmed down
			var enemy_height = enemy_height(enemy)
			
			var enemy_scale = enemy.get_node("AnimatedSprite2D").scale
			
			
			var enemy_x : int = camera.position.x + screen_size.x/2 + randi_range(200, 500)
			var enemy_y : int = screen_size.y -(ground_height*ground_scale)-((enemy_height*enemy_scale.y)/2) + 5
			#finaly, the funtion to make the guy appear
			add_enemy(enemy, enemy_x, enemy_y)

func enemy_height(foe):
	var foe_frames = foe.get_node("AnimatedSprite2D").sprite_frames
	var foe_texture = foe_frames.get_frame_texture("default", 0)
	var foe_height = foe_texture.get_height()
	return foe_height
	
func hit_foe(body):
	if body.name == "Dwarve":
		game_over()

func add_enemy(foe, x, y):
	foe.position = Vector2i(x,y)
	
	#connect to the body_entered Signal so we can detect collisions 
	#we than pass the function that shall activate once we collide with such foe
	foe.body_entered.connect(hit_foe)
	
	add_child(foe)
	enemies_created.append(foe)

func remove_enemy(foe):
	foe.queue_free()
	enemies_created.erase(foe)
	
	
func game_over():
	high_score_setter()
	get_tree().paused = true
	game_running = false
	start_label.text = "GAME OVER\nthough luck"
	start_label.show()
	restar_button.show()
	
	pass
