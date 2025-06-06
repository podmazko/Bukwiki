extends Control

var PartA:PackedScene=preload("res://Scenes/Parts/RepairPartA.tscn")
var PartB:PackedScene=preload("res://Scenes/Parts/RepairPartB.tscn")

@onready var Uno:Sprite2D=$Uno
var _light_mat:Material=preload("res://Assets/Shaders/Light.tres")
var _light_text:Texture=preload("res://Assets/Images/Segments/Repairing/Light.png")
@onready var _light_nodes:=[$Uno/Light1, $Uno/Light2, $Uno/Light3, $Uno/Light4, $Uno/Light5]

@onready var Hflow:HFlowContainer=$HFlow
@onready var Hbox:HBoxContainer=$Hbox


func _init_segment(_segment_info_words:Array)->void:
	Uno.scale=Vector2(0,0)
	
	LevelCounter=_segment_info_words.size()
	
	for i in _segment_info_words:
		#init word
		var _inst:Label=PartA.instantiate()
		_inst._init_repair_partA(i)
		Hflow.add_child(_inst)
		_inst.mouse_entered.connect(Globals._hover_image.bind(_inst))
		_inst.mouse_exited.connect(Globals._hover_image_exit)
		_inst.gui_input.connect(object_input.bind(_inst))
		_inst.modulate.a=0
		
	var _shuffled:Array=_segment_info_words.duplicate()
	_shuffled.shuffle()
	for i in _shuffled:
		#init letter
		var _instL:TextureRect=PartB.instantiate()
		_instL._init_repair_partB(i)
		Hbox.add_child(_instL)
		_instL.mouse_entered.connect(Globals._hover_image.bind(_instL))
		_instL.mouse_exited.connect(Globals._hover_image_exit)
		_instL.gui_input.connect(object_input.bind(_instL))
		_instL.modulate.a=0


func appear_anim()->void:
	var _tween:Tween=create_tween().set_parallel(true)
	_tween.tween_callback(Globals.emit_signal.bind("ShowMessage","Ой, только провода перепутались\nСможешь подключить?","Fear",Vector2(0.5,0)) )\
				.set_delay(1)

	var _delay:=0.0
	for _word in Hflow.get_children():
		_tween.tween_property(_word,"scale",Vector2(1.0,1.0),1.3).set_delay(_delay)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.4,0.4))
		_tween.tween_property(_word,"modulate:a",1.0,0.3).set_delay(_delay)
		_tween.tween_callback(Globals.emit_signal.bind("SFX","B")).set_delay(_delay)
		_delay+=0.05
	
	_delay+=0.05
	for _letter in Hbox.get_children():
		_tween.tween_property(_letter,"modulate:a",1.0,0.3).set_delay(_delay)
		_tween.tween_property(_letter,"position:y",_letter.position.y,1.3).set_delay(_delay)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(_letter.position.y+200)
		_tween.tween_callback(Globals.emit_signal.bind("SFX","B")).set_delay(_delay)
		_delay+=0.05
	
	_delay+=0.2
	_tween.tween_property(Uno,"scale",Vector2(1.0,1.0),1.3).set_delay(_delay)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.4,0.4))
	_tween.tween_callback(Globals.emit_signal.bind("SFX","A")).set_delay(_delay)




var LevelCounter:int
func object_input(event:InputEvent,object)->void:
	if event.is_pressed():
		var _obj_class:String=object.get_class()
		var _tween:Tween=create_tween().set_parallel(true)
		Globals.emit_signal("SFX","B")
		
		if Globals.current_selected==null: #then select
			Globals.current_selected=object
			_select_current_object_anim(_tween)
		else:
			if Globals.current_selected==object: #same - deselect
				_deselect_current_object_anim(_tween)
				Globals.current_selected=null
			elif Globals.current_selected.get_class()==_obj_class: #same type - reselect
				#deselect current
				_deselect_current_object_anim(_tween)
				#select new
				Globals.current_selected=object
				_select_current_object_anim(_tween)
			elif Globals.current_selected.full_word==object.full_word:
				## right anwer - disable all(Mouse-ignore) and send a message
				for i in [object,Globals.current_selected]: #right anim
					i.mouse_filter=2
					_tween.tween_property(i,"scale",Vector2(1.0,1.0),0.6).from(Vector2(1.2,1.2))\
						.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
					_tween.tween_property(i,"modulate",Color(1,1,1,0.3),0.5).from(Color(1.2,1.2,1.2,1.0))
					_tween.tween_property(i,"rotation_degrees",0,1.2).from(-12)\
						.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
						
					i._become_right()
				
				Globals.emit_signal("ShowMessage","_right")
				
				Globals.current_selected=null
				LevelCounter-=1
				#set light
				var _light:Sprite2D=_light_nodes[LevelCounter]
				_light.texture=_light_text
				_light.material=_light_mat.duplicate()
				_light.material.set("shader_parameter/offset",LevelCounter*3)
				_tween.tween_property(Uno,"rotation_degrees",0,1.2).from(-2)\
						.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
				_tween.tween_property(Uno,"scale",Vector2(1.0,1.0),1.2)\
					.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.993,0.993))
				Globals.emit_signal("SFX","C")
				if LevelCounter==0:
					finish_level()
			else:
				_deselect_current_object_anim(_tween)
				for i in [object,Globals.current_selected]: #wrong anim
					_tween.tween_property(i,"rotation_degrees",0,0.4).from(-15)\
						.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
					pass
				Globals.current_selected=null
				
				Globals.emit_signal("ShowMessage","_wrong")
		

func _select_current_object_anim(_tween:Tween)->void:
	Globals.current_selected.modulate=Color(1.2,1.2,1.2)
	_tween.tween_property(Globals.current_selected,"scale",Vector2(1.2,1.2),0.8)\
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.96,0.96))
func _deselect_current_object_anim(_tween:Tween)->void:
	Globals.current_selected.modulate=Color(1,1,1)
	_tween.tween_property(Globals.current_selected,"scale",Vector2(1.0,1.0),0.8)\
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)






func finish_level()->void:
	Globals.emit_signal("HideMessage")
	var _tween:Tween=create_tween().set_parallel(true)
	_tween.tween_property(Hflow,"modulate:a",0,1.0)
	_tween.tween_property(Hbox,"modulate:a",0,1.0)
	
	_tween.tween_property(Uno,"position:x",0,3.5)\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(Uno,"position:y",$Uno.position.y-800,2.5)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
	_tween.tween_property(Uno,"rotation_degrees",160,2.5).set_delay(0.6)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)

	_tween.tween_property(self,"modulate:a",0,1.0).set_delay(2.0)
	_tween.tween_callback(Globals.emit_signal.bind("NextSegment")).set_delay(3.0)

	#main scene will call disappear anim after that

func disappear_anim()->void:
	queue_free()
