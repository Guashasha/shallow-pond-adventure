extends Control

const MAX_PLAYERS = 4

var port = 8989
var ip = "127.0.0.1"

var peer
var connected_players = {}

func _ready():
    multiplayer.peer_connected.connect(connect_peer)
    multiplayer.peer_disconnected.connect(disconnect_peer)
    multiplayer.connected_to_server.connect(connect_to_server)
    multiplayer.connection_failed.connect(handle_failed_connection)

func connect_peer(id):
    pass

func disconnect_peer(id):
    pass

func connect_to_server():
    pass

func handle_failed_connection():
    pass

func _on_create_game_button_pressed():
    peer = ENetMultiplayerPeer.new()

    var err = peer.create_server(port, MAX_PLAYERS)
    if err != OK:
        # loggear error
        print("error al crear server: ", err)
        return
    
    peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
    multiplayer.set_multiplayer_peer(peer)