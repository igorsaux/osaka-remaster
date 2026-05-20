# Copyright (C) 2026 Igor Spichkin
# SPDX-License-Identifier: MPL-2.0

extends Camera3D
class_name FixedOrbitCamera

@export_group("Rotation Limits")
@export_range(-180, 180, 0.1, "degrees") var x_rot_min: float = -89.0
@export_range(-180, 180, 0.1, "degrees") var x_rot_max: float = 89.0

@export_range(-180, 180, 0.1, "degrees") var y_rot_min: float = -180.0
@export_range(-180, 180, 0.1, "degrees") var y_rot_max: float = 180.0

@export_group("Zoom Limits")
@export_range(1.0, 170.0, 0.1, "degrees") var fov_min: float = 10.0
@export_range(1.0, 170.0, 0.1, "degrees") var fov_max: float = 90.0

var _curr_x: float = 0.0
var _curr_y: float = 0.0

var _target_fov: float = 70.0

func _ready() -> void:
	_curr_x = rotation_degrees.x
	_curr_y = rotation_degrees.y
	
	_target_fov = clampf(fov, fov_min, fov_max)
	fov = _target_fov

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action(GameInputs.CAM_ZOOM_IN) and event.is_pressed():
		_target_fov -= SettingsManager.mouse_zoom_speed
		_target_fov = clampf(_target_fov, fov_min, fov_max)
		
	if event.is_action(GameInputs.CAM_ZOOM_OUT) and event.is_pressed():
		_target_fov += SettingsManager.mouse_zoom_speed
		_target_fov = clampf(_target_fov, fov_min, fov_max)

	if event is InputEventMagnifyGesture:
		var zoom_delta = (event.factor - 1.0) * SettingsManager.trackpad_pinch_sens

		_target_fov -= zoom_delta
		_target_fov = clampf(_target_fov, fov_min, fov_max)

	if event is InputEventPanGesture:
		var scroll_delta = event.delta.y * SettingsManager.trackpad_scroll_sens

		if SettingsManager.invert_trackpad_zoom:
			_target_fov -= scroll_delta
		else:
			_target_fov += scroll_delta

		_target_fov = clampf(_target_fov, fov_min, fov_max)

	if event is InputEventMouseMotion:
		if Input.is_action_pressed(GameInputs.CAM_ROTATE_HOLD):
			var zoom_compensation = fov / fov_max
			var delta_y = event.relative.x * SettingsManager.mouse_h_sens * zoom_compensation
			var delta_x = event.relative.y * SettingsManager.mouse_v_sens * zoom_compensation

			if SettingsManager.invert_mouse_rotation:
				_curr_y -= delta_y
				_curr_x -= delta_x
			else:
				_curr_y += delta_y
				_curr_x += delta_x

			_apply_rotation_limits()

func _process(delta: float) -> void:
	if !is_equal_approx(fov, _target_fov):
		fov = lerpf(fov, _target_fov, minf(1.0, SettingsManager.zoom_smoothness * delta))

	var pad_x = Input.get_axis(GameInputs.CAM_ROT_LEFT, GameInputs.CAM_ROT_RIGHT)
	var pad_y = Input.get_axis(GameInputs.CAM_ROT_UP, GameInputs.CAM_ROT_DOWN)

	if pad_x != 0.0 or pad_y != 0.0:
		var zoom_compensation = fov / fov_max

		_curr_y -= pad_x * SettingsManager.pad_h_sens * delta * zoom_compensation
		_curr_x -= pad_y * SettingsManager.pad_v_sens * delta * zoom_compensation
		_apply_rotation_limits()

	var pad_zoom = Input.get_axis(GameInputs.CAM_ZOOM_IN, GameInputs.CAM_ZOOM_OUT)

	if pad_zoom != 0.0:
		_target_fov += pad_zoom * SettingsManager.pad_zoom_speed * delta
		_target_fov = clampf(_target_fov, fov_min, fov_max)

func _apply_rotation_limits() -> void:
	_curr_x = clampf(_curr_x, x_rot_min, x_rot_max)
	_curr_y = clampf(_curr_y, y_rot_min, y_rot_max)

	rotation_degrees = Vector3(_curr_x, _curr_y, rotation_degrees.z)
