extends Node2D

export (PackedScene) var Dummy = load("res://PlayerDummy.tscn")
var players := {}

func _process(delta: float) -> void:
	for k in Server.players:
		var player : Player = Server.players[k]
		if not players.has(player.id):
			var d = Dummy.instance()
			d.set_network_master(k)
			d.name = player.name
			d.position = player.position
			players[player.id] = d
			add_child(d)
			
			if k == get_tree().network_peer.get_unique_id():
				var cam = $Camera2D
				cam.remove_and_skip()
				d.add_child(cam)
