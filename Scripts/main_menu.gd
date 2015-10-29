extends Node2D

# member variables here, example:
var http
var thread
var global

func _ready():
	OS.set_window_fullscreen(true)
	
	var version_file = File.new()
	version_file.open("res://version.txt", File.READ)
	version_file.get_line()
	var version = version_file.get_line()
	
	global = get_node("/root/global")
	global.menu = get_node(".")
	
	set_process_input(true)
	#thread = Thread.new()
	
	#thread.start(self, "get_version_info", "asdf")
	
	pass

func get_version_info(var input):
	http = HTTPClient.new()
	
	var err = http.connect("2catstudios.github.io", 80)
	
	while( http.get_status()==HTTPClient.STATUS_CONNECTING or http.get_status()==HTTPClient.STATUS_RESOLVING):
		http.poll()
		OS.delay_msec(100)
	
	assert(http.get_status() == HTTPClient.STATUS_CONNECTED) # Could not connect
	
	err = http.request(HTTPClient.METHOD_GET,"/UnityMusicPlayer/Stable/VersionInfo.txt", [])
	
	while (http.get_status() == HTTPClient.STATUS_REQUESTING):
		# Keep polling until the request is going on
		http.poll()
		OS.delay_msec(500)
	
	var text = ""
	
	if (http.has_response()):
		var array = RawArray()
		
		http.poll()
		
		while (http.get_status()==HTTPClient.STATUS_BODY):
			http.poll()
			var chunk = http.read_response_body_chunk()
			if (chunk.size()==0):
				OS.delay_msec(100)
			else:
				text = chunk.get_string_from_utf8()
	print(text)
	
	pass

func _input(ev):
	var menu = get_node("menu/main_menu")
	if ev.type == 1 and ev.is_pressed() and not ev.echo and not menu.is_hidden():
		if ev.is_action("ui_accept"):
			_on_menu_button_selected(get_node("menu/main_menu").get_selected())
		if ev.is_action("ui_down"):
			menu.set_selected(menu.get_selected()+1)
		if ev.is_action("ui_up"):
			menu.set_selected(menu.get_selected()-1)
	
	pass

func game_over(death_note):
	get_node("menu/main_menu").show()
	get_node("menu/death_note").show()
	get_node("menu/death_note").set_text(death_note)
	get_node("menu/death_note").set_percent_visible(1)
	pass
