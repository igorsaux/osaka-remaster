@tool
class_name LambertTransparentMaterial
extends ShaderMaterial

@export var albedo_color: Color = Color.WHITE:
	set(value):
		albedo_color = value
		set_shader_parameter("albedo_color", value)

@export var albedo_texture: Texture2D:
	set(value):
		albedo_texture = value
		set_shader_parameter("albedo_texture", value)

func _init() -> void:
	if not shader:
		shader = preload("res://shaders/lambert_transparent.gdshader")
	
	_update_shader_params()

func _update_shader_params() -> void:
	set_shader_parameter("albedo_color", albedo_color)
	set_shader_parameter("albedo_texture", albedo_texture)
