extends Control
@onready var Center:Control=$Center
@onready var SideR:Control=$Center/SideR
@onready var SideL:Control=$Center/SideL
@onready var PuzzleNode:PackedScene=preload("res://Scenes/Parts/PuzzlePart.tscn")

var base_y_offset:int=-60 #to offset objects center
###### PaseParts

func _init_segment(_segment_info_words:Array)->void:
	_words_count=_segment_info_words.size()
	LavelCounter=_words_count
	
	var _between_offset:int=30
	var PuzzlePart_height:int=150
	var _place_y:int=base_y_offset-0.5*(_words_count*PuzzlePart_height+_between_offset*(_words_count-1))
	
	#init images
	var puzzle_img_n:int=1
	for word in _segment_info_words:
		var _word_info:Array=Data.Words[word]
		
		#initImages
		var _img_name:String="res://Assets/Images/Objects/"+_word_info[0]+".png"
		var _isnt:TextureRect=TextureRect.new()
		Center.add_child(_isnt)
		_isnt.mouse_filter=2
		_isnt.modulate=Color(0.2,0.2,0.2,0.10)
		_isnt.texture=load(_img_name)
		_isnt.scale=Vector2(0,0)
		_isnt.name=str(puzzle_img_n)
		_images.append(_isnt)
		
		
		#init both sides
		var _l_part_size:int=_word_info[1].size()/2
		var _l_part_n:int
		for i in _l_part_size:
			_l_part_n+=_word_info[1][i]
			
		var parts:Array=[word.left(_l_part_n),word.right(-_l_part_n)] #["СУН", "ДУК"]
		##init puzzles
		var _pzL:NinePatchRect=PuzzleNode.instantiate()
		SideL.add_child(_pzL)
		_pzL.gui_input.connect(object_input.bind(_pzL))
		_pzL.mouse_entered.connect(Globals._hover_image.bind(_pzL))
		_pzL.mouse_exited.connect(Globals._hover_image_exit)
		L_parts.append(_pzL)
		_pzL.PuzzleSize="L"
		_pzL._init_PuzzlePart(true,parts[0],"res://Assets/Images/Segments/Puzzle/L"+str(puzzle_img_n)+".png")
		_pzL.name=str(puzzle_img_n)
		
		var _pzR:NinePatchRect=PuzzleNode.instantiate()
		SideR.add_child(_pzR)
		_pzR.gui_input.connect(object_input.bind(_pzR))
		_pzR.mouse_entered.connect(Globals._hover_image.bind(_pzR))
		_pzR.mouse_exited.connect(Globals._hover_image_exit)
		R_parts.append(_pzR)
		_pzL.PuzzleSize="R"
		_pzR._init_PuzzlePart(false,parts[1],"res://Assets/Images/Segments/Puzzle/R"+str(puzzle_img_n)+".png")
		_pzR.name=str(puzzle_img_n)
		puzzle_img_n+=1#set next images
		
	L_parts.shuffle()
	R_parts.shuffle()
	for i in _words_count:
		var _pzL:NinePatchRect=L_parts[i]
		var _pzR:NinePatchRect=R_parts[i]
		
		_pzL.position=Vector2(-870,_place_y)
		_pzR.position=Vector2(-50,_place_y)
		_pzL.scale=Vector2(0,0)
		_pzR.scale=Vector2(0,0)
		
		_place_y+=PuzzlePart_height+_between_offset
		
		
var L_parts:Array
var R_parts:Array
var _images:Array=[]
var _words_count:int
func appear_anim()->void:
	var _tween:Tween=create_tween().set_parallel(true)
	
	var _y_summ:int=0 #summ of all Y fot centrilizing
	for i in _images:
		_y_summ+=i.size.y
	
	var _offset:int=16 #base offset
	var _base_y:int=base_y_offset-0.5*( _y_summ+_offset*(_words_count-1) )
	
	

	for n in _words_count:
		var _I:TextureRect=_images[n]
		var _L:NinePatchRect=L_parts[n]
		var _R:NinePatchRect=R_parts[n]
		
		_I.position.y=_base_y
		_base_y+=_I.size.y+_offset
		_I.position.x=-250-0.5*_I.size.x
		_I.pivot_offset=_I.size*Vector2(0.5,0.5)
		

		var _delay:float=n*0.15
		_tween.tween_property(_L,"scale",Vector2(1.0,1.0),1.3).set_delay(_delay)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.2,0.2))
		_tween.tween_property(_L,"position:x",_L.position.x,0.6).set_delay(_delay)\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).from(_L.position.x-400)
		_tween.tween_property(_R,"scale",Vector2(1.0,1.0),1.3).set_delay(_delay)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.2,0.2))
		_tween.tween_property(_R,"position:x",_R.position.x,0.6).set_delay(_delay)\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).from(_R.position.x+400)
		_tween.tween_property(_I,"scale",Vector2(1.0,1.0),1.3).set_delay(_delay)\
			.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).from(Vector2(0.2,0.2))
		_tween.tween_callback(Globals.emit_signal.bind("SFX","A")).set_delay(_delay)

	
	_tween.tween_callback(Globals.emit_signal.bind("ShowMessage","Как же собрать слоги\nобратно в слова?","Fear",Vector2(0.5,0)) )\
				.set_delay(1)


func finish_level()->void:
	Globals.emit_signal("HideMessage")
	var _tween:Tween=create_tween().set_parallel(true)
	_tween.tween_property(SideR,"modulate:a",0,1.0)
	_tween.tween_property(SideL,"modulate:a",0,1.0)

	var _offset:=0.8 # wait for last right answer anim finish
	for i in Center.get_children():
		if i is TextureRect:#only images
			_tween.tween_property(i,"scale",Vector2(1.15,1.15),0.8).set_delay(_offset)\
				.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			_tween.tween_property(i,"modulate",Color(1.1,1.1,1.1,1),0.5)\
				.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).set_delay(_offset)
			_tween.tween_callback(Globals.emit_signal.bind("SFX","B")).set_delay(_offset)
		
			_offset+=0.1
	
	_tween.tween_property(self,"modulate:a",0,1.0).set_delay(2.0)
	_tween.tween_callback(Globals.emit_signal.bind("NextSegment")).set_delay(3.0)

	#main scene will call disappear anim after that

func disappear_anim()->void:
	queue_free()



############
var LavelCounter:int
func object_input(event:InputEvent,object)->void:
	if event.is_pressed():
		var _tween:Tween=create_tween().set_parallel(true)
		Globals.emit_signal("SFX","B")
		
		if Globals.current_selected==null: #then select
			Globals.current_selected=object
			_select_current_object_anim(_tween)
		else:
			if Globals.current_selected==object: #same - deselect
				_deselect_current_object_anim(_tween)
				Globals.current_selected=null
			elif  Globals.current_selected.PuzzleSize==object.PuzzleSize: #same side - reselect
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
			
				var _img_node:TextureRect=Center.get_node( NodePath(object.name) )
				_tween.tween_property(_img_node,"scale",Vector2(1.0,1.0),0.6).from(Vector2(1.2,1.2))\
						.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT).set_delay(0.3)
				_tween.tween_property(_img_node,"modulate",Color(1,1,1,1.0),0.5).set_delay(0.3)
				_tween.tween_callback(Globals.emit_signal.bind("SFX","A")).set_delay(0.3)
				
				Globals.emit_signal("ShowMessage","_right")
				
				Globals.current_selected=null
				LavelCounter-=1
				if LavelCounter==0:
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
