extends VBoxContainer


@export var available_tracks_settings : VBoxContainer
@export var track_buttons : Array[CheckBox]
@export var track_streams : Array[AudioStreamPlayer]

var curr_track_index : int = 0


func set_music_enabled(new_state : bool) -> void:
	available_tracks_settings.visible = new_state

	if new_state:
		track_streams[curr_track_index].play()
	else:
		track_streams[curr_track_index].stop()


func set_stream(new_state : bool, new_index : int) -> void:
	if !new_state:
		track_streams[curr_track_index].stop()
		return

	if new_index != curr_track_index:
		track_streams[curr_track_index].stop()
		track_buttons[curr_track_index].button_pressed = false
		curr_track_index = new_index

	track_streams[curr_track_index].play()
