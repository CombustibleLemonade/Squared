extends Node

signal version_got(version)

var latest_version # latest version available

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
