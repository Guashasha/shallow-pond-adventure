extends Control

const MAX_PLAYERS = 4

var port = 8989
var ip = "127.0.0.1"

var peer
var connected_players: Dictionary = {}

func _ready():
    multiplayer.peer_connected.connect(connect_peer)
    multiplayer.peer_disconnected.connect(disconnect_peer)
    multiplayer.connected_to_server.connect(connect_to_server)
    multiplayer.connection_failed.connect(handle_failed_connection)

func connect_peer(id):
    if !connected_players.has(id):
        #connected_players[id] = 
        Logger.info("peer with id " + id + " connected.")

func disconnect_peer(id):
    if connected_players.has(id):
        connected_players.erase(id)
        Logger.info("peer with id " + id + " disconnected.")

func connect_to_server():
    pass

func handle_failed_connection():
    pass

func _on_create_game_button_pressed():
    peer = ENetMultiplayerPeer.new()

    var err: int = peer.create_server(port, MAX_PLAYERS)
    if err != OK:
        Logger.error("Error occurred while creating a server: ", err)
        return
    
    peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
    multiplayer.set_multiplayer_peer(peer)
    Logger.info("Server created successfully")