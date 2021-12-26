extends Control
var index = 0
func _ready() -> void:
	var ips := IP.get_local_addresses()
	$CanvasLayer/LabelIP.text = str(ips[index])
	
	get_tree().connect("network_peer_connected", self, "playerConnected")

func playerConnected(id: int) -> void:
	print(id)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed() and event.scancode == KEY_SPACE:
			index += 1
			var ips := IP.get_local_addresses()
			if index > ips.size() - 1: index = 0
			$CanvasLayer/LabelIP.text = str(ips[index])

func _on_copy_button_down() -> void:
	OS.clipboard = $CanvasLayer/LabelIP.text
