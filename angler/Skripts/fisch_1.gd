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
		
	


# --- Einkauf: Fisch bekommt eine Tüte und schwimmt aus dem Bild ---
var is_leaving: bool = false

const LEAVE_TIME: float = 2.5
const PACK_SOUND := preload("res://Sounds/Einpacken.mp3")

func buy_and_leave(bag_texture: Texture2D) -> void:
	if is_leaving:
		return
	is_leaving = true
	isFollowingPlayer = false
	isCollectable = false

	# Physik aus: Fisch wird nicht mehr angezogen und stößt nirgends an
	gravity_scale = 0.0
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	freeze = true
	collision_layer = 0
	collision_mask = 0

	# Einpack-Sound: läuft beim Elternknoten, damit er nicht abbricht, wenn der Fisch verschwindet
	var sfx := AudioStreamPlayer.new()
	sfx.stream = PACK_SOUND
	get_parent().add_child(sfx)
	sfx.finished.connect(sfx.queue_free)
	sfx.play()

	# Tüte unter den Fisch hängen
	var bag := Sprite2D.new()
	bag.texture = bag_texture
	bag.scale = Vector2(0.40, 0.40)
	bag.position = Vector2(0, 55)
	bag.z_index = 3
	add_child(bag)

	# Richtung: weg von der Bildmitte, waagerecht
	var cam := get_viewport().get_camera_2d()
	var center := cam.get_screen_center_position() if cam else global_position
	var zoom := cam.zoom if cam else Vector2.ONE
	var side := 1.0 if global_position.x >= center.x else -1.0
	var half_width := get_viewport_rect().size.x / zoom.x / 2.0
	var distance := half_width + 400.0
	var drift: float = sign(global_position.y - center.y) * distance * 0.15
	var target := global_position + Vector2(side * distance, drift)

	# Fisch schaut in Schwimmrichtung (Bild schaut nach rechts)
	Sprite.flip_h = side < 0.0

	var tween := create_tween()
	tween.tween_property(self, "global_position", target, LEAVE_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
	queue_free()
