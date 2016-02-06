extends Node

var version = ""

var version_check_thread = Thread.new()
var get_version_thread = Thread.new()

func _ready():
	get_node("/root/http").connect("version_got", self, "on_version_received")
	version_check_thread.start(get_node("/root/http"), "get_version_info", null)
	get_version_thread.start(self, "get_version", null)

# Function called when the version is received
func on_version_received(version_received):
	pass

# Gets the version we're currently running
func get_version():
	pass

# Parses a config file to get version info
func parse_version_info():
	pass
