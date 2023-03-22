extends CharacterBody2D

@export var move_speed: float = 100
@export var max_move_speed: float = 250
@export var acceleration_rate: float = 50
@export var deceleration_rate: float = 5
@export var starting_direction: Vector2 = Vector2(0, 20)
# parameters/Idle/blend_position

@onready var animation_tree = $AnimationTree
@onready var state_mashine = animation_tree.get('parameters/playback')

func _ready():
	update_animation_parameters(starting_direction)

func _physics_process(_delta):
	# get input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"),
	)
	
	# Вторая попытка ускорения
	if (Input.get_action_strength("space")):
		print('hoo')
		
		if (move_speed > 100):
			move_speed -= deceleration_rate
		
		if (Input.is_action_just_pressed("space")):
			move_speed += acceleration_rate
		
			if (move_speed > max_move_speed):
				move_speed = max_move_speed
	else:
		move_speed -= deceleration_rate
	
	if (move_speed < 0):
		move_speed = 0
	
	
	update_animation_parameters(input_direction)
	
	# get velocity
	velocity = input_direction * move_speed
	
	# move and slide func uses velocity of char body to move char on map
	move_and_slide()
	
	
	pick_new_state()
	
	
func update_animation_parameters(move_input: Vector2):
	if (move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)
		
		
func pick_new_state():
	if (velocity != Vector2.ZERO):
		state_mashine.travel('Walk')
	else:
		state_mashine.travel('Idle')
