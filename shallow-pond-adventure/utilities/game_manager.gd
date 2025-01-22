class_name GameManager

var username = ""

var port = 8989
var ip = ""

var peer = null
var connected_players: Dictionary = {}

func clear_connection_data():
	ip = ""
	username = ""
	peer.close()
	connected_players = {}
