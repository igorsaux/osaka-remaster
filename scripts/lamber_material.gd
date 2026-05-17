@tool
class_name LambertMaterial
extends ShaderMaterial

@export var albedo_color: Color = Color.WHITE:
	set(value):
		albedo_color = value
		set_shader_parameter("albedo_color", value)

@export var albedo_texture: Texture2D:
	set(value):
		albedo_texture = value
		set_shader_parameter("albedo_texture", value)

@export_group("Mirror")
@export var mirror_x: bool = false:
	set(value):
		mirror_x = value
		set_shader_parameter("mirror_x", value)

@export var mirror_y: bool = false:
	set(value):
		mirror_y = value
		set_shader_parameter("mirror_y", value)

@export_group("Transparency")
@export var use_alpha_scissor: bool = false:
	set(value):
		use_alpha_scissor = value
		set_shader_parameter("use_alpha_scissor", value)

@export_range(0.0, 1.0) var alpha_scissor_threshold: float = 0.5:
	set(value):
		alpha_scissor_threshold = value
		set_shader_parameter("alpha_scissor_threshold", value)

func _init() -> void:
	if not shader:
		shader = preload("res://shaders/lambert.gdshader")
	
	_update_shader_params()

func _update_shader_params() -> void:
	set_shader_parameter("albedo_color", albedo_color)
	set_shader_parameter("albedo_texture", albedo_texture)
	set_shader_parameter("mirror_x", mirror_x)
	set_shader_parameter("mirror_y", mirror_y)
	set_shader_parameter("use_alpha_scissor", use_alpha_scissor)
	set_shader_parameter("alpha_scissor_threshold", alpha_scissor_threshold)
