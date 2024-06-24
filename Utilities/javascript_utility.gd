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
		input.setAttribute("accept", "image/png, image/jpeg, image/webp");
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


func save_image(image : Image, fileName : String = "export.png") -> void:
	if OS.get_name() != "Web":
		push_error("Error: cannot export png from platforms other than web")
		return

	image.clear_mipmaps()
	var buffer : PackedByteArray = image.save_png_to_buffer()
	JavaScriptBridge.download_buffer(buffer, fileName)
