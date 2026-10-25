extends RigidBody2D

var isFollowingPlayer: bool = false

var isCollectable: bool = true

@onready var Sprite: Sprite2D = $Sprite2D 
# Called when the node enters the scene tree for the first time.
#func wait(seconds:float):
	#await get_tree().create_timer(seconds).timeout

func _on_area_2d_area_entered(area):
	if area.is_in_group("2Technik"):
		await get_tree().create_timer(0.8).timeout
		self.queue_free()
		#RigidBody2D.freeze = true
	
	if area.is_in_group("Player") && isCollectable:
		var sprite = load("res://Assets/Füsch_normal.png")
		Sprite.Texture2D.texture(sprite)
		isFollowingPlayer = true
		
	
