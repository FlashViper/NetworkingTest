class_name ServerMain extends Node

const DEFAULT_PORT := 10567

# Game Data
var players := {}
var playerName := "Billy"

func _ready() -> void:
	get_tree().connect("connected_to_server", self, "onConnect")
	get_tree().connect("connection_failed", self, "onConnectFail")
	get_tree().connect("network_peer_connected", self, "onPeerConnect")
	get_tree().connect("network_peer_disconnected", self, "onPeerDisconnect")

func initServer()->void:
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_server(DEFAULT_PORT, 9)
	if err != OK:
		printerr("you a jellyfish", err)
		return
	get_tree().set_network_peer(peer)
	get_tree().change_scene("res://PlayerJoinds.tscn")
	get_tree().root.add_child(preload("res://HostWaitRoom.tscn").instance())
	createPlayer(playerName, 1)

func initClient(ip: String) -> void:
	var peer = NetworkedMultiplayerENet.new()
	if not ip.is_valid_ip_address():
		printerr("invalid ip %s" % [ip])
	var _err = peer.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(peer)

func onConnect() -> void:
	print("YAY!")
	get_tree().change_scene("res://PlayerJoinds.tscn")
	createPlayer(playerName, get_tree().network_peer.get_unique_id())

func onConnectFail() -> void:
	print("whaaaa")

func onPeerConnect(id : int) -> void:
#	tel the player who we are
	rpc_id(id, "addPlayer", playerName)

remote func addPlayer(name : String) -> void:
	var id := get_tree().get_rpc_sender_id()
	if players.has(id):
		print("EXISTS IM SO TIRED")
		return
#	print("Recieved player ", name)
	createPlayer(name, id)

func createPlayer(name: String, id: int) -> void:
	players[id] = Player.new(name)
	players[id].id = id
	players[id].position = get_viewport().size * Vector2(randf(), randf())

func onPeerDisconnect(id:int)-> void:
	pass
