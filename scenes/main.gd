extends Node
#preloading obstacles
var ogre = preload("res://scenes/ogre.tscn")
var goblin = preload("res://scenes/goblin.tscn")
var enemy_types := [ogre, goblin]
var enemies_created : Array

#game variables
#import variables
@onready var dwarve = $Dwarve
@onready var camera = $Camera2D
@onready var floor = $Floor
@onready var score_label = $HUD/score
@onready var high_score_label = $HUD/high_score
@onready var start_label = $HUD/start


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
#enemy variable
var last_enemy

#score variables
var score_changer
var score : int
const score_modifier = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	new_game()


#Function that will reset the game variables to their original state
func new_game():
	
	#guarantee the game will start from the beginning
	score = 0
	dwarve.position = dwarve_start_position
	dwarve.velocity = Vector2i(0, 0)
	camera.position = camera_start_position
	floor.position = Vector2i(0, 0)
	game_running = false
	start_label.show()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):  
	speed = start_speed
	
	if game_running:
		#camera and dwarve velocity
		#basically the dwarve will move along with the camera while everything happens around them
		dwarve.position.x += speed
		camera.position.x += speed
		
		score_changer = int(speed)
		
		if speed < max_speed:
			speed += float(score)/speed_modifier
		else:
			speed = max_speed
		
		
		#updating the score based on the score_chager wich is speed before it was altered and showing it on screen
		score+= score_changer
		show_score()
		
		#increase the speed value
		
		
		#updating the floor position
		if camera.position.x - floor.position.x > screen_size.x *1.5:
			floor.position.x += screen_size.x 
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			start_label.hide()
			

func show_score():
	score_label.text = "SCORE: " + str(score/score_modifier)
