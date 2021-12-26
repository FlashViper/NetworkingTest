class_name Player

# Identifiers
var id : int
var name : String

# Important things
var position : Vector2
var velocity : Vector2
var acceleration : Vector2

# Visual things
var rotation : float

func _init(pName := "Bob") -> void:
	name = pName
