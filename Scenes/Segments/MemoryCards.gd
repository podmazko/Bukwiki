extends Control

var _CardNode:PackedScene=preload("res://Scenes/Parts/MemoryCard.tscn")
@onready var Center:Control=$Center
@onready var Mage:Sprite2D=$Mage

var message:=[]

var LevelCounter:int
func _init_segment(_segment_info_words:Array)->void: #[(2, 2), 0.3]
	Mage.modulate.a=0
	
	var _grid:Vector2=_segment_info_words[0]
	var _difficult:float=_segment_info_words[1]
	message=_segment_info_words[2]
	
	var _all_words:Array=Data.Words.keys()
	var _words_count:int=_grid.x*_grid.y/2
	LevelCounter=_words_count
	
	#generate words
	var _all_words_count:int=_all_words.size()
	
	var _median:int=_all_words_count*_difficult
	var _rand_power:int=_words_count*3
	
	var _n_min:int=clamp(_median-_rand_power,0,_all_words_count-1)
	var _n_max:int=clamp(_median+_rand_power,0,_all_words_count-1)
	
	var _words_ns:=[]
	while _n_min!=_n_max:
		_words_ns.append(_n_min)
		_n_min+=1
		
	_words_ns.shuffle()
	_words_ns.resize(_words_count)
	
	#generate cards
	
	for i in _words_ns:
		var _word:String=_all_words[i]
		for _copy in 2:
			var _inst:Control=_CardNode.instantiate()
			Center.add_child(_inst)

			_inst._init_memory_card(_word)
			
			_inst.mouse_entered.connect(Globals._hover_image.bind(_inst))
			_inst.mouse_exited.connect(Globals._hover_image_exit)
			_inst.gui_input.connect(object_input.bind(_inst))
			_inst.modulate.a=0
			
	var _all_cards:Array=Center.get_children()
	_all_cards.shuffle()
	#1200x1000 field
	var _card_size:Vector2=_all_cards[0].size
	var _offset:Vector2=Vector2(25,30)
	var _axis:Vector2=Vector2(0,0)  #_grid
	var _start_point:Vector2
	_start_point.x=-0.5*(_grid.x*_card_size.x+_offset.x*(_grid.x-1))
	_start_point.y=-0.5*(_grid.y*_card_size.y+_offset.y*(_grid.y-1))
	
	for _card in _all_cards:
		_card.position=_start_point+_axis*(_card_size+_offset)
		
		_axis.x+=1
		if _axis.x==_grid.x:
			_axis.x=0
			_axis.y+=1
	
	#if odd card number
	if _words_count*2<_grid.x*_grid.y:
		for i in (_grid.x-1):
			var _last_row_card:Control=_all_cards[_words_count*2-1-i]
			_last_row_card.position.x+=0.5*(_card_size.x+_offset.x)
	
	if _start_point.x<-600:
		var _f:float=-600/_start_point.x
		Center.scale=Vector2(_f,_f)



func appear_anim()->void:
	var _tween:Tween=create_tween().set_parallel(true)
	
	if message.size()>0:
		_tween.tween_callback(Globals.emit_signal.bind("ShowMessage",message[1],message[0],Vector2(0.5,0)) )\
				.set_delay(1)


	var _delay:=0.0
	for _word in Center.get_children():
		_tween.tween_property(_word,"scale",Vector2(1.0,1.0),1.3).set_delay(_delay)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.7,0.7))
		_tween.tween_property(_word,"modulate:a",1.0,0.3).set_delay(_delay)
		_tween.tween_callback(Globals.emit_signal.bind("SFX","B")).set_delay(_delay)
		_delay+=0.05
	

	_tween.tween_property(Mage,"modulate:a",1.0,1.0)
	_tween.tween_property(Mage,"position:x",Mage.position.x,2.3).from(Mage.position.x+200)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(Mage,"rotation_degrees",0,2.8).from(13)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(Mage,"scale",Vector2(1,1),2.55).from(Vector2(1.15,0.85))\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)


func object_input(event:InputEvent,object)->void:
	if event.is_pressed():
		
		Globals.emit_signal("SFX","D")
		
		if Globals.current_selected==null: #then select
			Globals.current_selected=object
			object.swap()
		else:
			if Globals.current_selected==object: #same - deselect
				object.swap()
				Globals.current_selected=null

			else:
				var _tween:Tween=create_tween().set_parallel(true)
				if Globals.current_selected.word==object.word: # right anwer
					object.swap()
					Globals.emit_signal("SFX","A")

					_tween.tween_property(Mage,"position:y",Mage.position.y,0.7).from(Mage.position.y-50)\
							.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
					_tween.tween_property(Mage,"scale",Vector2(1,1),0.8).from(Vector2(0.94,1.06))\
							.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
					_tween.tween_property(Mage,"rotation_degrees",0,0.9).from(6)\
							.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
					
					for i in [object,Globals.current_selected]: #right anim
						i.word="" #its will block InputsUnbloking
						i.mouse_filter=2
						_tween.tween_property(i,"modulate",Color(1,1,1,0.3),0.8).from(Color(1.2,1.2,1.2,1.0))
					
					Globals.current_selected=null
					LevelCounter-=1
					if LevelCounter==0:
						_tween.tween_callback(finish_level).set_delay(1.0)
				else: #wrong answer - change selection
					object.swap()
					Globals.current_selected.swap()
					#wrong anim
					_tween.tween_property(Globals.current_selected,"rotation_degrees",0,0.6).from(-15)\
							.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
					_tween.tween_property(Globals.current_selected,"modulate",Color(1,1,1,1.0),0.5).from(Color(1.5,1.0,1.0,1.0))

					Globals.current_selected=object


func finish_level()->void:
	Globals.emit_signal("HideMessage")
	var _tween:Tween=create_tween().set_parallel(true)
	
	var _delay:=0.0
	var _delay_p:=0.10
	for _word in Center.get_children():
		_tween.tween_property(_word,"scale",Vector2(1.0,1.0),1.3).set_delay(_delay)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.7,0.7))
		_tween.tween_property(_word,"modulate:a",1.0,0.3).set_delay(_delay)
		_tween.tween_callback(Globals.emit_signal.bind("SFX","B")).set_delay(_delay)
		_delay+=_delay_p
		_delay_p-=0.005

	_tween.tween_property(self,"modulate:a",0,1.0).set_delay(2.0)
	_tween.tween_callback(Globals.emit_signal.bind("NextSegment")).set_delay(3.0)

	#main scene will call disappear anim after that


func disappear_anim()->void:
	queue_free()
