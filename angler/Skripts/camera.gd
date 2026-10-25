extends Camera2D

@export var min_zoom := 0.2      # am weitesten herausgezoomt
@export var max_zoom := 0.6      # am nächsten dran
@export var margin := 400.0      # Rand um die Spieler
@export var smooth := 4.0        # größer = schneller

func _process(delta):
	var players = get_tree().get_nodes_in_group("Player")
	if players.is_empty():
		return

	# Position der Sprites sammeln
	var points: Array[Vector2] = []
	for p in players:
		var s = p.get_node_or_null("Sprite2D")
		points.append(s.global_position if s else p.global_position)

	# Rechteck um alle Spieler
	var rect := Rect2(points[0], Vector2.ZERO)
	for pt in points:
		rect = rect.expand(pt)
	rect = rect.grow(margin)

	# Kamera in die Mitte
	global_position = global_position.lerp(rect.get_center(), delta * smooth)

	# Zoom so wählen, dass alle ins Bild passen
	var screen := get_viewport_rect().size
	var z = min(screen.x / rect.size.x, screen.y / rect.size.y)
	z = clamp(z, min_zoom, max_zoom)
	zoom = zoom.lerp(Vector2(z, z), delta * smooth)
