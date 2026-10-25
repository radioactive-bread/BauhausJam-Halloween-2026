extends Area2D

var min_wait_time: float = 2.0
var max_wait_time: float = 10.0

var tv_gravity: float = 50.0

@onready var tv_node: Node2D = %Fernseher
@onready var animated_sprite: AnimatedSprite2D = $Fernseher/AnimatedSprite2D

func _ready() -> void:
	_timed_mode()


func _on_area_2d_area_entered(body):
	#Solange der Fisch in dem Areal ist
	if body.is_in_group("Fisch"):
		body.isFollowingPlayer = false
		var rotten_texture = load("res://Assets/Füsch_hypno.png")
		var dead_texture = load("res://Assets/Füsch_rotten.png")
		await get_tree().create_timer(3).timeout
		body.texture(rotten_texture)
		await get_tree().create_timer(4).timeout
		body.texture(dead_texture)
		body.isCollectable = false
		body.gravity_scale = 0.0

func showBrainrot():
	# Nutzt jetzt die sicher geladene Variable
	if animated_sprite:
		animated_sprite.visible = true
		animated_sprite.play() 
	gravity = tv_gravity
	
func hideBrainrot():

	if animated_sprite:
		animated_sprite.visible = false
		if animated_sprite.has_method("stop"):
			animated_sprite.stop()
		
	gravity = 0 	
		
func _timed_mode():
	while true:
		# Hier nach einer Random Zeit Animation einblenden und nach 5s wieder ausblenden
		# 1. Generiere eine zufällige Wartezeit
		var random_delay = randf_range(min_wait_time, max_wait_time)
			
		# 2. Warte zufällige Zeit ab
		await get_tree().create_timer(random_delay).timeout
			
		# 3. Brainrot einschalten
		showBrainrot()
			
		# 4. Exakt 5 Sekunden warten
		await get_tree().create_timer(8.0).timeout
			
		# 5. Brainrot wieder ausschalten
		hideBrainrot()
