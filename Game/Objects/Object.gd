extends CharacterBody2D
class_name ClassObject

const object_scene = preload("res://Game/Objects/object.tscn")
var object_name : String

func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

static func new_object(object_name : String) -> Object:
	var object = object_scene.instantiate()
	object.object_name = object_name
	return ClassObject
	
	
	
