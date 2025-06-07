extends Node2D

var intensity : int = 1
var iks : bool = false

func _ready() -> void:
	play()

func play():
	var active_layers = intensity % 10 + 1
	for number in range(active_layers):
		get_node("AudioStreamPlayer" + str(number+1)).play()
	if iks:
		$AudioStreamPlayer11.play()


func _on_audio_stream_player_2_finished() -> void:
	intensity = get_node("/root/Game/Control/Map").get_intensity()
	iks = get_node("/root/Game/Control/Map").has_x()
	play()
