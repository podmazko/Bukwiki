extends Control

@onready var WordsGrp:HFlowContainer=$HFlow
@onready var ImagesGrp:HFlowContainer=$HFlow2

var LevelCounter:int

func _init_segment(_segment_info_words:Array)->void:
	#prepare arrays
	var _segment_info:Array=[_segment_info_words,[]]
	var words_count:int=_segment_info[0].size()
	LevelCounter=words_count
	#set images pathes
	for i in words_count:
		_segment_info[1].append( Data.Words[_segment_info_words[i]][0])
	#shuffled n
	var _shuffled_n:Array
	for i in words_count:
		_shuffled_n.append(i)
	_shuffled_n.shuffle()

	#start generating
	var _tween:Tween=create_tween().set_parallel(true)
	for i in words_count:
		#words from shuffle
		var _inst:Button=Button.new()
		_inst.text=_segment_info[0][  _shuffled_n[i]  ]
		_inst.name=str(_shuffled_n[i])
		_inst.focus_mode=0
		WordsGrp.add_child(_inst)
		_inst.gui_input.connect(object_input.bind(_inst))
		_inst.mouse_entered.connect(Globals._hover_button.bind(_inst))
		#text appearing anim
		_inst.pivot_offset=_inst.size*Vector2(0.5,0.5)
		_inst.modulate.a=0.0
		var _delay:float=i*0.05
		_tween.tween_property(_inst,"scale",Vector2(1.0,1.0),1.3).set_delay(_delay)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.2,0.2))
		_tween.tween_property(_inst,"modulate:a",1.0,0.2).set_delay(_delay)
		
		#images from normal
		var _img:TextureRect=TextureRect.new()
		_img.texture=load("res://Assets/Images/Objects/"+_segment_info[1][i]+".png")
		ImagesGrp.add_child(_img)
		_img.stretch_mode=5
		_img.name=str(i)
		_img.gui_input.connect(object_input.bind(_img))
		_img.mouse_entered.connect(Globals._hover_image.bind(_img))
		_img.mouse_exited.connect(Globals._hover_image_exit)
		
		#images appearing anim
		_img.pivot_offset=_img.size*Vector2(0.5,0.5)
		_img.modulate.a=0.0
		_tween.tween_property(_img,"scale",Vector2(1.0,1.0),1.3).set_delay(_delay)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.4,0.4))
		_tween.tween_property(_img,"modulate:a",1.0,0.3).set_delay(_delay)
		
		_tween.tween_callback(Globals.emit_signal.bind("SFX","B")).set_delay(_delay)
		
	
func appear_anim()->void:
	var _tween:Tween=create_tween().set_parallel(true)
	_tween.tween_callback(Globals.emit_signal.bind("ShowMessage","Как много слов!\nЧто же они все означают?","Fear",Vector2(0.5,0)) )\
				.set_delay(1)


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
			elif Globals.current_selected.name==object.name:
				## right anwer - disable all(Mouse-ignore) and send a message
				for i in [object,Globals.current_selected]: #right anim
					i.mouse_filter=2
					_tween.tween_property(i,"scale",Vector2(1.0,1.0),0.6).from(Vector2(1.2,1.2))\
						.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
					_tween.tween_property(i,"modulate",Color(1,1,1,0.3),0.5).from(Color(1.2,1.2,1.2,1.0))
				
				Globals.emit_signal("SFX","A")
				
				Globals.emit_signal("ShowMessage","_right")
				
				Globals.current_selected=null
				LevelCounter-=1
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
	_tween.tween_property(WordsGrp,"modulate:a",0,1.0)
	
	var _offset:=0.8 # wait for last right answer anim finish
	for i in ImagesGrp.get_children():
		_tween.tween_property(i,"scale",Vector2(1.15,1.15),0.8).set_delay(_offset)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		_tween.tween_property(i,"modulate",Color(1.1,1.1,1.1,1),0.5).from(Color(0.5,0.5,0.5,0.3))\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).set_delay(_offset)
		_tween.tween_callback(Globals.emit_signal.bind("SFX","B")).set_delay(_offset)
		
		_offset+=0.1
	
	_tween.tween_property(self,"modulate:a",0,1.0).set_delay(2.0)
	_tween.tween_callback(Globals.emit_signal.bind("NextSegment")).set_delay(3.0)

	#main scene will call disappear anim after that

func disappear_anim()->void:
	queue_free()


###### UI Beuty

func _physics_process(delta: float) -> void:#Flow placing
	WordsGrp.size.y=0.0
	var _aimed_pos:float=WordsGrp.position.y+WordsGrp.size.y*WordsGrp.scale.y+25
	ImagesGrp.position.y=lerp(ImagesGrp.position.y,_aimed_pos,delta*3)
