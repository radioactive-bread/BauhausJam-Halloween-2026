extends Area2D

	


func _on_body_entered(body):
	if body.is_in_group("Fisch"):
		# Diese Technik soll eingesammelt werden können
		# Wenn Spieler 1 dieses Item in seinen objectives hat dann bekommt jeweiliger Spieler 1 Punkt
		if(is_in_group("Player1Objective")):
			GlobalScript.score_1 += 1
		elif(is_in_group("Player2Objective")):
			GlobalScript.score_2 += 1
		
		
		await get_tree().create_timer(0.5).timeout
		self.queue_free()
		
		
