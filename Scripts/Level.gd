extends Spatial

signal level_changed(level_name)

	
#On play pressed
func _on_Button_pressed():
	emit_signal("level_changed", self.name)


func _on_TapToStart_pressed():
	emit_signal("level_changed", self.name)


func _on_powrotDoMenu_pressed():
	emit_signal("level_changed", self.name)
