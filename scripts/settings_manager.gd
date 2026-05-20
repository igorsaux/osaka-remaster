# Copyright (C) 2026 Igor Spichkin
# SPDX-License-Identifier: MPL-2.0

extends Node

const SETTINGS_FILE := "user://settings.cfg"
const INPUT_SECTION := "input"

var invert_mouse_rotation: bool = false
var invert_trackpad_zoom: bool = false
var trackpad_pinch_sens: float = 5.0
var trackpad_scroll_sens: float = 0.5
var zoom_smoothness: float = 10.0
var pad_h_sens: float = 50.0
var pad_v_sens: float = 25.0
var pad_zoom_speed: float = 50.0
var mouse_h_sens: float = 0.1
var mouse_v_sens: float = 0.1
var mouse_zoom_speed: float = 2.0

func _ready() -> void:
	load_settings()

func load_settings() -> void:
	var config = ConfigFile.new()

	if config.load(SETTINGS_FILE) != OK:
		return

	if config.has_section(INPUT_SECTION):
		for action in config.get_section_keys(INPUT_SECTION):
			if not InputMap.has_action(action):
				continue

			var events_str = config.get_value(INPUT_SECTION, action)
			var events = str_to_var(events_str)

			if events is Array:
				InputMap.action_erase_events(action)

				for event in events:
					InputMap.action_add_event(action, event)

	invert_mouse_rotation = config.get_value(INPUT_SECTION, "invert_mouse_rotation", false)
	invert_trackpad_zoom = config.get_value(INPUT_SECTION, "invert_trackpad_zoom", false)
	trackpad_pinch_sens = config.get_value(INPUT_SECTION, "trackpad_pinch_sens", 5.0)
	trackpad_scroll_sens = config.get_value(INPUT_SECTION, "trackpad_scroll_sens", 0.5)
	zoom_smoothness = config.get_value(INPUT_SECTION, "zoom_smoothness", 10.0)
	pad_h_sens = config.get_value(INPUT_SECTION, "pad_h_sens", 50.0)
	pad_v_sens = config.get_value(INPUT_SECTION, "pad_v_sens", 25.0)
	pad_zoom_speed = config.get_value(INPUT_SECTION, "pad_zoom_speed", 50.0)
	mouse_h_sens = config.get_value(INPUT_SECTION, "mouse_h_sens", 0.1)
	mouse_v_sens = config.get_value(INPUT_SECTION, "mouse_v_sens", 0.1)
	mouse_zoom_speed = config.get_value(INPUT_SECTION, "mouse_zoom_speed", 2.0)

func save_settings() -> void:
	var config = ConfigFile.new()
	
	for action in InputMap.get_actions():
		var events = InputMap.action_get_events(action)
		var events_str = var_to_str(events)
		
		config.set_value(INPUT_SECTION, action, events_str)

	config.set_value(INPUT_SECTION, "invert_mouse_rotation", invert_mouse_rotation)
	config.set_value(INPUT_SECTION, "invert_trackpad_zoom", invert_trackpad_zoom)
	config.set_value(INPUT_SECTION, "trackpad_pinch_sens", trackpad_pinch_sens)
	config.set_value(INPUT_SECTION, "trackpad_scroll_sens", trackpad_scroll_sens)
	config.set_value(INPUT_SECTION, "zoom_smoothness", zoom_smoothness)
	config.set_value(INPUT_SECTION, "pad_h_sens", pad_h_sens)
	config.set_value(INPUT_SECTION, "pad_v_sens", pad_v_sens)
	config.set_value(INPUT_SECTION, "pad_zoom_speed", pad_zoom_speed)
	config.set_value(INPUT_SECTION, "mouse_h_sens", mouse_h_sens)
	config.set_value(INPUT_SECTION, "mouse_v_sens", mouse_v_sens)
	config.set_value(INPUT_SECTION, "mouse_zoom_speed", mouse_zoom_speed)

	config.save(SETTINGS_FILE)

func reset_to_defaults() -> void:
	DirAccess.remove_absolute(SETTINGS_FILE)

	get_tree().quit()
