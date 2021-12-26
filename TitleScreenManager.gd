extends Node2D

export (NodePath) var joinIp
export (NodePath) var playerNameHost
export (NodePath) var playerNameJoin

func _ready() -> void:
	$"CanvasLayer/MarginContainer/HBoxContainer/MarginContainer/HostPanel/VBoxContainer/Host".connect(
		"pressed", self, "onHostPressed"
	)
	
	$"CanvasLayer/MarginContainer/HBoxContainer/MarginContainer/JoinPanel/MarginContainer/VBoxContainer/Join".connect(
		"pressed", self, "onJoinPressed"
	)

func hostPopup() -> void:
	$"CanvasLayer/MarginContainer/HBoxContainer/MarginContainer/HostPanel".popup_centered()

func joinPopup() -> void:
	$"CanvasLayer/MarginContainer/HBoxContainer/MarginContainer/JoinPanel".popup_centered()

func onHostPressed() -> void:
	Server.playerName = get_node(playerNameHost).text
	Server.initServer()

func onJoinPressed() -> void:
	var ip = get_node(joinIp).text
	Server.playerName = get_node(playerNameJoin).text
	Server.initClient(ip)
