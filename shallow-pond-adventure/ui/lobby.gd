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

@rpc("any_peer", "call_local")
func start_game():
	var scene = load("res://ui/game.tscn")
	get_tree().root.add_child(scene)
	self.hide()
	
func share_connected_players_to_client(client_id: int):
	pass

func _on_create_game_button_pressed():
	game_manager.username = $MarginContainer/HBoxContainer/VBoxContainer/NameTextBox.text
	if game_manager.username.is_empty():
		Logger.info("User left username field empty while trying to create a server")
		return

	game_manager.ip = get_local_ip()
	game_manager.ip = "192.0.0.1"
	set_ip_label(game_manager.ip)

	game_manager.peer = ENetMultiplayerPeer.new()

	var err: int = game_manager.peer.create_server(game_manager.port, MAX_PLAYERS)
	if err != OK:
		Logger.error("Error occurred while creating a server: ", err)
		return
	
	game_manager.peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(game_manager.peer)
	toggle_buttons_state()
	Logger.info("Server created successfully")
	
func toggle_buttons_state():
	var visibility = true
	var enable = false

	if $MarginContainer/HBoxContainer/VBoxContainer/PrimaryButtonsContainer/StartServerButton.visible:
		visibility = false
		enable = true

	$MarginContainer/HBoxContainer/VBoxContainer/PrimaryButtonsContainer/StartServerButton.visible = visibility
	$MarginContainer/HBoxContainer/VBoxContainer/PrimaryButtonsContainer/StartServerButton.disabled = enable
	$MarginContainer/HBoxContainer/VBoxContainer/PrimaryButtonsContainer/StartGameButton.visible = !visibility
	$MarginContainer/HBoxContainer/VBoxContainer/PrimaryButtonsContainer/StartGameButton.disabled = !enable
	$MarginContainer/HBoxContainer/VBoxContainer/StopServerButton.disabled = !enable
	
func _on_stop_server_button_pressed():
	game_manager.clear_connection_data()
	toggle_buttons_state()

func get_local_ip() -> String:
	for ip in IP.get_local_addresses():
		if ip.begins_with("10.") or ip.begins_with("172.16.") or ip.begins_with("192.168."):
			return ip
		
	Logger.warn("local IP not found")
	return "Error getting IP"

func set_ip_label(ip: String):
	$MarginContainer/HBoxContainer/VBoxContainer/IPLabel.text = "Your IP: " + ip


func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")


func _on_start_game_button_pressed():
	start_game.rpc()
