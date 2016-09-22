extends Node

signal version_got(version)
signal start_game(setup)
signal player_connected(id)

var latest_version # latest version available

var host
var players = [1]

var DEFAULT_PORT = 1234

# Gets version info
func get_version_info(adress):
	var data = get_file("combustiblelemonade.github.io", "/sq_version.txt")
	
	data = data.split('\n')
	for i in data:
		if i.find("version") != -1:
			data = i
			break
	
	data = data.split("version")[1]
	data = data.split('"')[1]
	latest_version = data
	
	emit_signal("version_got", data)

# Gets a file from the internet using http
func get_file(adress, path):
	var err = 0
	
	var http = HTTPClient.new()
	err = http.connect("combustiblelemonade.github.io", 80)
	
	assert err == OK
	
	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		OS.delay_msec(10)
	
	err = http.request(HTTPClient.METHOD_GET, "/sq_version.txt", [])
	
	assert err == OK
	
	while http.get_status() == HTTPClient.STATUS_REQUESTING:
		http.poll()
		OS.delay_msec(10)
	
	var data = http.read_response_body_chunk().get_string_from_ascii()
	return data

## MULTIPLAYER ##

# Hosts a game
func host():
	host = NetworkedMultiplayerENet.new()
	host.create_server(1234, 2)
	get_tree().set_network_peer(host)
	get_tree().connect("network_peer_connected", self, "player_connected")
	get_tree().connect("network_peer_disconnected", self, "player_disconnected")

# Joins into a game
func join(ip):
	host = NetworkedMultiplayerENet.new()
	host.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(host)

# Gets called when a player connects to the game
func player_connected(id):
	rpc("add_to_player_list", id)
	rpc_id(id, "set_player_list", players)
	
	emit_signal("player_connected", id)

# Gets called when a player disconnects from the game
func player_disconnected(id):
	rpc("remove_from_player_list", id)

# Appends a new player to the list
sync func add_to_player_list(id):
	players.push_back(id)

# Removes a player from the list
sync func remove_from_player_list(id):
	players.erase(id)

# Updates entire list
remote func set_player_list(list):
	players = list

# Starts the game
sync func start_game(setup):
	emit_signal("start_game", setup)
