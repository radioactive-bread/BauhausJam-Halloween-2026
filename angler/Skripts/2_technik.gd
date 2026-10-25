extends Area2D

const BAG_GREEN := preload("res://Assets/Einkaufstüte_grün.png")
const BAG_RED := preload("res://Assets/Einkaufstüte_rot.png")

var bought := false


func _on_body_entered(body):
	if bought or not body.is_in_group("Fisch"):
		return
	# Ein Fisch, der schon wegschwimmt, kauft nichts mehr
	if body.get("is_leaving"):
		return

	bought = true

	# Wer bekommt den Punkt und welche Tüte gehört dazu?
	var bag: Texture2D = null
	if is_in_group("Player1Objective"):
		GlobalScript.score_1 += 1
		bag = BAG_GREEN
	elif is_in_group("Player2Objective"):
		GlobalScript.score_2 += 1
		bag = BAG_RED

	# Fisch bekommt die Tüte und schwimmt aus dem Bild
	if bag and body.has_method("buy_and_leave"):
		body.call_deferred("buy_and_leave", bag)

	# Das Item steckt jetzt in der Tüte: ausblenden und entfernen
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	await tween.finished
	queue_free()
