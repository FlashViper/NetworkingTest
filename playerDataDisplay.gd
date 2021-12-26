extends RichTextLabel

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"): visible = !visible
	if not visible: return
	text = ""
	for id in Server.players:
		var p : Player = Server.players[id]
		text += "%s:\n\tName: %s\n\tposition: %s\n\tVelocity: %s\n"%[id, p.name, p.position, p.velocity]
#		text += "%s:\n\t%s\n"%[id, to_json(p)]
	text.trim_suffix("\n")
