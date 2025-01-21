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
    Logger.warn("unable to connect to server")

func _on_connect_button_pressed():
    game_manager.username = get_node("NameTextBox").text
    game_manager.ip = get_node("IPTextBox").text
    
    if game_manager.username.is_empty():
        return
    else: if game_manager.ip.is_empty():
        return
    
    game_manager.peer = ENetMultiplayerPeer.new()

    var err: int = game_manager.peer.create_client(game_manager.ip, game_manager.port)
    if err != OK:
        Logger.error("Error occurred while creating a client: ", err)
        return
    
    game_manager.peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
    multiplayer.set_multiplayer_peer(game_manager.peer)