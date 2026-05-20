# Copyright (C) 2026 Igor Spichkin
# SPDX-License-Identifier: MPL-2.0

extends Node

const SETTINGS_FILE := "user://settings.cfg"
const INPUT_SECTION := "input"

var invert_mouse_rotation: bool = true
var invert_trackpad_zoom: bool = true

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

		invert_mouse_rotation = config.get_value(INPUT_SECTION, "invert_mouse_rotation", true)

func save_settings() -> void:
	var config = ConfigFile.new()
	
	for action in InputMap.get_actions():
		var events = InputMap.action_get_events(action)
		var events_str = var_to_str(events)
		
		config.set_value(INPUT_SECTION, action, events_str)

	config.set_value(INPUT_SECTION, "invert_mouse_rotation", invert_mouse_rotation)

	config.save(SETTINGS_FILE)

func reset_to_defaults() -> void:
	DirAccess.remove_absolute(SETTINGS_FILE)

	get_tree().quit()
