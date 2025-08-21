extends Node


#game variables
#import variables
@onready var dwarve = $Dwarve
@onready var camera = $Camera2D
@onready var floor = $Floor

#game start variables
const dwarve_start_position := Vector2i(80, 576)
const camera_start_position := Vector2i(576, 324)

#movement Variables
var speed
const max_speed : float = 25.0
const start_speed : float = 10.0
var screen_size : Vector2i

#score variables
var score : int
const score_modifier = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	new_game()


#Function that will reset the game variables to their original state
func new_game():
	
	score = 0
	dwarve.position = dwarve_start_position
	dwarve.velocity = Vector2i(0, 0)
	camera.position = camera_start_position
	floor.position = Vector2i(0, 0)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): 
	speed = start_speed
	
	#camera and dwarve velocity
	#basically the dwarve will move along with the camera while everything happens around them
	dwarve.position.x += speed
	camera.position.x += speed
	
	#updating the score based on the speed
	score+= speed/score_modifier
	print(score)
	#updating the floor position
	if camera.position.x - floor.position.x > screen_size.x *1.5:
		floor.position.x += screen_size.x 
