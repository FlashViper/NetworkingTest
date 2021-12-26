extends Control

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "onPeerConnect")

func onPeerConnect(id: int) -> void:
	var label := Label.new()
	$VBoxContainer.add_child(label)
	label.text = str(id)
