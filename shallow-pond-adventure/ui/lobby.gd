extends Control

const MAX_PLAYERS = 4

var game_manager = GameManager.new()

func _ready():
	multiplayer.peer_connected.connect(connect_peer)
	multiplayer.peer_disconnected.connect(disconnect_peer)
	multiplayer.connected_to_server.connect(connect_to_server)
	multiplayer.connection_failed.connect(handle_failed_connection)

func connect_peer(id):
	if !game_manager.connected_players.has(id):
		#game_manager.connected_players[id] = 
		Logger.info("peer with id " + str(id) + " connected.")

func disconnect_peer(id):
	if game_manager.connected_players.has(id):
		game_manager.connected_players.erase(id)
		Logger.info("peer with id " + str(id) + " disconnected.")

func connect_to_server():
	pass

func handle_failed_connection():
	Logger.warn("unable to connect to server: " + game_manager.ip)
	
func share_connected_players_to_client(client_id: int):
	pass

func _on_create_game_button_pressed():
	game_manager.username = $MarginContainer/HBoxContainer/VBoxContainer/NameTextBox.text
	game_manager.peer = ENetMultiplayerPeer.new()

	var err: int = game_manager.peer.create_server(game_manager.port, MAX_PLAYERS)
	if err != OK:
		Logger.error("Error occurred while creating a server: ", err)
		return
	
	game_manager.peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(game_manager.peer)
	Logger.info("Server created successfully")
	
func _on_stop_server_button_pressed():
	$InformationPopup.popup()
