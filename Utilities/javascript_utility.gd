extends Node


### Adapted from https://github.com/Pukkah/HTML5-File-Exchange-for-Godot
### with thanks to Pukkah and yiyuezhuo


signal read_completed
signal load_completed(image : Image)

var js_callback = JavaScriptBridge.create_callback(load_handler)
var js_interface : JavaScriptObject


func _ready() -> void:
	if OS.get_name() == "Web":
		_define_js()
		js_interface = JavaScriptBridge.get_interface("_HTML5FileExchange");


func _define_js() -> void:
	#Define JS script
	JavaScriptBridge.eval("""
	var _HTML5FileExchange = {};
	_HTML5FileExchange.upload = function(gd_callback) {
		canceled = true;
		var input = document.createElement('INPUT'); 
		input.setAttribute("type", "file");
		input.setAttribute("accept", "image/png, image/jpeg, image/webp, application/json");
		input.click();
		input.addEventListener('change', event => {
			if (event.target.files.length > 0){
				canceled = false;}
			var file = event.target.files[0];
			var reader = new FileReader();
			this.fileType = file.type;
			// var fileName = file.name;
			reader.readAsArrayBuffer(file);
			reader.onloadend = (evt) => { // Since here's it's arrow function, "this" still refers to _HTML5FileExchange
				if (evt.target.readyState == FileReader.DONE) {
					this.result = evt.target.result;
					gd_callback(); // It's hard to retrieve value from callback argument, so it's just for notification
				}
			}
		  });
	}
	""", true)


func load_handler(_args):
	emit_signal("read_completed")


func load_image() -> Image:
	if OS.get_name() != "Web":
		push_error\
				("Error: uploads only available in web builds "
				+ "with JavaScript enabled")
		return null

	js_interface.upload(js_callback)
	await read_completed

	var imageType : String = js_interface.fileType 
	var imageData : Variant = JavaScriptBridge.eval\
			("_HTML5FileExchange.result", true) # interface doesn't work as expected for some reason

	var image : Image = Image.new()
	var image_error : Error
	match imageType:
		"image/png":
			image_error = image.load_png_from_buffer(imageData)
		"image/jpeg":
			image_error = image.load_jpg_from_buffer(imageData)
		"image/webp":
			image_error = image.load_webp_from_buffer(imageData)
		var invalidType:
			push_error("Error: unsupported file format %s." % invalidType)
			return null

	if image_error:
		push_error("Error: an error occurred while trying to display the image")
		return null

	return image


func load_preset() -> Dictionary:
	if OS.get_name() != "Web":
		push_error\
				("Error: uploads only available in web builds "
				+ "with JavaScript enabled")
		return {}

	js_interface.upload(js_callback)
	await read_completed

	var data_type : String = js_interface.fileType 
	var json_data : Variant = JavaScriptBridge.eval\
			("_HTML5FileExchange.result", true) # interface doesn't work as expected for some reason

	if data_type != "application/json":
		push_error("Error: file not of type .json")
		return {}

	json_data = json_data as PackedByteArray
	if json_data == null:
		push_error("Error: .json file cannot be parsed")
		return {}
	var json_string : String = json_data.get_string_from_utf8()

	var json : JSON = JSON.new()
	var error : Error = json.parse(json_string)
	if error == Error.OK:
		if typeof(json.data) != TYPE_DICTIONARY:
			push_error("Error: JSON data cannot be parsed as dictionary")
			return {}
		return json.data
	else:
		push_error\
				("JSON Parse Error: ", json.get_error_message(), " in ",
				json_string, " at line ", json.get_error_line())

	return {}


func save_image(image : Image, file_name : String = "export.png") -> void:
	if OS.get_name() != "Web":
		push_error("Error: cannot export png from platforms other than web")
		return

	image.clear_mipmaps()
	var buffer : PackedByteArray = image.save_png_to_buffer()
	file_name = "%s.png" % file_name if file_name != "export.png" else file_name
	JavaScriptBridge.download_buffer(buffer, file_name.validate_filename())


func save_preset(preset : Dictionary) -> void:
	if OS.get_name() != "Web":
		push_error("Error: cannot export preset from platforms other than web")
		return

	var file_name : String = preset["preset_name"].to_snake_case()
	file_name = file_name.validate_filename()

	var json : String = JSON.stringify(preset)
	var buffer : PackedByteArray = json.to_utf8_buffer()
	JavaScriptBridge.download_buffer\
			(buffer, "%s.json" % file_name, "application/json")
