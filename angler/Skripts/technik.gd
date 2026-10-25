extends Area2D

var min_wait_time: float = 2.0
var max_wait_time: float = 10.0

var tv_gravity: float = 300.0

# Wie lange ein Fisch im Areal sein muss, bis er sich verändert (in Sekunden)
const HYPNO_TIME: float = 3.0
const ROTTEN_TIME: float = 7.0

var tv_is_on: bool = false

# Fisch -> Zeit, die er schon im Areal ist
var fish_timers: Dictionary = {}

@onready var animated_sprite: AnimatedSprite2D = get_node_or_null("Fernseher/AnimatedSprite2D")

var normal_texture = load("res://Assets/Füsch_normal.png")
var hypno_texture = load("res://Assets/Füsch_hypno.png")
var rotten_texture = load("res://Assets/Füsch_rotten.png")


func _ready() -> void:
	# body_entered ist im Editor schon verbunden. body_exited verbinden wir hier.
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)
	_timed_mode()


func _on_body_entered(body):
	if body.is_in_group("Fisch") and not fish_timers.has(body):
		fish_timers[body] = 0.0
		body.isFollowingPlayer = false


func _on_body_exited(body):
	if not fish_timers.has(body):
		return
	fish_timers.erase(body)
	# Ist der Fisch noch nicht tot, wird er wieder normal
	if is_instance_valid(body) and body.isCollectable:
		body.Sprite.texture = normal_texture


func _physics_process(delta: float) -> void:
	# Nur solange der Fernseher an ist, verrottet der Fisch
	if not tv_is_on:
		return

	for fish in fish_timers.keys():
		if not is_instance_valid(fish):
			fish_timers.erase(fish)
			continue
		if not fish.isCollectable:
			continue # schon tot

		fish_timers[fish] += delta
		var t: float = fish_timers[fish]

		if t >= ROTTEN_TIME:
			fish.Sprite.texture = rotten_texture
			fish.isCollectable = false
			fish.isFollowingPlayer = false
			fish.gravity_scale = 0.0
		elif t >= HYPNO_TIME:
			fish.Sprite.texture = hypno_texture


func showBrainrot():
	tv_is_on = true
	if animated_sprite:
		animated_sprite.visible = true
		animated_sprite.play()
	gravity_point = true
	gravity = tv_gravity
	gravity_space_override = Area2D.SPACE_OVERRIDE_REPLACE


func hideBrainrot():
	tv_is_on = false
	if animated_sprite:
		animated_sprite.visible = false
		animated_sprite.stop()
	gravity_space_override = Area2D.SPACE_OVERRIDE_DISABLED


func _timed_mode():
	while true:
		# Zufällige Wartezeit
		var random_delay = randf_range(min_wait_time, max_wait_time)
		await get_tree().create_timer(random_delay).timeout

		# Brainrot einschalten
		showBrainrot()

		# 8 Sekunden warten
		await get_tree().create_timer(8.0).timeout

		# Brainrot wieder ausschalten
		hideBrainrot()
