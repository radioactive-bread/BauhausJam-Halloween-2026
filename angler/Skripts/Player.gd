extends CharacterBody2D
@onready var label = %Label
@onready var label2 = %Label2
const SPEED = 300.0
const ACCEL = 2.0

var score = 0

var input: Vector2

var objectives : Array =  ["walkman", "gameboy", "fridge"]

func get_input():
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input.normalized()

func _process(delta):
	var playerInput = get_input()
	velocity = lerp(velocity, playerInput * SPEED, delta * ACCEL)
	
	move_and_slide()
	
	label.text = "Player1 Score " + str(GlobalScript.score_1)
	
	label2.text = "Player2 Score " + str(GlobalScript.score_2)
	
	#func set_label(new_label_count: int):
		#label_counter = new_label_count
		#label.text = "score_1":
