extends Control


func _init_segment(_segment_info:Array)->void:
	pivot_offset=size*Vector2(0.5,1.0)
	$VBox/Images.texture=load("res://Assets/Images/Emotions/"+_segment_info[0]+".png")
	$VBox/Label.text=_segment_info[1]
	$VBox/Button.text=_segment_info[2]


func appear_anim()->void:
	Globals.emit_signal("SFX","A")
	scale=Vector2(0.5,0.5)
	modulate.a=0.0
	var _tween:Tween=create_tween().set_parallel(true)
	_tween.tween_property(self,"scale",Vector2(1.0,1.0),0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self,"modulate:a",1.0,0.3)
	
func disappear_anim()->void:
	var _tween:Tween=create_tween().set_parallel(true)
	_tween.tween_property(self,"scale",Vector2(0.0,0.0),0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	_tween.tween_property(self,"modulate:a",0,0.3)
	_tween.tween_callback(queue_free).set_delay(0.3)


func _on_button_pressed() -> void:
	Globals.emit_signal("SFX","B")
	Globals.emit_signal("NextSegment")
