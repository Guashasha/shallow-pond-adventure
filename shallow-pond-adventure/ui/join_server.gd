extends Control

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
	Logger.info("unable to connect to server")

func _on_connect_button_pressed():
	game_manager.username = $MarginContainer/HBoxContainer/MainButtonsContainer/NameTextBox.text
	game_manager.ip = $MarginContainer/HBoxContainer/MainButtonsContainer/IPTextBox.text
	
	if game_manager.username.is_empty():
		Logger.info("User left username field empty while trying to join a server")
		return
	elif game_manager.ip.is_empty():
		Logger.info("User left ip field empty while trying to join a server")
		return
	elif !game_manager.ip.is_valid_ip_address():
		Logger.info("IP is not valid: " + game_manager.ip)
		return
	
	game_manager.peer = ENetMultiplayerPeer.new()

	var err: int = game_manager.peer.create_client(game_manager.ip, game_manager.port)
	if err != OK:
		Logger.error("Error occurred while creating a client: ", err)
		return
	
	game_manager.peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(game_manager.peer)
	toggle_buttons()
	Logger.info("Connected to server successfully")

func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")

func _on_disconnect_button_pressed():
	if game_manager.peer.get_connection_status() == MultiplayerPeer.ConnectionStatus.CONNECTION_DISCONNECTED:
		Logger.info("There was a problem reaching the server, you are disconnected from the server")

	game_manager.clear_connection_data()
	toggle_buttons()
	Logger.info("Disconnected from server")

func toggle_buttons():
	var button_is_visible = true
	var button_is_disabled = false
	
	if $MarginContainer/HBoxContainer/MainButtonsContainer/PanelContainer/ConnectButton.visible:
		button_is_visible = false
		button_is_disabled = true
	
	$MarginContainer/HBoxContainer/MainButtonsContainer/PanelContainer/ConnectButton.visible = button_is_visible
	$MarginContainer/HBoxContainer/MainButtonsContainer/PanelContainer/ConnectButton.disabled = button_is_disabled
	$MarginContainer/HBoxContainer/MainButtonsContainer/PanelContainer/DisconnectButton.visible = !button_is_visible
	$MarginContainer/HBoxContainer/MainButtonsContainer/PanelContainer/DisconnectButton.disabled = !button_is_disabled
